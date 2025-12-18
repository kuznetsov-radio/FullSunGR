pro rotCR, r, L0, b0, oneD=oneD
 sl=sin(!dpi*L0/180)
 cl=cos(!dpi*L0/180)
 sb=sin(!dpi*b0/180)
 cb=cos(!dpi*B0/180)
 
 rm=r

 if keyword_set(oneD) then begin
  rm[0, *]= r[0, *]
  rm[1, *]= r[1, *]*cb+r[2, *]*sb
  rm[2, *]=-r[1, *]*sb+r[2, *]*cb
 
  r[0, *]= rm[0, *]*cl+rm[2, *]*sl
  r[1, *]= rm[1, *]
  r[2, *]=-rm[0, *]*sl+rm[2, *]*cl
 endif else begin
  rm[0, *, *]= r[0, *, *]
  rm[1, *, *]= r[1, *, *]*cb+r[2, *, *]*sb
  rm[2, *, *]=-r[1, *, *]*sb+r[2, *, *]*cb
 
  r[0, *, *]= rm[0, *, *]*cl+rm[2, *, *]*sl
  r[1, *, *]= rm[1, *, *]
  r[2, *, *]=-rm[0, *, *]*sl+rm[2, *, *]*cl
 endelse
end