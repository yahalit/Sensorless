function tab=MakeTableFromEnum(enstruct)
fld = fieldnames(enstruct) ; 
n = length(fld) ; 
codes = cell(1,n) ; 
for cnt = 1:n
    codes{cnt} = enstruct.(fld{cnt}) ; 
end
tab = struct( 'Code', codes ,'Label','') ; 
for cnt = 1:n
    tab(cnt).Label = fld{cnt} ; 
end