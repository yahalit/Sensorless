function r = DecodeAxisCbit( RecStr , CanId, signame)

ignorecanlist = 1 ; 
if nargin < 3
    ignorecanlist = 0 ; 
    signame = 'CBit'; 
end
fieldname = [signame,'Field'] ; 

r  = RecStr ; 

if  any( CanId == [36 35 34 30 11 12 21 22] ) || ignorecanlist
    try 
        cw = bitand( 2^32 + RecStr.(signame) , 2^32-1) ; 
        CBitField = struct('MotorOn', bitget(cw,1) ,'MotorReady',bitget(cw,2),'StoEvent',bitget(cw,3),...
            'ProfileConverged',bitget(cw,4),'MotionConverged',bitget(cw,5),'MotorFault',bitget(cw,6),...
            'QuickStop',bitget(cw,7),'BrakesReleaseCmd',bitget(cw,8),'PotRefFail',bitget(cw,9),...
            'LoopClosureMode',mybitget(cw,10:12),'SystemMode',mybitget(cw,13:15),'CurrentLimit',bitget(cw,16),...
            'NoCalib',bitget(cw,17),...
            'IsTemperature',bitget(cw,24),'ReferenceMode',mybitget(cw,25:27),'Configured',bitget(cw,29),...
            'Homed',bitget(cw,30),'D1',bitget(cw,31),'D2',bitget(cw,31)) ; 
        r.(fieldname) = CBitField ; 
    catch ME
        error('Could not iunterpret a bit field (negative or non integer number)') ; 
    end
end

end

function y = mybitget(x,n) 
    y = bitget( x,n(1));
    if length(n) < 2 
        return ; 
    end 
    for cnt = 2:length(n) 
        y = y + 2^(n(cnt)-n(1)) * bitget( x,n(cnt) ) ;
    end
end