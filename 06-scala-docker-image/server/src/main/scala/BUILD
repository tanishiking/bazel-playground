load("@io_bazel_rules_scala//scala:scala.bzl", "scala_binary")
load("@io_bazel_rules_docker//container:container.bzl", "container_image")
load("@io_bazel_rules_docker//docker/util:run.bzl", "container_run_and_commit")

scala_binary(
    name = "server_bin",
    main_class = "example.Main",
    srcs = glob(["*.scala"]),
)

container_image(
    name = "server_distroless",
    base = "@java_base_distroless//image",
    files = [":server_bin_deploy.jar"],
    cmd = ["server_bin_deploy.jar"]
)

container_run_and_commit(
  name = "alpine_with_bash",
  commands = ["apk add --no-cache bash"],
  image = "@java_base_11//image",
)

container_image(
    name = "server_temurin_jre",
    base = ":alpine_with_bash",
    files = [":server_bin", ":server_bin_deploy.jar"],
    cmd = ["./server_bin", "--singlejar", "--print_javabin"]
)
