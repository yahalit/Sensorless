#include "mex.h"
#include "windows.h"
//#include "canlib.h"
#include <process.h>  


void mexFunction(int nlhs, mxArray *plhs[], 
				 int nrhs, const mxArray *prhs[])
{
	mxArray *NextP ; 
	if ( nrhs !=1 || ( GetNumLen(prhs[0]) != 1 ) )  
	{ 
		mexErrMsgTxt("First Parameter of InterpTunnelCom() must be the option code\n");
	} 
	
	OptionCode =  (int) mxGetPr( prhs[0])[0] ; 
	
	NextP = ( nrhs >= 2 ) ? prhs[1] : NULL ; 
	
	if ( OptionCode == 1 ) 
	{ 
// Setup , the 2nd parameter must be a struct with filed names 


		if ( ( KvaserStr.LibOpened == 1 ) && (KvaserStr.Handle >= 0 ) )
		{ // Already open : nothing to do 
			goto OpenKvaserGoodRet ; 
			//plhs[0] = mxCreateDoubleMatrix (1, 1, mxREAL);
			//mxGetPr( plhs[0] )[0] = 1  ;
			//return ;
		}

		for ( cnt = 0 ; cnt < N_SDO ; cnt ++ )
		{ 
			MasterSdoStr[cnt].TxSdoId = 0xffff ; 
			MasterSdoStr[cnt].State = 0 ; 
		}
		
		BaudRate = (int)GetWithDefault (NextP , 0, 500000.0 ) ; 
		KvaserStr.BaudSelect = -1 ; 
		for ( cnt = 0 ; cnt < nRates ; cnt++ )
		{
			if ( BaudRate == BaudRates[cnt] )
			{
				KvaserStr.BaudSelect = cnt ; 
				break ; 
			}			
		}
		if ( KvaserStr.BaudSelect == -1 )
		{ 
			mexErrMsgTxt("Baud rates for KVaserCom() are 250000, 500000 and 1000000\n");
		}
		port = (int)GetWithDefault (NextP , 1, 0 ) ; 
		
		if ( CloseKvaserLib() < 0 )   
		{
			mexErrMsgTxt("Could not close previous connection of KvaserCom \n");
		}
		//initialize CANlib
		canInitializeLibrary();
		KvaserStr.Handle = canOpenChannel( port , canOPEN_EXCLUSIVE ) ;
		if ( KvaserStr.Handle < 0 ) 
		{
			mexErrMsgTxt( "Could not open Kvaser channel \n" ) ;
		}
		stat = (int) canSetBusParams(KvaserStr.Handle, BaudSymbols[KvaserStr.BaudSelect] , 0, 0, 0, 0, 0);
		if( stat != canOK )
		{
			CloseKvaserLib(); 
			sprintf( str , "Could not set the baud rate. Error = %d" , stat ) ;
			mexErrMsgTxt( str ) ;
		}
		KvaserStr.LibOpened = 1 ; 
		stat = (int) canBusOn(KvaserStr.Handle);
		if( stat != canOK )
		{
			CloseKvaserLib(); 
			sprintf( str , "Could not enter BUS ON. Error = %d" , stat ) ;
			mexErrMsgTxt( str ) ;
		}

	
		// Return 1 for success 
OpenKvaserGoodRet:
		// If we wanted to start a new, kill all the existing message processing
		MasterSdoStr[0].TxSdoId = 0xffff ; 
		MasterSdoStr[0].State = 0 ; 


		plhs[0] = mxCreateDoubleMatrix (1, 3, mxREAL);
		mxGetPr( plhs[0] )[0] = 1  ;
		mxGetPr( plhs[0] )[1] = BaudRate  ;
		mxGetPr( plhs[0] )[2] = port  ;
		return ;
	}
	
	if ( OptionCode == 2 ) 
	{ // Close port 

		plhs[0] = mxCreateDoubleMatrix (1, 1, mxREAL);
		mxGetPr( plhs[0] )[0] = CloseKvaserLib() ;

		for ( cnt = 0 ; cnt < N_SDO ; cnt++ ) 
		{  // Kill all the SDO slaves 
			MasterSdoStr[cnt].State = 0 ; 
		} 
		return ;
	}
	
	if ( (KvaserStr.Handle < 0 ) || ( KvaserStr.LibOpened != 1 ) ) 
	{ 
		mexErrMsgTxt("Attempt to access services other than close/open without first opening \n");			
	}

	if (OptionCode == 7)
	{ // SDO download
/* 7: Set SDO for download (will start process, but not necessarily end it) 
*	[handle] = KvaserCom( 7 , [CobId,CobIdRet,Index,SubIndex,DataType,Ext=0,TimeOut=0], Data[0..]] ) 
*/
		canFlushReceiveQueue(KvaserStr.Handle) ; 
		canFlushTransmitQueue(KvaserStr.Handle) ; 
		if ( nrhs != 3 ) 
		{ 
			mexErrMsgTxt("Use: KvaserCom( 7 , [CobId,CobIdRet,Index,SubIndex,DataType,Ext=0,TimeOut=0], Data[0..]] ) \n");	
		} 
		cntSdo = 0 ; 

		pSdo = & MasterSdoStr[cntSdo]; 
		NextP = prhs[1] ; 
		pSdo->RxSdoId = (int)GetWithDefault (NextP , 0, -1 ) ; 
		pSdo->TxSdoId = (int)GetWithDefault (NextP , 1, -1 ) ; 
		pSdo->Index = (int)GetWithDefault (NextP , 2, -1 ) ; 
		pSdo->SubIndex = (int)GetWithDefault (NextP , 3, -1 ) ; 
		pSdo->DataType = (int)GetWithDefault (NextP , 4, -1 ) ; 
		pSdo->Ext = (int)GetWithDefault (NextP , 5, 0 ) ; 
		pSdo->TimeOut =  GetWithDefault (NextP , 6, 0 ) ; 
		pSdo->AbortCode = 0 ; 

		MaxId = ( pSdo->Ext ? 0x1fffffff : 0x7ff ) ;

		if ( ( pSdo->TxSdoId < 0) || (pSdo->TxSdoId > MaxId)  || 
			( pSdo->RxSdoId < 0) || (pSdo->TxSdoId > MaxId) ) 
		{ 
			mexErrMsgTxt("Out of range TX ID or return ID \n");	
		} 
		if ( pSdo->Index < 1 || pSdo->Index > 65535 || pSdo->SubIndex < 0  || pSdo->SubIndex > 255) 
		{ 
			mexErrMsgTxt("Out of range Index or SubIndex \n");	
		} 
		if ( ( pSdo->DataType < 9 ) && (GetNumLen (prhs[2])!= 1 )  ) 
		{ 
			mexErrMsgTxt("For scalar types, SDO payload must be a single number \n");	
		} 


		// Assume an expedit 
		pSdo->sdata[1] = ( pSdo->Index & 0xff ) ;
		pSdo->sdata[2] = ( (pSdo->Index>>8) & 0xff ) ;
		pSdo->sdata[3] = pSdo->SubIndex ;
		

		switch ( pSdo->DataType) 
		{ 
		case 0: // Long 
			pSdo->Data = mxGetPr(prhs[2] )[0] ; 
			if ( pSdo->Data > 4294967295.0 || pSdo->Data < -2147483648.0) 
			{ 
				mexErrMsgTxt("Out of range  payload value \n");	
			} 
			if ( pSdo->Data >= 2147483648.0) 
			{ 
				pSdo->Data -= 4294967296;
			}
			uldata = (long unsigned )pSdo->Data ; 
			PutLongInString( uldata , (char unsigned *) &pSdo->sdata[4] ) ; 
			n = 4 ;
			break ; 
		case 1: // Float 
			pSdo->Data = mxGetPr(prhs[2] )[0] ; 
			if ( pSdo->Data > 1.0e38 || pSdo->Data < -1.0e38 ) 
			{ 
				mexErrMsgTxt("Out of range  payload value \n");	
			} 
			if ( pSdo->Data < 1.0e-38 && pSdo->Data > -1.0e-38 ) 
			{ 
				pSdo->Data = 0 ; 
			}
			fdata = (float)pSdo->Data ;  
			uldata = * ((long unsigned *) & fdata ) ; 
			PutLongInString( uldata , (char unsigned *) &pSdo->sdata[4] ) ; 
			n = 4 ;
			break ; 
		case 2: // Short 
			pSdo->Data = mxGetPr(prhs[2] )[0] ; 
			if ( pSdo->Data > 65535.0 || pSdo->Data < -32768.0) 
			{ 
				mexErrMsgTxt("Out of range  payload value \n");	
			} 
			if ( pSdo->Data >= 32768.0 ) 
			{ 
				pSdo->Data -= 65536 ;
			} 
			uldata = (long unsigned )pSdo->Data ; 
			PutLongInString( uldata & 0xffff , (char unsigned *) &pSdo->sdata[4] ) ; 
			n = 2 ; 
			break ; 
		case 3: // Character
			pSdo->Data = mxGetPr(prhs[2] )[0] ; 
			if ( pSdo->Data > 255.0 || pSdo->Data < -128.0) 
			{ 
				mexErrMsgTxt("Out of range  payload value \n");	
			} 
			if ( pSdo->Data >= 128.0 ) 
			{ 
				pSdo->Data -= 256 ;
			} 
			uldata = (long unsigned )pSdo->Data ; 
			PutLongInString( uldata & 0xff  , (char unsigned *) &pSdo->sdata[4] ) ; 
			n = 1 ; 
			break ; 

		case 9: 
			pChar = mxGetChars(prhs[2]); // String 
			if ( pChar == NULL  ) 
			{ 
				mexErrMsgTxt("Payload must be string \n");	
			} 
			pSdo->StringLen = (int) (mxGetN(prhs[2]) * mxGetM(prhs[2])) ; 
			if ( pSdo->StringLen < 1 || pSdo->StringLen > SDO_MAX_STR_LEN ) 
			{ 
				mexErrMsgTxt("Payload string length must be in [1..8192] \n");	
			} 
			n = pSdo->StringLen ; 
			if ( n <= 4 ) 
			{ 
				PutLongInString( 0 , (char unsigned *) &pSdo->sdata[4] ) ; 
				for ( cnt = 0 ; cnt < n ; cnt++ ) 
				{ 
					pSdo->sdata[cnt+4] = (char) pChar[cnt] ; 
				} 
			} 
			else
			{ 
				for ( cnt = 0 ; cnt < pSdo->StringLen ; cnt++ ) 
				{ 
					pSdo->String[cnt] = (char) pChar[cnt] ; 
				} 
			} 
			break ; 
		default: 
			mexErrMsgTxt("Unknown data type \n");	
			break ; 
		} 

		pSdo->StringLen = n ;
		if ( n <= 4 ) 
		{ 
			pSdo->sdata[0] = (0x1 << 5) + 3 ;  // Expedit 
			pSdo->sdata[0] |= ( (4-n)<<2) ;
		} 
		else
		{ 
			pSdo->sdata[0] = (0x1 << 5) + 1 ;  // Segmented 
			PutLongInString( n , (char unsigned *) &pSdo->sdata[4] ) ; 
		} 

		// Write SDO 
		stat = udpWrite(KvaserStr.Handle, pSdo->RxSdoId, (char *)pSdo->sdata);
		pSdo->State = 1; 
		pSdo->RetryCnt = 0; 
		pSdo->TransferType = 0 ; 

		// If timeout is installed, wait it
		if ( pSdo->TimeOut > 10000) 
		{ 
			pSdo->TimeOut = 10000 ;
		} 
		if ( pSdo->TimeOut < 1 ) 
		{ 
			pSdo->TimeOut = 1 ; 
		} 
		
		n1 = (short unsigned) ( pSdo->TimeOut ) ; 
		n = n1 ; 
		while ( n > 0 ) 
		{
			n -= 1 ; 
			Sleep(1);
			stat = DealKvaser() ; 
			if ( stat )
			{ 
				n = n1 ; 
			}

			if ( pSdo->State < 1 ) // Either 0 (done) or -1 (error)
			{ 
				break ; 
			} 
		} 
			
		// Waited for no one 
		if ( pSdo->State == 1 )
		{ 
			pSdo->State = -1 ; 
			pSdo->AbortCode  = 0xffffffff ; // Timed out 
		} 

		plhs[0] = mxCreateDoubleMatrix (1, 1, mxREAL);
		mxGetPr( plhs[0] )[0] = pSdo->AbortCode   ;
		
//		if ( nlhs > 1)
//		{ 
//			plhs[1] = mxCreateDoubleMatrix (1, 1, mxREAL);
//			mxGetPr( plhs[1] )[0] = pSdo->AbortCode   ;
//		}

		return ; 
	} 

/* 8: Set SDO for upload  (will start process, but not necessarily end it)
*	[data,errcode] = KvaserCom( 8 , [CobId,CobIdRet,Index,SubIndex,DataType,Ext=0,TimeOut=0]] ) 
*		if TimeOut is 0 , the SDO is placed in queue and function returns immetiately. 
*				One internal SDO management object remains occupied
*		Otherwise the SDO is managed till TimeOut. Return value is 0 on success and -1 on timeout.
*				If the SDO timed out, its SDO management object is killed.
*/
	if ( OptionCode == 8 ) 
	{ 
		canFlushReceiveQueue(KvaserStr.Handle) ; 
		canFlushTransmitQueue(KvaserStr.Handle) ; 
		if ( nrhs != 2 ) 
		{ 
			mexErrMsgTxt("Use: KvaserCom( 8 , [CobId,CobIdRet,Index,SubIndex,DataType,Ext=0,TimeOut=0] ) \n");	
		} 
		cntSdo = 0; 
		MasterSdoStr[0].State = 0 ; 

		pSdo = & MasterSdoStr[cntSdo]; 
		NextP = prhs[1] ; 
		pSdo->RxSdoId = (int)GetWithDefault (NextP , 0, -1 ) ; 
		pSdo->TxSdoId = (int)GetWithDefault (NextP , 1, -1 ) ; 
		pSdo->Index = (int)GetWithDefault (NextP , 2, -1 ) ; 
		pSdo->SubIndex = (int)GetWithDefault (NextP , 3, -1 ) ; 
		pSdo->DataType = (int)GetWithDefault (NextP , 4, -1 ) ; 
		pSdo->Ext = (int)GetWithDefault (NextP , 5, 0 ) ; 
		pSdo->TimeOut =  GetWithDefault (NextP , 6, 0 ) ; 
		pSdo->AbortCode = 0 ; 

		MaxId = ( pSdo->Ext ? 0x1fffffff : 0x7ff ) ;

		if ( ( pSdo->TxSdoId < 0) || (pSdo->TxSdoId > MaxId)  || 
			( pSdo->RxSdoId < 0) || (pSdo->TxSdoId > MaxId) ) 
		{ 
			mexErrMsgTxt("Out of range TX ID or return ID \n");	
		} 
		if ( pSdo->Index < 1 || pSdo->Index > 65535 || pSdo->SubIndex < 0  || pSdo->SubIndex > 255) 
		{ 
			mexErrMsgTxt("Out of range Index or SubIndex \n");	
		} 

		// SDO Init upload 
		pSdo->sdata[0] = (0x2 << 5)  ; 
		pSdo->sdata[1] = ( pSdo->Index & 0xff ) ;
		pSdo->sdata[2] = ( (pSdo->Index>>8) & 0xff ) ;
		pSdo->sdata[3] = pSdo->SubIndex ;
		pSdo->sdata[4] = 0 ; pSdo->sdata[5] = 0; pSdo->sdata[6] = 0 ; pSdo->sdata[7] = 0; 

		// Write SDO 
		stat = udpWrite(KvaserStr.Handle, pSdo->RxSdoId, (char *)pSdo->sdata); 

		pSdo->State = 1; 
		pSdo->RetryCnt = 0; 
		pSdo->TransferType = 1 ;
		pSdo->BytesAct = 0 ; 

		nact = pSdo->BytesAct; 

		// If we wait SDO ... otherwise just return 
		if ( pSdo->TimeOut > 10000) 
		{ 
			pSdo->TimeOut = 10000 ;
		} 
		if ( pSdo->TimeOut < 1 ) 
		{ 
			pSdo->TimeOut = 1 ; 
		} 
		n1 = (short unsigned) ( pSdo->TimeOut) ;
		n = n1 ; 
		
		while ( n > 0   ) 
		{ 
			Sleep(1) ; 
			n -= 1 ; 
			stat = DealKvaser() ; 
			if ( stat )
			{
				n = n1 ; 
			}
			if ( pSdo->State < 1 || pSdo->State > 2 ) 
			{
				break ; // Gamarnu 
			} 
		} 

		if ( pSdo->State < 0 || pSdo->State == 1 ) 
		{ // Nidfaknu, return empty code 
			plhs[0] = mxCreateDoubleMatrix (0, 0, mxREAL);
			if ( nlhs > 1 ) 
			{ 
				plhs[1] = mxCreateDoubleMatrix (1, 1, mxREAL);
				if ( pSdo->State == 1 )
				{  // Nobody home 
					mxGetPr( plhs[1])[0] = 0xffffffff   ; 
				} 
				else
				{
					mxGetPr( plhs[1])[0] = pSdo->AbortCode ; 
				} 
			} 
			return ; 
		} 

		if ( nlhs > 1 ) 
		{ // No error 
			plhs[1] = mxCreateDoubleMatrix (0, 0, mxREAL);
		} 
		
		PutStringInLong( &lNum , pSdo->String ) ; 
		switch ( pSdo->DataType) 
		{ 
		case 0: 
			plhs[0] = mxCreateDoubleMatrix (1, 1, mxREAL);
			mxGetPr( plhs[0])[0] = lNum ; 
			break ; 
		case 1: 
			plhs[0] = mxCreateDoubleMatrix (1, 1, mxREAL);
			mxGetPr( plhs[0])[0] = *( (float*) &lNum ) ; 
			break ; 
		case 2: 
			plhs[0] = mxCreateDoubleMatrix (1, 1, mxREAL);
			mxGetPr( plhs[0])[0] = *( (short unsigned*) &lNum ) ; 
			break ; 
		case 3: 
			plhs[0] = mxCreateDoubleMatrix (1, 1, mxREAL);
			mxGetPr( plhs[0])[0] = *( (char unsigned*) &lNum ) ; 
			break ; 
		case 9: 
			dims[1] = pSdo->StringLen ; 
			plhs[0] =  mxCreateCharArray(2, dims);
			dataptr = (mxChar *)mxGetData(plhs[0]); 
			for ( cnt = 0 ; cnt < pSdo->StringLen ; cnt++ ) 
			{ 
				dataptr[cnt] = pSdo->String[cnt] ; 
			} 
			break ; 
		case 10: //Vector of longs
			if ( pSdo->StringLen % 4  )
			{ 
				mexErrMsgTxt("Vector of longs should include 4*n characters \n");	 
			} 
			n = pSdo->StringLen >> 2 ; 
			plhs[0] = mxCreateDoubleMatrix (1, n, mxREAL);
			for ( cnt = 0 ; cnt < n ; cnt++ ) 
			{ 
				lNum = *  ((( long *)pSdo->String ) + cnt ) ;
				mxGetPr( plhs[0])[cnt] = lNum ; 
			} 
			break ; 
		case 11: //Vector of floats
			if ( pSdo->StringLen % 4  )
			{ 
				mexErrMsgTxt("Vector of float should include 4*n characters \n");	 
			} 
			n = pSdo->StringLen >> 2 ; 
			plhs[0] = mxCreateDoubleMatrix (1, n, mxREAL);
			for ( cnt = 0 ; cnt < n ; cnt++ ) 
			{ 
				fNum = *  ((( float *)pSdo->String ) + cnt ) ;
				mxGetPr( plhs[0])[cnt] = fNum ; 
			} 
			break ; 
		case 20: //Vector of unsigned longs
			if ( pSdo->StringLen % 4  )
			{ 
				mexErrMsgTxt("Vector of unsigned longs should include 4*n characters \n");	 
			} 
			n = pSdo->StringLen >> 2 ; 
			plhs[0] = mxCreateDoubleMatrix (1, n, mxREAL);
			for ( cnt = 0 ; cnt < n ; cnt++ ) 
			{ 
				ulNum = *  (((unsigned long *)pSdo->String ) + cnt ) ;
				mxGetPr( plhs[0])[cnt] = ulNum ; 
			} 
			break ; 


		default: 
			mexErrMsgTxt("Unknown data type \n");	 
		} 
		// Clear SDO object 
		pSdo->State = 0 ; 

		return ; 
	} 

	mexErrMsgTxt("Unknown option code !!\n");	
} 




short AbortSdo (struct CMasterSdoStr * pSdo, long unsigned AbortCode  )
{
	long unsigned kaka ; 
	pSdo->State = -1 ; 
	kaka = (4<<5) + ( (long unsigned)pSdo->Index << 8 ) + ( (long unsigned)pSdo->SubIndex << 24 ); 
	PutLongInString( kaka , (char unsigned *)  SdoUploadMsg ) ; 
	PutLongInString( AbortCode , (char unsigned *)  &SdoUploadMsg[4] ) ; 
	udpWrite(KvaserStr.Handle, pSdo->RxSdoId, (char *) SdoUploadMsg  );
	pSdo->AbortCode = AbortCode ; 
	return 0 ; 
} 

short CheckToggleBit(struct CMasterSdoStr * pSdo, char unsigned *data)
{
	short unsigned t ; 
	t = data[0] & 0x10 ;
	if ( t != pSdo->Toggle ) 
	{
		AbortSdo ( pSdo, 0x5030000 ) ;
		return -1 ; 
	} 
	pSdo->Toggle = 0x10 - pSdo->Toggle;
	return 0 ; 
} 

short CheckMultiplexor(struct CMasterSdoStr * pSdo, char unsigned *data)
{
	short unsigned Index , SubIndex  ; 
	Index = (short unsigned) data[1] + ( (short unsigned) data[2] << 8 )  ;
	SubIndex = (short unsigned) data[3] ; 
	if (Index != pSdo->Index || SubIndex != pSdo->SubIndex ) 
	{
		AbortSdo ( pSdo, 0x6040047 ) ;  
		return -1 ; 
	} 
	return 0 ;
} 

/**
* \brief CAN Master SDO management 

*/
void ProcMasterSdo (struct CMasterSdoStr * pSdo , char unsigned * data , short unsigned dlen ) 
{
	short unsigned expectcs , cs , e , s , cnt , c; 
	long unsigned n ; 
	//pSdo->State = -1  ; 
	pSdo->AbortCode = -1  ; 

	// All SDO: length must be 8 
	if ( dlen != 8 ) 
	{ 
		pSdo->State = -1  ; 
		pSdo->AbortCode = 0x5040001 ; 
	} 

	cs = ( data[0] >> 5 )  & 0x7 ; 
	e = ( data[0] >> 1 )  & 0x1 ; 
	n = ( data[0] >> 2 )  & 0x3 ; 
	s = data[0] & 0x1 ;


	if ( cs == 4 ) 
	{ // General treatment of abortion 
		pSdo->State = -1  ; 
		PutStringInLong( &pSdo->AbortCode  , &data[4]);
		return  ; 
	} 

	if ( pSdo->State == 1 ) 
	{// 1st return message 
		if ( CheckMultiplexor(pSdo,data) < 0 ) 
		{ // Bad multiplexor - not our boy 
			return ; 
		}
		pSdo->Toggle = 0 ; 
		pSdo->AbortCode = 0  ; 
		if ( pSdo->TransferType == 0 ) 
		{ 
			expectcs = 3; 
		} 
		else
		{ 
			expectcs = 2; 
		} 
		pSdo->BytesAct = 0 ; 
	}
	else
	{ // Continuation 
		if ( CheckToggleBit(pSdo,data) < 0 ) 
		{ 
			return ; 
		} 
		if ( pSdo->TransferType == 0 ) 
		{ 
			expectcs = 1; 
		} 
		else
		{ 
			expectcs = 0; 
		} 
	} 

	if ( cs != expectcs ) 
	{ 
		AbortSdo ( pSdo, 0x6040047 ) ;  
		return;
	} 



	if ( pSdo->TransferType == 0 ) 
	{ // Download value 
		switch ( pSdo->State ) 
		{ 
		case 1: // This is init dload response 
			if ( pSdo->StringLen <= 4  ) 
			{ 
				if ( pSdo->State == 1) 
				{ // Init dload response
					pSdo->State = 0  ;  // If this was an expedit, thats it 
					return ;
				} 
			} 
			pSdo->BytesAct = 0 ;
			pSdo->State    = 2 ; // Download continue

			n = pSdo->StringLen - pSdo->BytesAct ; 
			if ( n > 7 ) 
			{ 
				c = 0 ; 
				n = 7 ; 
			} 
			else
			{ 
				c = 1 ; 
			} 

			PutLongInString( 0 , &SdoUploadMsg[0]); 
			PutLongInString( 0 , &SdoUploadMsg[4]); 
			SdoUploadMsg[0] = (char unsigned) (c + ((7-n)<<1)+pSdo->Toggle) ; 
			for ( cnt = 0 ; cnt < n ; cnt++ ) 
			{ 
				SdoUploadMsg[cnt+1] = pSdo->String[pSdo->BytesAct+cnt] ; 
			} 

			pSdo->BytesAct += (unsigned short) n ; 
			udpWrite(KvaserStr.Handle, pSdo->RxSdoId, (char *) SdoUploadMsg );
			break ; 
		case 2: // Into segmented download

			if ( pSdo->StringLen == pSdo->BytesAct ) 
			{ 
				pSdo->AbortCode = 0  ; 
				pSdo->State = 0; // Gamarnu download
				return ; 
			} 

			n = pSdo->StringLen - pSdo->BytesAct ; 
			if ( n > 7 ) 
			{ 
				c = 0 ; 
				n = 7 ; 
			} 
			else
			{ 
				c = 1 ; 
			} 

			PutLongInString( 0 , &SdoUploadMsg[0]); 
			PutLongInString( 0 , &SdoUploadMsg[4]); 
			SdoUploadMsg[0] = (char unsigned) (c + ((7-n)<<1)+pSdo->Toggle) ; 
			for ( cnt = 0 ; cnt < n ; cnt++ ) 
			{ 
				SdoUploadMsg[cnt+1] = pSdo->String[pSdo->BytesAct+cnt] ; 
			} 

			pSdo->BytesAct += (unsigned short) n ; 
			udpWrite(KvaserStr.Handle, pSdo->RxSdoId, (char *) SdoUploadMsg  );

			break ;
		} 
		return ;
	}

	if ( pSdo->TransferType == 1 ) 
	{ // Upload value 
		switch ( pSdo->State ) 
		{ 
		case 1: // This is init upload response 
			if ( e )
			{ // Thats expedit 
				pSdo->State = 3 ;
				for ( cnt = 0 ; cnt < 4 ; cnt++ ) 
				{ 
					pSdo->String[cnt] = data[cnt+4] ; 
				}
				pSdo->StringLen = 4 - (( data[cnt+4]>>2 ) & 3 ) ;
			} 
			else
			{ 
				if ( s)
				{
					PutStringInLong( &pSdo->StringLen , (char unsigned *) &data[4]) ; 
					if ( pSdo->StringLen >= SDO_MAX_STR_LEN ) 
					{ 
						AbortSdo ( pSdo, 0x5040005 ) ;  
						return ;
					} 
				} 
				else
				{ 
					pSdo->StringLen = SDO_MAX_STR_LEN; 
				} 
				pSdo->State = 2 ; 
				// Ask continuation 
				PutLongInString( (3L<<5) , &SdoUploadMsg[0]); 
				PutLongInString( 0 , &SdoUploadMsg[4]); 

				udpWrite(KvaserStr.Handle, pSdo->RxSdoId, (char *) SdoUploadMsg );
			} 
			break ; 
		case 2: // Segmented upload continuoed 
			n = 7 - (( data[0]>>1 ) & 7 ); 
			if ( pSdo->StringLen - pSdo->BytesAct < n ) 
			{ 
				AbortSdo ( pSdo, 0x6040047 ) ;  
				return;		
			} 
			for ( cnt = 0 ; cnt < n ; cnt++ ) 
			{ 
				pSdo->String[pSdo->BytesAct+cnt] = data[cnt+1] ; 
			} 
			pSdo->BytesAct += (unsigned short) n ; 

			c = data[0] & 1 ; 
			if ( c ) 
			{
				if ( pSdo->StringLen = SDO_MAX_STR_LEN ) 
				{ 
					pSdo->StringLen = pSdo->BytesAct ; 
				} 
				else
				{ 
					if ( pSdo->StringLen != pSdo->BytesAct ) 
					{
						AbortSdo ( pSdo, 0x6040047 ) ;  
						return;		
					} 
				} 
				pSdo->State = 3 ; // Gamarnu 
			} 
			else
			{ // Trigger another cycle 
				PutLongInString( (3L<<5) + pSdo->Toggle , &SdoUploadMsg[0]); 
				PutLongInString( 0 , &SdoUploadMsg[4]); 
				udpWrite(KvaserStr.Handle, pSdo->RxSdoId, (char *) SdoUploadMsg  );
			} 

			break ; 
		} 
	} 
} 					


