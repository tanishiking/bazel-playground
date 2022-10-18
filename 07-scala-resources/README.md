```
❯ jar -tf bazel-bin/main.jar
META-INF/
META-INF/MANIFEST.MF
example/
example/App$.class
example/App.class
foo.txt
```

```scala
package example

import java.io._
import java.nio.charset.StandardCharsets
import java.nio.file.{Files, Paths}

object App {
  def main(args: Array[String]) = {
    val resource = getClass.getResource("/foo.txt")
    // jar:file:/private/var/tmp/_bazel_tanishiking/1eaa66c26ff6bfab47bbc9a627c054ed/execroot/__main__/bazel-out/darwin-fastbuild/bin/main.jar!/foo.txt
    println(resource.toURI)

    // Exception in thread "main" java.nio.file.FileSystemNotFoundException
    //         at jdk.zipfs/jdk.nio.zipfs.ZipFileSystemProvider.getFileSystem(ZipFileSystemProvider.java:156)
    //         at jdk.zipfs/jdk.nio.zipfs.ZipFileSystemProvider.getPath(ZipFileSystemProvider.java:142)
    //         at java.base/java.nio.file.Path.of(Path.java:208)
    //         at java.base/java.nio.file.Paths.get(Paths.java:98)
    //         at example.App$.main(App.scala:12)
    //         at example.App.main(App.scala)
    // Files.readString(Paths.get(resource.toURI))

    // Use getResourceAsStream to read from jar
    // see: https://stackoverflow.com/questions/6068197/read-resource-text-file-to-string-in-java
    val is: InputStream = getClass.getResourceAsStream("/foo.txt")
    val content = scala.io.Source.fromInputStream(is).mkString
    println(content)
  }
}
```

https://stackoverflow.com/questions/6068197/read-resource-text-file-to-string-in-java
