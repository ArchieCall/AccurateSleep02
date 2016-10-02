using BenchmarkTools
function DemoSuite()
  println("DemoSuite v.Suite003 dated 10-01-2016")
  println("================================================================")
  println("           Suite of various demo usages of AccurateSleep ")
  println("================================================================")
  #using BenchmarkTools
  #sleep(.4)
  @benchmark sleep_ns(.001)
  #whoaa()
  AccurateSleep.DemoTutor()
  sleep_ns(1.)
  sleep_ns(.01)
  sleep_ns(.001)
  sleep_ns(.0001)
  sleep_ns(.00001)
  sleep_ns(.000003)
  AccurateSleep.Demo2(.001, 2, 1000)
  AccurateSleep.Demo2(.0001, 1, 5000)
  AccurateSleep.Demo2(.000003, 1, 5000)

  println(" ... DemoSuite has completed")
  println("")
end
