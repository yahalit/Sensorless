function str = GetManPos( ManipStyle ) 
global DataType 
global RecStruct
    ManStyles = RecStruct.Enums.ManipulatorType ; 

    if isempty( ManipStyle ) 
        ManipStyle     = FetchObj( [hex2dec('2220'),53] , DataType.long , 'ManipStyle' ) ;     
    end 

    ManStat = FetchObj( [hex2dec('220b'),14] , DataType.long , 'MAN Stat' ) ;
    switch ManipStyle
        
        case ManStyles.Scara

            ManX = FetchObj( [hex2dec('2204'),80] , DataType.float , 'MAN X' ) ;
            ManY = FetchObj( [hex2dec('2204'),81] , DataType.float , 'MAN Y' ) ;
            ManTht = FetchObj( [hex2dec('2204'),82] , DataType.float , 'MAN T' ) ;
            ManLD = FetchObj( [hex2dec('2204'),83] , DataType.float , 'MAN RD' ) ;
            ManRD = FetchObj( [hex2dec('2204'),84] , DataType.float , 'MAN LD' ) ;


            ManErr  = bitand( ManStat,65535)   ; 
            ManRecover = bitand( ManStat,65536) / 65536  ;
            ManOk = 1 - bitand( ManStat,2^17) / 2^17  ;
            ManOn = bitand( ManStat,2^18) / 2^18  ;
            ManErrFlag = ~(ManErr==0); 
            ManStdBy = ManOk ; 
            if  ~(ManOn==0)
                ManStdBy = 0 ; 
            end 

            str = struct('X',ManX,'Y',ManY,'Tht',ManTht,'RD',ManRD,'LD', ManLD, 'Stat',...
                ManStat,'stdby',ManStdBy,'MotorOn',ManOn,...
                'Error',ManErrFlag,'ErrorRecoverable',ManRecover) ; 
        case ManStyles.Flex_Arm

            ManErr  = bitand( ManStat,65535)   ; 
            ManRecover = bitand( ManStat,65536) / 65536  ;
            ManOk = 1 - bitand( ManStat,2^17) / 2^17  ;
            ManOn = bitand( ManStat,2^18) / 2^18  ;
            ManErrFlag = ~(ManErr==0); 
            ManStdBy = ManOk ; 
            if  ~(ManOn==0)
                ManStdBy = 0 ; 
            end 
            str = struct('Tape',0,'Plate',0,'Door',0, 'Stat',...
                ManStat,'stdby',ManStdBy,'MotorOn',ManOn,...
                'Error',ManErrFlag,'ErrorRecoverable',ManRecover) ;     
        otherwise
            str = struct(   'Stat',...
                ManStat,'stdby',0,'MotorOn',0,...
                'Error',1,'ErrorRecoverable',0) ;     
    end
end