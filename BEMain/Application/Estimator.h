/*
 * Estimator.h
 *
 *  Created on: 16 בספט׳ 2025
 *      Author: Yahali
 */

#ifndef APPLICATION_ESTIMATOR_H_
#define APPLICATION_ESTIMATOR_H_

#ifdef EXTERN_TAG
#undef EXTERN_TAG
#endif

#ifdef VARS_OWNER
#define EXTERN_TAG
#pragma DATA_SECTION(ClaRecsCopy, ".data"); // Assure in DMA-accesible RAM
#else
#define EXTERN_TAG extern
#endif

enum E_AcceleratingAsV2FState
{
    E_AccelerationInit = 0 ,
    E_PureF2FAcceleration = 1 ,
    E_TakingFOM = 2 ,
    E_EngagingAngleObserver = 3,
    E_EngagingSpeedControl = 4
};

struct CSLessData
{
    float I[3];
    float IOld[3];
    float V[3];
};

typedef struct
{
    short bBeforeTakingEstimatorFOM ; // 1 when not yet started FOM estimation
    short bAcceleratingAsV2FState ;
    float FOMConvergenceTimer ; // Timer for timeouting FOM convergence
    float FOMConvergenceGoodTimer ; //Timer for establishing FOM convergence
} FomState_T ;

struct CSLState
{
    float ThetaEst;
    float ThetaPsi; // Electrical angle, based on atan of flux integrals, no smoothing other than integration
    float IAlpha;
    float IBeta;
    float VAlpha;
    float VBeta;
    float Id;
    float Iq;
    float Ld;
    float Lq;
    float Phida;
    float FluxIntA;
    float FluxIntB;
    float FluxErrA;
    float FluxErrB;
    float FluxErrIntA;
    float FluxErrIntB;
    float VcompA;
    float VcompB;
    float ETheta; // Estimator error for theta
    float OmegaHat;   // Estimated Omega
    float OmegaState; // PLL state of Omega
    float ThetaHat;
    float IdDemandPhase;
    float IdDisturbancePhase;
    float CommAngleDisturbance;
    float CommAngleQuadDisturbance;
    float DeltaThetaOnEngage ; // The angle difference that need be compensated at the engage time
    short On; // 1: Algorithm is active 0: Observing only
    short DInjectionOn; // 1: Inject D "noise"
    FomState_T FOM ;
};



typedef struct
{
    float CyclesForConvergenceApproval ; // !< The number of cycles in open loop mode in which the observer must show convergence
    float ObserverConvergenceToleranceFrac ; // !< The acceptable fraction of deviation from the expected speed
    float MaximumSteadyStateFieldRetard ; // !< The maximum field retard acceptable on steady state.
    float MinimumSteadyStateFieldRetard ; // !< The minimum field retard acceptable on steady state.
    float FOMTakingStartSpeed ; // Speed following which FOM is taken
    float OpenLoopAcceleration ; // !< The acceleration rate to OpenLoopEndSpeed
    float FOMConvergenceTimeout ; // Timeout for FOM convergence decision
    float OmegaCommutationLoss  ; // Speed that if you go below you consider commutation loss
}FomEstimatePars_T;


struct CSLPars
{
    float PhiM; // Flux of magnet
    float Lq0;  // Nominal inductance for q
    float LqCorner2; // Saturation current for q field
    float Ld0;       // Nominal inductance for d
    float LdSlope;   // Linear dependence of D inductance in d current
    float R;         // Resistance
    float dT;        // Time interval for integration
    float KiTheta; // Ki of the theta PLL
    float KpTheta; // Kp of the theta PLL
    float KiFlux;
    float KpFlux;
    float DInjectionFreqFac; // Factor between D injection frequency and motor frequency
    float DInjectionAmp    ; // D injection amplitude in Amp
    float WorkAcceleration  ;
    float WorkSpeed  ;
    FomEstimatePars_T FomPars  ; // Parameters for initial FO estimate
};

EXTERN_TAG struct CSLessData SLessData;
EXTERN_TAG struct CSLState   SLessState;
EXTERN_TAG struct CSLState   SLessStatePU;
EXTERN_TAG struct CSLState   SLessStateBU;
EXTERN_TAG struct CSLPars SLPars;

#define PI2 6.283185307179586f
#define InvPI2 0.159154943091895f





#endif /* APPLICATION_ESTIMATOR_H_ */
