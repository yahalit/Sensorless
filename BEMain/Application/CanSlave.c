/*
 * CanSlave.c
 *
 *  Created on: May 13, 2023
 *      Author: yahal
 */
#include "StructDef.h"




extern const struct CObjDictionaryItem ObjDictionaryItem [];



typedef  short unsigned u16 ;
typedef  char unsigned u8 ;





/**
 * \brief: Put record into CAN slave output queue
 *
 * \param pMsg-> Message to insert
 * \return 0 if ok, -1 if queue was full
 */
short PutCanSlaveQueue( struct CCanMsg * pMsg)
{
    short unsigned sr ;
    short unsigned Next ;
    short RetVal ;
    struct CCanQueue * pQueue ;

    pQueue = &CanSlaveOutQueue ;

    RetVal = 0 ;
    sr  = BlockInts() ;
    Next = ( pQueue->nPut + 1 ) & (pQueue->nQueue-1);
    if ( Next == pQueue->nGet )
    {
        RetVal =-1 ;
        pQueue->nGet  = ( pQueue->nGet  + 1 )& (pQueue->nQueue-1);
    }
    pQueue->Msg[pQueue->nPut] = *pMsg ;
    pQueue->nPut = Next ;
    RestoreInts(sr ) ;
    return RetVal ;
}

/**
 * \brief Prepare and send an SDO abort message for a given code
 *
 * \param Error code
  */
short AbortSlaveSdo( long unsigned code, struct CSdo * pSdo )
{
    struct CCanMsg  Msg ;
    pSdo->Status = -1 ; // Kill Sdo
    Msg.UseLongId = 0 ;
    Msg.cobId = ( 0xb << 7 ) + pSdo->SlaveID ;
    Msg.dLen = 8 ;
    Msg.data[0] = (4L<<5) + ( (long unsigned)pSdo->Index << 8 ) + ( (long unsigned)pSdo->SubIndex << 24 );
    Msg.data[1] = code ;
    SysState.BlockUpload.InBlockUload = 0 ;  // Terminate any SDO upload sequence in existence
    SysState.BlockDnload.InBlockDload = 0 ;
    return PutCanSlaveQueue( &Msg);
}

short SlaveSdoConfirmInitDload( struct CSdo *pSdo  )
{
    struct CCanMsg  Msg ;
    Msg.UseLongId = 0 ;
    Msg.cobId = ( 0xb << 7 )  + pSdo->SlaveID;
    Msg.dLen = 8 ;
    Msg.data[0] = (3L<<5) + ( (long unsigned)pSdo->Index << 8 ) + ( (long unsigned)pSdo->SubIndex << 24 );
    Msg.data[1] = 0 ;
    return PutCanSlaveQueue( &Msg);
}

short SlaveSdoConfirmInitDloadBlock( struct CSdo *pSdo  , long unsigned nBytes )
{
    struct CCanMsg  Msg ;
    unsigned short sr ;
    short stat ;
    SysState.BlockDnload.BlockDloadLen = nBytes ;
    if ((SysState.BlockDnload.BlockDloadLen & 0xffffc) !=  SysState.BlockDnload.BlockDloadLen  || ( SysState.BlockDnload.BlockDloadLen > 2048 * 4)  )
    {
        return AbortSlaveSdo ( Invalid_block_size , pSdo );
    }

    Msg.UseLongId = 0 ;
    Msg.cobId = ( 0xb << 7 )  + pSdo->SlaveID;
    Msg.dLen = 8 ;
    Msg.data[0] = (5L<<5) + 4 + ( (long unsigned)pSdo->Index << 8 ) + ( (long unsigned)pSdo->SubIndex << 24 );
    Msg.data[1] = 127 ; // Block length
    sr = BlockInts() ;
    stat =  PutCanSlaveQueue( &Msg);
    if ( stat == 0 )
    {
        SysState.BlockDnload.InBlockDload = 1;
    }
    RestoreInts(sr);
    return stat ;
}


short SlaveSdoConfirmInitUploadExpedit(struct CSdo * pSdo , long unsigned data , short unsigned n )
{
    struct CCanMsg  Msg ;
    Msg.UseLongId = 0 ;
    Msg.cobId = ( 0xb << 7 )  + pSdo->SlaveID;
    Msg.dLen = 8 ;
    Msg.data[0] = 0x43 + (((4-n )<<2) & 0xc )
            + (((long unsigned) pSdo->Index ) << 8 )
            + (((long unsigned) pSdo->SubIndex ) << 24 ) ;
    Msg.data[1] = data ;
    return PutCanSlaveQueue( &Msg);
}

short SlaveSdoConfirmInitUploadSegmented(struct CSdo * pSdo , short unsigned n )
{
    struct CCanMsg  Msg ;
    Msg.UseLongId = 0 ;
    Msg.cobId = ( 0xb << 7 )  + pSdo->SlaveID ;
    Msg.dLen = 8 ;
    Msg.data[0] = 0x41
    + (((long unsigned) pSdo->Index ) << 8 )
    + (((long unsigned) pSdo->SubIndex ) << 24 ) ;
    Msg.data[1] = (long unsigned) n  ;
    return PutCanSlaveQueue( &Msg);
}

short SlaveSdoConfirmInitUploadBlock(struct CSdo * pSdo , short unsigned n )
{
    struct CCanMsg  Msg ;
    short unsigned sr ;
    short stat ;
    Msg.UseLongId = 0 ;
    Msg.cobId = ( 0xb << 7 )  + pSdo->SlaveID ;
    Msg.dLen = 8 ;
    Msg.data[0] = 0xc6
    + (((long unsigned) pSdo->Index ) << 8 )
    + (((long unsigned) pSdo->SubIndex ) << 24 ) ;
    Msg.data[1] = (long unsigned) n  ;

    sr  = BlockInts() ;
    stat = PutCanSlaveQueue( &Msg);
    if  ( stat == 0 )
    {
        SysState.BlockUpload.StartBlockMsg.data[1] = n ;
        SysState.BlockUpload.pBuf = pSdo->SlaveBuf ;
        SysState.BlockUpload.InBlockUload = 1 ;
        SysState.BlockUpload.nBytes = n ;
    }
    RestoreInts(sr ) ;
    return stat ;
}



short SlaveSdoEndOfBlock (struct CSdo * pSdo )
{
    struct CCanMsg  Msg ;
    Msg.UseLongId = 0 ;
    Msg.cobId = ( 0xb << 7 )  + pSdo->SlaveID ;
    Msg.dLen = 8 ;
    Msg.data[0] = (0x5<<5)+1 ;
    Msg.data[1] = 0  ;
    return PutCanSlaveQueue( &Msg);
}

short SlaveSdoEndOfSubBlock (struct CSdo * pSdo )
{
    struct CCanMsg  Msg ;
    Msg.UseLongId = 0 ;
    Msg.cobId = ( 0xb << 7 )  + pSdo->SlaveID ;
    Msg.dLen = 8 ;
    Msg.data[0] = (0x5<<5)+2 + (SysState.BlockDnload.seqno<<8) + ( 127L << 16 )  ; ;
    Msg.data[1] = 0 ;
    SysState.BlockDnload.seqno = 0  ;
    return PutCanSlaveQueue( &Msg);
}




short SlaveSdoUploadSegmented(struct CSdo * pSdo )
{
    struct CCanMsg  Msg ;
    short unsigned remain , cnt  ;
    short unsigned * pload ;
    short unsigned * pdat  ;
    short unsigned odat ;
    short unsigned oload , next ;

    Msg.UseLongId = 0 ;
    Msg.cobId = ( 0xb << 7 )  + pSdo->SlaveID ;
    Msg.dLen = 8 ;

    remain = pSdo->Bytes2Dload - pSdo->ByteCnt ;

    if ( remain <= 7 )
    {
        Msg.data[0] = pSdo->toggle + 1 + ((7-remain)<<1) ;
        pSdo->Status = 0 ; // Gamarnu
    }
    else
    {
        Msg.data[0] = pSdo->toggle ;
        remain = 7 ;
    }
    Msg.data[1] = 0;
    pSdo->toggle = 0x10 - pSdo->toggle ;

    pdat = (short unsigned *) & Msg.data[0] ;
    odat = 1 ;
    pload = ((short unsigned*)SlaveSdoBuf) + ( pSdo->ByteCnt >> 1 ) ;
    oload = pSdo->ByteCnt & 1 ;
    for ( cnt = 0 ; cnt < remain ; cnt++ )
    {
        if ( oload )
        {
            next = *pload >> 8 ;
            oload = 0 ;
            pload += 1 ;
        }
        else
        {
            next = *pload & 0xff ;
            oload = 1 ;
        }

        if ( odat )
        {
            *pdat |= (next<<8) ;
            pdat += 1 ;
            odat = 0 ;
        }
        else
        {
            *pdat = next ;
            odat  = 1 ;
        }
    }
    pSdo->ByteCnt += remain ;
    return PutCanSlaveQueue( &Msg);
}


/**
 * \brief Add a new SDO data to buffer.
 *
 * \warning buf storage sufficiency is not checked, it is user responsibility
 * \param data: Data to add
 * \param Last: The number of bytes already filled into buf
 * \param NextBytes: The amount of bytes to insert
 * \param buf      : buffer to which we append the new bytes
 *
 * \return New amount of filled bytes in buffer
 */
struct CCanMsg  AddSdo2BufMsg ;
long unsigned AddSdo2Buf ( struct CSdo * pSdo , struct CCanMsg* pMsg )
{
    short unsigned remain , in_mess , cnt , c , t ;
    short unsigned * pload ;
    short unsigned * pdat  ;
    short unsigned odat ;
    short unsigned oload , next ;
    //short stat ;

    AddSdo2BufMsg.UseLongId = 0 ;
    AddSdo2BufMsg.cobId = ( 0xb << 7 )  + pSdo->SlaveID ;
    AddSdo2BufMsg.dLen = 8 ;

    t   = ( pMsg->data[0] & (1<<4) )  ;
    if ( t != SlaveSdo.toggle)
    {
        return Toggle_bit_not_alternated;
    }

    c = ((  pMsg->data[0] & 0x1 ) ? 1 : 0 ) ;

    if ( pSdo->ByteCnt > pSdo->Bytes2Dload)
    {
        return General_parameter_incompatibility_reason ;
    }

    remain = pSdo->Bytes2Dload - pSdo->ByteCnt ;
    in_mess = 7 - (( pMsg->data[0] >> 1 ) & 0x7 ) ;

    if ( in_mess > remain )
    {
        return General_parameter_incompatibility_reason ;
    }

    if ( c )
    {
        pSdo->Bytes2Dload = pSdo->ByteCnt + in_mess ;
        pSdo->Status = 0 ; // Gamarnu
    }



    AddSdo2BufMsg.data[0] = pSdo->toggle + (1<<5) ;
    AddSdo2BufMsg.data[1] = 0;
    pSdo->toggle = 0x10 - pSdo->toggle ;

    pdat = (short unsigned *) & pMsg->data[0] ;
    odat = 1 ;
    pload = ((short unsigned*)SlaveSdoBuf) + ( pSdo->ByteCnt >> 1 ) ;
    oload = pSdo->ByteCnt & 1 ;

    for ( cnt = 0 ; cnt < in_mess ; cnt++ )
    {
        if ( odat )
        {
            next = (*pdat) >> 8 ;
            odat = 0 ;
            pdat += 1 ;
        }
        else
        {
            next = *pdat & 0xff ;
            odat = 1 ;
        }
        if ( oload )
        {
            *pload |= (next<<8) ;
            pload += 1 ;
            oload = 0 ;
        }
        else
        {
            *pload = next ;
            oload  = 1 ;
        }
    }
    pSdo->ByteCnt += in_mess ;
    return 0 ;
}



/**
 * \brief Very limited CAN slave, purposed for debugging only
 *
 * \detail CAN ID is 124 (LP) or 126 (PD)
 *         Most of the objects are very simple expedit type downloads
 *
 *         Set commands normally replicate the code mode and index
 *         They return the response code as long.
 *
 *
 */
void CanSlave (void)
{
    short unsigned sr , next , restart, mask  ;
    short unsigned CobType ;
    short unsigned cs , exp , n , s     ;
    long  stat ;
    long unsigned ustat , nmtsamp;
    struct CCanMsg  Msg ;
    struct CSdo * pSdo ;
    struct CObjDictionaryItem *pOdObject ;

    pSdo = & SlaveSdo ;


    // Get NMT
    restart = 0 ;

    if  (SysState.MCanSupport.bAutoBlocked)
    {
        nmtsamp = 0 ;
        SysState.MCanSupport.uNMTRx.ul[1] = 0 ;
    }
    else
    {
        mask = BlockInts() ;
        nmtsamp = SysState.MCanSupport.uNMTRx.ul[1] ;
        SysState.MCanSupport.uNMTRx.ul[1] = 0 ;
        RestoreInts(mask) ;
    }
    while ( nmtsamp )
    {
        next = nmtsamp & 0xff  ;
        if ( next  )
        {
            switch ( next)
            {
            case 1:
                // Start remote node
                SysState.MCanSupport.NodeStopped = 0 ;
                break ;
            case 2:
                // Stop remote node
                SysState.MCanSupport.NodeStopped = 1 ;
                restart = 1;
                break ;
            case 100:
                restart = 5 ;
                break ;
            case 128:
                // Enter pre-operational (no sync or PDO)
                SysState.MCanSupport.NodeStopped = 2 ;
                break ;
            case 129:
                // Reset node .. verify watch-dog on, turn of motor, and good night
                SafeSetMotorOff() ;
                SysCtl_enableWatchdog() ;
                for(; ; ) ;
            case 130:
                // Reset communication
                restart = 3 ;
                SafeSetMotorOff() ;
#ifdef ON_BOARD_CAN
                setupMCAN();
                SetSysTimerTargetSec ( TIMER_MCAN_BUSOFF , BUS_OFF_RECOVERY_TIME ,  &SysTimerStr  );
#endif
            }
        }
        nmtsamp >>= 8 ;
    }

    if ( restart )
    {
        mask = BlockInts() ;
        SlaveSdo.Status = 0 ;
        CanSlaveInQueue.nPut = 0 ;
        CanSlaveInQueue.nGet = 0 ;
        SysState.MCanSupport.PdoDirtyBoard = 0 ;
        CanSlaveOutQueue.nGet = 0 ;
        CanSlaveOutQueue.nPut = 0 ;
        RestoreInts(mask) ;
        if ( restart & 2)
        {
            SetBootUpMessage() ;
        }
        if ( restart & 4)
        {
            SetExtendedBootUpMessage() ;
        }
    }


    if ( SlaveSdo.Status == 100  )
    { // SDO block dload
        if ( SysState.BlockDnload.emcy  )
        {
            AbortSlaveSdo(  SysState.BlockDnload.emcy ,  &SlaveSdo);
        }
        if ( SysState.BlockDnload.bEndOfBlockTransmission )
        {
            SysState.BlockDnload.InBlockDload = 0 ; // end RT service
            SlaveSdo.Status = 1000 ;
        }
        if (SysState.BlockDnload.bSendEndOfBlock)
        {
            SlaveSdoEndOfSubBlock( &SlaveSdo  );
            SysState.BlockDnload.bSendEndOfBlock = 0 ; // Mark end of use
        }
    }


    if ( CanSlaveInQueue.nPut == CanSlaveInQueue.nGet)
    {
        return ;
    }
    else
    {
        sr  = BlockInts() ;
        Msg = CanSlaveInQueue.Msg[CanSlaveInQueue.nGet] ;
        CanSlaveInQueue.nGet = ( CanSlaveInQueue.nGet + 1 )  & (CanSlaveInQueue.nQueue-1) ;
        RestoreInts(sr ) ;
    }

    CobType = (short unsigned) ( (Msg.cobId & 0x7fffffff ) >> 7) ;

    // SDO
    if ( CobType == 0xc ) // 0xc is SDO RX , 0xb is SDO TX
    {

        if ( SysState.BlockDnload.InBlockDload )
        { // Got confirmation for service , just proceed
            DealBlockDloadRt(&Msg) ;
            return ;
        }


        if ( SlaveSdo.Status <= 0 )
        { // Waiting start of new SDO
            cs = ( Msg.data[0] & 0xe0 ) >> 5 ;
            exp = ( Msg.data[0] & 0x2 ) >> 1 ;
            n   = ( Msg.data[0] & 0xc ) >> 2 ;
            s   = (short unsigned) ( Msg.data[0] & 0x1 ) ;
            SlaveSdo.Index = ( Msg.data[0] >> 8 ) & 0xffff ;
            SlaveSdo.SubIndex = ( Msg.data[0] >> 24 ) & 0xff  ;
            SlaveSdo.toggle = 0 ;
            SlaveSdo.SlaveID  = Msg.cobId & 0x8000007f ;

            if ( GetObjIndex(SlaveSdo.Index , & pOdObject , ObjDictionaryItem ) < 0 )
            {
                AbortSlaveSdo ( Object_does_not_exist_in_the_object_dictionary , &SlaveSdo);
                return ;
            }

            // If previous SDO terminated by error , forget it
            SlaveSdo.Status = 0 ;

            switch ( cs)
            {
            case 1: // Download SDO
                if ( SysState.BlockDnload.InBlockDload )
                { // Abort the block upload
                    AbortSlaveSdo ( Invalid_sequence_number, &SlaveSdo );
                }

                // Initiate download
                if ( pOdObject->SetFunc == (SetDictFunc) 0  )
                {
                    AbortSlaveSdo ( Unsupported_access_to_an_object , &SlaveSdo);
                    return ;
                }
                if (exp)
                {
                    SlaveSdoBuf[0] = Msg.data[1] ;
                    /*
                    if ( s && ((4-n) != pOdObject->bytelen ) )
                    {
                        AbortSlaveSdo ( length_of_service_parameter_does_not_match );
                        return ;
                    }
                    */
                    if ( s == 0 )
                    {
                        n = 4 - pOdObject->bytelen ;
                    }
                    stat = pOdObject->SetFunc(&SlaveSdo,4-n) ;
                    if ( stat )
                    {
                        if ( stat != ReturnNotExpected )
                        {
                            AbortSlaveSdo( stat, &SlaveSdo );
                        }
                        return ;
                    }
                }
                else
                {
                    if ( s  )
                    {
                        SlaveSdo.Bytes2Dload = (unsigned short) Msg.data[1] ;
                        if ( SlaveSdo.Bytes2Dload > ( 4 * sizeof( SlaveSdoBuf) - 1 ))
                        {
                            AbortSlaveSdo( Out_of_memory, &SlaveSdo);
                            return ;
                        }
                    }
                    else
                    {// Size not specified: allow maximum
                        SlaveSdo.Bytes2Dload =  4 * sizeof( SlaveSdoBuf) - 1 ;
                    }
                    SlaveSdo.ByteCnt = 0; // Nothing sent yet
                    SlaveSdo.Status = 1 ; // Go to the download stage
                    SlaveSdo.ExpectedCs = 0; // Next code sequence should be 3
                }
                SlaveSdoConfirmInitDload(&SlaveSdo ) ;
                break ;
            case 2: // Upload SDO
                // Initiate upload
                if ( SysState.BlockUpload.InBlockUload )
                { // Abort the block upload
                    AbortSlaveSdo ( Invalid_sequence_number, &SlaveSdo );
                }

                if ( pOdObject->GetFunc == (GetDictFunc) 0  )
                {
                    AbortSlaveSdo ( Unsupported_access_to_an_object , &SlaveSdo);
                    return ;
                }

                stat = pOdObject->GetFunc(&SlaveSdo,&n) ;
                if ( stat )
                {
                    AbortSlaveSdo( stat , &SlaveSdo);
                    return ;
                }
                SlaveSdo.Bytes2Dload = n ;

                // Slave SDO function did not export any message. It simply wrote n bytes
                // into SlaveSdoBuf. We next have to decide if expedit it.
                if ( n <= 4)
                { // That will be expedit
                    SlaveSdoConfirmInitUploadExpedit(&SlaveSdo,SlaveSdoBuf[0],n) ;
                    SlaveSdo.Status = 0 ; // Go to the download stage
                }
                else
                { // That will be segmented
                    // Object for recorder fast upload
                    SlaveSdoConfirmInitUploadSegmented(&SlaveSdo,n) ;
                    SlaveSdo.Status = 1 ; // Go to the download stage
                    SlaveSdo.ByteCnt = 0 ;
                    SlaveSdo.toggle = 0;
                    SlaveSdo.ExpectedCs = 3;
                }

                break ;

            case 5:
                if ( pOdObject->Index == 0x2006)
                { // Fast recorder - block upload
                    if (  ( Msg.data[0] & 0xff ) != 0xa4 )
                    {
                        AbortSlaveSdo( General_parameter_incompatibility_reason, &SlaveSdo);
                    }
                    stat = pOdObject->GetFunc(&SlaveSdo,&n) ;
                    if ( stat )
                    {
                        AbortSlaveSdo( stat , &SlaveSdo);
                        return ;
                    }
                    SlaveSdoConfirmInitUploadBlock(&SlaveSdo,n) ;
                }
                else
                {
                    AbortSlaveSdo( General_parameter_incompatibility_reason,&SlaveSdo);
                }
                break ;

            case 6: // Download block SDO
                SlaveSdo.Status = 100 ; // Go to the download stage
                SlaveSdo.ByteCnt = 0 ;
                SlaveSdo.toggle = 0;
                SlaveSdo.ExpectedCs = 5;
                SysState.BlockDnload.nextBlockLong = 0 ;
                SysState.BlockDnload.blockdatano = 0 ;
                //SysState.BlockDnload.BlockDloadLen = Msg.data[1] ;
                SysState.BlockDnload.inlongcnt   = 0 ;
                SysState.BlockDnload.longcnt = 0;
                SysState.BlockDnload.seqno = 0 ;
                SysState.BlockDnload.emcy  = 0 ;
                SysState.BlockDnload.crc   = 0xffff ;
                SysState.BlockDnload.bSendEndOfBlock = 0 ;
                SysState.BlockDnload.bEndOfBlockTransmission = 0 ;
                SlaveSdoConfirmInitDloadBlock(&SlaveSdo,Msg.data[1]) ;
                break ;

            default:
                // Could not identify SDO state or match ccs
                AbortSlaveSdo( General_parameter_incompatibility_reason, &SlaveSdo);
            }
            return ;
        }

        if ( SlaveSdo.Status == 100  )
        {
            if ( SysState.BlockDnload.emcy  )
            {
                AbortSlaveSdo(  SysState.BlockDnload.emcy ,  &SlaveSdo);
            }
            if ( SysState.BlockDnload.bEndOfBlockTransmission )
            {
                SysState.BlockDnload.InBlockDload = 0 ; // end RT service
                SlaveSdo.Status = 1000 ;
            }
            if (SysState.BlockDnload.bSendEndOfBlock)
            {
                SlaveSdoEndOfSubBlock( &SlaveSdo  );
                SysState.BlockDnload.bSendEndOfBlock = 0 ; // Mark end of use
            }
        }

        if ( SlaveSdo.Status == 1000  )
        { // Wait end of download
            if ( (Msg.data[0] & 0xff ) != ((6<<5)+1) )
            {
                AbortSlaveSdo( Client_server_command_specifier_not_valid_or_unknown, &SlaveSdo);
                return ;
            }
            if ( SysState.BlockDnload.crc != (( Msg.data[0] >> 8 ) & 0xfffff ) )
            {
                AbortSlaveSdo( crc_error, &SlaveSdo);
                return ;
            }
            SlaveSdo.Status  = 0 ;

            if ( GetObjIndex(SlaveSdo.Index , & pOdObject, ObjDictionaryItem ) < 0 )
            {
                AbortSlaveSdo ( Object_does_not_exist_in_the_object_dictionary , &SlaveSdo);
                return ;
            }

            stat = pOdObject->SetFunc(&SlaveSdo,(unsigned short) SysState.BlockDnload.BlockDloadLen) ;
            if ( stat )
            {
                AbortSlaveSdo( stat , &SlaveSdo);
                return ;
            }

            SlaveSdoEndOfBlock( &SlaveSdo  );

            return ;
        }

        if ( SlaveSdo.Status == 1  )
        { // Already within a segmented download SDO
            cs = ( Msg.data[0] & 0xe0 ) >> 5 ;
            if ( cs != SlaveSdo.ExpectedCs  )
            {
                AbortSlaveSdo(Client_server_command_specifier_not_valid_or_unknown, &SlaveSdo) ;
                return ;
            }

            switch ( cs)
            {
            case 0:
            // SDO segmented download

                ustat = AddSdo2Buf ( pSdo , &Msg ) ;
                if ( ustat )
                {
                    AbortSlaveSdo( ustat , &SlaveSdo);
                    return ;
                }

                if ( pSdo->Status == 0  )
                {
                    if ( GetObjIndex(SlaveSdo.Index , & pOdObject , ObjDictionaryItem ) < 0 )
                    {
                        AbortSlaveSdo ( Object_does_not_exist_in_the_object_dictionary, &SlaveSdo );
                        return ;
                    }
                    stat = pOdObject->SetFunc(&SlaveSdo,SlaveSdo.ByteCnt) ;
                    if ( stat )
                    {
                        AbortSlaveSdo( stat, &SlaveSdo);
                    }
                    else
                    {
                        PutCanSlaveQueue( &AddSdo2BufMsg);
                    }
                }
                else
                {
                        PutCanSlaveQueue( &AddSdo2BufMsg);
                }
                break;
            case 3:
                // SDO segmented upload
                SlaveSdoUploadSegmented( &SlaveSdo  );
                break ;
            default:
                // Could not identify SDO state or match ccs
                AbortSlaveSdo( General_parameter_incompatibility_reason, &SlaveSdo);
            }
            return ;
        }
        // Could not identify SDO state or match ccs
        AbortSlaveSdo( General_parameter_incompatibility_reason, &SlaveSdo);
    }
}

/**
 * \brief Get size of object dictionary
  * \detail This function is here because only in the scope of this file the size of
 * the object dictionary is known
 */
short unsigned GetOdSize( void )
{
    extern const short unsigned SizeofObjDict ;
    return SizeofObjDict ; // sizeof(ObjDictionaryItem)/sizeof(struct CObjDictionaryItem) ;
}




