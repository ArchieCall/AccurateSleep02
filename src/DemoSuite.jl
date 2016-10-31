using BenchmarkTools
function DemoSuite()
  TimerOK = AccurateSleep.CheckInterruptTimer()
  if TimerOK == false
    println("")
    println("The programmible interrupt timer resolution exceeds 15 milliseconds!")
    println(" ... accuracy of AccurateSleep is adversely affected.")
    println(" ... see the AccurateSleep doc for corrective measures.")
    println(" ... this is prevalent on the Windows OS.")
    println(" ... opening the Chrome browser may maintain appropriate resoution.")
    println("")
    return
  end

  TicsPerSec = 1_000_000_000.
  SuiteBegTic = time_ns()
  println("================================================================")
  println("           Suite of various demo usages of AccurateSleep ")
  println("================================================================")
  println("")

  println("Estimated running time:  => 85 seconds.")
  sleep_ns(3.)


  function ShowSleep(Sleep_Time)
    if Sleep_Time >= .001
      Tic1 = time_ns()
      sleep(Sleep_Time)
      Tic2 = time_ns()
      ElapsedSleep = (Tic2 - Tic1) / TicsPerSec
      @printf("sleep:              Desired(secs) => %11.9f   Actual(secs) => %11.9f   Diff(secs) => %11.9f\n",
      Sleep_Time, ElapsedSleep,  ElapsedSleep - Sleep_Time)

      Tic1 = time_ns()
      Libc.systemsleep(Sleep_Time)
      Tic2 = time_ns()
      ElapsedSleep = (Tic2 - Tic1) / TicsPerSec
      @printf("Libc.systemsleep:   Desired(secs) => %11.9f   Actual(secs) => %11.9f   Diff(secs) => %11.9f\n",
      Sleep_Time, ElapsedSleep,  ElapsedSleep - Sleep_Time)
    end

    Tic1 = time_ns()
    sleep_ns(Sleep_Time)
    Tic2 = time_ns()
    ElapsedSleep = (Tic2 - Tic1) / TicsPerSec
    @printf("sleep_ns:           Desired(secs) => %11.9f   Actual(secs) => %11.9f   Diff(secs) => %11.9f\n",
    Sleep_Time, ElapsedSleep, ElapsedSleep - Sleep_Time)

  end
  println("==========================================================================================================")
  println("   Single sample calls to sleep(), Libc.systemsleep(), and sleep_ns()")
  println("   Diff is the difference between Actual and Desired")
  println("   Timing of the sleeps:  tics before and after the function call")
  println("==========================================================================================================")
  ShowSleep(2.)
  println("----------------------------------------------------------------------------------------------------------")
  ShowSleep(1.)
  println("----------------------------------------------------------------------------------------------------------")
  ShowSleep(.1)
  println("----------------------------------------------------------------------------------------------------------")
  ShowSleep(.01)
  println("----------------------------------------------------------------------------------------------------------")
  ShowSleep(.0075)
  println("----------------------------------------------------------------------------------------------------------")
  ShowSleep(.005)
  println("----------------------------------------------------------------------------------------------------------")
  ShowSleep(.0025)
  println("----------------------------------------------------------------------------------------------------------")
  ShowSleep(.001)
  println("----------------------------------------------------------------------------------------------------------")
  ShowSleep(.0005)
  ShowSleep(.0001)
  ShowSleep(.00005)
  ShowSleep(.00001)
  ShowSleep(.000005)
  ShowSleep(.000003)
  println("----------------------------------------------------------------------------------------------------------")

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
  AccurateSleep.DemoCDF(.001, 1000)
  println("")
  AccurateSleep.DemoCDF(.0001, 5000)
  println("")
  AccurateSleep.DemoCDF(.000005, 100000)
  SuiteEndTic = time_ns()
  RunningSecs = (SuiteEndTic - SuiteBegTic) / TicsPerSec
  println("")
  @printf(" ... DemoSuite has completed:  running time => %3.0f seconds.\n", RunningSecs)
  println("")
end
