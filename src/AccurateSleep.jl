module AccurateSleep
#-- Updated: 09-29-2016
println("AccurateSleep v.10 dated 09-30-2016")


function sleep_ns(sleep_time::Float64)
  #-- start of funtion
  const burn_time_threshold = .0019   #-- time in seconds that is reserved todo burning
  const tics_per_sec = 1_000_000_000.  #-- number of tics in one sec
  const min_systemsleep = .001    #-- Libc.systemsleep to be less than this value
  const max_sleep = 86_400_000.   #-- 1000 day maximum
  const min_sleep = .000001000    #-- 1 microsecond minimum
  nano1 = time_ns()  #-- get beginning time tic
  nano2 = nano1 + (sleep_time * tics_per_sec)  #-- final time tic that needs to be exceeded
  #-- validate the value of sleep_time
  if sleep_time < min_sleep
    @printf("parameter error:  sleep_time => %10.8f is less than %10.8f secs!!\n",
    sleep_time, min_sleep)
    println("program halted.")
    SpecifiedSleepTooLow()
  end

  if sleep_time > max_sleep
    @printf("parameter error:  sleep_time => %12.1f is greater than %10.1f secs!!\n",
    sleep_time, max_sleep)
    println("program halted.")
    SpecifiedSleepTooHigh()
  end

  #--- calc sleeping time
  time_for_sleeping = 0.

  if sleep_time > burn_time_threshold
    time_for_sleeping = sleep_time - burn_time_threshold
  end

  if time_for_sleeping >= min_systemsleep
    Libc.systemsleep(time_for_sleeping)
  end

  #------ burn_time off time left after core sleep
  while true
    time_ns() >= nano2 && break
  end
  return nothing
end #-- end of sleep_ns

#include("Demo1.jl")  #-- demo
include("Demo2.jl")  #-- demo CDF's of sleep(), Libc.systemsleep(), sleep_ns
include("Demo3.jl")  #-- demo CPU utilization
export sleep_ns
end #-- end of AccurateSleep
#WantedSleep = .002000000
#AccurateSleep.Demo2(WantedSleep, 1, 5000) #--- actual

#WantedTime = .002000000
#AccurateSleep.Demo3(30, WantedTime) #--- actual

#println("all done")
