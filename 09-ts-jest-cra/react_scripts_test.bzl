load("@npm//react-scripts:index.bzl", _react_scripts_test = "react_scripts_test")

def react_scripts_test(name, args, srcs, data, **kwargs):
    for src in srcs:
        args.extend(["--runTestsByPath", "$(location %s)" % src])

    _react_scripts_test(
        name = name,
        data = srcs + data,
        args = args,
        **kwargs
    )
