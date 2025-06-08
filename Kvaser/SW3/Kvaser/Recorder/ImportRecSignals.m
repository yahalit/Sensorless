% function s = ImportRecSignals(SigList, RecNames )
% find the indices of the signals listed in RecNames in the signal list SigList 
function [s,slist] = ImportRecSignals(SigList, RecNames    )
n = length(RecNames);
s = zeros(1,n) ; 
slist = logical(s) ; 

nsig = length( SigList ) ; 
for cnt = 1:n
    for cnt1 = 1:nsig  
        if isequal( SigList{cnt1}{2} , strtrim(RecNames{cnt}) )
            s(cnt) = cnt1 ; 
            slist(cnt) = true ; 
            break ;
        end 
    end
    if s(cnt) == 0 && nargout < 2 
        error ( ['Name ',RecNames{cnt},' Not found in recorder lists'] ) ; 
    end 
end 
end 

