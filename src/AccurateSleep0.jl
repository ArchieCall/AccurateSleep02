module AccurateSleep
#-- Updated: 09-29-2016
println("in AccurateSleep - 110")



function sleep_ns(sleep_time::Float64)




  const burn_time_threshold = .0019   #-- time in seconds that is reserved for burning
    const tics_per_sec = 1000000000.  #-- number of tics from time_ns() for one second
      const min_systemsleep = .001    #-- do not allow a Libc.systemsleep to be less than this value
      const max_sleep = 86_400_000.   #-- 1000 days should be large enough
      const min_sleep = .000000500    #-- 5 microseconds - relates to accuracy of time_ns() and cycle rate of computer
      nano1 = time_ns()  #-- get beginning time tic
      nano2 = nano1 + (sleep_time * tics_per_sec)  #-- final time tic that needs to be exceeded

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

      if time_for_sleeping >= min_systemsleep
        Libc.systemsleep(time_for_sleeping)
      end

        #------ burn_time off time left after core sleep
        #nano3 = nano1 #-- make nano3 available out while loop

        while true
          #nano3 = time_ns()  #-- actual elapsed time so far
          #nano3 >= nano2 && break #-- break from loop as if done
          time_ns() >= nano2 && break #-- break from loop as if done
          end
          #act_sleep_time = (nano3 - nano1) / tics_per_sec
          return nothing   #-- return nothing
        end  #-- End of sleep_ns() function
          #include("Demo1.jl")  #-- demo
          include("Demo2.jl")  #-- demo CDF's of sleep(), Libc.systemsleep(), sleep_ns
          include("Demo3.jl")  #-- demo CPU utilization
          export sleep_ns
        end #-- end of module AccurateSleep

        #WantedSleep = .002000000
        #AccurateSleep.Demo2(WantedSleep, 1, 10)   #--- warmup
        #AccurateSleep.Demo2(WantedSleep, 1, 1000) #--- actual
        #WantedTime = .002000000
        #AccurateSleep.Demo3(30, WantedTime) #--- actual

        println("all done")
