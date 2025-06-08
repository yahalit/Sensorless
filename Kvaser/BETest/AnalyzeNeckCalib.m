function AnalyzeNeckCalib( fname , plotFig )
errMsg = []; Calib = [] ;p1 = [] ; p2 = [] ;  
if nargin < 2 || isempty(plotFig) 
    plotFig = figure  ; 
end 
if nargin < 1
    fname = 'NeckCalibRslt.mat' ; 
end 

r = load(fname) ;%  Geom Roll UserPos PotRat1 PotRat2 
if ~isfield(r,'t')
    r.t = cumsum( ones(size(r.Roll))) - 1 ;
end

pUserPos = WRegression(r.UserPos , r.Roll ,  18 );
pPotRat1 = WRegression(r.PotRat1 , r.Roll ,  18 );
pPotRat2 = WRegression(r.PotRat2 , r.Roll , 18 );

if ( pUserPos(1) < 0.98 || pUserPos(1) > 1.02)
    errMsg =  'Encoder fitting is out of range'  ; 
end
if ( pPotRat1(1) < 8.0 || pPotRat1(1) > 9)
    errMsg = 'Pot1 fitting fitting is out of range'  ; 
end
if ( pPotRat2(1) < 7.5 || pPotRat2(1) > 8.5)
    errMsg = 'Pot2 fitting fitting is out of range'  ; 
end

if isempty(errMsg) 

    PotGainFac1 =  pPotRat1(1) / r.Geom.Pot1Rat2Rad - 1 ;
    PotGainFac2 =  pPotRat2(1) / r.Geom.Pot2Rat2Rad - 1 ;
    PotCenter1 = -(pPotRat1(2)/ pPotRat1(1) + 0.5) ;
    PotCenter2 = -(pPotRat2(2)/ pPotRat2(1) + 0.5) ;

    if ( abs(PotGainFac1)  > 0.1 || abs(PotGainFac2)  > 0.1 || abs(pPotRat1)  > 0.2|| abs(pPotRat2)  > 0.2) 
        errMsg = 'Too big calibration deviation';
    end
    
    p1 =( r.PotRat1 - PotCenter1 - Geom.Pot1RatCenter) * ( 1.0  + PotGainFac1) * Geom.Pot1Rat2Rad ;
    p2 =( r.PotRat2 - PotCenter2 - Geom.Pot2RatCenter) * ( 1.0  + PotGainFac2) * Geom.Pot2Rat2Rad ;
    
    if ~isempty(plotFig)
        figure(plotFig) ; 
        clf
        plot( r.t , r.Roll ,  r.t , polyval(pUserPos,r.UserPos),  r.t , ...
            p1,  r.t , p2 );
        if ~isempty(errMsg) 
            title(errMsg) ; 
        end
        legend('Roll','UserPos','PotRat1','PotRat2') ; 
    end

    Calib = struct('PotGainFac1',PotGainFac1,'PotGainFac2',PotGainFac2,...
        'PotCenter1',PotCenter1,'PotCenter2',PotCenter2) ;
end

save AnalyzeNeckRslt.mat errMsg Calib p1 p2 
end 
