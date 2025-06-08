
function RetVal = PVTRunTimeDriver(tUsec)
SetEnums; 
CalcSpeed = 1 ;
global c ControlPars SysState  %#ok<*GVMIS> 

    if ( SysState.PVT.NewMsgReady )
        if ( SysState.PVT.Init == 0  )
        
            SysState.PVT.bFixedSpeed = 1;
            SysState.PVT.vFixed = SysState.SpeedControl.SpeedReference ;
            SysState.PVT.x0 = 0 ;
            SysState.PVT.a = 0 ;
            SysState.PVT.pout = SysState.PVT.ReadyMsgPosRef  ;
            SysState.PVT.pp0 = SysState.PVT.ReadyMsgPosRef  - SysState.PVT.vFixed ;
            SysState.PVT.pp1 = SysState.PVT.pp0 ;
            SysState.PVT.pp2 = SysState.PVT.pp0 ;
    
            SysState.PVT.vout = SysState.PVT.vFixed ;
            SysState.PVT.vp0 = SysState.PVT.vFixed ;
            SysState.PVT.vp1 = SysState.PVT.vFixed ;
            SysState.PVT.vp2 = SysState.PVT.vFixed ;
    
            SysState.PVT.tInterpStartUsec = tUsec  - fix( SysState.MCanSupport.NomInterMessageTime * SEC_2_USEC) ;
            SysState.PVT.Init = 1 ;
            CalcSpeed = 0 ; 
        else
            PVNewMessageExec(tUsec) ;     
        end


        SysState.PVT.NewMsgReady = 0 ;
    else
        if ( SysState.PVT.Init == 0 ) 
            StayInPlaceDriver(  ) ;
            RetVal = 0;
		    return ;             
        end 
    end


    tnow  = (tUsec - SysState.PVT.tInterpStartUsec) * USEC_2_SEC * SysState.MCanSupport.OneOverActMessageTime  ;

    if ( tnow > 4   )
    
        % New messages fail to arrive; Just stay in place
        PVResetTraj();
        StayInPlaceDriver(  ) ;
        RetVal = 0;
		return ; 
    end


    if ( SysState.PVT.bFixedSpeed )
    
        SysState.PVT.pout = SysState.PVT.pp0 + SysState.PVT.vFixed * tnow ;
        SysState.PVT.vout = SysState.PVT.vFixed ;
    else
    
        if (tnow <= SysState.PVT.x0 )
        
            SysState.PVT.vout = SysState.PVT.vp0 + SysState.PVT.a * tnow   ;
            SysState.PVT.pout = SysState.PVT.pp0 + tnow * (SysState.PVT.vp0 +  SysState.PVT.vout ) * 0.5 ;
        else
        
            if (tnow <= 1 )
            
                dt = tnow -SysState.PVT.x0 ;
                SysState.PVT.vout = SysState.PVT.vp1 - SysState.PVT.a * dt ;
                SysState.PVT.pout = SysState.PVT.pp1 + dt * (SysState.PVT.vout + SysState.PVT.vp1) * 0.5  ;
            else
            
                SysState.PVT.vout = SysState.PVT.vp2 ;
                SysState.PVT.pout = SysState.PVT.vp2 * (tnow - 1) + SysState.PVT.pp2  ;
            end
        end
    end

    % Do it with numerical derivative, as considering Tmessage/Ts fractions shall be complicated
    if CalcSpeed
        SysState.SpeedControl.SpeedReference = fSat ( (SysState.PVT.pout  - SysState.PosControl.PosReference) * SysState.Timing.OneOverTsTraj , ControlPars.MaxSpeedCmd ) ;
    end
    SysState.PosControl.PosReference = SysState.PVT.pout ;

	RetVal = 1 ; 
    return ;
end



function PVNewMessageExec(  tUsec )
global c ControlPars SysState  
SetEnums; 

    % Prepare commands for next go
    SysState.PVT.tInterpStartUsec = tUsec - SysState.Timing.TsTraj * SEC_2_USEC ;

    vnew = SysState.PVT.ReadyMsgPosRef - ( SysState.PVT.pout + SysState.PVT.vout * SysState.Timing.TsTraj * SysState.MCanSupport.OneOverActMessageTime) ;

    SysState.PVT.dv = (vnew - SysState.PVT.vout); %  

    % Position deviation from fixed speed motion
    pfin = SysState.PVT.ReadyMsgPosRef - vnew * SysState.Timing.TsTraj * SysState.MCanSupport.OneOverActMessageTime ;
    SysState.PVT.dp = pfin -  SysState.PVT.pout - SysState.PVT.vout  ;

    aa  = 2*SysState.PVT.dv ;

    if ( fabsf(aa) < 1e-5  )
    % Fixed speed case
        if (fabsf(SysState.PVT.dp) < 1e-3)
        
            SysState.PVT.bFixedSpeed = 1;
            SysState.PVT.vFixed = (pfin - SysState.PVT.pout);
            SysState.PVT.x0 = 0 ; SysState.PVT.a = 0 ;
        else
        
            % Speed remains but there is SysState.PVT.dp to close
            SysState.PVT.bFixedSpeed = 0;
            SysState.PVT.x0 = 0.5;
            SysState.PVT.a = SysState.PVT.dp;
        end
    else
    
        SysState.PVT.bFixedSpeed = 0 ;
        bb  = (4*SysState.PVT.dp - 4*SysState.PVT.dv) ;
        cc  = -2*SysState.PVT.dp + SysState.PVT.dv ;
        % Delta > 0 since delta = 2 * SysState.PVT.dp^2 + 2 * ( SysState.PVT.dp-SysState.PVT.dv)^2
        delta = sqrt(fmax(0,bb*bb-4*aa*cc))*0.5/aa ;
        bb = -0.5 * bb / aa ;

        % This is a quadratic equation, only one solution lies in 0...1
        % Take the in-interval solution
        SysState.PVT.x0 = bb + delta ;
        if ( SysState.PVT.x0 < -0.0001 || SysState.PVT.x0 > 1.001 )
        
            SysState.PVT.x0 = bb - delta ;
        end

        SysState.PVT.x0 = fmax( fmin( SysState.PVT.x0,1) , 0 ) ;
        SysState.PVT.a = (2 * SysState.PVT.x0 - 3 ) * SysState.PVT.dv  + 4 * SysState.PVT.dp ;
    end

    SysState.PVT.vp0 = SysState.PVT.vout ; 
    SysState.PVT.pp0 = SysState.PVT.pout ; 
 
    SysState.PVT.vp1 = SysState.PVT.vp0 + SysState.PVT.a * SysState.PVT.x0 ;
    SysState.PVT.pp1 = SysState.PVT.pp0 + 0.5 * SysState.PVT.x0 * ( SysState.PVT.vp1 + SysState.PVT.vp0 ) ;
    SysState.PVT.vp2 = SysState.PVT.vp1 - SysState.PVT.a * ( 1.0 - SysState.PVT.x0) ;
    SysState.PVT.pp2 = SysState.PVT.pp1 + 0.5 * ( 1 - SysState.PVT.x0) * ( SysState.PVT.vp1 + SysState.PVT.vp2 ) ;
end

