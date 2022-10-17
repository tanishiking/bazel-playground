load("@io_bazel_rules_scala//scala:scala.bzl", "scala_library", "scala_binary")

scalameta_deps = [
    "@maven//:org_scalameta_scalameta_2_13",
    "@maven//:org_scala_lang_modules_scala_collection_compat_2_13",
    "@maven//:org_scalameta_trees_2_13",
    "@maven//:org_scalameta_common_2_13",
    "@maven//:org_jline_jline",
    "@maven//:com_thesamet_scalapb_lenses_2_13",
    "@maven//:org_scalameta_parsers_2_13",
    "@maven//:net_java_dev_jna_jna",
    "@maven//:org_scalameta_fastparse_v2_2_13",
    "@maven//:org_scala_lang_scala_compiler",
    "@maven//:org_scala_lang_scala_reflect",
    "@maven//:org_scala_lang_scala_library",
    "@maven//:org_scala_lang_scalap",
    "@maven//:com_lihaoyi_sourcecode_2_13",
    "@maven//:com_google_protobuf_protobuf_java",
    "@maven//:com_lihaoyi_geny_2_13",
    "@maven//:com_thesamet_scalapb_scalapb_runtime_2_13",
]

scala_binary(
    name = "main",
    main_class = "example.App",
    srcs = ["src/main/scala/example/App.scala"],
    deps = [
        "@maven//:com_lihaoyi_pprint_2_13"
        "@maven//:org_scalameta_scalameta_2_13",
    ]
    scalacopts = ["-Ylog-classpath"]
)
