function ramp,t0,t1,increment 
steps=ceil((float(t1)-t0)/increment)
return,increment*findgen(steps+1)+t0
end

pro sublimation_read

sims=['O15_RIC_CAP','O20_RIC_CAP','O25_RIC_CAP','O30_RIC_CAP','O35_RIC_CAP']

years=[19,20]
interval=15.0
porb=16056.0

;Constants
   lat_dim=findgen(35)*5-85
   lon_dim=findgen(60)*(360.0/60.0)-180
   lon_dim[-1]=179.999
   j_array=(indgen(36,60)) mod 36

for sim=0,n_elements(sims)-1 do begin

  print,sims[sim]

;Specify the first and last record file number for reading
   fort11_1=151.
   fort11_2=167.

;Number of records that are expected to be read
   n_records=160*(fort11_2-fort11_1+1)

  path='./'+sims[sim]+'/run/'

print,'Declaring variable types'
;Variable Data Types
   f1=fltarr(1) & f2=fltarr(24) & f3=fltarr(36,60) & f4=fltarr(36,60,6) & f5=fltarr(36,60,24) & f6=fltarr(36,60,24,6) & f7=fltarr(36)
print,'Declaring variables'
;Declare Variables
   tau4=f1 & vpout4=f1 & rsdist4=f1 & tofday4=f1 & psf4=f1 & ptrop4=f1 & tautot4=f1 & rptau4=f1 & sind4=f1 & gasp4=f1 & grav=f1 & rgas=f1
   dsig4=f2
   p4=f3 & co2ice4=f3 & tausurf4=f3 & tinterp=f3 & gt4=f3 & stemp4=f3 & stressx4=f3 & stressxy=f3 & topog4=f3 & alsp4=f3 & zin4=f3 & dst_free_atm=f3 & dst_core_atm=f3 & dst_free_gnd=f3 & dst_core_gnd=f3 & hice_atm=f3 & hvap_atm=f3
   fuptopv=f3 & fdntopv=f3 & fupsurfv=f3 & fdnsurfv=f3 & fuptopir=f3 & fupsurfir=f3 & fdnsurfir=f3
   dst_free_medsize_avg=f3 & dst_free_cwmsize_avg=f3 & dst_free_mwmsize_avg=f3
   dst_core_medsize_avg=f3 & dst_core_cwmsize_avg=f3 & dst_core_mwmsize_avg=f3
   hice_medsize_avg=f3 & hice_cwmsize_avg=f3 & hice_mwmsize_avg=f3
   qcond4=f4 & prm=f4 & srfupflx4=f4 & srfdnflx4=f4 & srfupflx_dd4=f4
   t4=f5 & u4=f5 & v4=f5 & recordpk4a=f5
   dst_free_medsize=f5 & dst_free_cwmsize=f5 & dst_free_mwmsize=f5
   dst_core_medsize=f5 & dst_core_cwmsize=f5 & dst_core_mwmsize=f5
   hice_medsize=f5 & hice_cwmsize=f5 & hice_mwmsize=f5
   qtrace4=f6
   dxyp=f7
print,'Declaring storage variable types'
;Storage Array Data Types
   f1a=fltarr(2*n_records) & f2a=fltarr(36,60,50) & f3a=fltarr(36,60,1.1*n_records) & f4a=fltarr(36,60,6,1.1*n_records) & f5a=fltarr(36,60,24,1.1*n_records)
print,'Declaring storage variables'
;Declare Storage Arrays
   gasp4a=f1a & vpout4a=f1a & year_array=f1a & lsa=f1a & meantausurf4a=f1a & tofday4a=f1a
   yavgprma=f2a
   co2ice4a=f3a & tausurf4a=f3a & tinterpa=f3a & p4a=f3a & stemp4=f3a & gt4a=f3a & psf4a=f3a & stressmag4a=f3a & dst_free_atm_array=f3a & dst_core_atm_array=f3a & dst_free_gnd_array=f3a & dst_core_gnd_array=f3a & hice_atm_array=f3a & hvap_atm_array=f3a & q_gnda=f3a & qtrace_gnda=f3a
   dst_free_medsize_avg_array=f3a & dst_free_cwmsize_avg_array=f3a & dst_free_mwmsize_avg_array=f3a
   dst_core_medsize_avg_array=f3a & dst_core_cwmsize_avg_array=f3a & dst_core_mwmsize_avg_array=f3a
   hice_medsize_avg_array=f3a & hice_cwmsize_avg_array=f3a & hice_mwmsize_avg_array=f3a
   fuptopva=f3a & fdntopva=f3a & fupsurfva=f3a & fdnsurfva=f3a & fuptopira=f3a & fupsurfira=f3a & fdnsurfira=f3a
   qcond4a=f4a & prma=f4a & srfupflx4a=f4a & srfdnflx4a=f4a & srfupflx_dd4a=f4a
   u4a=f3a & v4a=f3a
   f8a=fltarr(2*360.0/interval,36)
   tau_sum=f8a & prm_sum=f8a & hice_sum=f8a & p4_sum=f8a & co2_sum=f8a & gwi_sum=f8a & atcor_sum=f8a & atfree_sum=f8a & h2o_sum=f8a & stressmag_sum=f8a & fort11_count=f8a & gt_sum=f8a
   srfupflx_sum=f8a & srfdnflx_sum=f8a & srfupflxdd_sum=f8a & srfupflxcor_sum=f8a & srfdnflxcor_sum=f8a & srfupflxh2o_sum=f8a & srfdnflxh2o_sum=f8a & fupsurfv_sum=f8a & fdnsurfv_sum=f8a & fupsurfir_sum=f8a & fdnsurfir_sum=f8a & fort45_count=f8a & tmp_sum=f8a	   

;Initialize 'counters' to zero
;'year' counts up one at the beginning of each Mars year
;'count11' counts up one at the beginning of each record
;'season_count' counts up one at the beginning of each season
   year=0
   count11=0

;goto,jump1

print,'Reading select fort.11 files'

;Loop sequentially from the first to the last desired fort.11 output file
for fnum=fort11_1,fort11_2 do begin
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

	;Determine the values of 'sigma' given dsig4
	   nlay=24
	   sigma=fltarr(51)
	   sigma[1-1]=0.0
	   sigma[2-1]=0.0
	   sigma[3-1]=0.0
	;sigma at layer boundaries
	   for l=1,nlay do begin
		   k=2*l+3
		   sigma[k-1]=sigma[k-1-2]+dsig4[l-1]
	   endfor
	;sigma at layer mid-points
	   nlevsm1=2*nlay+2
	   for k=4,nlevsm1,2 do begin
		   sigma(k-1)=0.5*(sigma(k-1+1)+sigma(k-1-1))
	   endfor

	;Read the 160 records in the output file and calculate and/or store desired quantities in arrays
	   for record_num=1,160 do begin
		   readu,2,tau4,vpout4,rsdist4,tofday4,psf4,ptrop4,tautot4,rptau4,sind4,gasp4
                   ;tau4=tau4-480.001
                   readu,2
                   readu,2,p4
                   readu,2,t4
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

                   stressmag4=sqrt(stressx4^2+stressy4^2)

		   if count11 eq 0 then year=fix(tau4/porb)
		   vpout4a[count11]=vpout4
		   if vpout4a[count11]-vpout4a[count11-1] lt 0 then year=year+1
		   lsa[count11]=vpout4+360.0*year

                   gt4a[*,*,count11]=gt4
                   co2ice4a[*,*,count11]=co2ice4
                   tausurf4a[*,*,count11]=tausurf4
                   qcond4a[*,*,*,count11]=qcond4
                   tofday4a[count11]=tofday4
                   p4a[*,*,count11]=p4
  
                   qtrace_gnd=qtrace4[*,*,23,5]
                   q_gnd=(18.0/44.0)*6.11*exp(22.5*(1.0-(273.16/gt4)))/(p4+ptrop4[0])

                   qtrace_gnda[*,*,count11]=qtrace_gnd
                   q_gnda[*,*,count11]=q_gnd

                   ;wflux=-1.0*(qtrace4[*,*,23,5]-q_gnd)/1000.0
                   ;print,mean(wflux)
                   ;w1=dxyp[0] & w2=dxyp[1]
                   ;npolar_wflux=(5.9355e7)*100.0*(w1*mean(wflux[33,*],dimension=2)+w2*mean(wflux[34,*],dimension=2))/(w1+w2)/900.0
                   ;spolar_wflux=(5.9355e7)*100.0*(w2*mean(wflux[0,*],dimension=2)+w1*mean(wflux[1,*],dimension=2))/(w1+w2)/900.0
                   ;print,npolar_wflux
                   ;stop

                      ;if (record_num eq 1) or (record_num eq 40) or (record_num eq 80) or (record_num eq 120) or (record_num eq 160) then print,count11,lsa[count11],vpout4,(lsa[count11])/360.

		   ;Count up to the next record
                      count11=count11+1

	   endfor

	close,2

endfor

print,'Saving select fort.11 variables'

;Save the arrays to be plotted in 'climate1.sav'
   ;SAVE,lsa,tausurf4a,qcond4a,co2ice4a,dst_free_atm_array,dst_core_atm_array,hice_atm_array,hvap_atm_array,topog4,tau_sum,prm_sum,hice_sum,p4_sum,co2_sum,gwi_sum,atcor_sum,atfree_sum,h2o_sum,stressmag_sum,gt_sum,fupsurfv_sum,fdnsurfv_sum,fupsurfir_sum,fdnsurfir_sum,tmp_sum,fort11_count,yavgprma,interval,tofday4a,dxyp,ptrop4,grav,filename=string('savs/',sims[sim],'_climate1_2.sav')

SAVE,lsa,qtrace_gnda,q_gnda,gt4a,p4a,ptrop4,filename=string('savs/',sims[sim],'_sublimation.sav')

goto,JUMP1

print,'Reading select fort.51 files'

dndiffv=dblarr(36,60)
dnirflux=dblarr(36,60)
rhouch=dblarr(1)
runnum=dblarr(1)
tau=dblarr(1)
topog4=dblarr(36,60) & alsp4=dblarr(36,60) & zin4=dblarr(36,60)
count51=0
;Loop through the first to last desired output files
for fnum=fort11_1,fort11_2 do begin
	;Determine the name of the output file to read
	   if fnum eq 0 then file_extension=''
	   if fnum ge 1 then file_extension=string('_000',strtrim(fix(fnum),1))
	   if fnum ge 10 then file_extension=string('_00',strtrim(fix(fnum),1))
	   if fnum ge 100 then file_extension=string('_0',strtrim(fix(fnum),1))
           if fnum ge 1000 then file_extension=string('_',strtrim(fix(fnum),1))
	   fort11=path+'fort.11'+file_extension & fort51=path+'fort.51'+file_extension
	   if fort51 eq 'run/fort.51_0001' then fort51=path+'fort.51'
	   print,fort51

	;Open the output file and read the header
	   openr,1,fort51,/f77_unformatted

	;Read the 160 records in the output file and calculate and/or store desired quantities in arrays
	   ;for record_num=1,160 do begin
                ;print,record_num
                readu,1,runnum,tau
                readu,1
                readu,1
                readu,1,topog4,alsp4,zin4
                readu,1
                readu,1
                readu,1
                readu,1,dndiffv,dnirflux,rhouch
                print,rhouch
                readu,1
                ;if (record_num eq 1) or (record_num eq 40) or (record_num eq 80) or (record_num eq 120) or (record_num eq 160) then print,count51,lsa[count51],vpout4,(lsa[count51])/360.

                count51=count51+1

	   ;endfor
	  close,1

endfor

print,'Saving select fort.51 variables'

;Save the arrays to be plotted in 'climate2.sav'
   ;SAVE,srfupflx4a,srfdnflx4a,srfupflx_dd4a,srfupflx_sum,srfdnflx_sum,srfupflxdd_sum,srfupflxcor_sum,srfdnflxcor_sum,srfupflxh2o_sum,srfdnflxh2o_sum,fort45_count,filename=string('savs/',sims[sim],'_climate2_2.sav')

JUMP1:

endfor

end
