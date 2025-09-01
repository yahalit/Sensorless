#ifndef DEVICE_SETUP_H_DEFINED
#define DEVICE_SETUP_H_DEFINED


typedef struct 
{ 
	short unsigned bUseUart;
	long unsigned UartBaudRate ;
	long unsigned CanID[4] ; 
	long unsigned CanIDMask[4]; 
	long unsigned ExtCanID[4]; 
	long unsigned ExtCanIDMask[4]; 
} DeviceSetup_T;

typedef union
{
    DeviceSetup_T items ;
    short unsigned us[40] ;
} UDeviceSetup_T ;

extern UDeviceSetup_T G_DeviceSetup ;

void SetUartParameters(short unsigned useUart , long unsigned baudRate);
void SetCanParameters(const long unsigned CanID[4] , const long unsigned CanIDMask[4] ,const long unsigned ExtCanID[4] , const long unsigned ExtCanIDMask[4] );


#endif
