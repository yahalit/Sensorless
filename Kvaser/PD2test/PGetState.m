function s = PGetState() 
DataType = GetDataType() ; 
VBatIn1 = FetchObj( [hex2dec('2105'),15] , DataType.float , 'Bat1 in' )  ; 
VBatIn2 = FetchObj( [hex2dec('2105'),16] , DataType.float , 'Bat2 in' )  ; 
V24  = FetchObj( [hex2dec('2105'),22] , DataType.float , 'V24' )  ; 
V18  = FetchObj( [hex2dec('2105'),23] , DataType.float , 'V18' )  ; 
V12  = FetchObj( [hex2dec('2105'),24] , DataType.float , 'V12' )  ; 
V5  = FetchObj( [hex2dec('2105'),25] , DataType.float , 'V5' )  ; 
Vservo  = FetchObj( [hex2dec('2105'),26] , DataType.float , 'Vservo' )  ; 
CurServo  = FetchObj( [hex2dec('2105'),21] , DataType.float , 'CurServo' )  ; 
Cur24  = FetchObj( [hex2dec('2105'),17] , DataType.float , 'Cur24' )  ; 
Cur18  = FetchObj( [hex2dec('2105'),18] , DataType.float , 'Cur18' )  ; 
Cur12  = FetchObj( [hex2dec('2105'),19] , DataType.float , 'Cur12' )  ; 
Cur5  = FetchObj( [hex2dec('2105'),20] , DataType.float , 'Cur5' )  ; 

Bit1  = ulong( FetchObj( [hex2dec('2104'),1] , DataType.long , 'Bit12_24_54' ) )  ; 
Bit2  = ulong( FetchObj( [hex2dec('2104'),2] , DataType.long , 'Bit12_5_18' ) )  ; 
% BitW  = ulong( FetchObj( [hex2dec('2104'),40] , DataType.long , 'BitW' ) )  ; 

Bit = struct ('Sw54On',bitget(Bit1,15),'Sw24On',bitget(Bit1,14),'Sw18On',bitget(Bit1,13),'Sw12On',bitget(Bit1,12),'Sw5On',bitget(Bit1,11),...
    'LSw5_On',bitget(Bit1,29),'LSw18On',bitget(Bit1,30),...
    'HS24',bitget(Bit2,17),'HS12',bitget(Bit2,18),'LS1',bitget(Bit2,19),'LS2',bitget(Bit2,20),'SelfSustain',bitget(Bit2,21),...
    'Mushroom',bitget(Bit1,6),'ChargeSw1',bitget(Bit2,22),'HotSwap1',bitget(Bit2,23),'Regen1',bitget(Bit2,24),...
    'BatGood1',bitget(Bit2,25),'ChargeSw2',bitget(Bit2,26),'HotSwap2',bitget(Bit2,27),'Regen2',bitget(Bit2,28),...
    'BatGood2',bitget(Bit2,29),'OverRideBatMachine',bitget(Bit2,30),...
    'PbitDone',bitget(Bit1,7),'BatteryTransition',bitget(Bit1,8),'BatteryIndex',bitgetvalue(Bit1,(1:2)+8),...
    'Buck12Exception',bitgetvalue(Bit1,(1:3)+16),'Buck18Exception',bitgetvalue(Bit1,(1:3)+19),...
    'Buck24Exception',bitgetvalue(Bit1,(1:3)+22),'CombinerException',bitgetvalue(Bit1,(1:3)+25),...
    'Buck5Exception',bitgetvalue(Bit2,(1:3)),'RecorderState',bitgetvalue(Bit2,(1:2)+3),...
    'Buck5On',bitgetvalue(Bit2,6),'Buck12On',bitgetvalue(Bit2,7),'Buck18On',bitgetvalue(Bit2,8),'Buck24On',bitgetvalue(Bit2,9) ...
    ) ; 


base = struct('VBatIn1',VBatIn1,'VBatIn2',VBatIn2,'Vservo',Vservo,'V24',V24,'V18',V18,'V12',V12,'V5',V5,...
    'CurServo',CurServo,'Cur24',Cur24,'Cur18',Cur18,'Cur12',Cur12,'Cur5',Cur5) ; 

s = struct('base',base,'Bit',Bit);

end

function x = ulong(x) 
    x = bitand( x + 2^32 , 2^32 -1 ); 
end

function z = bitgetvalue(x,y) 
    z = bitget(x+2^32,y) ; 
    junk = 2.^(0:(length(z)-1));
    z = sum( z.* junk) ; 
end
