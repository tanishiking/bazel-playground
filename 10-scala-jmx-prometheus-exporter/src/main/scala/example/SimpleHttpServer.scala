package example

import java.io.{InputStream, OutputStream}
import java.net.InetSocketAddress

import com.sun.net.httpserver.{HttpExchange, HttpHandler, HttpServer}
import scala.meta._

object SimpleHttpServer {

  def main(args: Array[String]) {
    val server = HttpServer.create(new InetSocketAddress(8000), 0)
    server.createContext("/", new RootHandler())
    server.setExecutor(null)

    server.start()

    println("Hit any key to exit...")

    System.in.read()
    server.stop(0)
  }

}

class RootHandler extends HttpHandler {

  def handle(t: HttpExchange) {
    val input = scala.io.Source.fromInputStream(t.getRequestBody).mkString
    displayPayload(input)
    sendResponse(t, input)
  }

  private def displayPayload(body: String): Unit ={
    println()
    println("******************** REQUEST START ********************")
    println()
    println(body)
    println()
    println("********************* REQUEST END *********************")
    println()
  }

  private def sendResponse(t: HttpExchange, body: String) {
    val prog = body.parse[Source].get

    val ast = pprint.apply(prog)

    val response = ast.plainText
    t.sendResponseHeaders(200, response.length())
    val os = t.getResponseBody
    os.write(response.getBytes)
    os.close()
  }

}
