function RetVal = GetHallComm()
global c ClaControlPars ClaState ClaMailIn ClaSimState SinTable SysState ControlPars HallDecode %#ok<*GVMIS> 
SetEnums ; 
HallCount2Key =   [ 1 , 3 , 2 , 6 , 4 , 5 , 1 ] ;
HallTable = [ HALL_BAD_VALUE , 0 , 2 , 1  , 4 , 5 , 3 , HALL_BAD_VALUE ] ;
HallFac = 1/6;

    hold = HallDecode.HallValue ;
    excp  = HallDecode.HallException ;

    HallDecode.HallKey = HallCount2Key (fix (fracf32( ClaSimState.MotorModuloPos * ClaControlPars.nPolePairs  + 2.083333333333333 )   * 6)  +1);

    HallDecode.HallValue = HallTable(HallDecode.HallKey+1) ;

    if ( HallDecode.HallValue==HALL_BAD_VALUE)
    
        HallDecode.HallException  =  exp_bad_hall_value  ;
        RetVal = -1 ;
    else
    
        HallDecode.HallException  =  0 ;

        if ( (hold == HallDecode.HallValue) || excp || (HallDecode.Init==0) )
         % Hall did not change or was old value illegal
            HallDecode.HallAngle = HallDecode.HallValue * HallFac ;
            HallDecode.Init = 1 ; 
            RetVal = 0 ;
        else
        
            delta = fracf32( ( HallDecode.HallValue - hold ) * HallFac  + 1.5) - 0.5 ;
            if ( abs( delta ) < 0.17 )
             % Hall changed
                HallDecode.HallAngle = fracf32 ( HallDecode.HallAngle + delta * 0.5 + 1 ) ;
                HallDecode.HallException  = 0  ;
                RetVal = 1 ;
            else
            
                HallDecode.HallException  = exp_hall_ilegal_delta  ;
                RetVal = -1  ;
            end
        end
    end

    %HallDecode.ComStat.fields.HallStat = ( HallDecode.HallKey & 7 ) &  ( (HallDecode.HallValue & 7 ) << 3 ) +  (( (short unsigned)(HallDecode.HallAngle * 1024 ) < 0x3ff ) << 6) ;
    %return RetVal ;
end