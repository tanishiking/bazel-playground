## How to build image

```sh
# with scala_image
## build .tar
$ bazel build //app/src/main/scala:app

## build .tar and load it as an image to local docker
$ bazel run //app/src/main/scala:app -- --norun

$ docker run bazel/app/src/main/scala:app
Hello, World!

# with container_image


```
https://github.com/bazelbuild/rules_docker#using-with-docker-locally


what? 52 years ago?
```
bazel/app/src/main/scala                                                       app                                   53f3fa69df17   52 years ago    219MB
```
[docker image is 292 years old if build from bazel · Issue #3625 · bazelbuild/bazel](https://github.com/bazelbuild/bazel/issues/3625)

## What's inside the image built with `scala_image`?

```sh
$ docker save -o app_image.tar bazel/app/src/main/scala:app
```

```
3989900e891a3489042b7b2d865501c53feb18b76f3c77564577fcf63c743e67/
4cfa08b3b313662a2e7c27044104ad69d0b666ac4afb3f60f54319b78c4b2393/
53f3fa69df1762915062c4d41d62e63e92b7eb6a6c48611bc9e01994da8e9d7d.json
58f4b2390f4a5116b0d218a078d87dd883cb08055ba41c68773e953ceb8dc9ff/
840c3e3dd6b852facd794de5276a836aacae925bc82f0873da66a38dd4cb8105/
8558a5446611ffb882e876378f5aae069bdebdcdadb59d4283aab7e09e0838c2/
e93d331b8d35a2d1ede197fcaa50e28764c69be263252e471c54c1640e057b65/
manifest.json
repositories
```

```
$ cat manifest.json | jq
[
  {
    "Config": "53f3fa69df1762915062c4d41d62e63e92b7eb6a6c48611bc9e01994da8e9d7d.json",
    "RepoTags": [
      "bazel/app/src/main/scala:app"
    ],
    "Layers": [
      "58f4b2390f4a5116b0d218a078d87dd883cb08055ba41c68773e953ceb8dc9ff/layer.tar",
      "8558a5446611ffb882e876378f5aae069bdebdcdadb59d4283aab7e09e0838c2/layer.tar",
      "4cfa08b3b313662a2e7c27044104ad69d0b666ac4afb3f60f54319b78c4b2393/layer.tar",
      "e93d331b8d35a2d1ede197fcaa50e28764c69be263252e471c54c1640e057b65/layer.tar",
      "3989900e891a3489042b7b2d865501c53feb18b76f3c77564577fcf63c743e67/layer.tar",
      "840c3e3dd6b852facd794de5276a836aacae925bc82f0873da66a38dd4cb8105/layer.tar"
    ]
  }
]

$ tar -tf 840c3e3dd6b852facd794de5276a836aacae925bc82f0873da66a38dd4cb8105/layer.tar

./
./app/
./app/__main__/
./app/__main__/app/
./app/__main__/app/src/
./app/__main__/app/src/main/
./app/__main__/app/src/main/scala/
./app/__main__/app/src/main/scala/app.binary.jar
./app/io_bazel_rules_scala_scala_library/
./app/io_bazel_rules_scala_scala_library/scala-library-2.13.6.jar
./app/io_bazel_rules_scala_scala_reflect/
./app/io_bazel_rules_scala_scala_reflect/scala-reflect-2.13.6.jar
./app/__main__/app/src/main/scala/app.binary
./app/__main__/app/src/main/scala/app.binary_wrapper.sh
./app/__main__/app/src/main/scala/app.classpath
```

- `/app/__main__/app/src/main/scala/app.binary` is something in `bazel-bin/app/src/main/scala/app.binary`
- `/app/` is kinda same with `bazel-bin/app/src/main/scala/app.binary.runfiles/` except docker image one doesn't have `MANIFEST` and `local_jdk/`

## So, how can we build image with `container_image` instead of `scala_image`?
Looks like we don't have target something like `app.binary.runfiles`.

### Use `_deploy.jar`
`java -jar name.jar` doesn't work, it fails with, because it doesn't have runtime deps

```
❯ java -jar bazel-bin/server/src/main/scala/server_bin.jar
Error: Unable to initialize main class example.Main
Caused by: java.lang.NoClassDefFoundError: scala/Function0
```

We can use `name_deploy.jar` and run it via wrapper script with `--singlejar` option.

https://bazel.build/reference/be/java#java_binary
> name_deploy.jar: A Java archive suitable for deployment (only built if explicitly requested).
> Building the <name>_deploy.jar target for your rule creates a self-contained jar file with a manifest that allows it to be run with the java -jar command or with the wrapper script's --singlejar option. **Using the wrapper script is preferred to java -jar because it also passes the JVM flags and the options to load native libraries.**
> The deploy jar contains all the classes that would be found by a classloader that searched the classpath from the binary's wrapper script from beginning to end. It also contains the native libraries needed for dependencies. These are automatically loaded into the JVM at runtime.

```python
# WORKSPACE
container_pull(
  name = "java_base_distroless",
  registry = "gcr.io",
  repository = "distroless/java11-debian11",
  tag = "latest",
)

# BUILD
load("@io_bazel_rules_scala//scala:scala.bzl", "scala_binary")
load("@io_bazel_rules_docker//container:container.bzl", "container_image")
scala_binary(
    name = "server_bin",
    main_class = "example.Main",
    srcs = glob(["*.scala"]),
)

# it works, but running via wrapper script is recommended
container_image(
    name = "server_distroless",
    base = "@java_base_distroless//image",
    files = [":server_bin_deploy.jar"],
    cmd = ["server_bin_deploy.jar"]
)
```

The following `BUILD` should work with `_deploy.jar`

```python
# WORKSPACE
container_pull(
    name = "java_base_11",
    registry = "index.docker.io",
    repository = "library/eclipse-temurin",
    tag = "11-jre-alpine",
)

# BUILD
container_run_and_commit(
  name = "alpine_with_bash",
  commands = ["apk add --no-cache bash"],
  image = "@java_base_11//image",
)

container_image(
    name = "server_temurin_jre",
    base = ":alpine_with_bash",
    files = [":server_bin", ":server_bin_deploy.jar"],
    entrypoint = ["./server_bin --singlejar"]
)
```

but it doesn't work because `$JAVABIN` points `/__main__/server/src/main/scala/server_bin_wrapper.sh` which doesn't exist in the image, and looks like there's no way to put it to the image...

and looks like there's no way to update `JAVABIN` from outside


```sh
export REAL_EXTERNAL_JAVA_BIN=${JAVABIN};JAVABIN=${TEST_SRCDIR}/__main__/server/src/main/scala/server_bin_wrapper.sh
```
https://github.com/bazelbuild/rules_scala/blob/de3d3a772e2fd443bcd662c740f5f8e916e4b6f0/scala/private/phases/phase_write_executable.bzl#L106-L109

On the other hand, we can update `JAVA_BIN` for java_binary generated wrapper script.

```sh
# Set JAVABIN to the path to the JVM launcher.
JAVABIN=${JAVABIN:-${JAVA_RUNFILES}/local_jdk/bin/java}
```
