#-- 10-14-2016
module AccurateSleep
function sleep_ns(sleep_time::AbstractFloat)
  const burn_time_threshold = .0019   #-- time in seconds that is reserved For burning
  const tics_per_sec = 1_000_000_000  #-- number of tics in one sec
  const min_systemsleep = .001    #-- Libc.systemsleep min value - (If used)
  const max_sleep = 86_400_000.   #-- 1000 day maximum
  const min_sleep = .000001000    #-- 1 microsecond minimum
  BegTic = time_ns()  #-- get beginning time tic
  AddedTics0 = round(sleep_time * tics_per_sec)
  AddedTics = convert(UInt64, AddedTics0)
  EndTic = BegTic + AddedTics  #-- final tic to equal or exceed in busy loop
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
    Libc.systemsleep(time_for_sleeping)  #-- sleep a portion of sleep_time
  end

  #------ burn off remaining time in busy loop
  CurrTic = time_ns()
  while true
    if CurrTic >= EndTic
      break
    end
    CurrTic = time_ns()
  end
  ActualSleepTime = (CurrTic - BegTic) / tics_per_sec
  Diff = ActualSleepTime - sleep_time

  if Diff > .005
    @printf("Interrupt timer is set too high!    Diff => %12.9f seconds\n", Diff)
    StoppedBecauseInterruptTimerSetTooHigh()
  end

  return nothing
end #-- end of sleep_ns
export sleep_ns
sleep(.001)  #--warmup
Libc.systemsleep(.001)  #--warmup
#sleep_ns(.001)  #--warmup
BenchmarkToolsInstalled = true
if Pkg.installed("BenchmarkTools") !== nothing
  BenchmarkToolsInstalled = true
  include("DemoSuite.jl")  #-- demo CDF's of sleep(), Libc.systemsleep(), sleep_ns
  include("DemoCDF.jl")  #-- demo CDF's of sleep(), Libc.systemsleep(), sleep_ns
  include("CheckCPUImpact.jl")  #-- demo CPU utilization
  include("CheckInterruptTimer.jl")  #-- check PIC
  include("Instructions.jl")  #-- check PIC
  include("ToyController.jl")  #-- check PIC
else
  BenchmarkToolsInstalled = false
  println("\nThe package: 'BenchmarkTools' is not installed!")
  println("\nTo run the Demo fucntions, this package must be installed.")
  println("Note: Calling only sleep_ns() does not require 'BenchmarkTools'.\n")
end
end #-- end of AccurateSleep module
