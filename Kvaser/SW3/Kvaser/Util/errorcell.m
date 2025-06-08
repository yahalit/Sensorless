function errorcell(junk) 
if ~iscell(junk) 
    error( junk) ; 
end
n = length( junk) ;
disp('!!!!!!  Error  !!!!!!') ; 
for cnt = 2:n 
    disp(junk{n}) ; 
end 
error(junk{1}); 