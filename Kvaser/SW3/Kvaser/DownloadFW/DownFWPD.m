AtpStart ;

uiwait(msgbox({'Verify connection to CAN #1','Press mushroom','Power cycle the robot'})) ; 
try
ShutCan  ; 
catch 
end

try
DownFWPDBody ; 
catch 
   uiwait( errordlg('PD downloading failed') ) ;  
end 

cd ..\LBTest 
uiwait(msgbox({'Move connection to CAN #1'})) ; 
AtpStart



