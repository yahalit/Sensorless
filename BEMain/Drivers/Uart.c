/*
 * Uart.c
 *
 *  Created on: 21  2025
 *      Author: Yahali
 */
#include "..\Application\StructDef.h"


void InitUart(uint32_t base )
{
    UART_setConfig(
            base, // base address
            CPU_CLK_HZ, // UART source clock
            UART_BAUD_RATE, // baud rate
        (UART_CONFIG_WLEN_8 | // word length
         UART_CONFIG_STOP_ONE) // stop bits
    );
    UART_setParityMode( base, UART_CONFIG_PAR_NONE);
    UART_enableFIFO(base);
    UART_disableInterrupt(base, 0xFFFF);
    UART_clearInterruptStatus(base, 0xFFFF);
    UART_enableModuleNonFIFO(base);
}



