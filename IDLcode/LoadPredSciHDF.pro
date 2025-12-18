pro LoadPredSciHDF, filename, scales1, scales2, scales3, datas
 sdId = hdf_sd_start(filename)
 
 datasetId = hdf_sd_select(sdId, 0)
 hdf_sd_getdata, datasetId, scales3
 hdf_sd_endaccess, datasetId

 datasetId = hdf_sd_select(sdId, 1)
 hdf_sd_getdata, datasetId, scales2
 hdf_sd_endaccess, datasetId

 datasetId = hdf_sd_select(sdId, 2)
 hdf_sd_getdata, datasetId, scales1
 hdf_sd_endaccess, datasetId

 datasetId = hdf_sd_select(sdId, 3)
 hdf_sd_getdata, datasetId, datas
 hdf_sd_endaccess, datasetId

 hdf_sd_end, sdId
end