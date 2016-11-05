#-- 01/05/2016
module AccurateSleep
function sleep_ns(SleepSecs::AbstractFloat)
  #----- accurately block the current task for specified SleepSecs
  #----- SleepSecs (secs) must be a float within MinSleepSecs to MaxSleepSecs
  #----- returns true or false: depending on accuracy of actual time slept

  #------ constants ------------------------------------------------------
  const TicsPerSec  = 1_000_000_000  #-- number of time tics in one sec
  const MinSleepSecs = .000001       #-- minimum allowed SleepSecs (secs)
  const MaxSleepSecs = 4.00000       #-- maximum allowed SleepSecs (secs)
  const BurnThreshold = .0019        #-- time reserved For burning (secs)
  const MinSystemSleepSecs = .0010   #-- accuracy limit of Libc.systemsleep (secs)
  const AllowSystemSleep = true      #-- if true, allow calls to SystemSleep (bool)
  const DiffOutlierLimit = .00006    #-- diffs above OutlierLimit occur about 1% of time (secs)
  const DiffErrorLimit = .00500      #-- diffs above ErrorLimit are unusual events (secs)
  const ShowDiffOutliers = false     #-- display DiffError msgs (bool)
  const ShowDiffErrors = false       #-- display DiffOutlier msgs (bool)
  const QuitOnDiffError = false      #-- quit Julia on diff ERROR (bool)
  const QuitOnParmError = false      #-- quit Julia on Parm error (bool)

  #----- get the initial time tic -------------------------------------------
  BegTic = time_ns()   #-- beginning time tic this a type UInt

  #----- validate that SleepSecs is within min to max range -----------------
  ParmOK = true
  if SleepSecs < MinSleepSecs
    @printf("ParmError::  SleepSecs: %10.9f is less than allowed min of %10.8f secs!!\n",
    SleepSecs, MinSleepSecs)
    ParmOK = false
  end
  if SleepSecs > MaxSleepSecs
    @printf("ParmError::  SleepSecs: %12.1f is greater than allowed max of %10.1f secs!!\n",
    SleepSecs, MaxSleepSecs)
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
  FloatTics = SleepSecs * TicsPerSec     #-- floating point tics for the sleep
  FloatTicsIntegral = round(FloatTics)   #-- round to integral float
  SleepTics = convert(UInt, FloatTicsIntegral)  #-- convert to UInt
  EndTic = BegTic + SleepTics      #-- UInt ending tic to break from burn loop


  if AllowSystemSleep  #-- is SystemSleep allowed?
    #----- calc how much time to systemsleep ----------------------------------
    SystemSleepSecs = 0.
    if SleepSecs > BurnThreshold  #-- do not sleep if below the burn threshold
      SystemSleepSecs = SleepSecs - BurnThreshold
    end
    #----- sleep, only if above the accuracy limit ------------------------------
    if SystemSleepSecs >= MinSystemSleepSecs
      Libc.systemsleep(SystemSleepSecs)  #-- sleep a portion of SleepTime
    end
  end

  #----- burn off remaining time in while loop -------------------------
  CurrTic = time_ns()
  while true
    CurrTic >= EndTic && break  #-- break out, sleep is done
    CurrTic = time_ns()
  end

  #----- calc the diff ------------------------------------------------
  ActualSleep = (CurrTic - BegTic) / TicsPerSec  #-- actual time slept
  Diff = ActualSleep - SleepSecs  #-- diff between Actual and Desired time
  SleepOK = true

  #----- test if diff is beyond limits ---------------------------------
  if Diff > DiffOutlierLimit
    SleepOK = false
    if ShowDiffOutliers
      if Diff < DiffErrorLimit
        #-- lo diff error
        @printf("Error:  Wanted: %12.9f secs  Act: %12.9f secs  Diff: %12.9f secs\n", SleepTime, ActualSleep, Diff)
      end
    end
    if Diff > DiffErrorLimit
      if ShowDiffErrors
        println("====================== excessive sleep_ns diff!! ========================================")
        @printf("DiffLimit => %12.9f secs has been exceeded!\n", DiffLimitHi)
        @printf("Desired => %12.9f secs  Actual => %12.9f secs  Diff => %12.9f secs\n", SleepSecs, ActualSleep, Diff)
        println("Your computer is currently slow, or 'Interrupt Timer Interval' is set too high.")
        println("Leaving the Chrome browser open in Windows, can maintain this timer at a lower level.")
        println("See the README.md for further information.")
        println("=========================================================================================")
        if QuitOnDiffError
          println("... Diff Error:  program halted.")
          quit()
        end
      end
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
  include("ThouSep.jl")  #-- insert comma separators into string
else
  BenchmarkToolsInstalled = false
  println("\nThe package: 'BenchmarkTools' is not installed!")
  println("\nTo run the Demo fucntions, this package must be installed.")
  println("Note: Calling only sleep_ns() does not require 'BenchmarkTools'.\n")
end
end #-- end of AccurateSleep module
