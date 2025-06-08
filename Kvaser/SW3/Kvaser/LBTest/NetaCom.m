function [RetVal,err] = NetaCom( service , paramvec, Data )
    global SciConfig ;
    s = SciConfig.s ; 
    global DataType ;

    err = [];
    set_flag = 0;
    switch service

        case 9 %Fetch objects vec. 
            %change: now need to be able to send a vector.
            disp('Service is fetch') ; 
            disp( ['COB ID : ', num2str(paramvec(1,1) ) ]) ; 
            disp( ['COB ID of returned message: ', num2str(paramvec(1,2) ) ]) ; 
            disp( ['Index : ', num2str(paramvec(1,3) ) ]) ; 
            disp( ['SubIndex : ', num2str(paramvec(1,4) ) ]) ; 
            disp( ['Data type : ', num2str(paramvec(1,5) ) ]) ; 
            disp( ['Use extended ID : ', num2str(paramvec(1,6) ) ]) ; 
            disp( ['Time out msec : ', num2str(paramvec(1,7) ) ]) ; 

            [rows,cols] = size(paramvec);
            payload = [];
            %build can msg:
            CCS = 64; %=64
            cobId = 1661 ; 
            dLen = 8;
            UseLongId = 0 ;
            
            for i = 1:rows
            Index = paramvec(i,3) ;
            si = paramvec(i,4) ;  
            data_0 = CCS + Index*(2^8) + si*(2^24) ; 

            payload_var = zeros(1,8) ;  
            payload_var(1:2) = Long2Payload( data_0) ;
            payload_var(3:4) = Long2Payload( 0) ;
            payload_var(5:6) = Long2Payload( cobId) ;
            payload_var(7) = Short2Payload( dLen) ;
            payload_var(8) = Short2Payload( UseLongId) ;  

            payload = [payload , payload_var];
            end 
             
            
        case 8 %Fetch object. 
            %change: now need to be able to send a vector.
            disp('Service is fetch') ; 
            disp( ['COB ID : ', num2str(paramvec(1) ) ]) ; 
            disp( ['COB ID of returned message: ', num2str(paramvec(2) ) ]) ; 
            disp( ['Index : ', num2str(paramvec(3) ) ]) ; 
            disp( ['SubIndex : ', num2str(paramvec(4) ) ]) ; 
            disp( ['Data type : ', num2str(paramvec(5) ) ]) ; 
            disp( ['Use extended ID : ', num2str(paramvec(6) ) ]) ; 
            disp( ['Time out msec : ', num2str(paramvec(7) ) ]) ; 
            %RetVal = 9 ; %DAD - why did you write it here?
            if nargout > 1
                err = 'kus ommo' ; 
            end 

            %checks - talk to dad
            % if (paramvec(2) ~= 1533) 
            %%DAD - 1. TargetCanId should be 125 for that to be received. 2.
            %%this is COB ID of returned msg Im checking here.make sure about CobId.
    %             error('wrong cobId for fetch service');
    %         elseif (not (paramvec(5 == 0) || (paramvec(5) == 1)))
    %             error('data type should be long or float')
    %         elseif (paramvec(6) ~= 0 )
    %             error('use extended ID should be 0')
    %         end


            %build can msg:
            %CCS: upload = get: 0x40. set: 0
            CCS = 64; %=64
            Index = paramvec(3) ;
            si = paramvec(4) ;

            data_0 = CCS + Index*(2^8) + si*(2^24) ; 

            cobId = 1661 ; 
            dLen = 8;
            UseLongId = 0 ;
            
            payload = zeros(1,8) ;  
            payload(1:2) = Long2Payload( data_0) ;
            payload(3:4) = Long2Payload( 0) ;
            payload(5:6) = Long2Payload( cobId) ;
            payload(7) = Short2Payload( dLen) ;
            payload(8) = Short2Payload( UseLongId) ;  

        case 7 %Send object
            %   function [Retcode,RetStr] =  SendObj( Multiplexor , Data , DType , Descr , CommFunc, tout) 
            %    Retcode = CommFunc( 7 , [1536+NodeId ,1408+NodeId ,Index,SubIndex,DType,0,tout], Data ); 
            set_flag = 1;
            disp('Service is send') ; 
            disp( ['COB ID : ', num2str(paramvec(1) ) ]) ; 
            disp( ['COB ID of returned message: ', num2str(paramvec(2) ) ]) ; 
            disp( ['Index : ', num2str(paramvec(3) ) ]) ; 
            disp( ['SubIndex : ', num2str(paramvec(4) ) ]) ; 
            disp( ['Data type : ', num2str(paramvec(5) ) ]) ; 
            disp( ['Use extended ID : ', num2str(paramvec(6) ) ]) ; 
            disp( ['Time out msec : ', num2str(paramvec(7) ) ]) ; 
            %RetVal = 9 ; 
            if nargout > 1
                err = 'kus omak' ; 
            end 

            %checks

            CCS = 34; %set
            Index = paramvec(3) ;
            si = paramvec(4) ;
            data_0 = CCS + Index*(2^8) + si*(2^24) ;
            cobId = 1661 ; %cobId = 0x67d ;
            dLen = 8; 
            UseLongId = 0 ;

            dType = paramvec(5);
            
            payload = zeros(1,8) ;  
            payload(1:2) = Long2Payload( data_0) ;
            if ( dType == 1 ) 
                payload(3:4) = Long2Payload( IEEEFloat(Data)) ;
            else
                payload(3:4) = Long2Payload( Data) ;
            end
            payload(5:6) = Long2Payload( cobId) ;
            payload(7) = Short2Payload( dLen) ;
            payload(8) = Short2Payload( UseLongId) ; 

        otherwise
            error('I dont know') ;    
    end
    
    msg = BuildTunnelMessage(payload);
    flush(s) ; 
    write(s,msg,'uint8');
    pause( 0.1); 
    
    
    RetVal = []; %dad - not sure when to put msgs here
    rxstr = struct('Payload',[],'Next',[],'TxCtr',[],'OpCode',[],'TimeTag',[],'Odd',0) ; 

    x=tic ;
    
    
    while (1)
        if (s.NumBytesAvailable == 0)
            disp('nothing to read now');
            break;
        end
        kaka = read( s , s.NumBytesAvailable , 'uint8'); 
        rxstr=DecomposeMessage(rxstr,kaka); 
        if (~isempty(rxstr.Payload))
            disp('woohoo');
            if ~set_flag
                for i = 1:(length(rxstr.Payload)/8)
                    si = bitshift(rxstr.Payload(2+ 8*(i-1)),-8);
                    if (si == 1)
                        %disp('data type is long. data is: ')
                        %disp(rxstr.Payload(3+ 8*(i-1):4+ 8*(i-1)) );
                        %RetVal = [RetVal,rxstr.Payload(3+ 8*(i-1):4+ 8*(i-1)) ];
                        data = rxstr.Payload(3+ 8*(i-1):4+ 8*(i-1));
                        RetVal = [RetVal, data(2)*2^16+data(1)];
                    elseif (si==2)
                        %disp('data type is float. data is: ')
                        %disp(rxstr.Payload(3+ 8*(i-1):4+ 8*(i-1)) );
                        data = rxstr.Payload(3+ 8*(i-1):4+ 8*(i-1)) ;
                        %RetVal = [RetVal,rxstr.Payload(3+ 8*(i-1):4+ 8*(i-1)) ];
                        RetVal = [RetVal, double(typecast(uint32(data(2)*2^16+data(1)),'single'))] ; %currently single, can be converted to double if required.
                        %typecast(uint32(hex2dec('419c0000')),'single')
                    else
                        error('this is weird');
                    end 
                end
            end 
            break;
        end
        t_elapsed = toc(x) ;
        if ( t_elapsed > 1 ) 
            RetVal = -1 ; 
            return ; 
        end
    end
    
    
    

end