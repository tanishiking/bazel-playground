load("@io_bazel_rules_scala//scala:scala.bzl", "scala_binary")

scala_binary(
    name = "server",
    main_class = "example.SimpleHttpServer",
    srcs = glob(["*.scala"]),
    deps = [
        "@maven//:com_lihaoyi_pprint_2_13",
        "@maven//:org_scalameta_scalameta_2_13",
    ],
    data = [
        "@jmx_prometheus_javaagent//file",
        "//:config.yml"
    ],
    jvm_flags = [
        "-javaagent:$(rlocation jmx_prometheus_javaagent/file/jmx_prometheus_javaagent.jar)=9999:config.yml"
    ]
)
