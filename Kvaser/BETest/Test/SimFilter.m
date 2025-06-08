
ts = 5e-5 ; 
ClaMailIn = struct('Ts',ts);
ClaState  = struct('CurrentControl',struct('CurrentCommandSlopeLimited',0,'CurrentCmdFilterState0',0,'CurrentCmdFilterState1',0) ); 
 
w = 600 * 2 * pi ; 
xi = 0.67 ; 
den = [1 2*w*xi w^2] ; 
num = den ; num(1:end-1) = 0 ;  
dsys = c2d( tf(num,den),dt,'zoh'); 
den = dsys.den{1}; 
disp( den ) 

% den = [den 0] ; 
a0 = den(2) ; 
a1 = den(3) ; 
b0 = 1 + a0 + a1 ; 
 

ClaControlPars = struct('MaxCurCmfDdt',10000,'CurrentRefFiltB',b0,'CurrentRefFiltA0',a0,'CurrentRefFiltA1',a1) ; 
 
n= 100 ; 
sl = 1:n ; 
fl = 1:n ; 
t  = ts * (( 1:n )-1); 
ClaState.CurrentControl.CurrentCommand = 10 ; 

for cnt = 1:n

fTemp = ClaControlPars.MaxCurCmfDdt * ClaMailIn.Ts ;
    ClaState.CurrentControl.CurrentCommandSlopeLimited = ClaState.CurrentControl.CurrentCommandSlopeLimited + ...
            max (min (ClaState.CurrentControl.CurrentCommand - ClaState.CurrentControl.CurrentCommandSlopeLimited ,fTemp) , -fTemp) ;

    ClaState.CurrentControl.CurrentCommandFiltered = ClaState.CurrentControl.CurrentCommandSlopeLimited * ClaControlPars.CurrentRefFiltB ...
            - ClaState.CurrentControl.CurrentCmdFilterState1 * ClaControlPars.CurrentRefFiltA1 ...
            - ClaState.CurrentControl.CurrentCmdFilterState0 * ClaControlPars.CurrentRefFiltA0;

    ClaState.CurrentControl.CurrentCmdFilterState1 = ClaState.CurrentControl.CurrentCmdFilterState0 ;
    ClaState.CurrentControl.CurrentCmdFilterState0 = ClaState.CurrentControl.CurrentCommandFiltered ;

    sl(cnt) = ClaState.CurrentControl.CurrentCommandSlopeLimited ;
    fl(cnt) = ClaState.CurrentControl.CurrentCommandFiltered ;
end 

figure(1) ; 
clf ; 
plot( t , sl , t , fl ) ; grid on 
