function [Status,Data] = JavaRxUdpPayload(cntr,DType,tout,MaxPacketLength,DontDecode)
global UdpStr %#ok<GVMIS> 

import java.io.*
import java.net.DatagramSocket
import java.net.DatagramPacket
import java.net.InetAddress


t3 = tic ; 
if nargin < 4 
    packetLength = 576 ; 
else
    packetLength = MaxPacketLength ; 
end 
if nargin < 5 
    DontDecode = 0 ; 
end 

while 1
    try 
        packet = DatagramPacket(zeros(1,packetLength,'uint8'),packetLength);        
        UdpStr.Socket.receive(packet);
        r = packet.getData; 
        r = r(1:packet.getLength); 
        inetAddress = packet.getAddress;
        if isequal(inetAddress,UdpStr.HostIpAddr) 
            r = double(r) ; 
            ind = find(r< 0) ; 
            r(ind) = r(ind) + 256 ; 
            r = uint8(r) ; 
            if DontDecode 
                Status = 0 ; 
                Data   = r ;
            else
                [Status,Data] = DecodeUdpObject(cntr,DType,r)  ;   
            end 
            return  ; 
        end 
    catch 
    end

    if ( toc(t3) > tout * 1e-3 )
        Status = -1 ; 
        Data = [] ; 
        return  ; 
    end   

end      
