load("@npm//react-app-rewired:index.bzl", _react_app_rewired_test = "react_app_rewired_test")

def react_scripts_test(name, args, srcs, data, **kwargs):
    for src in srcs:
        args.extend(["--runTestsByPath", "$(location %s)" % src])

    _react_app_rewired_test(
        name = name,
        data = srcs + data,
        args = args,
        **kwargs
    )
