function pState = RefGen(pPars , pState , dt )

SetEnums ; 
    pState.Time = fracf32(pState.Time + pPars.f * dt ) ;

    switch ( pState.Type * pState.On )
    
    case E_S_Fixed
        pState.Out  = pPars.Dc ;
        pState.dOut = 0 ;
    case E_S_Sine
        pState.Out   = pPars.Dc + pPars.Amp * sin( pState.Time * (2*pi) ) ;
        pState.dOut  = (2*pi) * pPars.f * pPars.Amp * cos(pState.Time * (2*pi) ) ;
    case E_S_Square
        b = pPars.Amp ;
        a = 2 * b ;
        pState.Out   = pPars.Dc - b  ;
        if ( pState.Time < pPars.Duty) 
            pState.Out   =  pState.Out + a  ;
        end
        pState.dOut = 0 ;
    case E_S_Triangle
        b = pPars.Amp ;
        a = 2 * b ;
        if ( pState.Time < pPars.Duty  )
        
            InvDuty = 1.0 / max(pPars.Duty, pPars.f * dt );
            d =  a * InvDuty  ;
            pState.Out   = pPars.Dc - b + d * pState.Time   ;        
        else
        
            InvDuty = 1.0 / max(1-pPars.Duty, pPars.f * dt );
            d =  -a * InvDuty  ;   
            pState.Out   = pPars.Dc - b + ( pState.Time-1)* d ;
        end
        pState.dOut =  d * pPars.f ;  
    otherwise
        pState.Out = 0 ;
        pState.dOut = 0 ;
    end
end
