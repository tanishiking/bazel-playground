load("@io_bazel_rules_scala//scala:scala.bzl", "scala_binary")

scala_binary(
    name = "main",
    main_class = "example.App",
    srcs = ["App.scala"],
    deps = [
        "@maven//:com_lihaoyi_pprint_2_13",
        "@maven//:org_scalameta_scalameta_2_13",
        "@maven//:com_typesafe_config",
    ],
    scalacopts = ["-Ylog-classpath"]
)
