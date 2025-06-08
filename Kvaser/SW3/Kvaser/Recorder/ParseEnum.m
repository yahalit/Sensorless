function out = ParseEnum(fname,enumname,bValueOnly) 
% function out = ParseEnum(fname,enumname,bValueOnly) 
% Get a description structure for an enumerated type
% Example: 
% enum E_LoopClosureMode
% {
%     E_LC_Voltage_Mode = 0 ,
%     E_LC_OpenLoopField_Mode = 1 ,
%     E_LC_Torque_Mode = 2 
% } ;
% Will return for ParseEnum( [WheelRoot,'Application\HwConfig.h'],'E_LoopClosureMode') 
%   struct with fields:
% 
%           E_LC_Voltage_Mode: 0
%     E_LC_OpenLoopField_Mode: 1
%            E_LC_Torque_Mode: 2
% bValueOnly: (default = 0 ) 
%   - If nonzero, remove the leading E_, so Eg., E_LC_Voltage_Mode field name becomes LC_Voltage_Mode


if nargin < 3 
    bValueOnly = 0 ; 
end

out = struct() ; 
fi = fopen ( fname , 'r' ) ; 
if isequal(fname,-1) 
    errordlg({'Error description file',fname,'Not found'}) ; 
    return ; 
end

enumfound  = 0 ; 
for cnt = 1:1e6 
    str = fgets(fi) ; 
    if isequal(str,-1) 
        break;
    end
    str = strsplit(str,' ') ;  
    if length( str) >= 2  
        if isequal( strtrim(str{1}),'enum') && isequal( strtrim(str{2}),enumname)
            state = 0 ; 
            while(1) 
                str   = strtrim(fgets(fi)) ; 
                place = strfind(str,'//') ; 
                if ~isempty(place) 
                    str = strtrim(str(1:place(1)-1)) ; 
                end
                place = strfind(str,',') ; 
                if ~isempty(place) 
                    str = strtrim(str(1:place(1)-1)) ; 
                end
                
                switch state
                    case 0
                        if isequal(str,'{') 
                            state = 1 ; 
                        else
                            break ;
                        end
                    case 1
                        place = strfind(str,'=') ; 
                        if ~isempty(place)  %#ok<STREMP>
                            str = strsplit(str,'=') ; 
                            
                            strfield = strtrim(str{1}); 
                            if ( bValueOnly ) 
                                plUs = strfind(strfield,'_'); 
                                if ~isempty(plUs) 
                                    strfield = strfield( plUs(1)+1:end) ; 
                                end
                            end
                            out.(strfield) = str2num(strtrim(str{2}));  %#ok<ST2NM>
                            enumfound = 1 ; 
                        end
                        if contains(str,'}') 
                            break ;
                        end
                end
            end
        end % end found enum 
        if enumfound
            break;
        end 
    end % End test str  
end 
if ~enumfound
    error(['File name: ',fname,' Enum name: ',enumname, ' :: Not found ::']); 
end 
fclose(fi) ; 