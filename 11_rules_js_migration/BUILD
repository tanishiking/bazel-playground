load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("@build_bazel_rules_nodejs//:index.bzl", "copy_to_bin")
# from @npm//react-scripts/bin:react-scripts
load("@npm//react-app-rewired:index.bzl", "react_app_rewired")
load("//:react_scripts_test.bzl", "react_scripts_test")

# Filename conventions described at
# https://create-react-app.dev/docs/running-tests#filename-conventions
_TESTS = [
    "src/**/*.test.js*",
    "src/**/*.test.ts*",
    "src/**/*.spec.js*",
    "src/**/*.spec.ts*",
    "src/**/__tests__/**/*.js*",
    "src/**/__tests__/**/*.ts*",
]

_RUNTIME_DEPS = [
    "chdir.js",
    "copy_static_files",
    "@npm//react",
    "@npm//react-dom",
]

# We don't want to teach react-scripts to include from multiple directories
# So we copy everything it wants to read to the output "bin" directory
copy_to_bin(
    name = "copy_static_files",
    srcs = glob(
        [
            "public/*",
            "src/**/*",
        ],
        exclude = _TESTS,
    ) + [
        "package.json",
        "tsconfig.json",
        "config-overrides.js",
    ],
)

# react-scripts can only work if the working directory is the root of the application.
# So we'll need to chdir before it runs.
write_file(
    name = "write_chdir_script",
    out = "chdir.js",
    content = ["process.chdir(__dirname)"],
)

react_app_rewired(
    # Note: If you want to change the name make sure you update BUILD_PATH below accordingly
    # https://create-react-app.dev/docs/advanced-configuration/
    name = "build",
    args = [
        "--node_options=--require=./$(execpath chdir.js)",
        "build",
    ],
    data = _RUNTIME_DEPS + [
        "@npm//web-vitals",
        "@npm//@types",
    ],
    env = {
        "BUILD_PATH": "./build",
    },
    output_dir = True,
)

copy_to_bin(
    name = "copy_test_files",
    srcs = glob(_TESTS),
)

react_scripts_test(
    name = "test",
    args = [
        "--node_options=--require=$(rootpath chdir.js)",
        "test",
        # ibazel is the watch mode for Bazel when running tests
        # Because Bazel is really a CI system that runs locally
        "--watchAll=false",
        "--no-cache",
        "--no-watchman",
        "--ci",
    ],
    srcs = [
        "copy_test_files",
    ],
    data = _RUNTIME_DEPS + [
        "@npm//@testing-library/jest-dom",
        "@npm//@testing-library/react",
        "@npm//@testing-library/user-event",
    ],
    # Need to set the pwd to avoid jest needing a runfiles helper
    # Windows users with permissions can use --enable_runfiles
    # to make this test work
    tags = ["no-bazelci-windows"],
)

react_app_rewired(
    name = "start",
    args = [
        "--node_options=--require=$(rootpath chdir.js)",
        "start",
    ],
    data = _RUNTIME_DEPS + [
        "@npm//@types/react",
        "@npm//@types/react-dom",
    ],
    tags = [
        # This tag instructs ibazel to pipe into stdin a event describing actions.
        # ibazel send EOF to stdin by default and `react-scripts start` will stop when getting EOF in stdin.
        # So use this to prevent EOF.
        "ibazel_notify_changes",
    ],
)
