function CheckCPUImpact(; SimSecs=20., Sleep=[.1, .05, .0004], Burn=[100., 50., 25.])
  sleep(2.)  #-- wait until warnings completed
  sleep_ns(.5)  #-- warm up
  #SimSecs = 20.
  InnerLoopTime = 1.
  #WantedSleep = [.1000, .0100, .0080, .0060, .0050, .0040, .0030, .0025, .0020, .0015]
  #WantedSleep = [.0050, .0030, .0020, .0015, .0010]
  #Sleep = [.0100, .0080, .0060]
  #Burn = [100., 75., 50., 25., 1.]  #-- 100. = 100% burn, 50. = 50% burn
  for st in Sleep
    for bl in Burn
      InnerLoopPause = InnerLoopTime * (100. - bl)/100.
      InnerBurnTime = InnerLoopTime - InnerLoopPause
      NumInnerIters = convert(Int, round(InnerBurnTime / st))
      ActInnerBurnTime = NumInnerIters * st
      NumOuterIters = convert(Int, round(SimSecs / InnerLoopTime))
      println("======================================================================")
      @printf("check your CPU loading during the next %i loops \n", NumOuterIters)
      println("======================================================================")
      for ol in 1:NumOuterIters
        @printf("Loop => %3i  Sleep = %11.6f secs   Burn => %4.0f Percent\n", ol, st, bl )
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
  println("========================================================================")
  println("... cpuloading has completed!")
  println("========================================================================")
end
