/*
 * TrapezeProfiler.h
 *
 *  Created on: May 12, 2023
 *      Author: yahal
 */

#ifndef CONTROL_TRAPEZEPROFILER_H_
#define CONTROL_TRAPEZEPROFILER_H_

#ifndef TRAPEZE_PROFILER_H_DEFINED
#define TRAPEZE_PROFILER_H_DEFINED


enum E_ProfileMode
{
    EProfile_PerAxis = 0 ,
    EProfile_ToolTip = 1
};



struct CProfiler
{
    float ProfileSpeed ; // !< Profile speed command (m or rad)/sec
    float ProfilePos   ; // !< Profile position command
    float PosDiff ;
    float tau          ; // !< Expected delay between speed reference and its convergence
    float tauact          ; // !< Expected delay between speed reference and its convergence
    float PosTarget  ;
    float PosTarget2 ;
    float PosTarget3 ;
    float PosTarget4 ;
    float accel ;
    float dec ;     // Profile deceleration (always positive, on stopping acc = -dec)
    float slowvmax ;
    float vmax ;
    long  PauseCtr ; // A counter for the debug repetitive PTP mode
    short Blocked ;
    short unsigned bSlow   ;
    short unsigned bPeriodic;
    short Done ;
};

void ResetProfiler ( struct CProfiler * pProf , float pos , float v , short unsigned reset );
short ProgramProfiler(  struct CProfiler * pProf , float vmax , float amax , float dmax , float tau , short unsigned mode );
void ReposRotProfiler ( struct CProfiler * pProf , float pos , float maxdelta  , float deltagain );

short unsigned  AdvanceProfiler(struct CProfiler * pProf , float dt );
short unsigned  PauseProfiler(struct CProfiler * pProf , float dt );
void ProfileToStop ( struct CProfiler * pProf , float pos , float v );



#endif






#endif /* CONTROL_TRAPEZEPROFILER_H_ */
