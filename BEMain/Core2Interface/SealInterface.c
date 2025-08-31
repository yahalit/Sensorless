/*
 * SealInterface.c
 *
 *  Created on: Aug 31, 2025
 *      Author: user
 */

#include "..\Application\StructDef.h"





void setUartOwnership(short unsigned owner)
{
    EALLOW;
    switch ( owner )
    {
    case 1:
        GPIO_setControllerCore(42, GPIO_CORE_CPU2);
        GPIO_setControllerCore(43, GPIO_CORE_CPU2);
        DevCfgRegs.CPUSEL5.bit.UART_A = 1 ;   // Give UARTA to CPU2
        UM2S.M2S.SetupReportBuf.bConfirmControlUART = 1 ;
        break ;
    default:
        if ( UM2S.M2S.SetupReportBuf.bConfirmControlUART)
        {
            GPIO_setControllerCore(42, GPIO_CORE_CPU1);
            GPIO_setControllerCore(43, GPIO_CORE_CPU1);
            DevCfgRegs.CPUSEL5.bit.UART_A = 0 ;
            UM2S.M2S.SetupReportBuf.bConfirmControlUART = 0 ;
            InitUart(UARTA_BASE) ;
        }
        break ;
    }
    EDIS;
}

void SealRelations()
{
    if ( SysState.bCore2IsDead )
    {
        return ;
    }
    setUartOwnership(US2M.S2M.DrvCommandBuf.bControlUART) ;
}

