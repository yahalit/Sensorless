/*
 * Commutation.c
 *
 *  Created on: May 12, 2023
 *      Author: Gal Lior
 */

// Hall sensor commutat

#include "..\Application\StructDef.h"






void InitHallModule(void)
{
    HallDecode.HallValue = HALL_BAD_VALUE ;
    HallDecode.HallException  = 0 ;
    HallDecode.Init = 0 ;

}

/*
// Get the Hall commutation
// Return value:
-1: Error
 0: Normal
 1: Accurate
 */

#ifdef  SIMULATION_MODE
const short unsigned HallTable[8] = { HALL_BAD_VALUE  , 0 , 2 , 1  , 4 , 5 , 3 , HALL_BAD_VALUE } ;
const short unsigned HallCount2Key[7] = { 1 , 3 , 2 , 6 , 4 , 5 , 1} ;
#endif



short GetHallComm()
{
    short unsigned ChangeKey,  port  ;
    short hold = HallDecode.HallValue ;
    short unsigned excp  = HallDecode.HallException   ;
    short RetVal ;
    short  oldValue;
    float delta ;
    long OldTimerCatch , deltat ;

    oldValue = HallDecode.HallValue ;

    union UMultiType u ;

#ifndef SLAVE_DRIVER
    //union UMultiType u1,u2,u3 ;

    port = HWREGH( GPIODATA_BASE + GPIO_O_GPADAT + 1 ) ;
    HallDecode.HallKey = ((port >> 5) & 5 )   + ( (port >> 3) & 2  ) ;
#endif





    HallDecode.HallValue = HallTable[HallDecode.HallKey] ;


    if ( HallDecode.HallValue==HALL_BAD_VALUE)
    {
        HallDecode.HallException  =  exp_bad_hall_value  ;
        RetVal = -1 ;
    }
    else
    {

        HallDecode.HallException  =  0 ;

        if ( (hold == HallDecode.HallValue) || excp || (HallDecode.Init == 0 ) )
        { // Hall did not change or was old value illegal
            HallDecode.HallAngle = __fracf32 ( (float) HallDecode.HallValue * HallFac + 1 + HallDecode.HallAngleOffset)  ;
            if ( HallDecode.Init == 0 )
            {
                HallDecode.Init = 1 ;
                HallDecode.OldKey  = HallDecode.HallKey ;
                HallDecode.Old2Key = HallDecode.OldKey  ;
            }
            RetVal = 0 ;
        }
        else
        {
            delta = __fracf32( (short)(HallDecode.HallValue - hold) * HallFac  + 2.5f) - 0.5f;
            if ( fabsf( delta ) < 0.17f )
            { // Hall changed
                HallDecode.HallAngle = __fracf32 ( HallDecode.HallAngle + delta * 0.5f + 2  );
                HallDecode.HallException  = 0  ;

                ChangeKey = HallDecode.OldKey  ^ HallDecode.HallKey ;
                u.us[0] = ( HallDecode.HallKey & 7 ) | ( (HallDecode.OldKey & 7 ) << 3 ) | ((oldValue &7)<<6) | ( (HallDecode.HallValue & 7 ) << 9 )  ;
                u.us[1] = (short)(__fracf32(ClaMailIn.ThetaElect) * 32767.5f );
                SysState.Debug.HallCatch.KeyCatch       = u.ul ;

                SysState.Debug.HallCatch.EncoderOnCatch = ClaState.Encoder1.Pos ;
                OldTimerCatch = HallDecode.TimerOnCatch;
                HallDecode.TimerOnCatch =  ~HWREG( CPUTIMER0_BASE+CPUTIMER_O_TIM) ;
                if ( ChangeKey & 1 )
                {
                    HallDecode.TimerOnCatch  -= (long) ((long unsigned) GPIO_getInterruptCounter(GPIO_INT_XINT1));
                }
                else
                {
                    if ( ChangeKey & 2 )
                    {
                        HallDecode.TimerOnCatch  -=  (long) ((long unsigned) GPIO_getInterruptCounter(GPIO_INT_XINT2));
                    }
                    else
                    {
                        HallDecode.TimerOnCatch  -=  (long) ((long unsigned) GPIO_getInterruptCounter(GPIO_INT_XINT3));
                    }
                }
                deltat = HallDecode.TimerOnCatch - OldTimerCatch ;

                if ( ( deltat > (CPU_CLK_HZ / 20 ) ) || (  HallDecode.HallKey == HallDecode.Old2Key))
                {
                    HallDecode.HallSpeed = 0 ;
                }
                else
                {
                    HallDecode.HallSpeed = delta * ClaControlPars.OneOverPP * CPU_CLK_HZ / __fmax( (float) deltat , (float)(10 * CPU_CLK_MHZ) )  ;
                }
                HallDecode.Old2Key = HallDecode.OldKey ;
                HallDecode.OldKey  = HallDecode.HallKey ;

                RetVal = 1 ;
            }
            else
            {
                HallDecode.HallException  = exp_hall_ilegal_delta  ;
                RetVal = -1  ;
            }


        }
    }

    HallDecode.ComStat.fields.HallStat = ( HallDecode.HallKey & 7 ) |  ( (HallDecode.HallValue & 7 ) << 3 ) |  (( (short unsigned)(HallDecode.HallAngle * 1024 ) & 0x3ff ) << 6) ;
    return RetVal ;
}

//#pragma FUNCTION_OPTIONS ( GetCommAnglePu, "--opt_level=0" );
//volatile long e1 ;
short GetCommAnglePu(long Encoder)
{
   short stat ;
   short RetVal ;
   long  enc ; // , enc4Hall ;
   float pu ;
   //e1 = Commutation.OldEncoder ;
   long  delta = Encoder - Commutation.OldEncoder ;
   Commutation.OldEncoder = Encoder ;

   enc = Commutation.EncoderCounts + delta ;
   if ( enc < 0 )
   {
       enc += Commutation.EncoderCountsFullRev ;
   }
   if ( enc >=  Commutation.EncoderCountsFullRev)
   {
       enc -= Commutation.EncoderCountsFullRev ;
   }

   stat = GetHallComm() ;

   Commutation.Encoder4Hall = (long) (HallDecode.HallAngle * Commutation.EncoderCountsFullRev * ClaControlPars.OneOverPP ) ;

   RetVal = 0 ;

   if ( Commutation.CommutationMode != COM_OPEN_LOOP)
   {
       switch( Commutation.CommutationMode )
       {
       default:
           // Nothing to do
           return  -1;
       case  COM_HALLS_ONLY:
           if (HallDecode.HallException == 0 )
           {
               enc = Commutation.Encoder4Hall ;
               RetVal = 0 ;
           }
           else
           {
               if (  SysState.Mot.LoopClosureMode > E_LC_OpenLoopField_Mode )
               {
                   LogException(EXP_FATAL,HallDecode.HallException) ;
               }
               RetVal = -1;
           }
           break ;

       case  COM_ENCODER:
           if ( Commutation.Init == 0 )
           {
               if (HallDecode.HallException == 0 )
               {
                   if ( stat == 1 )
                   {
                       enc = Commutation.Encoder4Hall  ;
                       Commutation.Init = 1;
                   }
               }
               else
               {
                   if ( SysState.Mot.LoopClosureMode > E_LC_OpenLoopField_Mode )
                   {
                       LogException(EXP_FATAL,HallDecode.HallException) ;
                   }
                   RetVal = -1 ;
               }
           }
           else
           {
                pu = CenterDiffPu ( Commutation.Encoder4Hall * Commutation.Encoder2CommAngle , enc * Commutation.Encoder2CommAngle ) ;
                if ( fabsf(pu) > 0.12f)
                {
                    if (SysState.Mot.LoopClosureMode > E_LC_OpenLoopField_Mode)
                    {
                        LogException(EXP_SAFE_FATAL,exp_encoder_hall_deviation) ;
                    }
                }
           }

           break ;

       case  COM_ENCODER_RESET:
           if (HallDecode.HallException == 0 )
           {
               if ( stat == 1 )
               {
                    Commutation.Init = 1;
                    enc = Commutation.Encoder4Hall ;
               }
               else
               {
                   pu = CenterDiffPu ( Commutation.Encoder4Hall * Commutation.Encoder2CommAngle , enc * Commutation.Encoder2CommAngle ) ;
                    if ( fabsf(pu) > 0.125f)
                    {
                        Commutation.Init = 0 ;
                    }
                    if ( Commutation.Init == 0 )
                    {
                        enc = Commutation.Encoder4Hall ;
                    }
                }
           }
           else
           {
               if ( Commutation.Init == 0)
               {
                   if ( SysState.Mot.LoopClosureMode > E_LC_OpenLoopField_Mode )
                   {
                       LogException(EXP_FATAL,HallDecode.HallException) ;
                   }
                   RetVal = -1 ;
               }
               else
               {
                   RetVal = 0 ;
               }
           }
           break ;
       }
       pu = fSat ( CenterDiffPu(Commutation.Encoder2CommAngle * enc,Commutation.ComAnglePu) , Commutation.MaxRawCommChangeInCycle) ;
       Commutation.ComAnglePu = __fracf32(Commutation.ComAnglePu+pu+1.0f) ;
   }
   // Limit rate of change
   Commutation.EncoderCounts = enc ;
   HallDecode.ComStat.fields.ThetaPu  = ( (short unsigned)( Commutation.ComAnglePu * 1024 ) & 0x3ff ) + (( Commutation.Init & 1 ) <<12 ) +
           ((RetVal < 0 ) ? (1<<13): 0)  + ( HallDecode.HallException ? (1<<14) : 0 ) + ((stat == 1) ? (1<<15) : 0 )  ;
   return RetVal ;
}




