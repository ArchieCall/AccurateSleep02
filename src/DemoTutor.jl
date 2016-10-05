function DemoTutor()
  println("DemoTutor v.Tutor005 dated 10-05-2016")
  println("")
  gdir = Pkg.dir("AccurateSleep")
  SuiteName = gdir * "\\src\\" * "Instructions.txt"
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
