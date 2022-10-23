# Basic usage of `rules_nodejs`
## specify node/yarn version

```python
# WORKSPACE
load("@build_bazel_rules_nodejs//:index.bzl", "node_repositories")
node_repositories(
    node_version = "8.11.1",
    yarn_version = "1.5.1",
)
```
Available node versions (out of the box)
https://github.com/bazelbuild/rules_nodejs/blob/36ef511575dbaf42e2628311654eaef8f648d95c/nodejs/private/node_versions.bzl

If it's not on the list:
https://github.com/bazelbuild/rules_nodejs/blob/36ef511575dbaf42e2628311654eaef8f648d95c/docs/install.md#installation-with-a-manually-specified-version-of-nodejs-and-yarn

```python
node_repositories(
  node_repositories = {
    "8.10.0-darwin_amd64": ("node-v8.10.0-darwin-x64.tar.gz", "node-v8.10.0-darwin-x64", "7d77bd35bc781f02ba7383779da30bd529f21849b86f14d87e097497671b0271"),
    "8.10.0-linux_amd64": ("node-v8.10.0-linux-x64.tar.xz", "node-v8.10.0-linux-x64", "92220638d661a43bd0fee2bf478cb283ead6524f231aabccf14c549ebc2bc338"),
    "8.10.0-windows_amd64": ("node-v8.10.0-win-x64.zip", "node-v8.10.0-win-x64", "936ada36cb6f09a5565571e15eb8006e45c5a513529c19e21d070acf0e50321b"),
  },
  yarn_repositories = {
    "1.5.1": ("yarn-v1.5.1.tar.gz", "yarn-v1.5.1", "cd31657232cf48d57fdbff55f38bfa058d2fb4950450bd34af72dac796af4de1"),
  },
  node_urls = ["https://nodejs.org/dist/v{version}/{filename}"],
  yarn_urls = ["https://github.com/yarnpkg/yarn/releases/download/v{version}/{filename}"],
```

## dependencies
### managed_directories

From bazel 5, `managed_directories` are deprecated, and rules_nodejs can't share `node_modules` between local environment and sandbox environement.
https://github.com/bazelbuild/rules_nodejs/pull/3466

```python
# Map the @npm bazel workspace to the node_modules directory.
# This lets Bazel use the same node_modules as other local tooling.
managed_directories = {"@npm": ["node_modules"]},
```

Which means `bazel build //...` no longer create `node_modules` directory in local directory (bazel downloads only in sandbox env). Therefore, in order to IDE works, you have to run `npm install` in local env to download libraries on local dir.

### multiple app
see: https://github.com/bazelbuild/rules_nodejs/blob/stable/docs/dependencies.md#multiple-sets-of-npm-dependencies

multiple `yarn_install` in `WORKSPACE`

## nodejs_binary

```python
load("@build_bazel_rules_nodejs//:index.bzl", "nodejs_binary")

nodejs_binary(
  name = "index",
  entry_point = "src/index.js",
  data = [
    "@npm//lodash",
    "src/printer.js",
    "src/int_list.js",
  ],
)
```

```sh
❯ bazel build //...
INFO: Invocation ID: 88b63d3c-4e98-46a3-a0f3-e6a0e741e2f7
INFO: Analyzed target //:index (1 packages loaded, 100 targets configured).
INFO: Found 1 target...
Target //:index up-to-date:
  dist/bin/index.sh
  dist/bin/index_require_patch.cjs
INFO: Elapsed time: 0.245s, Critical Path: 0.01s
INFO: 6 processes: 6 internal.
INFO: Build completed successfully, 6 total actions
```

## eslint
> If the foo package contains a bin entry bar, the index.bzl file will contain bar and bar_test macros. You can load these two generated rules in your BUILD file:
> load("@npm//foo:index.bzl", "bar", "bar_test")
https://bazelbuild.github.io/rules_nodejs/repositories.html#generated-macros-for-npm-packages-with-bin-entries

```sh
❯ bazel query "@npm//..." | grep "eslint/bin:"
Loading: 0 packages loaded
@npm//eslint/bin:eslint
@npm//eslint/bin:eslint_directory_file_path
Loading: 0 packages loaded
Loading: 0 packages loaded
```

```python
# BUILD
load("@npm//eslint:index.bzl", "eslint_test")

eslint_test(
  name = "lint",
  args = ["src"],
  data = [".eslintrc.json"] + glob(["src/**/*.js"])
)
```
