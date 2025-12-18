function PreprocessPredSci, p
 forward_function InterpolatePredSci

 MakeGridsPredSci, p, r_arr, lon_arr, lat_arr
 rmin=min(r_arr)
 
 T_arr=InterpolatePredSci(p.T, r_arr, lon_arr, lat_arr, p.T_rgrid, p.T_longrid, p.T_latgrid)
 n_arr=InterpolatePredSci(p.n, r_arr, lon_arr, lat_arr, p.n_rgrid, p.n_longrid, p.n_latgrid)
 Br_arr=InterpolatePredSci(p.Br, r_arr, lon_arr, lat_arr, p.Br_rgrid, p.Br_longrid, p.Br_latgrid)
 Bth_arr=InterpolatePredSci(p.Bth, r_arr, lon_arr, lat_arr, p.Bth_rgrid, p.Bth_longrid, p.Bth_latgrid)
 Bph_arr=InterpolatePredSci(p.Bph, r_arr, lon_arr, lat_arr, p.Bph_rgrid, p.Bph_longrid, p.Bph_latgrid)
 
 return, {info1: 'Full Sun coronal data', $
          info2: 'r in R_Sun, theta (lat) and phi (lon) in degrees, B in G, T in K, n in cm^{-3}', $
          info3: 'The arrays have the format: n(lon, lat, r), etc.', $
          r: r_arr, $
          lon: lon_arr, $
          lat: lat_arr, $
          rmin: rmin, $
          Br: Br_arr, $
          Bth: Bth_arr, $
          Bph: Bph_arr, $
          T: T_arr, $
          n: n_arr}
end