val scala3Version = "3.2.2"

lazy val app = project
  .in(file("app"))
  .settings(
    name := "app",
    version := "0.1.0-SNAPSHOT",
    scalaVersion := scala3Version,
  ).enablePlugins(JavaAppPackaging)

lazy val server = project
  .in(file("server"))
  .settings(
    name := "server",
    version := "0.1.0-SNAPSHOT",
    scalaVersion := scala3Version,
  ).enablePlugins(JavaServerAppPackaging)
