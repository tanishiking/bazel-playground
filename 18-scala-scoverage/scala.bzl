load("@io_bazel_rules_scala//scala:scala.bzl", _scala_library = "scala_library")

def scala_library(**kwargs):
    _scala_library(**kwargs)

    pkg_name = native.package_name().replace("/", "_")
    dir_name = pkg_name + kwargs["name"]

    kwargs["name"] = kwargs["name"] + ".instrumented"
    if "plugins" not in kwargs:
        kwargs["plugins"] = []
    kwargs["plugins"].append("@scalac_scoverage_plugin//jar")

    if "scalacopts" not in kwargs:
        kwargs["scalacopts"] = []
    kwargs["scalacopts"].extend([
        "-P:scoverage:dataDir:/tmp/scoverage-data/" + dir_name,
        "-P:scoverage:reportTestName",
    ])

    if "deps" not in kwargs:
        kwargs["deps"] = []
    kwargs["deps"].append("@scalac_scoverage_runtime//jar")

    _scala_library(**kwargs)
