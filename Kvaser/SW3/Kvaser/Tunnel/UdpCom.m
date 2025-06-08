function [RetVal,err] = UdpCom(Service , Descriptor , Data ) 
%    [1536+NodeId ,1408+NodeId ,Index,SubIndex,DType,0,tout], Data) 
global UdpStr  %#ok<*GVMIS> 
global TargetCanId 
global TargetCanId2 

global DataType ;  
global UdpHandle ;
RetVal = [] ; err = [] ;  

Target = mod(Descriptor(1),128) ; 
t1 = Descriptor(1) - Target ; 
t2 = Descriptor(2) - Target ; 
if ~((t1==1536) && (t2==1408))
    error('This utility is only good for SDO expedits') ; 
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
        error('This utility is only good for scalar types or send strings ') ;     
    end
end

if length(Descriptor) < 7 
    tout = 300 ; 
else
    tout = max(Descriptor(7),300); 
end 

flush(UdpHandle); 
switch Service
    case 7
        opcode = 1 ; 
        cs = 1 ; 
        ind1 = mod(Index,256) ; 
        ind2 = (Index - ind1) / 256 ; 
        for cntRetry = 1:3 
            payload = [uint8(32*cs+Cpu2Obj*16+DType),uint8(ind1),uint8(ind2),uint8(SubIndex),Num2Bytes(Data,DType)] ; 
            [UdpMessage,udpstr] = BuildUdpMsg(opcode, Target , payload , UdpStr );
            flush(UdpHandle); 
            write(UdpHandle,UdpMessage,"uint8",UdpStr.HostIP, UdpStr.HostPort  );
            cntr = udpstr.msgcntr ;
    
            UdpStr = udpstr ; 
    
            t3 = tic ; 
            while 1
                if UdpHandle.NumDatagramsAvailable
                    r = read(UdpHandle,1,"uint8") ; 
                    RetVal = DecodeUdpObject(cntr,DType,r.Data)  ;
                    break ; 
                end 
                if ( toc(t3) > tout * 1e-3 )
                    RetVal = -1 ; 
                    break  ; 
                end   
            end      

            if ( RetVal >= 0 )
                break ; 
            end 
        end 
        if ( RetVal )
            err = RetVal ; 
        end 

    case 8
        % [RetVal,err] = CommFunc( 8 , [1536+NodeId ,1408+NodeId ,Index,SubIndex,DType,0,200] ); % Get records
        opcode = 1 ; 
        cs = 2 ; 
        ind1 = mod(Index,256) ; 
        ind2 = (Index - ind1) / 256 ; 
        payload = [uint8(32*cs+Cpu2Obj*16+DType),uint8(ind1),uint8(ind2),uint8(SubIndex),uint8([0,0,0,0]) ]  ; 
        [UdpMessage,udpstr] = BuildUdpMsg(opcode, Target , payload , UdpStr );

        write(UdpHandle,UdpMessage,"uint8",UdpStr.HostIP, UdpStr.HostPort  );
        cntr = udpstr.msgcntr ;

        UdpStr = udpstr ; 
        
        t3 = tic ; 
        while 1
            if UdpHandle.NumDatagramsAvailable
                r = read(UdpHandle,1,"uint8") ; 
                [Status,Data] = DecodeUdpObject(cntr,DType,r.Data)  ; 
                if ~any(Status(1)==-5)
                    break ; 
                end
            end 
            if ( toc(t3) > tout * 1e-3)
                err = -1 ; 
                return ; 
            end
        end
        
        if ( Status )
            err = Status ; 
        else
            RetVal  = Data ;
        end 
    case 200
        opcode = 3 ; 
        [UdpMessage,udpstr] = BuildUdpMsg(opcode, Target , [0,0,0,0] , UdpStr );

        write(UdpHandle,UdpMessage,"uint8",UdpStr.HostIP, UdpStr.HostPort  );
        cntr = udpstr.msgcntr ;

        UdpStr = udpstr ; 
        
        t3 = tic ; 
        while 1
            if UdpHandle.NumDatagramsAvailable
                r = read(UdpHandle,1,"uint8") ; 
                try
                    pl  = GetUdpPayload(cntr,r.Data,2,3) ; 
                    RetVal = TunnelFields( double(pl) ) ;
                catch 
                    RetVal = [] ; 
                    err    = -6 ; 
                end   
                break ; 
            end 
            if ( toc(t3) > tout * 1e-3)
                err = -1 ; 
                return ; 
            end
        end
    case 201
        % Bring recorder (the subindex is just a vehicle for the data type)
        opcode = 2 ;
        ExpectedLength = Descriptor(6) ;
        kuku = 0 ;
        for cntRetry = 1:3 
            try 
                flush(UdpHandle); 
                [UdpMessage,udpstr] = BuildUdpMsg(opcode, Target , [SubIndex,0,0,0] , UdpStr );
                kuku = kuku+1 ; 
                write(UdpHandle,UdpMessage,"uint8",UdpStr.HostIP, UdpStr.HostPort  );
                cntr = udpstr.msgcntr ;
        
                UdpStr = udpstr ; 
                
                t3 = tic ; 
                while 1
                    if UdpHandle.NumDatagramsAvailable
                        r = read(UdpHandle,1,"uint8") ; 
                        kuku = kuku-1 ; 
                        try
                            pl  = GetUdpPayload(cntr,r.Data,2,2) ; 
        
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
                        break ; 
                    else
                        if ( toc(t3) > tout * 1e-3)
                            err = -1 ; 
                            RetVal = [] ; 
                            break  ; 
                        end
                    end 
                end
            catch 
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