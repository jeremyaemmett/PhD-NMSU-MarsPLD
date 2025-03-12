function ramp,t0,t1,increment 
steps=ceil((float(t1)-t0)/increment)
return,increment*findgen(steps+1)+t0
end

pro climate2

pfe=1 & skip=0
sims=['O15_E0_Ncap','O15_E0_Scap','O15_E0_TMG','O15_E0_band','O15_E0_caps','O25_E0_Ncap','O25_E0_Scap','O25_E0_TMG','O25_E0_band','O25_E0_caps','O35_E0_Ncap','O35_E0_Scap','O35_E0_TMG','O35_E0_band','O35_E0_caps','O45_E0_Ncap','O45_E0_Scap','O45_E0_TMG','O45_E0_band','O45_E0_caps']

sims=['O15_E0_TMG','O25_E0_TMG','O35_E0_TMG']
sims=['PRES_AD_E0225_DDA1E10_albfeed04']
;sims=['PRES']

;sims=['O15_E0_TMG','O35_E0_TMG','O35_E0_caps','O45_E0_caps']
sims=['PRES_E016_T0225_DDA1E10_cld','PRES_E016_T0225_DDA1E10_cld_af','PRES_E017_T0225_DDA1E10_cld','PRES_E017_T0225_DDA1E10_cld_af','PRES_E018_T0225_DDA1E10_cld','PRES_E018_T0225_DDA1E10_cld_af','PRES_E019_T0225_DDA1E10_cld','PRES_E019_T0225_DDA1E10_cld_af','PRES_E020_T0225_DDA1E10_cld','PRES_E020_T0225_DDA1E10_cld_af','PRES_E028_T0225_DDA1E10','PRES_E028_T0225_DDA1E10_af']
sims=['PRES_RIC']
sims=['O15_RIC_CAP','O15_RIC_MID','O20_RIC_CAP','O20_RIC_MID','O25_RIC_CAP','O25_RIC_MID','O30_RIC_CAP','O30_RIC_MID','O35_RIC_CAP','O35_RIC_MID','O40_RIC_CAP','O40_RIC_MID','O45_RIC_CAP','O45_RIC_MID','PRES_RIC']

;sims=['PRES_RIC']

;sims=['PRES_RIC_029','PRES_RIC_030','PRES_RIC_031']

years=[23,24]
years=[24,25]
years=[17,18]
years=[4,5]
;years=[0,1]
;years=[6,7]
interval=30.0
porb=16056.0

;Constants
   lat_dim=findgen(35)*5-85
   lon_dim=findgen(60)*(360.0/60.0)-180
   lon_dim[-1]=179.999
   j_array=(indgen(36,60)) mod 36

for sim=0,n_elements(sims)-1 do begin

  print,sims[sim]

;Specify the first and last record file number for reading
   fort11_1=25.
   fort11_2=42.

;Number of records that are expected to be read
   n_records=160*(fort11_2-fort11_1+1)

  if skip eq 1 then begin 
  print,'Restoring fort.11 variables'
  RESTORE,string(sims[sim],'_climate1.sav')
  print,'Restoring fort.45 variables'
  RESTORE,string(sims[sim],'_climate2.sav')
  endif
  if skip eq 1 then GOTO, JUMP1

  path='./'+sims[sim]+'/run/'
;  path='./'

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
   co2ice4a=f3a & tausurf4a=f3a & p4a=f3a & stemp4=f3a & gt4a=f3a & psf4a=f3a & stressmag4a=f3a & dst_free_atm_array=f3a & dst_core_atm_array=f3a & dst_free_gnd_array=f3a & dst_core_gnd_array=f3a & hice_atm_array=f3a & hvap_atm_array=f3a
   dst_free_medsize_avg_array=f3a & dst_free_cwmsize_avg_array=f3a & dst_free_mwmsize_avg_array=f3a
   dst_core_medsize_avg_array=f3a & dst_core_cwmsize_avg_array=f3a & dst_core_mwmsize_avg_array=f3a
   hice_medsize_avg_array=f3a & hice_cwmsize_avg_array=f3a & hice_mwmsize_avg_array=f3a
   fuptopva=f3a & fdntopva=f3a & fupsurfva=f3a & fdnsurfva=f3a & fuptopira=f3a & fupsurfira=f3a & fdnsurfira=f3a
   qcond4a=f4a & prma=f4a & srfupflx4a=f4a & srfdnflx4a=f4a & srfupflx_dd4a=f4a
   u4a=f3a & v4a=f3a
   f8a=fltarr(2*360.0/interval,36)
   tau_sum=f8a & prm_sum=f8a & hice_sum=f8a & p4_sum=f8a & co2_sum=f8a & gwi_sum=f8a & atcor_sum=f8a & atfree_sum=f8a & h2o_sum=f8a & stressmag_sum=f8a & fort11_count=f8a & gt_sum=f8a
   srfupflx_sum=f8a & srfdnflx_sum=f8a & srfupflxdd_sum=f8a & srfupflxcor_sum=f8a & srfdnflxcor_sum=f8a & srfupflxh2o_sum=f8a & srfdnflxh2o_sum=f8a & fupsurfv_sum=f8a & fdnsurfv_sum=f8a & fupsurfir_sum=f8a & fdnsurfir_sum=f8a & fort45_count=f8a	   

;Initialize 'counters' to zero
;'year' counts up one at the beginning of each Mars year
;'count11' counts up one at the beginning of each record
;'season_count' counts up one at the beginning of each season
   year=0
   count11=0

print,'Reading fort.11 files'

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

	;Read the 160 records in the output file and calculate and/or store desired quantities in arrays
	   for record_num=1,160 do begin
		   readu,2,tau4,vpout4,rsdist4,tofday4,psf4,ptrop4,tautot4,rptau4,sind4,gasp4
                   ;tau4=tau4-480.001
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
                   u4a[*,*,count11]=u4[*,*,17]
                   v4a[*,*,count11]=v4[*,*,17]
                   ;fupsurfva[*,*,count11]=fupsurfv
                   ;fdnsurfva[*,*,count11]=fdnsurfv
                   ;fupsurfir[*,*,count11]=supsurfir
                   ;fdnsurfir[*,*,count11]=fdnsurfir

		   ;Calculate column-integrated precipitable microns of water vapor at all J,I gridpoints 
		   ;Calculate column-integrated free dust and dust cores in the atmosphere (atm) at all J,I gridpoints 
		      prm=0.0*prm
		      dst_free_atm=0.0*dst_free_atm
		      dst_core_atm=0.0*dst_core_atm
                      dst_free_medsize_avg=0.0*dst_free_medsize_avg & dst_free_mwmsize_avg=0.0*dst_free_mwmsize_avg & dst_free_cwmsize_avg=0.0*dst_free_cwmsize_avg
                      dst_core_medsize_avg=0.0*dst_core_medsize_avg & dst_core_mwmsize_avg=0.0*dst_core_mwmsize_avg & dst_core_cwmsize_avg=0.0*dst_core_cwmsize_avg
                      hice_medsize_avg=0.0*hice_medsize_avg & hice_mwmsize_avg=0.0*hice_mwmsize_avg & hice_cwmsize_avg=0.0*hice_cwmsize_avg
                      hice_atm=0.0*hice_atm
                      hvap_atm=0.0*hvap_atm
		      for l=0,23 do begin
		      		prm(*,*,5)=prm(*,*,5)+((dsig4(l)*p4*100.0/3.711)*qtrace4(*,*,l,5)/1000.0)*(1.0e6)
		      		dst_free_atm=dst_free_atm+((dsig4(l)*p4*100.0/3.711)*qtrace4(*,*,l,0))
				dst_core_atm=dst_core_atm+((dsig4(l)*p4*100.0/3.711)*qtrace4(*,*,l,4))
                                hice_atm=hice_atm+((dsig4(l)*p4*100.0/3.711)*qtrace4(*,*,l,2)/917.0)*(1.0e6)
                                hvap_atm=hvap_atm+((dsig4(l)*p4*100.0/3.711)*qtrace4(*,*,l,5))
		      endfor
                      dst_free_atm_array[*,*,count11]=dst_free_atm[*,*]
                      dst_core_atm_array[*,*,count11]=dst_core_atm[*,*]
                      hice_atm_array[*,*,count11]=hice_atm[*,*]
                      hvap_atm_array[*,*,count11]=hvap_atm[*,*]

 		   ;Sum the IxJ precipitable micron arrays that are within the same year, so they can be averaged over that year
		      yavgprma[*,*,year]=yavgprma[*,*,year]+prm(*,*,5)
	           ;Using the specified Ls bin size (interval), bin precipitable microns of water vapor by latitude and Ls
		   ;This produces a 'sum' array and a 'counts' array that are used to average the binned quantities
                      if fix((lsa[count11])/360.) eq years[0] or fix((lsa[count11])/360.0) eq years[1] then begin
                      if fix(lsa[count11]/360.0) eq years[0] then ls_bin=fix((lsa[count11] mod 360.0)/interval)
                      if fix(lsa[count11]/360.0) eq years[1] then ls_bin=fix((lsa[count11] mod 360.0)/interval+360.0/interval)
                      if (record_num eq 1) or (record_num eq 160) then print,count11,lsa[count11],vpout4,(lsa[count11])/360.,ls_bin
		      for j=0,35 do begin
			      prm_sum(ls_bin,j)=prm_sum(ls_bin,j)+total(prm(j,*,5))
                              hice_sum(ls_bin,j)=hice_sum(ls_bin,j)+total(hice_atm[j,*])
			      tau_sum(ls_bin,j)=tau_sum(ls_bin,j)+total(tausurf4(j,*))
			      p4_sum(ls_bin,j)=p4_sum(ls_bin,j)+total(p4(j,*)+ptrop4)
			      stressmag_sum(ls_bin,j)=stressmag_sum(ls_bin,j)+total(stressmag4[j,*])
			      atcor_sum(ls_bin,j)=atcor_sum(ls_bin,j)+total(dst_core_atm(j,*))
			      atfree_sum(ls_bin,j)=atfree_sum(ls_bin,j)+total(dst_free_atm(j,*))
                              gt_sum(ls_bin,j)=gt_sum(ls_bin,j)+total(gt4(j,*))
                              fupsurfv_sum(ls_bin,j)=fupsurfv_sum(ls_bin,j)+total(fupsurfv(j,*))
                              fdnsurfv_sum(ls_bin,j)=fdnsurfv_sum(ls_bin,j)+total(fdnsurfv(j,*))
                              fupsurfir_sum(ls_bin,j)=fupsurfir_sum(ls_bin,j)+total(fupsurfir(j,*))
                              fdnsurfir_sum(ls_bin,j)=fdnsurfir_sum(ls_bin,j)+total(fdnsurfir(j,*))
                              co2_sum(ls_bin,j)=co2_sum(ls_bin,j)+total(co2ice4(j,*))
                              gwi_sum(ls_bin,j)=gwi_sum(ls_bin,j)+total(qcond4(j,*,5))

                              fort11_count(ls_bin,j)=fort11_count(ls_bin,j)+60
		      endfor
                      endif

		   ;Count up to the next record
                      count11=count11+1

	   endfor

	close,2

endfor

print,'Reading fort.45 files'

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

	;Open the output file and read the header
	   openr,1,fort45,/f77_unformatted

	;Read the 160 records in the output file and calculate and/or store desired quantities in arrays
	   for record_num=1,160 do begin

          	readu,1,tau4,vpout4,tofday4,srfupflx4,srfdnflx4,srfupflx_dd4,tauref3d4
                ;tau4=tau4-480.001
		srfupflx4a[*,*,*,count45]=srfupflx4
		srfdnflx4a[*,*,*,count45]=srfdnflx4
		srfupflx_dd4a[*,*,*,count45]=srfupflx_dd4

	        ;Using the specified Ls bin size (interval), bin water ice mass on the surface by latitude and Ls
		;This produces a 'sum' array and a 'counts' array that are used to average the binned quantities.
                      if fix((lsa[count45])/360.) eq years[0] or fix((lsa[count45])/360.0) eq years[1] then begin
                      if fix(lsa[count45]/360.0) eq years[0] then ls_bin=fix((lsa[count45] mod 360.0)/interval)
                      if fix(lsa[count45]/360.0) eq years[1] then ls_bin=fix((lsa[count45] mod 360.0)/interval+360.0/interval)

		   for j=0,35 do begin
			   srfupflx_sum(ls_bin,j)=srfupflx_sum(ls_bin,j)+total(srfupflx4(j,*,0))
			   srfdnflx_sum(ls_bin,j)=srfdnflx_sum(ls_bin,j)+total(srfdnflx4(j,*,0))
			   srfupflxdd_sum(ls_bin,j)=srfupflxdd_sum(ls_bin,j)+total(srfupflx_dd4(j,*,0))
			   srfupflxcor_sum(ls_bin,j)=srfupflxcor_sum(ls_bin,j)+total(srfupflx4(j,*,4))
			   srfdnflxcor_sum(ls_bin,j)=srfdnflxcor_sum(ls_bin,j)+total(srfdnflx4(j,*,4))
			   srfupflxh2o_sum(ls_bin,j)=srfupflxh2o_sum(ls_bin,j)+total(srfupflx4(j,*,5))
			   srfdnflxh2o_sum(ls_bin,j)=srfdnflxh2o_sum(ls_bin,j)+total(srfdnflx4(j,*,5))
                           fort45_count(ls_bin,j)=fort45_count(ls_bin,j)+60
		   endfor
                   endif

                   count45=count45+1

	   endfor
	  close,1

endfor

print,'Saving fort.11 variables'

;Save the arrays to be plotted in 'climate1.sav'
   SAVE,lsa,tausurf4a,qcond4a,co2ice4a,dst_free_atm_array,dst_core_atm_array,hice_atm_array,hvap_atm_array,topog4,tau_sum,prm_sum,hice_sum,p4_sum,co2_sum,gwi_sum,atcor_sum,atfree_sum,h2o_sum,stressmag_sum,gt_sum,fupsurfv_sum,fdnsurfv_sum,fupsurfir_sum,fdnsurfir_sum,fort11_count,yavgprma,interval,tofday4a,dxyp,ptrop4,grav,filename=string(sims[sim],'_climate1.sav')

print,'Saving fort.45 variables'

;Save the arrays to be plotted in 'climate2.sav'
   SAVE,srfupflx4a,srfdnflx4a,srfupflx_dd4a,srfupflx_sum,srfdnflx_sum,srfupflxdd_sum,srfupflxcor_sum,srfdnflxcor_sum,srfupflxh2o_sum,srfdnflxh2o_sum,fort45_count,filename=string(sims[sim],'_climate2.sav')

JUMP1:

if pfe eq 1 then GOTO, JUMP2

ps_open,string(sims[sim],'_climate'),/Color
!P.MULTI=[0,1,2]
!Y.MARGIN=[10,2]

year_array=fix(lsa/360.0)

int=15
plotidx_array=intarr(2*360/int)
taumap_array=fltarr(60,35,2*360/int) & dstcoreatmmap_array=fltarr(60,35,2*360/int)
hiceatmmap_array=fltarr(60,35,2*360/int)
for i=1,2*360/int do begin
ls=i*int
index=(where(year_array eq years[0] and fix((lsa mod 360)) eq ls))[0]
if ls eq 720 then index=(where(year_array eq years[1]+1 and fix((lsa mod 360)) eq 0))[0]
plotidx_array[i-1]=index
taumap=transpose(tausurf4a[0:34,*,index])
dstcoreatmmap=transpose(dst_core_atm_array[0:34,*,index])
hicemap=transpose(hice_atm_array[0:34,*,index])
taumap_array[*,*,i-1]=taumap & dstcoreatmmap_array[*,*,i-1]=dstcoreatmmap
hiceatmmap_array[*,*,i-1]=hicemap
endfor

!P.MULTI=[0,1,2]
!Y.MARGIN=[10,2]

loadct,39,/silent
;;;Plot Zonal and Ls-Averaged Dust Optical Depth (In Visible) at the Surface vs Ls;;;
tauavg=((tau_sum/fort11_count)[*,*])
tauavg=(tauavg[*,0:34])
contour,tauavg,interval*findgen((size(tauavg))[1])+interval/2.,lat_dim,/follow,levels=[1e-3,1e-2,1e-1,1e0,1e1,2.5e1],xrange=[0,360],xstyle=1,ystyle=1,xtickinterval=45.0,ytickinterval=30.0,charsize=1,title=string('Visible Dust Optical Depth in Year:',years),c_colors=[50,90,130,170,210,250],c_labels=[1,1,1,1,1,1],c_charsize=1.2

;;;Plot Global Average Dust Optical Depth (In Visible) at the Surface vs Ls;;;
taugavg=fltarr(n_records)
j_array=(indgen(36,60)) mod 36
for r=0,n_records-1 do begin
  taugavg[r]=total((dxyp[j_array])*tausurf4a[*,*,r])/total(dxyp[j_array])
endfor
plot,lsa[where(lsa ne 0.)]-years[0]*360.,taugavg[where(lsa ne 0.)],xrange=[0,360],yrange=[0.0,max(taugavg)],xstyle=1,ystyle=1,xtickinterval=45.0,charsize=1,title=string('Globally-Averaged Optical Depth in Year:',years)
oplot,lsa[where(lsa ne 0.)]-years[0]*360.,(taugavg/2.5)[where(lsa ne 0.)],color=250
legend,['Visible','IR (Visible/2.5)'],linestyle=[0,0],colors=[0.0,250.0],/top,/left,charsize=1.2

;;;Plot Zonal and Ls-Averaged Surface Stress Magnitude [N/m2] vs Ls;;;
stressmagavg=(stressmag_sum/fort11_count)[*,0:34]
contour,stressmagavg,interval*findgen((size(stressmagavg))[1])+interval/2.,lat_dim,/follow,levels=[0.00225,4e-3,6e-3,8e-3,1e-2,1.2e-1,1.4e-1,1.6e-1,1.8e-1,1e-0],xrange=[0,360],xstyle=1,ystyle=1,xtickinterval=45.0,ytickinterval=30.0,charsize=1,title=string('Surface Stress Magnitude [N/m2] in Year:',years),c_colors=[25,50,75,100,125,150,175,200,225,250],c_labels=[1,1,1,1,1,1,1,1,1,1],c_charsize=1.2

;;;Plot Zonal and Ls-Averaged Atmospheric Free Dust vs Ls;;;
atfreeavg=((atfree_sum/fort11_count)[*,*])
atfreeavg=(atfreeavg[*,0:34])
contour,atfreeavg,interval*findgen((size(atfreeavg))[1])+interval/2.,lat_dim,levels=[1e-6,5e-6,1e-5,5e-5,1e-4,5e-4,1e-3,5e-3,1e-2,5e-2,1e-1,5e-1],/follow,c_colors=[20,40,60,80,100,120,140,160,180,200,220,240],c_labels=[1,1,1,1,1,1,1,1,1,1,1,1],xrange=[0,360],xstyle=1,ystyle=1,xtickinterval=45.0,ytickinterval=30.0,charsize=1,title=string('Atmospheric Free Dust Mass [kg/m2] in Year:',years),c_charsize=1.2

;;;Plot Zonal and Ls-Averaged Atmospheric Core Dust vs Ls;;;
atcoravg=((atcor_sum/fort11_count)[*,*])
atcoravg=(atcoravg[*,0:34])
contour,atcoravg,interval*findgen((size(atcoravg))[1])+interval/2.,lat_dim,levels=[1e-6,5e-6,1e-5,5e-5,1e-4,5e-4,1e-3,5e-3,1e-2,5e-2,1e-1,5e-1],/follow,c_colors=[20,40,60,80,100,120,140,160,180,200,220,240],c_labels=[1,1,1,1,1,1,1,1,1,1,1,1],xrange=[0,360],xstyle=1,ystyle=1,xtickinterval=45.0,ytickinterval=30.0,charsize=1,title=string('Atmospheric Dust Core Mass [kg/m2] in Year:',years),c_charsize=1.2

;;;Plot Zonal and Ls-Averaged Wind Stress Free Dust Lifting Rate vs Ls;;;
srfupflxavg=((srfupflx_sum/fort45_count)[*,*])
srfupflxavg=(srfupflxavg[*,0:34])
contour,srfupflxavg,interval*findgen((size(srfupflxavg))[1])+interval/2.,lat_dim,levels=[5e-11,1e-10,5e-10,1e-9,5e-9,1e-8,5e-8,1e-7,5e-7,1e-6],/follow,c_colors=[25,50,75,100,125,150,175,200,225,250],c_labels=[1,1,1,1,1,1,1,1,1,1],xrange=[0,360],xstyle=1,ystyle=1,xtickinterval=45.0,ytickinterval=30.0,charsize=1,title=string('Wind Stress Free Dust Lifting Rate [kg/m2/s] in Year:',years),c_charsize=1.2

;;;Plot Zonal and Ls-Averaged Dust Devil Free Dust Lifting Rate vs Ls;;;
srfupflxddavg=((srfupflxdd_sum/fort45_count)[*,*])
srfupflxddavg=(srfupflxddavg[*,0:34])
contour,srfupflxddavg,interval*findgen((size(srfupflxddavg))[1])+interval/2.,lat_dim,levels=[5e-11,1e-10,5e-10,1e-9,5e-9,1e-8,5e-8,1e-7,5e-7,1e-6],/follow,c_colors=[25,50,75,100,125,150,175,200,225,250],c_labels=[1,1,1,1,1,1,1,1,1,1],xrange=[0,360],xstyle=1,ystyle=1,xtickinterval=45.0,ytickinterval=30.0,charsize=1,title=string('Dust Devil Free Dust Lifting Rate [kg/m2/s] in Year:',years),c_charsize=1.2

;;;Plot Zonal and Ls-Averaged Free Dust Deposition Rate vs Ls;;;
srfdnflxavg=((srfdnflx_sum/fort45_count)[*,*])
srfdnflxavg=(srfdnflxavg[*,0:34])
contour,srfdnflxavg,interval*findgen((size(srfdnflxavg))[1])+interval/2.,lat_dim,levels=[5e-11,1e-10,5e-10,1e-9,5e-9,1e-8,5e-8,1e-7,5e-7,1e-6],/follow,c_colors=[25,50,75,100,125,150,175,200,225,250],c_labels=[1,1,1,1,1,1,1,1,1,1],xrange=[0,360],xstyle=1,ystyle=1,xtickinterval=45.0,ytickinterval=30.0,charsize=1,title=string('Free Dust Deposition Rate [kg/m2/s] in Year:',years),c_charsize=1.2

;;;Plot Zonal and Ls-Averaged Core Dust Lifting Rate vs Ls;;;
srfupflxcoravg=((srfupflxcor_sum/fort45_count)[*,*])
srfupflxcoravg=(srfupflxcoravg[*,0:34])
contour,srfupflxcoravg,interval*findgen((size(srfupflxcoravg))[1])+interval/2.,lat_dim,levels=[5e-11,1e-10,5e-10,1e-9,5e-9,1e-8,5e-8,1e-7,5e-7,1e-6],/follow,c_colors=[25,50,75,100,125,150,175,200,225,250],c_labels=[1,1,1,1,1,1,1,1,1,1],xrange=[0,360],xstyle=1,ystyle=1,xtickinterval=45.0,ytickinterval=30.0,charsize=1,title=string('Core Dust Lifting Rate [kg/m2/s] in Year:',years),c_charsize=1.2

;;;Plot Zonal and Ls-Averaged Core Dust Deposition Rate vs Ls;;;
srfdnflxcoravg=((srfdnflxcor_sum/fort45_count)[*,*])
srfdnflxcoravg=(srfdnflxcoravg[*,0:34])
contour,srfdnflxcoravg,interval*findgen((size(srfdnflxcoravg))[1])+interval/2.,lat_dim,levels=[5e-11,1e-10,5e-10,1e-9,5e-9,1e-8,5e-8,1e-7,5e-7,1e-6],/follow,c_colors=[25,50,75,100,125,150,175,200,225,250],c_labels=[1,1,1,1,1,1,1,1,1,1],xrange=[0,360],xstyle=1,ystyle=1,xtickinterval=45.0,ytickinterval=30.0,charsize=1,title=string('Core Dust Deposition Rate [kg/m2/s] in Year:',years),c_charsize=1.2

;;;Plot Zonal and Ls-Averaged H2O Lifting Rate vs Ls;;;
srfupflxh2oavg=((srfupflxh2o_sum/fort45_count)[*,*])
srfupflxh2oavg=(srfupflxh2oavg[*,0:34])
contour,srfupflxh2oavg,interval*findgen((size(srfupflxh2oavg))[1])+interval/2.,lat_dim,levels=[1e-14,1e-12,1e-10,1e-8,1e-6,1e-4],/follow,c_colors=[40,80,120,160,200,240],c_labels=[1,1,1,1,1,1],xrange=[0,360],xstyle=1,ystyle=1,xtickinterval=45.0,ytickinterval=30.0,charsize=1,title=string('H2O Lifting Rate [kg/m2/s] in Year:',years),c_charsize=1.2

;;;Plot Zonal and Ls-Averaged H2O Deposition Rate vs Ls;;;
srfdnflxh2oavg=((srfdnflxh2o_sum/fort45_count)[*,*])
srfdnflxh2oavg=(srfdnflxh2oavg[*,0:34])
contour,srfdnflxh2oavg,interval*findgen((size(srfdnflxh2oavg))[1])+interval/2.,lat_dim,levels=[1e-14,1e-12,1e-10,1e-8,1e-6,1e-4],/follow,c_colors=[40,80,120,160,200,240],c_labels=[1,1,1,1,1,1],xrange=[0,360],xstyle=1,ystyle=1,xtickinterval=45.0,ytickinterval=30.0,charsize=1,title=string('H2O Deposition Rate [kg/m2/s] in Year:',years),c_charsize=1.2

loadct,39,/silent

;;;Plot Zonal and Ls-Averaged Water Vapor Column [prm] vs Ls;;;
prmavg=(prm_sum/fort11_count)[*,0:34]
contour,prmavg,interval*findgen((size(prmavg))[1])+interval/2.,lat_dim,/follow,levels=[10,20,50,100,200,500,1000,2000,5000],xrange=[0,360],xstyle=1,ystyle=1,xtickinterval=45.0,ytickinterval=30.0,charsize=1,title=string('Water Vapor Column [prm] in Year:',years),c_colors=[50,75,100,125,150,175,200,225,250],c_labels=[1,1,1,1,1,1,1,1,1],c_annotation=['10','20','50','100','200','500','1000','2000','5000','10000','20000'],c_charsize=1.2

;;;Plot Zonal and Ls-Averaged Water Ice Column [prm] vs Ls;;;
hiceavg=(hice_sum/fort11_count)[*,0:34]
contour,hiceavg,interval*findgen((size(hiceavg))[1])+interval/2.,lat_dim,/follow,levels=[2,5,10,20,50,100,200,500,1000,2000,5000],xrange=[0,360],xstyle=1,ystyle=1,xtickinterval=45.0,ytickinterval=30.0,charsize=1,title=string('Water Ice Column [kg/m2] in Year:',years),c_colors=[20,40,60,80,100,120,140,160,180,200,220],c_labels=[1,1,1,1,1,1,1,1,1,1,1],c_annotation=['2','5','10','20','50','100','200','500','1000','2000','5000'],c_charsize=1.2

dst_core_atm_record=fltarr(n_records)
dst_core_gnd_record=fltarr(n_records)
dst_free_gnd_record=fltarr(n_records)
dst_free_atm_record=fltarr(n_records)
for i=0,n_records-1 do begin
dst_core_atm_record[i]=total(dst_core_atm_array[*,*,i])
dst_free_atm_record[i]=total(dst_free_atm_array[*,*,i])
endfor
del_dst_core_atm_record=dst_core_atm_record[*]-dst_core_atm_record[indgen(n_records)-1]
del_dst_free_atm_record=dst_free_atm_record[*]-dst_free_atm_record[indgen(n_records)-1]

ps_close

JUMP2:

endfor

end
