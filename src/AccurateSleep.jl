#-- 10-17-2016
module AccurateSleep
function sleep_ns(SleepTime::AbstractFloat)
  #-- SleepTime is desired time to accurately sleep in seconds
  const TicsPerSec = 1_000_000_000   #-- number of tics in one sec
  const MinSleep = .000001000        #-- minimum allowed SleepTime (secs)
  const MaxSleep = 1_000_000.        #-- maximum allowed SleepTime (secs)
  const BurnThreshold = .0015        #-- time reserved For burning (secs)
  const MinLibcSystemSleep = .0010   #-- time below which Libc.systemsleep has no accuracy (secs)
  const DiffLimit = .00004           #-- error returned, if Diff above this limit (secs)
  const ShowErrors = false           #-- display error messages if true (bool)
  const QuitOnDiffError = false      #-- if true, quit on Diff error (bool)
  const QuitOnParmError = false      #-- if true, quit on Parm error (bool)

  BegTic = time_ns()   #-- get beginning time tic

  #-- validate the value of SleepTime
  ParmOK = true
  if SleepTime < MinSleep
    @printf("Parm Error:  SleepTime = %10.9f is less than allowed min of %10.8f secs!!\n",
    SleepTime, MinSleep)
    ParmOK = false
    #println("... program halted.")
    #quit()
  end
  if SleepTime > MaxSleep
    @printf("Parm Error:  SleepTime = %12.1f is greater allowed max of %10.1f secs!!\n",
    SleepTime, MaxSleep)
    ParmOK = false
    #println("... program halted.")
    #quit()
  end

  if ParmOK

    AddedTics0 = round(SleepTime * TicsPerSec)     #-- eliminate fractional tics
    AddedTics = convert(UInt64, AddedTics0)        #-- convert to UInt64
    EndTic = BegTic + AddedTics   #-- final tic to equal or exceed in burn loop

    #--- calc how much time to sleep
    TimeToSleep = 0.
    if SleepTime > BurnThreshold
      TimeToSleep = SleepTime - BurnThreshold
    end

    #-- only sleep if above the level where Libc.systemsleep has accuracy
    if TimeToSleep >= MinLibcSystemSleep
      Libc.systemsleep(TimeToSleep)  #-- sleep a portion of SleepTime
    end

    #------ burn off remaining time in a loop
    CurrTic = time_ns()
    while true
      if CurrTic >= EndTic  # break out of loop
        break
      end
      CurrTic = time_ns()
    end
    ActualSleep = (CurrTic - BegTic) / TicsPerSec  #-- actual time slept
    Diff = ActualSleep - SleepTime  #-- difference between
    SleepOK = true

    if Diff > DiffLimit
      SleepOK = false  #-- Diff is excessibe, return false
      if ShowErrors
        println("========================== sleep_ns error!! =========================================")
        @printf("DiffLimit => %12.9f secs has been exceeded!\n", DiffLimit)
        @printf("Desired => %12.9f secs  Actual => %12.9f secs  Diff => %12.9f secs\n", SleepTime, ActualSleep, Diff)
        println("Your computer is currently slow, or 'Interrupt Timer Interval' is set too high.")
        println("Leaving the Chrome browser open, can maintain this timer at a lower level.")
        println("See the README.md for further information.")
        println("=====================================================================================")
      end
      if QuitOnDiffError
        println("... Diff Error:  program halted.")
        quit()
      end
    end
  else
    #-- there is a parm error
    SleepOK = false
    if QuitOnParmError
      println("... Parm Error:  program halted.")
      quit()
    end
  end  #-- ParmOk check
  return SleepOK
end #-- end of sleep_ns function
export sleep_ns
sleep(.001)  #--warmup
Libc.systemsleep(.001)  #--warmup
BenchmarkToolsInstalled = true
if Pkg.installed("BenchmarkTools") !== nothing
  BenchmarkToolsInstalled = true
  include("DemoSuite.jl")  #-- demo CDF's of sleep(), Libc.systemsleep(), sleep_ns
  include("DemoCDF.jl")  #-- demo CDF's of sleep(), Libc.systemsleep(), sleep_ns
  include("CheckCPUImpact.jl")  #-- demo CPU utilization
  include("CheckInterruptTimer.jl")  #-- check PIC
  include("Instructions.jl")  #-- check PIC
  include("ToyController.jl")  #--
  include("ThouSep.jl")  #-- insert comma separators into string
else
  BenchmarkToolsInstalled = false
  println("\nThe package: 'BenchmarkTools' is not installed!")
  println("\nTo run the Demo fucntions, this package must be installed.")
  println("Note: Calling only sleep_ns() does not require 'BenchmarkTools'.\n")
end
end #-- end of AccurateSleep module
