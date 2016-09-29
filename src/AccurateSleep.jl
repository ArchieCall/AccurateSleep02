module AccurateSleep
#-- Updated: 09-29-2016
println("in AccurateSleep - 108")

function sleep_ns(sleep_time::Float64)
  #=
  - Updated:  09-29-2016
  - Purpose: an accurate sleep function written totally in Julia
  - Parameter: sleep_time
  -- number of seconds to sleep
  -- must be floating point within range of .000005 to 86_400_000.
  - Hybrid solution
  -- burn_time_threshold setting of .0025 seconds evolved after simulations
  --   which evaluated trading off accuracy vs. cpu loading
  -- combines regular systemsleep() function with a final burn cycle
  -- regular sleep is simply (sleep_time - burn_time_threshold)
  -- remaining time after systemsleep() is burned off in a while loop
  -- timing is with time_ns()
  - Returns:  delta = actual elapsed time in seconds of the sleep
  - Accuracy
  -- sleep()       => .0012000 seconds
  -- systemsleep() => .0006500 seconds
  -- sleep_ns()    => .0000005 seconds
  - Timing functions called
  -- sleep()             - blocks current task for specified seconds
  -- Libc.systemsleep()  - blocks current task for specified seconds
  -- time_ns()           - nanosecond time since midnight
  =#
  const burn_time_threshold = .0019  #-- time in seconds that is reserved for burning
  const tics_per_sec = 1_000_000_000.  #-- number of tics from time_ns() for one second
  const tic_fuzz = .000000100  #-- smallest possible tic
  const min_systemsleep = .001 #-- do not allow a Libc.systemsleep to be less than this value
  const max_sleep = 86_400_000.  #-- 1000 days should be large enough
  const min_sleep = .000000500      #-- 5 microseconds - relates to accuracy of time_ns() and cycle rate of computer
  nano1 = time_ns()  #-- get beginning time tic
  nano2 = nano1 + ((sleep_time - tic_fuzz) * tics_per_sec)  #-- final time tic that needs to be exceeded

  #-- validate the value of sleep_time
  if sleep_time < min_sleep
    @printf("parameter error:  sleep_time => %10.8f must be greater than %10.8f secs!!\n", sleep_time, min_sleep)
    println("program halted.")
    SpecifiedSleepTooLow()
  end
  if sleep_time > max_sleep
    @printf("parameter error:  sleep_time => %12.1f must be less than %10.1f secs!!\n", sleep_time, max_sleep)
    println("program halted.")
    SpecifiedSleepTooHigh()
  end

  #--- calc sleeping time
  time_for_sleeping = 0.
  if sleep_time > burn_time_threshold
    time_for_sleeping = sleep_time - burn_time_threshold
  end
  #if time_for_sleeping > 0.
  if time_for_sleeping >= min_systemsleep
    Libc.systemsleep(time_for_sleeping)  #-- systemsleep
  end
  #------ burn_time off time left after core sleep
  nano3 = nano1 #-- make nano3 available out while loop

  while true
    nano3 = time_ns()  #-- actual elapsed time so far
    nano3 > nano2 && break #-- break from loop as if done
  end
  #act_sleep_time = (nano3 - nano1) / tics_per_sec
  return nothing   #-- return nothing
end  #-- End of sleep_ns() function
#include("Demo1.jl")  #-- demo
include("Demo2.jl")  #-- demo CDF's of sleep(), Libc.systemsleep(), sleep_ns
include("Demo3.jl")  #-- demo CPU utilization
export sleep_ns
end #-- end of module AccurateSleep

WantedSleep = .000001000
#AccurateSleep.Demo2(WantedSleep, 1, 10)   #--- warmup
AccurateSleep.Demo2(WantedSleep, 1, 2000) #--- actual

#WantedTime = .002000000
#AccurateSleep.Demo3(30, WantedTime) #--- actual

println("all done")
