load("@io_bazel_rules_scala//scala:scala.bzl", "scala_library", "scala_binary")

scala_binary(
    name = "main",
    main_class = "example.App",
    srcs = ["src/main/scala/example/App.scala"],
    deps = [
        "@third_party//3rdparty/jvm/org/scalameta:scalameta",
        "@third_party//3rdparty/jvm/com/lihaoyi:pprint",
    ],
    scalacopts = ["-Ylog-classpath"]
)
