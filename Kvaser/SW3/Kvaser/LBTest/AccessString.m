function str = AccessString( x ) 
if x < 0 , x = x+2^32 ; end
str = [':',dec2hex(x),':'] ; 
if bitand( x,1) , str = [str,':NM_CPUREAD:'] ; end 
if bitand( x,2) , str = [str,':NM_CPUWRITE:'] ; end 
if bitand( x,4) , str = [str,':NM_CPUFETCH:'] ; end 
if bitand( x,8) , str = [str,':NM_DMAWRITE:'] ; end 
if bitand( x,16) , str = [str,':NM_CLA1READ:'] ; end
if bitand( x,32) , str = [str,':NM_CLA1WRITE:'] ; end
if bitand( x,64) , str = [str,':NM_CLA1FETCH:'] ; end 
if bitand( x,2^10) , str = [str,':NM_DMAREAD:'] ; end 
if bitand( x,2^12) , str = [str,':M_CPUFETCH:'] ; end 
if bitand( x,2^13) , str = [str,':M_CPUWRITE:'] ; end 
if bitand( x,2^14) , str = [str,':M_DMAWRITE:'] ; end 
if bitand( x,2^15) , str = [str,':WAS_ACCESS_VIOLATE_INT:'] ; end 
end