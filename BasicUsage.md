```
================================================================
        Usage of AccurateSleep package and sleep_ns
================================================================
using AccurateSleep               :loads the Package
sleep_ns(secs)                    :sleeps accurately for # of secs
AccurateSleep.DemoSuite()         :showcases and contrasts sleep examples
AccurateSleep.DemoCPULoad()       :repetitive sleeping to evaulate CPU loads
AccurateSleep.Instructions()      :displays usage instructions
AccurateSleep.DemoCDF(secs, cycles, iters)     :computes CDF tables
```

```
    using AccurateSleep
---------------------------------------------------------------
    loads AccurateSleep package and its functions
 ```

```
    sleep_ns(secs::AbstractFloat)
------------------------------------------------------------------------------
 ... primary function within AccurateSleep
 ... accurately sleeps specified secs and returns nothing
 ... secs must be floating point - integers not allowed
 ... secs must be in range of .000001 to 84_400_000.
 sleep_ns(.5)                   : sleeps half second
 sleep_ns(.000005)              : sleeps 5 microseconds
 sleep_ns(5.)                   : sleeps 5 seconds
 sleep_ns(1)                    : errors out - not float"
 ```

```
    AccurateSleep.DemoSuite()
------------------------------------------------------------------------------
... outputs these instructions
... runs script showcasing the accuracy of sleep_ns
... BenchmarkTools must be installed to provide the @benchmark macro
```

```
    AccurateSleep.DemoCDF(secs::AbstractFloat, cycles::Integer, iters::Integer)
------------------------------------------------------------------------------
  ... produces a detailed CDF report comparing: sleep, Libc.systemsleep, and sleep_ns
  ...if secs less than .001: systemsleep and sleep report bogus times of 10.000 secs
  AccurateSleep.DemoCDF(.001, 3, 2000)           sleeps .001 secs over 3 cycles with 2000 iters
  AccurateSleep.DemoCDF(.000001, 1, 10000)       sleeps .000003 secs for 1 cycle of 10000 iters
```

```
    AccurateSleep.DemoCPULoad()
------------------------------------------------------------------------------
 ... grinder to evaluate CPU loading under various sleep scenarios
```

Please see (https://github.com/ArchieCall/AccurateSleep/master/README.md)
... full documentation in README.md
