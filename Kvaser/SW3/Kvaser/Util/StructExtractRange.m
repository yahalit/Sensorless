function r  = StructExtractRange(rin,ind)

r = rin ; 

if isempty(ind) 
    return ; 
end 

nf = fieldnames(rin) ; 
n  = length(nf) ; 

for cnt = 1:n 
    if length(rin.(nf{cnt})) > 1 
        r.(nf{cnt}) =  rin.(nf{cnt})(ind) ; 
    end 
end 