function ToyTimeStamp(NumSecs::Integer)
  const TicsPerSec = 1_000_000_000
  const OverheadSleepLoop = .000001300
  for k = 1:2
    println("")
    if k == 1
      println("ToyTimeStamp for Libc.systemsleep() function")
    else
      println("ToyTimeStamp for sleep_ns() function")
    end

    DesiredSleep = 1.0
    SavedTime = Array{Float64}(NumSecs)
    BeginSecTic = time_ns()  #-- assume this is beginning second
    for i in 1:NumSecs
      if k == 1
        Libc.systemsleep(DesiredSleep)
      else
        sleep_ns(DesiredSleep)
      end

      EndSecTic = time_ns()
      ElapsedTime = (EndSecTic - BeginSecTic) / TicsPerSec
      DesiredSleep = (i + 1.) - ElapsedTime - OverheadSleepLoop
      SavedTime[i] = ElapsedTime
    end
    for i in 1:NumSecs
      @printf("ElapsedTime => %12.9f seconds\n", SavedTime[i])
    end
  end

  print("")
  return nothing
end
using AccurateSleep
