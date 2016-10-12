function ToyTimeStamp(NumSecs::Integer)
  const TicsPerSec = 1_000_000_000

  for k = 1:2
    if k == 1
      println("ToyTimeStamp for sleep")
    elseif
      println("ToyTimeStamp for sleep_ns")
    end

    DesiredSleep = 1.0
    SavedTime = Array{Float64}(NumSecs)
    BeginSecTic = time_ns()  #-- assume this is beginning second
    for i in 1:NumSecs
      if k == 1
        sleep(DesiredSleep)
      elseif
        sleep_ns(DesiredSleep)
      end

      EndSecTic = time_ns()
      ElapsedTime = (EndSecTic - BeginSecTic) / TicsPerSec
      DesiredSleep = (i + 1.) - ElapsedTime
      SavedTime[i] = ElapsedTime
    end
    for i in 1:NumSecs
      @printf("ElapsedTime => %12.9f\n", SavedTime[i])
    end
    next k

    print("")
    return nothing
  end
  using AccurateSleep
