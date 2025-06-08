#include "mex.h"
#include "windows.h"
#include "canlib.h"
#include <process.h>  
#include <sys\timeb.h> 


extern canStatus canFlushReceiveQueue	(	const int 	hnd	)	; 
extern canStatus canFlushTransmitQueue	(	const int 	hnd	)	; 

#define USE_BLOCK_SIZE 120 
#define USE_BLOCK_SIZE_B (120*7) 


int longcnt;
int inlongcnt;
int longcntstop = 207;
int stam = 0;
unsigned long *pL0;

unsigned long* GpL;
float* Gpf;
double* Gpd;
unsigned char BlockRxBuffer[4 * 2048];
struct timeb start, end;
int tdiff ;

// Get .QuadPart for number 

// Resource for threading from Matlab distribution: square.c

// Mutex used to lock resource access .

#define N_CYC_BUFSIZE 1024 
struct CSingleMsg 
{
	long CobId ; 
	long ldata[2] ;
	long dLen ; 
	long Time ; 
};


#define N_SDO 1 
#define SDO_MAX_STR_LEN (8192*2) 

struct CMasterSdoStr
{
	int RxSdoId ; 
	int TxSdoId ; 
	int  Index; 
	int  SubIndex; 
	int  Ext; 
	double TimeOut ;
	int State   ; // 0: Inactive , or Download done , 1: started , 2: In segmented session , 3: Upload done , -1: aborted 
	long unsigned StringLen ;
	int RetryCnt ;
	int TransferType ; // 0 dload , 1 upload
	int DataType ; 
	short unsigned Toggle; 
	short unsigned BytesAct ; 
	long unsigned AbortCode ; 
	char unsigned String[SDO_MAX_STR_LEN] ; 
	char unsigned sdata[8] ; // SDO download init 
	char unsigned rdata[8] ; // Return data 
	int  nBlock ; // Number of blocks 
	int  nLastBlock ; // Number of bytes in last block  
	double Data ; // Data passed from Matlab to transfer 
};
struct CMasterSdoStr MasterSdoStr[N_SDO];

char str[256] ;
char SdoUploadMsg[8] ; 
mwSize dims[] = {1, 0};
mxChar * dataptr ;

int BaudRates[3]   = {250000,500000,1000000} ; 
int BaudSymbols[3] = { BAUD_250K ,BAUD_500K ,BAUD_1M} ;  
int unsigned nRates  = sizeof(BaudRates)/sizeof(int) ; 



char junkstr [128] ; 



struct CKvaserStr
{ 
	int LibOpened  ; 
	int BaudSelect ; 
	canHandle Handle[2];
}; 
struct CKvaserStr KvaserStr = { .LibOpened = 0 , .BaudSelect = -1 , .Handle = {-1,-1} } ; 

// Locals 
////////////////////////////////////////////////////////////////////////////////
void ProcMasterSdo (struct CMasterSdoStr * pSdo , char unsigned * data , short unsigned dlen ) ;


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


void	printMessageData(char unsigned *data) 
{ 
	mexPrintf("\n\t Message data[0..7]: %x ,  %x  , %x  , %x  , %x  , %x  , %x  , %x ", 
	(short)data[0] ,(short)data[1] ,(short)data[2] ,(short)data[3] ,(short)data[4] ,(short)data[5] ,(short)data[6] ,(short)data[7] );
}					 					



/**
* \brief : Get item from a double array with default
*
* \param : px - Array to fetch from 
* \param : place - place to fetch px--[place]
* \param : def   - Default to take if array is absent or too short 
*
* \return : px--[place] if exists ; otherwise the default  
*/
double GetWithDefault(const mxArray *px , int unsigned place , double def ) 
{
		if ( (px==NULL) || (GetNumLen(px) <= place ) )
		{
				return def ;
		}
		return mxGetPr(px)[place] ; 
}

/**
* \brief Get a matlab array into char[8]
* \detail Array can be either double or char 
* \param px: Matlab array argument 
* \param msg: The output message 
*
* \return : Number of actual bytes in msg , -1 if ilegal (too long, includes value > 255 in data)
*/
unsigned int GetMessageContents (const mxArray *px , char unsigned *msg )
{
	int cnt , next ; 
	int n = (int) (mxGetM(px) * mxGetN( px) ) ; 
	mxChar * pChar ; 
	
	if ( n > 8 )
	{
		return -1 ; 
	}
 	
	if ( mxIsDouble(px) ) 
	{
		 for ( cnt = 0 ; cnt < n ; cnt++ )
		 {
			 next = (int) mxGetPr(px)[cnt]; 
			 if ( next < 0 || next > 255 )
			 {
					return -1; 
			 }
			 msg[cnt] = next ; 
		 }
		 return n ; 
	}
	pChar = mxGetChars(px);
	if ( pChar == NULL  ) 
	{ 
		return -1 ; 
	}
	for ( cnt = 0 ; cnt < n ; cnt++ )
	{
			msg[cnt] = (char) pChar[cnt] ;
	}
	return (unsigned int) n ; 
}

void PutLongVecInString(long unsigned lin[], int n )
{
	union
	{
		long ul;
		char unsigned c[4];
	} u; 
	long unsigned l; 
	int cnt; 
	for (cnt = 0; cnt < n; cnt++)
	{
		l = lin[cnt]; 
		u.c[0] = (char unsigned)(l & 0xff);
		u.c[1] = (char unsigned)((l >> 8) & 0xff);
		u.c[2] = (char unsigned)((l >> 16) & 0xff);
		u.c[3] = (char unsigned)((l >> 24) & 0xff);
		lin[cnt] = u.ul; 
	}
}


void PutLongInString( long unsigned l , char unsigned * c) 
{
	c[0] = (char unsigned) (l & 0xff ) ;  
	c[1] = (char unsigned) ((l>>8) & 0xff ) ;  
	c[2] = (char unsigned) ((l>>16) & 0xff ) ;  
	c[3] = (char unsigned) ((l>>24) & 0xff ) ;  
} 


void PutStringInLong( long unsigned *n , char unsigned * data) 
{
	*n =  (long unsigned) data[0] 
		+ ( (long unsigned) data[1] << 8 ) 
		+ ( (long unsigned) data[2] << 16 ) 
		+ ( (long unsigned) data[3] << 24 ) ; 
}

 /**
 * \brief Close the Kvaser connection 
 *
 * \detail Also close Kvaser handeling thread 
 */

short CloseKvaserLib(void)
{ 
int stat1 , stat2 ; 


	if ( ( KvaserStr.LibOpened != 1 ) || (KvaserStr.Handle < 0 ) )
	{
		KvaserStr.LibOpened    = 0 ; 
		KvaserStr.Handle[0] = -1 ; 
		KvaserStr.Handle[1] = -1 ; 
		return 1; // Close allready, nothing more to do 
	}
	
	stat1 = canBusOff( KvaserStr.Handle[0] ) ;			
	stat2 = canClose( KvaserStr.Handle[0] ) ;	
	stat1 = canBusOff( KvaserStr.Handle[1] ) ;			
	stat2 = canClose( KvaserStr.Handle[1] ) ;	
	KvaserStr.LibOpened	= 0 ; 
	KvaserStr.Handle[0] = -1 ; 
	KvaserStr.Handle[1] = -1 ; 

	if ( (stat1 == canOK) && (stat2 == canOK))
	{
		return 1 ; 
	}
	return -1; 
}

typedef  short unsigned u16 ; 
typedef  char unsigned u8 ; 


const u16 crc_ccitt_table[256] = {
	0x0000, 0x1189, 0x2312, 0x329b, 0x4624, 0x57ad, 0x6536, 0x74bf,
	0x8c48, 0x9dc1, 0xaf5a, 0xbed3, 0xca6c, 0xdbe5, 0xe97e, 0xf8f7,
	0x1081, 0x0108, 0x3393, 0x221a, 0x56a5, 0x472c, 0x75b7, 0x643e,
	0x9cc9, 0x8d40, 0xbfdb, 0xae52, 0xdaed, 0xcb64, 0xf9ff, 0xe876,
	0x2102, 0x308b, 0x0210, 0x1399, 0x6726, 0x76af, 0x4434, 0x55bd,
	0xad4a, 0xbcc3, 0x8e58, 0x9fd1, 0xeb6e, 0xfae7, 0xc87c, 0xd9f5,
	0x3183, 0x200a, 0x1291, 0x0318, 0x77a7, 0x662e, 0x54b5, 0x453c,
	0xbdcb, 0xac42, 0x9ed9, 0x8f50, 0xfbef, 0xea66, 0xd8fd, 0xc974,
	0x4204, 0x538d, 0x6116, 0x709f, 0x0420, 0x15a9, 0x2732, 0x36bb,
	0xce4c, 0xdfc5, 0xed5e, 0xfcd7, 0x8868, 0x99e1, 0xab7a, 0xbaf3,
	0x5285, 0x430c, 0x7197, 0x601e, 0x14a1, 0x0528, 0x37b3, 0x263a,
	0xdecd, 0xcf44, 0xfddf, 0xec56, 0x98e9, 0x8960, 0xbbfb, 0xaa72,
	0x6306, 0x728f, 0x4014, 0x519d, 0x2522, 0x34ab, 0x0630, 0x17b9,
	0xef4e, 0xfec7, 0xcc5c, 0xddd5, 0xa96a, 0xb8e3, 0x8a78, 0x9bf1,
	0x7387, 0x620e, 0x5095, 0x411c, 0x35a3, 0x242a, 0x16b1, 0x0738,
	0xffcf, 0xee46, 0xdcdd, 0xcd54, 0xb9eb, 0xa862, 0x9af9, 0x8b70,
	0x8408, 0x9581, 0xa71a, 0xb693, 0xc22c, 0xd3a5, 0xe13e, 0xf0b7,
	0x0840, 0x19c9, 0x2b52, 0x3adb, 0x4e64, 0x5fed, 0x6d76, 0x7cff,
	0x9489, 0x8500, 0xb79b, 0xa612, 0xd2ad, 0xc324, 0xf1bf, 0xe036,
	0x18c1, 0x0948, 0x3bd3, 0x2a5a, 0x5ee5, 0x4f6c, 0x7df7, 0x6c7e,
	0xa50a, 0xb483, 0x8618, 0x9791, 0xe32e, 0xf2a7, 0xc03c, 0xd1b5,
	0x2942, 0x38cb, 0x0a50, 0x1bd9, 0x6f66, 0x7eef, 0x4c74, 0x5dfd,
	0xb58b, 0xa402, 0x9699, 0x8710, 0xf3af, 0xe226, 0xd0bd, 0xc134,
	0x39c3, 0x284a, 0x1ad1, 0x0b58, 0x7fe7, 0x6e6e, 0x5cf5, 0x4d7c,
	0xc60c, 0xd785, 0xe51e, 0xf497, 0x8028, 0x91a1, 0xa33a, 0xb2b3,
	0x4a44, 0x5bcd, 0x6956, 0x78df, 0x0c60, 0x1de9, 0x2f72, 0x3efb,
	0xd68d, 0xc704, 0xf59f, 0xe416, 0x90a9, 0x8120, 0xb3bb, 0xa232,
	0x5ac5, 0x4b4c, 0x79d7, 0x685e, 0x1ce1, 0x0d68, 0x3ff3, 0x2e7a,
	0xe70e, 0xf687, 0xc41c, 0xd595, 0xa12a, 0xb0a3, 0x8238, 0x93b1,
	0x6b46, 0x7acf, 0x4854, 0x59dd, 0x2d62, 0x3ceb, 0x0e70, 0x1ff9,
	0xf78f, 0xe606, 0xd49d, 0xc514, 0xb1ab, 0xa022, 0x92b9, 0x8330,
	0x7bc7, 0x6a4e, 0x58d5, 0x495c, 0x3de3, 0x2c6a, 0x1ef1, 0x0f78
};


inline u16 crc_ccitt_byte(u16 crc, u8 c)
{
	return (crc >> 8) ^ crc_ccitt_table[(crc ^ c) & 0xff];
}


/**
 *	crc_ccitt - recompute the CRC (CRC-CCITT variant) for the data
 *	buffer
 *	@crc: previous CRC value
 *	@buffer: data pointer
 *	@len: number of bytes in the buffer
 */
u16 crc_ccitt( u16 crc  , u8  *buffer, int len)
{
	 
	while (len--)
		crc = crc_ccitt_byte(crc, *buffer++);
	return crc;
}

u16 crc_ccitt_w( u16 crc , u16  *buffer, int len)
{ 
	short unsigned next ; 
	//crc  should init by 0xffff ; 
	while (len--)
	{
		next = *buffer++ ; 
		crc = crc_ccitt_byte(crc, next & 0xff );
		crc = crc_ccitt_byte(crc, (next>>8) & 0xff );		
	}
	return crc;
}



int FetchBlockBody(long unsigned** ppSend, int nSendL, int IsLast, short unsigned* crc , canHandle handle )
{
	struct CMasterSdoStr* pSdo;
	char unsigned uc[8] , snchar;
	char unsigned c;
	char unsigned* pSend;
	int serno,npzz ,  nSendb, nlast, nrem, ns, cnt;
	unsigned int flg, dlc; 
	long stat, id ;
	DWORD time;

	pSdo = &MasterSdoStr[0];
	pSend = (char unsigned*)*ppSend;

	nSendb = nSendL * 4;
	nlast = (int)nSendb / 7;
	nrem = nSendb - nlast * 7;

	if (nrem)
	{
		nlast += 1;
	}
	else
	{
		nrem = 7;
	}

	if (nlast <= 0 || nlast > 127)
	{
		mexErrMsgTxt("FetchBlockBody: nlast out of range \n");
		return -1;
	}

	// Put sub-block upload request 
	*(long*)&uc[0] = 0;
	*(long*)&uc[4] = 0;
	uc[0] = 0xa3;

	canFlushReceiveQueue(handle);
	stat = canWriteWait(handle, pSdo->RxSdoId, (char*)uc, 8, canMSG_STD, 10);
	if (stat != canOK)
	{
		mexErrMsgTxt("Sub Block upload request Tx failed \n");
		return -1;
	}


	serno = 0; npzz = 0 ; 
	do
	{
		stat = canReadWait(handle, &id, (char*)uc, &dlc, &flg, &time , 40);

		if (stat)
		{
			if (stat == canERR_NOMSG)
			{
				mexErrMsgTxt("FetchBlockBody: Waiting a message : never arrived \n");
			}
			else
			{
				mexErrMsgTxt("FetchBlockBody: Accepted CAN error \n");
			}
			return -1;
		}

		if (pSdo->TxSdoId != id || dlc != 8 )
		{
			npzz += 1; 
			if (npzz > 64)
			{
				mexErrMsgTxt("FetchBlockBody: Too many messages without ID and DLC match \n");
				return -1;
			}
			continue;
		}

		npzz = 0; 

		serno += 1;


		if (serno == nlast)
		{
			snchar = 0x80 + serno;
			ns = nrem;
		}
		else
		{
			snchar = serno;
			ns = 7;
		}
		if (uc[0] != snchar)
		{
			mexPrintf("\n\t\r uc[0] %x , snchar  %x  ", (short)uc[0], (short)snchar);
			mexErrMsgTxt("FetchBlockBody: bad serial number confirmation \n");
			return -1;
		}

		for (cnt = 1; cnt <= ns; cnt++)
		{
			c = uc[cnt]; 
			*pSend++ = c;

			inlongcnt += 1;
			if (inlongcnt >= 4)
			{
				inlongcnt = 0;
				longcnt += 1;
				if (longcnt == longcntstop)
				{
					stam = 1;
				}
			}
			*crc = crc_ccitt_byte(*crc, c);
		}
	} while (serno < nlast) ; 

	// Put sub-block confirmation
		// Initialize block upload
	*(long*)&uc[0] = 0;
	*(long*)&uc[4] = 0;
	uc[0] = 0xa2;
	uc[1] = serno;
	uc[2] = 120;

	stat = canWriteWait(handle, pSdo->RxSdoId, (char*)uc, 8, canMSG_STD, 100  );
	if (stat != canOK)
	{
		mexErrMsgTxt("Sub Block upload confirmation Tx failed \n");
	}

	*ppSend = (long unsigned*)pSend;
	return 0;
}




int SendBlockBody( long unsigned **ppSend, int nSendL, int IsLast , short unsigned *crc ,  short unsigned UseHandle) 
{ 
		struct CMasterSdoStr *pSdo;
		char unsigned uc[8] , c; 
		char unsigned * pSend ; 
		int serno , nSendb , nlast , nrem , ns , cnt   ; 
		unsigned long cobId, dataLen, flag;
		long stat;
		DWORD time;
		canHandle handle = KvaserStr.Handle[UseHandle&1]; 

		pSdo  = & MasterSdoStr[0]; 
		pSend = ( char unsigned * ) *ppSend ; 
		
		nSendb = nSendL * 4 ; 
		nlast = (int) nSendb / 7 ; 
		nrem = nSendb - nlast * 7 ; 
		
		if ( nrem  ) 
		{ 
			nlast += 1 ; 
		}
		else
		{
			nrem = 7; 
		}
		
		if ( nlast <=0 || nlast > 127 )
		{
			return -1 ; 
		}
		
		for ( serno = 1 ; serno <= nlast ; serno+=1 )
		{ 
			if ( serno == nlast  ) 
			{ 
				uc[0] = 0x80 + serno ; 
				ns = nrem ; 
			} 
			else
			{ 
				uc[0] = serno ; 
				ns = 7 ; 
			}
			for ( cnt = 1 ; cnt <= ns ; cnt++ ) 
			{
				c = *pSend++ ; 

				inlongcnt += 1;
				if (inlongcnt >= 4)
				{
					inlongcnt = 0;
					longcnt += 1; 
					if (longcnt == longcntstop)
					{
						stam = 1; 
					}
				}

				uc[cnt] = c ; 
				*crc = crc_ccitt_byte( *crc, c);
			}
			stat = canRead( handle , &cobId , (char *)&pSdo->rdata[0], &dataLen , &flag, &time ) ;
			if ( stat == canOK ) 
			{
				if ( (cobId & 0x7f) == (pSdo->RxSdoId &0x7f ) ) 
				{
					printMessageData(&pSdo->rdata[0]) ; 
					mexErrMsgTxt("Sub Block transmission experienced unexpected message \n");					
				}
			}

			canWriteWait(handle, pSdo->RxSdoId, (char *) uc , 8, canMSG_STD , 10  );
		}

		// Wait sub-block confirmation
		stat = canReadWait(handle, &cobId, (char *)&pSdo->rdata[0], &dataLen, &flag, &time, 60);
		if (stat != canOK)
		{
			mexErrMsgTxt("Sub Block confirmation never arrived \n");
		}

		// Ask the KVASER instrument if there is anything 
		if ((pSdo->rdata[0] != ((5 << 5) + 2)) || (nlast != pSdo->rdata[1]) || (pSdo->rdata[2] < USE_BLOCK_SIZE))
		{
			mexPrintf("\n\t\rdata[0] %x , rdata[1] %d , nlast %d , rdata[2] %x ", (short)pSdo->rdata[0] , (short)pSdo->rdata[1] , nlast, (short)pSdo->rdata[2]  );

mexErrMsgTxt("Sub Block confirmation not as expected \n");
		}


		*ppSend = (long unsigned*)pSend;
		return 0;
}


/**
 * \brief Periodic thread for Kvaser handeling
 *
 * \detail Samples the Kvaser queue, fetch any messages that may exist
 *		   messages that have assigned SDO traps are processed as SDO
 *		   other messages rae placed in the history queue
 */
unsigned DealKvaser(short unsigned UseHandle)
{
	char unsigned data[8];
	unsigned long cobId, dataLen, flag;
	unsigned short RetVal;
	long stat;
	DWORD time;
	canHandle handle = KvaserStr.Handle[UseHandle&1]; 


	// Thread safety form main process 
	memset(data, 0, 8);

	stat = canOK;
	RetVal = 0;

	while (stat == canOK)
	{
		// Ask the KVASER instrument if there is anything 
		stat = canRead(handle, &cobId, (char*)data, &dataLen, &flag, &time);

		if (stat != canOK)
		{
			break;
		}

		if ((MasterSdoStr[0].State > 0) &&
			(MasterSdoStr[0].State < 3) &&
			(MasterSdoStr[0].TxSdoId == cobId))
		{
			ProcMasterSdo(&MasterSdoStr[0], data, (short unsigned)dataLen,handle);
			RetVal = 1;
			break;
		}
	}
	return RetVal;
}


/**
 * \brief DealKvaserBoot: NMT a slave identification request
 *
 */
unsigned DealKvaserBoot( int IdVec[] , int VerVec[] , int nId_in , int nIdMax , short unsigned UseHandle)
{
	char unsigned data[8];
	unsigned long cobId, dataLen, flag; 
	int nId;
	unsigned short RetVal;
	long stat;
	DWORD time;
	canHandle handle = KvaserStr.Handle[UseHandle&1]; 


	// Thread safety form main process 
	memset(data, 0, 8);
	nId = nId_in; 

	stat = canOK;
	RetVal = 0;

	while ( (stat == canOK) && ( nId < nIdMax ) ) 
	{
		// Ask the KVASER instrument if there is anything 
		stat = canRead(handle, &cobId, (char*)data, &dataLen, &flag, &time);

		if (stat != canOK)
		{
			break;
		}

		if ((dataLen >= 4) && ((cobId & 0xf80) == 1792) && (data[0] == 0) )
		{
			IdVec[nId] = (cobId & 0x7f) + ((long unsigned) data[1] << 8 ) + ((long unsigned)data[2] << 16 ) + ((long unsigned)data[3] << 24);
			if ( dataLen == 8 ) 
			{ 
				VerVec[nId] = (long unsigned) data[0]+ ((long unsigned) data[1] << 8 ) + ((long unsigned)data[2] << 16 ) + ((long unsigned)data[3] << 24);
			} 
			else
			{
				VerVec[nId] = 0 ; 				
			} 
			nId = nId + 1; 
		}
	} 
	return nId; 
}



canStatus canReadWaitSpecificCobId(const int 	hnd,
	long id,
	char* msg,
	unsigned int* dlc,
	unsigned int* flag,
	unsigned long* time,
	unsigned long 	timeout
)
{
	canStatus stat;
	long idCand;
	char dataCand[8];
	unsigned int dataLen;
	unsigned int flagCand;
	unsigned long timeCand;
	unsigned short n, n1, cnt;
	int kuku;

	n1 = (short unsigned)timeout;
	n = n1;
	kuku = 1;
	ftime(&start);

	while (n > 0)
	{
		n -= 1;

		ftime(&end);

		tdiff = end.millitm - start.millitm;
		if (end.time != start.time)
		{ // Compensate second boundary pass 
			tdiff += 1000;
		}
		if (tdiff > n1)
		{
			n = 0;
		}

		Sleep(kuku);
		//kuku  = 0 ; 

		while (canRead(hnd, &idCand, (char*)&dataCand[0], &dataLen, &flagCand, &timeCand) == canOK)
		{
			if (idCand == id)
			{
				for (cnt = 0; cnt < 8; cnt++)
				{
					msg[cnt] = dataCand[cnt];
					*flag = flagCand;
					*time = timeCand;
				}
				return canOK;
			}
			else
			{
				stat = canERR_NOMSG; 
			}
		}
	}
	return stat; 
}
	
	
	//


/**
*
* Kvaser handler function 
* Syntax: 
* [out_args] = KvaserCom (op code , args ) ; 
* Op codes: 
* 1: Open communication, 
*		[success,Baud,Port] = KvaserCom(1,[Baud=500000,Port=0]) 
* 2: Close communication  
*		success = KvaserCom(2) 
* 3: ?????  Not correct ???? Download single object by expedit SDO 
*		success = KvaserCom( 3 , [ind , subind, type , value ] )
* 4: Upload single object by expedit SDO 
* 		[success,value] = KvaserCom( 3 , [ind , subind]) 
* 5: Transmit arbitrary message
*	[success] = KvaserCom( 5 , [CobId, Ext=0,TimeOut=0], Data[0..7]] ) 
* 6: Fetch entire message queue 
*	[MessagesArray] = KvaserCom( 6 ) 
* 7: Set SDO for download (will start process, but not necessarily end it) 
*	[retval] = KvaserCom( 7 , [CobId,CobIdRet,Index,SubIndex,DataType,Ext=0,TimeOut=0], Data[0..]] ) 
*									DataType: 0 for long , 1 for float , 2 for short, 3 for char ,
*											  9 for unformatted string, 10 for vector of longs
*											 11 for vector of floats 
*											 12 for vector of unsigned longs 
*	For all but unformatted string, Data is a single number
*		Otherwise it need be a char array at the appropriate length
*		if TimeOut is 0 , the SDO is placed in queue and function returns immetiately. 
*				One internal SDO management object remains occupied
*		Otherwise the SDO is managed till TimeOut. Return value is 0 on success and -1 on timeout.
*				If the SDO timed out, its SDO management object is killed.
* 8: Set SDO for upload  (will start process, but not necessarily end it)
*	[data,errcode] = KvaserCom( 8 , [CobId,CobIdRet,Index,SubIndex,DataType,Ext=0,TimeOut=0] ) 
*									DataType: Refer SDO download 
*		if TimeOut is 0 , the SDO is placed in queue and function returns immetiately. 
*				One internal SDO management object remains occupied
*		Otherwise the SDO is managed till TimeOut. Return value is 0 on success and -1 on timeout.
*				If the SDO timed out, its SDO management object is killed.
* 9: Get SDO status, while killing the SDO if they are complete 
*	 [stat,data] = KvaserCom( 9, Index = all ) 
*	  stat : 0 = idle , 1 = active , -1 = aborted 
*		data: data if any was uploaded , or Abort code if aborted 
* 10: Same as 9, no kill
* 11: Kill all the SDO processes
* 20: Block download
* 21: block upload
* 32: Find slaves
* 
*
* 100: Program parameters
* 		[success,value] = KvaserCom( 3 , [ind , subind]) 
*			KvaserCom( 100 , [SleepBetweenConsecutives])  
*/
int BaudRate ; 
long  port ; 

canHandle GetValidPort(mxArray * px )
{ 
	int port = (int)GetWithDefault (px , 1, 0 ) ; 
	if ( (KvaserStr.Handle[port] < 0 ) || ( KvaserStr.LibOpened != 1 ) ) 
	{ 
		mexErrMsgTxt("Attempt to access services other than close/open without first opening \n");			
	}
	return KvaserStr.Handle[port] ; 
}

void mexFunction(int nlhs, mxArray *plhs[], 
				 int nrhs, const mxArray *prhs[])
{
	int OptionCode, kuku  ; 
	const mxArray * NextP ; 
	int stat; 
	int unsigned nId;
	int unsigned cnt , nact ;
    double ThreadID1[1]={1}; // ID of first Thread 
	float fdata ;
	int unsigned  n  , n1 , nL ;
	short unsigned crc;
	int MaxId , cntSdo ;
	mxChar * pChar ; 
	struct CMasterSdoStr *pSdo;
	long unsigned uldata;
	float fNum ;
	long lNum ;
	unsigned long * pL ;
	unsigned long ulNum ;
	unsigned long cobId , dataLen , flag   ; 
	DWORD time ;
	int nSend , IsLast , bcnt ;
	short unsigned crc16, nUnused;
	char NmtData[8];
	int IdVec[128]; 
	int VerVec[128] ; 
	canHandle handle ; 
	int unsigned nData; 
	double NextData; 
	union
	{
		long l; 
		unsigned long ul; 
		float f; 
	} u ;

	if ( nrhs < 1 || ( GetNumLen(prhs[0]) != 1 ) )  
	{ 
		mexErrMsgTxt("First Parameter of KVaserCom() must be the option code\n");
	} 
	
	OptionCode =  (int) mxGetPr( prhs[0])[0] ; 
	
	NextP = ( nrhs >= 2 ) ? prhs[1] : NULL ; 
	
	if ( OptionCode == 1 ) 
	{ 
		port = (int)GetWithDefault (NextP , 1, 0 ) ; 
		if (port < 0 || port > 1 ) 
		{ 
			mexErrMsgTxt("Port may be either 0 or 1 \n");
		} 

		if ( ( KvaserStr.LibOpened == 1 ) && (KvaserStr.Handle[port] >= 0 ) )
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
		
		if ( KvaserStr.Handle[1-port] == -1 ) 
		{
			if ( CloseKvaserLib() < 0 )   
			{
				mexErrMsgTxt("Could not close previous connection of KvaserCom \n");
			}
			//initialize CANlib
			canInitializeLibrary();
		}
		KvaserStr.Handle[port] = canOpenChannel( port , canOPEN_EXCLUSIVE ) ;
		if ( KvaserStr.Handle[port] < 0 ) 
		{
			mexErrMsgTxt( "Could not open Kvaser channel \n" ) ;
		}
		stat = (int) canSetBusParams(KvaserStr.Handle[port], BaudSymbols[KvaserStr.BaudSelect] , 0, 0, 0, 0, 0);
		if( stat != canOK )
		{
			CloseKvaserLib(); 
			sprintf( str , "Could not set the baud rate. Error = %d" , stat ) ;
			mexErrMsgTxt( str ) ;
		}
		KvaserStr.LibOpened = 1 ; 
		stat = (int) canBusOn(KvaserStr.Handle[port]);
		if( stat != canOK )
		{
			CloseKvaserLib(); 
			sprintf( str , "Could not enter BUS ON. Error = %d" , stat ) ;
			mexErrMsgTxt( str ) ;
		}

		SetThreadPriority(GetCurrentThread(), THREAD_PRIORITY_TIME_CRITICAL);
	
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
		port = (int)GetWithDefault (NextP , 1, 0 ) ; 
		handle = KvaserStr.Handle[port]; 
		if ( handle != -1 ) 
		{ 
			canBusOff(handle);
			canClose(handle);
		} 

		plhs[0] = mxCreateDoubleMatrix (1, 1, mxREAL);
		if ( KvaserStr.Handle[1-port] == -1 ) 
		{ 
			mxGetPr( plhs[0] )[0] = CloseKvaserLib() ;
			for ( cnt = 0 ; cnt < N_SDO ; cnt++ ) 
			{  // Kill all the SDO slaves 
				MasterSdoStr[cnt].State = 0 ; 
			} 
		} 
		else
		{ 
			mxGetPr( plhs[0] )[0] = 0 ;
		} 

		return ;
	}
	

	if (OptionCode == 32 )
	{ // Detect targets 
		handle = GetValidPort(NextP) ; 
		canFlushReceiveQueue(handle);
		canFlushTransmitQueue(handle);
		if (nrhs != 1)
		{
			mexErrMsgTxt("Use for target detection: KvaserCom( 32 )");
		}
		for (cnt = 0; cnt < 8; cnt++)
		{
			NmtData[cnt] = 0; 
		}
		NmtData[0] = 100; 
		stat = canWriteWait(handle, 0 , NmtData, 2, canMSG_STD, 100);

		n1 = 1000 ; 
		n = n1 ; 
		ftime(&start);
		kuku = 1;
		nId = 0; 
		while (n > 0)
		{
			n -= 1;

			ftime(&end);

			tdiff = end.millitm - start.millitm;
			if (end.time != start.time)
			{
				tdiff += 1000;
			}
			if (tdiff > (signed int)n1)
			{
				n = 0;
			}

			Sleep(kuku);

			nId = DealKvaserBoot(IdVec, VerVec , nId, 128);
		}

		plhs[0] = mxCreateDoubleMatrix(2, nId, mxREAL);
		
		for (cnt = 0; cnt < nId ; cnt++)
		{
			mxGetPr(plhs[0])[cnt*2] = IdVec[cnt];
			mxGetPr(plhs[0])[cnt*2+1] = VerVec[cnt];
		}

		return; 

	}


	if (OptionCode == 33 )
	{ // NMT node stop, stop all activity but SDO 
		handle = GetValidPort(NextP) ; 
		canFlushReceiveQueue(handle);
		canFlushTransmitQueue(handle);
		if (nrhs != 1)
		{
			mexErrMsgTxt("Use for target detection: KvaserCom( 32 )");
		}
		for (cnt = 0; cnt < 8; cnt++)
		{
			NmtData[cnt] = 0; 
		}
		NmtData[0] = 128; 
		stat = canWriteWait(handle, 0 , NmtData, 2, canMSG_STD, 100);	
		plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
		mxGetPr(plhs[0])[0] = 1 ; 
		
		return ;
	} 
	
	// Detect info of Kvaser unit
	if (OptionCode == 34 )
	{
		int KchannelCount ;
		char Kname[64];
		char Kean[32];
		int  Kserial;
		int c1 , Kcnt; 
		int Kstat = canGetNumberOfChannels(&KchannelCount);
		if ( Kstat <= 0 ) Kstat = 0 ; 
		plhs[0] = mxCreateDoubleMatrix(100,KchannelCount,  mxREAL);
		for ( Kcnt = 0; Kcnt < KchannelCount; Kcnt++) 
		{
			canGetChannelData(Kcnt, canCHANNELDATA_DEVDESCR_ASCII, Kname, sizeof(Kname));
			canGetChannelData(Kcnt, canCHANNELDATA_CARD_SERIAL_NO, &Kserial, sizeof(Kserial));
			canGetChannelData(Kcnt, canCHANNELDATA_CARD_UPC_NO, Kean, sizeof(Kean));
			mxGetPr(plhs[0])[100*Kcnt] = Kserial ;
			for ( c1 = 0 ; c1 < 64 ; c1++ ) 
			{ 
				mxGetPr(plhs[0])[100*Kcnt+1+c1] = Kname[c1] ;
			}				
			for ( c1 = 0 ; c1 < 32 ; c1++ ) 
			{ 
				mxGetPr(plhs[0])[100*Kcnt+65+c1] = Kean[c1] ;
			} 
		}	
		return ;		
	} 
		
	handle = GetValidPort(prhs[2]) ; 
		
	if (OptionCode == 21)
	{ // SDO block upload 

		canFlushReceiveQueue(handle);
		canFlushTransmitQueue(handle);
		if (nrhs < 2)
		{
			mexErrMsgTxt("Use: KvaserCom( 20 , [CobId,CobIdRet,Index,SubIndex,DataType,Ext=0,TimeOut=0]] , Port=0) \n");
		}
		
		cntSdo = 0;
		pSdo = &MasterSdoStr[cntSdo];
		NextP = prhs[1];
		pSdo->RxSdoId = (int)GetWithDefault(NextP, 0, -1);
		pSdo->TxSdoId = (int)GetWithDefault(NextP, 1, -1);
		pSdo->Index = (int)GetWithDefault(NextP, 2, -1);
		pSdo->SubIndex = (int)GetWithDefault(NextP, 3, -1);
		pSdo->DataType = (int)GetWithDefault(NextP, 4, -1);
		pSdo->Ext = (int)GetWithDefault(NextP, 5, 0);
		pSdo->TimeOut = GetWithDefault(NextP, 6, 0);
		pSdo->AbortCode = 0;

		MaxId = (pSdo->Ext ? 0x1fffffff : 0x7ff);

		if ((pSdo->TxSdoId < 0) || (pSdo->TxSdoId > MaxId) ||
			(pSdo->RxSdoId < 0) || (pSdo->TxSdoId > MaxId))
		{
			mexErrMsgTxt("Out of range TX ID or return ID \n");
		}
		if (pSdo->Index < 1 || pSdo->Index > 65535 || pSdo->SubIndex < 0 || pSdo->SubIndex > 255)
		{
			mexErrMsgTxt("Out of range Index or SubIndex \n");
		}
		if (pSdo->DataType > 1) //< 9 ) && (GetNumLen (prhs[2])!= 1 )  ) 
		{
			mexErrMsgTxt("Block service is only for long or float numbers \n");
		}

		// Initialize block upload
		pSdo->sdata[0] = 0xa4 ;
		pSdo->sdata[1] = (pSdo->Index & 0xff);
		pSdo->sdata[2] = ((pSdo->Index >> 8) & 0xff);
		pSdo->sdata[3] = pSdo->SubIndex;
		*(long*)&pSdo->sdata[4] =127;

		stat = canWriteWait(handle, pSdo->RxSdoId, (char*)pSdo->sdata,
			8, canMSG_STD, 100);

		// Get response 
		
		stat = canReadWaitSpecificCobId(handle, pSdo->TxSdoId, (char*)&pSdo->rdata[0], &dataLen, &flag, &time, 80);
		//stat = canReadWait(handle, &cobId, (char*)&pSdo->rdata[0], &dataLen, &flag, &time, 40);
		if (stat != canOK)
		{
			mexErrMsgTxt("Block upload initialize is not responded \n");
		}

		// Ask the KVASER instrument if there is anything 
		if ((pSdo->rdata[0] != 0xc6) || (pSdo->sdata[1] != pSdo->rdata[1]) || (pSdo->sdata[2] != pSdo->rdata[2]) || (pSdo->sdata[3] != pSdo->rdata[3]))
		{
			printMessageData(pSdo->rdata) ;  
			mexErrMsgTxt("Block download initialize response not as expected \n");
		}

		pSdo->StringLen = * ((long unsigned *) &pSdo->rdata[4] ) ; 
		if (pSdo->StringLen < 4 || pSdo->StringLen >= (2048 * 4))
		{
			mexErrMsgTxt("Block service is only for 1 to 2048 longs \n");
		}

		// 
		pSdo->nBlock = (int)((pSdo->StringLen) / USE_BLOCK_SIZE_B);
		pSdo->nLastBlock = pSdo->StringLen - pSdo->nBlock * USE_BLOCK_SIZE_B;

		// Assure a last block exists 
		if (pSdo->nLastBlock == 0 && pSdo->nBlock)
		{
			pSdo->nBlock = 0;
			pSdo->nLastBlock = USE_BLOCK_SIZE_B;
		}

		nSend = USE_BLOCK_SIZE_B;
		IsLast = 0;
		crc = 0xffff;
		pL = (unsigned long *)&BlockRxBuffer[0]; 
		for (bcnt = 0; bcnt < pSdo->nBlock; bcnt++)
		{
			if (FetchBlockBody(&pL, nSend >> 2, IsLast, &crc) < 0)
			{
				mexErrMsgTxt("Failed to fetch a block \n");
			}
		}

		IsLast = 1;
		if (FetchBlockBody(&pL, pSdo->nLastBlock >> 2, IsLast, &crc) < 0)
		{
			mexErrMsgTxt("Failed to fetch last block \n");
		}

		stat = canReadWaitSpecificCobId(handle, pSdo->TxSdoId,  (char*)&pSdo->rdata[0], &dataLen, &flag, &time, 80);
		//stat = canReadWait(handle, &cobId, (char*)&pSdo->rdata[0], &dataLen, &flag, &time, 10);
		if (stat != canOK)
		{
			mexErrMsgTxt("Block upload end is not responded \n");
		}
		if ((pSdo->rdata[0] & 0xe3) != 0xc1)
		{
			mexErrMsgTxt("Block upload end has incorrect header \n");
		}
		nUnused = (pSdo->rdata[0] >> 2) & 7; 
		crc16 = *(short unsigned*)&pSdo->rdata[1]; 

		if ( crc != crc16 )
		{
			mexErrMsgTxt("Block upload end has incorrect crc \n");
		}

		// End of block service 
		// Terminate block load 
		pSdo->sdata[0] = 0xa1;
		pSdo->sdata[1] = 0;
		pSdo->sdata[2] = 0;
		pSdo->sdata[3] = 0;
		*(long*)&pSdo->sdata[4] = 0;

		stat = canWriteWait(handle, pSdo->RxSdoId, (char*)pSdo->sdata,
			8, canMSG_STD, 100);

		// Data for return 
		nL = pSdo->StringLen >> 2; 
		plhs[0] = mxCreateDoubleMatrix(1, nL , mxREAL);
		GpL = (unsigned long *)BlockRxBuffer;
		Gpf = (float *)BlockRxBuffer;
		Gpd = mxGetPr(plhs[0]);
		if (pSdo->DataType == 0)
		{
			for (bcnt = 0; bcnt < (int) nL; bcnt++)
			{
				*Gpd++ = *GpL++; 
			}
		}
		else
		{
			for (bcnt = 0; bcnt < (int) nL; bcnt++)
			{
				*Gpd++ = *Gpf++;
			}
		}
		return;
	}

	if (OptionCode == 20)
	{ // SDO block download 

		canFlushReceiveQueue(handle) ; 
		canFlushTransmitQueue(handle) ; 
		if ( nrhs != 3 ) 
		{ 
			mexErrMsgTxt("Use: KvaserCom( 20 , [CobId,CobIdRet,Index,SubIndex,DataType,Ext=0,TimeOut=0], Data[0..]] ) \n");	
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
		if ( pSdo->DataType ) //< 9 ) && (GetNumLen (prhs[2])!= 1 )  ) 
		{ 
			mexErrMsgTxt("Block service is only for long numbers \n");	
		} 
		
		nL = (int) (mxGetN(prhs[2]) * mxGetM(prhs[2])); 
		pSdo->StringLen = nL * 4 ; // In bytes 
		if ( pSdo->StringLen < 2 || pSdo->StringLen > (2048*4)   )
		{ 
			mexErrMsgTxt("Block service is only for 2 to 2048 longs \n");	
		} 
		
		// Copy the string 
		pL = (unsigned long *) &pSdo->String[0] ; 
		pL0 = pL; 
		longcnt = 0; 
		inlongcnt = 0;
		for ( cnt = 0 ; cnt < nL ; cnt++ )
		{
			pL[cnt] = (long unsigned) mxGetPr(prhs[2])[cnt] ;  
		}

	// Initialize block download
		pSdo->sdata[0] = (6 << 5) + 6 ; 
		pSdo->sdata[1] = ( pSdo->Index & 0xff ) ;
		pSdo->sdata[2] = ( (pSdo->Index>>8) & 0xff ) ;
		pSdo->sdata[3] = pSdo->SubIndex ;
		* (long *) &pSdo->sdata[4] = pSdo->StringLen   ; 
		
		stat = canWriteWait(handle, pSdo->RxSdoId, (char *) pSdo->sdata, 
				8, canMSG_STD , 100  );

		// Wait response arrival 
		stat = canReadWait(handle, &cobId, (char *)&pSdo->rdata[0], &dataLen, &flag, &time, 60);
		if (stat != canOK)
		{
			mexErrMsgTxt("Block download initialize is not responded \n");
		}

		// Ask the KVASER instrument if there is anything 
		if  ( ( pSdo->rdata[0] != ((5 << 5) + 4 )) || ( pSdo->sdata[1] != pSdo->rdata[1]) || (pSdo->sdata[2] != pSdo->rdata[2]) || (pSdo->sdata[3] != pSdo->rdata[3]) || (pSdo->rdata[4] < USE_BLOCK_SIZE ) ) 
		{ 
			printMessageData(pSdo->rdata) ;  
			mexErrMsgTxt("Block download initialize response not as expected \n");
		}
		
		pSdo->nBlock = (int)((pSdo->StringLen ) / USE_BLOCK_SIZE_B ) ; 
		pSdo->nLastBlock = pSdo->StringLen - pSdo->nBlock * USE_BLOCK_SIZE_B ;
		
		// Assure a last block exists 
		if ( pSdo->nLastBlock == 0 && pSdo->nBlock )
		{ 
			pSdo->nBlock = 0 ;
			pSdo->nLastBlock = USE_BLOCK_SIZE_B;
		}

		nSend   = USE_BLOCK_SIZE_B ; 
		IsLast  = 0 ; 
		crc = 0xffff ; 
		for ( bcnt = 0 ; bcnt < pSdo->nBlock ; bcnt++)
		{
			if ( SendBlockBody( &pL, nSend >> 2 , IsLast , &crc ) < 0 ) 
			{ 
				mexErrMsgTxt("Failed to send a block \n");			
			}
		}

		IsLast = 1 ; 
		if ( SendBlockBody( &pL, pSdo->nLastBlock >> 2 , IsLast , &crc ) < 0 ) 
		{ 
				mexErrMsgTxt("Failed to send last block \n");			
		}

		// Terminate block load 
		pSdo->sdata[0] = (6 << 5) + 1 ; 
		pSdo->sdata[1] = (crc & 0xff ) ;
		pSdo->sdata[2] = ( (crc>>8) & 0xff ) ;
		pSdo->sdata[3] = 0 ;
		* (long *) &pSdo->sdata[4] = 0  ; 
		
		stat = canWriteWait(handle, pSdo->RxSdoId, (char *) pSdo->sdata, 
				8, canMSG_STD , 100  );

		stat = canReadWait(handle, &cobId, (char *)&pSdo->rdata[0], &dataLen, &flag, &time, 10 );
		if (stat != canOK)
		{
			mexErrMsgTxt("Block download end is not responded \n");
		}

		// Ask the KVASER instrument if there is anything 
		if (pSdo->rdata[0] != ((5 << 5)+1))
		{
			printMessageData(pSdo->rdata) ;  
			mexErrMsgTxt("Block download end response not as expected \n");
		}
		plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
		mxGetPr(plhs[0])[0] = 0 ;
		return;
	} 

	if (OptionCode == 7)
	{ // SDO download
/* 7: Set SDO for download (will start process, but not necessarily end it) 
*	[handle] = KvaserCom( 7 , [CobId,CobIdRet,Index,SubIndex,DataType,Ext=0,TimeOut=0], Data[0..]] ) 
*/
		canFlushReceiveQueue(handle) ; 
		canFlushTransmitQueue(handle) ; 
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
		

		switch (pSdo->DataType)
		{
		case 0: // Long 
			pSdo->Data = mxGetPr(prhs[2])[0];
			if (pSdo->Data > 4294967295.0 || pSdo->Data < -2147483648.0)
			{
				mexErrMsgTxt("Out of range  payload value \n");
			}
			if (pSdo->Data >= 2147483648.0)
			{
				pSdo->Data -= 4294967296;
			}
			uldata = (long unsigned)pSdo->Data;
			PutLongInString(uldata, (char unsigned*)&pSdo->sdata[4]);
			n = 4;
			break;
		case 1: // Float 
			pSdo->Data = mxGetPr(prhs[2])[0];
			if (pSdo->Data > 1.0e38 || pSdo->Data < -1.0e38)
			{
				mexErrMsgTxt("Out of range  payload value \n");
			}
			if (pSdo->Data < 1.0e-38 && pSdo->Data > -1.0e-38)
			{
				pSdo->Data = 0;
			}
			fdata = (float)pSdo->Data;
			uldata = *((long unsigned*)&fdata);
			PutLongInString(uldata, (char unsigned*)&pSdo->sdata[4]);
			n = 4;
			break;
		case 2: // Short 
			pSdo->Data = mxGetPr(prhs[2])[0];
			if (pSdo->Data > 65535.0 || pSdo->Data < -32768.0)
			{
				mexErrMsgTxt("Out of range  payload value \n");
			}
			if (pSdo->Data >= 32768.0)
			{
				pSdo->Data -= 65536;
			}
			uldata = (long unsigned)pSdo->Data;
			PutLongInString(uldata & 0xffff, (char unsigned*)&pSdo->sdata[4]);
			n = 2;
			break;
		case 3: // Character
			pSdo->Data = mxGetPr(prhs[2])[0];
			if (pSdo->Data > 255.0 || pSdo->Data < -128.0)
			{
				mexErrMsgTxt("Out of range  payload value \n");
			}
			if (pSdo->Data >= 128.0)
			{
				pSdo->Data -= 256;
			}
			uldata = (long unsigned)pSdo->Data;
			PutLongInString(uldata & 0xff, (char unsigned*)&pSdo->sdata[4]);
			n = 1;
			break;

		case 9:
			pChar = mxGetChars(prhs[2]); // String 
			if (pChar == NULL)
			{
				mexErrMsgTxt("Payload must be string \n");
			}
			pSdo->StringLen = (int)(mxGetN(prhs[2]) * mxGetM(prhs[2]));
			if (pSdo->StringLen < 1 || pSdo->StringLen > SDO_MAX_STR_LEN)
			{
				mexErrMsgTxt("Payload string length must be in [1..8192] \n");
			}
			n = pSdo->StringLen;
			if (n <= 4)
			{
				PutLongInString(0, (char unsigned*)&pSdo->sdata[4]);
				for (cnt = 0; cnt < n; cnt++)
				{
					pSdo->sdata[cnt + 4] = (char)pChar[cnt];
				}
			}
			else
			{
				for (cnt = 0; cnt < pSdo->StringLen; cnt++)
				{
					pSdo->String[cnt] = (char)pChar[cnt];
				}
			}
			break;

		case 10: //Vector of longs
			nData = (int unsigned) (mxGetM(prhs[2]) * mxGetN(prhs[2]));
			if (nData < 2)
			{
				mexErrMsgTxt("Please use the long data type - scalar version \n");
			}
			pSdo->StringLen = nData * 4;
			n = pSdo->StringLen;
			if (nData > 1024)
			{
				mexErrMsgTxt("Too long vector to send \n");
			}

			for (cnt = 0; cnt < nData ;cnt++)
			{
				NextData = mxGetPr(prhs[2])[cnt]; 
				if (NextData  > 4294967295.0 || NextData < -2147483648.0)
				{
					mexErrMsgTxt("Out of range  payload value \n");
				}
				if (NextData >= 2147483648.0)
				{
					NextData -= 4294967296;
				}
				u.l = (long)NextData; 
				PutLongInString(u.ul, &pSdo->String[cnt * 4]); 
			}
			break;
		case 11: //Vector of floats
			nData = (int unsigned) (mxGetM(prhs[2]) * mxGetN(prhs[2]));
			if (nData < 2)
			{
				mexErrMsgTxt("Please use the float data type - scalar version \n");
			}
			pSdo->StringLen = nData * 4;
			n = pSdo->StringLen;
			if (nData > 1024)
			{
				mexErrMsgTxt("Too long vector to send \n");
			}

			for (cnt = 0; cnt < nData; cnt++)
			{
				NextData = mxGetPr(prhs[2])[cnt];
				u.f = (float)NextData;
				PutLongInString(u.ul, &pSdo->String[cnt * 4]);
			}
		case 20: //Vector of unsigned longs

			nData = (int unsigned)(mxGetM(prhs[2]) * mxGetN(prhs[2]));
			if (nData < 2)
			{
				mexErrMsgTxt("Please use the long data type - scalar version \n");
			}
			pSdo->StringLen = nData * 4;
			n = pSdo->StringLen;
			if (nData > 1024)
			{
				mexErrMsgTxt("Too long vector to send \n");
			}

			for (cnt = 0; cnt < nData ; cnt++ )
			{
				NextData = mxGetPr(prhs[2])[cnt];
				if (NextData > 4294967295.0 || NextData < 0)
				{
					mexErrMsgTxt("Out of range  payload value \n");
				}
				u.ul = (long unsigned)NextData;
				PutLongInString(u.ul, &pSdo->String[cnt * 4]);
			}
			break;

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
		stat = canWrite(handle, pSdo->RxSdoId, (char *) pSdo->sdata, 
				8, (pSdo->Ext? canMSG_EXT :canMSG_STD)  );
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
		kuku = 1 ; 
		ftime(&start);
		
		
		while ( n > 0 ) 
		{
			n -= 1 ; 
			
			ftime(&end);
						
			tdiff = end.millitm - start.millitm;
			if ( end.time != start.time ) 
			{ 
				tdiff += 1000 ; 
			}
			if ( tdiff > (signed int) n1 ) 
			{
				n = 0 ; 
			} 
			
			Sleep(kuku);
			//kuku  = 0 ; 
			
			stat = DealKvaser() ; 
			if ( stat )
			{ 
				n = n1 ; 
				ftime(&start);
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
		canFlushReceiveQueue(handle) ; 
		canFlushTransmitQueue(handle) ; 
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
		stat = canWrite(handle, pSdo->RxSdoId, (char *) pSdo->sdata, 
				8, (pSdo->Ext? canMSG_EXT :canMSG_STD)  );

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
		
		ftime(&start);
		while ( n > 0   ) 
		{ 
			Sleep(1) ; 
			n -= 1 ; 
			
			ftime(&end);
						
			tdiff = end.millitm - start.millitm;
			if ( end.time != start.time ) 
			{ 
				tdiff += 1000 ; 
			}
			if ( tdiff > (signed int) n1 )
			{
				n = 0 ; 
			} 
			
			
			stat = DealKvaser() ; 
			if ( stat )
			{
				ftime(&start);
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




short AbortSdo (struct CMasterSdoStr * pSdo, long unsigned AbortCode , canHandle  handle  )
{
	long unsigned kaka ; 
	pSdo->State = -1 ; 
	kaka = (4<<5) + ( (long unsigned)pSdo->Index << 8 ) + ( (long unsigned)pSdo->SubIndex << 24 ); 
	PutLongInString( kaka , (char unsigned *)  SdoUploadMsg ) ; 
	PutLongInString( AbortCode , (char unsigned *)  &SdoUploadMsg[4] ) ; 
	canWrite(handle, pSdo->RxSdoId, (char *) SdoUploadMsg , 
						8, (pSdo->Ext? canMSG_EXT :canMSG_STD)  );
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
			canWrite(KvaserStr.Handle, pSdo->RxSdoId, (char *) SdoUploadMsg , 
				8, (pSdo->Ext? canMSG_EXT :canMSG_STD)  );
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
			canWrite(KvaserStr.Handle, pSdo->RxSdoId, (char *) SdoUploadMsg , 
				8, (pSdo->Ext? canMSG_EXT :canMSG_STD)  );

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

				canWrite(KvaserStr.Handle, pSdo->RxSdoId, (char *) SdoUploadMsg , 
					8, (pSdo->Ext? canMSG_EXT :canMSG_STD)  );
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
				canWrite(KvaserStr.Handle, pSdo->RxSdoId, (char *) SdoUploadMsg , 
					8, (pSdo->Ext? canMSG_EXT :canMSG_STD)  );
			} 

			break ; 
		} 
	} 
} 					


