```sh
❯ bazel build //scala/foo
...
Target //scala/foo:foo up-to-date:
  bazel-bin/scala/foo/foo.jar
  bazel-bin/scala/foo/foo

❯ jar tf bazel-bin/scala/foo/foo.jar
META-INF/
META-INF/MANIFEST.MF
a.txt
foo/
foo/Foo$.class
foo/Foo.class

❯ bazel-bin/scala/foo/foo
I'm from a.txt under base
```

not from `foo`
