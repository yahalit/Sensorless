function str = GetIdentRslt(stin) 
    % stin = struct('v11',v11,'v21',v21,'v31',v31,'v12',v12,'v22',v22,'v32',v32,'Mat',Mat,'Ts',Ts) ; 

    if ( norm(stin.Mat(4,1:2)) > stin.Mat(4,4) * 1e-4 ) 
        error('Bad data - not integer amount of cycles') ; 
    end 
    if ( cond(stin.Mat) < 1e-6 ) 
        error('Bad data - badly conditioned setup matrix') ; 
    end
    Mi       = inv( stin.Mat) ; 
    tht11    = Mi * stin.v11 ; %#ok<*MINV> 
    tht21    = Mi * stin.v21 ; 
    tht31    = Mi * stin.v31 ; 
    tht12    = Mi * stin.v12 ; 
    tht22    = Mi * stin.v22 ; 
    tht32    = Mi * stin.v32 ; 

    [a11,p11] = GetAmpPhase(tht11(1:2)) ; 
    [a21,p21] = GetAmpPhase(tht21(1:2)) ; 
    [a31,p31] = GetAmpPhase(tht31(1:2)) ; 
    
    [a12,p12] = GetAmpPhase(tht12(1:2)) ; 
    [a22,p22] = GetAmpPhase(tht22(1:2)) ; 
    [a32,p32] = GetAmpPhase(tht32(1:2)) ; 

    str = struct( 'a11',a11,'p11',p11,'a21',a21,'p21',p21,'a31',a31,'p31',p31,...
                  'a12',a12,'p12',p12,'a22',a22,'p22',p22,'a32',a32,'p32',p32) ; 

end 


function [a,p] = GetAmpPhase(tht) 
a = norm(tht(1:2)) ; 
p = atan2(tht(2),tht(1)) ; 
end
