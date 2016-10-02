using BenchmarkTools
function DemoSuite()
  println("DemoSuite v.Suite004 dated 10-01-2016")
  println("================================================================")
  println("           Suite of various demo usages of AccurateSleep ")
  println("================================================================")
  AccurateSleep.DemoTutor()
  sleep_ns(1.)
  sleep_ns(.01)
  sleep_ns(.001)
  sleep_ns(.0001)
  sleep_ns(.00001)
  sleep_ns(.000003)

  println("\n--- benchmark sleep of .001 secs")
  @show @benchmark sleep(.001)
  @show @benchmark Libc.systemsleep(.001)
  @show @benchmark sleep_ns(.001)

  println("\n--- benchmark sleep of .005 secs")
  @show @benchmark sleep(.005)
  @show @benchmark Libc.systemsleep(.005)
  @show @benchmark sleep_ns(.005)

  println("\nVarious CDF reports")
  AccurateSleep.Demo2(.001, 2, 1000)
  AccurateSleep.Demo2(.0001, 1, 5000)
  AccurateSleep.Demo2(.000003, 1, 5000)

  println(" ... DemoSuite has completed")
  println("")
end
