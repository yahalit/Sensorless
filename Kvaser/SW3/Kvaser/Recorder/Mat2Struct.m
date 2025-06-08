function r = Mat2Struct( fname) 
if ischar(fname) 
    xxx = load( fname) ; 
else
    xxx = fname ; 
end 
r = struct( 't', xxx.t) ; 
for cnt = 1:length(xxx.RecNames) 
    r.(xxx.RecNames{cnt}) = xxx.RecVec(cnt,:) ; 
end 