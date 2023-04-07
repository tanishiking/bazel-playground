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

load("@io_bazel_rules_scala//scala:scala_toolchain.bzl", "scala_toolchain")

scala_toolchain(
    name = "diagnostics_reporter_toolchain_impl",
    enable_diagnostics_report = True,
    visibility = ["//visibility:public"],
)

toolchain(
    name = "diagnostics_reporter_toolchain",
    toolchain = "diagnostics_reporter_toolchain_impl",
    toolchain_type = "@io_bazel_rules_scala//scala:toolchain_type",
    visibility = ["//visibility:public"],
)
