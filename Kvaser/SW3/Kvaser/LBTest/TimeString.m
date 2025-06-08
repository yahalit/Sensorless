function s = TimeString(m ) 

m = m / 1000 ; 
f = mod( m , 1 ) ; 
secs = fix(m) ; 
secsall = fix(secs) ; 
secs = mod(secsall,60 ) ; 
minsall = fix( secsall / 60 ) ;
mins = mod(minsall,60 ) ; 
hrs  = fix( minsall / 60 ) ;
s = [num2str(hrs),':',num2str(mins),':',num2str(secs),'.',num2str(round(f*10))] ;    


