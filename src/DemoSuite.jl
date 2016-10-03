using BenchmarkTools
function DemoSuite()

  #=
  ================================================================
  Usage of AccurateSleep package and sleep_ns
  ================================================================

  using AccurateSleep
  ---------------------------------------------------------------
  ... loads AccurateSleep package and its functions

  AccurateSleep.DemoTutor()
  ---------------------------------------------------------------
  ... outputs this tutorial
  ... runs a canned script

  sleep_ns(SleepSecs::AbstractFloat)
  ---------------------------------------------------------------
  ... primary Function within AccurateSleep
  ... accurately sleeps specified SleepSecs and returns nothing
  ... SleepSecs must be floating point
  ... SleepSecs must be in range of .000003 to 84_400_000.
  sleep_ns(.5)                   : sleeps half second
  sleep_ns(.000005)              : sleeps 5 microseconds
  sleep_ns(5.)                   : sleeps 5 seconds
  sleep_ns(1)                    : errors out - not float"

  AccurateSleep.DemoSuite()
  ---------------------------------------------------------------
  ... runs script showcasing the accuracey of sleep_ns
  ... BenchmarkTools must be installed which provides the @benchmark macro

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

  println("  Do you want to run the rest of the DemoSuite? ")
  println("  Enter "y" , or "n" to quit. ")
  keyentered = chomp(readline(STDIN))
  #@show(keyentered)
  if keyentered == "n"
    #sleep_ns(2.)
    whoa()
  end

  println("DemoSuite v.Suite005 dated 10-02-2016")
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
