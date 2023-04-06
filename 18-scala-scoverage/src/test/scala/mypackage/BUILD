load("//:scala.bzl", "scala_test")

scala_test(
    name = "test",
    srcs = glob(["*.scala"]),
    deps = [
        "//src/main/scala/mypackage",
        "//src/main/scala/mypackage2"
    ],
)
