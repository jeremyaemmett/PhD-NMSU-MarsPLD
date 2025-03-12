pro sshforts

sims=['O15_RIC_CAP_MID_40','O20_RIC_CAP_MID_40','O25_RIC_CAP_MID_40','O30_RIC_CAP_MID_40','O35_RIC_CAP_MID_40',$
      'O15_RIC_CAP_MID_60','O20_RIC_CAP_MID_60','O25_RIC_CAP_MID_60','O30_RIC_CAP_MID_60','O35_RIC_CAP_MID_60',$
      'O15_RIC_MID_40','O20_RIC_MID_40','O25_RIC_MID_40','O30_RIC_MID_40','O35_RIC_MID_40',$
      'O15_RIC_MID_60','O20_RIC_MID_60','O25_RIC_MID_60','O30_RIC_MID_60','O35_RIC_MID_60',$
      'O15_RIC_NCAP','O20_RIC_NCAP','O25_RIC_NCAP','O30_RIC_NCAP','O35_RIC_NCAP',$
      'O15_RIC_NMID_40','O20_RIC_NMID_40','O25_RIC_NMID_40','O30_RIC_NMID_40','O35_RIC_NMID_40',$
      'O15_RIC_NMID_60','O20_RIC_NMID_60','O25_RIC_NMID_60','O30_RIC_NMID_60','O35_RIC_NMID_60',$
      'O15_RIC_SCAP','O20_RIC_SCAP','O25_RIC_SCAP','O30_RIC_SCAP','O35_RIC_SCAP',$
      'O15_RIC_SMID_40','O20_RIC_SMID_40','O25_RIC_SMID_40','O30_RIC_SMID_40','O35_RIC_SMID_40',$
      'O15_RIC_SMID_60','O20_RIC_SMID_60','O25_RIC_SMID_60','O30_RIC_SMID_60','O35_RIC_SMID_60',$
      'PRES_RIC_047','PRES_RIC_047_no_outliers']

sims=['O25_RIC_CAP']

for i=0,n_elements(sims)-1 do begin

  print,sims[i]

  year1_11=' '+sims[i]+'/run/fort.11_0010 '+sims[i]+'/run/fort.11_000*'
  year20_11=' '+sims[i]+'/run/fort.11_0159 '+sims[i]+'/run/fort.11_016*'

  year1_45=' '+sims[i]+'/run/fort.45_0010 '+sims[i]+'/run/fort.45_000*'
  year20_45=' '+sims[i]+'/run/fort.45_0159 '+sims[i]+'/run/fort.45_016*'

  ;c11='scp -r'+year1_11+year20_11+' jeem9157@astronomy.nmsu.edu:/home/users/jeem9157/pfe5/'+sims[i]
  c45='scp -r'+year1_45+year20_45+' jeem9157@astronomy.nmsu.edu:/home/users/jeem9157/pfe5/'+sims[i]
  ;SPAWN,c11
  SPAWN,c45

endfor

end
