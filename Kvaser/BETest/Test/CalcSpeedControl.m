function [Kp,Ki] = GetSpeedControl( str , BWHz , rev2pos , drawit ) 
% Get the speed controller 

% ClaMailIn = struct('Ts',Ts,'SimVdc',38,'IaOffset',0,'IbOffset',0,'IcOffset',0,'ThetaElect',0,...
%      'SimdT',Ts,'SimKe',KErmsLL * sqrt(3)/4  ,'SimR',Rphase ,'SimDtOverL', Ts / Lphase ,'SimKtOverJdT', 0.025 , 'SimBOverJdT', 2.5e-5  ) ; 
if nargin < 4 
    drawit = 0 ; 
end

KtOverJ = str.SimKtOverJdT * rev2pos / str.Ts ; 
BOverJ  = str.SimBOverJdT  * rev2pos / str.Ts ; 
bw      = BWHz * 2 * pi ; 
zer     = bw / 3 ; 
cont    = tf( [1,zer],[1,0]) ; 
plant  = tf ( KtOverJ ,[1,BOverJ]) ; 
g = abs( freqresp(cont*plant,bw) ) ; 
cont    = cont / g ; 


dcont  = c2d(cont,str.Ts,'zoh') ; 
dplant = c2d(plant,str.Ts,'zoh') ; 

if drawit
    figure(31) ; clf 
    bode(cont * plant) ; 
    hold on ; 
    bode(dcont * dplant) ; 
end 

nn = dcont.num{1} ; 
dd = dcont.den{1} ; 
nn = nn / dd(1) ; 

Ki = sum( nn) / str.Ts ; 
Kp = -nn(2)  ;

end