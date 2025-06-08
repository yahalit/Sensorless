function str = ResetString( x ) 
if x < 0 , x = x+2^32 ; end
str = [':',dec2hex(x),':'] ; 
if bitand( x,1) , str = [str,':POR:'] ; end 
if bitand( x,2) , str = [str,':XRSn:'] ; end 
if bitand( x,4) , str = [str,':WDRSn:'] ; end 
if bitand( x,8) , str = [str,':NMIWDRSn:'] ; end 
if bitand( x,32) , str = [str,':HWBISTn:'] ; end
if bitand( x,256) , str = [str,':SCCRESETn:'] ; end 
if bitand( x,512) , str = [str,':ECAT:'] ; end 
if bitand( x,1024) , str = [str,':SIMRESET_CPU:'] ; end 
if bitand( x,2048) , str = [str,':SIMRESET_XRSn:'] ; end 
end