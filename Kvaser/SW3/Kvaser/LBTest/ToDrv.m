global DispT %#ok<GVMIS> 
KvaserCom(2) ; % Close Kvaser Service 
close all ; 
junk = findall(groot,'Type','figure') ;
for cnt = 1:length(junk) 
    if isequal(junk.Name,'BIT')
        close( junk.Number);
        break ;
    end
end
try
delete(DispT)  ;
catch
end
clear global
cd '..\..\..\Drivers\Kvaser\WhTest'; 
AtpStart ;
disp('Ready') ; 

