function ToyTimeStamp()
  const TicsPerSec = 1_000_000_000
  #const OverheadSleepLoop = .000001300
  const OverheadSleepLoop = .0

  NumIters = 100
  SleepPerIter = 1./60.
  for k = 1:2
    println("")
    if k == 1
      println("ToyTimeStamp for Libc.systemsleep() function")
    else
      println("ToyTimeStamp for sleep_ns() function")
    end

    DesiredSleep = SleepPerIter
    SavedTime = Array{Float64}(NumIters)
    BeginSecTic = time_ns()  #-- assume this is beginning second
    for i in 1:NumIters
      if k == 1
        @printf("DesiredSleep => %12.9f secs \n", DesiredSleep)
        Libc.systemsleep(DesiredSleep)
      else
        @printf("DesiredSleep => %12.9f secs \n", DesiredSleep)
        sleep_ns(DesiredSleep)
      end

      EndSecTic = time_ns()
      ElapsedTime = (EndSecTic - BeginSecTic) / TicsPerSec
      DesiredSleep = ((i + 1.) * SleepPerIter) - ElapsedTime - OverheadSleepLoop
      SavedTime[i] = ElapsedTime
    end
    for i in 1:NumIters
      @printf("ElapsedTime => %12.9f seconds\n", SavedTime[i])
    end
  end

  print("")
  return nothing
end
using AccurateSleep
