using BenchmarkTools
function DemoSuite()
  println("DemoSuite v.Suite005 dated 10-05-2016")

  println("")
  gdir = Pkg.dir("AccurateSleep")
  SuiteName = gdir * "\\src\\" * "Instructions.txt"
  f = open(SuiteName)
  lines = readlines(f)
  counter = 1
  for l in lines
     ll = chomp(l)
     println(ll)
     counter += 1
  end
  close(f)
  sleep_ns(3.)
  TimerOK = AccurateSleep.CheckInterruptTimer()
  if TimerOK = false
    println("The programmible interrupt timer resolution exceeds 15 milliseconds!")
    println(" ... accuracy of AccurateSleep is adversely affected.")
    println(" ... see the AccurateSleep doc for corrective measures.")
    println(" ... opening AdobeReaderDC will maintain appropriate resoution.")
    return
  end



  println("================================================================")
  println("           Suite of various demo usages of AccurateSleep ")
  println("================================================================")
  println("")

  println("\nIf you want to skip rest of suite then press CTRL-C now!\n")
  sleep_ns(5.)

  println("---- 6 sleep_ns() calls with various sleep times")
  println("---- integers are not accepeted")
  @show sleep_ns(1.)
  @show sleep_ns(.01)
  @show sleep_ns(.001)
  @show sleep_ns(.0001)
  @show sleep_ns(.00001)
  @show sleep_ns(.000003)

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


  println(" ... DemoSuite has completed")
  println("")
end
