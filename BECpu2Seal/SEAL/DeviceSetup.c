#include "DeviceSetup.h"

UDeviceSetup_T G_DeviceSetup ;
#pragma DATA_SECTION(G_DeviceSetup,"DeviceSetup");

void SetUartParameters(short unsigned bUseUart , long unsigned UartBaudRate)
{
	G_DeviceSetup.items.bUseUart = bUseUart  ;
	G_DeviceSetup.items.UartBaudRate = UartBaudRate;
}

void SetCanParameters(const long unsigned CanID[4] , const long unsigned CanIDMask[4] ,const long unsigned ExtCanID[4] , const long unsigned ExtCanIDMask[4] )
{
	short unsigned cnt ; 
	for ( cnt = 0 ; cnt < 4 ; cnt++ ) 
	{ 
		G_DeviceSetup.items.CanID[cnt] = CanID[cnt];
		G_DeviceSetup.items.CanIDMask[cnt] = CanIDMask[cnt];
		G_DeviceSetup.items.ExtCanID[cnt] = ExtCanID[cnt];
		G_DeviceSetup.items.ExtCanIDMask[cnt] = ExtCanIDMask[cnt];
	} 
}
