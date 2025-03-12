pro streamfunctions

sims=['O15_RIC_CAP','O20_RIC_CAP','O25_RIC_CAP','O30_RIC_CAP','O35_RIC_CAP', $
      'O15_RIC_MID_40','O20_RIC_MID_40','O25_RIC_MID_40','O30_RIC_MID_40','O35_RIC_MID_40',$
      'PRES_RIC_047']

for sim=0,n_elements(sims)-1 do begin

SPAWN,'cp analysis/* '+sims[sim]+'/run'
cd,sims[sim]+'/run'
SPAWN,'ifort -c extractmod.f90'
SPAWN,'ifort -o GCMextract_FB GCMextract_FB.f extractmod.o'
SPAWN,'./GCMextract_FB'

SPAWN,'cp fort.40 fort.40_'+sims[sim]
SPAWN,'cp fort.41 fort.41_'+sims[sim]
SPAWN,'cp fort.42 fort.42_'+sims[sim]
SPAWN,'cp fort.43 fort.43_'+sims[sim]

SPAWN,'mv fort.40_'+sims[sim]+' ../../xsections'
SPAWN,'mv fort.41_'+sims[sim]+' ../../xsections'
SPAWN,'mv fort.42_'+sims[sim]+' ../../xsections'
SPAWN,'mv fort.43_'+sims[sim]+' ../../xsections'

cd,'../..'

endfor

end
