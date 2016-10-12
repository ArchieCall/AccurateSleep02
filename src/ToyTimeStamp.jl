function ToyTimeStamp(NumSecs::Integer)
  const TicsPerSec = 1_000_000_000
  DesiredSleep = 1.0
  SavedTime = Array{Float64}(NumSecs)
  BeginSecTic = time_ns()  #-- assume this is beginning second
  for i in 1:NumSecs
    sleep_ns(DesiredSleep)
    EndSecTic = time_ns()
    ElapsedTime = (EndSecTic - BeginSecTic) / TicsPerSec
    DesiredSleep = (i + 1.) - ElapsedTime
    SavedTime[i] = ElapsedTime
  end
  for i in 1:NumSecs
    @printf("ElapsedTime => %12.9f\n", SavedTime[i])
  end

  print("")
  return nothing
end
using AccurateSleep
ToyTimeStamp(2)
ToyTimeStamp(60)
