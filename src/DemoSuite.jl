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
  sleep_ns(1.)


  function ShowSleep(Sleep_Time)
    if Sleep_Time >= .001
      Tic1 = time_ns()
      sleep(Sleep_Time)
      Tic2 = time_ns()
      ElapsedSleep = (Tic2 - Tic1) / TicsPerSec
      @printf("sleep:              Desired(secs) => %11.9f   Actual(secs) => %11.9f   Diff(secs) => %11.9f\n", Sleep_Time, ElapsedSleep,  ElapsedSleep - Sleep_Time)

      Tic1 = time_ns()
      Libc.systemsleep(Sleep_Time)
      Tic2 = time_ns()
      ElapsedSleep = (Tic2 - Tic1) / TicsPerSec
      @printf("Libc.systemsleep:   Desired(secs) => %11.9f   Actual(secs) => %11.9f   Diff(secs) => %11.9f\n", Sleep_Time, ElapsedSleep,  ElapsedSleep - Sleep_Time)
    end

    Tic1 = time_ns()
    ElapsedSleepA = sleep_ns(Sleep_Time)
    Tic2 = time_ns()
    ElapsedSleep = (Tic2 - Tic1) / TicsPerSec
    @printf("sleep_ns:           Desired(secs) => %11.9f   Actual(secs) => %11.9f   Diff(secs) => %11.9f\n", Sleep_Time, ElapsedSleep, ElapsedSleep - Sleep_Time)
    @printf("sleep_ns A:         Desired(secs) => %11.9f   Actual(secs) => %11.9f   Diff(secs) => %11.9f\n", Sleep_Time, ElapsedSleepA, ElapsedSleepA - Sleep_Time)

  end
  println("---- 6 sleep_ns() calls with various sleep times")
  println("---- integers are not accepeted")
  ShowSleep(1.)
  ShowSleep(.1)
  ShowSleep(.01)
  ShowSleep(.005)
  ShowSleep(.001)
  ShowSleep(.001)
  ShowSleep(.0005)
  ShowSleep(.00005)
  ShowSleep(.00001)
  ShowSleep(.000005)
  ShowSleep(.000003)
  jjjj()
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
  AccurateSleep.DemoCDF(.001, 2, 1000)
  println("")
  AccurateSleep.DemoCDF(.0001, 1, 5000)
  println("")
  AccurateSleep.DemoCDF(.000003, 1, 5000)
  SuiteEndTic = time_ns()
  RunningSecs = (SuiteEndTic - SuiteBegTic) / TicsPerSec
  println("")
  @printf(" ... DemoSuite has completed:  running time => %3.0f seconds.\n", RunningSecs)
  println("")
end
