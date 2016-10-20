# AccurateSleep



## AccurateSleep purpose
```
A package that provides an alternative sleep function:  sleep_ns().

This function is very similiar to the normal Julia sleep() function,
albeit with much improved accuracy.

The sleep_ns() function has an average error rate of .000003 seconds,
with only 5% of the errors exceeding .000002 seconds

In contrast: the regular sleep() function has an average error of .001150 seconds,
with 5% of the errors exceeding .002100 seconds

Use with caution!
```
## Basic usage of AccurateSleep commands
```
using AccurateSleep               :loads the Package
sleep_ns(secs)                    :sleeps accurately for # of secs
AccurateSleep.DemoSuite()         :showcases and contrasts sleep examples
AccurateSleep.DemoCPULoad()       :repetitive sleeping to evaulate CPU loads
AccurateSleep.Instructions()      :displays usage instructions
AccurateSleep.DemoCDF(secs, cycles, iters)     :computes CDF tables
```

### using AccurateSleep
```
loads AccurateSleep module to make available its functions
 ```

### sleep_ns(secs::AbstractFloat)
```
primary function within AccurateSleep
accurately sleeps specified secs and returns nothing
secs must be floating point - integers not allowed
secs must be in range of .000001 to 84_400_000.
sleep_ns(.5)                sleeps half second
sleep_ns(.000005)           sleeps 5 microseconds
sleep_ns(5.)                sleeps 5 seconds
sleep_ns(1)                 errors out - not float"
 ```

### AccurateSleep.DemoSuite()
```
runs script showcasing the accuracy of sleep_ns
 BenchmarkTools must be installed to provide the @benchmark macro
```

### AccurateSleep.DemoCDF(secs::AbstractFloat, cycles::Integer, iters::Integer)
```
produces a detailed CDF report comparing: sleep, Libc.systemsleep, and sleep_ns
if secs less than .001: systemsleep and sleep report bogus times of 10.000 secs
AccurateSleep.DemoCDF(.001, 3, 2000)           sleeps .001 secs over 3 cycles with 2000 iters
AccurateSleep.DemoCDF(.000001, 1, 10000)       sleeps .000003 secs for 1 cycle of 10000 iters
```

### AccurateSleep.DemoCPULoad()
```
grinder to evaluate CPU loading under various sleep scenarios
++++++++
```


### Installation
```
I apologise up front that this is not a package install.
I will get there once Github commands are wrapped in my mind!
```

**Method A: Manually install just the function sleep_ns()**
```julia
#-- copy and paste the contents of "sleep_ns.jl" into an appropriate location in your Julia application
#-- the contents are the sleep_ns() function
#-- no external packages are required

sleep_ns(.05)  #-- warm up sleep_ns
sleep_ns(.05)  #-- sleep accurately for .05 seconds

wanted_sleep = .002
actual_sleep = sleep_ns(wanted_sleep)
@show(wanted_sleep, actual_sleep)

#=  this is the output of above @show command
wanted_sleep => 0.002
actual_sleep => 0.002000409
=#

```
**Method B: Manually install demo file AccurateSleep.jl**
```julia
#-- download the file AccurateSleep.jl to your local computer

#-- the instruction below will run the demo application
include("c:\\ArchieJulia\\AccurateSleep.jl")  #-- revise the file location specific to your Julia installation

#-- the output should be similar to that in the SampleOutput folder on GitHub

```


-----------
### Table showing results for sample simulation
```
6,000 Samples comparing sleep(.005) and sleep_ns(.005)
DIFF => sleep(.005) - .005  or sleep_ns(.005) - .005
CDF => cumulative density function of DIFF
```

  Statistic            |   sleep(.005)           | sleep_ns(.005)                 
:-------------------:  |  :-------------------:  | :-----------------:
CDF 20.00 %            |  .001046 secs           |  .000001 secs
CDF 50.00 %            |  .001495 secs           |  .000001 secs
CDF 80.00 %            |  .001801 secs           |  .000001 secs
CDF 95.00 %            |  .002020 secs           |  .000001 secs
CDF 99.00 %            |  .002121 secs           |  .000023 secs
CDF 99.90 %            |  .002197 secs           |  .000165 secs
CDF 99.99 %            |  .003201 secs           |  .000233 secs
Mean sleep             |  .006366 secs           |  .005001 secs
Maximum sleep          |  .008201 secs           |  .005233 secs
Minimum sleep          |  .006366 secs           |  .005001 secs
Mean sleep DIFF        |  .001343 secs           |  .000002 secs


----------
## Use cases
* use sleep_ns() whenever sleep() is not accurate enough for your purposes
* call a function on a precise interval
* syncrhonize some action to a real time process or clock
* produce timestamps or tokens on some frequency

-------------
## How sleep_ns() works
  * upon examining sleep()
    * the time slept is always greater than the specified time
    * average error of the sleep is about .00150 second
    * 99+% of the errors were found to be less than .00230 seconds
  * a constant is defined: const burn_time = .00230  #-- in seconds
  * assume a sleep_time of .00800 seconds
  * the call to the function is:  sleep_ns(.00800)
  * an initial nanosecond time taken: nano1 = time_ns()
  * the function initially subtracts off the burn_time as follows:
  *   partial_sleep_time = .00800 - burn_time  #-- computes to .00570 seconds
  *   sleep(partial_sleep_time)  #--sleeps off .00570 sec
  * when this sleep is done the actual time elapsed will almost always be between .00570 seconds and .00800 seconds
  * if the elapsed time is greater than or = to .00800, then sleep_ns() is done
  * if the elapsed time is less than .00800 then a burn cycle is required
  * burn cycle is a simple while loop that
    * computes elapsed time: delta = (time_ns() - nano1) / 1_000_000_000.
    * if delta equal or exceeds .00800 then, sleep_ns() is done
  * delta returned is returned

-----------
## how sleep_ns works better explanation
* SleepTime is the desired sleep time in seconds
* BurnThreshold is a constant of .0019 seconds
* MinLibcSystemSleep is a constant of .0010 seconds
* DiffLimitLo is a constant of .00006 seconds
* DiffLimitHi is a constant of .00500 seconds
* TicsPerSec is a constant of 1_000_000_000
* BegTic = time_ns()   #-- gets beginning time tic
* SleepTimeTics = SleepTime * TicsPerSec
* EndTic = BegTic + SleepTimeTics
* TimeToSleep = SleepTime - BurnThreshold
* if TimeToSleep >= MinLibcSystemSleep then
 * Libc.systemsleep(TimeToSleep)  #-- sleep a fraction of SleepTime
* CurrTic = time_ns()  #-- get current time tic in while loop
* break out of while loop when CurrTic >= EndTic
* ActualSleepTime = (CurrTic - BegTic) / TicsPerSec
* Diff = ActualSleepTime - SleepTime
* if Diff > DiffLimitLo then return false
* if Diff > DiffLimitHi then print a limit error message and return false

-------------
## sleep_ns function
```Julia
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
  const ShowDiffErrorsLo = true     #-- display error messages, if true (bool)
  const ShowDiffErrorsHi = true     #-- display error messages, if true (bool)
  const QuitOnDiffError = false      #-- quit on Diff error, if true (bool)
  const QuitOnParmError = false      #-- quit on Parm error, if true (bool)

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
  #-- AddedTics represent SleepTime
  AddedTics1 = round(SleepTime * TicsPerSec)    #-- eliminate fractional tics
  AddedTics2 = convert(UInt64, AddedTics1)      #-- convert to UInt64
  EndTic = BegTic + AddedTics2      #-- time tic for breaking out of burn loop

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

```


## CPU loading when using sleep_ns
* the sleep(partial_sleep_time) portion of sleep_ns() has zero impact on loading
* the burn cycle of sleep_ns() has an impact on cpu loading
* on my Windows 10 Core i5 laptop running Julia 3.11, I found that the burn cycle maxed out at 29% CPU loading
  * the 29% loading on my computer is predicated on the number of cores and the standard settings on Windows 10
  * if the Affinity and Priority were revised for sleep_ns(), then the loading might be mitigated somewhat
  * I'm not familiar with how Linux handles such matters, but anything that throttles a process would be of benefit
* the burn_time threshold of .00230 seconds defines where burning begins
* if the sleep_time is less than .00230, then burning applies all the time
* if the sleep_time is greater than .00230, then the sleep is a hybrid of sleep and burn
* the greater the sleep_time in relation to burn_time the less the impact on loading
* for example, at sleep_time = .00800 seconds, the impact on cpu loading is 4%, while at .00400 seconds the loading is 12%


***The impact of sleep_ns on computer cpu loading is summarized below***

 sleep_time   |        cpu load  
 -----------  |        --------  
  .0900 secs  |         0.1 %
  .0500 secs  |         0.1 %    
  .0400 secs  |         0.9 %
  .0300 secs  |         1.2 %
  .0200 secs  |         1.5 %
  .0100 secs  |         2.5 %
  .0090 secs  |         3.5 %
  .0070 secs  |         4.5 %
  .0060 secs  |         4.9 %
  .0050 secs  |         6.0 %
  .0040 secs  |         8.5 %
  .0035 secs  |        12.0 %
  .0030 secs  |        12.0 %
  .0029 secs  |        22.0 %
  .0028 secs  |        22.0 %
  .0027 secs  |        22.0 %
  .0026 secs  |        25.0 %
  .0025 secs  |        25.0 %
  .0023 secs  |        25.0 %
  .0020 secs  |        25.0 %
  .0010 secs  |        25.0 %
  .0001 secs  |        25.0 %


-----------
### Importance of warm up operations
```
sleep_ns() and other functions calling sleep_ns() should be warmed up for accurate sleeping
```
------------------------
### sleep() allocates an additional 392 bytes for each call
```
The standard julia sleep() function incrmentally adds 392 bytes each time it is called.
I do not know the reason why? Possibly it is part and parcel of the ccall operation!

Since sleep-ns() makes use of sleep(), this extra alloction follows thru to each sleep_ns() call
whenever the sleep_time is in excess of .0023000 seconds.
```

## Possible use of sleep_ns in parallel operation
```
  There are areas of parallel operations that use polling.

  I have examined some of these and it seems that the poll timing is only accurate
  to about 1.5 milliseconds which is similiar to sleep().

  Potentially some of this polling or waiting could be augmented with sleep_ns().
  Of course, such a revision would need to be weighed against increased CPU loading!
```


## To-Do
* learn enough GitHub commands to create registered Julia package
* create AccurateSleep as a registered package
* investigate C instructions that are NOP and take up predictable time but not CPU load??





[![Build Status](https://travis-ci.org/ArchieCall/AccurateSleep.jl.svg?branch=master)](https://travis-ci.org/ArchieCall/AccurateSleep.jl)

[![Coverage Status](https://coveralls.io/repos/ArchieCall/AccurateSleep.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/ArchieCall/AccurateSleep.jl?branch=master)

[![codecov.io](http://codecov.io/github/ArchieCall/AccurateSleep.jl/coverage.svg?branch=master)](http://codecov.io/github/ArchieCall/AccurateSleep.jl?branch=master)
