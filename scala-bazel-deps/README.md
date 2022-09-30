## prepare dependencies
- Download `update_dependencies.sh` from https://github.com/johnynek/bazel-deps/releases/tag/v0.1-13
- `chmod +x update_dependencies.sh`
- modified `update_dependencies.sh` (because here's not a git toplevel)
  - from `REPO_ROOT=$(git rev-parse --show-toplevel)`
  - to `REPO_ROOT=$SCRIPT_LOCATION`
- run `update_dependencies.sh`


## build
```sh
$ bazel build //:main
```

## note

```yaml
# dependencies.yaml
options:
  # need to add this for scala support, because `scala_import` is used in the jvm/org/scalameta/BUILD
  buildHeader: [ "load(\"@io_bazel_rules_scala//scala:scala_import.bzl\", \"scala_import\")" ]
  # looks like we need to specify scala version here, otherwise, it downloads different version of binary
  languages: [ "java", "scala:2.13.8" ]
```
