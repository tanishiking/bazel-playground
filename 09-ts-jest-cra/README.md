# create-react-app
## react_scripts
`$ cat bazel-09-ts-jest-cra/external/npm/react-scripts/index.bzl`

```python
load("@build_bazel_rules_nodejs//:index.bzl", "nodejs_binary", "nodejs_test", "npm_package_bin")

# Generated helper macro to call react-scripts
def react_scripts(**kwargs):
    output_dir = kwargs.pop("output_dir", False)
    if "outs" in kwargs or output_dir:
        npm_package_bin(tool = "@npm//react-scripts/bin:react-scripts", output_dir = output_dir, **kwargs)
    else:
        nodejs_binary(
            entry_point = { "@npm//:node_modules/react-scripts": "bin/react-scripts.js" },
            data = ["@npm//react-scripts:react-scripts"] + kwargs.pop("data", []),
            **kwargs
        )

# Just in case react-scripts is a test runner, also make a test rule for it
def react_scripts_test(**kwargs):
    nodejs_test(
      entry_point = { "@npm//:node_modules/react-scripts": "bin/react-scripts.js" },
      data = ["@npm//react-scripts:react-scripts"] + kwargs.pop("data", []),
      **kwargs
    )
```

so, `react_scripts` rules receive the same arguments for [nodejs_binary](https://bazelbuild.github.io/rules_nodejs/Built-ins.html#nodejs_binary) or [npm_package_bin](https://bazelbuild.github.io/rules_nodejs/Built-ins.html#npm_package_bin).

Let's begin with

```python
# BUILD
load("@npm//react-scripts:index.bzl", "react_scripts", "react_scripts_test")

react_scripts(
    name = "build",
    args = ["build"],
)
```

and run `bazel build //...`, generates `bazel-bin/build.sh`

```sh
$ bazel-bin/build.sh
Unknown script "undefined".
Perhaps you need to update react-scripts?
See: https://facebook.github.io/create-react-app/docs/updating-to-new-releases
```

Looks like the generated script just runs `react-scripts`.

## output_dir
If we wanna write the output of `react-script` to directory, set `output_dir = True`

> set to True if you want the output to be a directory Exactly one of outs, output_dir may be used. If you output a directory, there can only be one output, which will be a directory named the same as the target.
https://bazelbuild.github.io/rules_nodejs/Built-ins.html#npm_package_bin-output_dir

```python
react_scripts(
    name = "build",
    args = ["build"],
    output_dir = True
)
```

Fail with

```
Error: Cannot find module '/private/var/tmp/_bazel_tanishiking/ce7161b25fc9f7d45b56c811d14e52a1/sandbox/darwin-sandbox/1020/execroot/ts_jest_cra/package.json'
````

## chdir

We have to run `react-scripts` on the project root (where `package.json` exists).


```
$ cd src
$ npx react-scripts build
node:internal/modules/cjs/loader:936
  throw err;
  ^

Error: Cannot find module '/Users/tanishiking/src/github.com/tanishiking/bazel-playground/09-ts-jest-cra/src/package.json'
Require stack:
...
```

- Copy all things to `bazel-out/bin` by `copy_to_bin`
- change dir at the beginning of `react_scripts` using [--require-module](https://nodejs.org/api/cli.html#-r---require-module) node option to run `chdir.js`.


```python
load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("@build_bazel_rules_nodejs//:index.bzl", "copy_to_bin")
load("@npm//react-scripts:index.bzl", "react_scripts", "react_scripts_test")

# We don't want to teach react-scripts to include from multiple directories
# So we copy everything it wants to read to the output "bin" directory
copy_to_bin(
    name = "copy_static_files",
    srcs = glob(
        [
            "public/*",
            "src/**/*",
        ],
        exclude = _TESTS, # exclude test items
    ) + [
        "package.json",
        "tsconfig.json",
    ],
)

# react-scripts can only work if the working directory is the root of the application.
# So we'll need to chdir before it runs.
write_file(
    name = "write_chdir_script",
    out = "chdir.js",
    content = ["process.chdir(__dirname)"],
)

react_scripts(
    name = "build",
    args = [
        "--node_options=--require=./$(execpath chdir.js)",
        "build",
    ],
    data = [":chdir.js", ":copy_static_files"],
    output_dir = True,
)
```

```
Module not found: Error: Can't resolve 'react-dom/client' in '/private/var/tmp/_bazel_tanishiking/ce7161b25fc9f7d45b56c811d14e52a1/sandbox/darwin-sandbox/2061/execroot/ts_jest_cra/bazel-out/darwin-fastbuild/bin/src'

Module not found: Error: Can't resolve 'web-vitals' in '/private/var/tmp/_bazel_tanishiking/ce7161b25fc9f7d45b56c811d14e52a1/sandbox/darwin-sandbox/2065/execroot/ts_jest_cra/bazel-out/darwin-fastbuild/bin/src'
```

adding runtime deps to `data` following `Module not found error`

```python
react_scripts(
    # ...
    data = [
        ":chdir.js",
        ":copy_static_files",
        "@npm//react",
        "@npm//react-dom",
        "@npm//web-vitals",
    ],
    # ...
```

type declaration is missing:

```
TS7016: Could not find a declaration file for module 'react'. '/private/var/tmp/_bazel_tanishiking/ce7161b25fc9f7d45b56c811d14e52a1/sandbox/darwin-sandbox/2100/execroot/ts_jest_cra/node_modules/react/index.js' implicitly has an 'any' type.
  Try `npm i --save-dev @types/react` if it exists or add a new declaration (.d.ts) file containing `declare module 'react';`
  > 1 | import React from 'react';
      |                   ^^^^^^^
    2 | import { render, screen } from '@testing-library/react';
    3 | import App from './App';
    4 |
```


add `"@npm//@types"` to `data`

```sh
$ bazel build //...
INFO: Analyzed 3 targets (1 packages loaded, 20 targets configured).
INFO: Found 3 targets...
INFO: From NpmPackageBin build:
Creating an optimized production build...
Compiled successfully.

File sizes after gzip:

  46.61 kB  build/static/js/main.ba4c486f.js
  1.79 kB   build/static/js/976.3056f9d2.chunk.js
  541 B     build/static/css/main.073c9b0a.css

...
INFO: Elapsed time: 20.219s, Critical Path: 19.85s
INFO: 2 processes: 1 internal, 1 darwin-sandbox.
INFO: Build completed successfully, 2 total actions

$ ls bazel-out/darwin-fastbuild/bin/build
asset-manifest.json* index.html*          logo512.png*         robots.txt*
favicon.ico*         logo192.png*         manifest.json*       static/
```

note that `name` and `BUILD_PATH` should be the same:

- `output_dir` write output to the directory whose name is target name (`build`)
- `react-scripts` write to `BUILD_PATH` dir (`build` by default)
  - https://create-react-app.dev/docs/advanced-configuration/

if they has different value, bazel create an empty dir (dir whose name is target name).


