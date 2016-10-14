function ToyController()
  const TicsPerSec = 1_000_000_000
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
  #--
  NumIters = 100
  ProcessTime = 1./60.  #-- time of the process cycle (secs)
  ProcessTolerance = .05  #-- percent + or - allowed for process to start
  c = .01     #-- ControllerMean -> mean time that the process is controlled
  cDiff = 1.  #-- ControllerMean varies uniformly about this percent diff
  cMin = .5 * ProcessTime
  cMax = .8 * ProcessTime
  NumCSteps = 10
  cStep = (cMax - cMin) / NumCSteps
  for c = cMin:cStep:cMax
    DesiredSleep = SleepPerIter
    SavedTime = Array{Float64}(NumIters)
    BeginSecTic = time_ns()  #-- assume this is beginning second
    for i in 1:NumIters

      #--- assume we have started a control task within the process cycle
      cTimeMin = c * (1. - (.5 * cDiff /100.))
      cTimeMax = c * (1. + (.5 * cDiff /100.))
      cTime = cTimeMin + rand(cTimeMax - CTimeMin)

      sleep_ns(DesiredSleep)
      #--sleep(DesiredSleep)
      EndSecTic = time_ns()
      ElapsedTime = (EndSecTic - BeginSecTic) / TicsPerSec
      DesiredSleep = ((i + 1.) * SleepPerIter) - ElapsedTime
      SavedTime[i] = ElapsedTime
    end
    for i in 1:NumIters
      CumDesired = SavedTime[i] - (i * SleepPerIter)
      @printf("ElapsedTime => %12.9f secs   Diff => %12.9f secs\n", SavedTime[i], CumDesired)
    end
  end  #-- end of c loop

  print("")
  return nothing
end  #-- end of ToyController function
