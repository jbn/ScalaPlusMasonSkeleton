name := "EDIT_NAME_IN_BUILD_DOT_SBT"

version := "0.0.1"

scalaVersion := "2.9.1"

// Simulations have a tendency to be big. Forking the run means you don't have
// to give SBT more resources than it needs.

fork in run := true

javaOptions in run += "-Xmx1G"

scalacOptions += "-deprecation"

// @todo check to see if this is still the preferred way of including specs2
// and if there is a new stable version.

libraryDependencies ++= Seq(
  "org.specs2" %% "specs2" % "1.7",
  "org.specs2" %% "specs2-scalaz-core" % "6.0.1" % "test"
)

resolvers ++= Seq(
  "snapshots" at "http://scala-tools.org/repo-snapshots",
  "releases"  at "http://scala-tools.org/repo-releases"
)
