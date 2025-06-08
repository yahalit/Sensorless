function [msg,str] = BuildConfigurationMessageVec( RCVersion, Permission, amount_of_periods, periods) 
% if nargin < 4 
%     RCVersion = 0 ; 
%     Permission = 0;
% end 
% if nargin < 3
%     TravelInfoPeriod = 0 ;
% end

%periods_amount = length(periods)/2;
if ~(amount_of_periods*2 == length(periods))
    error('wrong amount of periods');
end
payload = zeros(1,2+amount_of_periods*2) ;  
payload(1:2) = Long2Payload(RCVersion) ; 
payload(3) = Short2Payload(Permission) ;
payload(4) = amount_of_periods ;
for cntPeriod = 1:amount_of_periods
    payload(2*cntPeriod+3) = Short2Payload(periods(2*cntPeriod-1)) ;
    payload(2*cntPeriod+4) = Short2Payload(periods(2*cntPeriod)*100) ;
end


str = struct('OpCode',14 ,'Payload',payload ) ; 

msg = BuildHostSciString( str.Payload , str.OpCode  ) ; 

end 