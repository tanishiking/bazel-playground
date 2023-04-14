load("@io_bazel_rules_scala//scala:scala.bzl", "scala_binary", "scala_library")

scala_library(
    name = "greeting",
    srcs = ["Greeting.scala"],
    deps = [
        "@maven//:com_lihaoyi_pprint_2_13"
    ],
    visibility = ["//cmd/src/main/scala:__pkg__"],
)
