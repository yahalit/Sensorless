#include "..\Application\StructDef.h"

/* Flash handler functions for the 28P65x
 * All entities are 32 bits
 */

const long unsigned BankAddress[5] =
{
 0x080000, 0x0A0000 ,0x0C0000  , 0x0e0000,  0x100000
};

volatile short unsigned PumpOwner ;



/*
 * Relates flash size ID to physical size
 */
const short unsigned nSectPerId[8] = {0,0,0,1,2,3,4,5} ;
short unsigned nThisCpu ;
short unsigned nOtherCpu ;

/*
 * Initial flash memory setup
 * CPU may be     IPC_FLASHSEM_OWNER_CPU1 = 0x1, or  IPC_FLASHSEM_OWNER_CPU2 = 0x2
 *
 */

void DeallocateFlashPump(void)
{
    uint32_t semRegister = IPC_CPUXTOCPUX_BASE + IPC_O_FLASHCTLSEM;
    EALLOW ;
    HWREG(semRegister) = 0x5A5A0000U  ;
    EDIS ;
    PumpOwner = 0 ; //No - ones
}


// Get number of flash banks for this component
short unsigned GetNFlashBanks( )
{
    short unsigned n ;
    long unsigned cfgreg = HWREG(DEVCFG_BASE + SYSCTL_O_PARTIDL);
    n = (short unsigned)((cfgreg>>16) & 0xff ) ;
    if ( n > 7 )
    {
        n = 7 ;
    }
    return nSectPerId[n] ;
}





#pragma CODE_SECTION(SetupFlashBody, ".TI.ramfunc");
short   SetupFlashBody(IPC_FlashSemOwner cpu , uint32 u32HclkFrequencyMHz  )
{
    Fapi_StatusType oReturnCheck;
    //uint32_t partNumber ;
    // Initialize the module, 4 wait states for 200MHz
    Flash_initModule(FLASH0CTRL_BASE, FLASH0ECC_BASE, 4);

    // Get the part
    //partNumber = DevCfgRegs.DEVICEID.all;

    // Define the other core
    nThisCpu = (short unsigned ) cpu ;
    nOtherCpu = 3 - nThisCpu ;

    // Assure this device has 5 banks
    if ( GetNFlashBanks() <  5 )
    {
        return -1 ;
    }

    //Allocate 3 banks to CPU1, later 2 banks for CPU2
    if ( cpu == IPC_FLASHSEM_OWNER_CPU1)
    {
        IPC_claimFlashSemaphore(IPC_FLASHSEM_OWNER_CPU1);
        SysCtl_allocateFlashBank(SYSCTL_FLASH_BANK0, SYSCTL_CPUSEL_CPU1);
        SysCtl_allocateFlashBank(SYSCTL_FLASH_BANK1, SYSCTL_CPUSEL_CPU1);
        SysCtl_allocateFlashBank(SYSCTL_FLASH_BANK2, SYSCTL_CPUSEL_CPU1);
        SysCtl_allocateFlashBank(SYSCTL_FLASH_BANK3, SYSCTL_CPUSEL_CPU2);
        SysCtl_allocateFlashBank(SYSCTL_FLASH_BANK4, SYSCTL_CPUSEL_CPU2);
    }

    // NOTE: This will be different for every device
    // This is set up for F28P650DK9
    // Initialize the Flash API by providing the Flash register base address
    // and operating frequency(in MHz).
    // This function is required to initialize the Flash API based on System
    // frequency before any other Flash API operation can be performed.
    // This function must also be called whenever System frequency or RWAIT is
    // changed.
    oReturnCheck = Fapi_initializeAPI(FlashTech_CPU0_BASE_ADDRESS, u32HclkFrequencyMHz);

    if(oReturnCheck != Fapi_Status_Success)
    {
        // Check Flash API documentation for possible errors
        return -2;
    }

    return 0 ;
}

#pragma CODE_SECTION(SetupFlash, ".TI.ramfunc");

/*
 * cpu: 1 for CPU1 , 2 for CPU2
 */
short SetupFlash(short unsigned cpu , unsigned long u32HclkFrequencyMHz  )
{
    short stat = SetupFlashBody((IPC_FlashSemOwner)cpu , (uint32) u32HclkFrequencyMHz  );
    DeallocateFlashPump() ;
    return stat ;
}



#pragma CODE_SECTION(ClearFSMState, ".TI.ramfunc")
/*
 * Clear status of the state machine
 */
short ClearFSMState(void)
{
    Fapi_FlashStatusType  oFlashStatus;
    Fapi_StatusType  oReturnCheck;

    // Wait until FSM is done with the previous flash operation
    while (Fapi_checkFsmForReady() != Fapi_Status_FsmReady){}

    oFlashStatus = Fapi_getFsmStatus();

    if(oFlashStatus != 0)
    {

        /* Clear the Status register */
        oReturnCheck = Fapi_issueAsyncCommand(Fapi_ClearStatus);

        // Wait until status is cleared
        while (Fapi_getFsmStatus() != 0) {}

        if(oReturnCheck != Fapi_Status_Success)
        {
            // Check Flash API documentation for possible errors
            return -1;
        }
    }

    return 0 ;
}


#pragma CODE_SECTION(WaitFlashActionComplete, ".TI.ramfunc")
/*
 * Wait a flash action to complete
 */
short WaitFlashActionComplete()
{
    Fapi_FlashStatusType  oFlashStatus;

    // Wait until the Flash program operation is over
    do
    {
        oFlashStatus = Fapi_checkFsmForReady() ;

    } while ( (oFlashStatus==Fapi_Status_AsyncBusy) || (oFlashStatus==Fapi_Status_FsmBusy) );
    return (oFlashStatus <= Fapi_Status_AsyncComplete) ? 0 : -12 ;
}



/*
 * Get the protection masks that need to be set for erasing or writing
 */

void GetBankProtectionMaskes(long unsigned FlashAddress , long unsigned buflen32 , long unsigned *_prot0to31 , long unsigned *_prot32to127)
{
    short unsigned cnt ;
    long unsigned RelEndAddress;
    long unsigned RelStartAddress;
    long unsigned prot0to31;
    long unsigned prot32to127;
    long unsigned buflen = buflen32 >> 1 ;
#define FLASH_ABS_START 0x00080000
    RelStartAddress = ((FlashAddress-FLASH_ABS_START) & 0x1ffff) >> 10  ;
    RelEndAddress   = (((FlashAddress-FLASH_ABS_START)+buflen) & 0x1ffff) >> 10  ;
    prot0to31 = 0xffffffff ;
    prot32to127 = 0xffffffff ;
    // 1k sector
    if ( RelStartAddress < 32 )
    {
        for ( cnt = RelStartAddress ; cnt < 32 ; cnt++ )
        {
            if ( cnt > RelEndAddress)
            {
                *_prot0to31   = prot0to31 ;
                *_prot32to127 = prot32to127 ;
                return ;
            }
            prot0to31 &= (~(1UL<<cnt));
        }
    }
    // 8k sectors
    if ( RelEndAddress >= 32 )
    {
        RelEndAddress = (RelEndAddress - 32) >> 3  ;
        if ( RelStartAddress < 32 )
        {
            RelStartAddress = 0 ;
        }
        else
        {
            RelStartAddress = (RelStartAddress - 32) >> 3  ;
        }
        for ( cnt = 0 ; cnt < 12 ; cnt++ )
        {
            if ( cnt > RelEndAddress)
            {
                *_prot0to31   = prot0to31 ;
                *_prot32to127 = prot32to127 ;
                return ;
            }
            if ( cnt >= RelStartAddress)
            {
                prot32to127 &= (~(1UL<<cnt));
            }
        }
    }
    // Case we reached the end of bank
    *_prot0to31   = prot0to31 ;
    *_prot32to127 = prot32to127 ;
}

#pragma CODE_SECTION(UnProtectBank, ".TI.ramfunc")
void UnProtectBank(long unsigned FlashAddress , long unsigned buflen)
{
    long unsigned prot0to31 ;
    long unsigned prot32to127 ;
    GetBankProtectionMaskes(FlashAddress , buflen , &prot0to31 , &prot32to127);
    // Clears status of previous Flash operation
    ClearFSMState();
    Fapi_setupBankSectorEnable(FLASH_WRAPPER_PROGRAM_BASE+FLASH_O_CMDWEPROTA, prot0to31);
    Fapi_setupBankSectorEnable(FLASH_WRAPPER_PROGRAM_BASE+FLASH_O_CMDWEPROTB, prot32to127);
}


// Which CPU: 0 for CPU1 , 1 for CPU2
#pragma CODE_SECTION(GetFlashAccess, ".TI.ramfunc")
short GetFlashAccess(  long unsigned FlashAddress , long unsigned buflen32)
{
    // Test if we have the pump. If not, try claim it
    short unsigned cnt ;
    long unsigned nBank ;
    short unsigned BankMux  ;
    long unsigned prot0to31 ;
    long unsigned prot32to127 ;
    Fapi_StatusType  oReturnCheck;
    long unsigned buflen = (buflen32 << 1) ;


    // Test we can claim
    uint32_t semRegister = IPC_CPUXTOCPUX_BASE + IPC_O_FLASHCTLSEM;
    PumpOwner = ( short unsigned) ( HWREG(semRegister) & 3)  ;
    if ( PumpOwner == nOtherCpu)
    {
        return -1 ;
    }

    if (PumpOwner != nThisCpu )
    {
        // Make the claim
        EALLOW ;
        HWREG(semRegister) = 0x5A5A0000U | (uint32_t)nThisCpu;

        for ( cnt = 0 ; cnt < 100 ; cnt++ )
        {
            PumpOwner = ( short unsigned) ( HWREG(semRegister) & 3)  ;
            if ( PumpOwner == nThisCpu)
            {
                break  ;
            }
        }
        EDIS ;
    }


    if ( PumpOwner != nThisCpu)
    {
        return -3 ;
    }

    // Test address validity
    nBank =  (FlashAddress - BankAddress[0]) >> 17   ;
    if ( nBank*2 >= sizeof(BankAddress) )
    {
        return -4 ;
    }

    // Test that action does not go beyond bank limits
    if ( nBank != ((FlashAddress- BankAddress[0] + buflen) >> 17 ) )
    {
        return -5 ;
    }

    // See if we own this bank
    BankMux = ( (short unsigned) HWREG(DEVCFG_BASE + SYSCTL_O_BANKMUXSEL) >> (2*nBank) ) & 3 ;

#ifdef CPU1
    if ( BankMux )
    {// Bank is not ours
        return -6 ;
    }
#else
    if (  3 !=  BankMux )
    {// Bank is not ours
        return -6 ;
    }
#endif

    // Check address alignment (128 bits)
    if ( FlashAddress & 0x3f)
    {
        return -7 ;
    }
    // Check action length alignment (128 bits)
    if ( buflen & 0x3f)
    {
        return -7 ;
    }


    // Initialize the API for this bank (by TI DOC : always use Fapi_FlashBank0 regardless of actual bank)
    // Initialize the Flash banks and FMC for erase and program operations.
    // Fapi_setActiveFlashBank() function sets the Flash banks and FMC for
    // further Flash operations to be performed on the banks.
    oReturnCheck = Fapi_setActiveFlashBank( Fapi_FlashBank0 );
    if(oReturnCheck != Fapi_Status_Success)
    {
        return -8  ;
    }

        // Clears status of previous Flash operation
    if ( ClearFSMState() )
    {
        return -9 ;
    }

    GetBankProtectionMaskes(FlashAddress , buflen32 , &prot0to31 , &prot32to127) ;

    // Enable program/erase protection for select sectors
    // CMDWEPROTA is applicable for sectors 0-31
    // Bits 0-11 of CMDWEPROTB is applicable for sectors 32-127, each bit represents
    // a group of 8 sectors, e.g bit 0 represents sectors 32-39, bit 1 represents
    // sectors 40-47, etc
    UnProtectBank( FlashAddress , buflen) ;

    return 0 ;
}


//############################# EEPROM_ERASE #################################
#pragma CODE_SECTION(EraseSectorsBody, ".TI.ramfunc")
short EraseSectorsBody( long unsigned FlashAddress , long unsigned buflen32)
{
    Fapi_StatusType  oReturnCheck;
    Fapi_FlashStatusWordType poFlashStatusWord ;
    short stat ;
    long unsigned buflen = buflen32 >> 1 ;
    stat = GetFlashAccess(FlashAddress, buflen) ;
    if ( stat )
    {
        return stat ;
    }

    // Erase the EEPROM Bank
    oReturnCheck = Fapi_issueBankEraseCommand((uint32*) (FlashAddress & (~0x1ffffUL)) );
    if(oReturnCheck != Fapi_Status_Success)
    {
        return -10 ;
    }
    // Wait for completion and check for any programming errors
    stat = WaitFlashActionComplete() ;

    oReturnCheck = Fapi_doBlankCheck((uint32*) FlashAddress,buflen32,&poFlashStatusWord) ;
    if(oReturnCheck != Fapi_Status_Success)
    {
        return -11 ;
    }

    return stat ;
}

#pragma CODE_SECTION(EraseSectors, ".TI.ramfunc")
short EraseSectors( long unsigned FlashAddress , long unsigned buflen32)
{
    short stat ;
    stat = EraseSectorsBody( FlashAddress ,  buflen32);
    DeallocateFlashPump() ;
    return stat ;
}



#pragma CODE_SECTION(WriteToFlashBody, ".TI.ramfunc")
short WriteToFlashBody( long unsigned FlashAddress , long unsigned * Write_Buffer , long unsigned buflen32)
{
    Fapi_StatusType  oReturnCheck;
    Fapi_FlashStatusWordType poFlashStatusWord ;
    long unsigned buflen = (buflen32 << 1) ;
    long unsigned prot0to31;
    long unsigned prot32to127;
    short stat ;
    short cnt ;
    stat = GetFlashAccess(FlashAddress, buflen) ;
    if ( stat )
    {
        return stat ;
    }

    // Verify the write area is indeed blank
    oReturnCheck = Fapi_doBlankCheck((uint32*) FlashAddress,buflen32, &poFlashStatusWord ) ;
    if(oReturnCheck != Fapi_Status_Success)
    {
        return -14 ;
    }

    // Program the EEPROM Bank
    // We program for 128 bit = 8 word chunks
    GetBankProtectionMaskes(FlashAddress , buflen , &prot0to31 , &prot32to127);
    for  (  cnt = 0 ; cnt < (buflen>>3) ; cnt++ )
    {

        // Clears status of previous Flash operation
        //ClearFSMState();
        Fapi_setupBankSectorEnable(FLASH_WRAPPER_PROGRAM_BASE+FLASH_O_CMDWEPROTA, prot0to31);
        Fapi_setupBankSectorEnable(FLASH_WRAPPER_PROGRAM_BASE+FLASH_O_CMDWEPROTB, prot32to127);

        oReturnCheck = Fapi_issueProgrammingCommand((uint32*) (FlashAddress+ (cnt << 3 )),
                                                    (uint16*)Write_Buffer + (cnt << 3 ), 8  , 0, 0,
                                                    Fapi_AutoEccGeneration);
         if(oReturnCheck != Fapi_Status_Success)
        {
            return -10 ;
        }
        // Wait for completion and check for any programming errors
        stat = WaitFlashActionComplete() ;
        if ( stat )
        {
            return stat ;
        }
    }

    oReturnCheck = Fapi_doVerify((uint32*) FlashAddress,buflen32,Write_Buffer,&poFlashStatusWord ) ;

    return stat ;
}

#pragma CODE_SECTION(WriteToFlash, ".TI.ramfunc")
short WriteToFlash( long unsigned FlashAddress , long unsigned * Write_Buffer , long unsigned buflen)
{
    short stat ;
    stat = WriteToFlashBody( FlashAddress , Write_Buffer , buflen);
    DeallocateFlashPump() ;
    return stat ;
}


