x = load('SigRecmissjunk.mat');
r = x.RecStr ; 

%               t: [0 0.0164 0.0328 0.0492 0.0655 0.0819 0.0983 0.1147 0.1311 0.1475 … ]
%              Ts: 0.0164
%    RWheelEncPos: [30731 30731 30731 30731 30731 30731 30731 30731 30731 30731 30731 … ]
%    LWheelEncPos: [30916 30916 30916 30916 30916 30916 30916 30916 30916 30916 30916 … ]
%         tOutCnt: [366 366 366 366 366 366 366 366 366 366 366 366 366 366 366 366 366 … ]
% ShelfSubSubMode: [1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 … ]
%      bPinState0: [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 … ]
%      bPinState1: [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 … ]
%         RPinPos: [2837 2837 2837 2837 2837 2837 2837 2837 2837 2837 2837 2837 2837 2837 … ]
%         LPinPos: [3870 3870 3870 3870 3870 3870 3870 3870 3870 3870 3870 3870 3870 3870 … ]
tmax = 10 ; 
ind = find( r.t < 10) ; 
nn = fieldnames(r) ;
for cnt = 1:length(nn) 
    temp = r.(nn{cnt});
    try
        r.(nn{cnt}) = temp(ind) ; 
    catch
    end
end
t = r.t ; 
figure(1);
subplot(2,1,1); 
plot( t ,r.ShelfSubSubMode);
subplot(2,1,2); 
plot( t ,r.bPinState0, t ,r.bPinState1); legend('0','1')
figure(2);
subplot(2,1,1); 
plot( t ,r.tOutCnt);
subplot(2,1,2); 
plot( t ,r.RWheelEncPos, t ,r.LWheelEncPos); legend('R','L')

