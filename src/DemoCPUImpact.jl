function DemoCPUImpact()
  sleep(2.)  #-- wait until warnings completed
  sleep_ns(.5)
  function DummyCode(NumDummyLoops) #-- warm up sleep
    xsum = 0.
    for i in 1:NumDummyLoops
      xsum += rand()
    end
  end
  RunningSecs = 20
  DesiredSleep = .0075

  println("DemoCPUImpact v.3002 dated 10-05-2016")
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
  for i in 1:NumIters
    sleep_ns(DesiredSleep)
  end

  println("")
  println("=========================================================================================")
  @printf("... check your cpu loading For Function Libc.systemsleep?\n")
  println("=========================================================================================")
  for i in 1:NumIters
    Libc.systemsleep(DesiredSleep)
  end

  println("")
  println("=========================================================================================")
  println("... cpuloading has completed!")
  println("=========================================================================================")
end
