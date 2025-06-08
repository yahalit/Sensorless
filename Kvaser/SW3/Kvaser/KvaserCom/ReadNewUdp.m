function [stat,data,kaka] = ReadNewUdp ( ) 
global AtpCfg 
global UdpHandle 

kaka = [] ; 
stat = 1 ; 
if ( AtpCfg.Udp.On ) 
    [A,count,msg,datagramaddress,datagramport] = fread(UdpHandle); 
    if ~isempty(A) 
        x = 1 ; 
    end
    kaka = struct('count',count,'msg',msg,'datagramaddress',datagramaddress,'datagramport',datagramport) ; 
    data = double(A) ; 
else
    stat = -1 ; 
    data = zeros( 1, 14) ; 
end

end