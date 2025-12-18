pro MakeMWimagePredSci
 InDir='.'
 t0='2025-08-31 03:30:00'
 
 x1=-1100d0
 x2= 1100d0
 y1=-1100d0
 y2= 1100d0
 Nx=220L
 Ny=220L
 
 f1=0.1d0
 f2=9.5499260
 Nf=100L
 
 forward_function LoadPredSci
 
 p0=LoadPredSci(InDir)
 p1=PreprocessPredSci(p0)
 
 ComputeMWimage, p1, t0, [x1, x2], [y1, y2], [f1, f2], Nx, Ny, Nf, $
                 mapI, mapTb, freq, flux
                    
 save, mapI, mapTb, freq, flux, filename='mapI.sav', /compress
end