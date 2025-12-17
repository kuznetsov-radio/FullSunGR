pro DownloadPredSci, time, outdir=outdir, masID=masID, masNO=masNO
;Downloads the MAS data files from the Predictive Science site
;
;Input parameters:
; time - required time (any format accepted by the anytim function)
; outdir - if present, specifies the output directory. Default: the current directory
; masID - identifier of the MAS code ('masp' or 'mast'). Default: 'mast'
; masNO - identifier of the MAS iteration ('0101' or '0201'). Default: '0201'

 dtime=anytim(time)

 carr_rot=tim2carr(dtime, /dc)
 carr_rot=floor(carr_rot)
 cstr=string(format='(I4.4)',carr_rot)
 
 print, 'Carrington rotation: ', cstr
 
 if ~exist(masID) then masID='mast'
 if ~exist(masNO) then masNO='0201'
 
 str1='http://www.predsci.com/data/runs/cr'
 str2='-high/hmi_'+masID+'_mas_std_'+masNO+'/corona/

 url_rho=str1+cstr+str2+'rho002.hdf'
 url_T=  str1+cstr+str2+'t002.hdf'
 url_Br= str1+cstr+str2+'br002.hdf'
 url_Bph=str1+cstr+str2+'bp002.hdf' 
 url_Bth=str1+cstr+str2+'bt002.hdf'
 url_Br0=str1+cstr+str2+'br_r0.hdf'    
 
 if exist(outdir) then d=file_dirname(outdir+path_sep()+'*', /mark_directory) else d=''  
  
 obj=obj_new('IDLnetURL')
 print, 'Downloading files ...'
 obj->SetProperty, verbose=1
  
 file_rho=obj->Get(filename=d+'rho002.hdf', url=url_rho)
 print, 'filename returned = ', file_rho
 file_T  =obj->Get(filename=d+'t002.hdf', url=url_T)
 print, 'filename returned = ', file_T
 file_Br =obj->Get(filename=d+'Br002.hdf', url=url_Br)
 print, 'filename returned = ', file_Br
 file_Bth=obj->Get(filename=d+'Bt002.hdf', url=url_Bth)
 print, 'filename returned = ', file_Bth
 file_Bph=obj->Get(filename=d+'Bp002.hdf', url=url_Bph)
 print, 'filename returned = ', file_Bph
 file_Br0=obj->Get(filename=d+'Br_r0.hdf', url=url_Br0)
 print, 'filename returned = ', file_Br0
  
 obj_destroy,obj
 print, 'All downloaded!'
end