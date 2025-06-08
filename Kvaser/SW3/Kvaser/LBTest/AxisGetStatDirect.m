% This function addresses the servo axes directly, thus uses the direct CAN lines
function AxisData = AxisGetStatDirect(RqAxis) 
global DataType;

AxisData = struct ( 'Axis' ,RqAxis , 'cw', 0 , 'sw' , 0 , 'mode' , 0 ) ; 
AxisData.sw = KvaserCom( 8 , [1536+RqAxis ,1408+RqAxis ,hex2dec('6041') ,0,DataType.short,0,100] ) ;% Get status
if isempty (AxisData.sw) 
    error ( 'Could not retrieve status word') ; 
end 

opstat = bitand( AxisData.sw , 15) ; 
switch ( opstat ) 
    case 7, 
        if bitand( AxisData.sw , 32) ; 
            AxisData.Oper = 'Oper' ; 
        else
            AxisData.Oper = 'QS' ; 
        end 
    case 8,         
            AxisData.Oper = 'Fault' ;         
    case 15, 
            AxisData.Oper = 'FaultHandling' ;         
    otherwise, 
            AxisData.Oper = 'MOFF' ; 
end 

AxisData.cw = KvaserCom( 8 , [1536+RqAxis ,1408+RqAxis ,hex2dec('6040') ,0,DataType.short,0,100] ) ;% Get control word
if isempty (AxisData.sw) 
    error ( 'Could not retrieve control word') ; 
end 
AxisData.mode = KvaserCom( 8 , [1536+RqAxis ,1408+RqAxis ,hex2dec('6061') ,0,DataType.short,0,100] ); % Get control word
if isempty (AxisData.mode) 
    error ( 'Could not retrieve mode of operation') ; 
end 


