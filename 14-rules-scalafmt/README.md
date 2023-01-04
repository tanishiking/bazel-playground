## Update scalafmt

Theoretically, we should be able to update scalafmt-core to `3.6.1` by setting `overriden_artifacts` in `scalamft-respositories()` for all the transitive dependencies of scalafmt-core.


```sh
❯ cs resolve org.scalameta::scalafmt-core:3.6.1
com.geirsson:metaconfig-core_2.13:0.11.1:default
com.geirsson:metaconfig-pprint_2.13:0.11.1:default
com.geirsson:metaconfig-typesafe-config_2.13:0.11.1:default
com.lihaoyi:fansi_2.13:0.3.0:default
com.lihaoyi:geny_2.13:0.6.5:default
com.lihaoyi:sourcecode_2.13:0.3.0:default
com.typesafe:config:1.4.1:default
io.github.java-diff-utils:java-diff-utils:4.12:default
net.java.dev.jna:jna:5.9.0:default
org.jline:jline:3.21.0:default
org.scala-lang:scala-compiler:2.13.9:default
org.scala-lang:scala-library:2.13.10:default
org.scala-lang:scala-reflect:2.13.10:default
org.scala-lang:scalap:2.13.9:default
org.scala-lang.modules:scala-collection-compat_2.13:2.5.0:default
org.scala-lang.modules:scala-parallel-collections_2.13:1.0.4:default
org.scalameta:common_2.13:4.6.0:default
org.scalameta:fastparse-v2_2.13:2.3.1:default
org.scalameta:parsers_2.13:4.6.0:default
org.scalameta:scalafmt-config_2.13:3.6.1:default
org.scalameta:scalafmt-core_2.13:3.6.1:default
org.scalameta:scalafmt-sysops_2.13:3.6.1:default
org.scalameta:scalameta_2.13:4.6.0:default
org.scalameta:trees_2.13:4.6.0:default
org.typelevel:paiges-core_2.13:0.4.2:default
```

like

```python
scalafmt_repositories(
  overriden_artifacts = {
    "org_scalameta_scalafmt_core": {
      "artifact": "org.scalameta:scalafmt-core_2.13:3.6.1",
      "sha256": "0e32468becb1505ba5e4797f5577c29e000af2f172d2caf8eafab99708a2dc5c",
    },
    "org_scalameta_common": {
      ...
    },
    ...
  }
)
```

This is quite time-consuming, because we have to add all artifacts' sha256 and update it everytime we bump scalafmt version.

Additionally, we cannot override scalafmt-core to v3, because `rules_scala` depends on `scalafmt-core`'s old API and if we update to v3, it doesn't compile.

We can fix `rules_scala`, so it compiles with the lates version of scalafmt-core, but then it might not work for scalafmt v2.


```sh
> bazel build //...
...
error: error while loading Error, class file 'bazel-out/darwin-opt-exec-2B5CBBC6/bin/external/org_scalameta_scalafmt_core/org_scalameta_scalafmt_core.stamp/scalafmt-core_2.13-3.6.1-stamped.jar(org/scalafmt/Error.class)' is broken
(class java.lang.RuntimeException/error reading Scala signature of Error.class: Scala signature Error has wrong version
 expected: 5.0
 found: 5.2 in Error.class)
external/io_bazel_rules_scala/scala/scalafmt/scalafmt/ScalafmtWorker.scala:33: warning: fruitless type test: a value of type Throwable cannot also be a org.scalafmt.Error
      case e @ (_: org.scalafmt.Error | _: scala.meta.parsers.ParseException) => {
                                ^
one warning found
6 errors found
Build failed
java.lang.RuntimeException: Build failed
        at io.bazel.rulesscala.scalac.ScalacWorker.compileScalaSources(ScalacWorker.java:290)
        at io.bazel.rulesscala.scalac.ScalacWorker.work(ScalacWorker.java:61)
        at io.bazel.rulesscala.worker.Worker.persistentWorkerMain(Worker.java:86)
        at io.bazel.rulesscala.worker.Worker.workerMain(Worker.java:39)
        at io.bazel.rulesscala.scalac.ScalacWorker.main(ScalacWorker.java:25)
Target //example:example failed to build
Use --verbose_failures to see the command lines of failed build steps.
INFO: Elapsed time: 15.339s, Critical Path: 0.77s
INFO: 7 processes: 6 internal, 1 darwin-sandbox.
FAILED: Build did NOT complete successfully
```


<details>

```sh
❯ bazel build //...
INFO: Invocation ID: b6cc5d39-ca68-4a75-b04e-8fbd9fed8aa0
INFO: Analyzed target //example:example (42 packages loaded, 379 targets configured).
INFO: Found 1 target...
ERROR: /private/var/tmp/_bazel_tanishiking/927b28a204db9383d74c92a5d0e0416f/external/io_bazel_rules_scala/scala/scalafmt/BUILD:21:13: scala @io_bazel_rules_scala//scala/scalafmt:scalafmt [for tool] failed: (Exit 1): scalac failed: error executing command (from target @io_bazel_rules_scala//scala/scalafmt:scalafmt) bazel-out/darwin-opt-exec-2B5CBBC6/bin/external/io_bazel_rules_scala/src/java/io/bazel/rulesscala/scalac/scalac ... (remaining 1 argument skipped)
java.io.IOException: Scala signature package has wrong version
 expected: 5.0
 found: 5.2 in package.class
        at scala.reflect.internal.pickling.UnPickler$Scan.checkVersion(UnPickler.scala:122)
        at scala.reflect.internal.pickling.UnPickler$Scan.<init>(UnPickler.scala:64)
        at scala.reflect.internal.pickling.UnPickler.unpickle(UnPickler.scala:47)
        at scala.tools.nsc.symtab.classfile.ClassfileParser.unpickleOrParseInnerClasses(ClassfileParser.scala:1186)
        at scala.tools.nsc.symtab.classfile.ClassfileParser.parseClass(ClassfileParser.scala:468)
        at scala.tools.nsc.symtab.classfile.ClassfileParser.$anonfun$parse$2(ClassfileParser.scala:161)
        at scala.tools.nsc.symtab.classfile.ClassfileParser.$anonfun$parse$1(ClassfileParser.scala:147)
        at scala.tools.nsc.symtab.classfile.ClassfileParser.parse(ClassfileParser.scala:130)
        at scala.tools.nsc.symtab.SymbolLoaders$ClassfileLoader.doComplete(SymbolLoaders.scala:343)
        at scala.tools.nsc.symtab.SymbolLoaders$SymbolLoader.complete(SymbolLoaders.scala:250)
        at scala.reflect.internal.Symbols$Symbol.completeInfo(Symbols.scala:1542)
        at scala.reflect.internal.Symbols$Symbol.info(Symbols.scala:1514)
        at scala.reflect.internal.SymbolTable.openPackageModule(SymbolTable.scala:356)
        at scala.reflect.internal.SymbolTable.openPackageModule(SymbolTable.scala:411)
        at scala.tools.nsc.symtab.SymbolLoaders$PackageLoader.doComplete(SymbolLoaders.scala:313)
        at scala.tools.nsc.symtab.SymbolLoaders$SymbolLoader.complete(SymbolLoaders.scala:250)
        at scala.tools.nsc.symtab.SymbolLoaders$SymbolLoader.load(SymbolLoaders.scala:269)
        at scala.reflect.internal.Symbols$Symbol.$anonfun$typeParams$1(Symbols.scala:1772)
        at scala.reflect.internal.Symbols$Symbol.completeTypeParams$1(Symbols.scala:1772)
        at scala.reflect.internal.Symbols$Symbol.typeParams(Symbols.scala:1779)
        at scala.reflect.internal.Types.isRawIfWithoutArgs(Types.scala:3930)
        at scala.reflect.internal.Types.isRawIfWithoutArgs$(Types.scala:3930)
        at scala.reflect.internal.SymbolTable.isRawIfWithoutArgs(SymbolTable.scala:28)
        at scala.reflect.internal.tpe.TypeMaps$$anon$1.apply(TypeMaps.scala:356)
        at scala.reflect.internal.tpe.TypeMaps$$anon$1.apply(TypeMaps.scala:353)
        at scala.reflect.internal.Symbols$Symbol.modifyInfo(Symbols.scala:1572)
        at scala.reflect.internal.Symbols$Symbol.cookJavaRawInfo(Symbols.scala:1727)
        at scala.tools.nsc.typechecker.Infer$Inferencer.checkAccessible(Infer.scala:280)
        at scala.tools.nsc.typechecker.Typers$Typer.makeAccessible(Typers.scala:593)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typed1$59(Typers.scala:5137)
        at scala.tools.nsc.typechecker.Typers$Typer.silent(Typers.scala:713)
        at scala.tools.nsc.typechecker.Typers$Typer.typedSelect$1(Typers.scala:5137)
        at scala.tools.nsc.typechecker.Typers$Typer.typedSelectOrSuperCall$1(Typers.scala:5197)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5737)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Namers$Namer.scala$tools$nsc$typechecker$Namers$Namer$$importSig(Namers.scala:1809)
        at scala.tools.nsc.typechecker.Namers$Namer$ImportTypeCompleter.completeImpl(Namers.scala:913)
        at scala.tools.nsc.typechecker.Namers$LockingTypeCompleter.complete(Namers.scala:2082)
        at scala.tools.nsc.typechecker.Namers$LockingTypeCompleter.complete$(Namers.scala:2080)
        at scala.tools.nsc.typechecker.Namers$TypeCompleterBase.complete(Namers.scala:2075)
        at scala.reflect.internal.Symbols$Symbol.completeInfo(Symbols.scala:1542)
        at scala.reflect.internal.Symbols$Symbol.info(Symbols.scala:1514)
        at scala.reflect.internal.Symbols$Symbol.initialize(Symbols.scala:1698)
        at scala.tools.nsc.typechecker.Typers$Typer.typedStat$1(Typers.scala:3188)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typedStats$10(Typers.scala:3337)
        at scala.tools.nsc.typechecker.Typers$Typer.typedStats(Typers.scala:3337)
        at scala.tools.nsc.typechecker.Typers$Typer.typedPackageDef$1(Typers.scala:5413)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5705)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Analyzer$typerFactory$TyperPhase.apply(Analyzer.scala:114)
        at scala.tools.nsc.Global$GlobalPhase.applyPhase(Global.scala:453)
        at scala.tools.nsc.typechecker.Analyzer$typerFactory$TyperPhase.run(Analyzer.scala:102)
        at scala.tools.nsc.Global$Run.compileUnitsInternal(Global.scala:1514)
        at scala.tools.nsc.Global$Run.compileUnits(Global.scala:1498)
        at scala.tools.nsc.Global$Run.compileSources(Global.scala:1491)
        at scala.tools.nsc.Global$Run.compile(Global.scala:1620)
        at scala.tools.nsc.Driver.doCompile(Driver.scala:47)
        at scala.tools.nsc.MainClass.doCompile(Main.scala:32)
        at scala.tools.nsc.Driver.process(Driver.scala:67)
        at io.bazel.rulesscala.scalac.ScalacWorker.compileScalaSources(ScalacWorker.java:257)
        at io.bazel.rulesscala.scalac.ScalacWorker.work(ScalacWorker.java:61)
        at io.bazel.rulesscala.worker.Worker.persistentWorkerMain(Worker.java:86)
        at io.bazel.rulesscala.worker.Worker.workerMain(Worker.java:39)
        at io.bazel.rulesscala.scalac.ScalacWorker.main(ScalacWorker.java:25)
error: error while loading package, class file 'bazel-out/darwin-opt-exec-2B5CBBC6/bin/external/org_scalameta_scalafmt_core/org_scalameta_scalafmt_core.stamp/scalafmt-core_2.13-3.6.1-stamped.jar(org/scalafmt/config/package.class)' is broken
(class java.lang.RuntimeException/error reading Scala signature of package.class: Scala signature package has wrong version
 expected: 5.0
 found: 5.2 in package.class)
external/io_bazel_rules_scala/scala/scalafmt/scalafmt/ScalafmtWorker.scala:8: error: object FileOps is not a member of package org.scalafmt.util
import org.scalafmt.util.FileOps
       ^
external/io_bazel_rules_scala/scala/scalafmt/scalafmt/ScalafmtWorker.scala:21: error: not found: value FileOps
    val source = FileOps.readFile(namespace.getOrElse("input", new File("")))(Codec.UTF8)
                 ^
java.io.IOException: Scala signature Config has wrong version
 expected: 5.0
 found: 5.2 in Config.class
        at scala.reflect.internal.pickling.UnPickler$Scan.checkVersion(UnPickler.scala:122)
        at scala.reflect.internal.pickling.UnPickler$Scan.<init>(UnPickler.scala:64)
        at scala.reflect.internal.pickling.UnPickler.unpickle(UnPickler.scala:47)
        at scala.tools.nsc.symtab.classfile.ClassfileParser.unpickleOrParseInnerClasses(ClassfileParser.scala:1186)
        at scala.tools.nsc.symtab.classfile.ClassfileParser.parseClass(ClassfileParser.scala:468)
        at scala.tools.nsc.symtab.classfile.ClassfileParser.$anonfun$parse$2(ClassfileParser.scala:161)
        at scala.tools.nsc.symtab.classfile.ClassfileParser.$anonfun$parse$1(ClassfileParser.scala:147)
        at scala.tools.nsc.symtab.classfile.ClassfileParser.parse(ClassfileParser.scala:130)
        at scala.tools.nsc.symtab.SymbolLoaders$ClassfileLoader.doComplete(SymbolLoaders.scala:343)
        at scala.tools.nsc.symtab.SymbolLoaders$SymbolLoader.complete(SymbolLoaders.scala:250)
        at scala.tools.nsc.symtab.SymbolLoaders$SymbolLoader.load(SymbolLoaders.scala:269)
        at scala.tools.nsc.typechecker.Typers$Typer.isStale(Typers.scala:526)
        at scala.tools.nsc.typechecker.Typers$Typer.reallyExists(Typers.scala:517)
        at scala.tools.nsc.typechecker.Typers$Typer.qualifies$1(Typers.scala:5220)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typed1$66(Typers.scala:5251)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typed1$66$adapted(Typers.scala:5251)
        at scala.reflect.internal.Symbols$Symbol.filter(Symbols.scala:2004)
        at scala.tools.nsc.typechecker.Contexts$SymbolLookup.apply(Contexts.scala:1247)
        at scala.tools.nsc.typechecker.Contexts$Context.$anonfun$lookupSymbol$1(Contexts.scala:1051)
        at scala.tools.nsc.typechecker.Contexts$Context.lookupSymbol(Contexts.scala:1051)
        at scala.tools.nsc.typechecker.Typers$Typer.typedIdent$2(Typers.scala:5251)
        at scala.tools.nsc.typechecker.Typers$Typer.typedIdentOrWildcard$1(Typers.scala:5301)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5734)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.typedSelectOrSuperCall$1(Typers.scala:5865)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5737)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typed1$39(Typers.scala:4891)
        at scala.tools.nsc.typechecker.Typers$Typer.silent(Typers.scala:713)
        at scala.tools.nsc.typechecker.Typers$Typer.normalTypedApply$1(Typers.scala:4893)
        at scala.tools.nsc.typechecker.Typers$Typer.typedApply$1(Typers.scala:4921)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5736)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.typedSelectOrSuperCall$1(Typers.scala:5865)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5737)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.computeType(Typers.scala:5856)
        at scala.tools.nsc.typechecker.Namers$Namer.assignTypeToTree(Namers.scala:1114)
        at scala.tools.nsc.typechecker.Namers$Namer.valDefSig(Namers.scala:1733)
        at scala.tools.nsc.typechecker.Namers$Namer.memberSig(Namers.scala:1919)
        at scala.tools.nsc.typechecker.Namers$Namer.typeSig(Namers.scala:1870)
        at scala.tools.nsc.typechecker.Namers$Namer$MonoTypeCompleter.completeImpl(Namers.scala:877)
        at scala.tools.nsc.typechecker.Namers$LockingTypeCompleter.complete(Namers.scala:2082)
        at scala.tools.nsc.typechecker.Namers$LockingTypeCompleter.complete$(Namers.scala:2080)
        at scala.tools.nsc.typechecker.Namers$TypeCompleterBase.complete(Namers.scala:2075)
        at scala.reflect.internal.Symbols$Symbol.completeInfo(Symbols.scala:1542)
        at scala.reflect.internal.Symbols$Symbol.info(Symbols.scala:1514)
        at scala.reflect.internal.Symbols$Symbol.initialize(Symbols.scala:1698)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5406)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.typedStat$1(Typers.scala:5845)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typedStats$10(Typers.scala:3337)
        at scala.tools.nsc.typechecker.Typers$Typer.typedStats(Typers.scala:3337)
        at scala.tools.nsc.typechecker.Typers$Typer.typedBlock(Typers.scala:2497)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typed1$103(Typers.scala:5711)
        at scala.tools.nsc.typechecker.Typers$Typer.typedOutsidePatternMode$1(Typers.scala:500)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5746)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.typedDefDef(Typers.scala:5997)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5701)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.typedStat$1(Typers.scala:5845)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typedStats$10(Typers.scala:3337)
        at scala.tools.nsc.typechecker.Typers$Typer.typedStats(Typers.scala:3337)
        at scala.tools.nsc.typechecker.Typers$Typer.typedTemplate(Typers.scala:2019)
        at scala.tools.nsc.typechecker.Typers$Typer.typedModuleDef(Typers.scala:1885)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5703)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.typedStat$1(Typers.scala:5845)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typedStats$10(Typers.scala:3337)
        at scala.tools.nsc.typechecker.Typers$Typer.typedStats(Typers.scala:3337)
        at scala.tools.nsc.typechecker.Typers$Typer.typedPackageDef$1(Typers.scala:5413)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5705)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Analyzer$typerFactory$TyperPhase.apply(Analyzer.scala:114)
        at scala.tools.nsc.Global$GlobalPhase.applyPhase(Global.scala:453)
        at scala.tools.nsc.typechecker.Analyzer$typerFactory$TyperPhase.run(Analyzer.scala:102)
        at scala.tools.nsc.Global$Run.compileUnitsInternal(Global.scala:1514)
        at scala.tools.nsc.Global$Run.compileUnits(Global.scala:1498)
        at scala.tools.nsc.Global$Run.compileSources(Global.scala:1491)
        at scala.tools.nsc.Global$Run.compile(Global.scala:1620)
        at scala.tools.nsc.Driver.doCompile(Driver.scala:47)
        at scala.tools.nsc.MainClass.doCompile(Main.scala:32)
        at scala.tools.nsc.Driver.process(Driver.scala:67)
        at io.bazel.rulesscala.scalac.ScalacWorker.compileScalaSources(ScalacWorker.java:257)
        at io.bazel.rulesscala.scalac.ScalacWorker.work(ScalacWorker.java:61)
        at io.bazel.rulesscala.worker.Worker.persistentWorkerMain(Worker.java:86)
        at io.bazel.rulesscala.worker.Worker.workerMain(Worker.java:39)
        at io.bazel.rulesscala.scalac.ScalacWorker.main(ScalacWorker.java:25)
error: error while loading Config, class file 'bazel-out/darwin-opt-exec-2B5CBBC6/bin/external/org_scalameta_scalafmt_core/org_scalameta_scalafmt_core.stamp/scalafmt-core_2.13-3.6.1-stamped.jar(org/scalafmt/config/Config.class)' is broken
(class java.lang.RuntimeException/error reading Scala signature of Config.class: Scala signature Config has wrong version
 expected: 5.0
 found: 5.2 in Config.class)
java.io.IOException: Scala signature Scalafmt has wrong version
 expected: 5.0
 found: 5.2 in Scalafmt.class
        at scala.reflect.internal.pickling.UnPickler$Scan.checkVersion(UnPickler.scala:122)
        at scala.reflect.internal.pickling.UnPickler$Scan.<init>(UnPickler.scala:64)
        at scala.reflect.internal.pickling.UnPickler.unpickle(UnPickler.scala:47)
        at scala.tools.nsc.symtab.classfile.ClassfileParser.unpickleOrParseInnerClasses(ClassfileParser.scala:1186)
        at scala.tools.nsc.symtab.classfile.ClassfileParser.parseClass(ClassfileParser.scala:468)
        at scala.tools.nsc.symtab.classfile.ClassfileParser.$anonfun$parse$2(ClassfileParser.scala:161)
        at scala.tools.nsc.symtab.classfile.ClassfileParser.$anonfun$parse$1(ClassfileParser.scala:147)
        at scala.tools.nsc.symtab.classfile.ClassfileParser.parse(ClassfileParser.scala:130)
        at scala.tools.nsc.symtab.SymbolLoaders$ClassfileLoader.doComplete(SymbolLoaders.scala:343)
        at scala.tools.nsc.symtab.SymbolLoaders$SymbolLoader.complete(SymbolLoaders.scala:250)
        at scala.tools.nsc.symtab.SymbolLoaders$SymbolLoader.load(SymbolLoaders.scala:269)
        at scala.tools.nsc.typechecker.Typers$Typer.isStale(Typers.scala:526)
        at scala.tools.nsc.typechecker.Typers$Typer.reallyExists(Typers.scala:517)
        at scala.tools.nsc.typechecker.Typers$Typer.qualifies$1(Typers.scala:5220)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typed1$66(Typers.scala:5251)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typed1$66$adapted(Typers.scala:5251)
        at scala.reflect.internal.Symbols$Symbol.filter(Symbols.scala:2004)
        at scala.tools.nsc.typechecker.Contexts$SymbolLookup.apply(Contexts.scala:1247)
        at scala.tools.nsc.typechecker.Contexts$Context.$anonfun$lookupSymbol$1(Contexts.scala:1051)
        at scala.tools.nsc.typechecker.Contexts$Context.lookupSymbol(Contexts.scala:1051)
        at scala.tools.nsc.typechecker.Typers$Typer.typedIdent$2(Typers.scala:5251)
        at scala.tools.nsc.typechecker.Typers$Typer.typedIdentOrWildcard$1(Typers.scala:5301)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5734)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.typedSelectOrSuperCall$1(Typers.scala:5865)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5737)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typed1$39(Typers.scala:4891)
        at scala.tools.nsc.typechecker.Typers$Typer.silent(Typers.scala:713)
        at scala.tools.nsc.typechecker.Typers$Typer.normalTypedApply$1(Typers.scala:4893)
        at scala.tools.nsc.typechecker.Typers$Typer.typedApply$1(Typers.scala:4921)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5736)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.typedSelectOrSuperCall$1(Typers.scala:5865)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5737)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.computeType(Typers.scala:5856)
        at scala.tools.nsc.typechecker.Namers$Namer.assignTypeToTree(Namers.scala:1114)
        at scala.tools.nsc.typechecker.Namers$Namer.valDefSig(Namers.scala:1733)
        at scala.tools.nsc.typechecker.Namers$Namer.memberSig(Namers.scala:1919)
        at scala.tools.nsc.typechecker.Namers$Namer.typeSig(Namers.scala:1870)
        at scala.tools.nsc.typechecker.Namers$Namer$MonoTypeCompleter.completeImpl(Namers.scala:877)
        at scala.tools.nsc.typechecker.Namers$LockingTypeCompleter.complete(Namers.scala:2082)
        at scala.tools.nsc.typechecker.Namers$LockingTypeCompleter.complete$(Namers.scala:2080)
        at scala.tools.nsc.typechecker.Namers$TypeCompleterBase.complete(Namers.scala:2075)
        at scala.reflect.internal.Symbols$Symbol.completeInfo(Symbols.scala:1542)
        at scala.reflect.internal.Symbols$Symbol.info(Symbols.scala:1514)
        at scala.reflect.internal.Symbols$Symbol.initialize(Symbols.scala:1698)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5406)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.typedStat$1(Typers.scala:5845)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typedStats$10(Typers.scala:3337)
        at scala.tools.nsc.typechecker.Typers$Typer.typedStats(Typers.scala:3337)
        at scala.tools.nsc.typechecker.Typers$Typer.typedBlock(Typers.scala:2497)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typed1$103(Typers.scala:5711)
        at scala.tools.nsc.typechecker.Typers$Typer.typedOutsidePatternMode$1(Typers.scala:500)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5746)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.typedDefDef(Typers.scala:5997)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5701)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.typedStat$1(Typers.scala:5845)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typedStats$10(Typers.scala:3337)
        at scala.tools.nsc.typechecker.Typers$Typer.typedStats(Typers.scala:3337)
        at scala.tools.nsc.typechecker.Typers$Typer.typedBlock(Typers.scala:2497)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typed1$103(Typers.scala:5711)
        at scala.tools.nsc.typechecker.Typers$Typer.typedOutsidePatternMode$1(Typers.scala:500)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5746)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.typedDefDef(Typers.scala:5997)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5701)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.typedStat$1(Typers.scala:5845)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typedStats$10(Typers.scala:3337)
        at scala.tools.nsc.typechecker.Typers$Typer.typedStats(Typers.scala:3337)
        at scala.tools.nsc.typechecker.Typers$Typer.typedTemplate(Typers.scala:2019)
        at scala.tools.nsc.typechecker.Typers$Typer.typedModuleDef(Typers.scala:1885)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5703)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.typedStat$1(Typers.scala:5845)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typedStats$10(Typers.scala:3337)
        at scala.tools.nsc.typechecker.Typers$Typer.typedStats(Typers.scala:3337)
        at scala.tools.nsc.typechecker.Typers$Typer.typedPackageDef$1(Typers.scala:5413)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5705)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Analyzer$typerFactory$TyperPhase.apply(Analyzer.scala:114)
        at scala.tools.nsc.Global$GlobalPhase.applyPhase(Global.scala:453)
        at scala.tools.nsc.typechecker.Analyzer$typerFactory$TyperPhase.run(Analyzer.scala:102)
        at scala.tools.nsc.Global$Run.compileUnitsInternal(Global.scala:1514)
        at scala.tools.nsc.Global$Run.compileUnits(Global.scala:1498)
        at scala.tools.nsc.Global$Run.compileSources(Global.scala:1491)
        at scala.tools.nsc.Global$Run.compile(Global.scala:1620)
        at scala.tools.nsc.Driver.doCompile(Driver.scala:47)
        at scala.tools.nsc.MainClass.doCompile(Main.scala:32)
        at scala.tools.nsc.Driver.process(Driver.scala:67)
        at io.bazel.rulesscala.scalac.ScalacWorker.compileScalaSources(ScalacWorker.java:257)
        at io.bazel.rulesscala.scalac.ScalacWorker.work(ScalacWorker.java:61)
        at io.bazel.rulesscala.worker.Worker.persistentWorkerMain(Worker.java:86)
        at io.bazel.rulesscala.worker.Worker.workerMain(Worker.java:39)
        at io.bazel.rulesscala.scalac.ScalacWorker.main(ScalacWorker.java:25)
error: error while loading Scalafmt, class file 'bazel-out/darwin-opt-exec-2B5CBBC6/bin/external/org_scalameta_scalafmt_core/org_scalameta_scalafmt_core.stamp/scalafmt-core_2.13-3.6.1-stamped.jar(org/scalafmt/Scalafmt.class)' is broken
(class java.lang.RuntimeException/error reading Scala signature of Scalafmt.class: Scala signature Scalafmt has wrong version
 expected: 5.0
 found: 5.2 in Scalafmt.class)
java.io.IOException: Scala signature Error has wrong version
 expected: 5.0
 found: 5.2 in Error.class
        at scala.reflect.internal.pickling.UnPickler$Scan.checkVersion(UnPickler.scala:122)
        at scala.reflect.internal.pickling.UnPickler$Scan.<init>(UnPickler.scala:64)
        at scala.reflect.internal.pickling.UnPickler.unpickle(UnPickler.scala:47)
        at scala.tools.nsc.symtab.classfile.ClassfileParser.unpickleOrParseInnerClasses(ClassfileParser.scala:1186)
        at scala.tools.nsc.symtab.classfile.ClassfileParser.parseClass(ClassfileParser.scala:468)
        at scala.tools.nsc.symtab.classfile.ClassfileParser.$anonfun$parse$2(ClassfileParser.scala:161)
        at scala.tools.nsc.symtab.classfile.ClassfileParser.$anonfun$parse$1(ClassfileParser.scala:147)
        at scala.tools.nsc.symtab.classfile.ClassfileParser.parse(ClassfileParser.scala:130)
        at scala.tools.nsc.symtab.SymbolLoaders$ClassfileLoader.doComplete(SymbolLoaders.scala:343)
        at scala.tools.nsc.symtab.SymbolLoaders$SymbolLoader.complete(SymbolLoaders.scala:250)
        at scala.tools.nsc.symtab.SymbolLoaders$SymbolLoader.load(SymbolLoaders.scala:269)
        at scala.tools.nsc.typechecker.Typers$Typer.isStale(Typers.scala:526)
        at scala.tools.nsc.typechecker.Typers$Typer.reallyExists(Typers.scala:517)
        at scala.tools.nsc.typechecker.Typers$Typer.typedSelect$1(Typers.scala:5096)
        at scala.tools.nsc.typechecker.Typers$Typer.typedSelectOrSuperCall$1(Typers.scala:5193)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5737)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.typedType(Typers.scala:5907)
        at scala.tools.nsc.typechecker.PatternTypers$PatternTyper.typedInPattern(PatternTypers.scala:160)
        at scala.tools.nsc.typechecker.PatternTypers$PatternTyper.typedInPattern$(PatternTypers.scala:158)
        at scala.tools.nsc.typechecker.Typers$Typer.typedInPattern(Typers.scala:202)
        at scala.tools.nsc.typechecker.Typers$Typer.typedTyped$1(Typers.scala:5492)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5739)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typed1$82(Typers.scala:5429)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typed1$81(Typers.scala:5429)
        at scala.tools.nsc.typechecker.Typers$Typer.typedAlternative$1(Typers.scala:5429)
        at scala.tools.nsc.typechecker.Typers$Typer.typedInPatternMode$1(Typers.scala:5682)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5744)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.typedBind$1(Typers.scala:4488)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5735)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typedPattern$2(Typers.scala:5902)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typedPattern$1(Typers.scala:5902)
        at scala.tools.nsc.typechecker.TypeDiagnostics.typingInPattern(TypeDiagnostics.scala:71)
        at scala.tools.nsc.typechecker.TypeDiagnostics.typingInPattern$(TypeDiagnostics.scala:68)
        at scala.tools.nsc.Global$$anon$5.typingInPattern(Global.scala:482)
        at scala.tools.nsc.typechecker.Typers$Typer.typedPattern(Typers.scala:5902)
        at scala.tools.nsc.typechecker.Typers$Typer.typedCase(Typers.scala:2516)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typedCases$1(Typers.scala:2550)
        at scala.tools.nsc.typechecker.Typers$Typer.typedCases(Typers.scala:2549)
        at scala.tools.nsc.typechecker.Typers$Typer.typedTry$1(Typers.scala:5464)
        at scala.tools.nsc.typechecker.Typers$Typer.typedOutsidePatternMode$1(Typers.scala:5722)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5746)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.computeType(Typers.scala:5856)
        at scala.tools.nsc.typechecker.Namers$Namer.assignTypeToTree(Namers.scala:1114)
        at scala.tools.nsc.typechecker.Namers$Namer.valDefSig(Namers.scala:1733)
        at scala.tools.nsc.typechecker.Namers$Namer.memberSig(Namers.scala:1919)
        at scala.tools.nsc.typechecker.Namers$Namer.typeSig(Namers.scala:1870)
        at scala.tools.nsc.typechecker.Namers$Namer$MonoTypeCompleter.completeImpl(Namers.scala:877)
        at scala.tools.nsc.typechecker.Namers$LockingTypeCompleter.complete(Namers.scala:2082)
        at scala.tools.nsc.typechecker.Namers$LockingTypeCompleter.complete$(Namers.scala:2080)
        at scala.tools.nsc.typechecker.Namers$TypeCompleterBase.complete(Namers.scala:2075)
        at scala.reflect.internal.Symbols$Symbol.completeInfo(Symbols.scala:1542)
        at scala.reflect.internal.Symbols$Symbol.info(Symbols.scala:1514)
        at scala.reflect.internal.Symbols$Symbol.initialize(Symbols.scala:1698)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5406)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.typedStat$1(Typers.scala:5845)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typedStats$10(Typers.scala:3337)
        at scala.tools.nsc.typechecker.Typers$Typer.typedStats(Typers.scala:3337)
        at scala.tools.nsc.typechecker.Typers$Typer.typedBlock(Typers.scala:2497)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typed1$103(Typers.scala:5711)
        at scala.tools.nsc.typechecker.Typers$Typer.typedOutsidePatternMode$1(Typers.scala:500)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5746)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.typedDefDef(Typers.scala:5997)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5701)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.typedStat$1(Typers.scala:5845)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typedStats$10(Typers.scala:3337)
        at scala.tools.nsc.typechecker.Typers$Typer.typedStats(Typers.scala:3337)
        at scala.tools.nsc.typechecker.Typers$Typer.typedTemplate(Typers.scala:2019)
        at scala.tools.nsc.typechecker.Typers$Typer.typedModuleDef(Typers.scala:1885)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5703)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Typers$Typer.typedStat$1(Typers.scala:5845)
        at scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typedStats$10(Typers.scala:3337)
        at scala.tools.nsc.typechecker.Typers$Typer.typedStats(Typers.scala:3337)
        at scala.tools.nsc.typechecker.Typers$Typer.typedPackageDef$1(Typers.scala:5413)
        at scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:5705)
        at scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:5781)
        at scala.tools.nsc.typechecker.Analyzer$typerFactory$TyperPhase.apply(Analyzer.scala:114)
        at scala.tools.nsc.Global$GlobalPhase.applyPhase(Global.scala:453)
        at scala.tools.nsc.typechecker.Analyzer$typerFactory$TyperPhase.run(Analyzer.scala:102)
        at scala.tools.nsc.Global$Run.compileUnitsInternal(Global.scala:1514)
        at scala.tools.nsc.Global$Run.compileUnits(Global.scala:1498)
        at scala.tools.nsc.Global$Run.compileSources(Global.scala:1491)
        at scala.tools.nsc.Global$Run.compile(Global.scala:1620)
        at scala.tools.nsc.Driver.doCompile(Driver.scala:47)
        at scala.tools.nsc.MainClass.doCompile(Main.scala:32)
        at scala.tools.nsc.Driver.process(Driver.scala:67)
        at io.bazel.rulesscala.scalac.ScalacWorker.compileScalaSources(ScalacWorker.java:257)
        at io.bazel.rulesscala.scalac.ScalacWorker.work(ScalacWorker.java:61)
        at io.bazel.rulesscala.worker.Worker.persistentWorkerMain(Worker.java:86)
        at io.bazel.rulesscala.worker.Worker.workerMain(Worker.java:39)
        at io.bazel.rulesscala.scalac.ScalacWorker.main(ScalacWorker.java:25)
error: error while loading Error, class file 'bazel-out/darwin-opt-exec-2B5CBBC6/bin/external/org_scalameta_scalafmt_core/org_scalameta_scalafmt_core.stamp/scalafmt-core_2.13-3.6.1-stamped.jar(org/scalafmt/Error.class)' is broken
(class java.lang.RuntimeException/error reading Scala signature of Error.class: Scala signature Error has wrong version
 expected: 5.0
 found: 5.2 in Error.class)
external/io_bazel_rules_scala/scala/scalafmt/scalafmt/ScalafmtWorker.scala:33: warning: fruitless type test: a value of type Throwable cannot also be a org.scalafmt.Error
      case e @ (_: org.scalafmt.Error | _: scala.meta.parsers.ParseException) => {
                                ^
one warning found
6 errors found
Build failed
java.lang.RuntimeException: Build failed
        at io.bazel.rulesscala.scalac.ScalacWorker.compileScalaSources(ScalacWorker.java:290)
        at io.bazel.rulesscala.scalac.ScalacWorker.work(ScalacWorker.java:61)
        at io.bazel.rulesscala.worker.Worker.persistentWorkerMain(Worker.java:86)
        at io.bazel.rulesscala.worker.Worker.workerMain(Worker.java:39)
        at io.bazel.rulesscala.scalac.ScalacWorker.main(ScalacWorker.java:25)
Target //example:example failed to build
Use --verbose_failures to see the command lines of failed build steps.
INFO: Elapsed time: 15.339s, Critical Path: 0.77s
INFO: 7 processes: 6 internal, 1 darwin-sandbox.
FAILED: Build did NOT complete successfully
```

</details>

---

Alternatively, we can make `rules_scala` to use `scalafmt-dynamic` instead of `scalafmt-core` that download `scalafmt-core` at runtime, but it might break the Bazel's philosophy?
https://bazelbuild.slack.com/archives/CDCKJ2KFZ/p1670601024139329

