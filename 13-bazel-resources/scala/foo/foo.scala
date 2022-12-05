package foo

import java.io._
import java.nio.charset.StandardCharsets

object Foo {
  def main(args: Array[String]) = {
    val is: InputStream = getClass.getResourceAsStream("/a.txt")
    val content = scala.io.Source.fromInputStream(is).mkString
    println(content)
  }
}
