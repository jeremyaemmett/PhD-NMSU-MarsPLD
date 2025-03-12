pro rename

  sims=FILE_SEARCH('./*RIC*',/TEST_DIRECTORY)

  for i=0,n_elements(sims)-1 do begin

    fort11s=(file_search(sims[i]+'/run/fort.11*'))
    fort45s=(file_search(sims[i]+'/run/fort.45*'))
    fort51s=(file_search(sims[i]+'/run/fort.51*'))
    fort91s=(file_search(sims[i]+'/run/fort.91*'))
    fnums=fix(strmid(fort11s,strlen(fort11s[-1])-4,4))
    missingidx=(where(fnums[indgen(n_elements(fnums))]-fnums[indgen(n_elements(fnums))-1] eq 2))[-1]
    fmissing=string(fnums[missingidx]-1)
    f11_missing=fort11s[missingidx]
    f45_missing=fort45s[missingidx]
    f51_missing=fort51s[missingidx]
    f91_missing=fort91s[missingidx]
    root11=strmid(f11_missing,0,strlen(f11_missing)-5)
    root45=strmid(f45_missing,0,strlen(f45_missing)-5)
    root51=strmid(f51_missing,0,strlen(f51_missing)-5)
    root91=strmid(f91_missing,0,strlen(f91_missing)-5)
    if fmissing lt 10 then ending=strcompress('_000'+fmissing,/remove_all)
    if fmissing ge 10 and fmissing lt 100 then ending=strcompress('_00'+fmissing,/remove_all)
    if fmissing ge 100 and fmissing lt 1000 then ending=strcompress('_0'+fmissing,/remove_all)
    if fmissing ge 1000 and fmissing lt 10000 then ending=strcompress('_'+fmissing,/remove_all)

    movefr11=root11
    movefr45=root45
    movefr51=root51
    movefr91=root91
    moveto11=strcompress(root11+ending,/remove_all)
    moveto45=strcompress(root45+ending,/remove_all)
    moveto51=strcompress(root51+ending,/remove_all)
    moveto91=strcompress(root91+ending,/remove_all)
    command11='mv '+movefr11+' '+moveto11
    command45='mv '+movefr45+' '+moveto45
    command51='mv '+movefr51+' '+moveto51
    command91='mv '+movefr91+' '+moveto91

    print,sims[i]
    if missingidx eq -1 then print,'Already renamed forts'
    if missingidx ne -1 then begin
      SPAWN,command11
      SPAWN,command45
      SPAWN,command51
      SPAWN,command91
      print,command11
      print,command45
      print,command51
      print,command91
    endif
    print,''

  endfor

end
