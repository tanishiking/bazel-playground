## Doesn't rules_jvm_external even take care of adding transitive dependencies to the classpath?

```scala
lazy val root = (project in file("."))
  .settings(
    name := "scalameta-playground",
    scalaVersion     := "2.13.8",
    version          := "0.1.0-SNAPSHOT",
    libraryDependencies += "org.scalameta" %% "scalameta" % "4.5.13",
    scalacOptions += "-Ylog-classpath"
  )
```

logged classpath

```
After java boot/extdirs classpath has 19 entries:
  ZipArchiveClassPath(/Users/tanishiking/Library/Caches/Coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala-library/2.13.8/scala-library-2.13.8.jar,None)
  ZipArchiveClassPath(/Users/tanishiking/.sbt/1.0/java9-rt-ext-azul_systems__inc__17_0_3/rt.jar,None)
  DirectoryClassPath(/Users/tanishiking/src/github.com/tanishiking/scalameta-playground/target/scala-2.13/classes)
  ZipArchiveClassPath(/Users/tanishiking/Library/Caches/Coursier/v1/https/repo1.maven.org/maven2/org/scalameta/scalameta_2.13/4.5.13/scalameta_2.13-4.5.13.jar,None)
  ZipArchiveClassPath(/Users/tanishiking/Library/Caches/Coursier/v1/https/repo1.maven.org/maven2/org/scalameta/parsers_2.13/4.5.13/parsers_2.13-4.5.13.jar,None)
  ZipArchiveClassPath(/Users/tanishiking/Library/Caches/Coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scalap/2.13.8/scalap-2.13.8.jar,None)
  ZipArchiveClassPath(/Users/tanishiking/Library/Caches/Coursier/v1/https/repo1.maven.org/maven2/org/scalameta/trees_2.13/4.5.13/trees_2.13-4.5.13.jar,None)
  ZipArchiveClassPath(/Users/tanishiking/Library/Caches/Coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala-compiler/2.13.8/scala-compiler-2.13.8.jar,None)
  ZipArchiveClassPath(/Users/tanishiking/Library/Caches/Coursier/v1/https/repo1.maven.org/maven2/org/scalameta/common_2.13/4.5.13/common_2.13-4.5.13.jar,None)
  ZipArchiveClassPath(/Users/tanishiking/Library/Caches/Coursier/v1/https/repo1.maven.org/maven2/org/scalameta/fastparse-v2_2.13/2.3.1/fastparse-v2_2.13-2.3.1.jar,None)
  ZipArchiveClassPath(/Users/tanishiking/Library/Caches/Coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala-reflect/2.13.8/scala-reflect-2.13.8.jar,None)
  ZipArchiveClassPath(/Users/tanishiking/Library/Caches/Coursier/v1/https/repo1.maven.org/maven2/org/jline/jline/3.21.0/jline-3.21.0.jar,None)
  ZipArchiveClassPath(/Users/tanishiking/Library/Caches/Coursier/v1/https/repo1.maven.org/maven2/net/java/dev/jna/jna/5.9.0/jna-5.9.0.jar,None)
  ZipArchiveClassPath(/Users/tanishiking/Library/Caches/Coursier/v1/https/repo1.maven.org/maven2/com/lihaoyi/sourcecode_2.13/0.3.0/sourcecode_2.13-0.3.0.jar,None)
  ZipArchiveClassPath(/Users/tanishiking/Library/Caches/Coursier/v1/https/repo1.maven.org/maven2/com/thesamet/scalapb/scalapb-runtime_2.13/0.11.11/scalapb-runtime_2.13-0.11.11.jar,None)
  ZipArchiveClassPath(/Users/tanishiking/Library/Caches/Coursier/v1/https/repo1.maven.org/maven2/com/lihaoyi/geny_2.13/0.6.5/geny_2.13-0.6.5.jar,None)
  ZipArchiveClassPath(/Users/tanishiking/Library/Caches/Coursier/v1/https/repo1.maven.org/maven2/com/thesamet/scalapb/lenses_2.13/0.11.11/lenses_2.13-0.11.11.jar,None)
  ZipArchiveClassPath(/Users/tanishiking/Library/Caches/Coursier/v1/https/repo1.maven.org/maven2/com/google/protobuf/protobuf-java/3.19.2/protobuf-java-3.19.2.jar,None)
  ZipArchiveClassPath(/Users/tanishiking/Library/Caches/Coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/modules/scala-collection-compat_2.13/2.7.0/scala-collection-compat_2.13-2.7.0.jar,None)
```

transitive dependencies are added to classpath

---


with bazel `rules_jvm_external`

```starlark
# WORKSPACE
# ...
load("@rules_jvm_external//:defs.bzl", "maven_install")
maven_install(
    artifacts = [
        "org.scalameta:scalameta_2.13:4.5.13",
        "com.lihaoyi:pprint_2.13:0.7.3"
    ],
    fetch_sources = True,
    repositories = [
        "https://repo1.maven.org/maven2",
    ],
)

# BUILD
load("@io_bazel_rules_scala//scala:scala.bzl", "scala_library", "scala_binary")

scala_binary(
    name = "scala-maven",
    main_class = "example.App",
    srcs = ["src/main/scala/example/App.scala"],
    deps = ["@maven//:org_scalameta_scalameta_2_13", "@maven//:com_lihaoyi_pprint_2_13"],
    scalacopts = ["-Ylog-classpath"]
)
```


```
After java boot/extdirs classpath has 4 entries:
  ZipArchiveClassPath(external/maven/v1/https/repo1.maven.org/maven2/org/scalameta/scalameta_2.13/4.5.13/scalameta_2.13-4.5.13.jar,None)
  ZipArchiveClassPath(external/maven/v1/https/repo1.maven.org/maven2/com/lihaoyi/pprint_2.13/0.7.3/pprint_2.13-0.7.3.jar,None)
  ZipArchiveClassPath(bazel-out/darwin-fastbuild/bin/external/io_bazel_rules_scala_scala_library/io_bazel_rules_scala_scala_library.stamp/scala-library-2.13.6-stamped.jar,None)
  ZipArchiveClassPath(bazel-out/darwin-fastbuild/bin/external/io_bazel_rules_scala_scala_reflect/io_bazel_rules_scala_scala_reflect.stamp/scala-reflect-2.13.6-stamped.jar,None)
```

Looks like there's no transitive dependencies in classpath
actually, build fail with

```
src/main/scala/example/App.scala:3: error: Symbol 'type scala.meta.classifiers.Api' is missing from the classpath.
This symbol is required by 'package scala.meta.package'.
Make sure that type Api is in your classpath and check for conflicting dependencies with `-Ylog-classpath`.
A full rebuild may help if 'package.class' was compiled against an incompatible version of scala.meta.classifiers.
import scala.meta._
       ^
src/main/scala/example/App.scala:9: error: value parse is not a member of String
    program.parse[Source].get
            ^
src/main/scala/example/App.scala:9: error: not found: type Source
    program.parse[Source].get
                  ^
3 errors
```

