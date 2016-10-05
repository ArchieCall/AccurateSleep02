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
  const tics_per_sec = 1_000_000_000.

  println("DemoCPUImpact v.3002 dated 10-05-2016")
  println(" ")
  println("=========================================================================================")
  println("... cpuloading_sleep_ns  => continuous calls to sleep_ns Function")
  @printf("... parms:  RunningSecs => %4i secs,  DesiredSleep => %11.9f\n", RunningSecs, DesiredSleep)
  println("=========================================================================================")

  DesiredSleep = 1.0000
  NumIters = convert(Int, round(RunningSecs / DesiredSleep))
  println("")
  println("=========================================================================================")
  @printf("... for %i secs check cpu loading using sleep_ns() of %11.9f seconds\n", RunningSecs, DesiredSleep)
  println("=========================================================================================")
  for i in 1:NumIters
    sleep_ns(DesiredSleep)
  end

  DesiredSleep = .1000
  NumIters = convert(Int, round(RunningSecs / DesiredSleep))
  println("")
  println("=========================================================================================")
  @printf("... for %i secs check cpu loading using sleep_ns() of %11.9f seconds\n", RunningSecs, DesiredSleep)
  println("=========================================================================================")
  for i in 1:NumIters
    sleep_ns(DesiredSleep)
  end

  DesiredSleep = .0100
  NumIters = convert(Int, round(RunningSecs / DesiredSleep))
  println("")
  println("=========================================================================================")
  @printf("... for %i secs check cpu loading using sleep_ns() of %11.9f seconds\n", RunningSecs, DesiredSleep)
  println("=========================================================================================")
  for i in 1:NumIters
    sleep_ns(DesiredSleep)
  end

  DesiredSleep = .0075
  NumIters = convert(Int, round(RunningSecs / DesiredSleep))
  println("")
  println("=========================================================================================")
  @printf("... for %i secs check cpu loading using sleep_ns() of %11.9f seconds\n", RunningSecs, DesiredSleep)
  println("=========================================================================================")
  for i in 1:NumIters
    sleep_ns(DesiredSleep)
  end

  DesiredSleep = .0050
  NumIters = convert(Int, round(RunningSecs / DesiredSleep))
  println("")
  println("=========================================================================================")
  @printf("... for %i secs check cpu loading using sleep_ns() of %11.9f seconds\n", RunningSecs, DesiredSleep)
  println("=========================================================================================")
  for i in 1:NumIters
    sleep_ns(DesiredSleep)
  end

  DesiredSleep = .0025
  NumIters = convert(Int, round(RunningSecs / DesiredSleep))
  println("")
  println("=========================================================================================")
  @printf("... for %i secs check cpu loading using sleep_ns() of %11.9f seconds\n", RunningSecs, DesiredSleep)
  println("=========================================================================================")
  for i in 1:NumIters
    sleep_ns(DesiredSleep)
  end

  DesiredSleep = .0010
  NumIters = convert(Int, round(RunningSecs / DesiredSleep))
  println("")
  println("=========================================================================================")
  @printf("... for %i secs check cpu loading using sleep_ns() of %11.9f seconds\n", RunningSecs, DesiredSleep)
  println("=========================================================================================")
  for i in 1:NumIters
    sleep_ns(DesiredSleep)
  end

  println("")
  println("=========================================================================================")
  println("... cpuloading has completed!")
  println("=========================================================================================")
end
