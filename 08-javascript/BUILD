load("@build_bazel_rules_nodejs//:index.bzl", "nodejs_binary")
load("@npm//eslint:index.bzl", "eslint_test")

nodejs_binary(
  name = "index",
  entry_point = "src/index.js",
  data = [
    "@npm//lodash",
    "src/printer.js",
    "src/int_list.js",
  ],
)

eslint_test(
  name = "lint",
  args = ["src"],
  data = [".eslintrc.json"] + glob(["src/**/*.js"])
)
