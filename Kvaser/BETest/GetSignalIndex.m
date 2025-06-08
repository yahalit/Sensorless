function x = GetSignalIndex( list , cpu , recstruct )
n = length(list) ; 
x = cell(1, n) ; 
z = cell(1, n) ; 

if nargin < 2
    cpu = [] ;
end

if nargin < 3 
    recstruct = [] ; 
end 

for cnt = 1:n 
    [~,x{cnt},z{cnt}] = GetSignal(list{cnt},cpu , recstruct); 
end
y   = struct('Signal',list,'Ind',x,'datatype',z) ;
str = struct() ;
for cnt = 1:n 
    str.(list{cnt}) = 0 ;  
end 

x = struct('str',y,'list',{list},'out',str);