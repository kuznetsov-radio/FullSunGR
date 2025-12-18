function InterpolatePredSci, Q, r, lon, lat, r_arr, lon_arr, lat_arr
 r_ind=value_locate(r_arr, r)
 r_ind=(r-r_arr[r_ind])/(r_arr[r_ind+1]-r_arr[r_ind])+r_ind
 lon_ind=value_locate(lon_arr, lon)
 lon_ind=(lon-lon_arr[lon_ind])/(lon_arr[lon_ind+1]-lon_arr[lon_ind])+lon_ind
 lat_ind=value_locate(lat_arr, lat)
 lat_ind=(lat-lat_arr[lat_ind])/(lat_arr[lat_ind+1]-lat_arr[lat_ind])+lat_ind
 return, interpolate(Q, lon_ind, lat_ind, r_ind, /grid)
end