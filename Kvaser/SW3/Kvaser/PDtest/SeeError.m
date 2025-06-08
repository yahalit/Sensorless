% x = load( 'SIgRecSave.mat') ;
% x = load( 'ManErr1.mat') ;
%x = load( 'ManErr2.mat') ;
% x = load( 'ManErr3.mat') ;
% x = load( 'ManErr4.mat') ;
x = load( 'ManErr5.mat') ;

r = x.RecStr ; 
ind = min( [min(find(r.ShoulderProfilePos-r.ShoulderProfilePos(1)) ),...
    min(find(r.ElbowProfilePos-r.ElbowProfilePos(1)) )...
    ,min(find(r.WristProfilePos-r.WristProfilePos(1)) )]) ;   %#ok<*MXFND>
ind = ind:length(r.t); 
if isempty( ind) 
    ind = 1:length(r.t); 
end 

ti = r.t(ind) ; 

figure(10) ; clf 
subplot( 2,1,1) ; 
plot( ti  , r.ShoulderProfilePos(ind), ti  , r.ShoulderPosAct(ind)) 
legend({'Shoulder Profile','act'}) ; 
subplot( 2,1,2) ; 
plot( ti  , r.ShoulderProfilePos(ind) - r.ShoulderPosAct(ind))
ylabel('Error');

figure(11) ; clf 
subplot( 2,1,1) ; 
plot( ti  , r.ElbowProfilePos(ind), ti  , r.ElbowPosAct(ind)) 
legend({'Elbow Profile','act'}) ; 
subplot( 2,1,2) ; 
plot( ti  , r.ElbowProfilePos(ind) - r.ElbowPosAct(ind))
ylabel('Error');

figure(12) ; clf 
subplot( 2,1,1) ; 
plot( ti  , r.WristProfilePos(ind), ti  , r.WristPosAct(ind)) 
legend({'Wrist Profile','act'}) ; 
subplot( 2,1,2) ; 
plot( ti  , r.WristProfilePos(ind) - r.WristPosAct(ind))
ylabel('Error');

figure(14) ; 
CommStatisticsSh  = r.CommStatisticsSh - fix( r.CommStatisticsSh(1)/ 2^16) * 2^16  ; 
CommStatisticsEl  = r.CommStatisticsEl - fix(  r.CommStatisticsEl(1) / 2^16 ) * 2^16 ;  
CommStatisticsWr  = r.CommStatisticsWr -  fix( r.CommStatisticsWr(1) / 2^16 ) * 2^16 ;
td = r.t(2:end); 
plot( td , diff(fix(CommStatisticsSh/2^16 )) ,'-x' , ...
    td , diff(fix(CommStatisticsEl/2^16 )) + 0.1,'-o' , td , diff(fix(CommStatisticsWr/2^16 )) + 0.2,'-+');

figure(15 ) ; 
plot( r.t , r.Volts24 ) ; legend('24V voltage') ;

errlog = r.MovStatUnion  ; 
errsh  = bitand( r.MovStatUnion , 255 ) ; 
errel  = bitand( r.MovStatUnion , 255 * 2^8 ) / 2^8  ; 
errwr  = bitand( r.MovStatUnion , 255 * 2^16 ) / 2^16  ; 

