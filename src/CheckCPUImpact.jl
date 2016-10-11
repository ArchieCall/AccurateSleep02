function CheckCPUImpact(; SimSecs=20., Sleep=[.0060, .0050, .0040, .0035, .0030, .0029, .0028, .0027, .0026, .0025, .0023, .0020], Burn=[100.])
  sleep(2.)  #-- wait until warnings completed
  sleep_ns(.5)  #-- warm up
  InnerLoopTime = 1.
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
