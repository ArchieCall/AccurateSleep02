function Demo3(RunningSecs::Int, DesiredSleep::AbstractFloat)
  sleep(2.)  #-- wait until warnings completed
  sleep_ns(.5)
  function DummyCode(NumDummyLoops) #-- warm up sleep
    xsum = 0.
    for i in 1:NumDummyLoops
      xsum += rand()
    end
  end
  println("Demo3 v.3002 dated 10-01-2016")
  println(" ")
  println("=========================================================================================")
  println("... cpuloading_sleep_ns  => continuous calls to sleep_ns Function")
  @printf("... parms:  RunningSecs => %4i secs,  DesiredSleep => %11.9f\n", RunningSecs, DesiredSleep)
  println("=========================================================================================")
  NumIters = convert(Int, round(RunningSecs / DesiredSleep))
  const tics_per_sec = 1_000_000_000.

  println("")
  println("=========================================================================================")
  @printf("... check your cpu loading For Function sleep_ns?\n")
  println("=========================================================================================")
  begtim = time_ns()
  for i in 1:NumIters
    #DummyCode(10_000_000)
    sleep_ns(DesiredSleep)
  end
  endtim = time_ns()
  AverageSleep1 = ((endtim - begtim)/tics_per_sec)/NumIters
  AverageDiff1 = AverageSleep1 - DesiredSleep

  println("")
  println("=========================================================================================")
  @printf("... check your cpu loading For Function Libc.systemsleep?\n")
  println("=========================================================================================")
  begtim = time_ns()
  for i in 1:NumIters
    Libc.systemsleep(DesiredSleep)
  end
  endtim = time_ns()
  AverageSleep2 = ((endtim - begtim)/tics_per_sec)/NumIters
  AverageDiff2 = AverageSleep2 - DesiredSleep

  println("")
  println("=========================================================================================")
  @printf("... DesiredSleep                  => %12.9f seconds\n", DesiredSleep)
  @printf("... sleep_ns AverageSleep         => %12.9f seconds\n", AverageSleep1)
  @printf("... sleep_ns AverageDiff          => %12.9f seconds\n", AverageDiff1)
  @printf("... Libc.systemsleep AverageSleep => %12.9f seconds\n", AverageSleep2)
  @printf("... Libc.systemsleep AverageDiff  => %12.9f seconds\n", AverageDiff2)
  println("... cpuloading has completed!")
  println("=========================================================================================")
end
