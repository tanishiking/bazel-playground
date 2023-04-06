load("@io_bazel_rules_scala//scala:scala.bzl", _scala_library = "scala_library", _scala_test = "scala_test")

def scala_library(**kwargs):
    _scala_library(**kwargs)
    kwargs = _setup_scoverage(kwargs)
    _scala_library(**kwargs)

def scala_test(**kwargs):
    _scala_test(**kwargs)
    kwargs = _setup_scoverage_test(kwargs)
    _scala_test(**kwargs)

def _setup_scoverage_test(kwargs):
    def _use_instrumented(input):
        # To collect coverage information, tests have to depend on the instrumented build targets.
        # if the given input label has an instrumented version of build target, use that one.
        # Checking if there exists instrumented version of target by heuristics that the
        # - label starts with "//" (the target is defined in this repository)
        # - label contains "src/main" (the target is defined in somewhere in "src/main")
        # but this heuristics may barek in future.
        # AFAIK, there's no way to check the given label is exists in build (before analysis phase).
        if input.startswith("//") and input.find("src/main") > 0:
            label = Label(input)
            return "//{}:{}.instrumented".format(label.package, label.name)
        else:
            return input
    kwargs["name"] = kwargs["name"] + ".scoverage"

    # Do not cache test otherwise the coverage measurements won't be generated in `/tmp/scoverage-data/...`
    # see https://github.com/bazelbuild/rules_scala/issues/184#issuecomment-1484828184 for more details
    if "tags" not in kwargs:
        kwargs["tags"] = []
    kwargs["tags"].extend(["scoverage", "manual", "no-cache"])

    if "deps" not in kwargs:
        kwargs["deps"] = []
    kwargs["deps"] = [_use_instrumented(x) for x in kwargs["deps"]]

    return kwargs

def _setup_scoverage(kwargs):
    # Create an extra built target with scoverage instrumentation
    # whose name is ".instrumented" suffixed.
    # e.g. "//src/main:main" will be "//src/main:main.instrumented"
    kwargs["name"] = kwargs["name"] + ".instrumented"

    # Convert targets' label to directory name.
    # For example, "//commons/hmac-auth/src/main:main.instrumented" will be
    # commons_hmac-auth_src_main_main.instrumented
    # The coverage information from this target will be written into
    # "/tmp/scoverage-data/commons_hmac-auth_src_main_main.instrumented/"
    # by setting scalacopts "-P:scoverage:dataDir:..."
    pkg_name = native.package_name().replace("/", "_")
    dir_name = pkg_name + "_" + kwargs["name"]

    # Do not cache build otherwise the coverage information won't be created in `/tmp/scoverage-data/...`
    # see https://github.com/bazelbuild/rules_scala/issues/184#issuecomment-1484828184 for more details
    if "tags" not in kwargs:
        kwargs["tags"] = []
    kwargs["tags"].extend(["manual", "no-remote-cache"])

    if "deps" not in kwargs:
        kwargs["deps"] = []
    kwargs["deps"].append("@maven//:org_scoverage_scalac_scoverage_runtime_2_13")

    if "plugins" not in kwargs:
        kwargs["plugins"] = []
    kwargs["plugins"].append("@maven//:org_scoverage_scalac_scoverage_plugin_2_13_6")

    if "scalacopts" not in kwargs:
        kwargs["scalacopts"] = []
    kwargs["scalacopts"].extend([
      "-P:scoverage:dataDir:/tmp/scoverage-data/" + dir_name,
      "-P:scoverage:reportTestName",
    ])
    return kwargs
