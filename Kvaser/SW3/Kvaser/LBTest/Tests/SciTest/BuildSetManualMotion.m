function [msg,str] = BuildSetManualMotion( configuration, NumberOfCommands, commands ) 
%commands is a vector of [type, value, type value, ...] 

if ~(NumberOfCommands*2 == length(commands))
    error('wrong amount of periods');
end
payload = zeros(1,2+NumberOfCommands*3) ;  
payload(1) = Short2Payload( configuration) ; 
payload(2) = Short2Payload( NumberOfCommands) ; 

for cntCommands = 1:NumberOfCommands
    payload(3*cntCommands) = Short2Payload(commands(1+2*(cntCommands-1))) ; %index
    payload((3*cntCommands)+(1:2)) = Long2Payload(commands(2 + 2*(cntCommands-1))) ; %value
end

str = struct('OpCode',13 ,'Payload',payload ) ; 

msg = BuildHostSciString( str.Payload , str.OpCode  ) ; 

end 