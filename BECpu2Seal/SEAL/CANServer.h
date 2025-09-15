#ifndef CAN_SERVER_DEFINED
#define CAN_SERVER_DEFINED

void SetObject2Drive(short unsigned Index, short unsigned subIndex, double value, unsigned short dataType, long* RetVal);
void GetObjectFromDrive(short unsigned Index, short unsigned subIndex, unsigned short dataType, double* value, long* RetVal);
void SetObject2DriveNoWait(short unsigned Index, short unsigned subIndex, double value, unsigned short dataType , long TrackingCode , long* RetVal );
void GetAcknowledgeForObject2DriveNoWait(short unsigned* Index, short unsigned* subIndex, unsigned short dataType, long TrackingCode, long* RetVal);
void GetObjectFromDriveNoWait(short unsigned Index, short unsigned subIndex, long TrackingCode, long* RetVal);
void GetResponseForGetObjectFromDrive(short unsigned Index, short unsigned subIndex, short unsigned dataType, long TrackingCode, long* RetVal);



#endif
