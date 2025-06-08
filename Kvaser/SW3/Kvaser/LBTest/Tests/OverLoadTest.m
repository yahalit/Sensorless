% Overload test 
AtpStart ;

s = GetAnalogs() ; 
disp(['Neck overload resistance =' , num2str(fix(s.OverLoadkRNk * 1000)) , ' Ohm'] ) ; 
disp(['Steering #1 overload resistance =' , num2str(fix(s.OverLoadkRSt1 * 1000)) , ' Ohm'] ) ; 
disp(['Steering #2 overload resistance =' , num2str(fix(s.OverLoadkRSt2* 1000 )) , ' Ohm'] ) ; 
disp(['Wheel #1 overload resistance =' , num2str(fix(s.OverLoadkRWh1 * 1000)) , ' Ohm'] ) ; 
disp(['Wheel #2 overload resistance =' , num2str(fix(s.OverLoadkRWh2 * 1000)) , ' Ohm'] ) ; 
disp(['Laser #1 distance =' , num2str(fix(s.UsSamp1+0.5)) , ' mm'] ) ; 
disp(['Laser #2 distance =' , num2str(fix(s.UsSamp2+0.5)) , ' mm'] ) ; 

uiwait( msgbox( 'Short the console sim load resistor using the crocodile','Please','modal') ) ; 
s = GetAnalogs() ; 
disp(['Laser #1 distance =' , num2str(fix(s.UsSamp1+0.5)) , ' mm'] ) ; 
disp(['Laser #2 distance =' , num2str(fix(s.UsSamp2+0.5)) , ' mm'] ) ; 
