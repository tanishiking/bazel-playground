load("@io_bazel_rules_scala//scala:scala.bzl", "scala_binary")

scala_binary(
    name = "foo",
    srcs = ["foo.scala"],
    main_class = "foo.Foo",
    deps = ["//scala/base"],
    resources = glob(["resources/**"]),
)

