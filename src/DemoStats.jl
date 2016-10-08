function DemoStats(sleep_time::AbstractFloat)
  TimerOK = AccurateSleep.CheckInterruptTimer()
  if TimerOK == false
    println("")
    println("The programmible interrupt timer resolution exceeds 15 milliseconds!")
    println(" ... accuracy of AccurateSleep is adversely affected.")
    println(" ... see the AccurateSleep doc for corrective measures.")
    println(" ... this is prevalent on the Windows OS.")
    println(" ... opening the Chrome browser may maintain appropriate resoution.")
    println("")
    return
  end
end
