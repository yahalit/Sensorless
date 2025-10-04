function [str,IsOperational] = GetProjTypeString( ProjType) 
% function [str,IsOperational] = GetProjTypeString( ProjType) : Get project name and if in boot state by ProjType number

% NeckDrvBootProjId   = hex2dec('92f0') ;
% NeckDrvOpProjId   = hex2dec('9300') ;
IsOperational = 0 ; 

% AtpCfg.HwProjectsList = struct('NeckDrvBootProjId',hex2dec('92f0'),...
%     'NeckDrvOpProjId',hex2dec('9300'),...
%     'IntfcDrvBootProjId',hex2dec('9880'),...
%     'IntfcDrvOpProjId',hex2dec('9900'),...
%     'WheelDrvBootProjId',hex2dec('93f0'),...
%     'WheelDrvOpProjId',hex2dec('9400') ) ;
% SteerDrvBootProjId   = hex2dec('94f0') ;
% SteerDrvOpProjId   = hex2dec('9500') ;

cfg = GetAtpCfg() ; 
fnames = fieldnames(cfg.HwProjectsList ) ;

name = [] ; 
for cnt = 1:length(fnames) 
    next = fnames{cnt};
    if ProjType == cfg.HwProjectsList.(next) 
        name = next ; 
        break ; 
    end
end

if isempty(name) 
   error('Cannot identify drive type ' ) ; 
end

if contains(name,'OpProjId')
    IsOperational = 1 ; 
    str = 'OpProjId' ; 
elseif  contains(name,'BootProjId')
    IsOperational = 0 ; 
    str = 'BootProjId' ; 
else
   error('Cannot identify if boot or operational ' ) ; 
end

place = strfind(name,str) ; 
str = name(1:place-1) ; 

end 