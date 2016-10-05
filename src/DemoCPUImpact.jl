function DemoCPUImpact()
  sleep(2.)  #-- wait until warnings completed
  sleep_ns(.5)
  function DummyCode(NumDummyLoops) #-- warm up sleep
    xsum = 0.
    for i in 1:NumDummyLoops
      xsum += rand()
    end
  end
  RunningSecs = 30.
  DesiredSleep = .0075
  InnerLoopTime = 1.
  #WantedSleep = [.1000, .0100, .0080, .0060, .0050, .0040, .0030, .0025, .0020, .0015]
  WantedSleep = [.0050, .0030, .0020, .0015]
  BurnLevel = [1.0000, .7500, .5000, .0100] #-- 1.000 = 100% burn, .01 = 1% burn
  for st in WantedSleep
    for bl in BurnLevel
      InnerLoopPause = InnerLoopTime * (1. - bl)
      InnerBurnTime = InnerLoopTime - InnerLoopPause
      NumInnerIters = convert(Int, round(InnerBurnTime / st))
      ActInnerBurnTime = NumInnerIters * st
      NumOuterIters = convert(Int, round(RunningSecs / InnerLoopTime))
      @printf("Sleep = %10.4f  BurnLevel = %10.4f InnerLoopPause = %11.8f NumInnerIters = %5i ActInnerBurnTime = %11.8f\n", st, bl, InnerLoopPause, NumInnerIters, ActInnerBurnTime)
      println("=====================================================================================")
      @printf("sleep_time = %11.8f secs\n", st)
      @printf("BurnLevel = %11.3f percent\n", bl * 100.)
      println("check your CPU loading")
      println("=====================================================================================")
      for ol in 1:NumOuterIters
        if InnerLoopPause > .0001
          Libc.systemsleep(InnerLoopPause)
        end
        for il in 1:NumInnerIters
          sleep_ns(st)  #-- burn
        end
      end

    end
  end
  println("")
  println("=========================================================================================")
  println("... cpuloading has completed!")
  println("=========================================================================================")
end
