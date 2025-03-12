pro polarplots

sims=['O15_RIC_CAP','O20_RIC_CAP','O25_RIC_CAP','O30_RIC_CAP','O35_RIC_CAP','O15_RIC_MID','O20_RIC_MID','O25_RIC_MID','O30_RIC_MID','O35_RIC_MID','O40_RIC_CAP','O40_RIC_MID','O45_RIC_CAP','O45_RIC_MID','PRES_RIC']

sims=['O15_RIC_MID','O20_RIC_MID','O25_RIC_MID','O30_RIC_MID','O35_RIC_MID','O40_RIC_CAP','O40_RIC_MID','O45_RIC_CAP','O45_RIC_MID']

;Constants
   lat_dim=findgen(35)*5-85
   lon_dim=findgen(60)*(360.0/60.0)-180
   lon_dim[-1]=179.999
   j_array=(indgen(36,60)) mod 36
   porb=16056.0

for sim=0,n_elements(sims)-1 do begin

  print,sims[sim]

;Specify the first and last record file number for reading
   fort11_1=25.
   fort11_2=42.

   year1=4
   year2=5

;Number of records that are expected to be read
   n_records=160*(fort11_2-fort11_1+1)

  path='./'+sims[sim]+'/run/'

   f1=fltarr(1) & f2=fltarr(24) & f3=fltarr(36,60) & f4=fltarr(36,60,6) & f5=fltarr(36,60,24) & f6=fltarr(36,60,24,6) & f7=fltarr(36)
;Declare Variables
   tau4=f1 & vpout4=f1 & rsdist4=f1 & tofday4=f1 & psf4=f1 & ptrop4=f1 & tautot4=f1 & rptau4=f1 & sind4=f1 & gasp4=f1 & grav=f1 & rgas=f1
   dsig4=f2
   p4=f3 & co2ice4=f3 & tausurf4=f3 & tinterp=f3 & gt4=f3 & stemp4=f3 & stressx4=f3 & stressxy=f3 & topog4=f3 & alsp4=f3 & zin4=f3
   qcond4=f4 & prm=f4 & srfupflx4=f4 & srfdnflx4=f4 & srfupflx_dd4=f4
   t4=f5 & u4=f5 & v4=f5 & recordpk4a=f5
   qtrace4=f6
   dxyp=f7
   qcond4_1=f4 & qcond4_2=f4

   f1a=fltarr(n_records) & f3a=fltarr(36,60,1.1*n_records) & f4a=fltarr(36,60,6,n_records)
   gasp4a=f1a & vpout4a=f1a & year_array=f1a & lsa=f1a & meantausurf4a=f1a & tofday4a=f1a
   co2ice4a=f3a & tausurf4a=f3a & p4a=f3a & stemp4=f3a & gt4a=f3a & psf4a=f3a
   qcond4a=f4a & prma=f4a & srfupflx4a=f4a & srfdnflx4a=f4a & srfupflx_dd4a=f4a

;Initialize 'counters' to zero
;'year' counts up one at the beginning of each Mars year
;'count11' counts up one at the beginning of each record
;'season_count' counts up one at the beginning of each season
   year=0
   count11=0

print,'Reading fort.11 files'

;Loop sequentially from the first to the last desired fort.11 output file
for fnum=fort11_1,fort11_2,1. do begin
	;Determine the name of the output file to read
	   if fnum eq 0 then file_extension=''
	   if fnum ge 1 then file_extension=string('_000',strtrim(fix(fnum),1))
	   if fnum ge 10 then file_extension=string('_00',strtrim(fix(fnum),1))
	   if fnum ge 100 then file_extension=string('_0',strtrim(fix(fnum),1))
           if fnum ge 1000 then file_extension=string('_',strtrim(fix(fnum),1))
	   fort11=path+'fort.11'+file_extension & fort45=path+'fort.45'+file_extension
	   print,fort11

	;Open the output file and read the header
	   openr,2,fort11,/f77_unformatted
	   readu,2
	   readu,2,dsig4,dxyp,grav,rgas
	   readu,2,topog4,alsp4,zin4

	;Read the 160 records in the output file and calculate and/or store desired quantities in arrays
	   for record_num=1,160 do begin
		   readu,2,tau4,vpout4,rsdist4,tofday4,psf4,ptrop4,tautot4,rptau4,sind4,gasp4
                   readu,2
                   readu,2,p4
                   readu,2
                   readu,2,u4
                   readu,2,v4
		   readu,2,gt4
                   readu,2,co2ice4
                   readu,2,stressx4
                   readu,2,stressy4
                   readu,2
                   readu,2,tausurf4
                   readu,2
                   readu,2,qtrace4
		   readu,2,qcond4
                   readu,2
                   readu,2,fuptopv,fdntopv,fupsurfv,fdnsurfv
                   readu,2,fuptopir,fupsurfir,fdnsurfir
		   for rep=1,3 do readu,2

		   if count11 eq 0 then year=fix(tau4/porb)
		   vpout4a[count11]=vpout4
		   if vpout4a[count11]-vpout4a[count11-1] lt 0 then year=year+1
		   lsa[count11]=vpout4+360.0*year
                   tofday4a[count11]=tofday4
                   qcond4a[*,*,*,count11]=qcond4[*,*,*]

                   if vpout4a[count11]-vpout4a[count11-1] lt 0 and year eq year1 then begin
                     print,'NEW YEAR'
                     qcond4_1=qcond4
                   endif
                   if vpout4a[count11]-vpout4a[count11-1] lt 0 and year eq year1+1 then begin
                     print,'NEW YEAR'
                     qcond4_2=qcond4
                   endif
                   if record_num eq 1 then print,lsa[count11] mod 360.0,year

                   count11=count11+1
	   endfor ;record
	close,2
endfor ;fort

print,'READING 45'

count45=0
;Loop through the first to last desired output files
for fnum=fort11_1,fort11_2 do begin
	;Determine the name of the output file to read
	   if fnum eq 0 then file_extension=''
	   if fnum ge 1 then file_extension=string('_000',strtrim(fix(fnum),1))
	   if fnum ge 10 then file_extension=string('_00',strtrim(fix(fnum),1))
	   if fnum ge 100 then file_extension=string('_0',strtrim(fix(fnum),1))
           if fnum ge 1000 then file_extension=string('_',strtrim(fix(fnum),1))
	   fort11=path+'fort.11'+file_extension & fort45=path+'fort.45'+file_extension
	   if fort45 eq 'run/fort.45_0001' then fort45=path+'fort.45'
	   print,fort45
	   openr,1,fort45,/f77_unformatted
           print,'Opened 45'
	   for record_num=1,160 do begin
                print,record_num
          	readu,1,tau4,vpout4,tofday4,srfupflx4,srfdnflx4,srfupflx_dd4,tauref3d4
                print,'read 45 data'
		srfupflx4a[*,*,*,count45]=srfupflx4
		srfdnflx4a[*,*,*,count45]=srfdnflx4
		srfupflx_dd4a[*,*,*,count45]=srfupflx_dd4
                count45=count45+1
	   endfor ;record
	  close,1
endfor ;fort

save,lsa,dxyp,qcond4_1,qcond4_2,srfupflx4a,srfdnflx4a,qcond4a,filename=strcompress(string(sims[sim],'_surface.SAV'),/remove_all)

endfor ;simulation

end
