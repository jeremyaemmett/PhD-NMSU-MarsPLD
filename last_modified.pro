pro last_modified

test=file_search('*RIC*')
for i=0,n_elements(test)-1 do begin
  if strpos(test[i],'.sav') eq -1 then SPAWN,'ls -tr '+test[i]+'/run/fort.11* | tail -1 '
  if strpos(test[i],'.sav') eq -1 then SPAWN,'ls -tr '+test[i]+'/run/fort.45* | tail -1 '
  if strpos(test[i],'.sav') eq -1 then SPAWN,'ls -tr '+test[i]+'/run/fort.51* | tail -1 '
  if strpos(test[i],'.sav') eq -1 then SPAWN,'ls -tr '+test[i]+'/run/fort.91* | tail -1 '
  print,''
endfor


end
