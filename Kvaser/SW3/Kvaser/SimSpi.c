#include "mex.h"
#include <math.h>
#include <stdio.h> 
#include <stdlib.h> 


/**
Build a SPI message by a Matlab struct 
Must accept a struct 
as: 
Preamble 
TxCntr 
RflctCnt 
MsgOpCode 
TimeTag 

Also mission dependent: 
qIndex
EntryIndex
Mode
*/

#define SPI_MSG_LEN 31	// Length of message over the SPI lines
#define SPI_PREAMBLE_LEN 5
#define SPI_BODY_LEN (SPI_MSG_LEN-SPI_PREAMBLE_LEN-1) 
mwSize dims[] = {1, SPI_MSG_LEN*2};
mxChar * dataptr ;

/*
struct CSpiMessageStr
{
	unsigned long  Preamble ; // Including the RPB message ID , for long alignment
	unsigned short Opcode;
	unsigned short  TimeTag_L;
	unsigned short  TimeTag_H;
	short unsigned msgBody[SPI_BODY_LEN];
	short unsigned Checksum ;
};
struct CSpiMessageStr SpiMessageStr ; 
*/


short unsigned SpiMessageStr[SPI_MSG_LEN] ; 

double dbody[SPI_BODY_LEN] ; 



short GetFromStr( const mxArray *pMat , char * fname , double *dval ) 
{
	mxArray *pF ; 
	pF = (mxArray *)mxGetField( pMat , 0 , fname ) ;  
	if ( pF == NULL ) 
	{ 
		return -1 ; 
	} 
	*dval = mxGetPr(pF)[0] ; 
	return 0 ; 
}

/**
* \brief : Get the number of items in a matrix 
*
* \return : Number of items or -1 if ilegal (empty, not double, dim >= 3)   
*/
int unsigned GetNumLen (const mxArray *px) 
{ 
	if ( mxIsDouble(px) == 0) 
	{
		return -1; 
	}
	if ( mxGetNumberOfDimensions(px) > 2 ) 
	{ 
		return -1; 
	} 
	return (int) (mxGetM(px) * mxGetN(px)) ;  
}

 
short GetVecFromStr( const mxArray *pMat , char * fname , short unsigned len , double *dval ) 
{
	mxArray *pF ; 
	int unsigned cnt ; 
	pF = (mxArray *)mxGetField( pMat , 0 , fname ) ;  
	if ( pF == NULL ) 
	{ 
		return -1 ; 
	} 
	if ( len != GetNumLen(pF) ) 
	{ 
		return -1 ; 
	} 
	for ( cnt = 0 ; cnt < len ; cnt++ ) 
	{ 
		dval[cnt] = mxGetPr(pF)[cnt] ; 
	} 
	return 0 ; 
}


short unsigned UsGetFromStr( const mxArray *pMat , char * fname , char * errmsg ) 
{
	mxArray *pF ; 
	pF = (mxArray *)mxGetField( pMat , 0 , fname ) ;  
	if ( pF == NULL ) 
	{ 
		mexErrMsgTxt(errmsg)  ; 
	} 
	return (short unsigned) mxGetPr(pF)[0] ; 
}

long unsigned UlGetFromStr( const mxArray *pMat , char * fname , char * errmsg ) 
{
	mxArray *pF ; 
	pF = (mxArray *)mxGetField( pMat , 0 , fname ) ;  
	if ( pF == NULL ) 
	{ 
		mexErrMsgTxt(errmsg)  ; 
	} 
	return (long unsigned) mxGetPr(pF)[0] ; 
}



void mexFunction(int nlhs, mxArray *plhs[], 
				 int nrhs, const mxArray *prhs[])
{ 

short unsigned *uPtr  ;
short unsigned *pMsg  ;
char unsigned * cPtr ; 
short unsigned TxCntr , RflctCnt ;
short unsigned qIndex ; 
short unsigned cnt , Preamble , cs , MsgOpCode  , SetOpCode ; 
long unsigned TimeTag ;
long unsigned TT ; 
double dval ; 
double X[3] ,DMsg[8] ; 
mxArray * pArg ; 


	// Clear entire message body 
	uPtr = (short unsigned *) &SpiMessageStr ; 
	pMsg = uPtr + SPI_PREAMBLE_LEN ; 

	for ( cnt = 0 ; cnt < SPI_MSG_LEN ; cnt++ ) 
	{
		uPtr[cnt] = 0 ; 
	}

	if ( nrhs < 1 || (0==mxIsStruct(prhs[0])) ) 
	{ 			
		mexErrMsgTxt("First parameter should be struct\n");
	} 

	if  ( GetFromStr( prhs[0] , "Preamble" , &dval ) ) 
	{ 
		Preamble = 0xAC13 ; 
	} 
	else
	{ 
		Preamble = (short unsigned) dval ;  
	} 
	TxCntr   = UsGetFromStr(prhs[0] , "TxCntr", "TxCntr field is missing in argument" )   ;
	RflctCnt = UsGetFromStr(prhs[0] , "RflctCnt", "RflctCnt field is missing in argument" )   ;
	TT = UlGetFromStr(prhs[0] , "TimeTag", "TimeTag field is missing in argument" )   ;
	MsgOpCode = UsGetFromStr(prhs[0] , "MsgOpCode", "MsgOpCode field is missing in argument" )   ;

	uPtr[0] = Preamble ; 
	uPtr[1] = ( TxCntr & 0xff ) + ( ( RflctCnt << 8 ) & 0xff00 ) ; 
	uPtr[3] = (short unsigned) (TT & 0xffff) ; 
	uPtr[4] = (short unsigned) ((TT>>16) & 0xffff ); 
	uPtr[2] = MsgOpCode ;

	switch ( MsgOpCode ) 
	{ 
	default: // Null command or default 
		if ( GetVecFromStr( prhs[0] , "Body" , SPI_BODY_LEN , dbody )  < 0 )
		{ 
			for ( cnt = 0 ; cnt < SPI_BODY_LEN ; cnt++ ) dbody[cnt] = 0 ; 
		} 
		for ( cnt = 0 ; cnt < SPI_BODY_LEN ; cnt++ )
		{ 
			pMsg[cnt] = (short unsigned) dbody[cnt]  ; 
		} 
		break ; 

	case 1: // Clear queue
		pMsg[0] = UsGetFromStr(prhs[0] , "qIndex", "qIndex field is missing in argument" )   ;
		break ; 

	case 2: // Set queue entry 
		pMsg[0] = UsGetFromStr(prhs[0] , "qIndex", "qIndex field is missing in argument" )   ;
		pMsg[1] = UsGetFromStr(prhs[0] , "EntryIndex", "EntryIndex field is missing in argument" )   ;
		pMsg[2] = UsGetFromStr(prhs[0] , "qOpCode", "qOpCode field is missing in argument" )   ;
		SetOpCode = pMsg[2] ; 
		pMsg+= 3 ; 

		switch ( SetOpCode )
		{ 
		default: 
			break ; 
		case 1: // Set path point 
			if ( GetVecFromStr( prhs[0] , "Pos" , 3 , X )  < 0 )
			{ 
				mexErrMsgTxt("Missing or incorrectly dimensioned Pos in struct\n");
			} 
			TT = (long) X[0] ; 
			pMsg[0] = (short unsigned) (TT & 0xffff) ; 
			pMsg[1] = (short unsigned) ((TT>>16) & 0xffff ); 
			TT = (long) X[1] ; 
			pMsg[2] = (short unsigned) (TT & 0xffff) ; 
			pMsg[3] = (short unsigned) ((TT>>16) & 0xffff ); 
			TT = (long) X[2] ; 
			pMsg[4] = (short unsigned) (TT & 0xffff) ; 
			pMsg[5] = (short unsigned) ((TT>>16) & 0xffff ); 
			pMsg[6] = UsGetFromStr(prhs[0] , "CosX", "CosX field is missing in argument" )   ;
			pMsg[7] = UsGetFromStr(prhs[0] , "CosY", "CosY field is missing in argument" )   ;
			pMsg[8] = UsGetFromStr(prhs[0] , "CosZ", "CosZ field is missing in argument" )   ;
			break ; 
		case 2: // Wait 
			TT = UlGetFromStr(prhs[0] , "WaitTimeMs", "WaitTimeMs field is missing in argument" )   ;
			pMsg[0] = (short unsigned) (TT & 0xffff) ; 
			pMsg[1] = (short unsigned) ((TT>>16) & 0xffff ); 
			break ; 
		case 3: // Change mode 
			pMsg[0] = UsGetFromStr(prhs[0] , "BodyAngle", "BodyAngle field is missing in argument" )   ;
			pMsg[1] = UsGetFromStr(prhs[0] , "RotJunction", "RotJunction field is missing in argument" )   ;
			pMsg[2] = UsGetFromStr(prhs[0] , "Climb", "Climb field is missing in argument" )   ;
			break ; 
		case 4: // Handle package 
			pMsg[0] = UsGetFromStr(prhs[0] , "LoadFlag", "LoadFlag field is missing in argument" )   ;
			pMsg[1] = UsGetFromStr(prhs[0] , "PackTilt", "PackTilt field is missing in argument" )   ;
			break ; 
		} 

		break ; 

	case 3: // Set execution pointer 
		pMsg[0] = UsGetFromStr(prhs[0] , "qIndex", "qIndex field is missing in argument" )   ;
		pMsg[1] = UsGetFromStr(prhs[0] , "EntryIndex", "EntryIndex field is missing in argument" )   ;
		pMsg[2] = UsGetFromStr(prhs[0] , "Mode", "Mode field is missing in argument" )   ;
		break ;

	case 10: // Deviation report 
		pMsg[0] = UsGetFromStr(prhs[0] , "DevOffset", "DevOffset field is missing in argument" )   ;
		pMsg[1] = UsGetFromStr(prhs[0] , "DevAzimuth", "DevAzimuth field is missing in argument" )   ;
		TT = UlGetFromStr(prhs[0] , "DevTimeTag", "DevTimeTag field is missing in argument" )   ;
		pMsg[2] = (short unsigned) (TT & 0xffff) ; 
		pMsg[3] = (short unsigned) ((TT>>16) & 0xffff ); 
		break ; 
	case 11: // Pos report 
		if ( GetVecFromStr( prhs[0] , "Pos" , 3 , X )  < 0 )
		{ 
			mexErrMsgTxt("Missing or incorrectly dimensioned Pos in struct\n");
		} 

		TT = (long) X[0] ; 
		pMsg[0] = (short unsigned) (TT & 0xffff) ; 
		pMsg[1] = (short unsigned) ((TT>>16) & 0xffff ); 
		TT = (long) X[1] ; 
		pMsg[2] = (short unsigned) (TT & 0xffff) ; 
		pMsg[3] = (short unsigned) ((TT>>16) & 0xffff ); 
		TT = (long) X[2] ; 
		pMsg[4] = (short unsigned) (TT & 0xffff) ; 
		pMsg[5] = (short unsigned) ((TT>>16) & 0xffff ); 

		pMsg[6] = UsGetFromStr(prhs[0] , "PosAzimuth", "PosAzimuth field is missing in argument" )   ;
		TT = UlGetFromStr(prhs[0] , "PosTimeTag", "PosTimeTag field is missing in argument" )   ;
		pMsg[7] = (short unsigned) (TT & 0xffff) ; 
		pMsg[8] = (short unsigned) ((TT>>16) & 0xffff ); 

		break ; 
	case 12: // Set parameter 
		pMsg[0] = UsGetFromStr(prhs[0] , "Index", "qIndex field is missing in argument" )   ;
		pMsg[1] = UsGetFromStr(prhs[0] , "SubIndex", "EntryIndex field is missing in argument" )   ;
		pMsg[2] = UsGetFromStr(prhs[0] , "Flags", "EntryIndex field is missing in argument" )   ;
		TT = UlGetFromStr(prhs[0] , "LongValue", "LongValue field is missing in argument" )   ;
		pMsg[3] = (short unsigned) (TT & 0xffff) ; 
		pMsg[4] = (short unsigned) ((TT>>16) & 0xffff ); 
		break ; 

	case 13: // Set CAN message 
		pMsg[0] = UsGetFromStr(prhs[0] , "CobId", "CobId field is missing in argument" )   ;
		pMsg[1] = UsGetFromStr(prhs[0] , "dLen", "dLen field is missing in argument" )   ;
		if ( pMsg[1] > 8 ) 
		{ 
			mexErrMsgTxt("CAN message length is limited to zero\n");
		} 

		if ( GetVecFromStr( prhs[0] , "Payload" , pMsg[1] , DMsg )  < 0 )
		{ 
			mexErrMsgTxt("Missing or incorrectly dimensioned payload in struct\n");
		} 
		cPtr  = ( char unsigned *) (&pMsg[2]) ; 
		for ( cnt = 0 ; cnt < pMsg[1] ; cnt++ ) 
		{ 
			if ( DMsg[cnt] < 0 ) 
			{ 
				DMsg[cnt] += 256 ; 
			} 
			if ( DMsg[cnt] < 0  || DMsg[cnt] > 255) 
			{ 
				mexErrMsgTxt("Out of range poayload items in struct\n");
			}
			cPtr[cnt] = (char unsigned) DMsg[cnt] ; 
		} 
		break ; 

	} 


	// Get the checksum 
	cs = 0 ; 
	for ( cnt = 1 ; cnt < (SPI_MSG_LEN-1) ; cnt++ ) 
	{ 
		cs -= uPtr[cnt] ; 
	} 
	uPtr[SPI_MSG_LEN-1]= cs ; 

	// Output matrix 
	plhs[0] =  mxCreateCharArray(2, dims);

	dataptr = (mxChar *)mxGetData(plhs[0]); 
	cPtr = (char unsigned *)  uPtr ;
	for ( cnt = 0 ; cnt < dims[1] ; cnt++ ) 
	{ 
		dataptr[cnt] = cPtr[cnt] ; 
	} 

} 
