function  RetVal = GetCommAnglePu(Encoder)

global c ClaControlPars ClaState ClaMailIn ClaSimState SinTable SysState ControlPars HallDecode Commutation%#ok<*GVMIS> 
SetEnums ; 
   
   delta = Encoder - Commutation.OldEncoder ;
   Commutation.OldEncoder = Encoder ;

   enc = Commutation.EncoderCounts + delta ;
   if ( enc < 0 )
   
       enc = enc + Commutation.EncoderCountsFullRev ;
   end
   if ( enc >=  Commutation.EncoderCountsFullRev)
   
       enc = enc - Commutation.EncoderCountsFullRev ;
   end

   stat = GetHallComm() ;

   enc4Hall = fix(HallDecode.HallAngle * Commutation.EncoderCountsFullRev * ClaControlPars.OneOverPP ) ;

   RetVal = 0 ;
   switch( Commutation.CommutationMode )
   
   case  COM_OPEN_LOOP
       % Nothing to do

   case  COM_HALLS_ONLY
       if (HallDecode.HallException == 0 )
       
           enc = enc4Hall ;
           RetVal = 0 ;
       else
       
           LogException(EXP_FATAL,HallDecode.HallException) ;
           RetVal = -1;
       end

   case  COM_ENCODER
       if ( Commutation.Init == 0 )
       
           if (HallDecode.HallException == 0 )
           
               if ( stat == 1 )               
                   Commutation.Init = 1;
               end
               enc = enc4Hall  ;
           else
           
               LogException(EXP_FATAL,HallDecode.HallException) ;
               RetVal = -1 ;
           end
       else
            pu = CenterDiffPu ( enc4Hall * Commutation.Encoder2CommAngle , enc * Commutation.Encoder2CommAngle ) ;
            if ( fabsf(pu) > 0.12 )
                LogException(EXP_FATAL,exp_encoder_hall_deviation) ;
            end
       end

   case  COM_ENCODER_RESET
       if (HallDecode.HallException == 0 )
       
           if ( stat == 1 )
                Commutation.Init = 1;
                enc = enc4Hall ;
           else

                pu = CenterDiffPu ( enc4Hall * Commutation.Encoder2CommAngle , enc * Commutation.Encoder2CommAngle ) ;
                if ( fabsf(pu) > 0.1)
                
                    Commutation.Init = 0 ;
                end
                if ( Commutation.Init == 0 )
                
                    enc = enc4Hall ;
                end
            end
       else
       
           if ( Commutation.Init == 0)
           
               LogException(EXP_FATAL,HallDecode.HallException) ;
               RetVal = -1 ;
           else
           
               RetVal = 0 ;
           end
       end
   end
   % Limit rate of change
   pu = fSat ( CenterDiffPu(Commutation.Encoder2CommAngle * enc,Commutation.ComAnglePu) , Commutation.MaxCommChangeInCycle) ;
   Commutation.ComAnglePu = fracf32(Commutation.ComAnglePu+pu+1.0) ;
   Commutation.EncoderCounts = enc ;
end
