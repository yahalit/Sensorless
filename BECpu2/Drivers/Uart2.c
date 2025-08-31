/*
 * Uart2.c
 *
 *  Created on: Aug 30, 2025
 *      Author: user
 */
#include "..\Application\StructDef2.h"

/**
 * @brief Initialize a UART (SCI) for CPU2 once CPU1 has released it.
 *
 * Releases reset, enables the peripheral clock, and configures the UART
 * referenced by @p base for operation on CPU2 at the requested @p BaudRate.
 * The routine prepares the peripheral for immediate use (8-N-1 frame, FIFOs
 * enabled, TX/RX enabled). GPIO pin-muxing and interrupt hookup are assumed
 * to be handled by the caller unless noted otherwise.
 *
 * @param base      UART peripheral base address (e.g., SCIA_BASE / SCIB_BASE / SCIC_BASE).
 * @param BaudRate  Desired baud rate in bits per second (e.g., 2000000UL for 2 Mbaud).
 *
 * @pre  UART ownership has been relinquished by CPU#1 (e.g., via IPC/flag/sem)
 *       and any shared system state reflects that CPU2 may acquire the UART.
 * @pre  CPU2 has access to the UART’s clock domain and protected register writes
 *       are permitted (EALLOW/EDIS as required by the platform).
 *
 * @post The UART peripheral clock is enabled and the module is configured for:
 *       - Asynchronous mode, 8 data bits, no parity, 1 stop bit (8-N-1)
 *       - Baud rate ≈ @p BaudRate (subject to divider granularity)
 *       - FIFOs enabled and flushed
 *       - Transmitter and receiver enabled
 *
 * @warning Call only from CPU2 context after confirming CPU1 has cleared any
 *          “UART acquired” flag. Concurrent access by CPU1 during initialization
 *          can corrupt configuration.
 *
  *
 * @par Example
 * @code
 * // Acquire ownership via IPC/flag, then:
 * InitUART4CPU2(SCIA_BASE, 2000000UL); // SCIA at 2 Mbaud
 * @endcode
 *
 * @see TestAvailableConnections()
 *
 * @return void
 */
static void InitUART4CPU2(uint32_t base , long unsigned BaudRate  )
{
    // Enable device clock
    SysCtl_enablePeripheral(SYSCTL_PERIPH_CLK_UARTA);

    UART_disableModule(base);

    // Clear Software FIFOs
    ClearMem( (short unsigned *) &UartCyclicBuf_in , sizeof(UartCyclicBuf_in) ) ;
    ClearMem( (short unsigned *) &UartCyclicBuf_out , sizeof(UartCyclicBuf_out) ) ;

    UART_setConfig(
            base, // base address
            (uint32_t) UM2S.M2S.CpuClockHz, // UART source clock
            (uint32_t) BaudRate, // baud rate
        (UART_CONFIG_WLEN_8 | // word length
         UART_CONFIG_STOP_ONE) // stop bits
    );
    UART_setParityMode( base, UART_CONFIG_PAR_NONE);
    UART_enableFIFO(base);
    UART_disableInterrupt(base, 0xFFFF);
    UART_clearInterruptStatus(base, 0xFFFF);
    UART_enableModuleNonFIFO(base);
}

/**
 * @brief Test availability and manage acquisition of the UART connection on core #1.
 *
 * This function verifies whether UART use on core #1 is approved.
 * - If UART use is approved, it checks the system state flag @c SysState.UartAcquired.
 *   - If @c UartAcquired is not set, the UART is initialized and @c UartAcquired is set.
 * - If UART use is not approved, the function clears @c UartAcquired to ensure the
 *   UART resource is considered unavailable.
 *
 * @note This function both tests and enforces the UART acquisition policy:
 *       - It will initialize the UART on first approval.
 *       - It will revoke the acquisition if UART use becomes disallowed.
 *
 * @return void
 */
void TestAvailableConnections(void)
{
    if ( UM2S.M2S.SetupReportBuf.bConfirmControlUART)
    {
        if (SysState.UartAcquired == 0 )
        {
            InitUART4CPU2(UARTA_BASE, 232400UL )  ;
            SysState.UartAcquired = 1 ;
        }
    }
    else
    {
        SysState.UartAcquired = 0 ;
    }
}


/**
 * @brief Real-time UART service routine.
 *
 * This function empties the UART receive FIFO into a cyclic buffer.
 * It reads characters from the UART data register as long as data
 * is available, and stores them in @ref UartCyclicBuf_in.
 *
 * Error conditions are detected and recorded:
 * - Buffer overflow: when the next position would overwrite
 *   the current PutCounter.
 * - UART error flags: bits [11:8] of the received word
 *   (framing, parity, break, or overrun errors).
 *
 * On success, valid characters are written into
 * UartCyclicBuf_in.UARTQueue[] and the PutCounter is advanced.
 *
 * @note The UART error is encoded into
 *       UartCyclicBuf_in.UartError as:
 *       - #seal_uart_overflow if buffer is full.
 *       - #seal_uart_overflow + (error_code) if hardware reported errors.
 *
 * @return void
 */
void  RtUartService(void)
{
    // Test any characters in the FIFO
    short unsigned next, c ;
    while( (UART_O_FR & 0x10 ) == 0 )
    {
        next = (UartCyclicBuf_in.PutCounter + 1 ) & (UART_BUF_CYC_SIZE-1);
        c = HWREG(UARTA_BASE + UART_O_DR);

        if ( next == UartCyclicBuf_in.PutCounter )
        {
            UartCyclicBuf_in.UartError = seal_uart_overflow ;
        }
        else
        {
            if ( c & 0xf00 )
            {
                UartCyclicBuf_in.UartError = seal_uart_overflow + (( c >> 8 ) & 0xf)   ;
            }
            else
            {
                UartCyclicBuf_in.UARTQueue[UartCyclicBuf_in.PutCounter] = c ;
                UartCyclicBuf_in.PutCounter = next ;
            }
        }
    }
}


