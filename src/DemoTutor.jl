function DemoTutor()
  println("DemoTutor v.Tutor005 dated 10-02-2016")

  println("")
  currworkdir = pwd()
  homedir1 = homedir()
  @show(currworkdir)
  @show(homedir1)
  gdir = Pkg.dir("AccurateSleep")
  @show(gdir)
  dirdir = Pkg.dir()
  @show(dirdir)
  BenchmarkInstalled = Pkg.installed("BenchmarkTools")
  @show(BenchmarkInstalled)
  whoa()
  #SuiteName = "c:\\Users\\Owner\\.julia\\v0.5\\AccurateSleep\\src\\DemoSuite.jl"
  SuiteName = gdir * "\\src\\" * "DemoSuite.jl"
  f = open(SuiteName)

  lines = readlines(f)
  counter = 1
  for l in lines
     #println("$counter $l")
     ll = chomp(l)
     println(ll)
     #println("$l")
     counter += 1
  end
  close(f)
  AccurateSleep.DemoSuite()

end
