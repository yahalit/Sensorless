function str = Cell2Char(c)
str = '::'; 
n = length(c) ; 
for cnt = 1:n-1
    str = [str , char(c{cnt}),' , ' ] ; %#ok<AGROW> 
end 
str = [str , char(c{n}),'::'] ; 

end