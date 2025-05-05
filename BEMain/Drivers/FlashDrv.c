#include "..\Application\StructDef.h"



void   SetupFlash(void)
{
    Fapi_StatusType oReturnCheck;
    Flash_initModule(FLASH0CTRL_BASE, FLASH0ECC_BASE, 4);

    //EALLOW;
    IPC_claimFlashSemaphore(IPC_FLASHSEM_OWNER_CPU1);
    SysCtl_allocateFlashBank(SYSCTL_FLASH_BANK0, SYSCTL_CPUSEL_CPU1);
    SysCtl_allocateFlashBank(SYSCTL_FLASH_BANK1, SYSCTL_CPUSEL_CPU1);
    SysCtl_allocateFlashBank(SYSCTL_FLASH_BANK2, SYSCTL_CPUSEL_CPU1);
    SysCtl_allocateFlashBank(SYSCTL_FLASH_BANK3, SYSCTL_CPUSEL_CPU2);
    SysCtl_allocateFlashBank(SYSCTL_FLASH_BANK4, SYSCTL_CPUSEL_CPU2);

    // NOTE: This will be different for every device
    // This is set up for F28P650DK9
    // Initialize the Flash API by providing the Flash register base address
    // and operating frequency(in MHz).
    // This function is required to initialize the Flash API based on System
    // frequency before any other Flash API operation can be performed.
    // This function must also be called whenever System frequency or RWAIT is
    // changed.
    oReturnCheck = Fapi_initializeAPI(FlashTech_CPU0_BASE_ADDRESS,
                                      DEVICE_SYSCLK_FREQ/1000000U);

    if(oReturnCheck != Fapi_Status_Success)
    {
        // Check Flash API documentation for possible errors
        Sample_Error();
    }
}



/*

EraseSector

Function to Erase data of a sector in Flash.
Flash API functions used in this function are executed from RAM in this
*/


#pragma CODE_SECTION(EraseSector, ".TI.ramfunc");


//******************************************************************************
// For this example, just stop here if an API error is found
//******************************************************************************
void Example_Error(Fapi_StatusType status)
{
    //
    //  Error code will be in the status parameter
    //
    __asm("    ESTOP0");
}

//******************************************************************************
// For this example, just stop here if FMSTAT fail occurs
//******************************************************************************
void FMSTAT_Fail(void)
{
    __asm("    ESTOP0");
}


#pragma CODE_SECTION(ProgramPageAutoECC, ".TI.ramfunc");
short ProgramPageAutoECC( short unsigned * Buffer_in , long unsigned FlashAddress , long unsigned buflen)
{
    uint32 u32Index = 0;
    uint16 i = 0, ECC_B = 0, ECC_LB = 0, ECC_HB = 0;
    uint16 * Buffer = (uint16 * ) &Buffer_in[0];
    uint64 *LData, *HData, dataLow, dataHigh;
    Fapi_StatusType  oReturnCheck;
    Fapi_FlashStatusType  oFlashStatus;
    Fapi_FlashStatusWordType  oFlashStatusWord;

    //
    // Program data and ECC in Flash using "DataAndEcc" option.
    // When DataAndECC option is used, Flash API will program both the supplied
    // data and ECC in Flash at the address specified.
    // Fapi_calculateEcc is used to calculate the corresponding ECC of the data.
    //
    // Note that data buffer (Buffer) is aligned on 64-bit boundary for verify
    // reasons.
    //
    // In this example, 0x100 bytes are programmed in Flash Sector6
    // along with the specified ECC.
    //

    for(i=0, u32Index = FlashAddress;
       (u32Index < (FlashAddress + buflen));
       i+= 8, u32Index+= 8)
    {
        //
        // Point LData to the lower 64 bit data
        // and   HData to the higher 64 bit data
        //
        LData = (uint64 *)((uint32 *)Buffer + i/2);
        HData = (uint64 *)((uint32 *)Buffer + i/2 + 2);

        //
        // Calculate ECC for lower 64 bit and higher 64 bit data
        //
        ECC_LB = Fapi_calculateEcc(u32Index,*LData);
        ECC_HB = Fapi_calculateEcc(u32Index+4,*HData);
        ECC_B = ((ECC_HB<<8) | ECC_LB);

        oReturnCheck = Fapi_issueProgrammingCommand((uint32 *)u32Index,Buffer+i,
                                                 8, &ECC_B, 2, Fapi_DataAndEcc);

        //
        // Wait until the Flash program operation is over
        //
        while(Fapi_checkFsmForReady() == Fapi_Status_FsmBusy);

        if(oReturnCheck != Fapi_Status_Success)
        {
            //
            // Check Flash API documentation for possible errors
            //
            Example_Error(oReturnCheck);
        }

        //
        // Read FMSTAT register contents to know the status of FSM after
        // program command to see if there are any program operation related
        // errors
        //
        oFlashStatus = Fapi_getFsmStatus();
        if(oFlashStatus != 0)
        {
            //
            // Check FMSTAT and debug accordingly
            //
            FMSTAT_Fail();
        }

        Flash_enableECC(FLASH0ECC_BASE);

        //
        // Read back the programmed data to check if there are any ECC failures
        //
        dataLow = *(uint64 *)(u32Index);

        Flash_ErrorStatus errorStatusLow = Flash_getLowErrorStatus(FLASH0ECC_BASE);
        if((errorStatusLow != FLASH_NO_ERR) || (dataLow != *LData))
        {
            return -1 ; // ECC_Fail();
        }

        dataHigh = *(uint64 *)(u32Index + 4);

        Flash_ErrorStatus errorStatusHigh = Flash_getHighErrorStatus(FLASH0ECC_BASE);
        if((errorStatusHigh != FLASH_NO_ERR) || (dataHigh != *HData))
        {
            return -2 ; //ECC_Fail();
        }

        //
        // Verify the programmed values.  Check for any ECC errors.
        //
        oReturnCheck = Fapi_doVerify((uint32 *)u32Index,
                                     4, (uint32 *)Buffer + (i/2),
                                     &oFlashStatusWord);

        if(oReturnCheck != Fapi_Status_Success)
        {
            //
            // Check Flash API documentation for possible errors
            //
            return -3 ; // Example_Error(oReturnCheck);
        }
    }
    return 0 ;
}


short EraseSector(unsigned long SecAddress )
{
    Fapi_StatusType  oReturnCheck;
    Fapi_FlashStatusType  oFlashStatus;
    Fapi_FlashStatusWordType  oFlashStatusWord;

    //
    // Issue ClearMore command
    //
    oReturnCheck = Fapi_issueAsyncCommand(Fapi_ClearMore);

    //
    // Wait until FSM is done with erase sector operation
    //
    while (Fapi_checkFsmForReady() != Fapi_Status_FsmReady){}

    if(oReturnCheck != Fapi_Status_Success)
    {
        //
        // Check Flash API documentation for possible errors
        //
        return -1 ; // Example_Error(oReturnCheck);
    }

    //
    // Erase the sector that is programmed in the above example
    // Erase Sector1
    //
    oReturnCheck = Fapi_issueAsyncCommandWithAddress(Fapi_EraseSector,
                   (uint32 *)SecAddress);
    //
    // Wait until FSM is done with erase sector operation
    //
    while (Fapi_checkFsmForReady() != Fapi_Status_FsmReady){}

    if(oReturnCheck != Fapi_Status_Success)
    {
        //
        // Check Flash API documentation for possible errors
        //
        return -2 ; // Example_Error(oReturnCheck);
    }

    //
    // Read FMSTAT register contents to know the status of FSM after
    // erase command to see if there are any erase operation related errors
    //
    oFlashStatus = Fapi_getFsmStatus();
    if(oFlashStatus != 0)
    {
        //
        // Check Flash API documentation for FMSTAT and debug accordingly
        // Fapi_getFsmStatus() function gives the FMSTAT register contents.
        // Check to see if any of the EV bit, ESUSP bit, CSTAT bit or
        // VOLTSTAT bit is set (Refer to API documentation for more details).
        //
        return -3 ; // FMSTAT_Fail();
    }

    //
    // Verify that Sector1 is erased
    //
    oReturnCheck = Fapi_doBlankCheck((uint32 *)SecAddress,
                   Sector8KB_u32length,
                   &oFlashStatusWord);

    if(oReturnCheck != Fapi_Status_Success)
    {
        //
        // Check Flash API documentation for error info
        //
        return -4 ; //Example_Error(oReturnCheck);
    }
    return 0 ;
}

#pragma CODE_SECTION(PrepFlash4Burn, ".TI.ramfunc");
short PrepFlash4Burn(void)
{
    Fapi_StatusType  oReturnCheck;
    //
    // Enable Global Interrupt (INTM) and realtime interrupt (DBGM)
    //
    EINT;
    ERTM;

    // At 120MHz, execution wait-states for external oscillator is 5. Modify the
    // wait-states when the system clock frequency is changed.
    //
    //Flash_initModule(FLASH0CTRL_BASE, FLASH0ECC_BASE, 5);

  //
    // Initialize the Flash API by providing the Flash register base address
    // and operating frequency(in MHz).
    // This function is required to initialize the Flash API based on System
    // frequency before any other Flash API operation can be performed.
    // This function must also be called whenever System frequency or RWAIT is
    // changed.
    //
    oReturnCheck = Fapi_initializeAPI(F021_CPU0_BASE_ADDRESS,
                                      DEVICE_SYSCLK_FREQ/1000000U);

    if(oReturnCheck != Fapi_Status_Success)
    {
        //
        // Check Flash API documentation for possible errors
        //
        return -1;
    }

    //
    // Initialize the Flash banks and FMC for erase and program operations.
    // Fapi_setActiveFlashBank() function sets the Flash banks and FMC for
    // further Flash operations to be performed on the banks.
    //
    oReturnCheck = Fapi_setActiveFlashBank(Fapi_FlashBank0);

    if(oReturnCheck != Fapi_Status_Success)
    {
        //
        // Check Flash API documentation for possible errors
        //
        return -1 ;
    }

    return 0;
}

