function  EstimateMessageTiming()
global c   SysState ControlPars  %#ok<*GVMIS> 
SetEnums ;

    SysState.MCanSupport.Usec4Sync = SysState.Timing.UsecTimer ;

    if ( bitand(SysState.MCanSupport.PdoDirtyBoard ,1) == 0 )
    
        SysState.MCanSupport.SyncValid = 0 ;
    end

    if ( SysState.MCanSupport.SyncValid )
    
        MeasuredMessageTime = ( SysState.MCanSupport.Usec4Sync - SysState.MCanSupport.SyncTrackTime ) * USEC_2_SEC ;
        if ( fmin( fmax( MeasuredMessageTime, SysState.MCanSupport.MinInterMessage), SysState.MCanSupport.MaxInterMessage)  ~= MeasuredMessageTime )
        
            SysState.MCanSupport.SyncValid = 0 ;
        end
    end
    SysState.MCanSupport.SyncTrackTime = SysState.MCanSupport.Usec4Sync ;

    if ( SysState.MCanSupport.SyncValid )
    
        % Just for performance tracking
        SysState.MCanSupport.LastInterMessageTime = MeasuredMessageTime ;

        % Filter the inter-message time
        SysState.MCanSupport.InterMessageTime = SysState.MCanSupport.InterMessageTime + ...
                0.01 * ( SysState.MCanSupport.LastInterMessageTime - SysState.MCanSupport.InterMessageTime ) ;

        % Clean jitter from current message time estimate
        NextMessageTimePrediction = SysState.MCanSupport.Usec4ThisMessage + fix( SysState.MCanSupport.InterMessageTime * SEC_2_USEC ) ;
        MessageTimeInnovation = ( SysState.MCanSupport.Usec4Sync - NextMessageTimePrediction ) * 0.1 + ...
                SysState.MCanSupport.Usec4ThisMessageDebt ;

        SysState.MCanSupport.Usec4ThisMessage = NextMessageTimePrediction + fix(MessageTimeInnovation)  ;
        SysState.MCanSupport.Usec4ThisMessageDebt = fracf32(MessageTimeInnovation) ;
        SysState.MCanSupport.OneOverActMessageTime = 1.0 / SysState.MCanSupport.InterMessageTime ;

        if ( SysState.Mot.ReferenceMode  == E_PosModePT )
        
            PVNewMessageDriver(SysState.MCanSupport.uPDO1Rx.f(1+1) ) ;
        end
    else
    
        SysState.MCanSupport.Usec4ThisMessage = SysState.MCanSupport.Usec4Sync ;
        SysState.MCanSupport.Usec4ThisMessageDebt = 0 ;
        if bitand(SysState.MCanSupport.PdoDirtyBoard , 1)
        
            SysState.MCanSupport.SyncValid = 1 ; % For the next time
        end
    end
    SysState.MCanSupport.PdoDirtyBoard = 0 ;
end
