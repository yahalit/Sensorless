/*
 * Seal_errorcodes.h
 *
 *  Created on: 23 баев„ 2025
 *      Author: Yahali
 */

#ifndef SEAL_SEAL_ERRORCODES_H_
#define SEAL_SEAL_ERRORCODES_H_


#define seal_error_ticker_overflow 0x4000 // Ticker registered a difference > 65535

#define seal_uart_overflow  0x5000 // UART in characters overflow , characters lost
#define seal_uart_overflow1  0x5001 // UART in frame error, characters lost
#define seal_uart_overflow2  0x5002 // UART in parity error, characters lost
#define seal_uart_overflow3  0x5003 // UART in frame error, parity error,  characters lost
#define seal_uart_overflow4  0x5004 // UART in break error , characters lost
#define seal_uart_overflow5  0x5005 // UART in frame error, break error , characters lost
#define seal_uart_overflow6  0x5006 // UART in parity error,break error ,  characters lost
#define seal_uart_overflow7  0x5007 // UART in frame error,  parity error,break error , characters lost
#define seal_uart_overflow8  0x5008 // UART in characters overflow , overflow , characters lost
#define seal_uart_overflow9  0x5009 // UART in frame error, overflow , characters lost
#define seal_uart_overflowa  0x500a // UART in overflow ,  parity error, characters lost
#define seal_uart_overflowb  0x500b // UART in frame error,  parity error, overflow , characters lost
#define seal_uart_overflowc  0x500c // UART in break error , overflow , characters lost
#define seal_uart_overflowd  0x500d // UART in frame error, break error , overflow, characters lost
#define seal_uart_overflowe  0x500e // UART in  parity error, break error ,overflow , characters lost
#define seal_uart_overflowf  0x500f // UART in frame error,  parity error, break error , overflow, characters lost

#endif /* SEAL_SEAL_ERRORCODES_H_ */
