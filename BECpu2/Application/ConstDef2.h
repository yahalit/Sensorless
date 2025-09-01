/*
 * ConstDef.h
 *
 *  Created on: Apr 8, 2025
 *      Author: user
 */

#ifndef APPLICATION_CONSTDEF2_H_
#define APPLICATION_CONSTDEF2_H_

#define PROJ_TYPE 110

#define UART_BUF_CYC_SIZE 256
#define N_CAN_QUEUE_SIZE 64

#define ON_BOARD_CAN


#define N_RECS_MAX  16 // Maximum amount of recorded signals
#define REC_BUF_LEN  1024 // Number of bins in recorder
#define N_FDEBUG 8
#define N_LDEBUG 8


#define NSYS_TIMER_CMP_ARRAY 32
#define SDO_BUF_LEN_LONGS 128

#define CAN_NMT  (0<<7)
#define CAN_SYNC  (1<<7)
#define CAN_EMCY  CAN_SYNC
#define CAN_TSTAMP (2<<7)

#define PDO1_TX (3<<7)
#define PDO2_TX (5<<7)
#define PDO3_TX (7<<7)
#define PDO4_TX (9<<7)

#define PDO1_RX (4<<7)
#define PDO2_RX (6<<7)
#define PDO3_RX (8<<7)
#define PDO4_RX (0xa<<7)

#define SDO_TX (0xb<<7)
#define SDO_RX (0xc<<7)

#define CAN_NMT_ERROR_CONTROL  (0xe<<7)

enum E_FindPosMgrState
{
    FindPosMgrPosNothing = 0 ,
    FindPosMgrPosSlope1 = 1 ,
    FindPosMgrNegSlope1p1 = 2 ,
    FindPosMgrNegSlope1p2 = 3 ,
    FindPosMgrNoSlope = 4 ,
    FindPosMgrPosSlope2p1 = 5 ,
    FindPosMgrPosSlope2p2 = 6 ,
    FindPosMgrPosSlope2 = 7 ,
    FindPosMgrPosDone = 8 ,
    FindPosMgrStateFailure = 15
};


enum SdoAbortErrorCode
{
    Toggle_bit_not_alternated = 0x05030000,
    SDO_protocol_timed_out = 0x5040000 ,
    Client_server_command_specifier_not_valid_or_unknown = 0x5040001 ,
    Object_does_not_exist_in_the_object_dictionary = 0x06020000,
    Unsupported_access_to_an_object = 0x6010000,
    General_parameter_incompatibility_reason = 0x6040043,
    length_of_service_parameter_does_not_match=0x6070010,
    Sub_index_does_not_exist = 0x6090011,
    Out_of_memory = 0x5040005,
    Invalid_block_size = 0x5040002,
    Invalid_sequence_number = 0x5040003,
    crc_error = 0x5040004,
    Manufacturer_error_detail = 0x9000000UL,
    ReturnNotExpected = 0x7fffffffUL
};



#define TIMEOUT_FIND_POS_CUR_MAX 0.1

#endif /* APPLICATION_CONSTDEF2_H_ */
