function ThouSep(IntNumber::Integer)
  strnumber = string(IntNumber)
  maxlen = 13
  StrArray = Array{String}(maxlen)
  for k = 1:3
    cpos = (k-1) * 4 + 2
    StrArray[cpos] = ","
  end
  #@show(StrArray)
  lens = length(strnumber)
  cntchars = 0
  numcommas = 0
  ij = 0
  for i = 1:lens
    ii = lens - i + 1
    cookie = string(strnumber[ii])
    cntchars += 1
    ij = maxlen - i + 1 - numcommas
    StrArray[ij] = cookie
    if cntchars == 3
      numcommas += 1
      cntchars = 0
    end
  end
  thousepstr = ""
  for j = ij:maxlen
    thousepstr = thousepstr * StrArray[j]
  end
  return thousepstr
end
