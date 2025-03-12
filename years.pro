pro years

pfe=1 & skip=0

;Specify the first and last record file number for reading
  fort11_1=168.
  fort11_2=168.

porb=16056.0

;sims=['O25_E0_Ncap','O25_E0_Scap','O25_E0_TMG','O25_E0_band','O25_E0_caps','O35_E0_Ncap','O35_E0_Scap','O35_E0_TMG','O35_E0_band','O35_E0_caps','O45_E0_Ncap','O45_E0_Scap','O45_E0_TMG','O45_E0_band','O45_E0_caps','PRES']

sims=['O15_E0_Ncap','O15_E0_Scap','O15_E0_TMG','O15_E0_band','O15_E0_caps']
sims=['PRES_AD_E0225_DDA1E10_albfeed04']
sims=['PRES_AD_E0225_DDA1E10_albfeed04']
sims=['PRES_E020_T0225_DDA1E10_RAC']
sims=['O35_RIC_CAP']

;Number of records that are expected to be read
  n_records=160.0*(fort11_2-fort11_1+1.0)

for sim=0,n_elements(sims)-1 do begin

path='./'+sims[sim]+'/run/'

;Declare variables
tau4=fltarr(1) & vpout4=fltarr(1) & rsdist4=fltarr(1) & tofday4=fltarr(1) & psf4=fltarr(1) & ptrop=fltarr(1)
tautot4=fltarr(1) & rptau4=fltarr(1) & sind4=fltarr(1) & gasp4=fltarr(1)
dxyp=fltarr(36) & grav=fltarr(1) & rgas=fltarr(24) & dsig4=fltarr(24)
p4=fltarr(36,60) & u4=fltarr(36,60,24) & v4=fltarr(36,60,24) & tausurf4=fltarr(36,60)
qcond4=fltarr(36,60,6) & qtrace4=fltarr(36,60,24,6)

;Declare Storage Arrays
  vpout4a=fltarr(n_records)
  lsa=fltarr(n_records)

;Determine the starting year
fnum=fix(fort11_1)
;Determine the name of the output file to read
if fnum eq 0 then file_extension=''
if fnum ge 1 then file_extension=string('_000',strtrim(fnum,1))
if fnum ge 10 then file_extension=string('_00',strtrim(fnum,1))
if fnum ge 100 then file_extension=string('_0',strtrim(fnum,1))
if fnum ge 1000 then file_extension=string('_',strtrim(fnum,1))
fort11=path+'fort.11'+file_extension & fort45=path+'fort.45'+file_extension
openr,2,fort11,/f77_unformatted
for rep=1,3 do readu,2
readu,2,tau4,vpout4,rsdist4,tofday4
for rep=1,11 do readu,2
close,2
year=fix(tau4/porb)

;Initialize 'counters' to zero
  count11=0

;Loop through the first to last desired output files
for fnum=fort11_1,fort11_2 do begin
  ;Determine the name of the output file to read
  if fnum eq 0 then file_extension=''
  if fnum ge 1 then file_extension=string('_000',strtrim(fix(fnum),1))
  if fnum ge 10 then file_extension=string('_00',strtrim(fix(fnum),1))
  if fnum ge 100 then file_extension=string('_0',strtrim(fix(fnum),1))
  if fnum ge 1000 then file_extension=string('_',strtrim(fix(fnum),1))
  fort11=path+'fort.11'+file_extension
  print,fort11

;Open the output file and read the header
  openr,2,fort11,/f77_unformatted
  readu,2
  readu,2,dsig4,dxyp,grav,rgas
  readu,2

;Read the 160 records in the output file
  for record_num=1,160 do begin
    readu,2,tau4,vpout4,rsdist4,tofday4,psf4,ptrop4,tautot4,rptau4,sind4,gasp4
    ;tau4=tau4-480.001
    readu,2
    readu,2
    readu,2
    readu,2
    readu,2
    for rep=1,15 do readu,2

    vpout4a[count11]=vpout4
    if vpout4a[count11] lt vpout4a[count11-1] then year=year+1
    lsa[count11]=vpout4+year*360.
    print,'Rec: ',record_num,' Ls: ',lsa[count11],' Year: ',(lsa[count11])/360.0,' Tau/Porb: ',tau4/porb,' Tau: ',tau4
    count11=count11+1

  endfor

  close,2

endfor

endfor

end
