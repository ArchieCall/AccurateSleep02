#-- 10-20-2016
module AccurateSleep
function sleep_ns(SleepTime::AbstractFloat)
  #----- accurately block the current task for SleepTime (secs) ---------

  #------ constants ------------------------------------------------------
  const TicsPerSec = 1_000_000_000   #-- number of time tics in one sec
  const MinSleep = .000001000        #-- minimum allowed SleepTime (secs)
  const MaxSleep = 4.0               #-- maximum allowed SleepTime (secs)
  const BurnThreshold = .0019        #-- time reserved For burning (secs)
  const MinLibcSystemSleep = .0010   #-- min accuracy limit of Libc.systemsleep (secs)
  const DiffLimitLo = .00006         #-- normal diff error limit (secs)
  const DiffLimitHi = .00500         #-- excessive diff error limit (secs)
  const ShowErrors = false           #-- display error messages, if true (bool)
  const ShowDiffErrorsLo = false     #-- display error messages, if true (bool)
  const ShowDiffErrorsHi = true      #-- display error messages, if true (bool)
  const QuitOnDiffError = false      #-- quit Julia on Diff error, if true (bool)
  const QuitOnParmError = false      #-- quit Julia on Parm error, if true (bool)

  #----- get the initial time tic -------------------------------------------
  BegTic = time_ns()   #-- beginning time tic

  #----- validate that SleepTime is within min to max range -----------------
  ParmOK = true
  if SleepTime < MinSleep
    @printf("ParmError::  SleepTime: %10.9f is less than allowed min of %10.8f secs!!\n",
    SleepTime, MinSleep)
    ParmOK = false
  end
  if SleepTime > MaxSleep
    @printf("ParmError::  SleepTime: %12.1f is greater allowed max of %10.1f secs!!\n",
    SleepTime, MaxSleep)
    ParmOK = false
  end
  if !ParmOK
    #-- there is a parm error
    SleepOK = false
    if QuitOnParmError
      println("... Parm Error:  program halted.")
      quit()
    end
    return SleepOK  #-- exit function with false being returned
  end

  #----- compute the ending time tic ----------------------------------------
  SleepTimeTics0 = round(SleepTime * TicsPerSec)    #-- eliminate fractional tics
  SleepTimeTics = convert(UInt64, SleepTimeTics0)  #-- convert to UInt64
  EndTic = BegTic + SleepTimeTics      #-- time tic for breaking out of burn loop

  #----- calc how much time to sleep ----------------------------------
  TimeToSleep = 0.
  if SleepTime > BurnThreshold  #-- do not sleep if below the burn threshold
    TimeToSleep = SleepTime - BurnThreshold
  end

  #----- sleep if above the accuracy limit -----------------------------
  if TimeToSleep >= MinLibcSystemSleep
    Libc.systemsleep(TimeToSleep)  #-- sleep a portion of SleepTime
  end

  #----- burn off remaining time in while loop -------------------------
  CurrTic = time_ns()
  while true
    CurrTic >= EndTic && break  #-- break out, sleep is done
    CurrTic = time_ns()
  end

  #----- calc the diff ------------------------------------------------
  ActualSleep = (CurrTic - BegTic) / TicsPerSec  #-- actual time slept
  Diff = ActualSleep - SleepTime  #-- diff between Actual and Desired time
  SleepOK = true

  #----- test if diff is beyond limits ---------------------------------
  if Diff > DiffLimitLo
    SleepOK = false
    if ShowDiffErrorsLo
      #@show(Diff)
      #diffstop()
      if Diff < DiffLimitHi
        #-- lo diff error
        @printf("Error:  Wanted: %12.9f secs  Act: %12.9f secs  Diff: %12.9f secs\n", SleepTime, ActualSleep, Diff)
      end
    end
    if Diff > DiffLimitHi
      if ShowDiffErrorsHi
        #-- hi diff error
        println("====================== excessive sleep_ns diff!! ========================================")
        @printf("DiffLimit => %12.9f secs has been exceeded!\n", DiffLimitHi)
        @printf("Desired => %12.9f secs  Actual => %12.9f secs  Diff => %12.9f secs\n", SleepTime, ActualSleep, Diff)
        println("Your computer is currently slow, or 'Interrupt Timer Interval' is set too high.")
        println("Leaving the Chrome browser open, can maintain this timer at a lower level.")
        println("See the README.md for further information.")
        println("=====================================================================================")
      end
    end
    if QuitOnDiffError
      println("... Diff Error:  program halted.")
      quit()
    end
  end
  return SleepOK
end   #-- end of sleep_ns function

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
