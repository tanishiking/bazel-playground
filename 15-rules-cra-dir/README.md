
```
ERROR: /Users/tanishiking/src/github.com/tanishiking/bazel-playground/15-rules-cra-dir/app/BUILD.bazel:3:22: no such package 'app/public/lodash-4.17.21.tgz': BUILD file not found in any of the following directories. Add a BUILD file to a directory to mark it as a package.
 - /Users/tanishiking/src/github.com/tanishiking/bazel-playground/15-rules-cra-dir/app/public/lodash-4.17.21.tgz and referenced by '//app:.aspect_rules_js/node_modules/lodash@0.0.0'
ERROR: Analysis of target '//app:cra' failed; build aborted:

```

---


chdir fixes the following error!

```
$ bazel build //app:cra

...
ERROR: /Users/tanishiking/src/github.com/tanishiking/bazel-playground/15-rules-cra-dir/app/BUILD.bazel:10:22: ReactAppRewired app/build failed: (Exit 1): cra__js_binary.sh failed: error executing command bazel-out/darwin-opt-exec-2B5CBBC6/bin/app/cra__js_binary.sh build

Use --sandbox_debug to see verbose messages from the sandbox and retain the sandbox build root for debugging
node:internal/modules/cjs/loader:998
  throw err;
  ^

Error: Cannot find module '/private/var/tmp/_bazel_tanishiking/2c6a183d674e8b442742c9aea3ef12a6/sandbox/darwin-sandbox/2370/execroot/ts_jest_cra/bazel-out/darwin-fastbuild/bin/package.json'
Require stack:
- /private/var/tmp/_bazel_tanishiking/2c6a183d674e8b442742c9aea3ef12a6/sandbox/darwin-sandbox/2370/execroot/ts_jest_cra/bazel-out/darwin-fastbuild/bin/app/node_modules/.aspect_rules_js/react-app-rewired@2.2.1_react-scripts@5.0.1/node_modules/react-app-rewired/scripts/utils/paths.js
- /private/var/tmp/_bazel_tanishiking/2c6a183d674e8b442742c9aea3ef12a6/sandbox/darwin-sandbox/2370/execroot/ts_jest_cra/bazel-out/darwin-fastbuild/bin/app/node_modules/.aspect_rules_js/react-app-rewired@2.2.1_react-scripts@5.0.1/node_modules/react-app-rewired/scripts/utils/dependRequire.js
- /private/var/tmp/_bazel_tanishiking/2c6a183d674e8b442742c9aea3ef12a6/sandbox/darwin-sandbox/2370/execroot/ts_jest_cra/bazel-out/darwin-fastbuild/bin/app/node_modules/.aspect_rules_js/react-app-rewired@2.2.1_react-scripts@5.0.1/node_modules/react-app-rewired/bin/index.js
    at Function.Module._resolveFilename (node:internal/modules/cjs/loader:995:15)
    at Function.Module._load (node:internal/modules/cjs/loader:841:27)
    at Module.require (node:internal/modules/cjs/loader:1067:19)
    at require (node:internal/modules/cjs/helpers:103:18)
    at Object.<anonymous> (/private/var/tmp/_bazel_tanishiking/2c6a183d674e8b442742c9aea3ef12a6/sandbox/darwin-sandbox/2370/execroot/ts_jest_cra/bazel-out/darwin-fastbuild/bin/app/node_modules/.aspect_rules_js/react-app-rewired@2.2.1_react-scripts@5.0.1/node_modules/react-app-rewired/scripts/utils/paths.js:14:20)
    at Module._compile (node:internal/modules/cjs/loader:1165:14)
    at Object.Module._extensions..js (node:internal/modules/cjs/loader:1219:10)
    at Module.load (node:internal/modules/cjs/loader:1043:32)
    at Function.Module._load (node:internal/modules/cjs/loader:878:12)
    at Module.require (node:internal/modules/cjs/loader:1067:19) {
  code: 'MODULE_NOT_FOUND',
  requireStack: [
    '/private/var/tmp/_bazel_tanishiking/2c6a183d674e8b442742c9aea3ef12a6/sandbox/darwin-sandbox/2370/execroot/ts_jest_cra/bazel-out/darwin-fastbuild/bin/app/node_modules/.aspect_rules_js/react-app-rewired@2.2.1_react-scripts@5.0.1/node_modules/react-app-rewired/scripts/utils/paths.js',
    '/private/var/tmp/_bazel_tanishiking/2c6a183d674e8b442742c9aea3ef12a6/sandbox/darwin-sandbox/2370/execroot/ts_jest_cra/bazel-out/darwin-fastbuild/bin/app/node_modules/.aspect_rules_js/react-app-rewired@2.2.1_react-scripts@5.0.1/node_modules/react-app-rewired/scripts/utils/dependRequire.js',
    '/private/var/tmp/_bazel_tanishiking/2c6a183d674e8b442742c9aea3ef12a6/sandbox/darwin-sandbox/2370/execroot/ts_jest_cra/bazel-out/darwin-fastbuild/bin/app/node_modules/.aspect_rules_js/react-app-rewired@2.2.1_react-scripts@5.0.1/node_modules/react-app-rewired/bin/index.js'
  ]
}
Target //app:cra failed to build
```
