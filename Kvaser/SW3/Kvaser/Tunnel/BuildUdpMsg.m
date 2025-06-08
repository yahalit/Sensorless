function [UdpMessage,udpstr] = BuildUdpMsg(opcode, target , payload , udpstr_in ) 
%udpstr = struct('msgtype',3,'msgcntr',1,'msgpayloadlen',0) ; 

udpstr = udpstr_in ; 

%         msgtype = udpstr.msgtype ; 
        udpstr.msgcntr = mod(udpstr.msgcntr+1,65536) ; 

        msgpayloadlen = length(payload)+4 ; 

        UdpMessage = uint8(zeros(1,256));
        UdpMessage(1) = 5 ; 
        ctrL = mod(udpstr.msgcntr,256) ; 
        UdpMessage(3) = ctrL ; 
        UdpMessage(4) = (udpstr.msgcntr - ctrL)/256 ;

        place = 6 ; nlen = 4 ; 
        UdpMessage((1:nlen)+place) =  udpstr.IPOwnPc ; % (4:-1:1) ;  

        place = place + nlen ; 
        nlen = 2 ; 
        UdpMessage((1:nlen)+place) = dec2baseY( udpstr.HostPort , 256);

        place = place + nlen ; 
        nlen = 2 ; 
        UdpMessage(1+place) = msgpayloadlen + 2  ; 

        place = place + nlen ; 
        nlen = msgpayloadlen  ; % Include also the checksum 
        UdpMessage((1:nlen)+place) = [opcode,target,UdpMessage(3:4),payload]  ; 

        place = place + nlen ; 
        UdpMessage(5) = place + 2 ;

        % Check all contents will hold transition to uint8 
        if ~all(UdpMessage==fix(UdpMessage)) || any(UdpMessage<0) || any(UdpMessage>255)
            error('Payload to UDP must only contain byte data') ; 
        end 

        % Test length and furnish checksum
        if ~(mod(place,4)==2)
            error('Payload to UDP must have N*4 length') ; 
        end 

        cs1 = sum(UdpMessage(15:2:place)) ; 
        cs2 = sum(UdpMessage(16:2:place)) ; 
        cs = mod( 2^20 - cs1 - 256 * cs2 , 65536 ) ;  
        cs1  = mod(cs,256) ; 
        cs2  = (cs - cs1) / 256 ; 
        
        UdpMessage(place+1:place+2) = [cs1 , cs2] ; 

    UdpMessage = UdpMessage(1:place+2) ;     


end 