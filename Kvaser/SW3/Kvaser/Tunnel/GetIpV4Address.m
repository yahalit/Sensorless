function [ip,errmsg] = GetIpV4Address(gateway,result) 

% k = 0 ; 
% try
%     evalin('base','k=KillUdp;' ) 
%     if k 
%         evalin('base','KillUdp=0;' ) 
%         error('UDP not allowed now - no UDP use') ; 
%     end
% catch 
% end

if nargin < 2 
    [~, result] = system('ipconfig') ; 
end
errmsg = [] ; 
ip = [] ; 

str = strsplit(result ,'\n') ; 

for cnt = 1:length(str)
    if contains(str{cnt},'IPv4 Address') && length(str) >= cnt+2 && contains(str{cnt+2},'Default Gateway')
        gatestring = str{cnt+2} ; 
        place = strfind(gatestring,':') ; 
        gatestring = strtrim(gatestring(place(1)+1:end)) ; 
        if isequal(gatestring,gateway) || isempty(gateway) 
            ipstring = str{cnt}  ; 
            place = strfind(ipstring,':') ; 
            ipstring = strtrim(ipstring(place(1)+1:end)) ; 
            ip = str2double(strsplit(ipstring,'.')) ; 
            if ~(length(ip)==4)
                errmsg = 'Bad format for IP' ; 
                ip = [] ; 
                if nargout < 2
                    error(errmsg) ;
                end
            end
            return ;
        end     
    end
end 
errmsg = 'Could not locate IP address in match to gateway' ; 
if nargout < 2
    error(errmsg) ;
end
end 