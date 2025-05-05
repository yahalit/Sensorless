/*
 * Profiler.c
 *
 *  Created on: May 12, 2023
 *      Author: Gal Lior
 */


//#include "SysUtils.h"
#include "..\Application\StructDef.h"

#include <math.h>

/*
 * \brief Reset the profiler of an inactive axis
 * \param pProf-> Profiler to reset
 * \param pos:  Initial position
 * \param v  :  Initial speed
 *
 * \param reset: if 0 , pos just sets the position target and v is ignored.
 *               if 1 , pos and v fully initializes the state
 */
void ResetProfiler ( struct CProfiler * pProf , float pos , float v , short unsigned reset )
{
    pos  = __fmax( __fmin( pos ,ControlPars.MaxPositionCmd ),ControlPars.MinPositionCmd ) ;

    pProf->PosTarget = pos ;
    if ( reset )
    {
        pProf->ProfilePos = pos ;
        pProf->ProfileSpeed = v ;
        pProf->Done = 1 ;
    }
    else
    {
        pProf->Done = 0 ;
    }
}


/*
 * \brief Make a profiler for organized stop
 * \param pProf-> Profiler to reset
 * \param pos:  Initial position
 * \param v  :  Initial speed
 * THIS ROUTINE CAN PLAY EITHER FROM INTERRUPTS OF BACKGROUND
 */
void ProfileToStop ( struct CProfiler * pProf , float pos , float v )
{
    // Predicted position on stop
    float targ ;
    short unsigned mask ;
    mask = BlockInts() ;
    targ  = pos + v * pProf->tau + v * v * 0.5f / __fmax(pProf->dec,1.0f) * ( v > 0 ? 1 : -1 ) ;
    pProf->PosTarget  = __fmax( __fmin( targ ,ControlPars.MaxPositionCmd ),ControlPars.MinPositionCmd ) ;

    pProf->ProfilePos = pos ;
    pProf->ProfileSpeed = v ;
    pProf->Done = 0 ;
    RestoreInts(mask) ;
}





/*
 * \brief Pause the profiler
 */
short unsigned  PauseProfiler(struct CProfiler * pProf , float dt )
{
    float err , vold  , v , p ;

    err = pProf->PosTarget - pProf->ProfilePos ;

    pProf->PosDiff = err ;
    v = pProf->ProfileSpeed  ;
    p = pProf->ProfilePos  ;
    vold = v ;
    if ( v > 0 )
    {
        v = __fmax( v - dt * pProf->dec , 0 ) ;
    }
    else
    {
        v = __fmin( v + dt * pProf->dec , 0 ) ;
    }

    pProf->ProfilePos = p + ( ( v + vold) * 0.5f * dt)  ;
    pProf->ProfileSpeed = v ;

    return 0 ;
}


/*
 * \brief Advance the profiler
 * \arguments:
 * pProf: Pointer to profiler struct
 * dt   : Sampling interval of routine
 */
short unsigned  AdvanceProfiler(struct CProfiler * pProf , float dt )
{
    float err, errt , vold  , dir , vm , v , p ,  a , maxspeed ,minspeed , tau, dec  ;
    short unsigned done ;
    err = pProf->PosTarget - pProf->ProfilePos ;

    pProf->PosDiff = err ; // For recorder

    // Select profile speed if low or high
    if ( pProf->bSlow )
    {
        maxspeed = pProf->slowvmax ;
    }
    else
    {
        maxspeed = pProf->vmax ;
    }

    // Present state of profile
    v = pProf->ProfileSpeed ;
    p = pProf->ProfilePos ;
    vold = v ; // Keep a copy of the speed before the update
    dec = __fmax(pProf->dec,1e-4f);

    // The algorithm deals with positive translations only, so rectify the problem
    if ( err >= 0 )
    {
        dir = 1 ;
    }
    else
    {
        v   = -v;
        err = -err ;
        dir = -1; // So we know to back the direction after calculation completes
    }

    // Find the done condition (note err >=0, no need to take abs)
    if ( fabsf(v) < __fmax(2.0f * dec * dt,5e-4f)  && (err < __fmax(9 * dec * dt * dt,1e-4f)  ) )
    {
        done = 1 ;
    }
    else
    {
        done = 0 ;
        // Get the next speed
        /* The movement is comprised of a few possible steps (only step 1 is mandatory, the rest depend on V0 & Vmax, X.
         * 1. Constant deceleration trajectory, parabolic movement in plane V vs. X based on the formula V^2 = 2*a*dx.
         * 2. Constant acceleration trajectory to get to trajectory 1, parabolic movement in plane V vs. X based on the formula V^2 = 2*a*dx.
         * 3. Constant speed - if already at V max and not yet at Vmax (also if trajectory 2 meets trajectory 1 above Vmax).
        */
        if ( v < 0 )
        {
            a = dec ;
            maxspeed = 0 ; // Do not cross the zero while stopping
            minspeed = v ;
            pProf->tauact  = 0 ;
            err = 0 ;
            errt = 0;
            vm = 0 ;
       }
        else
        {// Here v>= 0
            minspeed = 0 ;
            if ( v < 1e-4f )
            {
                tau = 0 ;
            }
            else
            {// Limiting delay - the time it will take us to reach the switching line (the delay means the time of staying at constant max speed until reaching the decelerating parabula.
                //tau = 0.5f * __eisqrtf32(pProf->dec *__einvf32(v) );
                tau = err*__einvf32(v) - v * 0.5f * __einvf32(dec) ; //approximates based on LUT - __einvf32(x) = 1/x ; __eisqrtf32(x) = 1/sqrt(x)
            }

            // Deduce the inertia from the remaining distance.
            // Inertia takes the nominal delay time if it is shorter than the switching line rendezvous time
            pProf->tauact = __fmax(__fmin( pProf->tau ,tau),0.0f);

            errt   = __fmax(0, err- v * pProf->tauact) ;


            vm = sqrtf(2.0f * dec * errt ) ; // Speed of switching line


            if ( v < vm )
            {
                a = pProf->accel ;
                maxspeed = __fmin(vm,maxspeed)  ; // Anyway d'ont cross the switching line
            }
            else
            { // Over the switching line. We don't permit overshoot, so we take the deceleration required to not overshoot even if too large.
                a = -__fmin( v * v * 0.5f / __fmax(err,1e-7f),dec * 1.3f) ;
            }
        }
        v = __fmax( __fmin( v + dt * a , maxspeed  ), minspeed ) ;
    }

    if ( done )
    {
        pProf->ProfilePos   = pProf->PosTarget ;
        pProf->ProfileSpeed = 0 ;
    }
    else
    {
        v = v * dir ;
        pProf->ProfilePos = p + ( ( v + vold) * 0.5f * dt)  ;
        pProf->ProfileSpeed = v ;
    }

    // Output by jerk limiting filter
    pProf->Done = done  ;
    return done ;
}


