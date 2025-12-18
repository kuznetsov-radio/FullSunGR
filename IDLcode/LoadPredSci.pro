function LoadPredSci, dirname
;Loads the MAS data
;
;Input parameter:
; dirname - the directory where the files are stored.
;
;Return value: a structure containing the data

 d=file_dirname(dirname+path_sep()+'*', /mark_directory)

 file_rho=d+'rho002.hdf'
 file_T  =d+'t002.hdf'
 file_Br =d+'Br002.hdf'
 file_Bth=d+'Bt002.hdf'
 file_Bph=d+'Bp002.hdf'
 
 LoadPredSciHDF, file_Br, scales1, scales2, scales3, datas
 Br_rgrid=double(scales1)
 Br_latgrid=90d0-scales2/!dpi*180
 Br_longrid=scales3/!dpi*180
 Br=transpose(datas, [2, 1, 0])*2.206891397800740d0

 LoadPredSciHDF, file_Bth, scales1, scales2, scales3, datas
 Bth_rgrid=double(scales1)
 Bth_latgrid=90d0-scales2/!dpi*180
 Bth_longrid=scales3/!dpi*180
 Bth=-transpose(datas, [2, 1, 0])*2.206891397800740d0 ;sign must be changed
 
 LoadPredSciHDF, file_Bph, scales1, scales2, scales3, datas
 Bph_rgrid=double(scales1)
 Bph_latgrid=90d0-scales2/!dpi*180
 Bph_longrid=scales3/!dpi*180
 Bph=transpose(datas, [2, 1, 0])*2.206891397800740d0
 
 LoadPredSciHDF, file_rho, scales1, scales2, scales3, datas
 n_rgrid=double(scales1)
 n_latgrid=90d0-scales2/!dpi*180
 n_longrid=scales3/!dpi*180
 n=transpose(datas, [2, 1, 0])*1d8

 LoadPredSciHDF, file_T, scales1, scales2, scales3, datas
 T_rgrid=double(scales1)
 T_latgrid=90d0-scales2/!dpi*180
 T_longrid=scales3/!dpi*180
 T=transpose(datas, [2, 1, 0])*2.807066716734894d7
 
 p={info: 'PredSci data: r in R_Sun, theta and phi in degrees, B in G, T in K, n in cm^{-3}', $
    Br_rgrid: Br_rgrid, $
    Br_latgrid: Br_latgrid, $
    Br_longrid: Br_longrid, $
    Br: Br, $
    Bth_rgrid: Bth_rgrid, $
    Bth_latgrid: Bth_latgrid, $
    Bth_longrid: Bth_longrid, $
    Bth: Bth, $
    Bph_rgrid: Bph_rgrid, $
    Bph_latgrid: Bph_latgrid, $
    Bph_longrid: Bph_longrid, $
    Bph: Bph, $
    n_rgrid: n_rgrid, $
    n_latgrid: n_latgrid, $
    n_longrid: n_longrid, $
    n: n, $
    T_rgrid: T_rgrid, $
    T_latgrid: T_latgrid, $
    T_longrid: T_longrid, $
    T: T}

 return, p
end