function [MQ,nGet,nPut,UsrQ] = GetMotionQueue() 
% Syntax: 
%[MQ,nGet,nPut,UsrQ] = GetMotionQueue() 
% Get the motion queues from the robot
% MQ  : Operational motion queue
% nGet: Executing instruction index (zero based) 
% nPut: Queue size (zero based) 
% UsrQ: User queue (programmed queuem as set by the host ) 

global DataType 
sides   = {'Undefined0','Left','Right', 'Undefined3' }; 
MQ = struct('x',cell(1,64),'y',0,'z',0,'Theta',0,'cz',0,'Opcode',0,'Mode',0,'ChgMode',[],'IndInUserQueue',[]) ;


OpCodeStr = {'Zero','PATH_PT' ,'Code2_Unknown','CHANGE_MODE','HANDLE_PACK','Wait(End_Queue)','Nothing'};

Wait = 0 ; 
for cnt = 1:64 
    try 
        SendObj( [hex2dec('2221'),1] , cnt-1  , DataType.short , 'Set readptr' ) ;
        MQ(cnt).x = FetchObj( [hex2dec('2221'),1] , DataType.long ,'Get x')  ; 
        MQ(cnt).y = FetchObj( [hex2dec('2221'),2] , DataType.long ,'Get y')  ; 
        MQ(cnt).z = FetchObj( [hex2dec('2221'),3] , DataType.long ,'Get z') ; 
        xx = FetchObj( [hex2dec('2221'),4] , DataType.long ,'Get Cx Cy') ; 
        [cx,cy] = TwoShorts( xx,'s')  ;
        MQ(cnt).Theta = atan2(cy,cx)  ;
        MQ(cnt).cz = FetchObj( [hex2dec('2221'),5] , DataType.float ,'Get cz') ; 
        xx = FetchObj( [hex2dec('2221'),6] , DataType.long ,'Get Opcode, Mode') ; 
        [OpCode,Mode] = TwoShorts( xx)  ;
        if ( OpCode == 5) 
            Wait = 1 ; 
        end 
        if OpCode == 1 
            % Path point 
            MQ(cnt).x = MQ(cnt).x * 1e-4 ; 
            MQ(cnt).y = MQ(cnt).y * 1e-4 ; 
            MQ(cnt).z = MQ(cnt).z * 1e-4 ; 
        end 
        if ( OpCode == 3 ) 
            MQ(cnt).ChgMode = ['Crab:',num2str(MQ(cnt).x),' Junct:',num2str(MQ(cnt).y), ' Climb:',num2str(MQ(cnt).z)];
        end
        if ( OpCode == 4 ) 
            MQ(cnt).Theta = Angle2F(cx);
            zmode = MQ(cnt).z ; 
            if ( zmode < 0 ) 
                zmode = zmode + 2^32 ; 
            end 
            if bitand( zmode , 1 ) 
                GetMode = 'Get ' ;
            else 
                GetMode = 'Set ' ;
            end 
            side = sides{bitand( zmode , 196608 ) / 65536 + 1  } ;
                        
            MQ(cnt).ChgMode = ['Incidence deg: ', num2str(MQ(cnt).Theta * 180 / pi)  ,' Action:' , GetMode ,' Side:', side  ];            
        end
        
        if OpCode < 0 || OpCode > 6
            OpCode = ['Ilegal',num2str(OpCode)]; 
        else
            OpCode = OpCodeStr(OpCode+1) ; 
        end 

        
        MQ(cnt).OpCode = OpCode ; 
        MQ(cnt).IndInUserQueue = fix ( Mode / 2^6 ) ; 
        MQ(cnt).Mode = bitand( Mode ,1 ) ; 

        if ( Wait) 
            MQ = MQ(1:cnt) ; 
            break ; 
        end 
    catch 
        error ('Cant read motion queue') ; 
    end
end 

xx = FetchObj( [hex2dec('2221'),10] , DataType.long ,'Get and put ptr') ; 
[nGet,nPut] = TwoShorts( xx)  ;

% Get the user queue
if nargout > 3 
    if size(MQ) < 1 
       UsrQ = [] ; 
       return ; 
    end
        
    Wait = 0 ; 
    UsrQ = struct('x',cell(1,64),'y',0,'z',0,'Theta',0,'cz',0,'Opcode',0,'Mode',0,'ChgMode',[],'IndInUserQueue',[]) ;
    cnt = 1 ; 
    for cntx = (MQ(1).IndInUserQueue+1):64 
        try 
            SendObj( [hex2dec('2221'),1] , cnt-1  , DataType.short , 'Set readptr' ) ;
            UsrQ(cnt).x = FetchObj( [hex2dec('2221'),11] , DataType.long ,'Get x')  ; 
            UsrQ(cnt).y = FetchObj( [hex2dec('2221'),12] , DataType.long ,'Get y')  ; 
            UsrQ(cnt).z = FetchObj( [hex2dec('2221'),13] , DataType.long ,'Get z') ; 
            xx = FetchObj( [hex2dec('2221'),14] , DataType.long ,'Get Cx Cy') ; 
            [cx,cy] = TwoShorts( xx,'s')  ;
            UsrQ(cnt).Theta = atan2(cy,cx)  ;
            UsrQ(cnt).cz = FetchObj( [hex2dec('2221'),15] , DataType.float ,'Get cz') ; 
            xx = FetchObj( [hex2dec('2221'),16] , DataType.long ,'Get Opcode, Mode') ; 
            [OpCode,Mode] = TwoShorts( xx)  ;
            if ( OpCode == 5) 
                Wait = 1 ; 
            end 
            if OpCode == 1 
                % Path point 
                UsrQ(cnt).x = UsrQ(cnt).x * 1e-4 ; 
                UsrQ(cnt).y = UsrQ(cnt).y * 1e-4 ; 
                UsrQ(cnt).z = UsrQ(cnt).z * 1e-4 ; 
            end 
            if ( OpCode == 3 ) 
                UsrQ(cnt).ChgMode = ['Crab:',num2str(UsrQ(cnt).x),' Junct:',num2str(UsrQ(cnt).y), ' Climb:',num2str(UsrQ(cnt).z)];
            end
            if ( OpCode == 4 ) 
                UsrQ(cnt).Theta = Angle2F(cx);
                zmode = UsrQ(cnt).z ; 
                if ( zmode < 0 ) 
                    zmode = zmode + 2^32 ; 
                end 
                if bitand( zmode , 1 ) 
                    GetMode = 'Get ' ;
                else 
                    GetMode = 'Set ' ;
                end 
                side = sides{bitand( zmode , 196608 ) / 65536 + 1  } ;

                UsrQ(cnt).ChgMode = ['Incidence deg: ', num2str(UsrQ(cnt).Theta * 180 / pi) ,' Action:' , GetMode ,' Side:', side  ];                       
            end

            if OpCode < 0 || OpCode > 6
                OpCode = ['Ilegal',num2str(OpCode)]; 
            else
                OpCode = OpCodeStr(OpCode+1) ; 
            end 


            UsrQ(cnt).OpCode = OpCode ; 
            UsrQ(cnt).IndInUserQueue = fix ( Mode / 2^6 ) ; 
            UsrQ(cnt).Mode = bitand( Mode ,1 ) ; 

            if ( Wait) 
                UsrQ = UsrQ(1:cnt) ; 
                break ; 
            end 
            cnt = cnt + 1 ;  
        catch 
            error ('Cant read user motion queue') ; 
        end
    end
end


