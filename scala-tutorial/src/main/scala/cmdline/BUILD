load("@io_bazel_rules_scala//scala:scala.bzl", "scala_binary")

scala_binary(
    name = "runner",
    srcs = ["Runner.scala"],
    main_class = "example.cmdline.Runner",
    deps = ["//:greeting"]

)
