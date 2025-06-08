function [str,reply,errcode] = SendSpiSim( cmd , ReportType , DoTx  ) 
% function [str,reply] = SendSpiSim( cmd , ReportType , DoTx  ) 
% Prepare and transmit a message, simulating an SPI command
% cmd: A structure with the command data 
% ReportType : The opcode for the desired report 
% DoTx : 0: Just prepare message, 1: Transmit to matlab simulation, 2:
% Transmit through CAN to actual system


global SimTime  
global RxCtr  
global TxCtr 
global DataType

if nargin < 2 || ReportType == 0  
    ReportType = 32 ; 
end 

if ( nargin < 3 ) 
    DoTx = 1 ; 
end 

str = zeros( 1, 31 ) ; 
str(1) = 44051 ; % 0xac13 
TxCtr = mod (TxCtr + 1 , 256 ) ; 
str(2) = TxCtr + RxCtr * 256 ; 
str(3) = cmd.OpCode + ReportType * 256 ; 
str(4:5) = DecompLong(SimTime * 1e6 ) ; 

switch( cmd.OpCode ) 
    case 0  % Nothing 
    case 1  % Clear queue 
        str(6+0) = cmd.QIndex ; 
    case 2  % Set queue entry
        str(6+0) = cmd.QIndex ; 
        str(6+1) = cmd.EntryIndex ; 
        str(6+2) = cmd.QOpCode; 
        switch ( cmd.QOpCode ) 
            case 0
            case 1 % Set path point 
                str(9+(0:1)) = DecompLong(cmd.X * 10000) ;
                str(9+(2:3)) = DecompLong(cmd.Y * 10000) ;
                str(9+(4:5)) = DecompLong(cmd.Z * 10000) ;
                str(9+6) = SetIQ1Word ( cmd.cx  ) ; 
                str(9+7) = SetIQ1Word ( cmd.cy  ) ; 
                str(9+8) = SetIQ1Word ( cmd.cz  ) ;
                if (cmd.Protocol ) 
                    str(9+9) = fix( cmd.TrackWidth * 10000) ; 
                    if ( cmd.IgnoreJunction ) 
                        str(9+9) = str(9+9) + 32768 ; 
                    end 
                end
            case 2
                str(9+(0:1)) = DecompLong(cmd.Dir)  ;
                str(9+(2:3)) = DecompLong(cmd.Mode ) ;
                str(9+(4:5)) = DecompLong(-cmd.Height* 10000) ; % Changed 71-11-22
            case 3
                str(9+0) = Angle2Int ( cmd.Yew  ) ; 
                str(9+1) = bitand( 2^16 + cmd.RotateCmd  , 65535 )   ;
                str(9+2) = cmd.IsClimb   ;
            case 4
                str(9+(0:1)) = DecompLong(cmd.ActionLoad + cmd.Side * 65536) ;
                str(9+(4:5)) = DecompLong(cmd.PackageXOffset * 10000) ;
                str(9+(2:3)) = DecompLong(cmd.PackageDepth * 10000) ;
                junk = fix( cmd.Incidence * 1.043037835047045e+04); 
                if ( junk < 0 ) 
                    junk = junk + 65536 ; 
                end 
                str(9+6) = junk ;           
             
            case 5
                if ~isfinite(cmd.WaitLen) 
                    str(9) = 0 ; 
                else
                    str(9) = DecompLong ( cmd.WaitLen * 1e6 ) ; 
                end 
            otherwise  
                error ('Unknown waypoint code' ) ; 
        end 
    case 3  % Set queue exec pointer
        str(6+0) = cmd.QIndex ; 
        str(6+1) = cmd.EntryIndex ; 
        str(6+2) = cmd.SwitchImmediate ; 
    case 7  % Emergency stop 
        str(6+0) = 4660 ; % 0x1234 
    case 8  % Handle package 
        str(6+(0:1)) = DecompLong(cmd.Action + cmd.Side * 65536) ;
        str(6+(4:5)) = DecompLong(cmd.PackageXOffset * 10000) ;
        str(6+(2:3)) = DecompLong(cmd.PackageDepth * 10000) ;
        junk = fix( cmd.Incidence * 1.043037835047045e+04); 
        if ( junk < 0 ) 
            junk = junk + 65536 ; 
        end 
        str(6+6) = junk ;           
    case 10  % Deviation report 
        str(6+0) = cmd.OffsetUnused ; 
        str(6+1) = cmd.AdimuthDev ; 
        str(6+(2:3)) = DecompLong(cmd.TimeTag * 1e6 ) ; 
    case 11  % Position report 
        str(6+(0:1)) = DecompLong(cmd.X * 10000) ; 
        str(6+(2:3)) = DecompLong(cmd.Y * 10000) ; 
        str(6+(4:5)) = DecompLong(cmd.Z * 10000) ; 
         q = [ cos(cmd.Tht/2) , 0 , 0 , sin(cmd.Tht/2)] ;  
%        q = [ sin(cmd.Tht/2) , 0 , 0 , cos(cmd.Tht/2)] ;  
        str(6+(6:7)) = DecompLong(q(2)*2^16) ; % Angle2Int ( cmd.Tht ) ; 
        str(6+(8:9)) = DecompLong(q(3)*2^16) ; % Angle2Int ( cmd.Tht ) ; 
        str(6+(10:11)) = DecompLong(q(4)*2^16) ; % Angle2Int ( cmd.Tht ) ; 
        str(6+(12:13)) = DecompLong(q(1)*2^16) ; % Angle2Int ( cmd.Tht ) ; 
        
        %str(6+(7:8)) = DecompLong(cmd.TimeTag * 1e6 ) ;
        str(6+16) = SetFieldDefault( cmd , 'Mode' , 4 ) ;
    case 12  % Set parameter 
        str(6+0) = cmd.Index; 
        str(6+1) = cmd.SubIndex; 
        str(6+2) = cmd.nData ; 
        if ( cmd.Float ) 
            str(6+(3:4)) = DecompLong ( Float2IEEE ( cmd.Value) )  ; 
        else    
            str(6+(3:4)) = DecompLong ( cmd.Value)  ;
        end 
    case 13  % Set CAN message 
        str(6+0) = cmd.CobId; 
        str(6+(1:length(cmd.PayLoad))) = cmd.PayLoad; 
    otherwise  
        error( 'Ilegal op code ') ; 
        
end 

cs = 2^22 - sum( str(2:30) ) ; 
str(31) = mod( cs , 65536 ) ; 
errcode = [] ; 
switch ( DoTx) 
    case 1
        reply = MatIntfc ( 2 , str ) ;
    case 2
        reply = str  ; 
        [Retcode,RetStr] = SendObj( [hex2dec('1f00'),1] , discompact(str) , DataType.string , 'SPI command' ) ; %#ok<ASGLU>
        if ~isempty(RetStr) 
            errcode = RetStr ; 
        end 
    case 3
        % Words 
        reply = str ; 
    case 4
        % Bytes 
        reply =  discompact(str) ;
    otherwise 
        reply = [] ; 
end 


end 


function str2 = discompact( str ) 

str2 = zeros( 1 , 2 * length( str)) ;  
for cnt = 1 : length( str) 
    Next = str(cnt) ; 
    if ( Next < 0 ) 
        Next = Next + 65536 ; 
    end 
    str2( 2 * cnt - 1 ) = mod ( Next , 256 ) ; 
    str2( 2 * cnt  ) = fix ( Next / 256 ) ; 
end 
str2 = char( str2) ; 

end 
