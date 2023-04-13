load("@io_bazel_rules_scala//scala:scala.bzl", "scala_binary", "scala_library")

scala_binary(
    name = "runner",
    main_class = "cmd.Runner",
    srcs = ["Runner.scala"],
    deps = ["//lib/src/main/scala:greeting"],
)

