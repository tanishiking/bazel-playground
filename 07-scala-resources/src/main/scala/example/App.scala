package example

import java.io._
import java.nio.charset.StandardCharsets
import java.nio.file.{Files, Paths}
import java.net.URI
import java.nio.file.FileSystem
import java.nio.file.FileSystems

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

    // doesn't work (empty string)
    val is2 = resource.openStream
    val content2 = scala.io.Source.fromInputStream(is).mkString
    println(content2)


    // doesn't work
    // Exception in thread "main" java.lang.IllegalArgumentException: URI is not hierarchical
    //         at java.base/java.io.File.<init>(File.java:420)
    //         at example.App$.main(App.scala:33)
    //         at example.App.main(App.scala)
    // val folder = new File(resource.toURI)
    // val items = folder.listFiles.toList
    // println(items)
    // val ls = getClass.getClassLoader.getResources("*")
    // import scala.jdk.CollectionConverters._
    // println(ls.asScala.toList)

    val uri = resource.toURI
    if (uri.getScheme == "jar") {
      val jarURI = URI.create(uri.toString.split("!").head)
      val path = uri.toString.split("!").tail.head
      println(jarURI)
      println(path)
      val jarfs = FileSystems.newFileSystem(jarURI, new java.util.HashMap[String, String]())
      val p = jarfs.getPath(path)
      val content = Files.readString(p, StandardCharsets.UTF_8)
      println(content)

      // /
      // /foo.txt
      // /example
      // /bar.txt
      // /META-INF
      import scala.jdk.CollectionConverters._
      val walk = Files.walk(p.getParent, 1).iterator.asScala
      walk.foreach { p =>
        println(p)
      }
    }



  }
}
