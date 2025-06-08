x = load('SigRecSave.mat');
x = x.RecStr ; 
sw = x.SwField ; 
t = x.t ; 
pos = (x.Pos3-x.Pos3(1)) * 0.1 / 722 / 2.111 ; % 2.111 is ratio between ground and shelf gears 
rise = sw.RiseMarker ; 
v = sw.PresentValue ; 
figure(2000)
subplot(2,1,1); 
plot( pos , v + 0.1, pos , rise , pos , x.IndSenWL ); legend('Value','Rise','Analog'); 
subplot(2,1,2); 
plot( pos ,x.DistIntoSwitch )