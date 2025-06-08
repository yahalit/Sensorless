function MotorOnSeq()
global c ClaControlPars ClaState ClaMailIn ClaSimState SinTable  SysState ControlPars Commutation ClaMailOut %#ok<*GVMIS,*NUSED> 

SetEnums ;
    % Run reference generators
    if ( ClaState.SystemMode == E_SysMotionModeAutomatic )
    
        CurMax = ControlPars.MaxCurCmd * SysState.Mot.CurrentLimitFactor;
    else
    
        % Limit current command
        CurMax = ControlPars.MaxCurCmd  ;
    end

    if ( SysState.Status.HaltRequest)
        CurMax = ControlPars.MaxCurCmd; 
        ClaState.CurrentControl.CurrentReference = 0 ;
        SysState.SpeedControl.SpeedReference = 0 ;
        SysState.Mot.ReferenceMode = E_PosModeStayInPlace ;
    end

    % Open loop field direction
    if ( SysState.Mot.LoopClosureMode == E_LC_OpenLoopField_Mode )
     % Open loop mode always goes with debug waveforms - G for the current command and T for the angle
        CurCmd = SysState.Debug.TRef.Out;
        ClaMailIn.ThetaElect = SysState.Debug.GRef.Out;
    else
    

        % Commutation runs
        if ( SysState.Mot.LoopClosureMode >= E_LC_Torque_Mode )
        
            if ( ClaState.SystemMode == E_SysMotionModeManual )
             % Manual mode - take current command from the G generator
                if ( SysState.Mot.ReferenceMode == E_PosModeDebugGen ) 
                    CurCmd = SysState.Debug.TRef.Out;
                else
                    CurCmd = 0 ;
                end 
            else
            
                CurCmd = ClaState.CurrentControl.CurrentReference ;
            end

            if ( Commutation.Status < 0 )
            
                return ;
            end
            ClaMailIn.ThetaElect = Commutation.ComAnglePu + 0.25 ;
        end


        % Position controller
        if ( SysState.Mot.LoopClosureMode >= E_LC_Pos_Mode )
        
            SysState.PosControl.PosError =  SysState.PosControl.PosReference - SysState.Encoder.UserPos ;
            SysState.SpeedControl.SpeedCommand = GetSpeedCmdForPerr( SysState.PosControl.PosError , SysState.SpeedControl.SpeedReference );
        else
        
            SysState.SpeedControl.SpeedCommand = SysState.SpeedControl.SpeedReference ;
        end

        % Limit the speed reference
        SysState.SpeedControl.SpeedCommand = fSatNanProt (SysState.SpeedControl.SpeedCommand , ControlPars.MaxSpeedCmd ) ;


        % Speed Controller
        if ( SysState.Mot.LoopClosureMode >= E_LC_Speed_Mode )
            CurCmd = GetCurrentCmdForSpeedErr(  CurCmd  );
        end

    end

    ClaState.CurrentControl.CurrentCommand =  fSatNanProt( CurCmd , CurMax ) ;
    if ( abs(ClaState.CurrentControl.CurrentCommand)  ==  CurMax )
    
        if ( SysState.Mot.CurrentLimitCntr < 50 )
        
            SysState.Mot.CurrentLimitCntr = SysState.Mot.CurrentLimitCntr + 1 ;
        else
        
            SysState.Mot.CurrentLimitCntr = max( SysState.Mot.CurrentLimitCntr - 3 , 0 );
        end
    end
    % Current controller
    %GetVoltageCmdForCurErr ( SysState.CurrentControl.CurrentCommand , SysState.VoltageControl.VoltageReference , &SysState.VoltageControl.VoltageCommands[0]  );

    % Trajectory generator
    if ( ClaMailOut.StoEvent || SysState.Mot.QuickStop)
    
        if ( SysState.Mot.LoopClosureMode >= E_LC_Speed_Mode)
        
            SysState.Mot.ProfileConverged = StopProfiler(  ) ;
        else
        
            SysState.Mot.ProfileConverged = 1 ;
        end
        SetReferenceMode(E_PosModeStayInPlace) ;
        ClaState.CurrentControl.CurrentReference = 0 ;
        if ( SysState.Mot.ProfileConverged  && ClaMailOut.StoEvent )
        
            LogException(EXP_FATAL,exp_expecting_sto ) ;
        end
    else
    
        if ( SysState.Mot.LoopClosureMode >= E_LC_Pos_Mode )
         % Position profile
            switch (SysState.Mot.ReferenceMode )
            case E_PosModeDebugGen
                SysState.PosControl.PosReference = SysState.Debug.GRef.Out ;  
                SysState.Mot.ProfileConverged = 1 ; 
            case E_PosModePTP
                [SysState.Mot.ProfileConverged,SysState.Profiler(SysState.ActiveProfiler+1)] = AdvanceProfiler(SysState.Profiler(SysState.ActiveProfiler+1) , SysState.Timing.TsTraj ) ;
                SysState.PosControl.PosReference  = SysState.Profiler(SysState.ActiveProfiler+1).ProfilePos ;
                SysState.SpeedControl.SpeedReference = SysState.Profiler(SysState.ActiveProfiler+1).ProfileSpeed ;

            case E_PosModePT
                SysState.Mot.ProfileConverged = PVTRunTimeDriver(SysState.Timing.UsecTimer) ;
            otherwise % case E_PosModeStayInPlace:
                SysState.Mot.ProfileConverged = StayInPlaceDriver(SysState.Timing.UsecTimer);
            end

            % Keep position to limits
            SysState.PosControl.PosReference = Sat2Side(SysState.PosControl.PosReference , ControlPars.MinPositionCmd , ControlPars.MaxPositionCmd ) ;

        elseif ( SysState.Mot.LoopClosureMode == E_LC_Speed_Mode )
         % Speed profiler
            SysState.PosControl.PosReference = SysState.Encoder.UserPos ; 
            switch (SysState.Mot.ReferenceMode )
            case E_PosModeDebugGen
                 SysState.SpeedControl.SpeedReference = SysState.Debug.GRef.Out ;
                 SysState.Mot.ProfileConverged = 1 ;
            otherwise
                SysState.Mot.ProfileConverged = SpeedProfiler() ;
            end
        else
            SysState.PosControl.PosReference = SysState.Encoder.UserPos ; 
            SysState.SpeedControl.SpeedReference = SysState.Encoder.UserSpeed ; 
        end
    end
end


function y = Sat2Side(x,xl,xh)
    y = min(max((x),(xl)),(xh)); 
end

function SpeedCmd = GetSpeedCmdForPerr( PosError, vt   )
global c ControlPars SysState 

    a = ControlPars.MaxAcc  ;
    alim = a ;
    t0 = ControlPars.SpeedCtlDelay;
    vmax = ControlPars.MaxSpeedCmd ;
    
    if ( PosError * vmax > 0  )
    
        t0 = min(t0,PosError/ max(vmax,1e-6) ) ;
    else
    
        t0 = 0 ;
    end


    dVMotEncSec = a * SysState.Timing.Ts ;
    if ( PosError >= 0 )
        if ( vt < 0 )
            SpeedSat = vmax ; 
            SpeedSatByEdge = vmax ; 
        else
            SpeedSat =  min( -(a * t0) + sqrt(a * a * t0 * t0 + 2 * ( max(PosError,vt*2*t0) * a)+vt*vt), vmax ) ;
            SpeedSatByEdge = -(alim * t0) + sqrt(alim * alim * t0 * t0 + 2 * max((ControlPars.MaxPositionCmd-SysState.Encoder.UserPos)* alim,0) ) ;
        end
        SpeedSat = min( SpeedSat , SpeedSatByEdge ) ;
        SpeedCmd = min(min(ControlPars.PosKp * PosError + vt , SpeedSat) , SysState.SpeedControl.SpeedCommand + dVMotEncSec )  ;
    else
        if ( vt > 0 )
            SpeedSat = -vmax ; 
            SpeedSatByEdge = -vmax ; 
        else
            SpeedSat =  max( (a * t0) - sqrt(a * a * t0 * t0 + 2 * ( max(-PosError,-vt*2*t0) * a)+vt*vt), -vmax ) ;
            SpeedSatByEdge = (alim * t0) - sqrt(alim * alim * t0 * t0 + 2 * max((SysState.Encoder.UserPos-ControlPars.MinPositionCmd)* alim,0)  ) ;
        end    
        SpeedSat = max( SpeedSat ,SpeedSatByEdge ) ;
        SpeedCmd =    max( max(ControlPars.PosKp * PosError + vt , SpeedSat) , SysState.SpeedControl.SpeedCommand - dVMotEncSec ) ;
    end
end






