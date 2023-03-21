load("@io_bazel_rules_scala//scala:scala.bzl", "scala_test")

scala_test(
    name = "test",
    srcs = glob(["*.scala"]),
    deps = [
        "//src/main/scala/mypackage:mypackage.instrumented",
        "//src/main/scala/mypackage2:mypackage2.instrumented"
    ],
)
