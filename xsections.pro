pro xsections

years=[4,5]
sims=['O15_RIC_MID','O20_RIC_CAP','O20_RIC_MID','O25_RIC_CAP','O25_RIC_MID','O30_RIC_CAP','O30_RIC_MID','O35_RIC_CAP','O35_RIC_MID','O40_RIC_CAP','O40_RIC_MID','O45_RIC_CAP','O45_RIC_MID','PRES_RIC']

sims=['PRES_RIC_047']

close,2
;!P.Color = '000000'xL
;!P.Background = 'FFFFFF'xL
;!P.MULTI=[0,2,2]
lat_dim=findgen(35)*5-85
lon_dim=findgen(60)*(360.0/60.0)-180
tracernames=['Free Dust','Core Dust','Water Vapor','Water Ice','Zonal Wind','Meridional Wind']

for x=0,5 do begin
;!P.MULTI=[0,2,2]
;window,x,xsize=1000,ysize=800

for sim=0,n_elements(sims)-1 do begin
	path=sims[sim]+'/run/'

   ;Specify the first and last record file number for reading
   fort11_1=34
   fort11_2=51

   ;Number of records that are expected to be read
   n_records=160*(fort11_2-fort11_1+1)

   ;Variable Data Types
   f1=fltarr(1) & f2=fltarr(24) & f3=fltarr(36,60) & f4=fltarr(36,60,6) & f5=fltarr(36,60,24) & f6=fltarr(36,60,24,6) & f7=fltarr(36)
   ;Declare Variables
   tau4=f1 & vpout4=f1 & rsdist4=f1 & tofday4=f1 & psf4=f1 & ptrop4=f1 & tautot4=f1 & rptau4=f1 & sind4=f1 & gasp4=f1 & grav=f1 & rgas=f1
   dsig4=f2 & dzcol=f2 & zcol=f2
   p4=f3 & co2ice4=f3 & tausurf4=f3 & tinterp=f3
   qcond4=f4 & prm=f4
   t4=f5 & u4=f5 & v4=f5 & recordpk4a=f5
   qtrace4=f6
   dxyp=f7
   ;Storage Array Data Types
   f1a=fltarr(n_records) & f2a=fltarr(36,60,50) & f3a=fltarr(36,60,n_records) & f4a=fltarr(36,60,6,n_records); & f5a=fltarr(36,60,24,n_records)
   ;f6a=fltarr(36,60,24,6,n_records)
   f7a=fltarr(36,60,24,4)
   f8a=fltarr(4)
   ;Declare Storage Arrays
   gasp4a=f1a & vl1p4a=f1a & vl2p4a=f1a & vpout4a=f1a & year_array=f1a & lsa=f1a & meantausurf4a=f1a & tinterpmean=f1a & tofday4a=f1a
   yavgprma=f2a
   co2ice4a=f3a & tausurf4a=f4a & p4a=f4a
   ;qcond4a=f4a & prma=f4a
   ;t4a=f5a & u4a=f5a & v4a=f5a
   ;qtrace4a=f6a
   seasonpk4a=f7a & seasonuk4a=f7a & seasonmk4a=f7a & seasontk4a=f7a & seasonfk4a=f7a & seasonck4a=f7a & seasonvk4a=f7a & seasonik4a=f7a
season_counter=f8a
   pinterp=[7.5e2,7e2,6.5e2,6e2,5.5e2,5e2,4.5e2,4e2,3.5e2,3e2,2.5e2,2e2,1.5e2,1e2,9.5e1,9e1,8.5e1,8e1,7.5e1,7e1,6.5e1,6e1,5.5e1,5e1,4.5e1,4e1,3.5e1,3e1,2.5e1,2e1,1.5e1,1e1,9.5e0,9e0,8.5e0,8e0,7.5e0,7e0,6.5e0,6e0,5.5e0,5e0,4.5e0,4e0,3.5e0,3e0,2.5e0,2e0,1.5e0,1e0,9e-1,8e-1,7e-1,6e-1,5e-1,4.5e-1,4e-1,3.5e-1,3e-1,2.5e-1,2e-1,1.5e-1,1e-1,9.5e-2,9e-2,8.5e-2,8e-2,7.5e-2,7e-2,6.5e-2,6e-2,5.5e-2,5e-2,4.5e-2,4e-2,3.5e-2,3e-2,2.5e-2,2e-2,1.5e-2,1e-2]
   tinterpa=fltarr(36,60,n_elements(pinterp),4)
   uinterpa=fltarr(36,60,n_elements(pinterp),4)
   minterpa=fltarr(36,60,n_elements(pinterp),4)
   finterpa=fltarr(36,60,n_elements(pinterp),4)
   cinterpa=fltarr(36,60,n_elements(pinterp),4)
   vinterpa=fltarr(36,60,n_elements(pinterp),4)
   iinterpa=fltarr(36,60,n_elements(pinterp),4)
   season_id=fltarr(1)

   count11=0
   season_count=0
   ;loop sequentially from the first to the last desired output file
   for fnum=fort11_1,fort11_2 do begin
      ;Determine the name of the output file to read
      if fnum eq 0 then file_extension=''
      if fnum ge 1 then file_extension=string('_000',strtrim(fnum,1))
      if fnum ge 10 then file_extension=string('_00',strtrim(fnum,1))
      if fnum ge 100 then file_extension=string('_0',strtrim(fnum,1))
      fort11=path+'fort.11'+file_extension & fort45=path+'fort.45'+file_extension
      print,fort11

      ;Open the output file and read the header
      openr,2,fort11,/f77_unformatted
      readu,2
      readu,2,dsig4,dxyp,grav,rgas
      readu,2

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
	 readu,2
	 readu,2,p4
         readu,2,t4
	 readu,2,u4
	 readu,2,v4
	 readu,2
	 readu,2,co2ice4
	 for rep=1,3 do readu,2
	 readu,2,tausurf4
	 readu,2
	 readu,2,qtrace4
	 readu,2,qcond4
	 for rep=1,6 do readu,2

	 if count11 eq 0 then year=fix(tau4/16487.51)
		
	 vpout4a[count11]=vpout4
	 if vpout4a[count11]-vpout4a[count11-1] lt 0 then year=year+1
         year_array[count11]=year
	 lsa[count11]=vpout4+360.0*year
	 tofday4a[count11]=tofday4

	 ;If a solstice or equinox occurs, calculate and record the physical pressure [mbar] at every J,I,L gridpoint,
	 ;and record the atmospheric temperature and the zonal wind speed at every J,I,L gridpoint
	 if (lsa[count11] mod 90) lt (lsa[count11-2] mod 90) and fix((lsa[count11] mod 90)) eq 0 and fix(lsa[count11]/360.0) eq years[0] then begin
           if fix((lsa[count11] mod 360)/10.) eq 0 then season_id=0
           if fix((lsa[count11] mod 360)/10.) eq 9 then season_id=1
           if fix((lsa[count11] mod 360)/10.) eq 18 then season_id=2
           if fix((lsa[count11] mod 360)/10.) eq 27 then season_id=3 
	    for k=4,nlevsm1,2 do begin
	       l=(k-1-3)/2
               ;print,season_count,record_num,lsa[count11],tofday4
	       seasonpk4a[*,*,l,season_id]=100.0*p4*sigma[k-1]+ptrop4[0] ;36,60,24,100
	    endfor
	    seasonuk4a[*,*,*,season_id]=u4
            seasonmk4a[*,*,*,season_id]=v4
	    seasontk4a[*,*,*,season_id]=t4
            seasonfk4a[*,*,*,season_id]=qtrace4[*,*,*,0]
            seasonck4a[*,*,*,season_id]=qtrace4[*,*,*,4]
            seasonvk4a[*,*,*,season_id]=qtrace4[*,*,*,5]
            seasonik4a[*,*,*,season_id]=qtrace4[*,*,*,2]
            ;At every J,I gridpoint, use the 24 temperature values and calculated pressure values in the overlying column to interpolate 
	    ;the atmospheric temperature at the 0.5 mbar pressure level above that gridpoint
            ;Construct an IxJ array of interpolated temperatures at the 0.5 mbar pressure level\
            for lat=0,35 do begin
	       for lon=0,59 do begin
	          pcol=reform(seasonpk4a[lat,lon,*,season_id])
	          tcol=reform(seasontk4a[lat,lon,*,season_id])
                  ucol=reform(seasonuk4a[lat,lon,*,season_id])
                  mcol=reform(seasonmk4a[lat,lon,*,season_id])
                  fcol=reform(seasonfk4a[lat,lon,*,season_id])
                  ccol=reform(seasonck4a[lat,lon,*,season_id])
                  vcol=reform(seasonvk4a[lat,lon,*,season_id])
                  icol=reform(seasonik4a[lat,lon,*,season_id])
	          tinterpa[lat,lon,*,season_id]=interpol(tcol,pcol,pinterp)
                  uinterpa[lat,lon,*,season_id]=interpol(ucol,pcol,pinterp)
                  minterpa[lat,lon,*,season_id]=interpol(mcol,pcol,pinterp)
                  finterpa[lat,lon,*,season_id]=interpol(fcol,pcol,pinterp)
                  cinterpa[lat,lon,*,season_id]=interpol(ccol,pcol,pinterp)
                  vinterpa[lat,lon,*,season_id]=interpol(vcol,pcol,pinterp)
                  iinterpa[lat,lon,*,season_id]=interpol(icol,pcol,pinterp)	
	       endfor
            endfor
	 endif

         if (lsa[count11] mod 90) lt (lsa[count11-2] mod 90) and fix((lsa[count11] mod 90)) eq 0 and fix(lsa[count11]/360.0) eq years[0] then begin
         print,(lsa[count11] mod 360.),season_count,tofday4a[count11],tracernames[x]
         ;contour,reverse(reform(mean(seasontk4a[0:34,*,*,season_count],dimension=2)),2),levels=[115,120,125,130,135,140,145,150,155,160,165,170,175,180,185,190,195,200,205,210,215,220,225,230,235,240,245,250],/cell_fill,xstyle=1,ystyle=1,title=string(lsa[count11],tofday4a[count11])
         tinterpa(where(tinterpa lt 0))=!VALUES.F_NAN
         finterpa(where(finterpa lt 0))=!VALUES.F_NAN
         cinterpa(where(cinterpa lt 0))=!VALUES.F_NAN
         vinterpa(where(vinterpa lt 0))=!VALUES.F_NAN
         iinterpa(where(cinterpa lt 0))=!VALUES.F_NAN
         SAVE,tinterpa,filename=string(sims[sim],'_','Temp','_xsections.sav')
         if x eq 0 then begin 
            xinterpa=finterpa
            xname='Free_Dust'
         ;   clevels=[0.0,0.01,0.1,1,10,20,40,60,80,100,1000]
         ;   cannotations=['0','0.01','0.1','1','10','20','40','60','80','100','1000']
         endif
         if x eq 1 then begin 
            xinterpa=cinterpa
            xname='Core_Dust'
         ;   clevels=[0.0,0.01,0.1,1,10,20,40,60,80,100,1000]
         ;   cannotations=['0','0.01','0.1','1','10','20','40','60','80','100','1000']
         endif
         if x eq 2 then begin 
            xinterpa=vinterpa
            xname='Water_Vapor'
         ;   clevels=[0.0,0.01,0.1,1,10,20,40,60,80,100,1000]
         ;   cannotations=['0','0.01','0.1','1','10','20','40','60','80','100','1000']
         endif
         if x eq 3 then begin 
	    xinterpa=iinterpa
            xname='Water_Ice'
         ;   clevels=[0.0,0.01,0.1,1,10,20,40,60,80,100,1000]
         ;   cannotations=['0','0.01','0.1','1','10','20','40','60','80','100','1000']
         endif
         if x eq 4 then begin
            xinterpa=uinterpa
            xname='Zonal_Wind'
         ;   clevels=[-60,-40,-20,0,20,40,60,80,100,120,140]
         ;   cannotations=['-60','-40','-20','0','20','40','60','80','100','120','140']
         endif
         if x eq 5 then begin
            xinterpa=minterpa
            xname='Meridional_Wind'
         ;   clevels=[-60,-40,-20,0,20,40,60,80,100,120,140]
         ;   cannotations=['-60','-40','-20','0','20','40','60','80','100','120','140']
         endif
         ;loadct,39,/silent
         ;if x ge 0 and x le 3 then contour,reform(mean(xinterpa[0:34,*,*,season_count],dimension=2))*(1.0e6),lat_dim,pinterp,levels=clevels,c_annotation=cannotations,/follow,xstyle=1,ystyle=1,/overplot,color=0,thick=1.5,c_charsize=1.5,c_labels=[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
         ;if x eq 4 or x eq 5 then contour,reform(mean(xinterpa[0:34,*,*,season_count],dimension=2)),lat_dim,pinterp,levels=clevels,c_annotation=cannotations,/follow,xstyle=1,ystyle=1,/overplot,color=0,thick=1.5,c_charsize=1.5,c_labels=[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
         ;xyouts,0,1,xname,/device,charsize=2

         if x ge 0 and x le 3 then SAVE,xinterpa,filename=string(sims[sim],'_',xname,'_xsections.sav')
         if x eq 4 or x eq 5 then SAVE,xinterpa,filename=string(sims[sim],'_',xname,'_xsections.sav')

         season_count=season_count+1

         endif

         ;Count up to the next record/season
         count11=count11+1

      endfor

      close,2

   endfor

endfor

endfor

end
