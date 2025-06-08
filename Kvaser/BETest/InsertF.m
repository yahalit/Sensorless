function [fout,InsertIdx] = InsertF(pfInterp,pf) 
% Assume start and end points are equal 
%   also pf length > 3 , pfInterp longer than pf is log spaced 
nInterp = length(pfInterp) ; 

orgind  = 2 ; 
nextorg = pf(2) ; 
fout = pfInterp ; 
ftol = exp((log(pfInterp(end)) - log(pfInterp(1)))/((nInterp-1)*3)) ; 
InsertIdx = pf * 0 ; 
InsertIdx(1) = 1;
InsertIdx(end) = nInterp ; 

for cnt = 2:nInterp-1
    if fout(cnt) >= nextorg 
        if ( fout(cnt) / nextorg < ftol && fout(cnt) / nextorg > 1/ftol)
            fout(cnt) = nextorg ; 
            InsertIdx(orgind) = cnt ; 
        else
            if ( fout(cnt-1) / nextorg < ftol && fout(cnt-1) / nextorg > 1/ftol)
                fout(cnt-1) = nextorg ; 
                InsertIdx(orgind) = cnt - 1  ; 
            else
                fout = [fout(1:cnt-1),nextorg,fout(cnt:end)] ; 
                InsertIdx(orgind) = cnt ; 
            end 
        end
        orgind  = orgind + 1  ; 
        nextorg = pf(orgind) ; 
    end 
end

end 