function [RetVal,err] = UdpComJava(Service , Descriptor , Data ) 
%    [1536+NodeId ,1408+NodeId ,Index,SubIndex,DType,0,tout], Data) 
global UdpStr  %#ok<*GVMIS> 
global TargetCanId 
global TargetCanId2 

global DataType ;  
global UdpHandle ;

% Code borrowed from O'Reilly Learning Java, edition 2, chapter 12.
import java.io.*
import java.net.DatagramSocket
import java.net.DatagramPacket
import java.net.InetAddress

RetVal = [] ; err = [] ;  

Target = mod(Descriptor(1),128) ; 
t1 = Descriptor(1) - Target ; 
t2 = Descriptor(2) - Target ; 
if ~((t1==1536) && (t2==1408))
    error('This utility is only good for SDO') ; 
end
if (Target==TargetCanId)
    Cpu2Obj = 0 ; 
elseif (Target==TargetCanId2)
    Cpu2Obj = 1 ; 
else
    % Not for UDP, attempt CAN 
    [RetVal,err] = KvaserCom(Service , Descriptor , Data )  ; 
end

Index = Descriptor(3);
SubIndex = Descriptor(4);
DType = Descriptor(5); 
if  ~ any(DType==[DataType.long,DataType.float,DataType.short,DataType.char]) 
    if ~(( Service == 7) && (DataType.string == DType) ) 
        error('This utility is only good for scalar types or send strings (hint: recorder asked for short var?)') ;     
    end
end

if length(Descriptor) < 7 
    tout = 300 ; 
else
    tout = max(Descriptor(7),300); 
end 



% Kill anything that may wait in UDP mail 


switch Service
    case 7
        % Send 
        opcode = 1 ; 
        cs = 1 ; 
        ind1 = mod(Index,256) ; 
        ind2 = (Index - ind1) / 256 ; 
        for cntRetry = 1:3 
            payload = [uint8(32*cs+Cpu2Obj*16+DType),uint8(ind1),uint8(ind2),uint8(SubIndex),Num2Bytes(Data,DType)] ; 
            JavaUdpflush(); 

            cntr = JavaTxUdpPayload(opcode, Target , payload);
   
            RetVal = JavaRxUdpPayload(cntr,DType,tout,576) ; 

            if ( RetVal >= 0 )
                break ; 
            end 
        end 
        if ( RetVal )
            err = RetVal ; 
        end 

    case 8
        % Receive 
        % [RetVal,err] = CommFunc( 8 , [1536+NodeId ,1408+NodeId ,Index,SubIndex,DType,0,200] ); % Get records
        opcode = 1 ; 
        cs = 2 ; 
        ind1 = mod(Index,256) ; 
        ind2 = (Index - ind1) / 256 ; 
        payload = [uint8(32*cs+Cpu2Obj*16+DType),uint8(ind1),uint8(ind2),uint8(SubIndex),uint8([0,0,0,0]) ]  ;
        


        for cntRetry = 1:3 
            JavaUdpflush(); 
            cntr = JavaTxUdpPayload(opcode, Target , payload);
            [RetVal,Data] = JavaRxUdpPayload(cntr,DType,tout,576) ;             
            if ( RetVal )
                err = RetVal ; 
            else
                RetVal  = Data ;
            end 
        end

    case 200
        % GetState all in one message
        opcode = 3 ; 

        DontDecode = 1; 
        payload = [0,0,0,0]; 
        JavaUdpflush(); 
        cntr = JavaTxUdpPayload(opcode, Target , payload);
        [RetVal,Data] = JavaRxUdpPayload(cntr,DType,tout,576,DontDecode ) ;             
        if ( RetVal )
            err = RetVal ; 
        else
            try
                pl  = GetUdpPayload(cntr,Data,2,3) ; 
                RetVal = TunnelFields( double(pl) ) ;
                RetVal.RawData = double(pl) ; 
            catch 
                RetVal = [] ; 
                err    = -6 ; 
            end   
        end

    case 201
        % Bring recorder (the subindex is just a vehicle for the data type)
        opcode = 2 ;
        DontDecode = 1; 
        ExpectedLength = Descriptor(6) ;
        kuku = 0 ;
        payload = [SubIndex,0,0,0]; 
        for cntRetry = 1:3 
            JavaUdpflush();  
            cntr = JavaTxUdpPayload(opcode, Target , payload);
            [RetVal,Data] = JavaRxUdpPayload(cntr,DType,tout,576,DontDecode ) ;             
            try
                pl  = GetUdpPayload(cntr,Data,2,2) ; 
    
                if length(pl) < 4
                    err = -7; 
                else
                    RetVal = typecast (uint8(pl(1:4)),'uint32') ;
                    if RetVal(1)  
                        err = RetVal ;
                        RetVal = [] ; 
                    else
                        RetVal = GetRecorderVec ( double(pl(5:end)) , SubIndex ) ;
                    end 
                end
            catch 
                RetVal = [] ; 
                err    = -6 ; 
            end
            if length(RetVal) == ExpectedLength % Good length, may break loop 
                break ; 
            end
        end
        if (length(RetVal) == ExpectedLength) % Good length, may break loop 
            err = []  ;
        else
            if isempty(err) 
                err = -8; 
            end 
        end
%         if UdpHandle.NumDatagramsAvailable
%             muku = 1 ; 
%         end 
%         if kuku
%             muku = 1 ; 
%         end 
% 

end 



end 