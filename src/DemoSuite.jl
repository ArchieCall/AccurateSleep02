using BenchmarkTools
function DemoSuite()
  println("DemoSuite v.Suite005 dated 10-02-2016")
  println("================================================================")
  println("           Suite of various demo usages of AccurateSleep ")
  println("================================================================")
  println("")
  println("If you want to skip rest of suite then press CTRL-C now!")
  sleep_ns(5.)
  #AccurateSleep.DemoTutor()
  sleep_ns(1.)
  sleep_ns(.01)
  sleep_ns(.001)
  sleep_ns(.0001)
  sleep_ns(.00001)
  sleep_ns(.000003)

  println("\n--- benchmark sleep of .001 secs")
  @show @benchmark sleep(.001)
  println("")
  @show @benchmark Libc.systemsleep(.001)
  println("")
  @show @benchmark sleep_ns(.001)
  println("")


  println("\n--- benchmark sleep of .005 secs")
  @show @benchmark sleep(.005)
  println("")
  @show @benchmark Libc.systemsleep(.005)
  println("")
  @show @benchmark sleep_ns(.005)
  println("")


  println("\nVarious CDF reports")
  AccurateSleep.Demo2(.001, 2, 1000)
  println("")
  AccurateSleep.Demo2(.0001, 1, 5000)
  println("")
  AccurateSleep.Demo2(.000003, 1, 5000)

  #=

  ------ AccurateSleep commands -------
  sleep_ns(.5)
  AccurateSleep.Demo2(.001, 2, 1000)
  AccurateSleep.Demo3(15, .005)

  =#

  println(" ... DemoSuite has completed")
  println("")
end
