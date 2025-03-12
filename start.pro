pro start

  sims=FILE_SEARCH('./*RIC*')
  for i=0,n_elements(sims)-1 do begin
    cd, sims[i]+'/code'
    SPAWN,'make clean'
    SPAWN,'make'
    SPAWN,'cp gcm2.3 ../run'
    cd, '../run'
    SPAWN,'pwd'
    SPAWN,'qsub -q long GCM_script.pbs'
    cd, '../..'
    SPAWN,'pwd'
  endfor

end
