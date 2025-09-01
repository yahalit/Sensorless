/*
 * SealCommService.c
 *
 *  Created on: 27 באוג׳ 2025
 *      Author: Yahali
 */


/*
 * PrjMCAN.c
 *
 *  Created on: 3 MAY 2025
 *      Author: Yahali
 */




/*
 * MCanDrv.c
 *
 *  Created on: Jun 26, 2023
 *      Author: yahal
 */

#include "..\Application\StructDef2.h"



#define MCAN_RAM_LONG_PTR_INC 2

#define NUM_OF_MSG                    (7U)  // Must be 2^N-1
#define MCAN_STD_ID_FILT_START_ADDR   (0U)
//#define MCAN_STD_ID_FILTER_NUM        (4U)
#define MCAN_EXT_ID_FILT_START_ADDR   (4U)
//#define MCAN_EXT_ID_FILTER_NUM        (4U)

#define MCAN_FIFO_1_START_ADDR        (2560U)  // (64 + 18 * 16 + 18 * 16 ) * 4
#define MCAN_FIFO_1_NUM               (NUM_OF_MSG)
#define MCAN_FIFO_1_WATERMARK         (NUM_OF_MSG)

#define MCAN_FIFO_0_START_ADDR        (1408U) // (64 + 18 * 16  ) * 4
#define MCAN_FIFO_0_NUM               (NUM_OF_MSG)  // Must be 2^N-1
#define MCAN_FIFO_0_WATERMARK         (NUM_OF_MSG)

#define MCAN_TX_BUFF_START_ADDR       (256U) // 64 * 4
#define MCAN_TX_BUFF_SIZE             (NUM_OF_MSG)  // Must be 2^N-1


//#define MCANA_MSG_RAM_BASE        0x00058000U
#define MCAN1_BASE MCANA_MSG_RAM_BASE

const short SpaceForElementSizeInLongs[8] = {4 , 5 , 6 , 7 , 8 , 10 , 14 , 18 } ;
const short Dlc2Len[16] = {0,1,2,3,4,5,6,7,8,12,16,20,32,18,48,64} ;



short unsigned IsTemperatureReport ;



short unsigned dLen2Dlc(short unsigned l )
{
    if ( l <= 8 )
    {
        return l ;
    }
    if ( l <= 24 )
    {
        return ((l >> 2) + 6 ) ;
    }
    return (((l>>4)+11) & 0xf )  ;
}


volatile long unsigned rmw ;

short unsigned IsValidCanId ( short unsigned id , short unsigned mask)
{
    if ( (mask | id)  & ~0x3ff )
    {
        return 0 ;
    }
    return 1 ;
}
short unsigned IsValidExtCanId ( long unsigned id , long unsigned mask)
{
    if ( (mask | id)  & ~0x1ffffffffUL )
    {
        return 0 ;
    }
    return 1 ;
}

void setupMCAN2(long unsigned CanId[], long unsigned CanIDMask[] ,  long unsigned ExtCanId[], long unsigned ExtCanIDMask[] )
{
    short unsigned cnt,n ,m ;
    MCAN_InitParams            initParams;
    MCAN_MsgRAMConfigParams    msgRAMConfigParams;
    MCAN_BitTimingParams       bitTimes;
    MCAN_StdMsgIDFilterElement stdFiltelem;
    MCAN_ExtMsgIDFilterElement ExtFiltelem;
    MCAN_GlobalFiltConfig      filter_config_obj;

    ClearMem((short unsigned *)&initParams , sizeof(initParams));
    ClearMem((short unsigned *)&msgRAMConfigParams , sizeof(msgRAMConfigParams));
    ClearMem((short unsigned *)&bitTimes , sizeof(bitTimes));
    ClearMem((short unsigned *)&stdFiltelem , sizeof(stdFiltelem));
    ClearMem((short unsigned *)&filter_config_obj , sizeof(filter_config_obj));


//    MCAN_ConfigParams          config_params;     // Reserve
//    MCAN_RxBufElement          rxMsg1;            // Reserve

    filter_config_obj.anfs = 1;

//    config_params.filterConfig = filter_config_obj;   // Reserve

    //
    // Configure the divisor for the MCAN bit-clock
    //
    // SysCtl_setMCANClk(SYSCTL_MCANB,SYSCTL_MCANCLK_DIV_5);

    // Initialize MCAN Init parameters.
    //
    //
    initParams.fdMode            = 0 ; // 0x1U; // FD operation enabled. // FD change: Was 0,0
    initParams.brsEnable         = 0 ; // x1U; // Bit rate switching for
                                         // transmissions enabled.

    initParams.wkupReqEnable  = 1 ;
    initParams.autoWkupEnable = 1 ;
    initParams.emulationEnable = 1 ;


    // Transmitter Delay Compensation parameters.
    //
    initParams.tdcConfig.tdcf    = 0xAU;
    initParams.tdcConfig.tdco    = 0x6U;

    //
    // Initialize Message RAM Sections Configuration Parameters for Rx
    //
    msgRAMConfigParams.flssa                = MCAN_STD_ID_FILT_START_ADDR;

    // Standard ID Filter List Start Address (0).
    n = 0  ;
    for ( cnt = 0; cnt < 4 ; cnt++)
    {
        n+=IsValidCanId ( CanId[cnt], CanIDMask[cnt]) ;
    }

    msgRAMConfigParams.lss  = n;
    // Standard ID Filter List Size (1).

    msgRAMConfigParams.flesa = MCAN_EXT_ID_FILT_START_ADDR ;
    m = 0  ;
    for ( cnt = 0; cnt < 4 ; cnt++)
    {
        m+=IsValidCanId ( ExtCanId[cnt], ExtCanIDMask[cnt]) ;
    }
    msgRAMConfigParams.lse  =  m;

    if ( (m == 0) && ( n == 0 ) )
    {
        return ; // Nothing, no point ni CAN setup
    }

    msgRAMConfigParams.rxFIFO0startAddr     = MCAN_FIFO_0_START_ADDR;

    // Rx FIFO1 Start Address (748U).
    msgRAMConfigParams.rxFIFO0size          = MCAN_FIFO_0_NUM;
    // Number of Rx FIFO elements (1).
    msgRAMConfigParams.rxFIFO0waterMark     = MCAN_FIFO_0_WATERMARK;
    // Level for Rx FIFO 1 watermark interrupt (1).
    msgRAMConfigParams.rxFIFO0OpMode        = 0U;
    // FIFO overwriting mode.
    msgRAMConfigParams.rxFIFO0ElemSize      = MCAN_ELEM_SIZE_64BYTES;
    // Rx FIFO1 Element Size. RBDS field of MCAN_RXESC Register

    /*
    msgRAMConfigParams.rxFIFO1startAddr     = MCAN_FIFO_1_START_ADDR;
    // Rx FIFO1 Start Address (748U).
    msgRAMConfigParams.rxFIFO1size          = MCAN_FIFO_1_NUM;
    // Number of Rx FIFO elements (1).
    msgRAMConfigParams.rxFIFO1waterMark     = MCAN_FIFO_1_WATERMARK;
    // Level for Rx FIFO 1 watermark interrupt (1).
    msgRAMConfigParams.rxFIFO1OpMode        = 0U;
    // FIFO overwriting mode.
    msgRAMConfigParams.rxFIFO1ElemSize      = MCAN_ELEM_SIZE_64BYTES;
    // Rx FIFO1 Element Size. RBDS field of MCAN_RXESC Register
    */

    //
    // Initialize Message RAM Sections Configuration Parameters
    //
    msgRAMConfigParams.txStartAddr          = MCAN_TX_BUFF_START_ADDR ;
    // Tx Buffers Start Address.
    msgRAMConfigParams.txBufNum             = MCAN_TX_BUFF_SIZE;
    // Number of Dedicated Transmit Buffers.
    msgRAMConfigParams.txBufMode            = 1U; // Queue , not FIFO
    msgRAMConfigParams.txBufElemSize        = MCAN_ELEM_SIZE_64BYTES;
    // Tx Buffer Element Size.


    //
    // Initialize bit timings.
    // These values are for 0.5M
    // 40MH / (3+1) = 10MHz after prescale
    // Bit time = 8 + 9 + 3 = 20  so 10/20 = 0.5
    bitTimes.nomRatePrescalar   = 0x3U; // Nominal Baud Rate Pre-scaler.
    bitTimes.nomTimeSeg1        = 0x9U; // Nominal Time segment before SP
    bitTimes.nomTimeSeg2        = 0x8U; // Nominal Time segment after SP
    bitTimes.nomSynchJumpWidth  = 0x8U; // Nominal SJW

    // Data phase: 2 Mbps with BRS
    // Keep DBRP=1 -> 40 MHz / (1+1) = 20 MHz tq clock
    // Need 10 TQ/bit: 1 + TSEG1 + TSEG2 = 10  -> TSEG1=7, TSEG2=2 (≈80% SP)
    // Encoded fields are "minus one".
    bitTimes.dataRatePrescalar  = 0x1U; // DBRP (BRP-1)  => BRP=2
    bitTimes.dataTimeSeg1       = 0x6U; // DTSEG1 (TSEG1-1) => TSEG1=7
    bitTimes.dataTimeSeg2       = 0x1U; // DTSEG2 (TSEG2-1) => TSEG2=2
    bitTimes.dataSynchJumpWidth = 0x1U; // DSJW  (SJW-1)    => SJW=2

    // Bit time = 20M / 20 = 1M NBD
    //bitTimes.dataRatePrescalar  = 0x1U; // Data Baud Rate Pre-scaler.
    //bitTimes.dataTimeSeg1       = 0x9U; // Data Time segment before SP
    //bitTimes.dataTimeSeg2       = 0x8U; // Data Time segment after SP
    //bitTimes.dataSynchJumpWidth = 0x8U; // Data SJW

    setupGpioCAN() ;

    //
    // Wait for memory initialization to happen.
    //
    while(false == MCAN_isMemInitDone(MCAN1_BASE))
    {
    }

    //
    // Put MCAN in SW initialization mode.
    //
    MCAN_setOpMode(MCAN1_BASE, MCAN_OPERATION_MODE_SW_INIT);

    //
    // Wait till MCAN is not initialized.
    //
    while (MCAN_OPERATION_MODE_SW_INIT != MCAN_getOpMode(MCAN1_BASE))
    {}

    //
    // Initialize MCAN module.
    //
    MCAN_init(MCAN1_BASE, &initParams);

    //
    // Configure Bit timings.
    //
    MCAN_setBitTime(MCAN1_BASE, &bitTimes);

    //
    // Configure Message RAM Sections
    //
    MCAN_msgRAMConfig(MCAN1_BASE, &msgRAMConfigParams);

    SysState.MCanSupport.Fifo0ElementWidth = SpaceForElementSizeInLongs[msgRAMConfigParams.rxFIFO0ElemSize] ;
    SysState.MCanSupport.pFifo0Start       = (unsigned long *)(MCANA_MSG_RAM_BASE+msgRAMConfigParams.rxFIFO0startAddr);
    SysState.MCanSupport.TxBufElementWidth = SpaceForElementSizeInLongs[msgRAMConfigParams.txBufElemSize]  ;
    SysState.MCanSupport.pTxBufStart       = (unsigned long *)(MCANA_MSG_RAM_BASE+msgRAMConfigParams.txStartAddr);

    SysState.MCanSupport.Fifo0NumElements = msgRAMConfigParams.rxFIFO0size+1  ;  // Must be 2^N
    SysState.MCanSupport.TxNumElements = msgRAMConfigParams.txBufNum+1  ;  // Must be 2^N


    //
    // Initialize Rx Buffer Filter element Configuration parameters.
    //
    //CanId
    for ( cnt = 0 ; cnt < 4 ; cnt++ )
    {
        if ( IsValidCanId ( CanId[cnt], CanIDMask[cnt]))
        {
            stdFiltelem.sfid2              = CanIDMask[cnt]; // Standard ID Filter Mask. 0 bit is "don't care"
            stdFiltelem.sfid1              = CanId[cnt] ; // Standard ID Filter
            stdFiltelem.sfec               = 0x5U; // Store into FIFO 0.
            stdFiltelem.sft                = 0x02U; // SFID1 = filter; SFID2 = mask
            MCAN_addStdMsgIDFilter(MCAN1_BASE, cnt, &stdFiltelem);
        }
        if ( IsValidCanId ( ExtCanId[cnt], ExtCanIDMask[cnt]))
        {
            ExtFiltelem.efid2              = CanIDMask[cnt]; // Standard ID Filter Mask. 0 bit is "don't care"
            ExtFiltelem.efid1              = CanId[cnt] ; // Standard ID Filter
            ExtFiltelem.efec               = 0x5U; // Store into FIFO 0.
            ExtFiltelem.eft                = 0x02U; // SFID1 = filter; SFID2 = mask
            MCAN_addExtMsgIDFilter(MCAN1_BASE, cnt, &ExtFiltelem);
        }
    }

    /*
     * Un-comment the following line in order to bypass any type of Message Filter
     */
   // MCAN_config(MCANA_BASE, &config_params);         // Reserve


    //
    // Take MCAN out of the SW initialization mode
    //
    //MCAN_writeProtectedRegAccessUnlock(MCAN1_BASE);
    rmw = * (unsigned long *) (MCAN1_BASE + MCAN_CCCR) ;
    rmw |= 2 ;
    * (unsigned long *) (MCAN1_BASE + MCAN_CCCR) = rmw ;

    // Reject all non-matching messages
    * (unsigned long *) (MCAN1_BASE + MCAN_GFC) = 0x3ff ;

    MCAN_setOpMode(MCAN1_BASE, MCAN_OPERATION_MODE_NORMAL);

    //cccr = * (unsigned long *) (MCAN1_BASE + MCAN_CCCR) ;
    while (MCAN_OPERATION_MODE_NORMAL != MCAN_getOpMode(MCAN1_BASE))
    {
        MCAN_setOpMode(MCAN1_BASE, MCAN_OPERATION_MODE_NORMAL);
        //cccr = * (unsigned long *) (MCAN1_BASE + MCAN_CCCR) ;
    }

    //
    // Enable Interrupts.
    //
    //MCAN_enableIntr(MCAN1_BASE, MCAN_INTR_MASK_ALL, 1U);

    //
    // Select Interrupt Line.
    //
    //MCAN_selectIntrLine(MCAN1_BASE, MCAN_INTR_MASK_ALL, MCAN_INTR_LINE_NUM_1);

    //
    // Enable Interrupt Line.
    //
    //MCAN_enableIntrLine(MCAN1_BASE, MCAN_INTR_LINE_NUM_1, 1U);
    SealState.bCanInitialized = 1 ;
    return;
}



struct CCanMsg TxMsg ;
#define HW_RD_REG32(addr) (uint32_t)(HW_RD_REG32_RAW((uint32_t) (addr)))
void RtCanService(void)
{
    short unsigned next , dlc  ;
    //float pref ;
    union
    {
        long unsigned ul ;
        long l ;
        float f ;
        short unsigned us[2];
        short s[2] ;
    } u , u2 , u3 ;
    unsigned long cobId  ;
    unsigned long * pmsg ;
    short unsigned nf , nread , cnt  , nget  ;

/*
    // Track sync time validity
    u.ul = SysState.Timing.UsecTimer - SysState.MCanSupport.SyncTrackTime ;
    if ( u.us[1] & 0x8000)
    {
        SysState.MCanSupport.SyncValid = 0 ;
    }
*/
    //Test which receivers are ready to read;
    u.ul = HWREG(MCAN1_BASE + MCAN_RXF0S) ;
    nf     = (short unsigned) (u.us[0] & 0x7f) ;
    if ( nf )
    {
        nread  = __min( nf , 3 ) ;
        for ( cnt = 0 ; cnt < nread ; cnt++ )
        {
            nget  =  ( u.us[0] >> 8 ) & 0x3f ;
            pmsg = SysState.MCanSupport.pFifo0Start + nget * SysState.MCanSupport.Fifo0ElementWidth * MCAN_RAM_LONG_PTR_INC ;
            u3.ul = pmsg[0] ;
            if ( u3.us[1] & 0x6000 )
            {
                HWREG(MCAN1_BASE + MCAN_RXF0A) = nget ;
                continue ; // Either RTR or extended frame
            }
            cobId =  ( u3.ul >> 18 ) & 0x7ff ;

            u2.ul = pmsg[MCAN_RAM_LONG_PTR_INC] ;
            if ( u2.us[1] & 0x30  )
            { // Either baud rate change or FD
                HWREG(MCAN1_BASE + MCAN_RXF0A) = nget ;
                continue ;
            }


            dlc   = Dlc2Len[u2.us[1] & 0xf ];
            //filtIndex     = ( u2.us[1] >> 8 ) & 0x3f ;

            next = ( CANCyclicBuf_in.PutCounter + 1 ) & (N_CAN_QUEUE_SIZE - 1 ) ;
            if ( CANCyclicBuf_in.FetchCounter == next )
            {
                return ; // SW Queue full, nothing to do
            }
            CANCyclicBuf_in.CANID[CANCyclicBuf_in.PutCounter] = cobId ;
            CANCyclicBuf_in.DLenAndAttrib[CANCyclicBuf_in.PutCounter] = dlc ;
            CANCyclicBuf_in.CANQueue[CANCyclicBuf_in.PutCounter*2] = pmsg[MCAN_RAM_LONG_PTR_INC*2] ;
            CANCyclicBuf_in.CANQueue[CANCyclicBuf_in.PutCounter*2+1] = pmsg[MCAN_RAM_LONG_PTR_INC*3] ;
            CANCyclicBuf_in.PutCounter = next ;
            // Approve Rx fetch and go to next
            HWREG(MCAN1_BASE + MCAN_RXF0A) = nget ;
            u.ul = HWREG(MCAN1_BASE + MCAN_RXF0S) ;
            nget =  ( u.us[0] >> 8 ) & 0x3f ;
        }
    }

    // TX queued message
    // Is SDO waiting
    // Transmit messages required by the idle process
    nf     = (short unsigned) ((CANCyclicBuf_in.PutCounter -CANCyclicBuf_in.FetchCounter ) &(N_CAN_QUEUE_SIZE - 1 )) ;
    nf     = __min( nf , 3 ) ;

    for ( cnt = 0 ; cnt < nf ; cnt++ )
    {
        TxMsg.UseLongId = 0 ;
        TxMsg.cobId = CANCyclicBuf_out.CANID[CANCyclicBuf_in.FetchCounter] ;
        TxMsg.dLen = CANCyclicBuf_out.DLenAndAttrib[CANCyclicBuf_in.FetchCounter] & 0xf ;
        TxMsg.data[0] = CANCyclicBuf_out.CANQueue[CANCyclicBuf_in.FetchCounter*2] ;
        TxMsg.data[1] = CANCyclicBuf_out.CANQueue[CANCyclicBuf_in.FetchCounter*2+1] ;
        if ( SetMsg2HW(& TxMsg) )
        {
            break ;
        }
        CANCyclicBuf_in.FetchCounter = (CANCyclicBuf_in.FetchCounter+1) & (N_CAN_QUEUE_SIZE-1) ;
    }
}



#pragma FUNCTION_OPTIONS ( SetMsg2HW, "--opt_level=3" );


/*
 * Send a standard 8-byte message
 */
short SetMsg2HW(struct CCanMsg  *pMsg )
{
    int  shift ;
    union
    {
        long unsigned ul ;
        short unsigned us[2];
    } u2 ;
    long unsigned *pmsg ;
    short unsigned mask ;


    mask = BlockInts() ;
    // Invert the pending state so we have the clear mailboxes
    u2.ul = ~HWREG(MCAN1_BASE + MCAN_TXBRP) ; // Free units

    u2.us[0] &= (SysState.MCanSupport.TxNumElements-1)  ; // Look only at implemented boxes
    if (  u2.us[0] == 0 )
    {// All clogged, go home
        RestoreInts(mask) ;
        return -1 ;
    }

    u2.us[0] = __flip16(u2.us[0] ) ;
    u2.us[1] = 0  ;
    __norm32(u2.ul , &shift );
    shift -= 15 ;
    pmsg = SysState.MCanSupport.pTxBufStart + shift * SysState.MCanSupport.TxBufElementWidth * MCAN_RAM_LONG_PTR_INC   ;
    pmsg[0] = ( pMsg->cobId & 0x7ff) << 18 ;
#ifdef CANFD
    pmsg[1] = ( pmsg[1] & 0xcf0000 ) | ( 0x8UL << 16 );
#endif
    pmsg[MCAN_RAM_LONG_PTR_INC] = ( unsigned long) pMsg->dLen << 16 ;
    pmsg[MCAN_RAM_LONG_PTR_INC*2] = pMsg->data[0] ;
    pmsg[MCAN_RAM_LONG_PTR_INC*3] = pMsg->data[1] ;

    // Send request to transmit this buffer
    HWREG(MCAN1_BASE +MCAN_TXBAR) = (1<<shift) ;
    RestoreInts(mask) ;
    return 0 ;
}

#ifdef CANFD

/*
 * Send a standard 8-byte message
 * LengthCode is 0 to 8, or 0x9-0xF (9-15): CAN FD: transmit frame has 12/16/20/24/32/48/64 data
 */
short SetFDMsg2HW(struct CCanMsg  *pMsg , long unsigned *databuf , short unsigned LengthCode )
{
    int  shift ;
    union
    {
        long unsigned ul ;
        short unsigned us[2];
    } u2 ;
    long unsigned *pmsg ;
    short unsigned mask ;

    mask = BlockInts() ;
    // Invert the pending state so we have the clear mailboxes
    u2.ul = ~HWREG(MCAN1_BASE + MCAN_TXBRP) ; // Free units

    u2.us[0] &= (SysState.MCanSupport.TxNumElements-1)  ; // Look only at implemented boxes
    if (  u2.us[0] == 0 )
    {// All clogged, go home
        RestoreInts(mask) ;
        return -1 ;
    }

    u2.us[0] = __flip16(u2.us[0] ) ;
    u2.us[1] = 0  ;
    __norm32(u2.ul , &shift );
    shift -= 15 ;
    pmsg = SysState.MCanSupport.pTxBufStart + shift * SysState.MCanSupport.TxBufElementWidth * MCAN_RAM_LONG_PTR_INC   ;
    pmsg[0] = ( pMsg->cobId & 0x7ff) << 18 ;
    pmsg[1] = ( pmsg[1] & 0xcf0000 ) | (( 0x30UL + (unsigned long) LengthCode ) << 16 );
    pmsg[MCAN_RAM_LONG_PTR_INC] = ( unsigned long) pMsg->dLen << 16 ;
    pmsg[MCAN_RAM_LONG_PTR_INC*2] = databuf[0] ;
    pmsg[MCAN_RAM_LONG_PTR_INC*3] = databuf[1] ;
    pmsg[MCAN_RAM_LONG_PTR_INC*4] = databuf[2] ;
    pmsg[MCAN_RAM_LONG_PTR_INC*5] = databuf[3] ;
    pmsg[MCAN_RAM_LONG_PTR_INC*6] = databuf[4] ;
    pmsg[MCAN_RAM_LONG_PTR_INC*7] = databuf[5] ;
    pmsg[MCAN_RAM_LONG_PTR_INC*8] = databuf[6] ;
    pmsg[MCAN_RAM_LONG_PTR_INC*9] = databuf[7] ;
    pmsg[MCAN_RAM_LONG_PTR_INC*10] = databuf[8] ;
    pmsg[MCAN_RAM_LONG_PTR_INC*11] = databuf[9] ;
    pmsg[MCAN_RAM_LONG_PTR_INC*12] = databuf[10] ;
    pmsg[MCAN_RAM_LONG_PTR_INC*13] = databuf[11] ;
    pmsg[MCAN_RAM_LONG_PTR_INC*14] = databuf[12] ;
    pmsg[MCAN_RAM_LONG_PTR_INC*15] = databuf[13] ;
    pmsg[MCAN_RAM_LONG_PTR_INC*16] = databuf[14] ;
    pmsg[MCAN_RAM_LONG_PTR_INC*17] = databuf[15] ;



    // Send request to transmit this buffer
    HWREG(MCAN1_BASE +MCAN_TXBAR) = (1<<shift) ;
    RestoreInts(mask) ;
    return 0 ;
}
#endif


