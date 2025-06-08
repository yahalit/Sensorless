function cntr = JavaTxUdpPayload(opcode, Target ,payload)
global UdpStr %#ok<GVMIS> 

import java.io.*
import java.net.DatagramSocket
import java.net.DatagramPacket
import java.net.InetAddress

try 
    [UdpMessage,udpstr] = BuildUdpMsg(opcode, Target , payload , UdpStr );
    packet = DatagramPacket(UdpMessage, length(UdpMessage), UdpStr.HostIpAddr, UdpStr.HostPort);
    UdpStr.Socket.send(packet);
    cntr = udpstr.msgcntr ;
    UdpStr = udpstr ; 
catch mycatch
end 

end 

