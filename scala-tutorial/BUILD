load("@io_bazel_rules_scala//scala:scala.bzl", "scala_binary", "scala_library")

scala_library(
    name = "greeting",
    srcs = ["src/main/scala/Greeting.scala"],
    deps = [],
    visibility = ["//src/main/scala/cmdline:__pkg__"],
)

scala_binary(
    name = "main",
    main_class = "example.Main",
    srcs = ["src/main/scala/Main.scala"],
    deps = [":greeting"],
)
