pro transport_ls_looper2

 resolve_routine,'transport_ls2'

sims=['O15_RIC_MID','O20_RIC_CAP','O20_RIC_MID','O25_RIC_CAP','O25_RIC_MID','O30_RIC_CAP','O30_RIC_MID','O35_RIC_CAP','O35_RIC_MID','O40_RIC_CAP','O40_RIC_MID','O45_RIC_CAP','O45_RIC_MID','PRES_RIC']

year1=4
year2=5

for sim=0,n_elements(sims)-1 do begin

 path1='./'+sims[sim]+'/run/'

lsint=15.0
;for year=year1,year2 do begin
year=year1
if year eq year1 then n1=33
if year eq year1 then n2=44
if year eq year2 then n1=43
if year eq year2 then n2=52
 for lsbini=0,23 do begin
  transport_ls2,lsbini,lsint,path1,n1,n2,sims[sim],year
 endfor
;endfor

endfor

end
