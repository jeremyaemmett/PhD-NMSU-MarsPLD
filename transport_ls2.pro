pro transport_ls2,lsbini,lsint,path1,n1,n2,sim,year

startls=lsbini*lsint
endls=startls+lsint

;startls=0.0
;endls=38.4


close,/all



g=3.72



l_layers=24

l_levels=2*l_layers+3



nsig=l_layers

nlat=35

nlon=60



nfile=(n2-n1)+1

grav3=3.72

dsig1=fltarr(l_layers)

topo1=fltarr(36,60)



p1=fltarr(36,60)

t1=fltarr(36,60,24)

u1=fltarr(36,60,24)

v1=fltarr(36,60,24)

tg1=fltarr(36,60)

co2ice1=fltarr(36,60)

stressx1=fltarr(36,60)

stressy1=fltarr(36,60)

tstrat1=fltarr(36,60)

tausurf1=fltarr(36,60)

ssun1=fltarr(36,60)

qtrace1=fltarr(36,60,24,6)

surfalb1=fltarr(36,60)



nsel=n1



nsoltot=nfile*10.



latitude=findgen(35)*5-85.

longitude=findgen(60)*6.-180.



nday=1

nall=0



ntot=nfile*160



;transport arrays



psurf=fltarr(nlat)



vc_jlt=fltarr(nlat,nsig,160*nfile)

vc_jt=fltarr(nlat,160*nfile)

vc_j=fltarr(nlat)



mvapsig_jilt=fltarr(nlat,nlon,nsig,ntot)

mcldsig_jilt=fltarr(nlat,nlon,nsig,ntot)

mdstsig_jilt=fltarr(nlat,nlon,nsig,ntot)

mcorsig_jilt=fltarr(nlat,nlon,nsig,ntot)





vsig_jilt=fltarr(nlat,nlon,nsig,ntot)



qsigh2o_st=fltarr(nlat,nlon,nsig)

qsigh2o_st_v=fltarr(nlat,nlon,nsig)

qsigh2o_st_i=fltarr(nlat,nlon,nsig)

qsigdst_st=fltarr(nlat,nlon,nsig)

qsigdst_st_f=fltarr(nlat,nlon,nsig)

qsigdst_st_c=fltarr(nlat,nlon,nsig)



vsig_st=fltarr(nlat,nlon,nsig)



qvsigh2o_st=fltarr(nlat,nlon,nsig)

qvsigh2o_st_v=fltarr(nlat,nlon,nsig)

qvsigh2o_st_i=fltarr(nlat,nlon,nsig)

qvsigdst_st=fltarr(nlat,nlon,nsig)

qvsigdst_st_f=fltarr(nlat,nlon,nsig)

qvsigdst_st_c=fltarr(nlat,nlon,nsig)



zqvsigh2o_st=fltarr(nlat,nlon)

zqvsigh2o_st_v=fltarr(nlat,nlon)

zqvsigh2o_st_i=fltarr(nlat,nlon)

zqvsigdst_st=fltarr(nlat,nlon)

zqvsigdst_st_f=fltarr(nlat,nlon)

zqvsigdst_st_c=fltarr(nlat,nlon)



tqvsigh2o=fltarr(nlat,nlon,nsig)

tqvsigh2o_v=fltarr(nlat,nlon,nsig)

tqvsigh2o_i=fltarr(nlat,nlon,nsig)

tqvsigdst=fltarr(nlat,nlon,nsig)

tqvsigdst_f=fltarr(nlat,nlon,nsig)

tqvsigdst_c=fltarr(nlat,nlon,nsig)



tqsigh2o=fltarr(nlat,nlon,nsig)

tqsigh2o_v=fltarr(nlat,nlon,nsig)

tqsigh2o_i=fltarr(nlat,nlon,nsig)

tqsigdst=fltarr(nlat,nlon,nsig)

tqsigdst_f=fltarr(nlat,nlon,nsig)

tqsigdst_c=fltarr(nlat,nlon,nsig)



tvsig=fltarr(nlat,nlon,nsig)



ztqsigh2o=fltarr(nlat,nsig)

ztqsigh2o_v=fltarr(nlat,nsig)

ztqsigh2o_i=fltarr(nlat,nsig)

ztqsigdst=fltarr(nlat,nsig)

ztqsigdst_f=fltarr(nlat,nsig)

ztqsigdst_c=fltarr(nlat,nsig)



ztvsig=fltarr(nlat,nsig)



ztqztvsigh2o=fltarr(nlat,nsig)

ztqztvsigh2o_v=fltarr(nlat,nsig)

ztqztvsigh2o_i=fltarr(nlat,nsig)

ztqztvsigdst=fltarr(nlat,nsig)

ztqztvsigdst_f=fltarr(nlat,nsig)

ztqztvsigdst_c=fltarr(nlat,nsig)



ztqvsigh2o=fltarr(nlat,nsig)

ztqvsigh2o_v=fltarr(nlat,nsig)

ztqvsigh2o_i=fltarr(nlat,nsig)

ztqvsigdst=fltarr(nlat,nsig)

ztqvsigdst_f=fltarr(nlat,nsig)

ztqvsigdst_c=fltarr(nlat,nsig)



ztvsigcol=fltarr(nlat)

ztqsigh2ocol=fltarr(nlat)

ztqsigh2ocol_v=fltarr(nlat)

ztqsigh2ocol_i=fltarr(nlat)

ztqsigdstcol=fltarr(nlat)

ztqsigdstcol_f=fltarr(nlat)

ztqsigdstcol_c=fltarr(nlat)







cztqvsigh2o=fltarr(nlat)

cztqvsigh2o_v=fltarr(nlat)

cztqvsigh2o_i=fltarr(nlat)

cztqvsigdst=fltarr(nlat)

cztqvsigdst_f=fltarr(nlat)

cztqvsigdst_c=fltarr(nlat)



cztqztvsigh2o=fltarr(nlat)

cztqztvsigh2o_v=fltarr(nlat)

cztqztvsigh2o_i=fltarr(nlat)

cztqztvsigdst=fltarr(nlat)

cztqztvsigdst_f=fltarr(nlat)

cztqztvsigdst_c=fltarr(nlat)



czqvsigh2o_st=fltarr(nlat)

czqvsigh2o_st_v=fltarr(nlat)

czqvsigh2o_st_i=fltarr(nlat)

czqvsigdst_st=fltarr(nlat)

czqvsigdst_st_f=fltarr(nlat)

czqvsigdst_st_c=fltarr(nlat)







for n=0,nfile-1 do begin

 str1=strcompress(string(floor(nsel)),/remove_all)

 if (nsel le 9) then str2='000'+str1

 if ((nsel gt 9)and(nsel le 99)) then str2='00'+str1

 if (nsel gt 99) then str2='0'+str1

 if (nsel gt 999) then str2=str1

 file1=path1+'fort.11_'+str2

 print,file1



 openr,11,file1,/f77_unformatted



 readu,11,x1,x2,x3,x4,x5,x6



 readu,11, dsig1

 readu,11, topo1



if (n eq 0) then begin



lsavg=0.



topo1b=fltarr(35,60)

topo1b(*,*)=topo1(0:34,*)*(-1.)/grav3

topo1b=rotate(topo1b,4)



nlat=n_elements(latitude)

nlon=n_elements(longitude)

nlay=n_elements(dsig1)



sgm=fltarr(2*nlay+1)



for l=0,nlay-1 do begin

 k=2*l+2

 sgm(k)=sgm(k-2)+dsig1(l)

 ;print,l,k,sgm(k)

endfor



for l=0,nlay-1 do begin

 k=2*l+1

 sgm(k)=(sgm(k+1)+sgm(k-1))/2.

endfor



endif



 for nr=0,159 do begin


    readu,11, TAU1, VPOUT1, RSDIST1, TOFDAY1, PSF1, PTROP1;, TAUTOT, RPTAU, SIND, GASP
    ;tau1=tau1-478.501

      lsbin=fix(vpout1/lsint)

      if vpout1 ge startls and vpout1 le endls and $
      tau1 ge 16056.00*(year) and tau1 le 16056.00*(year+1) then begin
       print,'Ls: ',vpout1,'Ls bin :',lsbin,'# binned: ',nall+1,'Year: ',tau1/16056.00
       lsavg=lsavg+vpout1
      endif

    readu,11, NC31;, NCYCLE



    readu,11, P1

    readu,11, T1

    readu,11, U1

    readu,11, V1

    readu,11, TG1

    readu,11, CO2ICE1

    readu,11, STRESSX1

    readu,11, STRESSY1

    readu,11, TSTRAT1

    readu,11, TAUSURF1

    readu,11, SSUN1

    readu,11, QTRACE1

    readu,11, x;QCOND

    readu,11, x;STEMP

    readu,11, x;fuptopv, fdntopv, fupsurfv, fdnsurfv

    readu,11, x;fuptopir, fupsurfir, fdnsurfir

    readu,11, surfalb1

    readu,11, x; surfalb1

    readu,11, x; surfalb1


   if vpout1 ge startls and vpout1 le endls and $
      tau1 ge 16056.00*(year) and tau1 le 16056.00*(year+1) then begin


    for j=0,nlat-1 do begin

     for i=0,nlon-1 do begin

      for l=0,23 do begin

       vsig_jilt(j,i,l,nall)=v1(j,i,l)             ;Merid Wind Velocity at every J,I,L,record

       mvapsig_jilt(j,i,l,nall)=qtrace1(j,i,l,5)   ;Water Vap Mass Ratio at every J,I,L,record

       mcldsig_jilt(j,i,l,nall)=qtrace1(j,i,l,2)   ;Water Ice Mass Ratio at every J,I,L,record

       mdstsig_jilt(j,i,l,nall)=qtrace1(j,i,l,0)   ;Free Dust Mass Ratio at every J,I,L,record

       mcorsig_jilt(j,i,l,nall)=qtrace1(j,i,l,4)   ;Core Dust Mass Ratio at every J,I,L,record

      endfor

      psurf(j)=psurf(j)+p1(j,i)                    ;Sum psrf-ptrop at latitude J over ls interval

     endfor

    endfor



    nall=nall+1

   endif


 endfor

  

 close,11

 nsel=nsel+1

endfor
lsavg=lsavg/(nall)      ;Average Ls over ls interval
psurf=psurf/(60.*(nall)) ;Average psrf-ptrop over ls interval 

print,startls,endls,nall,lsavg
if nall eq 0 then goto, label1

;goto, label1



qvsigh2o=vsig_jilt*(mvapsig_jilt+mcldsig_jilt)

qvsigh2o_v=vsig_jilt*(mvapsig_jilt)

qvsigh2o_i=vsig_jilt*(mcldsig_jilt)

qvsigdst=vsig_jilt*(mdstsig_jilt+mcorsig_jilt)

qvsigdst_f=vsig_jilt*(mdstsig_jilt)

qvsigdst_c=vsig_jilt*(mcorsig_jilt)


print,'test test test',size(vc_jlt)


print,nall


for j=0,nlat-1 do begin

 for t=0,nall-1 do begin

  for l=0,nsig-1 do begin

   for i=0,nlon-1 do begin

    vc_jlt(j,l,t)=vc_jlt(j,l,t)+vsig_jilt(j,i,l,t)/float(nlon)

   endfor

   vc_jt(j,t)=vc_jt(j,t)+vc_jlt(j,l,t)*dsig1(l)

  endfor

  vc_j(j)=vc_j(j)+vc_jt(j,t)/(nall)

 endfor

endfor


print,'check 1'



for j=0,nlat-1 do begin

 for l=0,nsig-1 do begin



  for i=0,nlon-1 do begin



   for t=0,nall-1 do begin

    tqvsigh2o(j,i,l)=tqvsigh2o(j,i,l)+qvsigh2o(j,i,l,t)/(nall)

    tqvsigh2o_v(j,i,l)=tqvsigh2o_v(j,i,l)+qvsigh2o_v(j,i,l,t)/(nall)

    tqvsigh2o_i(j,i,l)=tqvsigh2o_i(j,i,l)+qvsigh2o_i(j,i,l,t)/(nall)

    tqvsigdst(j,i,l)=tqvsigdst(j,i,l)+qvsigdst(j,i,l,t)/(nall)

    tqvsigdst_f(j,i,l)=tqvsigdst_f(j,i,l)+qvsigdst_f(j,i,l,t)/(nall)

    tqvsigdst_c(j,i,l)=tqvsigdst_c(j,i,l)+qvsigdst_c(j,i,l,t)/(nall)



    tqsigh2o(j,i,l)=tqsigh2o(j,i,l)+(mcldsig_jilt(j,i,l,t)+mvapsig_jilt(j,i,l,t))/(nall)

    tqsigh2o_v(j,i,l)=tqsigh2o_v(j,i,l)+(mvapsig_jilt(j,i,l,t))/(nall)

    tqsigh2o_i(j,i,l)=tqsigh2o_i(j,i,l)+(mcldsig_jilt(j,i,l,t))/(nall)

    tqsigdst(j,i,l)=tqsigdst(j,i,l)+(mdstsig_jilt(j,i,l,t)+mcorsig_jilt(j,i,l,t))/(nall)

    tqsigdst_f(j,i,l)=tqsigdst_f(j,i,l)+(mdstsig_jilt(j,i,l,t))/(nall)

    tqsigdst_c(j,i,l)=tqsigdst_c(j,i,l)+(mcorsig_jilt(j,i,l,t))/(nall)

;    tvsig(j,i,l)=tvsig(j,i,l)+vsig_jilt(j,i,l,t)/(1nall)

    tvsig(j,i,l)=tvsig(j,i,l)+(vsig_jilt(j,i,l,t)-vc_jt(j,t))/(nall)



   endfor



   ztqvsigh2o(j,l)=ztqvsigh2o(j,l)+tqvsigh2o(j,i,l)/float(nlon)

   ztqvsigh2o_v(j,l)=ztqvsigh2o_v(j,l)+tqvsigh2o_v(j,i,l)/float(nlon)

   ztqvsigh2o_i(j,l)=ztqvsigh2o_i(j,l)+tqvsigh2o_i(j,i,l)/float(nlon)

   ztqvsigdst(j,l)=ztqvsigdst(j,l)+tqvsigdst(j,i,l)/float(nlon)

   ztqvsigdst_f(j,l)=ztqvsigdst_f(j,l)+tqvsigdst_f(j,i,l)/float(nlon)

   ztqvsigdst_c(j,l)=ztqvsigdst_c(j,l)+tqvsigdst_c(j,i,l)/float(nlon)



   ztqsigh2o(j,l)=ztqsigh2o(j,l)+tqsigh2o(j,i,l)/float(nlon)

   ztqsigh2o_v(j,l)=ztqsigh2o_v(j,l)+tqsigh2o_v(j,i,l)/float(nlon)

   ztqsigh2o_i(j,l)=ztqsigh2o_i(j,l)+tqsigh2o_i(j,i,l)/float(nlon)

   ztqsigdst(j,l)=ztqsigdst(j,l)+tqsigdst(j,i,l)/float(nlon)

   ztqsigdst_f(j,l)=ztqsigdst_f(j,l)+tqsigdst_f(j,i,l)/float(nlon)

   ztqsigdst_c(j,l)=ztqsigdst_c(j,l)+tqsigdst_c(j,i,l)/float(nlon)

   ztvsig(j,l)=ztvsig(j,l)+tvsig(j,i,l)/float(nlon)



  endfor

  ztqztvsigh2o(j,l)=ztqsigh2o(j,l)*ztvsig(j,l)

  ztqztvsigh2o_v(j,l)=ztqsigh2o_v(j,l)*ztvsig(j,l)

  ztqztvsigh2o_i(j,l)=ztqsigh2o_i(j,l)*ztvsig(j,l)

  ztqztvsigdst(j,l)=ztqsigdst(j,l)*ztvsig(j,l)

  ztqztvsigdst_f(j,l)=ztqsigdst_f(j,l)*ztvsig(j,l)

  ztqztvsigdst_c(j,l)=ztqsigdst_c(j,l)*ztvsig(j,l)



  cztqvsigh2o(j)=cztqvsigh2o(j)+100.*psurf(j)*dsig1(l)/g*ztqvsigh2o(j,l)

  cztqvsigh2o_v(j)=cztqvsigh2o_v(j)+100.*psurf(j)*dsig1(l)/g*ztqvsigh2o_v(j,l)

  cztqvsigh2o_i(j)=cztqvsigh2o_i(j)+100.*psurf(j)*dsig1(l)/g*ztqvsigh2o_i(j,l)

  cztqvsigdst(j)=cztqvsigdst(j)+100.*psurf(j)*dsig1(l)/g*ztqvsigdst(j,l)

  cztqvsigdst_f(j)=cztqvsigdst_f(j)+100.*psurf(j)*dsig1(l)/g*ztqvsigdst_f(j,l)

  cztqvsigdst_c(j)=cztqvsigdst_c(j)+100.*psurf(j)*dsig1(l)/g*ztqvsigdst_c(j,l)



  cztqztvsigh2o(j)=cztqztvsigh2o(j)+100.*psurf(j)*dsig1(l)/g*ztqztvsigh2o(j,l)

  cztqztvsigh2o_v(j)=cztqztvsigh2o_v(j)+100.*psurf(j)*dsig1(l)/g*ztqztvsigh2o_v(j,l)

  cztqztvsigh2o_i(j)=cztqztvsigh2o_i(j)+100.*psurf(j)*dsig1(l)/g*ztqztvsigh2o_i(j,l)

  cztqztvsigdst(j)=cztqztvsigdst(j)+100.*psurf(j)*dsig1(l)/g*ztqztvsigdst(j,l)

  cztqztvsigdst_f(j)=cztqztvsigdst_f(j)+100.*psurf(j)*dsig1(l)/g*ztqztvsigdst_f(j,l)

  cztqztvsigdst_c(j)=cztqztvsigdst_c(j)+100.*psurf(j)*dsig1(l)/g*ztqztvsigdst_c(j,l)



 endfor

endfor



for j=0,nlat-1 do begin

 v2=0.

 q2h2o=0.

 q2h2o_v=0.

 q2h2o_i=0.

 q2dst=0.

 q2dst_f=0.

 q2dst_c=0.



 for l=0,nsig-1 do begin

  v2=v2+dsig1(l)*ztvsig(j,l)

  q2h2o=q2h2o+100.*psurf(j)*dsig1(l)/g*ztqsigh2o(j,l)

  q2h2o_v=q2h2o_v+100.*psurf(j)*dsig1(l)/g*ztqsigh2o_v(j,l)

  q2h2o_i=q2h2o_i+100.*psurf(j)*dsig1(l)/g*ztqsigh2o_i(j,l)

  q2dst=q2dst+100.*psurf(j)*dsig1(l)/g*ztqsigdst(j,l)

  q2dst_f=q2dst_f+100.*psurf(j)*dsig1(l)/g*ztqsigdst_f(j,l)

  q2dst_c=q2dst_c+100.*psurf(j)*dsig1(l)/g*ztqsigdst_c(j,l)



 endfor

 ztvsigcol(j)=v2

 ztqsigh2ocol(j)=q2h2o

 ztqsigh2ocol_v(j)=q2h2o_v

 ztqsigh2ocol_i(j)=q2h2o_i

 ztqsigdstcol(j)=q2dst

 ztqsigdstcol_f(j)=q2dst_f

 ztqsigdstcol_c(j)=q2dst_c



endfor

print,'check 3'



qsigh2o_tr=fltarr(nlat,nlon,nsig,nall)

qsigh2o_tr_v=fltarr(nlat,nlon,nsig,nall)

qsigh2o_tr_i=fltarr(nlat,nlon,nsig,nall)

qsigdst_tr=fltarr(nlat,nlon,nsig,nall)

qsigdst_tr_f=fltarr(nlat,nlon,nsig,nall)

qsigdst_tr_c=fltarr(nlat,nlon,nsig,nall)



vsig_tr=fltarr(nlat,nlon,nsig,nall)

qvsigh2o_tr=fltarr(nlat,nlon,nsig,nall)

qvsigh2o_tr_v=fltarr(nlat,nlon,nsig,nall)

qvsigh2o_tr_i=fltarr(nlat,nlon,nsig,nall)

qvsigdst_tr=fltarr(nlat,nlon,nsig,nall)

qvsigdst_tr_f=fltarr(nlat,nlon,nsig,nall)

qvsigdst_tr_c=fltarr(nlat,nlon,nsig,nall)

print,'check 4'



tqvsigh2o_tr=fltarr(nlat,nlon,nsig)

tqvsigh2o_tr_v=fltarr(nlat,nlon,nsig)

tqvsigh2o_tr_i=fltarr(nlat,nlon,nsig)

tqvsigdst_tr=fltarr(nlat,nlon,nsig)

tqvsigdst_tr_f=fltarr(nlat,nlon,nsig)

tqvsigdst_tr_c=fltarr(nlat,nlon,nsig)



ztqvsigh2o_tr=fltarr(nlat,nlon)

ztqvsigh2o_tr_v=fltarr(nlat,nlon)

ztqvsigh2o_tr_i=fltarr(nlat,nlon)

ztqvsigdst_tr=fltarr(nlat,nlon)

ztqvsigdst_tr_f=fltarr(nlat,nlon)

ztqvsigdst_tr_c=fltarr(nlat,nlon)



cztqvsigh2o_tr=fltarr(nlat)

cztqvsigh2o_tr_v=fltarr(nlat)

cztqvsigh2o_tr_i=fltarr(nlat)

cztqvsigdst_tr=fltarr(nlat)

cztqvsigdst_tr_f=fltarr(nlat)

cztqvsigdst_tr_c=fltarr(nlat)

print,'check 5'



for j=0,nlat-1 do begin

 for l=0,nsig-1 do begin 

  for i=0,nlon-1 do begin

   for t=0,nall-1 do begin

    qsigh2o_tr(j,i,l,t)=(mvapsig_jilt(j,i,l,t)+mcldsig_jilt(j,i,l,t))$

                      -tqsigh2o(j,i,l)

    qsigh2o_tr_v(j,i,l,t)=(mvapsig_jilt(j,i,l,t))-tqsigh2o_v(j,i,l)

    qsigh2o_tr_i(j,i,l,t)=(mcldsig_jilt(j,i,l,t))-tqsigh2o_i(j,i,l)

    qsigdst_tr(j,i,l,t)=(mdstsig_jilt(j,i,l,t)+mcorsig_jilt(j,i,l,t))$

                      -tqsigdst(j,i,l)

    qsigdst_tr_f(j,i,l,t)=(mdstsig_jilt(j,i,l,t))-tqsigdst_f(j,i,l)

    qsigdst_tr_c(j,i,l,t)=(mcorsig_jilt(j,i,l,t))-tqsigdst_c(j,i,l)



;    qsigh2o_tr(j,i,l,t)=(mcldsig_jilt(j,i,l,t))$

;    qsigh2o_tr(j,i,l,t)=(mvapsig_jilt(j,i,l,t))$

    vsig_tr(j,i,l,t)=vsig_jilt(j,i,l,t)-tvsig(j,i,l)

    qvsigh2o_tr(j,i,l,t)=qsigh2o_tr(j,i,l,t)*vsig_tr(j,i,l,t)

    qvsigh2o_tr_v(j,i,l,t)=qsigh2o_tr_v(j,i,l,t)*vsig_tr(j,i,l,t)

    qvsigh2o_tr_i(j,i,l,t)=qsigh2o_tr_i(j,i,l,t)*vsig_tr(j,i,l,t)

    qvsigdst_tr(j,i,l,t)=qsigdst_tr(j,i,l,t)*vsig_tr(j,i,l,t)

    qvsigdst_tr_f(j,i,l,t)=qsigdst_tr_f(j,i,l,t)*vsig_tr(j,i,l,t)

    qvsigdst_tr_c(j,i,l,t)=qsigdst_tr_c(j,i,l,t)*vsig_tr(j,i,l,t)



    tqvsigh2o_tr(j,i,l)=tqvsigh2o_tr(j,i,l)+qvsigh2o_tr(j,i,l,t)/(nall)

    tqvsigh2o_tr_v(j,i,l)=tqvsigh2o_tr_v(j,i,l)+qvsigh2o_tr_v(j,i,l,t)/(nall)

    tqvsigh2o_tr_i(j,i,l)=tqvsigh2o_tr_i(j,i,l)+qvsigh2o_tr_i(j,i,l,t)/(nall)

    tqvsigdst_tr(j,i,l)=tqvsigdst_tr(j,i,l)+qvsigdst_tr(j,i,l,t)/(nall)

    tqvsigdst_tr_f(j,i,l)=tqvsigdst_tr_f(j,i,l)+qvsigdst_tr_f(j,i,l,t)/(nall)

    tqvsigdst_tr_c(j,i,l)=tqvsigdst_tr_c(j,i,l)+qvsigdst_tr_c(j,i,l,t)/(nall)

   endfor

   ztqvsigh2o_tr(j,l)=ztqvsigh2o_tr(j,l)+tqvsigh2o_tr(j,i,l)/float(nlon)

   ztqvsigh2o_tr_v(j,l)=ztqvsigh2o_tr_v(j,l)+tqvsigh2o_tr_v(j,i,l)/float(nlon)

   ztqvsigh2o_tr_i(j,l)=ztqvsigh2o_tr_i(j,l)+tqvsigh2o_tr_i(j,i,l)/float(nlon)

   ztqvsigdst_tr(j,l)=ztqvsigdst_tr(j,l)+tqvsigdst_tr(j,i,l)/float(nlon)

   ztqvsigdst_tr_f(j,l)=ztqvsigdst_tr_f(j,l)+tqvsigdst_tr_f(j,i,l)/float(nlon)

   ztqvsigdst_tr_c(j,l)=ztqvsigdst_tr_c(j,l)+tqvsigdst_tr_c(j,i,l)/float(nlon)

  endfor

  cztqvsigh2o_tr(j)=cztqvsigh2o_tr(j)+100.*psurf(j)*dsig1(l)/g*ztqvsigh2o_tr(j,l)

  cztqvsigh2o_tr_v(j)=cztqvsigh2o_tr_v(j)+100.*psurf(j)*dsig1(l)/g*ztqvsigh2o_tr_v(j,l)

  cztqvsigh2o_tr_i(j)=cztqvsigh2o_tr_i(j)+100.*psurf(j)*dsig1(l)/g*ztqvsigh2o_tr_i(j,l)

  cztqvsigdst_tr(j)=cztqvsigdst_tr(j)+100.*psurf(j)*dsig1(l)/g*ztqvsigdst_tr(j,l)

  cztqvsigdst_tr_f(j)=cztqvsigdst_tr_f(j)+100.*psurf(j)*dsig1(l)/g*ztqvsigdst_tr_f(j,l)

  cztqvsigdst_tr_c(j)=cztqvsigdst_tr_c(j)+100.*psurf(j)*dsig1(l)/g*ztqvsigdst_tr_c(j,l)



 endfor

endfor

print,'check 6'





for l=0,nsig-1 do begin

 for j=0,nlat-1 do begin

  for i=0,nlon-1 do begin

       vsig_st(j,i,l)=tvsig(j,i,l)-ztvsig(j,l)

       qsigh2o_st(j,i,l)=tqsigh2o(j,i,l)-ztqsigh2o(j,l)

       qsigh2o_st_v(j,i,l)=tqsigh2o_v(j,i,l)-ztqsigh2o_v(j,l)

       qsigh2o_st_i(j,i,l)=tqsigh2o_i(j,i,l)-ztqsigh2o_i(j,l)

       qsigdst_st(j,i,l)=tqsigdst(j,i,l)-ztqsigdst(j,l)

       qsigdst_st_f(j,i,l)=tqsigdst_f(j,i,l)-ztqsigdst_f(j,l)

       qsigdst_st_c(j,i,l)=tqsigdst_c(j,i,l)-ztqsigdst_c(j,l)



       qvsigh2o_st(j,i,l) = vsig_st(j,i,l) * qsigh2o_st(j,i,l)

       qvsigh2o_st_v(j,i,l) = vsig_st(j,i,l) * qsigh2o_st_v(j,i,l)

       qvsigh2o_st_i(j,i,l) = vsig_st(j,i,l) * qsigh2o_st_i(j,i,l)

       qvsigdst_st(j,i,l) = vsig_st(j,i,l) * qsigdst_st(j,i,l)

       qvsigdst_st_f(j,i,l) = vsig_st(j,i,l) * qsigdst_st_f(j,i,l)

       qvsigdst_st_c(j,i,l) = vsig_st(j,i,l) * qsigdst_st_c(j,i,l)



       zqvsigh2o_st(j,l)=zqvsigh2o_st(j,l)+qvsigh2o_st(j,i,l)/float(nlon)

       zqvsigh2o_st_v(j,l)=zqvsigh2o_st_v(j,l)+qvsigh2o_st_v(j,i,l)/float(nlon)

       zqvsigh2o_st_i(j,l)=zqvsigh2o_st_i(j,l)+qvsigh2o_st_i(j,i,l)/float(nlon)

       zqvsigdst_st(j,l)=zqvsigdst_st(j,l)+qvsigdst_st(j,i,l)/float(nlon)

       zqvsigdst_st_f(j,l)=zqvsigdst_st_f(j,l)+qvsigdst_st_f(j,i,l)/float(nlon)

       zqvsigdst_st_c(j,l)=zqvsigdst_st_c(j,l)+qvsigdst_st_c(j,i,l)/float(nlon)

  endfor

  czqvsigh2o_st(j)=czqvsigh2o_st(j)+100.*psurf(j)*dsig1(l)/g*zqvsigh2o_st(j,l)

  czqvsigh2o_st_v(j)=czqvsigh2o_st_v(j)+100.*psurf(j)*dsig1(l)/g*zqvsigh2o_st_v(j,l)

  czqvsigh2o_st_i(j)=czqvsigh2o_st_i(j)+100.*psurf(j)*dsig1(l)/g*zqvsigh2o_st_i(j,l)

  czqvsigdst_st(j)=czqvsigdst_st(j)+100.*psurf(j)*dsig1(l)/g*zqvsigdst_st(j,l)

  czqvsigdst_st_f(j)=czqvsigdst_st_f(j)+100.*psurf(j)*dsig1(l)/g*zqvsigdst_st_f(j,l)

  czqvsigdst_st_c(j)=czqvsigdst_st_c(j)+100.*psurf(j)*dsig1(l)/g*zqvsigdst_st_c(j,l)



 endfor

endfor



cztqvsigh2o2=cztqvsigh2o*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.

cztqvsigh2o2_v=cztqvsigh2o_v*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.

cztqvsigh2o2_i=cztqvsigh2o_i*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.

cztqvsigdst2=cztqvsigdst*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.

cztqvsigdst2_f=cztqvsigdst_f*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.

cztqvsigdst2_c=cztqvsigdst_c*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.



cztqztvsigh2o2=cztqztvsigh2o*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.

cztqztvsigh2o2_v=cztqztvsigh2o_v*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.

cztqztvsigh2o2_i=cztqztvsigh2o_i*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.

cztqztvsigdst2=cztqztvsigdst*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.

cztqztvsigdst2_f=cztqztvsigdst_f*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.

cztqztvsigdst2_c=cztqztvsigdst_c*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.



czqvsigh2o_st2=czqvsigh2o_st*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.

czqvsigh2o_st2_v=czqvsigh2o_st_v*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.

czqvsigh2o_st2_i=czqvsigh2o_st_i*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.

czqvsigdst_st2=czqvsigdst_st*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.

czqvsigdst_st2_f=czqvsigdst_st_f*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.

czqvsigdst_st2_c=czqvsigdst_st_c*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.



cztqvsigh2o_tr2=cztqvsigh2o_tr*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.

cztqvsigh2o_tr2_v=cztqvsigh2o_tr_v*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.

cztqvsigh2o_tr2_i=cztqvsigh2o_tr_i*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.

cztqvsigdst_tr2=cztqvsigdst_tr*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.

cztqvsigdst_tr2_f=cztqvsigdst_tr_f*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.

cztqvsigdst_tr2_c=cztqvsigdst_tr_c*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.



cztvqcondh2o=vc_j*ztqsigh2ocol

cztvqcondh2o_v=vc_j*ztqsigh2ocol_v

cztvqcondh2o_i=vc_j*ztqsigh2ocol_i

cztvqconddst=vc_j*ztqsigdstcol

cztvqconddst_f=vc_j*ztqsigdstcol_f

cztvqconddst_c=vc_j*ztqsigdstcol_c



cztvqcondh2o2=cztvqcondh2o*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.

cztvqcondh2o2_v=cztvqcondh2o_v*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.

cztvqcondh2o2_i=cztvqcondh2o_i*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.

cztvqconddst2=cztvqconddst*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.

cztvqconddst2_f=cztvqconddst_f*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.

cztvqconddst2_c=cztvqconddst_c*cos(latitude*!PI/180.)*2.*!PI*3396.*1000.

print,'check 8'

strls=strcompress(string(fix(lsavg)),/remove_all)
strbot=strcompress(string(floor(startls)),/remove_all)
strtop=strcompress(string(floor(endls)),/remove_all)

goto,JUMP3

set_plot,'ps'



loadct,39

!p.font=0.

!p.multi=[0,1,3]

 

strls=strcompress(string(fix(lsavg)),/remove_all)
strbot=strcompress(string(floor(startls)),/remove_all)
strtop=strcompress(string(floor(endls)),/remove_all)



device,file='H2Otransport_3PANEL_Ls'+strls+'_MK.eps',/encaps,/color,/inch,$

       xsize=5.5,ysize=9.5,/helvet

nm1=['Mean Circulation','Stationary Eddies','Transient Eddies','Condensation Flow','Total']

ln1=[0,2,4,5,0]

cl1=[0,0,0,0,250]

plot,latitude,(cztqvsigh2o2_i+cztqvsigh2o2_v)/1.e5,yrange=[-1.75,1.75],$

title='Total Water Meridional Transport at L!Ds!N '+strls,xtitle='Latitude',$

ytitle='Meridional Water Flux (10!E5!N kg s!E-1!N)',$

;/nodata,charthick=2.5,xthick=2.5,ythick=2.5,/ystyle,xrange=[-90,90],$

charthick=2.5,xthick=2.5,ythick=2.5,/ystyle,xrange=[-90,90],$

xticks=6,/xstyle,charsize=1.5,thick=5.

oplot,latitude,(cztqztvsigh2o2_i+cztqztvsigh2o2_v)/1.e5,thick=2.5

oplot,latitude,(czqvsigh2o_st2_i+czqvsigh2o_st2_v)/1.e5,line=2,thick=2.5

oplot,latitude,(cztqvsigh2o_tr2_i+cztqvsigh2o_tr2_v)/1.e5,line=4,thick=2.5

oplot,latitude,(cztvqcondh2o2_i+cztvqcondh2o2_v)/1.e5,line=5,thick=2.5

oplot,latitude,(cztqztvsigh2o2_i+cztqztvsigh2o2_v+czqvsigh2o_st2_i+czqvsigh2o_st2_v+ $

               cztqvsigh2o_tr2_i+cztqvsigh2o_tr2_v+cztvqcondh2o2_i+cztvqcondh2o2_v)/1.e5,$

               col=250,line=0,thick=2.5

;legend,nm1,pos=[15,1.6],line=ln1,col=cl1,thick=2.5,charthick=2.5,charsize=0.75



nm1=['Mean Circulation','Stationary Eddies','Transient Eddies','Condensation Flow','Total']

ln1=[0,2,4,5,0]

cl1=[0,0,0,0,250]

plot,latitude,(cztqvsigh2o2_v)/1.e5,yrange=[-1.75,1.75],$

title='Water Vapor Meridional Transport at L!Ds!N '+strls,xtitle='Latitude',$

ytitle='Meridional Water Flux (10!E5!N kg s!E-1!N)',$

;/nodata,charthick=2.5,xthick=2.5,ythick=2.5,/ystyle,xrange=[-90,90],$

charthick=2.5,xthick=2.5,ythick=2.5,/ystyle,xrange=[-90,90],$

xticks=6,/xstyle,charsize=1.5,thick=5.

oplot,latitude,(cztqztvsigh2o2_v)/1.e5,thick=2.5

oplot,latitude,(czqvsigh2o_st2_v)/1.e5,line=2,thick=2.5

oplot,latitude,(cztqvsigh2o_tr2_v)/1.e5,line=4,thick=2.5

oplot,latitude,(cztvqcondh2o2_v)/1.e5,line=5,thick=2.5

oplot,latitude,(cztqztvsigh2o2_v+czqvsigh2o_st2_v+cztqvsigh2o_tr2_v+cztvqcondh2o2_v)/1.e5,$

     col=250,line=0,thick=2.5

legend,nm1,pos=[0,1.4],line=ln1,col=cl1,thick=2.5,charthick=2.5



nm1=['Mean Circulation','Stationary Eddies','Transient Eddies','Condensation Flow','Total']

ln1=[0,2,4,5,0]

cl1=[0,0,0,0,250]

plot,latitude,(cztqvsigh2o2_i)/1.e5,yrange=[-1.75,1.75],$

title='Water Cloud Meridional Transport at L!Ds!N '+strls,xtitle='Latitude',$

ytitle='Meridional Water Flux (10!E5!N kg s!E-1!N)',$

;/nodata,charthick=2.5,xthick=2.5,ythick=2.5,/ystyle,xrange=[-90,90],$

charthick=2.5,xthick=2.5,ythick=2.5,/ystyle,xrange=[-90,90],$

xticks=6,/xstyle,charsize=1.5,thick=5.

oplot,latitude,(cztqztvsigh2o2_i)/1.e5,thick=2.5

oplot,latitude,(czqvsigh2o_st2_i)/1.e5,line=2,thick=2.5

oplot,latitude,(cztqvsigh2o_tr2_i)/1.e5,line=4,thick=2.5

oplot,latitude,(cztvqcondh2o2_i)/1.e5,line=5,thick=2.5

oplot,latitude,(cztqztvsigh2o2_i+czqvsigh2o_st2_i+cztqvsigh2o_tr2_i+cztvqcondh2o2_i)/1.e5,$

     col=250,line=0,thick=2.5

legend,nm1,pos=[0,1.4],line=ln1,col=cl1,thick=2.5,charthick=2.5





device,/close



device,file='DSTtransport_3PANEL_Ls'+strls+'_MK.eps',/encaps,/color,/inch,$

       xsize=5.5,ysize=9.5,/helvet

nm1=['Mean Circulation','Stationary Eddies','Transient Eddies','Condensation Flow','Total']

ln1=[0,2,4,5,0]

cl1=[0,0,0,0,250]

plot,latitude,(cztqvsigdst2_f+cztqvsigdst2_c)/1.e5,yrange=[-1.75,1.75],$

title='Total Dust Meridional Transport at L!Ds!N '+strls,xtitle='Latitude',$

ytitle='Meridional Dust Flux (10!E5!N kg s!E-1!N)',$

;/nodata,charthick=2.5,xthick=2.5,ythick=2.5,/ystyle,xrange=[-90,90],$

charthick=2.5,xthick=2.5,ythick=2.5,/ystyle,xrange=[-90,90],$

xticks=6,/xstyle,charsize=1.5,thick=5.

oplot,latitude,(cztqztvsigdst2_f+cztqztvsigdst2_c)/1.e5,thick=2.5

oplot,latitude,(czqvsigdst_st2_f+czqvsigdst_st2_c)/1.e5,line=2,thick=2.5

oplot,latitude,(cztqvsigdst_tr2_f+cztqvsigdst_tr2_c)/1.e5,line=4,thick=2.5

oplot,latitude,(cztvqconddst2_f+cztvqconddst2_c)/1.e5,line=5,thick=2.5

oplot,latitude,(cztqztvsigdst2_f+cztqztvsigdst2_c+czqvsigdst_st2_f+czqvsigdst_st2_c+ $

               cztqvsigdst_tr2_f+cztqvsigdst_tr2_c+cztvqconddst2_f+cztvqconddst2_c)/1.e5,$

               col=250,line=0,thick=2.5

legend,nm1,pos=[15,1.6],line=ln1,col=cl1,thick=2.5,charthick=2.5,charsize=0.75



nm1=['Mean Circulation','Stationary Eddies','Transient Eddies','Condensation Flow','Total']

ln1=[0,2,4,5,0]

cl1=[0,0,0,0,250]

plot,latitude,(cztqvsigdst2_f)/1.e5,yrange=[-1.75,1.75],$

title='Free Dust Meridional Transport at L!Ds!N '+strls,xtitle='Latitude',$

ytitle='Meridional Dust Flux (10!E5!N kg s!E-1!N)',$

;/nodata,charthick=2.5,xthick=2.5,ythick=2.5,/ystyle,xrange=[-90,90],$

charthick=2.5,xthick=2.5,ythick=2.5,/ystyle,xrange=[-90,90],$

xticks=6,/xstyle,charsize=1.5,thick=5.

oplot,latitude,(cztqztvsigdst2_f)/1.e5,thick=2.5

oplot,latitude,(czqvsigdst_st2_f)/1.e5,line=2,thick=2.5

oplot,latitude,(cztqvsigdst_tr2_f)/1.e5,line=4,thick=2.5

oplot,latitude,(cztvqconddst2_f)/1.e5,line=5,thick=2.5

oplot,latitude,(cztqztvsigdst2_f+czqvsigdst_st2_f+cztqvsigdst_tr2_f+cztvqconddst2_f)/1.e5,$

     col=250,line=0,thick=2.5

legend,nm1,pos=[0,1.4],line=ln1,col=cl1,thick=2.5,charthick=2.5



nm1=['Mean Circulation','Stationary Eddies','Transient Eddies','Condensation Flow','Total']

ln1=[0,2,4,5,0]

cl1=[0,0,0,0,250]

plot,latitude,(cztqvsigdst2_c)/1.e5,yrange=[-1.75,1.75],$

title='Core Dust Meridional Transport at L!Ds!N '+strls,xtitle='Latitude',$

ytitle='Meridional Dust Flux (10!E5!N kg s!E-1!N)',$

;/nodata,charthick=2.5,xthick=2.5,ythick=2.5,/ystyle,xrange=[-90,90],$

charthick=2.5,xthick=2.5,ythick=2.5,/ystyle,xrange=[-90,90],$

xticks=6,/xstyle,charsize=1.5,thick=5.

oplot,latitude,(cztqztvsigdst2_c)/1.e5,thick=2.5

oplot,latitude,(czqvsigdst_st2_c)/1.e5,line=2,thick=2.5

oplot,latitude,(cztqvsigdst_tr2_c)/1.e5,line=4,thick=2.5

oplot,latitude,(cztvqconddst2_c)/1.e5,line=5,thick=2.5

oplot,latitude,(cztqztvsigdst2_c+czqvsigdst_st2_c+cztqvsigdst_tr2_c+cztvqconddst2_c)/1.e5,$

     col=250,line=0,thick=2.5

legend,nm1,pos=[0,1.4],line=ln1,col=cl1,thick=2.5,charthick=2.5

print,(cztqztvsigdst2_c)/1.e5





device,/close

JUMP3:

save,cztqztvsigh2o2_i,cztqztvsigh2o2_v,czqvsigh2o_st2_i,czqvsigh2o_st2_v,cztqvsigh2o_tr2_i,$
     cztqvsigh2o_tr2_v,cztvqcondh2o2_i,cztvqcondh2o2_v,filename=strcompress('Ls'+strls+'_Yr'+string(year)+'_'+string(sim)+'_H2O.sav',/remove_all)
save,cztqztvsigdst2_f,cztqztvsigdst2_c,czqvsigdst_st2_f,czqvsigdst_st2_c,cztqvsigdst_tr2_f,$
     cztqvsigdst_tr2_c,cztvqconddst2_f,cztvqconddst2_c,filename=strcompress('Ls'+strls+'_Yr'+string(year)+'_'+string(sim)+'_DST.sav',/remove_all)






set_plot,'x'


label1:


;stop



return

end
