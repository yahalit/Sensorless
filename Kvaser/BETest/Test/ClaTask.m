function ClaTask() 
Cla1Task1() ; 
Cla1Task2() ; 
end 

function Cla1Task1 (  )
global c ClaControlPars ClaState ClaMailIn ClaSimState %#ok<*GVMIS,*NUSED> 
global EPWM1_O_CMPA EPWM1_O_CMPB EPWM2_O_CMPA EPWM2_O_CMPB EPWM3_O_CMPA EPWM3_O_CMPB

    RunMotorSim();
    ClaState.AdcRaw.PhaseCurAdc(1) = ClaSimState.ia * ClaControlPars.Amp2Bit + 2048.0  ;
    ClaState.AdcRaw.PhaseCurAdc(2) = ClaSimState.ib * ClaControlPars.Amp2Bit + 2048.0  ;
    ClaState.AdcRaw.PhaseCurAdc(3) = ClaSimState.ic * ClaControlPars.Amp2Bit + 2048.0  ;

    ClaState.Analogs.PhaseCur(1) = ( ClaState.AdcRaw.PhaseCurAdc(1) - 2048 - ClaMailIn.IaOffset ) * ClaControlPars.Bit2Amp ;
    ClaState.Analogs.PhaseCur(2) = ( ClaState.AdcRaw.PhaseCurAdc(2) - 2048 - ClaMailIn.IbOffset ) * ClaControlPars.Bit2Amp ;
    ClaState.Analogs.PhaseCur(3) = ( ClaState.AdcRaw.PhaseCurAdc(3) - 2048 - ClaMailIn.IcOffset ) * ClaControlPars.Bit2Amp ;

 
    % Evaluate conditions for run


    ClaState.CurrentControl.Iq = c.TwoThirds * ...
            (ClaState.Analogs.PhaseCur(1) * ClaState.c + ClaState.Analogs.PhaseCur(2) * ClaState.c120 + ClaState.Analogs.PhaseCur(3) * ClaState.c240) ;
    ClaState.CurrentControl.Id = c.TwoThirds * ...
            (ClaState.Analogs.PhaseCur(1) * ClaState.s + ClaState.Analogs.PhaseCur(2) * ClaState.s120 + ClaState.Analogs.PhaseCur(3) * ClaState.s240) ;

    RunLoadSim();

    if ( ClaState.MotorOn)
        ClaState.CurrentControl.Error_q = ClaState.CurrentControl.CurrentCommandFiltered - ClaState.CurrentControl.Iq ;
        ClaState.CurrentControl.Error_d = - ClaState.CurrentControl.Id;
        ClaState.vqd = ClaState.CurrentControl.vpre_q + ClaState.CurrentControl.Error_q * ClaControlPars.KpCur ;
        ClaState.vdd = ClaState.CurrentControl.vpre_d + ClaState.CurrentControl.Error_d * ClaControlPars.KpCur ;

        % Vfac = Let (Vsat = alpha * Vbus) , then Vsat * TBPRD / Vbus = alpha * Tbprd
        f1 = ClaState.vqd * ClaState.vqd + ClaState.vdd * ClaState.vdd; 
        if ( f1 > ClaState.Vsat * ClaState.Vsat )
            ClaState.SaturationFac4AWU = ClaState.Vsat * meisqrtf32(f1);  
        else
            ClaState.SaturationFac4AWU = 1 ; 
        end 
        ClaState.va = ClaState.PwmFac *ClaState.SaturationFac4AWU  * ( ClaState.q2v1 * ClaState.vqd +  ClaState.d2v1 * ClaState.vdd  ) ;
        ClaState.vb = ClaState.PwmFac *ClaState.SaturationFac4AWU  * ( ClaState.q2v2 * ClaState.vqd +  ClaState.d2v2 * ClaState.vdd  ) ;
        ClaState.vc = -ClaState.vb - ClaState.va ;
    else
    
        ClaState.CurrentControl.CurrentCommandFiltered = 0 ; 
        ClaState.CurrentControl.Error_q = 0 ;
        ClaState.CurrentControl.Error_d = 0 ;
        ClaState.vqd  = 0 ;
        ClaState.vdd = 0 ;
        ClaState.va = 0 ;
        ClaState.vb = 0 ;
        ClaState.vb = 0 ;
        ClaState.SaturationFac4AWU  = 1.0 ;
    end

    vn =  ClaState.PwmOffset + 0.5 * ( max(max(ClaState.va,ClaState.vb),ClaState.vc) + min(min(ClaState.va,ClaState.vb),ClaState.vc))  ;

    fTemp = min (vn-ClaState.va, ClaState.PwmMax ) ;
    EPWM1_O_CMPA =   max (fTemp, ClaState.PwmMin );
    EPWM1_O_CMPB =   max (fTemp, ClaState.PwmMinB );

    fTemp = min (vn-ClaState.vb, ClaState.PwmMax ) ;
    EPWM2_O_CMPA =   max (fTemp, ClaState.PwmMin );
    EPWM2_O_CMPB =   max (fTemp, ClaState.PwmMinB );

    fTemp = min (vn-ClaState.vc, ClaState.PwmMax ) ;
    EPWM3_O_CMPA =   max (fTemp, ClaState.PwmMin );
    EPWM3_O_CMPB =   max (fTemp, ClaState.PwmMinB );



    delta = (ClaState.SaturationFac4AWU - 1.0) *  ClaState.vqd ;
    er    = ClaState.CurrentControl.Error_q + delta * ClaControlPars.KAWUCur ;
    ClaState.CurrentControl.Int_q =  ClaState.CurrentControl.Int_q + ClaControlPars.KiCur * ClaMailIn.Ts * er ;

    delta = (ClaState.SaturationFac4AWU - 1.0) *  ClaState.vdd ;
    er    = ClaState.CurrentControl.Error_d + delta * ClaControlPars.KAWUCur ;
    ClaState.CurrentControl.Int_d =  ClaState.CurrentControl.Int_d + ClaControlPars.KiCur * ClaMailIn.Ts * er ;


end

function y = meinvf32(x)
    if x == 0 
		y =0 ; 
    else
	    y = 1/x ; 
    end
end


function ProcAnalogSamples()
global c ClaControlPars ClaState ClaMailIn ClaSimState
    ClaState.Analogs.Vdc = ClaMailIn.SimVdc ;
end

function y = meisqrtf32(x)
    if ( x <= 0 )
        y = 0 ; 
    else
        y = 1/ sqrt(x) ; 
    end
end 

function ClaSinCos( pu_arg_in )
global c ClaControlPars ClaState ClaMailIn ClaSimState SinTable

    pu_arg = mfracf32(mfracf32(pu_arg_in+1))* 32.0 ;
    pu_ind = fix ( pu_arg ) + 1  ; % Get modulo to the 0-1 range
    pu_arg = mfracf32(pu_arg) ;
    t1 = SinTable(pu_ind) ;
    t2 = SinTable(pu_ind+1) ;
    t3 = SinTable(pu_ind+8) ;
    t4 = SinTable(pu_ind+9) ;

    ClaState.s = (t1 + t3 * pu_arg * c.piOver32 ) * (1-pu_arg) ...
        + (t2 - t4 *( (1 - pu_arg) * c.piOver32) ) * pu_arg ;
    ClaState.c = (t3 - t1 * pu_arg * c.piOver32 ) * (1-pu_arg) ...
        + (t4 + t2 *( (1 - pu_arg) * c.piOver32) ) * pu_arg ;

    ClaState.c120 = -0.5 * ( ClaState.c + ClaState.s * c.sqrt3 ) ;
    ClaState.c240 = -0.5 * ( ClaState.c - ClaState.s * c.sqrt3 ) ;
    ClaState.s120 = -0.5 * ( ClaState.s - ClaState.c * c.sqrt3 ) ;
    ClaState.s240 = -0.5 * ( ClaState.s + ClaState.c * c.sqrt3 ) ;

    ClaState.q2v1 = ClaState.c ;
    ClaState.d2v1 = ClaState.s ;

    ClaState.q2v2 = -0.5 * (c.sqrt3  * ClaState.s + ClaState.c);
    ClaState.d2v2 =  0.5 * (c.sqrt3 *ClaState.c - ClaState.s) ;

%     ClaState.q2v1 = c.TwoThirds * ClaState.c ;
%     ClaState.d2v1 = c.TwoThirds * ClaState.s ;
% 
%     ClaState.q2v2 = -c.OneOver3GoodBehavior * (c.sqrt3  * ClaState.s + ClaState.c);
%     ClaState.d2v2 =  c.OneOver3GoodBehavior * ( c.sqrt3 *ClaState.c - ClaState.s) ;
end



function RunMotorSim()
global c ClaControlPars ClaState ClaMailIn ClaSimState SinTable
global EPWM1_O_CMPA EPWM1_O_CMPB EPWM2_O_CMPA EPWM2_O_CMPB EPWM3_O_CMPA EPWM3_O_CMPB %#ok<*NUSED> 


    pu_arg = mfracf32(mfracf32(ClaSimState.MotorModuloPos*ClaControlPars.nPolePairs+1))* 32.0 ;
    pu_ind = fix ( pu_arg ) + 1  ; % Get modulo to the 0-1 range
    pu_arg = mfracf32(pu_arg) ;
    t1 = SinTable(pu_ind) ;
    t2 = SinTable(pu_ind+1) ;
    t3 = SinTable(pu_ind+8) ;
    t4 = SinTable(pu_ind+9) ;

    ClaSimState.s = (t1 + t3 * pu_arg * c.piOver32 ) * (1-pu_arg) ...
        + (t2 - t4 *( (1 - pu_arg) * c.piOver32) ) * pu_arg ;
    ClaSimState.c = (t3 - t1 * pu_arg * c.piOver32 ) * (1-pu_arg) ...
        + (t4 + t2 *( (1 - pu_arg) * c.piOver32) ) * pu_arg ;

    ClaSimState.c120 = -0.5 * ( ClaSimState.c + ClaSimState.s * c.sqrt3 ) ;
    ClaSimState.c240 = -0.5 * ( ClaSimState.c - ClaSimState.s * c.sqrt3 ) ;
    ClaSimState.s120 = -0.5 * ( ClaSimState.s - ClaSimState.c * c.sqrt3 ) ;
    ClaSimState.s240 = -0.5 * ( ClaSimState.s + ClaSimState.c * c.sqrt3 ) ;


    if ( ClaState.MotorOn)
    % WTF Change
        ClaSimState.va = (ClaState.PwmFrame - 0.5*(EPWM1_O_CMPA + EPWM1_O_CMPB)) * ClaMailIn.SimVdc * ClaState.InvPwmFrame;
        ClaSimState.vb = (ClaState.PwmFrame - 0.5*(EPWM2_O_CMPA + EPWM2_O_CMPB)) * ClaMailIn.SimVdc * ClaState.InvPwmFrame;
        ClaSimState.vc = (ClaState.PwmFrame - 0.5*(EPWM3_O_CMPA + EPWM3_O_CMPB)) * ClaMailIn.SimVdc * ClaState.InvPwmFrame;
    else
        ClaSimState.va = 0 ;
        ClaSimState.vb = 0 ;
        ClaSimState.vc = 0 ;
    end
    ClaSimState.vn = (ClaSimState.va+ClaSimState.vb+ClaSimState.vc) * c.OneOver3GoodBehavior ;
    ClaSimState.vanet = ClaSimState.va - ( ClaSimState.vn + ClaMailIn.SimR * ClaSimState.ia ...
             + ClaSimState.w * ClaMailIn.SimKe * ClaState.c ) ;
    ClaSimState.vbnet = ClaSimState.vb - ( ClaSimState.vn + ClaMailIn.SimR * ClaSimState.ib ...
             + ClaSimState.w * ClaMailIn.SimKe * ClaState.c120 ) ;
    ClaSimState.vcnet = ClaSimState.vc - ( ClaSimState.vn + ClaMailIn.SimR * ClaSimState.ic ...
             + ClaSimState.w * ClaMailIn.SimKe * ClaState.c240 ) ;
    ClaSimState.ia = ClaSimState.ia + ClaSimState.vanet *  ClaMailIn.SimDtOverL ;
    ClaSimState.ib = ClaSimState.ib + ClaSimState.vbnet *  ClaMailIn.SimDtOverL ;
    ClaSimState.ic = ClaSimState.ic + ClaSimState.vcnet *  ClaMailIn.SimDtOverL ;
    fTemp = (ClaSimState.ia+ClaSimState.ib+ClaSimState.ic) * c.OneOver3GoodBehavior ;
    ClaSimState.ia = ClaSimState.ia - fTemp ;
    ClaSimState.ib = ClaSimState.ib - fTemp ;
    ClaSimState.ic = ClaSimState.ic - fTemp ;

    ClaSimState.Iq = c.TwoThirds * ...
            (ClaSimState.ia  * ClaState.c + ClaSimState.ib * ClaState.c120 + ClaSimState.ic * ClaState.c240) ;
    
end
%    ClaSimState.iq = ( ClaSimState.ia * ClaState.c + ClaSimState.ib * ClaState.c120 + ClaSimState.ic * ClaState.c240 ) * c.TwoThirds;
%    ClaSimState.id = ( ClaSimState.ia * ClaState.s + ClaSimState.ib * ClaState.s120 + ClaSimState.ic * ClaState.s240 ) * c.TwoThirds;

function RunLoadSim()
    global c ClaControlPars ClaState ClaMailIn ClaSimState

    ClaSimState.w = ClaSimState.w + ( ClaMailIn.SimKtOverJdT * ClaSimState.Iq - ClaSimState.w * ClaMailIn.SimBOverJdT ) ;
    ClaSimState.MotorPos = ClaSimState.MotorPos + ClaSimState.w * ClaMailIn.SimdT ;
    ClaSimState.MotorModuloPos = mfracf32( ClaSimState.MotorModuloPos + ClaSimState.w * ClaMailIn.SimdT + 2 ) ;
end


function Cla1Task2 (  )
global c ClaControlPars ClaState ClaMailIn ClaSimState



    % Get the analog variables
    ProcAnalogSamples();

    % Check motor readyness
    % CheckMotorReady();

    % ClaCheckMotorOn() ;

    % Get the trigonometric functions for work
    ClaSinCos( ClaMailIn.ThetaElect ) % + 0.25 ) ;

    % Filter the reference
    fTemp = ClaControlPars.MaxCurCmdDdt * ClaMailIn.Ts ;
    ClaState.CurrentControl.CurrentCommandSlopeLimited = ClaState.CurrentControl.CurrentCommandSlopeLimited + ...
            max (min (ClaState.CurrentControl.CurrentCommand - ClaState.CurrentControl.CurrentCommandSlopeLimited ,fTemp) , -fTemp) ;

    ClaState.CurrentControl.CurrentCommandFiltered = ClaState.CurrentControl.CurrentCommandSlopeLimited * ClaControlPars.CurrentRefFiltB ...
            - ClaState.CurrentControl.CurrentCmdFilterState1 * ClaControlPars.CurrentRefFiltA1 ...
            - ClaState.CurrentControl.CurrentCmdFilterState0 * ClaControlPars.CurrentRefFiltA0;

    ClaState.CurrentControl.CurrentCmdFilterState1 = ClaState.CurrentControl.CurrentCmdFilterState0 ;
    ClaState.CurrentControl.CurrentCmdFilterState0 = ClaState.CurrentControl.CurrentCommandFiltered ;

    ClaState.CurrentControl.vpre_q = ClaState.SpeedHz * ClaControlPars.KeHz  + ClaState.CurrentControl.Int_q ;
    ClaState.CurrentControl.vpre_d = ClaState.CurrentControl.Int_d ;

    % Get the voltage to PWM ratios

    ClaState.PwmFac = ClaState.PwmFrame * meinvf32 ( max( ClaState.Analogs.Vdc , 1.0 ) )  ;
    ClaState.Vsat   = ClaState.Analogs.Vdc * ClaControlPars.VectorSatFac ;

end

