pro ComputeMWimage, p, time, xrange, yrange, frange, Nx, Ny, Nf, $
                    mapI, mapTb, freq, flux, noGR=noGR, noFF=noFF, noNeutral=noNeutral
 AU=1.495978707d13
 RSun=696000d5 
 sfu=1d-19
 kB=1.380649d-16
 c=2.99792458d10
 
 forward_function RenderSphericalMulti, CrossP
 
 r_arr=p.r
 lat_arr=p.lat
 lon_arr=p.lon
 Br_arr=p.Br
 Bth_arr=p.Bth
 Bph_arr=p.Bph
 n_arr=p.n
 T_arr=p.T
 rmin=p.rmin
 
 mode=0
 if keyword_set(noGR) then mode+=1
 if keyword_set(noFF) then mode+=2
 if keyword_set(noNeutral) then mode+=4
  
 a=get_sun(time)
 DSun=a[0]*AU 
 L0=a[10]
 b0=a[11]
 
 x_arr=xrange[0]+(xrange[1]-xrange[0])*dindgen(Nx)/(Nx-1)
 y_arr=yrange[0]+(yrange[1]-yrange[0])*dindgen(Ny)/(Ny-1)
 dx=x_arr[1]-x_arr[0]
 dy=y_arr[1]-y_arr[0]
 
 freq=exp(alog(frange[0])+alog(frange[1]/frange[0])*dindgen(Nf)/(Nf-1))
 
 zmin=-max(r_arr)*1.01*RSun
 zmax= max(r_arr)*1.01*RSun
 
 r1m=dblarr(3, Ny)
 r2m=dblarr(3, Ny)
 LOSm=dblarr(3, Ny)
 norm_xm=dblarr(3, Ny)
 norm_ym=dblarr(3, Ny)
 
 p1m=dblarr(3, Ny)
 p2m=dblarr(3, Ny)
 
 fluxI=dblarr(Nf, Nx, Ny)
 
 for i=0, Nx-1 do begin
  tmL=systime(1)
  
  spx=sin(!dpi/648000*x_arr[i])
  
  for j=0, Ny-1 do begin
   spy=sin(!dpi/648000*y_arr[j])
   q=sqrt(1d0-spx^2-spy^2)
   xD=spx/q
   yD=spy/q
  
   r1m[0, j]=(DSun-zmin)*xD
   r1m[1, j]=(DSun-zmin)*yD
   r1m[2, j]=zmin
   
   r2m[0, j]=(DSun-zmax)*xD
   r2m[1, j]=(DSun-zmax)*yD
   r2m[2, j]=zmax 
   
   LOSm[0, j]=(zmin-zmax)*xD
   LOSm[1, j]=(zmin-zmax)*yD
   LOSm[2, j]=zmax-zmin 
   LOSm[*, j]/=sqrt(LOSm[0, j]^2+LOSm[1, j]^2+LOSm[2, j]^2)
   
   norm_xm[*, j]=CrossP([0d0, 1d0, 0d0], LOSm[*, j])
   norm_ym[*, j]=CrossP(LOSm[*, j], norm_xm[*, j])
  endfor
   
  r1m/=RSun
  r2m/=RSun
 
  rotCR, r1m, L0, b0, /oneD
  rotCR, r2m, L0, b0, /oneD
  rotCR, LOSm, L0, b0, /oneD
  rotCR, norm_xm, L0, b0, /oneD
  rotCR, norm_ym, L0, b0, /oneD
  
  p1m[0, *]=sqrt(r1m[0, *]^2+r1m[1, *]^2+r1m[2, *]^2)
  p1m[1, *]=atan(r1m[0, *], r1m[2, *])/!dpi*180
  p1m[2, *]=asin(r1m[1, *]/p1m[0, *])/!dpi*180
  p2m[0, *]=sqrt(r2m[0, *]^2+r2m[1, *]^2+r2m[2, *]^2)
  p2m[1, *]=atan(r2m[0, *], r2m[2, *])/!dpi*180
  p2m[2, *]=asin(r2m[1, *]/p2m[0, *])/!dpi*180
   
  NvoxM=RenderSphericalMulti(Ny, lon_arr, lat_arr, r_arr, p1m, p2m, rmin, indexM, dlM, $
                             lon_ind_M, lat_ind_M, r_ind_M, /closed)                           
                            
  s=size(indexM, /dimensions)
  Nz=s[0]
 
  Lparms_M=[Ny, Nz, Nf, 0, 0, 0]
 
  Rparms_M=dblarr(3, Ny)
  Rparms_M[0, *]=dx*dy*(AU*!dpi/648000)^2
  Rparms_M[1, *]=-1
 
  Parms_M=dblarr(15, Nz, Ny)
  for j=0, Ny-1 do begin
   Nz_local=NvoxM[j]
  
   if Nz_local gt 0 then begin
    Parms_M[0, 0 : Nz_local-1, j]=dlM[0 : Nz_local-1, j]*RSun ;dz
   
    Parms_M[1, 0 : Nz_local-1, j]=interpolate(T_arr, $
                                              lon_ind_M[ 0 : Nz_local-1, j], $
                                              lat_ind_M[ 0 : Nz_local-1, j], $
                                              r_ind_M[ 0 : Nz_local-1, j]); T
    Parms_M[2, 0 : Nz_local-1, j]=interpolate(n_arr, $
                                              lon_ind_M[ 0 : Nz_local-1, j], $
                                              lat_ind_M[ 0 : Nz_local-1, j], $
                                              r_ind_M[ 0 : Nz_local-1, j]); n

    lon_local=interpolate(lon_arr, lon_ind_M[ 0 : Nz_local-1, j])
    lat_local=interpolate(lat_arr, lat_ind_M[ 0 : Nz_local-1, j])
    sp=sin(lon_local*!dpi/180)
    cp=cos(lon_local*!dpi/180)
    st=sin(lat_local*!dpi/180)
    ct=cos(lat_local*!dpi/180)
    Br_local=interpolate(Br_arr, $
                         lon_ind_M[ 0 : Nz_local-1, j], $
                         lat_ind_M[ 0 : Nz_local-1, j], $
                         r_ind_M[ 0 : Nz_local-1, j])
    Bth_local=interpolate(Bth_arr, $
                          lon_ind_M[ 0 : Nz_local-1, j], $
                          lat_ind_M[ 0 : Nz_local-1, j], $
                          r_ind_M[ 0 : Nz_local-1, j])
    Bph_local=interpolate(Bph_arr, $
                          lon_ind_M[ 0 : Nz_local-1, j], $
                          lat_ind_M[ 0 : Nz_local-1, j], $
                          r_ind_M[ 0 : Nz_local-1, j])      
    Bx=Br_local*sp*ct+Bph_local*cp-Bth_local*sp*st
    By=Br_local*st+Bth_local*ct
    Bz=Br_local*cp*ct-Bph_local*sp-Bth_local*cp*st    
    Bnorm=sqrt(Bx^2+By^2+Bz^2)                                                         
    Parms_M[3, 0 : Nz_local-1, j]=sqrt(Br_local^2+Bth_local^2+Bph_local^2) ;B
    Parms_M[4, 0 : Nz_local-1, j]= $
     acos((Bx*LOSm[0, j]+By*LOSm[1, j]+Bz*LOSm[2, j])/Bnorm)/!dpi*180 ;theta
    Parms_M[5, 0 : Nz_local-1, j]= $
     atan(Bx*norm_ym[0, j]+By*norm_ym[1, j]+Bz*norm_ym[2, j], $ 
          Bx*norm_xm[0, j]+By*norm_xm[1, j]+Bz*norm_xm[2, j])/!dpi*180 ;psi
   
    Parms_M[6, 0 : Nz_local-1, j]=mode ;emission mechanism
    Parms_M[7, 0 : Nz_local-1, j]=10 ;s_max
   endif
  endfor
 
  RLm=dblarr(7, Nf, Ny)
  for j=0, Ny-1 do RLm[0, *, j]=freq
 
  res=call_external('GRFF_DEM_Transfer_64.dll', 'GET_MW_SLICE', $
                    Lparms_M, Rparms_M, Parms_M, 0, 0, 0, RLm)
  fluxI[*, i, *]=reform(RLm[5, *, *]+RLm[6, *, *], Nf, Ny)
  
  print, 'Line No.: ', i+1, ', elapsed time: ', systime(1)-tmL, ' s' 
 endfor
 
 flux=dblarr(Nf)
 mapI=obj_new('map')
 mapTb=obj_new('map')
 for k=0, Nf-1 do begin
  m=make_map(reform(fluxI[k, *, *], Nx, Ny), dx=dx, dy=dy, freq=freq[k], $
             id=string(freq[k], format='(F5.2)')+' GHz', time=t0)
  mapI->setmap, k, m
  flux[k]=total(m.data)
  
  r=sfu*c^2/(2.0*kB*(freq[k]*1d9)^2)/(dx*dy*(!dpi/180/60/60)^2)
  m=make_map(reform(fluxI[k, *, *], Nx, Ny)*r, dx=dx, dy=dy, freq=freq[k], $
             id=string(freq[k], format='(F5.2)')+' GHz', time=t0)
  mapTb->setmap, k, m
 endfor
end