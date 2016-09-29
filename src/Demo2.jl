function Demo2(desired_sleep, numcycles, numloops)
  #--updated  09-28-2016
  smean1 = 0.
  smean2 = 0.
  smean3 = 0.
  maxBin1 = 0.
  maxBin2 = 0.
  maxBin3 = 0.
  for cy in 1:numcycles
    DiffArray1 = zeros(AbstractFloat, numloops)
    DiffArray2 = zeros(AbstractFloat, numloops)
    DiffArray3 = zeros(AbstractFloat, numloops)
    nanosecond = 1_000_000_000.
    overhead_time_ns = .000000038  #--- timing overhead for two time_ns() calls
    sum1 = 0.
    sum2 = 0.
    sum3 = 0.
    max_diff1 = 0.
    max_diff2 = 0.
    max_diff3 = 0.
    sleep_time = desired_sleep
    for i in 1:numloops

      begtime = time_ns()
      sleep_ns(sleep_time)
      endtime = time_ns()
      actual_sleep_time = (endtime - begtime) / nanosecond

      diff_sleep_time = abs(actual_sleep_time - sleep_time)
      DiffArray1[i] = diff_sleep_time
      sum1 += diff_sleep_time
      if diff_sleep_time > max_diff1
        max_diff1 = diff_sleep_time
      end

      #-- sleep()
      begtime = time_ns()
      sleep(sleep_time)
      endtime = time_ns()
      actual_sleep_time = (endtime - begtime) / nanosecond
      #actual_sleep_time -= overhead_time_ns  #-- substract off timing overhead
      diff_sleep_time = abs(actual_sleep_time - sleep_time)
      DiffArray2[i] = diff_sleep_time
      sum2 += diff_sleep_time
      if diff_sleep_time > max_diff2
        max_diff2 = diff_sleep_time
      end

      #-- Libc.systemsleep()
      begtime = time_ns()
      Libc.systemsleep(sleep_time)
      endtime = time_ns()
      actual_sleep_time = (endtime - begtime) / nanosecond
      #actual_sleep_time -= overhead_time_ns  #-- substract off timing overhead
      diff_sleep_time = abs(actual_sleep_time - sleep_time)
      DiffArray3[i] = diff_sleep_time
      sum3 += diff_sleep_time
      if diff_sleep_time > max_diff3
        max_diff3 = diff_sleep_time
      end
    end

    DiffSort1 = sort(DiffArray1)  #-- sort diff times
    DiffSort2 = sort(DiffArray2)
    DiffSort3 = sort(DiffArray3)
    CDF_levels = [99.99, 99.95, 99.90, 99., 98., 95., 90., 80., 50., 20., 10., 5., 1., .10, .05, .01]
    level_cnt = length(CDF_levels)
    CDF_diff1 = zeros(AbstractFloat, level_cnt)
    CDF_diff2 = zeros(AbstractFloat, level_cnt)
    CDF_diff3 = zeros(AbstractFloat, level_cnt)

    #--- do not print out for long run
    TheDateTime = string(now())
    println("")
    @printf("======== %s ===== Cycle %i of %i =====================================================\n", TheDateTime, cy, numcycles)
    @printf("  Iters =>%6i    DesiredSleep => %11.9f\n", numloops, sleep_time)
    println("  ActualSleep => actual time slept by each of the three methods")
    println("  DifferentialSleep => abs(ActualSleep - DesiredSleep)")
    println("==========================================================================================================")
    println("                ---------- ActualSleep (secs) -----------       -------- DifferentialSleep (secs) ------- ")
    println("  CDF Level     sleep_ns         sleep        systemsleep       sleep_ns         sleep        systemsleep ")
    println("==========================================================================================================")


    for l = 1:level_cnt
      floatbin = CDF_levels[l] * numloops / 100
      bin = convert(Int, round(floatbin))
      if bin < 1
        bin = 1
      end
      CDF_diff1[l] = DiffSort1[bin]
      CDF_diff2[l] = DiffSort2[bin]
      CDF_diff3[l] = DiffSort3[bin]

      # do not print out for long runs
      d1 = CDF_diff1[l]
      d2 = CDF_diff2[l]
      d3 = CDF_diff3[l]
      a1 = sleep_time + d1
      a2 = sleep_time + d2
      a3 = sleep_time + d3
      @printf("   %6.2f    %12.9f    %12.9f    %12.9f    %12.9f    %12.9f    %12.9f\n", CDF_levels[l], a1, a2, a3 , d1, d2, d3)
    end
    mean1 = sum1/numloops
    mean2 = sum2/numloops
    mean3 = sum3/numloops
    scoef = .05
    if cy == 1
      maxBin1 = CDF_diff1[1]
      maxBin2 = CDF_diff2[1]
      maxBin3 = CDF_diff3[1]
      smean1 = mean1
      smean2 = mean2
      smean3 = mean3
    else
      smean1 = (scoef * mean1) + ((1. - scoef) * smean1)
      smean2 = (scoef * mean2) + ((1. - scoef) * smean2)
      smean3 = (scoef * mean3) + ((1. - scoef) * smean3)
      if CDF_diff1[1] > maxBin1
        maxBin1 = CDF_diff1[1]
      end
      if CDF_diff2[1] > maxBin2
        maxBin2 = CDF_diff2[1]
      end
      if CDF_diff3[1] > maxBin3
        maxBin3 = CDF_diff3[1]
      end
    end
    st = sleep_time
    a1 = st + mean1
    a2 = st + mean2
    a3 = st + mean3
    sa1 = st + smean1
    sa2 = st + smean2
    sa3 = st + smean3
    xa1 = st + maxBin1
    xa2 = st + maxBin2
    xa3 = st + maxBin3
    @printf("     Mean    %12.9f    %12.9f    %12.9f    %12.9f    %12.9f    %12.9f\n", a1,a2,a3, mean1, mean2, mean3  )
    @printf("  ExpMean    %12.9f    %12.9f    %12.9f    %12.9f    %12.9f    %12.9f\n", sa1, sa2, sa3, smean1, smean2, smean3)
    @printf(" Max99.99    %12.9f    %12.9f    %12.9f    %12.9f    %12.9f    %12.9f\n", xa1, xa2, xa3, maxBin1, maxBin2, maxBin3)
    println("=========================================================================================================")
  end
end
