# Difference between `scala_library` and `scala_macro_library`

## description

> scala_library generates a .jar file from .scala source files. This rule also creates an interface jar to avoid recompiling downstream targets unless their interface changes.
https://github.com/bazelbuild/rules_scala/blob/85f85d12f225695dc7eb7a9d5928fd0a93c05b93/docs/scala_library.md?plain=1#L22-L24

> `scala_macro_library` generates a `.jar` file from `.scala` source files when
> they contain macros. For macros, there are no interface jars because the macro
> code is executed at compile time. For best performance, aim for granular (smaller)
> targets to take advantage of Bazel caching as much as possible.
https://github.com/bazelbuild/rules_scala/blob/85f85d12f225695dc7eb7a9d5928fd0a93c05b93/docs/scala_macro_library.md?plain=1#L22-L26

## What is an "interface jars"?

> In Java, by contrast, a compilation unit involves a set of .java
> source files, plus a set of .jar files containing already-compiled
> JVM .class files.  Class files serve a dual purpose: from the JVM's
> perspective, they are containers of executable code, but from the
> compiler's perspective, they are interface definitions.  The problem
> here is that .jar files are very much more sensitive to change than
> C++ header files, so even a change that is insignificant to the
> compiler (such as the addition of a print statement to a method in a
> prerequisite class) will cause the jar to change, and any code that
> depends on this jar's interface will be recompiled unnecessarily.
> The purpose of ijar is to produce, from a .jar file, a much smaller,
> simpler .jar file containing only the parts that are significant for
> the purposes of compilation.  In other words, an interface .jar
> file.  By changing ones compilation dependencies to be the interface
> jar files, unnecessary recompilation is avoided when upstream
> changes don't affect the interface.
[tools/ijar/README.txt - platform/build - Git at Google](https://android.googlesource.com/platform/build/+/c1f5d9c/tools/ijar/README.txt)

- interface jars are jar that contains only interfaces
  - > By changing ones compilation dependencies to be the interface jar files, unnecessary recompilation is avoided when upstream changes don't affect the interface.
- How it's generated for Scala?
  - using `java_commons.run_ijar`
- Why we can't use interface jar for macro?
  - because, macro code needs to be available at compile-time

## Let's see the implementation
### entrypoint
- [_scala_library_impl](https://github.com/bazelbuild/rules_scala/blob/85f85d12f225695dc7eb7a9d5928fd0a93c05b93/scala/private/rules/scala_library.bzl#L56-L74)
- [_scala_macro_library_impl](https://github.com/bazelbuild/rules_scala/blob/85f85d12f225695dc7eb7a9d5928fd0a93c05b93/scala/private/rules/scala_library.bzl#L194-L211)

```python
# _scala_library_impl
("collect_jars", phase_collect_jars_common),
("compile", phase_compile_library),

# _scala_macro_library_impl
("collect_jars", phase_collect_jars_macro_library),
("compile", phase_compile_macro_library),
```

### phase_collect_jars

```python
def phase_collect_jars_common(ctx, p):
    return _phase_collect_jars_default(ctx, p)

def phase_collect_jars_macro_library(ctx, p):
    args = struct(
        base_classpath = p.scalac_provider.default_macro_classpath,
    )
    return _phase_collect_jars_default(ctx, p, args)
```

Add macro library into classpath

define our own toolchain to locate the custom classpath
https://github.com/bazelbuild/rules_scala/blob/85f85d12f225695dc7eb7a9d5928fd0a93c05b93/docs/scala_toolchain.md?plain=1#L69-L76

### phase_compile_(macro_)library

```python
def phase_compile_library(ctx, p):
    args = struct(
        srcjars = p.collect_srcjars,
        ...
    )
    return _phase_compile_default(ctx, p, args)

def phase_compile_macro_library(ctx, p):
    args = struct(
        buildijar = False,
        ...
    )
    return _phase_compile_default(ctx, p, args)
```
https://github.com/bazelbuild/rules_scala/blob/85f85d12f225695dc7eb7a9d5928fd0a93c05b93/scala/private/phases/phase_compile.bzl#L52-L61

`buildiar = False` in `phase_compile_macro_library`.

```python
# build ijar if needed
if buildijar:
    ijar = java_common.run_ijar(
        ctx.actions,
        jar = ctx.outputs.jar,
        target_label = ctx.label,
        java_toolchain = specified_java_compile_toolchain(ctx),
    )
else:
    #  macro code needs to be available at compile-time,
    #  so set ijar == jar
    ijar = ctx.outputs.jar
```
https://github.com/bazelbuild/rules_scala/blob/85f85d12f225695dc7eb7a9d5928fd0a93c05b93/scala/private/phases/phase_compile.bzl#L214-L225

> Runs ijar on a jar, stripping it of its method bodies. This helps reduce rebuilding of dependent jars during any recompiles consisting only of simple changes to method implementations. The return value is typically passed to JavaInfo#compile_jar.
https://bazel.build/rules/lib/java_common?hl=en#run_ijar
