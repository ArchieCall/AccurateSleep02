function CheckInterruptTimer()
  IsTimerValid = true
  TicsPerSec = 1_000_000_000.

  MaxTime = 0.
  MinTime = 999.
  SumTime = 0.
  NumIters = 50
  WantedSleep = .001
  t1 = time_ns()
  sleep(WantedSleep) #--- dummy call to sleep to warm it up
  t2 = time_ns()
  SleepTime = (t2-t1)/TicsPerSec
  if SleepTime < .0027
    return  IsTimerValid   #-- passes muster on a single check
  end
  sleep(WantedSleep) #--- dummy call to sleep to warm it up
  sleep(WantedSleep) #--- dummy call to sleep to warm it up
  sleep(WantedSleep) #--- dummy call to sleep to warm it up
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
  if MeanDiff > .0017
    IsTimerValid = false
  end
  if MaxDiff > .0090
    IsTimerValid = false
  end

  if IsTimerValid == false  #-- only print stats if false
    println("")
    println("...  Desired sleep time of .001 seconds has failed! ...")
    @printf("MeanTime => %11.9f   MeanTimeDiff => %11.9f \n", MeanTime, MeanDiff)
    @printf("MaxTime  => %11.9f   MaxDiff      => %11.9f \n", MaxTime, MaxDiff)
    @printf("MinTime  => %11.9f   MinDiff      => %11.9f \n", MinTime, MinDiff)
    println("")
    sleep(.1)  #-- allow time for print to complete
  end
  return IsTimerValid
end
