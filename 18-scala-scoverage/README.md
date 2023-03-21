- `bazel test //...` generates scoverage data under `/tmp/scoverage-data`
- `scala-cli scripts/aggregate.sc` to aggregate the coverage data and generate an HTML report.

However, we have some troubles.

- If tests are cached, the code coverage won't be available.
  - because it doesn't aligned with Bazel way
- Twice build targets (one for uninstrumented, and one for instrumented)
