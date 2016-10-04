function DemoTutor()
  println("DemoTutor v.Tutor006 dated 10-03-2016")

  println("")
  gdir = Pkg.dir("AccurateSleep")

  SuiteName = gdir * "\\src\\" * "DemoSuite.jl"
  f = open(SuiteName)
  lines = readlines(f)
  counter = 1
  for l in lines
     ll = chomp(l)
     println(ll)
     counter += 1
  end
  close(f)
  AccurateSleep.DemoSuite()

end
