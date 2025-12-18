pro MakeGridsPredSci, p, r_arr, lon_arr, lat_arr
 r_arr=p.Bth_rgrid[0 : n_elements(p.Bth_rgrid)-2]
 lon_arr=p.Br_longrid[0 : n_elements(p.Br_longrid)-2]
 lat_arr=reverse(p.Br_latgrid)
 lat_arr[0]=-90d0+1d-5
 lat_arr[n_elements(lat_arr)-1]=90d0-1d-5
end