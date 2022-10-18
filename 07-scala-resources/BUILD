load("@io_bazel_rules_scala//scala:scala.bzl", "scala_binary")

scala_binary(
    name = "main",
    main_class = "example.App",
    srcs = ["src/main/scala/example/App.scala"],
    resources = glob(["src/main/resources/*"]),
)
