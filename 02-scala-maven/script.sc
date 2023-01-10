//> using scala "2.13.8"
import $dep.`io.circe::circe-core:0.15.0-M1`
import $dep.`io.circe::circe-parser:0.15.0-M1`
import $dep.`io.circe::circe-generic:0.15.0-M1`
import $dep.`io.circe::circe-generic-extras:0.14.3`

import io.circe._
import io.circe.syntax._
import io.circe.parser._
import io.circe.generic.extras.auto._
import io.circe.generic.extras.Configuration

import java.nio.file.{Files, Paths}

implicit val customConfig: Configuration = Configuration.default.withDefaults

val jsonStr = Files.readString(Paths.get("maven_install.json"))

decode[MavenInstall](jsonStr) match {
    case Right(value) =>
        println(value.toDepGraphData.asJson.deepDropNullValues)
    case Left(err) => throw err
}

case class MavenInstall(
    dependency_tree: DependencyTree
) {
  def toDepGraphData = {
    val rootPkg = Pkg(
      id = "app@1.0.0",
      info = PkgInfo(name = "app", version = Some("1.0.0"), purl = None)
    )
    val rootNode = GraphNode(
      nodeId = "root-node",
      pkgId = "app@1.0.0",
      info = None,
      deps = dependency_tree.libDependencies.map(dep => Dep(dep.parsed.id))
    )
    val nodes = dependency_tree.libDependencies.map(_.toGraphNode) :+ rootNode
    val pkgs = dependency_tree.libDependencies.map(_.toPkg) :+ rootPkg
    DepGraphData(
      schemaVersion = "1.2.0",
      pkgManager = PkgManager(name = "maven", version = None, repositories = Nil),
      pkgs = pkgs,
      graph = Graph(
        rootNodeId = "root-node",
        nodes = nodes,
      )
    )
  }
}

// ====== data models =======

case class DependencyTree(
    dependencies: List[Dependency],
    version: String
) {
    def libDependencies = dependencies.filter(!_.isSourceJar)
}

case class Dependency(
    coord: String,
    dependencies: List[String] = Nil,
    directDependencies: List[String] = Nil,
    file: String = "",
    mirror_urls: List[String] = Nil,
    sha256: String,
    url: String
) {
  lazy val parsed = Coord(coord)
  def isSourceJar = parsed.isSourceJar
  def toGraphNode: GraphNode = {
    GraphNode(
      nodeId = parsed.id,
      pkgId = parsed.id,
      info = None,
      deps = dependencies.map { dep =>
        Dep(Coord(dep).id)
      }
    )
  }
  def toPkg: Pkg = {
    Pkg(
      id = parsed.id,
      info = PkgInfo(
        name = s"${parsed.org}:${parsed.name}",
        version = Some(parsed.version),
        purl = None,
      )
    )
  }
}

case class Coord(
    org: String,
    name: String,
    isSourceJar: Boolean,
    version: String
) {
  lazy val id = s"$org:$name@$version"
}
object Coord {
  def apply(coord: String): Coord = {
    val split = coord.split(":")
    if (split.length == 3) {
      Coord(split(0), split(1), false, split(2))
    } else if (
      split.length == 5 && split(2) == "jar" && split(3) == "sources"
    ) {
      Coord(split(0), split(1), true, split(4))
    } else {
      throw new Exception(s"Invalid coord '$coord'")
    }
  }
}

// for snyk below

case class PkgInfo(
    name: String,
    version: Option[String],
    purl: Option[String]
)

case class VersionProvenance(
    `type`: String,
    location: String
    // property: Option[{name: String}]
)

case class NodeInfo(
    versionProvenance: Option[VersionProvenance],
    labels: Option[Map[String, Option[String]]]
)

case class Node(
    info: NodeInfo
)

case class GraphNode(
    nodeId: String,
    pkgId: String,
    info: Option[NodeInfo],
    deps: List[Dep]
)

case class Dep(
    nodeId: String
)

case class PkgManager(
    name: String,
    version: Option[String],
    repositories: List[Repository]
)
case class Repository(
    alias: String
)

case class DepGraphData(
    schemaVersion: String,
    pkgManager: PkgManager,
    pkgs: List[Pkg],
    graph: Graph
)
case class Pkg(
    id: String,
    info: PkgInfo
)

case class Graph(
    rootNodeId: String,
    nodes: List[GraphNode]
)
