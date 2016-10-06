function CheckInterruptTimer()
  IsTimerValid = true
  TicsPerSec = 1_000_000_000.


  MaxTime = 0.
  MinTime = 999.
  SumTime = 0.
  NumIters = 500
  WantedSleep = .001
  for i=1:NumIters
    t1 = time_ns()
    sleep(WantedSleep)
    t2 = time_ns()
    SleepTime = (t2-t1)/TicsPerSec
    SumTime += SleepTime
    if SleepTime > MaxTime
      MaxTime = SleepTime
    end
    if SleepTime < MinTime
      MinTime = SleepTime
    end

  end
  MeanTime = SumTime / NumIters
  MeanDiff = MeanTime - WantedSleep
  MaxDiff = MaxTime - WantedSleep
  MinDiff = MinTime - WantedSleep
  if MeanDiff > .00165
    IsTimerValid = false
  end
  if MaxDiff > .0055
    IsTimerValid = false
  end
  if IsTimerValid == false  #-- only print stats if false
    @printf("MeanTime => %11.9f   MeanTimeDiff => %11.9f \n", MeanTime, MeanDiff)
    @printf("MaxTime  => %11.9f   MaxDiff      => %11.9f \n", MaxTime, MaxDiff)
    @printf("MinTime  => %11.9f   MinDiff      => %11.9f \n", MinTime, MinDiff)
    sleep(.1)  #-- allow time for print to complete
  end
  return IsTimerValid
end
