function DemoTutor()
  println("DemoTutor v.Tutor005 dated 10-02-2016")
  println("================================================================")
  println("           Usage of AccurateSleep and sleep_ns")
  println("================================================================")
  println("")
  println(" using AccurateSleep                     ")
  println(" ---------------------------------------------------------------")
  println("  ... loads AccurateSleep package so its functions can be used ...")
  println("")
  println(" AccurateSleep.DemoTutor()")
  println(" ---------------------------------------------------------------")
  println("  ... runs this tutorial ...")
  println("")
  println(" sleep_ns(SleepSecs::AbstractFloat)")
  println(" ---------------------------------------------------------------")
  println("    ... primary Function within AccurateSleep ...")
  println("    ... accurately sleeps specified SleepSecs ...")
  println("    sleep_ns(.5)                   : sleeps half second")
  println("    sleep_ns(.000005)              : sleeps 5 microseconds")
  println("    sleep_ns(5.)                   : sleeps 5 seconds")
  println("    sleep_ns(1)                    : errors out - not float")
  println("")
  println(" AccurateSleep.Demo1() ")
  println(" ---------------------------------------------------------------")
  println("    ... runs simple script showcasing sleep_ns ...")
  println("")
  println(" AccurateSleep.Demo2(SleepSecs::AbstractFloat, NumCycles::Integer, NumIters::Integer) ")
  println(" -------------------------------------------------------------------------------------")
  println("    ... produces a detailed CDF report ...")
  println("    AccurateSleep.Demo2(.001, 3, 2000)      - sleeps .001 secs, 3 cycles, 2000 iters")
  println("    AccurateSleep.Demo2(.000001, 1, 10000)  - sleeps .000001 secs, 1 cycle, 10000 iters")
  println("")
  println(" AccurateSleep.Demo3(secs, DesiredSleep)")
  println(" ---------------------------------------------------------------")
  println("    ... grinder to evaluate CPU loading ...")
  println("")
  println(" ================================================================")
  println("            See the Package doc on Github  ")
  println("   https://github.com/ArchieCall/AccurateSleep  ")
  println(" ================================================================")
  println("")

  SuiteName = "c:\\Users\\Owner\\.julia\\v0.5\\AccurateSleep\\src\\DemoSuite.jl"


  open("SuiteName) do f
     line = 1
     while !eof(f)
       x = readline(f)
       xx = chomp(x)
       println("$xx")
       line += 1
     end
   end

end
