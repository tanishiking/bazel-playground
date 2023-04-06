import scoverage.report.CoverageAggregator
import scoverage.report.ScoverageXmlWriter
import scoverage.report.ScoverageHtmlWriter
import java.nio.file.Paths

/**
  * Run `CoverageAggregator.aggregate` against `/tmp/scoverage-data/`
  * and create a report in "$pwd/scoverage-report"
  * 
  * This script is expected to run with
  * "bazel run //bazel_scoverage -- <pwd> <html/xml>".
  */
object ScoverageAggregator {
  def main(args: Array[String]) = {
    val pwd = os.Path(Paths.get(args(0)))
    val format = args(1)
    val dest = pwd / "scoverage-report"
    val dataDirs = os.walk(os.Path(Paths.get("/tmp/scoverage-data"))).filter(os.isDir)
    val sourceDirs = os.list(pwd).filter(os.isDir).map(_.toIO)
    CoverageAggregator.aggregate(dataDirs.map(_.toIO)) match {
      case Some(cov) =>
        os.remove.all(dest)
        os.makeDir.all(dest)
        if (format == "xml") {
            new ScoverageXmlWriter(sourceDirs, dest.toIO, false).write(cov)
        } else if (format == "html") {
            new ScoverageHtmlWriter(sourceDirs, dest.toIO, None).write(cov)
        }
      case None =>
    }
  }
} 
