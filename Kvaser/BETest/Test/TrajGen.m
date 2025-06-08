





function  GetCommAnglePu(Encoder)

global c ClaControlPars ClaState ClaMailIn ClaSimState SinTable SysState ControlPars HallDecode %#ok<*GVMIS> 
SetEnums ; 

   delta = Encoder - Commutation.OldEncoder ;
   Commutation.OldEncoder = Encoder ;

   enc = Commutation.EncoderCounts + delta ;
   if ( enc < 0 )
   
      % enc += Commutation.EncoderCountsFullRev ;
      enc =  enc+ Commutation.EncoderCountsFullRev ; %OBB changed due to unclear syntax error

   end
   if ( enc >=  Commutation.EncoderCountsFullRev)
   
      %enc -= Commutation.EncoderCountsFullRev ;
      enc = enc - Commutation.EncoderCountsFullRev ; %OBB changed due to unclear syntax error

   end
   Commutation.EncoderCounts = enc ;

   stat = GetHallComm() ;

   RetVal = 0 ;
   switch( Commutation.CommutationMode )
   
   case  COM_OPEN_LOOP
       % Nothing to do
       
   case  COM_HALLS_ONLY
       if (HallDecode.HallException == 0 )
       
           Commutation.ComAnglePu = HallDecode.HallAngle ;
           RetVal = 0 ;
       else
       
           LogException(EXP_FATAL,HallDecode.HallException) ;
           RetVal = -1;
       end

   case  COM_ENCODER
       if ( Commutation.Init == 0 )
       
           if ( HallDecode.HallException == 0 )

               if ( stat == 1 )
               
                   %Commutation.EncoderCounts = (long) (
                   %HallDecode.HallAngle * Commutation.EncoderCountsFullRev  %* ClaControlPars.OneOverPP ) ; %OBB fixed syntax
                   Commutation.EncoderCounts = long ( HallDecode.HallAngle * Commutation.EncoderCountsFullRev * ClaControlPars.OneOverPP ) ;

                   Commutation.Init = 1;
               end
           else
           
               LogException(EXP_FATAL,HallDecode.HallException) ;
               RetVal = -1 ;
           end
       end

       

   case  COM_ENCODER_RESET
       if (HallDecode.HallException == 0 )
       
           if ( stat == 1 )
           
               Commutation.EncoderCounts = fix (HallDecode.HallAngle * Commutation.EncoderCountsFullRev * ClaControlPars.OneOverPP ) ;
               Commutation.Init = 1;
           end
       else
       
           LogException(EXP_FATAL,HallDecode.HallException) ;
           RetVal = -1 ;
       end
   end
   % Limit rate of change
   Commutation.ComAnglePu = Commutation.ComAnglePu + fSat ( Commutation.Encoder2CommAngle * Commutation.EncoderCounts  - Commutation.ComAnglePu , Commutation.MaxCommChangeInCycle) ;
  % HallDecode.ComStat.fields.ThetaPu  = ( (short unsigned)( Commutation.ComAnglePu * 1024 ) & 0x3ff ) + (( Commutation.Init & 1 ) <<12 ) +
  %         ((RetVal < 0 ) ? (1<<13): 0)  + ( HallDecode.HallException ? (1<<14) : 0 ) ;
  %return RetVal ;
end










