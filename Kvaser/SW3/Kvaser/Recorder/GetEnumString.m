function str = GetEnumString( enum, n ) 
names = fieldnames(enum) ; 
str = 'Not found' ; 
for cnt = 1:length(names) 
    if enum.(names{cnt}) == n 
        str = names{cnt};
        return ; 
    end 
end