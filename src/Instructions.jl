function Instructions()
  println("")
  BasicUsage = false
  gdir = Pkg.dir("AccurateSleep")
  #SuiteName = gdir * "\\src\\" * "Instructions.txt"
  SuiteName = gdir * "\\README.md"
  f = open(SuiteName)
  lines = readlines(f)
  counter = 1
  for l in lines
    ll = chomp(l)
    if length(ll) >= 8
      l8 = ll[1:8]
      if l8 == "## Basic"
        BasicUsage = true
      end
      if l8 == "++++++++"
        BasicUsage = false
      end

    end
    if BasicUsage
      println(ll)
    end
    counter += 1
  end
  close(f)
  println("")
  println("Please see the full doc at http://github.com/ArchieCall/AccurateSleep")
  println("")
  sleep_ns(3.)
end
