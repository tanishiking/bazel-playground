load("@io_bazel_rules_scala//scala:scala.bzl", "scala_binary")

scala_binary(
    name = "bazel_scoverage",
    srcs = glob(["**/*.scala"]),
    main_class = "ScoverageAggregator",
    deps = [
        "@maven//:org_scoverage_scalac_scoverage_plugin_2_13_6",
        "@maven//:com_lihaoyi_os_lib_2_13",
        "@maven//:org_scala_lang_modules_scala_xml_2_13",
    ]
)
