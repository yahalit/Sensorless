function  FlushUdpInQueue() 
global AtpCfg 
global UdpHandle 

if ( AtpCfg.Udp.On ) 
    flushinput(UdpHandle) ; 
end 

end 