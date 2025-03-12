pro warmstart

  sims=FILE_SEARCH('./*RIC*',/TEST_DIRECTORY)
  for i=0,n_elements(sims)-1 do begin
    cd, sims[i]+'/run'

    f1=fltarr(1)
    tau4=f1 & vpout4=f1 & rsdist4=f1 & tofday4=f1
    fort11=(file_search('./fort.11*'))[-1]
    fort45=(file_search('./fort.45*'))[-1]
    fort51=(file_search('./fort.51*'))[-1]
    fort91=(file_search('./fort.91*'))[-1]
    fnum=fix(strmid(fort11,8,4))
    ;Determine the name of the output file to read
      if fnum eq 0 then file_extension=''
      if fnum ge 1 then file_extension=string('_000',strtrim(fnum,1))
      if fnum ge 10 then file_extension=string('_00',strtrim(fnum,1))
      if fnum ge 100 then file_extension=string('_0',strtrim(fnum,1))
      if fnum ge 1000 then file_extension=string('_',strtrim(fnum,1))
      fort11='fort.11'+file_extension & fort45='fort.45'+file_extension
    ;Open the output file and read the header
      openr,2,fort11,/f77_unformatted
      readu,2
      readu,2
      readu,2
    ;Read the first record in the output file
      readu,2,tau4,vpout4,rsdist4,tofday4
      close,2

    file1='mars'
    file2='restart'
    file_lines=file_lines(file1)

    openr,lun,file1,/get_lun
    array=''
    line=''
    while not eof(lun) do begin
      readf,lun,line
      array=[array,line]
    endwhile
    free_lun,lun

    tauih_line=array[49]
    print,tauih_line
    print,'  ->'
    mod_tauih_line=strmid(tauih_line,0,strpos(tauih_line,'tauih = '))+strmid(tauih_line,strpos(tauih_line,'tauih = '),8)+strcompress(string(tau4),/remove_all)
    print,mod_tauih_line
    array[49]=mod_tauih_line

    print,''

    rsetsw_line=array[50]
    print,rsetsw_line
    print,'  ->'
    mod_rsetsw_line=strmid(rsetsw_line,0,strpos(rsetsw_line,'rsetsw = '))+strmid(rsetsw_line,strpos(rsetsw_line,'rsetsw = '),8)+' 0'
    print,mod_rsetsw_line
    array[50]=mod_rsetsw_line

    openw,lun,file2,/get_lun
    for j=0,file_lines do begin
      if j gt 0 then printf,lun,array[j]
    endfor
    free_lun,lun

    SPAWN,'mkdir ../warmfiles'
    print,string('cp ',fort11,' ../warmfiles')
    SPAWN,string('cp ',fort11,' ../warmfiles')
    print,string('cp ',fort45,' ../warmfiles')
    SPAWN,string('cp ',fort45,' ../warmfiles')
    print,string('cp ',fort51,' ../warmfiles')
    SPAWN,string('cp ',fort51,' ../warmfiles')
    print,string('cp ',fort91,' ../warmfiles')
    SPAWN,string('cp ',fort91,' ../warmfiles')
    print,string('mv ',fort11,' fort.11')
    SPAWN,string('mv ',fort11,' fort.11')
    print,string('mv ',fort45,' fort.45')
    SPAWN,string('mv ',fort45,' fort.45')
    print,string('mv ',fort51,' fort.51')
    SPAWN,string('mv ',fort51,' fort.51')
    print,string('mv ',fort91,' fort.91')
    SPAWN,string('mv ',fort91,' fort.91')

    SPAWN,'cp ../../GCM_script_warm.pbs .'
    print,''
    SPAWN,'pwd'
    print,sims[i]
    SPAWN,'qsub -q long GCM_script_warm.pbs'
    print,'--------------------------------------------------------------'
    cd, '../..'

  endfor

end
