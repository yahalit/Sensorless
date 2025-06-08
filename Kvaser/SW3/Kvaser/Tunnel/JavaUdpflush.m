function JavaUdpflush()
global UdpStr %#ok<GVMIS> 

import java.io.*
import java.net.DatagramSocket
import java.net.DatagramPacket
import java.net.InetAddress


packetLength = 100 ; 

while(1)        
    try 
        packet = DatagramPacket(zeros(1,packetLength,'int8'),packetLength);        
        UdpStr.Socket.receive(packet);
    catch % receiveError
        return ;
    end
end 