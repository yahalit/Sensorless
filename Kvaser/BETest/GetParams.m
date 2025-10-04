function [ClaPars,MainPars,SimPars]=GetParams(tab) 
% function [ClaPars,MainPars,SimPars]=GetParams(tab) Get (sorted) parameters to fill the parameters table

global DataType 
    nPars = length(tab) ; 
    ClaPars= struct() ; 
    MainPars= struct() ; 
    SimPars= struct() ; 
    
    for cnt = 1:nPars
%     Ind
%     Name
%     MinVal
%     MaxVal
%     Value
%     Description
        next = tab(cnt) ; 
        nextvalue =  FetchObj( [hex2dec('2208'),next.Ind] , DataType.float , 'Read parameter' ) ; 
        nDot = strfind(next.Name,'.') ; 
        if (length(nDot) == 1) 
            nexttype = next.Name(1:nDot-1);
            nextname = next.Name(nDot+1:end);
            % Avoid parantheses in field names, as these are ilegal in Matlab 
            nextname = strrep(nextname,'[',''); 
            nextname = strrep(nextname,']',''); 
        else
            continue ; 
        end

        if isequal (nexttype,'ControlPars' )
            MainPars.(nextname) = nextvalue ; 
        elseif isequal (nexttype,'ClaControlPars')
            ClaPars.(nextname) = nextvalue ; 
        elseif startsWith (nextname,'Sim')
            SimPars.(nextname) = nextvalue ; 
        end 
    end 

end