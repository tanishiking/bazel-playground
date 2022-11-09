# load("@io_bazel_rules_docker//scala:image.bzl", "scala_image")
load("@io_bazel_rules_scala//scala:scala.bzl", "scala_binary")

scala_binary(
    name = "main",
    main_class = "example.Main",
    srcs = glob(["*.scala"]),
    data = ["@byteman//jar", "hello.btm"],
    jvm_flags = ["-javaagent:$(rlocation __main__/$(location @byteman//jar))=script:$(location hello.btm)"]
)
