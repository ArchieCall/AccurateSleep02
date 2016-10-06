function CheckInterruptTimer()
  TimerWaitValid = true
  TicsPerSec = 1_000_000_000.
  t1 = time_ns()
  sleep(.001)
  t2 = time_ns()
  SingleSleepTime = (t2-t1)/TicsPerSec
  @printf("SingleSleepTime => %11.9f \n", SingleSleepTime)

  for o = 1:10
    for i = 1:50
      #sleep(.001)
    end
  end
end
