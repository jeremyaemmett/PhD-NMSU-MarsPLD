pro water_conserve_endpoints

sims=['O15_RIC_CAP','O20_RIC_CAP','O25_RIC_CAP','O30_RIC_CAP','O35_RIC_CAP','O15_RIC_MID_40','O20_RIC_MID_40','O25_RIC_MID_40','O30_RIC_MID_40','O35_RIC_MID_40','O15_RIC_NMID_40','O20_RIC_NMID_40','O25_RIC_NMID_40','O30_RIC_NMID_40','O35_RIC_NMID_40','O15_RIC_NMID_60','O20_RIC_NMID_60','O25_RIC_NMID_60','O30_RIC_NMID_60','O35_RIC_NMID_60','O15_RIC_SMID_40','O20_RIC_SMID_40','O25_RIC_SMID_40','O30_RIC_SMID_40','O35_RIC_SMID_40','O15_RIC_SMID_60','O20_RIC_SMID_60','O25_RIC_SMID_60','O30_RIC_SMID_60','O35_RIC_SMID_60''PRES_RIC_047']

;sims=['PRES_RIC_047']

year=19

;Constants
lat_dim=findgen(35)*5-85
lon_dim=findgen(60)*(360.0/60.0)-180
lon_dim[-1]=179.999
j_array=(indgen(36,60)) mod 36
porb=16056.0
types=[' total',' north',' south',' other']

for sim=0,n_elements(sims)-1 do begin
  path=sims[sim]+'/run/'
  print,sims[sim]

  ;Specify the first and last record file number for reading
  fort11s=[118,126,134,143,151,159,168,176,184,193,201,210,218,226]
  fort11s=[9,17,26,34,42,51,59,67,76,84,92,101,109,118,126,134,143,151,159,168]
  fort11_1=fort11s[0] & fort11_2=fort11s[-1]

  ;Number of records that are expected to be read
  n_records=160*(fort11_2-fort11_1+1)

  for type=0,0 do begin
    if type eq 0 then begin
      lat1=0
      lat2=34
    endif
    if type eq 1 then begin
      lat1=33
      lat2=34
    endif
    if type eq 2 then begin
      lat1=0
      lat2=1
    endif
    if type eq 3 then begin
      lat1=2
      lat2=32
    endif

  ;Declare Variables
  tau4=fltarr(1) & vpout4=fltarr(1) & rsdist4=fltarr(1) & tofday4=fltarr(1) & psf4=fltarr(1) & ptrop=fltarr(1)
  dxyp=fltarr(36) & grav=fltarr(1) & rgas=fltarr(24) & dsig4=fltarr(24)
  p4=fltarr(36,60) & tausurf4=fltarr(36,60) 
  h2o_vap_atm=fltarr(1) & h2o_ice_atm=fltarr(1) & h2o_ice_gnd=fltarr(1)	
  qcond4=fltarr(36,60,6) & qtrace4=fltarr(36,60,24,6)

  ;Declare Storage Arrays
  vpout4a=fltarr(n_records) & year_array=intarr(n_records) & lsa=fltarr(n_records)
  h2o_vap_atm_globally_integrated=fltarr(n_records) & h2o_ice_atm_globally_integrated=fltarr(n_records)
  h2o_ice_gnd_globally_integrated=fltarr(n_records)
  tausurf4a=fltarr(36,60,n_records)

  ;Loop through the first to last desired output files
  count11=0
  total=[]
  for fnum=0,n_elements(fort11s)-1 do begin
    ;Determine the name of the output file to read
    fnum2=fort11s[fnum]
    if fnum2 eq 0 then file_extension=''
    if fnum2 ge 1 then file_extension=string('_000',strtrim(fnum2,1))
    if fnum2 ge 10 then file_extension=string('_00',strtrim(fnum2,1))
    if fnum2 ge 100 then file_extension=string('_0',strtrim(fnum2,1))
    fort11=path+'fort.11'+file_extension & fort45=path+'fort.45'+file_extension
    ;print,fort11

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

      readu,2,tau4,vpout4,rsdist4,tofday4,psf4,ptrop4
      readu,2
      readu,2,p4
      for rep=1,10 do readu,2
      readu,2,qtrace4
      readu,2,qcond4
      for rep=1,6 do readu,2	
      

      ;if count11 eq 0 then year=fix(tau4/porb)
      year=fix(tau4/porb)
      vpout4a[count11]=vpout4
      ;if vpout4a[count11]-vpout4a[count11-1] lt 0 then year=year+1
      year_array[count11]=year
      lsa[count11]=vpout4+360.0*year
      ;print,lsa[count11],year

        
	;Calculate total water in the atmosphere and on the ground
        h2o_vap_atm=0.0*h2o_vap_atm
        h2o_ice_atm=0.0*h2o_ice_atm
        h2o_ice_gnd=0.0*h2o_ice_gnd
       
        for k=0,59 do begin
          for j=lat1,lat2 do begin
            for l=0,23 do begin
              h2o_vap_atm=h2o_vap_atm+(dxyp[j])*((dsig4(l))*p4[j,k]*100.0/grav[0])*qtrace4(j,k,l,5)
              h2o_ice_atm=h2o_ice_atm+(dxyp[j])*((dsig4(l))*p4[j,k]*100.0/grav[0])*qtrace4(j,k,l,2)
            endfor
	    h2o_ice_gnd=h2o_ice_gnd+(dxyp[j])*qcond4[j,k,5]      
          end
        endfor

        h2o_vap_atm_globally_integrated[count11]=h2o_vap_atm
        h2o_ice_atm_globally_integrated[count11]=h2o_ice_atm
        h2o_ice_gnd_globally_integrated[count11]=h2o_ice_gnd

        if (lsa[count11] mod 360.0)-(lsa[count11-1] mod 360.0) lt 0.0 then begin
          ;print,lsa[count11],(lsa[count11] mod 360.0),year,h2o_vap_atm+h2o_ice_atm+h2o_ice_gnd
          total=[total,h2o_vap_atm+h2o_ice_atm+h2o_ice_gnd]
        endif

        ;Count up to the next record
        count11=count11+1

      endfor

      close,2

  endfor

  h2o_vap_atm_globally_integrated=h2o_vap_atm_globally_integrated[where(year_array eq 19)]
  h2o_ice_atm_globally_integrated=h2o_ice_atm_globally_integrated[where(year_array eq 19)]
  h2o_ice_gnd_globally_integrated=h2o_ice_gnd_globally_integrated[where(year_array eq 19)]
  lsa=lsa[where(year_array eq 19)]
  h2o_tot_atm_globally_integrated=h2o_vap_atm_globally_integrated+h2o_ice_atm_globally_integrated
  h2o_tot_gnd_globally_integrated=h2o_ice_gnd_globally_integrated
  h2o_tot_all_globally_integrated=h2o_tot_atm_globally_integrated+h2o_tot_gnd_globally_integrated

percent_change=100.0*(h2o_tot_all_globally_integrated[-1]-h2o_tot_all_globally_integrated[0])/h2o_tot_all_globally_integrated[0]

cap_equiv=100.0*( (h2o_tot_all_globally_integrated[-1]-h2o_tot_all_globally_integrated[0])/(dxyp[0]*60.0+dxyp[1]*60.0) )/900.0

print,total
diffs=total[indgen(n_elements(total))]-total[indgen(n_elements(total))-1]
diffs=diffs[1:-1]
diffs=[diffs,0.0]
diffs=100.0*diffs/total
print,diffs

endfor

endfor

;WRITE_PNG,path+'water_conservation_year1.png', TVRD(/TRUE)

end
