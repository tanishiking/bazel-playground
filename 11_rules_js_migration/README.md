```
❯ bazel build //:main
INFO: Analyzed target //:main (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //:main up-to-date:
  bazel-bin/main.jar
  bazel-bin/main
INFO: Elapsed time: 0.825s, Critical Path: 0.15s
INFO: 2 processes: 1 internal, 1 worker.
INFO: Build completed successfully, 2 total actions

❯ ./bazel-bin/main
jar:file:/private/var/tmp/_bazel_tanishiking/248b328882768a29be950d9fd3b5752b/execroot/ts_jest_cra/bazel-out/darwin-fastbuild/bin/react.jar!/build/index.html
```

---

```
$ bazel build //:cra
INFO: Analyzed target //:cra (1161 packages loaded, 12814 targets configured).
INFO: Found 1 target...
Target //:cra up-to-date:
  bazel-bin/build
INFO: Elapsed time: 37.232s, Critical Path: 21.68s
INFO: 7689 processes: 5371 internal, 1 darwin-sandbox, 2317 local.
INFO: Build completed successfully, 7689 total actions

❯ ls -l bazel-bin/build
total 80
drwxr-xr-x  10 tanishiking  wheel   320 Nov  6 14:30 ./
drwxr-xr-x  50 tanishiking  wheel  1600 Nov  6 14:30 ../
-rw-r--r--   1 tanishiking  wheel   605 Nov  6 14:30 asset-manifest.json
-r-xr-xr-x   1 tanishiking  wheel  3870 Nov  6 14:30 favicon.ico*
-rw-r--r--   1 tanishiking  wheel   644 Nov  6 14:30 index.html
-r-xr-xr-x   1 tanishiking  wheel  5347 Nov  6 14:30 logo192.png*
-r-xr-xr-x   1 tanishiking  wheel  9664 Nov  6 14:30 logo512.png*
-r-xr-xr-x   1 tanishiking  wheel   492 Nov  6 14:30 manifest.json*
-r-xr-xr-x   1 tanishiking  wheel    67 Nov  6 14:30 robots.txt*
drwxr-xr-x   5 tanishiking  wheel   160 Nov  6 14:30 static/
```


---

```
❯ bazel build //:main
WARNING: /Users/tanishiking/src/github.com/tanishiking/bazel-playground/11_rules_js_migration/BUILD.bazel:41:22: target 'build' is both a rule and a file; please choose another name for the rule
INFO: Analyzed target //:main (15 packages loaded, 5204 targets configured).
INFO: Found 1 target...
INFO: From Building Java resource jar:
singlejar_local: ./src/tools/singlejar/mapped_file_posix.inc:52: bazel-out/darwin-fastbuild/bin/build is a directory: Invalid argument
Target //:main up-to-date:
  bazel-bin/main.jar
  bazel-bin/main
INFO: Elapsed time: 22.421s, Critical Path: 19.16s
INFO: 29 processes: 20 internal, 2 darwin-sandbox, 6 local, 1 worker.
INFO: Build completed successfully, 29 total actions

$ jar -tf bazel-bin/main.jar
META-INF/
META-INF/MANIFEST.MF
build/
example/
example/Main.class
```

build directory is empty!

