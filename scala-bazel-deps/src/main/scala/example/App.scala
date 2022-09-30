package example

import scala.meta._

object App {

  def parseProgram = {
    val program = """object Main extends App { print("Hello!") }"""
    program.parse[Source].get
  }

  def main(args: Array[String]) = {
    pprint.pprintln(parseProgram)
  }

}
