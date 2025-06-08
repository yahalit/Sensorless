#include "mex.h"


struct CManOnState
{
    short unsigned PdoAcceptMask ;
    short WellnessStatus ; // Recorded status of manipulator wellness
    short RetryCounter ;
    short FailureCode  ;
    short State ;
};

struct CPackSim
{
    short OldMotMode ;
    short OldNeckMode;
    float OldPosTarget ;
};

struct CManControlWord
{
	int unsigned Automatic  : 1 ; // !< 1 for automatic action , 0 for manual
	int unsigned MotorsOn	: 1 ; // !< Active manipulator motors
	int unsigned Standby	: 1 ; // !< 1: Standby  position
	int unsigned Package	: 1 ; // !< 1: deal Package
	int unsigned PackageGet : 1 ; // !< 1 get package, 0: Put packge
	int unsigned Side		: 2 ; // !< Access side: 0: Straight back (undefined), 1: Left , 2: Right
	int unsigned LaserValid : 1 ; // !< Laser reading is valid
	int unsigned BrakeValid	: 1 ; // !< 1 if later brake control fields are valid
	int unsigned ReleaseWheels : 1 ; // !< 1 to release the wheels ( if BrakeValid )
	int unsigned ReleaseSteer : 1 ; // !< 1 to release the steering ( if BrakeValid )
	int unsigned ReleaseNeck : 1 ; // !< 1 to release the neck ( if BrakeValid )
	int unsigned LaserPsOn : 1 ; // !< Set on the laser PS (Switch 1)
	int unsigned RepeatAction: 1 ; // !< Set if repeated action (e.g. repush package)
	int unsigned Reserved	: 1 ; // !< Reserved
	int unsigned UnProcFromPdo : 1 ; // !< 1: Do not process from PDO
};

// Command word #2
struct CPdCmd2
{
    int unsigned ChakalakaOn : 1 ; // Chakalaka
    int unsigned FanOn : 1 ;
    int unsigned Power24V   : 1 ;
    int unsigned Power12V   : 1 ;
    int unsigned CommRestart : 1 ; // Restart manipulator communication
    int unsigned PowerEnter : 1 ; // <Enter> for Power commands
    int unsigned FrontCamLightOn : 1 ; // Front camera light
    int unsigned RearCamLightOn : 1 ; // Front camera light
};


// Descriptor for self test bits
struct CPdCBit
{
	int unsigned V24Fail : 1 ; //!< Failure of the 24V voltage
	int unsigned V12Fail : 1 ; //!< Failure of the 12V voltage
	int unsigned MushroomDepressed : 1 ; // !< Mushrum is depressed
	int unsigned ShuntFail : 1 ; // !< 1 if shunt fails to stabilize voltages (too hot) 0x8
	int unsigned GripFail : 1 ; // !< 1 if grip of package failed 0x10
	int unsigned ManFail: 3 ; // !< Dynamixel errors: Shoulder , elbow , wrist 0x20,0x40,0x80
    int unsigned StopFail: 2 ; // !< Dynamixel errors:   left . right  0x100 0x200
	int unsigned V54Fail : 1 ; // !< 54V failure 0x400
	int unsigned NoSuck1 : 1 ; // !< No sucking in sucker pump 1 0x800
	int unsigned NoSuck2 : 1 ; // !< No sucking in sucker pump 2 0x1000
	int unsigned Reserved : 3 ; //!< Reserved
};



struct CPdCBit2
{
	int unsigned Active12V : 1 ;
	int unsigned FailCode12V : 3 ;
	int unsigned Active24V : 1 ;
	int unsigned FailCode24V : 3 ;
    int unsigned Active54V : 1 ;
	int unsigned FailCode54V : 3 ;
};


struct CPdCBit3
{
	int unsigned ManSw1 : 1 ;
	int unsigned ManSw2 : 1 ;
	int unsigned StopSw1 : 1 ;
	int unsigned StopSw2 : 1 ;
	int unsigned Dyn12NetOn : 1 ;
	int unsigned Dyn12InitDone : 1 ;
	int unsigned Dyn24NetOn : 1 ;
	int unsigned Dyn24InitDone : 1 ;
	int unsigned Disc2In : 1  ;
	int unsigned MotorOnMan : 3 ;
	int unsigned MotorOnStop : 2 ;
	int unsigned PbitDone : 1 ;
	int unsigned IndividualAxControl : 1 ; // !< Manipulator axes controlled manually and individually
};


struct CPdBitGen
{
	int unsigned SteerBrakeRelease : 1 ;
	int unsigned WheelBrakeRelease : 1 ;
	int unsigned NeckBrakeRelease : 1 ;
	int unsigned ShuntActive : 1 ;
	int unsigned ServoGateDriveOn : 1 ;
	int unsigned LaserPsSwOn : 1 ;
	int unsigned Pump1SwOn : 1 ;
	int unsigned Pump2SwOn : 1 ;
	int unsigned ChakalakaOn : 1 ;
	int unsigned StopBrakeReleased : 1 ;
	int unsigned StopRelaySwOn : 1 ;
	int unsigned FanSwOn : 1  ;
	int unsigned TailLampSwOn : 1 ;
	int unsigned Disc1On : 1 ;
	int unsigned ServoPowerOn : 1 ;
	int unsigned Reserved : 1 ;
};



struct CLpPackage
{
//	short unsigned Active 	   ; //!< Flag: 1 if package handling is active
//	short unsigned LoadInto    ; //!< 1 to load into , 0 to unload
	short State 	   ; //!< Package delivery state
	short unsigned SubState 	   ; //!< Package delivery sub state
	short unsigned iDistanceTo ; //!< Distance to package, 1mm units
	short unsigned LaserDist0p1mm ; // Laser distance in 0.1 mm
	short unsigned ManState ; // !< Report of state from manipulator state machine
	short unsigned Side		; // !< Package side
	short unsigned Get 		; // !< 1 Get , 0 Set
	short unsigned LastFault ; // !< Last fault capture
    short unsigned IsFaultRecoverable ; // !< If there is a fault, 1 if recoverable
    short unsigned PendingException ; // !< Pending exception: allow completing a motion before error applies quickstop
    short unsigned ExceptionType    ; // !< Type of exception
	short unsigned StandbyAction ; // !< Standby action flag
	short Mode; // !< Mode of package action (for emergency handling)
    short ManHolds ; //
    short ManStopErr ; // !< Error that stopped the manipulator
    short Algn ;
    long  unsigned Summary ;
	struct CManControlWord ManControlWord ; // Package handler control word
	struct CPdCBit  ManCBit1 ; // !< Manipulator basic CBIT1
	struct CPdCBit2 ManCBit2 ; // !< Manipulator basic CBIT2
	struct CPdCBit3 ManCBit3 ; // !< Manipulator CBIT 3
	float IncidenceAngle     ; // !< Tail incidence with respect to shelf
	float PackageX ;
	float PackageY ;
	float DebugIncidenceAngle ;
	float XPosition ;
    float YPosition ;
    float ThtPosition ;
    float LeftStopPosition ;
    float RightStopPosition ;

	struct CManOnState ManOnState ;
	struct CPackSim  PackSim ; // Backup for state before neck simulation
	
	struct CPdBitGen PdBitGen ;
    
	short  ComNetState    [2] ;
    short  AxisFailStatus [5] ;

float V24; 
float V12; 
float V36; 
float V54; 
};


struct 
{ 
struct CLpPackage Package; 
} SysState ; 


struct CCanMsg
{
	long data[2] ; 
};



const char *fieldnames[] = 
{
    "ManOnState_PdoAcceptMask",
    "ManOnState_WellnessStatus",
    "ManOnState_RetryCounter",
    "ManOnState_FailureCode",
    "ManOnState_State",
} ; 






/**
 * @brief Process incoming PDO1 from PD
 *
 */

short PdProcessTxPdo1(struct CCanMsg *pMsg)
{
	short unsigned * uPtr ;
	uPtr = (unsigned short *) & pMsg->data[0] ;
	SysState.Package.ManCBit1 = * ( ( struct CPdCBit *) uPtr ) ;
	SysState.Package.ManCBit2 = * ( ( struct CPdCBit2 *) (uPtr+1) ) ;
	SysState.Package.PdBitGen = * ( ( struct CPdBitGen *) (uPtr+2) ) ;
	SysState.Package.ManCBit3 = * ( ( struct CPdCBit3 *) (uPtr+3) ) ;
//	SysState.Package.ManOnState.PdoAcceptMask |= 1 ;
//    SysState.PdRawData[0] = pMsg->data[0];
//    SysState.PdRawData[1] = pMsg->data[1];
	return 0 ;
}



short PdProcessTxPdo2(struct CCanMsg *pMsg)
{
	short unsigned * uPtr ; // ,ubit3 ;
	uPtr = (unsigned short *) & pMsg->data[0] ;
	SysState.Package.ManState = uPtr[0] & 0xff ;
	SysState.Package.ManStopErr = ( uPtr[0] & 0xff00 ) >> 8 ;

//	ubit3 = * (short unsigned *) &SysState.Package.ManCBit3 ;
//	SysState.Package.Summary = uPtr[0] + ((long unsigned)ubit3<<16) ;

	SysState.Package.V24 = ( uPtr[1] & 0xff ) * 0.2f ;
	SysState.Package.V12 = ( ( uPtr[1] >> 8 ) & 0xff ) * 0.1f ;
	SysState.Package.V36 = uPtr[3] * 0.01f ;
	SysState.Package.V54 = uPtr[2] * 0.01f ;
 //   SysState.Package.ManOnState.PdoAcceptMask |= 2 ;

 //   SysState.PdRawData[2] = pMsg->data[0];
 //   SysState.PdRawData[3] = pMsg->data[1];
	return 0 ;
}


/**
 * @brief Process incoming PDO3
 *
 * For all the exes PDO 3 has the same composition:
 * - speed command, act position
 */
short PdProcessTxPdo3(struct CCanMsg *pMsg)
{
    //(void) pMsg ;
    short unsigned s1 ;
    short s2 ;
    s2 = (short)pMsg->data[0] ;
    SysState.Package.XPosition = ((  s2 << 8 ) >> 8 ) *  0.0078125f ;
    SysState.Package.YPosition = ( s2 >> 8 ) *  0.0078125f ;

    SysState.Package.ManHolds =  (short) ( pMsg->data[0] >> 16 ) ;

    s2 = (short) ( pMsg->data[1] & 0xff00 ) ;

    SysState.Package.ThtPosition = s2 * 9.587727708533077e-05f;
    //SysState.Package.ManState = (short) ( pMsg->data[1] & 0xff ) ;

    s1 = (short unsigned) ( pMsg->data[1] >> 16 ) ;
    s2 = s1 & 0xff ;
    if ( s2 >= 128 ) s2 -= 256 ;
    SysState.Package.LeftStopPosition = s2 * 0.02f;
    s2 = s1 >> 8 ;
    if ( s2 >= 128 ) s2 -= 256 ;
    SysState.Package.RightStopPosition = s2 * 0.02f;
//    SysState.Package.ManOnState.PdoAcceptMask |= 4 ;

//    SysState.PdRawData[4] = pMsg->data[0];
//    SysState.PdRawData[5] = pMsg->data[1];

    return 0 ;
}

    
short PdProcessTxPdo3p5(struct CCanMsg *pMsg)
{
    short unsigned us2 ;
    us2 = (unsigned short)pMsg->data[0] ;
    //(void) pMsg ;
        SysState.Package.ComNetState[0] = us2 & 0xf  ;
        SysState.Package.ComNetState[1] = (us2 & 0xf0)>>4  ;

        us2 = (short unsigned) ( pMsg->data[0] >> 16 );
        SysState.Package.AxisFailStatus[0] = us2 & 0xff ;
        SysState.Package.AxisFailStatus[1] = (us2 >> 8 ) & 0xff ;

        us2 = (short unsigned)   pMsg->data[1]  ;
        SysState.Package.AxisFailStatus[2] = us2 & 0xff ;
        SysState.Package.AxisFailStatus[3] = (us2 >> 8 ) & 0xff ;

        us2 = (short unsigned) ( pMsg->data[1] >> 16 );
        SysState.Package.AxisFailStatus[4] = us2 & 0xff ;
        //SysState.PdRawData[6] = pMsg->data[0];
        //SysState.PdRawData[7] = pMsg->data[1];
    return 0 ;
}


#define PdCBit_V24Fail 0
#define PdCBit_V12Fail 1
#define PdCBit_MushroomDepressed 2
#define PdCBit_ShuntFail 3
#define PdCBit_GripFail 4
#define PdCBit_ManFail 5
#define PdCBit_StopFail 6
#define PdCBit_V54Fail 7
#define PdCBit_NoSuck1 8
#define PdCBit_NoSuck2 9
#define PdCBit_Reserved 10


char *PdCBitNames[] = { 
	"PdCBit_V24Fail",
	"PdCBit_V12Fail",
	"PdCBit_MushroomDepressed",
	"PdCBit_ShuntFail",
	"PdCBit_GripFail",
	"PdCBit_ManFail",
    "PdCBit_StopFail",
	"PdCBit_V54Fail",
	"PdCBit_NoSuck1",
	"PdCBit_NoSuck2",
	"PdCBit_Reserved"
};


#define PdCBit2_Active12V 0
#define PdCBit2_FailCode12V 1
#define PdCBit2_Active24V 2
#define PdCBit2_FailCode24V 3
#define PdCBit2_Active54V 4
#define PdCBit2_FailCode54V 5


char *PdCBit2Names[] = { 
	"PdCBit2_Active12V",
	"PdCBit2_FailCode12V",
	"PdCBit2_Active24V",
	"PdCBit2_FailCode24V",
    "PdCBit2_Active54V",
	"PdCBit2_FailCode54V" 
} ; 

#define PdCBit3_ManSw1 0
#define PdCBit3_ManSw2 1
#define PdCBit3_StopSw1 2
#define PdCBit3_StopSw2 3
#define PdCBit3_Dyn12NetOn 4
#define PdCBit3_Dyn12InitDone 5
#define PdCBit3_Dyn24NetOn 6
#define PdCBit3_Dyn24InitDone 7 
#define PdCBit3_Disc2In 8 
#define PdCBit3_MotorOnMan 9
#define PdCBit3_MotorOnStop 10 
#define PdCBit3_PbitDone 11
#define PdCBit3_IndividualAxControl 12

char *PdCBit3Names[] = { 
	"PdCBit3_ManSw1",
	"PdCBit3_ManSw2",
	"PdCBit3_StopSw1",
	"PdCBit3_StopSw2",
	"PdCBit3_Dyn12NetOn",
	"PdCBit3_Dyn12InitDone",
	"PdCBit3_Dyn24NetOn",
	"PdCBit3_Dyn24InitDone",
	"PdCBit3_Disc2In",
	"PdCBit3_MotorOnMan",
	"PdCBit3_MotorOnStop",
	"PdCBit3_PbitDone",
	"PdCBit3_IndividualAxControl"
} ; 

#define PdBitGen_SteerBrakeRelease 0
#define PdBitGen_WheelBrakeRelease 1
#define PdBitGen_NeckBrakeRelease 2
#define PdBitGen_ShuntActive 3
#define PdBitGen_ServoGateDriveOn 4
#define PdBitGen_LaserPsSwOn 5
#define PdBitGen_Pump1SwOn 6
#define PdBitGen_Pump2SwOn 7
#define PdBitGen_ChakalakaOn 8
#define PdBitGen_StopBrakeReleased 9
#define PdBitGen_StopRelaySwOn 10
#define PdBitGen_FanSwOn 11
#define PdBitGen_TailLampSwOn 12
#define PdBitGen_Disc1On 13
#define PdBitGen_ServoPowerOn 14
#define PdBitGen_Reserved 15

char *PdBitGenNames[] = { 
	"PdBitGen_SteerBrakeRelease",
	"PdBitGen_WheelBrakeRelease",
	"PdBitGen_NeckBrakeRelease",
	"PdBitGen_ShuntActive",
	"PdBitGen_ServoGateDriveOn",
	"PdBitGen_LaserPsSwOn",
	"PdBitGen_Pump1SwOn",
	"PdBitGen_Pump2SwOn",
	"PdBitGen_ChakalakaOn",
	"PdBitGen_StopBrakeReleased",
	"PdBitGen_StopRelaySwOn",
	"PdBitGen_FanSwOn",
	"PdBitGen_TailLampSwOn",
	"PdBitGen_Disc1On",
	"PdBitGen_ServoPowerOn",
	"PdBitGen_Reserved"
}; 


#define ManControlWord_Automatic 0
#define ManControlWord_MotorsOn 1
#define ManControlWord_Standby 2
#define ManControlWord_Package 3
#define ManControlWord_PackageGet 4
#define ManControlWord_Side 5
#define ManControlWord_LaserValid 6
#define ManControlWord_BrakeValid 7
#define ManControlWord_ReleaseWheels 8
#define ManControlWord_ReleaseSteer 9
#define ManControlWord_ReleaseNeck 10
#define ManControlWord_LaserPsOn 11
#define ManControlWord_RepeatAction 12
#define ManControlWord_Reserved 13
#define ManControlWord_UnProcFromPdo 14

char *ManControlWordNames[] = 
{ 
	"ManControlWord_Automatic",
	"ManControlWord_MotorsOn",
	"ManControlWord_Standby",
	"ManControlWord_Package",
	"ManControlWord_PackageGet",
	"ManControlWord_Side",
	"ManControlWord_LaserValid",
	"ManControlWord_BrakeValid",
	"ManControlWord_ReleaseWheels",
	"ManControlWord_ReleaseSteer",
	"ManControlWord_ReleaseNeck",
	"ManControlWord_LaserPsOn",
	"ManControlWord_RepeatAction",
	"ManControlWord_Reserved",
	"ManControlWord_UnProcFromPdo" 
} ;


#define Package_V24 0 
#define Package_V12	1
#define Package_V36 2
#define Package_V54 3 
#define Package_ManState 4
#define Package_ManStopErr 5 
#define Package_XPosition 6 
#define Package_YPosition 7 
#define Package_ManHolds 8
#define Package_ThtPosition 9 
#define Package_LeftStopPosition 10 
#define Package_RightStopPosition 11
#define Package_PendingException 12
#define Package_ManOnState_FailureCode 13
#define Package_State 14 
#define Package_NextState 15 
#define Package_TimeSec  16 
#define Package_AxisFailStatusD1 17 
#define Package_AxisFailStatusD2 18 
#define Package_AxisFailStatusSH 19 
#define Package_AxisFailStatusEL 20 
#define Package_AxisFailStatusWR 21 




char *PackageNames[] = { 
"Package_V24",
"Package_V12",
"Package_V36",
"Package_V54",
"Package_ManState",
"Package_ManStopErr",
"Package_XPosition",
"Package_YPosition",
"Package_ManHolds",
"Package_ThtPosition",
"Package_LeftStopPosition",
"Package_RightStopPosition",
"Package_PendingException",
"Package_ManOnState_FailureCode",
"Package_State",
"Package_NextState",
"Package_TimeSec",
"Package_AxisFailStatusD1",
"Package_AxisFailStatusD2",
"Package_AxisFailStatusSH",
"Package_AxisFailStatusEL",
"Package_AxisFailStatusWR"
} ;


void   mxSetFieldByNumberKuku(mxArray *pm, mwIndex index, int fieldnumber, double x )
{
 mxArray *pvalue = mxCreateDoubleMatrix(1, 1, mxREAL); 	
 mxGetPr(pvalue)[0] = x ;  
 mxSetFieldByNumber(pm, index, fieldnumber, pvalue ); 
}

char * structnames[] = 
{ 
	"ManControlWord", "PdCBit","PdCBit2","PdCBit3","PdBitGen","Pacgake"
} ; 


mxArray *MakePDRecord(long *msg) 
{ 
	mxArray *pX[10]; 
	long unsigned lu ;
	short unsigned su , NextState  , PackState , tmsec  ;
	
	PdProcessTxPdo1( (struct CCanMsg *) msg ); 
	PdProcessTxPdo2( (struct CCanMsg *) (msg+2) ); 
	PdProcessTxPdo3( (struct CCanMsg *) (msg+4) ); 
	PdProcessTxPdo3p5( (struct CCanMsg *) (msg+6) ); 
	
	lu = * (( unsigned long *) (msg+8));  
	su = (short unsigned)(lu >> 16) ; 
	
    SysState.Package.PendingException = lu & 0xffff ;
    SysState.Package.ManControlWord   = * ((struct CManControlWord *) & su ) ; 
	
	lu = * (( unsigned long *) (msg+9));  
	SysState.Package.ManOnState.FailureCode = (short)( lu & 0x3fff) ; 
	PackState = ( lu >> 18 ) & 15  ;
	NextState = (lu >> 14 ) & 15 ;
	tmsec     = (lu >> 22) & 0x3ff;

	
	pX[0] = mxCreateStructMatrix(1,1,ManControlWord_UnProcFromPdo+1,ManControlWordNames);
    mxSetFieldByNumberKuku(pX[0],0,ManControlWord_Automatic, (double) SysState.Package.ManControlWord.Automatic );
    mxSetFieldByNumberKuku(pX[0],0,ManControlWord_MotorsOn, (double) SysState.Package.ManControlWord.MotorsOn );
    mxSetFieldByNumberKuku(pX[0],0,ManControlWord_Standby, (double) SysState.Package.ManControlWord.Standby );
    mxSetFieldByNumberKuku(pX[0],0,ManControlWord_Package, (double) SysState.Package.ManControlWord.Package );
    mxSetFieldByNumberKuku(pX[0],0,ManControlWord_PackageGet, (double) SysState.Package.ManControlWord.PackageGet );
    mxSetFieldByNumberKuku(pX[0],0,ManControlWord_Side, (double) SysState.Package.ManControlWord.Side );
    mxSetFieldByNumberKuku(pX[0],0,ManControlWord_LaserValid, (double) SysState.Package.ManControlWord.LaserValid );
    mxSetFieldByNumberKuku(pX[0],0,ManControlWord_BrakeValid, (double) SysState.Package.ManControlWord.BrakeValid );
    mxSetFieldByNumberKuku(pX[0],0,ManControlWord_ReleaseWheels, (double) SysState.Package.ManControlWord.ReleaseWheels );
    mxSetFieldByNumberKuku(pX[0],0,ManControlWord_ReleaseSteer, (double) SysState.Package.ManControlWord.ReleaseSteer );
    mxSetFieldByNumberKuku(pX[0],0,ManControlWord_ReleaseNeck, (double) SysState.Package.ManControlWord.ReleaseNeck );
    mxSetFieldByNumberKuku(pX[0],0,ManControlWord_LaserPsOn, (double) SysState.Package.ManControlWord.LaserPsOn );
    mxSetFieldByNumberKuku(pX[0],0,ManControlWord_RepeatAction, (double) SysState.Package.ManControlWord.RepeatAction );
    mxSetFieldByNumberKuku(pX[0],0,ManControlWord_Reserved, (double) SysState.Package.ManControlWord.Reserved );
    mxSetFieldByNumberKuku(pX[0],0,ManControlWord_UnProcFromPdo, (double) SysState.Package.ManControlWord.UnProcFromPdo );


	pX[1] = mxCreateStructMatrix(1,1,PdCBit_Reserved+1,PdCBitNames);

    mxSetFieldByNumberKuku(pX[1],0,PdCBit_V24Fail, (double) SysState.Package.ManCBit1.V24Fail );
    mxSetFieldByNumberKuku(pX[1],0,PdCBit_V12Fail, (double) SysState.Package.ManCBit1.V12Fail );
    mxSetFieldByNumberKuku(pX[1],0,PdCBit_MushroomDepressed, (double) SysState.Package.ManCBit1.MushroomDepressed );
    mxSetFieldByNumberKuku(pX[1],0,PdCBit_ShuntFail, (double) SysState.Package.ManCBit1.ShuntFail );
    mxSetFieldByNumberKuku(pX[1],0,PdCBit_GripFail, (double) SysState.Package.ManCBit1.GripFail );
    mxSetFieldByNumberKuku(pX[1],0,PdCBit_ManFail, (double) SysState.Package.ManCBit1.ManFail );
    mxSetFieldByNumberKuku(pX[1],0,PdCBit_StopFail, (double) SysState.Package.ManCBit1.StopFail );
    mxSetFieldByNumberKuku(pX[1],0,PdCBit_V54Fail, (double) SysState.Package.ManCBit1.V54Fail );
    mxSetFieldByNumberKuku(pX[1],0,PdCBit_NoSuck1, (double) SysState.Package.ManCBit1.NoSuck1 );
    mxSetFieldByNumberKuku(pX[1],0,PdCBit_NoSuck2, (double) SysState.Package.ManCBit1.NoSuck2 );
    mxSetFieldByNumberKuku(pX[1],0,PdCBit_Reserved, (double) SysState.Package.ManCBit1.Reserved );


	pX[2] = mxCreateStructMatrix(1,1,PdCBit2_FailCode54V+1,PdCBit2Names);
    mxSetFieldByNumberKuku(pX[2],0,PdCBit2_Active12V, (double) SysState.Package.ManCBit2.Active12V );	
    mxSetFieldByNumberKuku(pX[2],0,PdCBit2_FailCode12V, (double) SysState.Package.ManCBit2.FailCode12V );
    mxSetFieldByNumberKuku(pX[2],0,PdCBit2_Active24V, (double) SysState.Package.ManCBit2.Active24V );
    mxSetFieldByNumberKuku(pX[2],0,PdCBit2_FailCode24V, (double) SysState.Package.ManCBit2.FailCode24V );
    mxSetFieldByNumberKuku(pX[2],0,PdCBit2_Active54V, (double) SysState.Package.ManCBit2.Active54V );
    mxSetFieldByNumberKuku(pX[2],0,PdCBit2_FailCode54V, (double) SysState.Package.ManCBit2.FailCode54V );

	pX[3] = mxCreateStructMatrix(1,1,PdCBit3_IndividualAxControl+1,PdCBit3Names);
    mxSetFieldByNumberKuku(pX[3],0,PdCBit3_ManSw1, (double) SysState.Package.ManCBit3.ManSw1 );	
    mxSetFieldByNumberKuku(pX[3],0,PdCBit3_ManSw2, (double) SysState.Package.ManCBit3.ManSw2 );	
    mxSetFieldByNumberKuku(pX[3],0,PdCBit3_StopSw1, (double) SysState.Package.ManCBit3.StopSw1 );	
    mxSetFieldByNumberKuku(pX[3],0,PdCBit3_StopSw2, (double) SysState.Package.ManCBit3.StopSw2 );	
    mxSetFieldByNumberKuku(pX[3],0,PdCBit3_Dyn12NetOn, (double) SysState.Package.ManCBit3.Dyn12NetOn );	
    mxSetFieldByNumberKuku(pX[3],0,PdCBit3_Dyn12InitDone, (double) SysState.Package.ManCBit3.Dyn12InitDone );	
    mxSetFieldByNumberKuku(pX[3],0,PdCBit3_Dyn24NetOn, (double) SysState.Package.ManCBit3.Dyn24NetOn );	
    mxSetFieldByNumberKuku(pX[3],0,PdCBit3_Dyn24InitDone, (double) SysState.Package.ManCBit3.Dyn24InitDone );	
    mxSetFieldByNumberKuku(pX[3],0,PdCBit3_Disc2In, (double) SysState.Package.ManCBit3.Disc2In );		
    mxSetFieldByNumberKuku(pX[3],0,PdCBit3_MotorOnMan, (double) SysState.Package.ManCBit3.MotorOnMan );	
    mxSetFieldByNumberKuku(pX[3],0,PdCBit3_MotorOnStop, (double) SysState.Package.ManCBit3.MotorOnStop );	
    mxSetFieldByNumberKuku(pX[3],0,PdCBit3_PbitDone, (double) SysState.Package.ManCBit3.PbitDone );	
    mxSetFieldByNumberKuku(pX[3],0,PdCBit3_IndividualAxControl, (double) SysState.Package.ManCBit3.IndividualAxControl );	


	pX[4] = mxCreateStructMatrix(1,1,PdBitGen_Reserved+1,PdBitGenNames);
    mxSetFieldByNumberKuku(pX[4],0,PdBitGen_SteerBrakeRelease, (double) SysState.Package.PdBitGen.SteerBrakeRelease );	
    mxSetFieldByNumberKuku(pX[4],0,PdBitGen_WheelBrakeRelease, (double) SysState.Package.PdBitGen.WheelBrakeRelease );	
    mxSetFieldByNumberKuku(pX[4],0,PdBitGen_NeckBrakeRelease, (double) SysState.Package.PdBitGen.NeckBrakeRelease );	
    mxSetFieldByNumberKuku(pX[4],0,PdBitGen_ShuntActive, (double) SysState.Package.PdBitGen.ShuntActive );	
    mxSetFieldByNumberKuku(pX[4],0,PdBitGen_ServoGateDriveOn, (double) SysState.Package.PdBitGen.ServoGateDriveOn );	
    mxSetFieldByNumberKuku(pX[4],0,PdBitGen_LaserPsSwOn, (double) SysState.Package.PdBitGen.LaserPsSwOn );	
    mxSetFieldByNumberKuku(pX[4],0,PdBitGen_Pump1SwOn, (double) SysState.Package.PdBitGen.Pump1SwOn );	
    mxSetFieldByNumberKuku(pX[4],0,PdBitGen_Pump2SwOn, (double) SysState.Package.PdBitGen.Pump2SwOn );	
    mxSetFieldByNumberKuku(pX[4],0,PdBitGen_ChakalakaOn, (double) SysState.Package.PdBitGen.ChakalakaOn );	
    mxSetFieldByNumberKuku(pX[4],0,PdBitGen_StopBrakeReleased, (double) SysState.Package.PdBitGen.StopBrakeReleased );	
    mxSetFieldByNumberKuku(pX[4],0,PdBitGen_StopRelaySwOn, (double) SysState.Package.PdBitGen.StopRelaySwOn );	
    mxSetFieldByNumberKuku(pX[4],0,PdBitGen_FanSwOn, (double) SysState.Package.PdBitGen.FanSwOn );	
    mxSetFieldByNumberKuku(pX[4],0,PdBitGen_TailLampSwOn, (double) SysState.Package.PdBitGen.TailLampSwOn );	
    mxSetFieldByNumberKuku(pX[4],0,PdBitGen_Disc1On, (double) SysState.Package.PdBitGen.Disc1On );	
    mxSetFieldByNumberKuku(pX[4],0,PdBitGen_ServoPowerOn, (double) SysState.Package.PdBitGen.ServoPowerOn );	
    mxSetFieldByNumberKuku(pX[4],0,PdBitGen_Reserved, (double) SysState.Package.PdBitGen.Reserved );	

	pX[5] = mxCreateStructMatrix(1,1, Package_AxisFailStatusWR +1,PackageNames);
    mxSetFieldByNumberKuku(pX[5],0,Package_V24, (double) SysState.Package.V24 );	
    mxSetFieldByNumberKuku(pX[5],0,Package_V12, (double) SysState.Package.V12 );	
    mxSetFieldByNumberKuku(pX[5],0,Package_V36, (double) SysState.Package.V36 );	
    mxSetFieldByNumberKuku(pX[5],0,Package_V54, (double) SysState.Package.V54 );	
    mxSetFieldByNumberKuku(pX[5],0,Package_ManState, (double) SysState.Package.ManState );	
    mxSetFieldByNumberKuku(pX[5],0,Package_ManStopErr, (double) SysState.Package.ManStopErr );	
    mxSetFieldByNumberKuku(pX[5],0,Package_XPosition, (double) SysState.Package.XPosition );	
    mxSetFieldByNumberKuku(pX[5],0,Package_YPosition, (double) SysState.Package.YPosition );	
    mxSetFieldByNumberKuku(pX[5],0,Package_ManHolds, (double) SysState.Package.ManHolds );	
    mxSetFieldByNumberKuku(pX[5],0,Package_ThtPosition, (double) SysState.Package.ThtPosition );	
    mxSetFieldByNumberKuku(pX[5],0,Package_LeftStopPosition, (double) SysState.Package.LeftStopPosition );	
    mxSetFieldByNumberKuku(pX[5],0,Package_RightStopPosition, (double) SysState.Package.RightStopPosition );	
    mxSetFieldByNumberKuku(pX[5],0,Package_PendingException, (double) SysState.Package.PendingException );	
    mxSetFieldByNumberKuku(pX[5],0,Package_ManOnState_FailureCode, (double) SysState.Package.ManOnState.FailureCode  );	
    mxSetFieldByNumberKuku(pX[5],0,Package_State, (double) PackState  );	
	mxSetFieldByNumberKuku(pX[5],0,Package_NextState, (double)NextState);
	mxSetFieldByNumberKuku(pX[5],0,Package_TimeSec, (double)tmsec);
    
	mxSetFieldByNumberKuku(pX[5],0,Package_AxisFailStatusD1, (double)SysState.Package.AxisFailStatus[0]);
	mxSetFieldByNumberKuku(pX[5],0,Package_AxisFailStatusD2, (double)SysState.Package.AxisFailStatus[1]);
	mxSetFieldByNumberKuku(pX[5],0,Package_AxisFailStatusSH, (double)SysState.Package.AxisFailStatus[2]);
	mxSetFieldByNumberKuku(pX[5],0,Package_AxisFailStatusEL, (double)SysState.Package.AxisFailStatus[3]);
	mxSetFieldByNumberKuku(pX[5],0,Package_AxisFailStatusWR, (double)SysState.Package.AxisFailStatus[4]);

  
	pX[6] = mxCreateStructMatrix(1,1,6,structnames);
	mxSetFieldByNumber(pX[6], 0, 0, pX[0]);
	mxSetFieldByNumber(pX[6], 0, 1, pX[1]);
	mxSetFieldByNumber(pX[6], 0, 2, pX[2]);
	mxSetFieldByNumber(pX[6], 0, 3, pX[3]);
	mxSetFieldByNumber(pX[6], 0, 4, pX[4]);
	mxSetFieldByNumber(pX[6], 0, 5, pX[5]);

	return pX[6];
} 
                 
union { 
long unsigned ul[2] ; 
__int64 ll; 
} kuku64 ; 
long unsigned msg[8] ; 

void mexFunction(int nlhs, mxArray *plhs[], 
				 int nrhs, const mxArray *prhs[])
{ 
int cnt ; 
if ( nrhs != 1 ) 
{
	mexErrMsgTxt("Required 1 arguments\n");	
}
if ( mxGetM( prhs[0] ) * mxGetN( prhs[0] ) != 10 ) 
{ 
	mexErrMsgTxt("Required 10 vector argument\n");	
}

for ( cnt = 0 ; cnt < 8 ; cnt++) 
{ 
	kuku64.ll = (__int64) mxGetPr( prhs[0])[cnt] ; 
	msg[cnt] = kuku64.ul[0] ; 
} 

plhs[0] = MakePDRecord(msg);


} 
