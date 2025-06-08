function KvaserPorts = IdentifyMyKvaser() 
aa = KvaserCom(1,[500000,-1]) ; 
aa = aa' ; 
[m,~] = size(aa); 
KvaserPorts = [] ; 
if m == 0 
    return ; 
end
for cnt = 1:m 
    name = char(aa(cnt,2:64));
    name = name(logical(name));
    if contains(name,'Virtual')
        continue ; 
    end
    KvaserPorts = [KvaserPorts;{cnt-1,aa(cnt,1),name}]; %#ok<AGROW> 
    %disp( ['Port: ',num2str(cnt-1),' Serial :', num2str(aa(cnt,1) ),'   Name:',name] ) ; 
end 
