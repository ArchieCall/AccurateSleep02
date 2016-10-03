function DemoTutor()
  println("DemoTutor v.Tutor005 dated 10-02-2016")

  println("")
  currworkdir = pwd()
  homedir1 = homedir()
  gdir = Pkg.dir("AccurateSleep")
  BenchmarkInstalled = Pkg.status("BenchmarkTools")
  @show(BenchmarkInstalled)
  BenchmarkInstalledBad = Pkg.status("BenchmarkToolsBad")
  @show(BenchmarkInstalledBad)
  snot()
  if BenchmarkInstalled == nothing
    println("BenchmarkTools is not installed")
    whoaNotOK()
  end
  whoaOK()
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
