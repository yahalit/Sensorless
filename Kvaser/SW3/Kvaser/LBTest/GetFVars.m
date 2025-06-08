function [s,t] = GetFVars( fname )
r = load( fname) ; 
t = r.t(:) ; 
s = struct() ; 
for cnt = 1:length(r.RecNames) 
    s.(r.RecNames{cnt}) = transpose(r.RecVec(cnt,:)) ;  
end 

end

