/*
 * SLEstimator.c
 *
 *  Created on: 16 בספט׳ 2025
 *      Author: Yahali
 */


#include "StructDef.h"



inline float __SignedFrac(float x)
{// Return always positive fraction
    return __fracf32(__fracf32(x)+1.5f) - 0.5f;
}


short PaicuPU(void)
/*
* Based on Active Flux Concept for Motion-Sensorless Unified AC Drives, Ion Boldea; Mihaela Codruta Paicu; Gheorghe-Daniel Andreescu , 2008 IEEE transactions on power electronics
*/
{
    float s, c, a, b, d   ;
    float ipart ;
    s = __sinpuf32(SLessState.ThetaEst);
    c = __cospuf32(SLessState.ThetaEst);
    SLessState.IAlpha = 0.666666f * (SLessData.I[0] - 0.5f * (SLessData.I[1] + SLessData.I[2]));
    SLessState.IBeta = 0.577350269189626f * (SLessData.I[1] - SLessData.I[2]);

    SLessState.VAlpha = 0.666666f * (SLessData.V[0] - 0.5f * (SLessData.V[1] + SLessData.V[2]));
    SLessState.VBeta = 0.577350269189626f * (SLessData.V[1] - SLessData.V[2]);

    SLessState.Id = c * SLessState.IAlpha + s * SLessState.IBeta;
    SLessState.Iq = -s * SLessState.IAlpha + c * SLessState.IBeta;

    if (SLPars.LqCorner2 > 0)
    {
        SLessState.Lq = SLPars.Lq0 * SLPars.LqCorner2 / (SLPars.LqCorner2 + SLessState.Iq * SLessState.Iq);
    }
    else
    {
        SLessState.Lq = SLPars.Lq0;
    }
    SLessState.Ld = SLPars.Ld0 + SLPars.LdSlope * SLessState.Id;

    // Equivalent (active) flux linkage (always in the D direction)
    SLessState.Phida = SLPars.PhiM + (SLessState.Ld - SLessState.Lq) * SLessState.Id;

    // Flux estimation errors in both channels.
    // Expected A flux: LA * Ia + SLessState.Phida * c (projection of d on A)
    // Expected B flux: LB * Ib + SLessState.Phida * s (projection of d on B)
    // This should equal the flux for that axis: V-IR = d phi/ dt so int( V-IR) = LI + Phida
    SLessState.FluxErrA =   SLessState.Phida * c + SLessState.Lq * SLessState.IAlpha - SLessState.FluxIntA;
    SLessState.FluxErrB =   SLessState.Phida * s + SLessState.Lq * SLessState.IBeta  - SLessState.FluxIntB;

    // For loop closure: Integral of error
    SLessState.FluxErrIntA = SLessState.FluxErrIntA + SLessState.FluxErrA * SLPars.KiFlux * SLPars.dT;
    SLessState.FluxErrIntB = SLessState.FluxErrIntB + SLessState.FluxErrB * SLPars.KiFlux * SLPars.dT;

    // Compensation: PI control
    SLessState.VcompA = SLessState.FluxErrIntA + SLessState.FluxErrA * SLPars.KpFlux;
    SLessState.VcompB = SLessState.FluxErrIntB + SLessState.FluxErrB * SLPars.KpFlux;

    SLessState.FluxIntA = SLessState.FluxIntA + SLPars.dT * (SLessState.VAlpha - SLPars.R * SLessState.IAlpha + SLessState.VcompA);
    SLessState.FluxIntB = SLessState.FluxIntB + SLPars.dT * (SLessState.VBeta  - SLPars.R * SLessState.IBeta + SLessState.VcompB);

    // Get the angle based on flux estimates
    a = __atan2puf32((SLessState.FluxIntB - SLessState.Lq * SLessState.IBeta), (SLessState.FluxIntA - SLessState.Lq * SLessState.IAlpha));

    // Update flux angle. We keep track of full cycles, otherwise we will crash on low errors
    SLessState.ThetaPsi += __SignedFrac(a - SLessState.ThetaPsi);

    // Tracking error of accumulated angle
    b = (SLessState.ThetaPsi - SLessState.ThetaHat) ;
    // and limit it from wild deviations
    SLessState.ETheta = __fmax(__fmin(b, 40), -40);
    // PLL for speed and position
    SLessState.OmegaState = SLessState.OmegaState + SLPars.KiTheta * SLPars.dT * SLessState.ETheta;
    SLessState.OmegaHat   = SLessState.OmegaState + SLPars.KpTheta * SLessState.ETheta;

    // Advance angle by w
    d = SLessState.ThetaHat + SLessState.OmegaHat * SLPars.dT;
    //SLessState.ThetaHat = d;

// Keep ThetaHat in range. ThetaPsi is deduced as well by the same amount, to keep the difference between them
    SLessState.ThetaHat = modff(d, &ipart);
    SLessState.ThetaPsi -= ipart;
//#endif
    // Must remove shared part between ThetaPsi and ThetaHat
    // Do the entire filter per-unit
    return 0;
}


short PaicuPUAchoti(void)
/*
* Based on Active Flux Concept for Motion-Sensorless Unified AC Drives, Ion Boldea; Mihaela Codruta Paicu; Gheorghe-Daniel Andreescu , 2008 IEEE transactions on power electronics
*/
{
    float s, c, a, b, d  ;
    float ipart ;
    s = __sinpuf32(SLessState.ThetaEst);
    c = __cospuf32(SLessState.ThetaEst);
    SLessState.IAlpha = 0.666666f * (SLessData.I[0] - 0.5f * (SLessData.I[1] + SLessData.I[2]));
    SLessState.IBeta = 0.577350269189626f * (SLessData.I[1] - SLessData.I[2]);

    SLessState.VAlpha = 0.666666f * (SLessData.V[0] - 0.5f * (SLessData.V[1] + SLessData.V[2]));
    SLessState.VBeta = 0.577350269189626f * (SLessData.V[1] - SLessData.V[2]);

    SLessState.Id = c * SLessState.IAlpha + s * SLessState.IBeta;
    SLessState.Iq = -s * SLessState.IAlpha + c * SLessState.IBeta;

    if (SLPars.LqCorner2 > 0)
    {
        SLessState.Lq = SLPars.Lq0 * SLPars.LqCorner2 / (SLPars.LqCorner2 + SLessState.Iq * SLessState.Iq);
    }
    else
    {
        SLessState.Lq = SLPars.Lq0;
    }
    SLessState.Ld = SLPars.Ld0 + SLPars.LdSlope * SLessState.Id;

    // Equivalent flux linkage
    SLessState.Phida = SLPars.PhiM + (SLessState.Ld - SLessState.Lq) * SLessState.Id;
    SLessState.FluxErrA =  SLessState.Phida * c - SLessState.FluxIntA;
    SLessState.FluxErrB =  SLessState.Phida * s - SLessState.FluxIntB;

    SLessState.FluxErrIntA = SLessState.FluxErrIntA + SLessState.FluxErrA * SLPars.KiFlux * SLPars.dT;
    SLessState.FluxErrIntB = SLessState.FluxErrIntB + SLessState.FluxErrB * SLPars.KiFlux * SLPars.dT;

    SLessState.VcompA = SLessState.FluxErrIntA + SLessState.FluxErrA * SLPars.KpFlux;
    SLessState.VcompB = SLessState.FluxErrIntB + SLessState.FluxErrB * SLPars.KpFlux;

    SLessState.FluxIntA = SLessState.FluxIntA + SLPars.dT * (SLessState.VAlpha - SLPars.R * SLessState.IAlpha + SLessState.VcompA);
    SLessState.FluxIntB = SLessState.FluxIntB + SLPars.dT * (SLessState.VBeta - SLPars.R * SLessState.IBeta + SLessState.VcompB);

    a = __atan2puf32((SLessState.FluxIntB - SLessState.Lq * SLessState.IBeta), SLessState.FluxIntA - SLessState.Lq * SLessState.IAlpha);
    SLessState.ThetaPsi += __SignedFrac(a - SLessState.ThetaPsi);
    b = (SLessState.ThetaPsi - SLessState.ThetaHat) ;
    SLessState.ETheta = __fmax(__fmin(b, 40), -40);
    SLessState.OmegaState = SLessState.OmegaState + SLPars.KiTheta * SLPars.dT * SLessState.ETheta;
    SLessState.OmegaHat = SLessState.OmegaState + SLPars.KpTheta * SLessState.ETheta;

    // Advance angle by w
    d = SLessState.ThetaHat + SLessState.OmegaHat * SLPars.dT;
    SLessState.ThetaHat = d;

//#ifdef REMINT
    SLessState.ThetaHat = modff(d, &ipart);
    SLessState.ThetaPsi -= ipart;
//#endif
    // Must remove shared part between ThetaPsi and ThetaHat
    // Do the entire filter per-unit
    return 0;
}




