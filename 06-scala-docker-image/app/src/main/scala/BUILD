load("@io_bazel_rules_docker//scala:image.bzl", "scala_image")

scala_image(
    name = "app",
    main_class = "example.Main",
    srcs = glob(["*.scala"]),
)
