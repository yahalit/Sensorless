 function ReadEncPosition()
global   ClaState  ClaSimState SinTable SysState ControlPars HallDecode Commutation ClaMailOut  %#ok<*GVMIS> 
SetEnums ; 

    fpos  = ClaSimState.MotorPos * Commutation.EncoderCountsFullRev  ;
    ride  = fpos - SysState.Encoder.Pos ; 
    pos = floor(fpos) ;
    if ( ride >= 0 )
        posfrac = fracf32(ride) ;
    else
        posfrac = fracf32(-ride)   ;
    end
    now = SysState.Timing.UsecTimer ;

    tmr = ((CPU_CLK_MHZ/32.0)*1e6) * min ( posfrac / max( fabsf(ClaSimState.w) * ControlPars.EncoderCountsFullRev  , 1e-7) , 65535.0) ;

    if ( (pos-SysState.Encoder.Pos) * ClaSimState.w < 0 )
    
        stat = QEPSTS_CDEF_MASK;
    else
    
        stat = 0 ;
    end

    if ( SysState.Encoder.Pos == pos )
     % Nothing changed
        if bitand(stat , QEPSTS_CDEF_MASK )
        
            SysState.Encoder.MotSpeedHz = 0 ;
        end
        deltaT = now - SysState.Encoder.SpeedTime;
        if  (SysState.Encoder.MotSpeedHz )  &&  (deltaT >  MAX_TICKS_FOR_ZERO_SPEED )
            SysState.Encoder.MotSpeedHz = sign(SysState.Encoder.MotSpeedHz) * ...
                    fSat( abs(SysState.Encoder.MotSpeedHz), ControlPars.InvEncoderCountsFullRev * 1.e6 / deltaT ) ;
        end
    else
    
        dpos = pos - SysState.Encoder.Pos ;
        if ( dpos >= 0 )
        
            sg = 1 ;
        else
        
            sg   = -1 ;
            dpos = -dpos ;
        end

        if bitand(stat , QEPSTS_CDEF_MASK )
         % Speed direction change occurred
            SysState.Encoder.MotSpeedHz = 0 ;
        end

        CountTime = now - fix(tmr * (32.0/CPU_CLK_MHZ) ) ;

        if (SysState.Encoder.MotSpeedHz == 0 )
        

            if ( dpos == 1 )
            
                SysState.Encoder.MotSpeedHz = SysState.Encoder.MinMotSpeedHz * sg ;
            else
            
                SysState.Encoder.MotSpeedHz = ControlPars.InvEncoderCountsFullRev * SysState.Timing.TsInTicks * (dpos-1) * sg;
            end
        else
        
            SysState.Encoder.MotSpeedHz = dpos * ControlPars.InvEncoderCountsFullRev * sg * 1e6  /   ...
                    max( (CountTime-SysState.Encoder.SpeedTime)  , MIN_TICKS_FOR_SPEED) ;
            if ( SysState.Encoder.MotSpeedHz < -15 )
                x = 1; 
            end
            
        end
        SysState.Encoder.SpeedTime = CountTime ;
    end

    SysState.Encoder.Pos = pos ;
    if (SysState.Encoder.MotSpeedHz == 0 )
    
        SysState.Encoder.SpeedTime = 0 ;
    end

    if ( SysState.Status.HomingRequest)
    
        SysState.Encoder.EncoderOnZero = pos - SysState.Encoder.UserPosHere * ControlPars.Pos2Rev * ControlPars.EncoderCountsFullRev ;
        SysState.Status.HomingRequest = 0 ;
        SysState.PosControl.PosReference = SysState.PosControl.PosReference + SysState.Encoder.UserPosHere - SysState.Encoder.UserPos ;
    end

    up = SysState.Encoder.UserPos ;
    SysState.Encoder.UserPos = ( pos -  SysState.Encoder.EncoderOnZero ) * (ControlPars.InvEncoderCountsFullRev * ControlPars.Rev2Pos) ;
    SysState.Encoder.UserPosDelta = SysState.Encoder.UserPos - up ;
    SysState.Encoder.MotSpeedHzFilt  = SysState.Encoder.MotSpeedHzFilt + ControlPars.SpeedFilterCst * ( SysState.Encoder.MotSpeedHz - SysState.Encoder.MotSpeedHzFilt) ; 
    SysState.Encoder.UserSpeed = SysState.Encoder.MotSpeedHz * ControlPars.Rev2Pos ; 

end
