function ToyTimeStamp()
  const TicsPerSec = 1_000_000_000
  const OverheadSleepLoop = .000001300
  #const OverheadSleepLoop = .0
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

  NumIters = 100
  SleepPerIter = 1./60.
  for k = 1:3
    println("")
    if k == 1
      println("ToyTimeStamp for sleep() function")
    elseif k == 2
      println("ToyTimeStamp for Libc.systemsleep() function")
    else
      println("ToyTimeStamp for sleep_ns() function")
    end

    DesiredSleep = SleepPerIter
    SavedTime = Array{Float64}(NumIters)
    #SavedDesiredTime = Array{Float64}(NumIters)
    BeginSecTic = time_ns()  #-- assume this is beginning second
    for i in 1:NumIters
      if k == 1
        sleep(DesiredSleep)
      elseif k == 2
        Libc.systemsleep_ns(DesiredSleep)
      else
        sleep_ns(DesiredSleep)
      end
      EndSecTic = time_ns()
      ElapsedTime = (EndSecTic - BeginSecTic) / TicsPerSec
      DesiredSleep = ((i + 1.) * SleepPerIter) - ElapsedTime - OverheadSleepLoop
      SavedTime[i] = ElapsedTime
    end
    for i in 1:NumIters
      CumDesired = SavedTime[i] - (i * SleepPerIter)
      @printf("ElapsedTime => %12.9f secs   Diff => %12.9f secs\n", SavedTime[i], CumDesired)
    end
  end

  print("")
  return nothing
end
using AccurateSleep
