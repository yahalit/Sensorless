    E_LC_Voltage_Mode = 0 ; %#ok<*NASGU> 
    E_LC_OpenLoopField_Mode = 1 ;
    E_LC_Torque_Mode = 2 ;
    E_LC_Speed_Mode = 3 ;
    E_LC_Pos_Mode = 4 ;
    E_LC_Dual_Pos_Mode = 5 ;
    E_LC_Dont_Change_Mode = 7;

    E_SysMotionModeNothing = 1 ;
    E_SysMotionModeManual = 2 ;
    E_SysMotionModeAutomatic  = 3 ;
    E_SysMotionModeFault       = -1;
    E_SysMotionModeSafeFault = -2;


    E_S_Nothing = 0 ;
    E_S_Fixed   = 1 ; 
    E_S_Sine    = 2 ; 
    E_S_Square  = 3 ; 
    E_S_Triangle = 4 ; 

    E_PosModeNothing = 0 ; 
    E_PosModeDebugGen = 1 ; 
    E_PosModeStayInPlace = 2 ;
    E_PosModePTP = 3 ; 
    E_PosModePT = 4 ; 

    HALL_BAD_VALUE = -1; 

    COM_OPEN_LOOP = 0 ;
    COM_HALLS_ONLY = 1 ;
    COM_ENCODER = 2 ;
    COM_ENCODER_RESET= 3 ; 


    CPU_CLK_MHZ = 120; 
    QEPSTS_CDEF_MASK = 4 ;

    CUR_SAMPLE_TIME_USEC = 50;

    MAX_TICKS_FOR_ZERO_SPEED = (5000) ; 
    MIN_TICKS_FOR_SPEED = (CUR_SAMPLE_TIME_USEC  / 5 ) ; 

    Log2OfE = 1.442695040888963 ; 

SEC_2_USEC = 1e6 ; 
USEC_2_SEC = 1e-6 ; 

