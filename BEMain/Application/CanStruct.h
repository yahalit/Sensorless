/*
 * CanStruct.h
 *
 *  Created on: Jun 26, 2023
 *      Author: yahal
 */

#ifndef APPLICATION_CANSTRUCT_H_
#define APPLICATION_CANSTRUCT_H_


/**
Struct to describe a CAN message
NEVER CHANGE THE ARRANGEMENT OF ITEMS IN THIS STRUCT !!!!!
*/
struct CCanMsg
{
    long unsigned data[2] ; //!< Data payload.
    long unsigned cobId   ;  //!< The ID (short or long )
    short dLen ;    //!< Data length (amount of valid bytes in data[]
    short UseLongId     ;  //!< Flag: 1 - use long ID (29 bit)
} ;

#define N_SLAVE_QUEUE 16
struct CCanQueue
{
    struct CCanMsg Msg[N_SLAVE_QUEUE]; //!< The message queue
    short  unsigned nPut ;   //!< Where to put
    short  unsigned nGet ;   //!< Wait for fetch
    short  unsigned nQueue ; //!< Number of entries in queue , must be 2^(integer)
};

#define N_EMCY_QUEUE 4
struct CEmergencyRecord
{
    short unsigned EmcyCode ;
    short unsigned ErrorReg ;
    long  unsigned SpecificError ;
    long unsigned  EmcyCtr ; //!< Reflection of total emcy counter
};

struct CEmergencyLog
{
    struct CEmergencyRecord EmergencyRecord[N_EMCY_QUEUE] ;
    short unsigned nPut ;
    short unsigned nGet ;
    long  unsigned EmcyCtr ; //!< Total emergency counter
    long unsigned SpecificError ; //!<Manufacturer specific error
};

struct CSdo
{
    long unsigned  SlaveID; //!< The slave to which the SDO is targeted (or own ID if this id slave)
    short unsigned Index;
    short unsigned SubIndex;
    long  unsigned Lpayload;
    short Status; //!< 0 inactive, 1 continuing, -1 aborted
    short unsigned toggle; //!< Toggle state for SDO segmented
    short unsigned Bytes2Dload; // !< Bytes remaining to download by SDO
    short unsigned DataType; //!< Cia DATA type - 5: Byte , 6: Word , 7: Long
    short unsigned ByteCnt; //!< Byte count for segmented SDO
    short unsigned ExpectedCs; // !< Expected command specifier for the next transaction
    short unsigned TrapCobId ; // The COB id trapped in return
    short unsigned Algn ;
    long  unsigned *SlaveBuf; // !< Address of communication string in use
    long  unsigned AbortCode; // !< The code of abortion if relevant
};

struct CObjDictionaryItem
{
    short Index  ;
    short bytelen ;
    long unsigned  (*SetFunc)( struct CSdo * pSdo ,short unsigned nData) ;
    long unsigned  (*GetFunc)( struct CSdo * pSdo ,short unsigned *nData)  ;
};
typedef long unsigned  (*SetDictFunc)( struct CSdo * pSdo ,short unsigned  nData);
typedef long unsigned  (*GetDictFunc)( struct CSdo * pSdo ,short unsigned *nData);


struct CBlockDnload
{
    short unsigned InBlockDload ;
    short unsigned crc ;
    short unsigned cv[7] ;
    long BlockDloadLen ;
    short unsigned seqno ;
    short unsigned bSendEndOfBlock ;
    short unsigned bEndOfBlockTransmission ;
    short unsigned blockdatano ;
    long unsigned nextBlockLong ;
    short unsigned inlongcnt  ;
    long  unsigned longcnt  ;
    long unsigned emcy ;
};



struct CBlockUpload
{
    short unsigned InBlockUload ;
    short unsigned nBytes       ;
    short unsigned SeqNo  ;
    short unsigned BytesTransmitted  ;
    short unsigned crc ;
    short unsigned BytesEmptyAtEnd ;
    long  unsigned *pBuf ;
    long  emcy ;
    struct CCanMsg StartBlockMsg ;
    struct CCanMsg InBlockMsg;
    struct CCanMsg EndBlockMsg;
    struct CCanMsg AbortBlockMsg ;
};


#endif /* APPLICATION_CANSTRUCT_H_ */
