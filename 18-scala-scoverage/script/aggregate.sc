//> using scala "2.13.6"
//> using lib "org.scoverage:scalac-scoverage-plugin_2.13.6:1.4.11"
//> using lib "com.lihaoyi::os-lib:0.9.1"

import java.io.File
import scoverage.report.CoverageAggregator
import scoverage.report.ScoverageHtmlWriter

val dataDirs =  os.walk(os.root / "tmp" / "scoverage-data").filter(os.isDir)
println(dataDirs)

val sourceDirs = os.list(os.pwd / os.up).filter(os.isDir).map(_.toIO)
println(sourceDirs)

CoverageAggregator.aggregate(dataDirs.map(_.toIO)) match {
    case Some(cov) =>
        os.makeDir(os.pwd / "html")
        new ScoverageHtmlWriter(sourceDirs, (os.pwd / "html").toIO).write(cov)
    case None =>
}