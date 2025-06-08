INV_CPU_CLK_HZ = 1/120e6 ; 
CUR_SAMPLE_TIME_USEC = 50 ; 
MAX_TIME_FOR_ZERO_SPEED = 6.4e-3 ; 
QEPSTS_CDEF_MASK = 4 ; 

ClaControlPars = struct('SpeedFilterCst',0.25) ; 
ClaState = struct( 'Encoder2' , struct('Rev2Bit', 4000 ,'rev2Pos', 0.05 ,'MinMotSpeedHz', 0.1 ,'MotorPosCnt' , 0 ,'bit2Rev' , 1/4000 ,'EncoderOnZero',0 ) )  ; 

ClaState.Encoder2.Pos = r.Pos2(1);
ClaState.Encoder2.UserPos = ( ClaState.Encoder2.Pos -  ClaState.Encoder2.EncoderOnZero )  * ClaState.Encoder2.bit2Rev * ClaState.Encoder2.rev2Pos  ;
ClaState.Encoder2.MotSpeedHzFilt = r.MotSpeedHzFilt2(1); 
ClaState.Encoder2.MotSpeedHz = r.MotSpeedHz2(1); 
ClaState.Encoder2.SpeedTime = r.SpeedTime2(1); 

 for cnt = 2:40 
 
     if ( cnt == 33 )
         x = 1 ; 
     end
 
    ClaState.Encoder2.Stat = r.EncoderStat2(cnt)  ;
    pos  = r.Pos2(cnt) ;
    ClaState.Encoder2.now = r.EncoderNow2(cnt) ;
    ClaState.Encoder2.TimeLat  = r.TimeLat2(cnt) ;


    if ( ClaState.Encoder2.Pos == pos )
     % Nothing changed
        if  bitand(ClaState.Encoder2.Stat , QEPSTS_CDEF_MASK )
             ClaState.Encoder2.MotSpeedHz = 0 ;
        end
 
		ClaState.Encoder2.DeltaT = mmaxf32( (ClaState.Encoder2.now - ClaState.Encoder2.SpeedTime) * INV_CPU_CLK_HZ , CUR_SAMPLE_TIME_USEC*1e-6);

        if ( ClaState.Encoder2.DeltaT >  MAX_TIME_FOR_ZERO_SPEED)
        
            %ldebug += 2  ;
            ClaState.Encoder2.MotSpeedHz = 0 ;
        end

        if (ClaState.Encoder2.MotSpeedHz )
        
            %ldebug += 4  ;
            sgg = 1 ; if ( ClaState.Encoder2.MotSpeedHz < 0 )  , sgg = -1 ; end 
            ClaState.Encoder2.MotSpeedHz = sgg * ...
                    mminf32( fabsf(ClaState.Encoder2.MotSpeedHz), ClaState.Encoder2.bit2Rev  /  ClaState.Encoder2.DeltaT ) ;
        else
        
            %ldebug += 8  ;
            ClaState.Encoder2.SpeedTime = ClaState.Encoder2.now ;
        end
    else
    
        %ldebug += 16 ;
        dpos = pos - ClaState.Encoder2.Pos ;
        if ( dpos >= 0 )
        
            %ldebug += 32 ;
            sg = 1 ;
        else        
            sg   = -1 ;
            dpos = -dpos ;
        end

        if bitand(ClaState.Encoder2.Stat , QEPSTS_CDEF_MASK )
         % Speed direction change occurred
            %ldebug += 64 ;
            ClaState.Encoder2.MotSpeedHz = 0 ;
        end

        CountTime =  ClaState.Encoder2.now - ( ClaState.Encoder2.TimeLat * 32 )  ; % Time of capture

        if ( sg * ClaState.Encoder2.MotSpeedHz <= 0 )
        
            ClaState.Encoder2.DeltaT = CUR_SAMPLE_TIME_USEC * 1e-6 ;  
            if ( dpos == 1 )
            
                ClaState.Encoder2.MotSpeedHz = ClaState.Encoder2.MinMotSpeedHz * sg ;
            else
                ClaState.Encoder2.MotSpeedHz = ClaState.Encoder2.bit2Rev * (dpos-1) * sg / ClaState.Encoder2.DeltaT ;
            end
        else
        
            %ldebug += 512 ;
            ClaState.Encoder2.DeltaT = mmaxf32(  (CountTime - ClaState.Encoder2.SpeedTime) * INV_CPU_CLK_HZ , 0.2 * CUR_SAMPLE_TIME_USEC*1e-6);
            ClaState.Encoder2.MotSpeedHz = dpos * ClaState.Encoder2.bit2Rev * sg  / ClaState.Encoder2.DeltaT ;
        end
        ClaState.Encoder2.SpeedTime = CountTime ;
    end


    % The motor position should count accurately as a revolution counter
    lNext  = ClaState.Encoder2.MotorPosCnt + pos - ClaState.Encoder2.Pos ;
    dlNext = lNext - ClaState.Encoder2.Rev2Bit ; % This writing is a CLA work around for flaw in integer comparison
    if ( dlNext >= 0  )    
        lNext = dlNext  ;
    end
    if ( lNext < 0  )
    
        lNext = lNext + ClaState.Encoder2.Rev2Bit ;
    end
    ClaState.Encoder2.MotorPosCnt =  lNext ;

    ClaState.Encoder2.MotorPos = ClaState.Encoder2.MotorPosCnt * ClaState.Encoder2.bit2Rev  ;

    ClaState.Encoder2.Pos = pos ;


    up = ClaState.Encoder2.UserPos ;



    ClaState.Encoder2.UserPos = ( pos -  ClaState.Encoder2.EncoderOnZero )  * ClaState.Encoder2.bit2Rev * ClaState.Encoder2.rev2Pos  ;
    ClaState.Encoder2.UserPosDelta = ClaState.Encoder2.UserPos - up ;
    ClaState.Encoder2.MotSpeedHzFilt  = ClaState.Encoder2.MotSpeedHzFilt + ClaControlPars.SpeedFilterCst * ( ClaState.Encoder2.MotSpeedHz - ClaState.Encoder2.MotSpeedHzFilt) ;
    ClaState.Encoder2.UserSpeed = ClaState.Encoder2.MotSpeedHz * ClaState.Encoder2.rev2Pos ;
end