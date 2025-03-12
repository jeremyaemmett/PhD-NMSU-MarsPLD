pro last_file

sims=FILE_SEARCH('./*RIC*',/TEST_DIRECTORY)

for sim=0,n_elements(sims)-1 do begin

 spawn,'ls '+sims[sim]+'/run/fort.11* -lt | head -5'

endfor

end
