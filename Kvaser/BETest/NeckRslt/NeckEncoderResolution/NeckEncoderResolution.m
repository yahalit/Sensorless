r = load('NeckEncoderResolution') ; 
r = r.RecStr ; 

% {'EncCounts'  'ThetaElect'  'Iq'}
tht = unwrap( r.ThetaElect * 2 * pi ) / 2 / pi; 
e = r.EncCounts - r.EncCounts(1) ; 
p = polyfit(tht/4,e,1) ; 

figure(1) ; 
plot( tht , p(1) * tht/4 + p(2) , tht , e )

xlabel('PU electrical angle') ; 
ylabel('Encoder') ; 
title(['Resolution: ',num2str(round(p(1))),'  Bit/Rev' ])  ;