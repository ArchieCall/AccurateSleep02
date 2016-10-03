using BenchmarkTools
function DemoSuite()
  println("DemoSuite v.Suite005 dated 10-02-2016")
  println("================================================================")
  println("           Suite of various demo usages of AccurateSleep ")
  println("================================================================")
  println("")

  #=
  ================================================================
  Usage of AccurateSleep and sleep_ns
  ================================================================

  using AccurateSleep
  ---------------------------------------------------------------
  ... loads AccurateSleep package and its functions ...

  AccurateSleep.DemoTutor()
  ---------------------------------------------------------------
  ... runs this tutorial ...

  sleep_ns(SleepSecs::AbstractFloat
  ---------------------------------------------------------------
  ... primary Function within AccurateSleep ...
  ... accurately sleeps specified SleepSecs ...
  sleep_ns(.5)                   : sleeps half second
  sleep_ns(.000005)              : sleeps 5 microseconds
  sleep_ns(5.)                   : sleeps 5 seconds
  sleep_ns(1)                    : errors out - not float"

  AccurateSleep.Demo1()
  ---------------------------------------------------------------
  ... runs simple script showcasing sleep_ns ...

  AccurateSleep.Demo2(SleepSecs::AbstractFloat, NumCycles::Integer, NumIters::Integer)
  -------------------------------------------------------------------------------------
  ... produces a detailed CDF report ...
  AccurateSleep.Demo2(.001, 3, 2000)      - sleeps .001 secs, 3 cycles, 2000 iters
  AccurateSleep.Demo2(.000001, 1, 10000)  - sleeps .000001 secs, 1 cycle, 10000 iters)

  AccurateSleep.Demo3(secs, DesiredSleep)
  ---------------------------------------------------------------
  ... grinder to evaluate CPU loading ...

  ================================================================
  See the Package doc on Github
  https://github.com/ArchieCall/AccurateSleep
  ================================================================
  =#


  println("\nIf you want to skip rest of suite then press CTRL-C now!\n")
  
  sleep_ns(5.)
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
