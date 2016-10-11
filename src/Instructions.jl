function Instructions()
  println("")
  gdir = Pkg.dir("AccurateSleep")
  #SuiteName = gdir * "\\src\\" * "Instructions.txt"
  SuiteName = gdir * "\\README.md"
  f = open(SuiteName)
  lines = readlines(f)
  counter = 1
  for l in lines
    ll = chomp(l)
    println(ll)
    counter += 1
  end
  close(f)
  sleep_ns(3.)
end
