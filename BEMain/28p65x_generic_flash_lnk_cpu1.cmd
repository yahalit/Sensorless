MEMORY
{
   BEGIN            : origin = 0x080000, length = 0x000002  // Update the codestart location as needed

   BOOT_RSVD        : origin = 0x000002, length = 0x0001AF     /* Part of M0, BOOT rom will use this for stack */
   RAMM0            : origin = 0x0001B1, length = 0x00024F
   RAMM1            : origin = 0x000400, length = 0x000400

   //RAMD0            : origin = 0x00C000, length = 0x002000
   //RAMD1            : origin = 0x00E000, length = 0x002000
   //RAMD2            : origin = 0x01A000, length = 0x002000  // Can be mapped to either CPU1 or CPU2. When configured to CPU2, use the address 0x8000. User should comment/uncomment based on core selection
   //RAMD3            : origin = 0x01C000, length = 0x002000  // Can be mapped to either CPU1 or CPU2. When configured to CPU2, use the address 0xA000. User should comment/uncomment based on core selection

   //RAMD4            : origin = 0x01E000, length = 0x002000  // Can be mapped to either CPU1 or CPU2. When configured to CPU2, use the address 0xC000. User should comment/uncomment based on core selection
   //RAMD5            : origin = 0x020000, length = 0x002000  // Can be mapped to either CPU1 or CPU2. When configured to CPU2, use the address 0xE000. User should comment/uncomment based on core selection

   RAMLS02           : origin = 0x008000, length = 0x001800
   //RAMLS1           : origin = 0x008800, length = 0x000800
   RAMLS3           : origin = 0x009800, length = 0x000800
   //RAMLS3           : origin = 0x009000, length = 0x000800
   RAMLS4to7        : origin = 0x00a000, length = 0x006000  // Including D0 to D1
   //RAMLS4           : origin = 0x00A000, length = 0x000800
   //RAMLS5           : origin = 0x00A800, length = 0x000800
   //RAMLS6           : origin = 0x00B000, length = 0x000800
   //RAMLS7           : origin = 0x00B800, length = 0x000800
   RAMLS8           : origin = 0x022000, length = 0x002000  // When configured as CLA program use the address 0x4000
   RAMLS9           : origin = 0x024000, length = 0x002000  // When configured as CLA program use the address 0x6000

   // RAMLS8_CLA    : origin = 0x004000, length = 0x002000  // Use only if configured as CLA program memory
   // RAMLS9_CLA    : origin = 0x006000, length = 0x002000  // Use only if configured as CLA program memory

   //RAMGS0           : origin = 0x010000, length = 0x002000
   //RAMGS1to4           : origin = 0x012000, length = 0x008000
   //RAMGS2           : origin = 0x014000, length = 0x002000
   //RAMGS3           : origin = 0x016000, length = 0x002000
   //RAMGS4           : origin = 0x018000, length = 0x002000

   /* Flash Banks (128 sectors each) */
   FLASH_BANK0     : origin = 0x080002, length = 0x1FFFE  // Can be mapped to either CPU1 or CPU2. User should comment/uncomment based on core selection
   FLASH_BANK1     : origin = 0x0A0000, length = 0x20000  // Can be mapped to either CPU1 or CPU2. User should comment/uncomment based on core selection
   FLASH_BANK2     : origin = 0x0C0000, length = 0x1dc00  // Can be mapped to either CPU1 or CPU2. User should comment/uncomment based on core selection
   FLASH_CALIB  	: origin = 0xddc00, length = 0x400
   FLASH_PARAMS 	: origin = 0xde000, length = 0x1000
   FLASH_IDENTITY  : origin = 0xdf000, length = 0x400
   FLASH_STATISTIC  : origin = 0xdf400, length = 0x400
   // FLASH_BANK3     : origin = 0x0E0000, length = 0x20000  // Can be mapped to either CPU1 or CPU2. User should comment/uncomment based on core selection
   // FLASH_BANK4     : origin = 0x100000, length = 0x20000  // Can be mapped to either CPU1 or CPU2. User should comment/uncomment based on core selection



   CPU1TOCPU2RAM    : origin = 0x03A000, length = 0x000400
   CPU2TOCPU1RAM    : origin = 0x03B000, length = 0x000400

   CLATOCPURAM      : origin = 0x001480,   length = 0x000080
   CPUTOCLARAM      : origin = 0x001500,   length = 0x000080
   CLATODMARAM      : origin = 0x001680,   length = 0x000080
   DMATOCLARAM      : origin = 0x001700,   length = 0x000080

   CANA_MSG_RAM     : origin = 0x049000, length = 0x000800
   CANB_MSG_RAM     : origin = 0x04B000, length = 0x000800
   RESET            : origin = 0x3FFFC0, length = 0x000002
}


SECTIONS
{
   codestart        : > BEGIN
   .text            : >> FLASH_BANK0 | FLASH_BANK1, ALIGN(8)
   .cinit           : > FLASH_BANK0, ALIGN(8)
   .switch          : > FLASH_BANK0, ALIGN(8)
   .reset           : > RESET, TYPE = DSECT /* not used, */

   .stack           : > RAMM1
#if defined(__TI_EABI__)
   .bss             : > RAMLS4to7
   .bss:output      : > RAMLS4to7
   .init_array      : > FLASH_BANK0, ALIGN(8)
   .const           : > FLASH_BANK0, ALIGN(8)
   .data            : > RAMLS4to7
   .sysmem          : > RAMLS4to7
#else
   .pinit           : > FLASH_BANK0, ALIGN(8)
   .ebss            : >> RAMLS4to9
   .econst          : > FLASH_BANK0, ALIGN(8)
   .esysmem         : > RAMLS5
#endif

	.statistics		: > FLASH_STATISTIC, ALIGN(8)

   //ramgs0 : > RAMGS0, type=NOINIT
   //ramgs1 : > RAMGS1, type=NOINIT
   //amgs2 : > RAMGS2, type=NOINIT

   MSGRAM_CPU1_TO_CPU2 > CPU1TOCPU2RAM, type=NOINIT
   MSGRAM_CPU2_TO_CPU1 > CPU2TOCPU1RAM, type=NOINIT

   #if defined(__TI_EABI__)
       .TI.ramfunc : {} LOAD = FLASH_BANK0,
                        RUN = RAMLS9,
                        LOAD_START(RamfuncsLoadStart),
                        LOAD_SIZE(RamfuncsLoadSize),
                        LOAD_END(RamfuncsLoadEnd),
                        RUN_START(RamfuncsRunStart),
                        RUN_SIZE(RamfuncsRunSize),
                        RUN_END(RamfuncsRunEnd),
                        ALIGN(8)
   #else
       .TI.ramfunc : {} LOAD = FLASH_BANK0,
                        RUN = RAMLS9,
                        LOAD_START(_RamfuncsLoadStart),
                        LOAD_SIZE(_RamfuncsLoadSize),
                        LOAD_END(_RamfuncsLoadEnd),
                        RUN_START(_RamfuncsRunStart),
                        RUN_SIZE(_RamfuncsRunSize),
                        RUN_END(_RamfuncsRunEnd),
                        ALIGN(8)
   #endif



   /* CLA specific sections */

#if defined(__TI_EABI__)
    /* CLA specific sections */
    Cla1Prog        : LOAD = FLASH_BANK0,
                      RUN = RAMLS02,
                      LOAD_START(Cla1ProgLoadStart),
                      RUN_START(Cla1ProgRunStart),
                      LOAD_SIZE(Cla1ProgLoadSize),
                      ALIGN(4)
#else
    /* CLA specific sections */
    Cla1Prog        : LOAD = FLASH_BANK0,
                      RUN = RAMLS02,
                      LOAD_START(_Cla1ProgLoadStart),
                      RUN_START(_Cla1ProgRunStart),
                      LOAD_SIZE(_Cla1ProgLoadSize),
                      ALIGN(4)
#endif

   Cla1ToCpuMsgRAM  : > CLATOCPURAM
   CpuToCla1MsgRAM  : > CPUTOCLARAM

   .scratchpad      : > RAMLS3
   .bss_cla         : > RAMLS3

   Cla1DataRam      : > RAMLS3
   cla_shared       : > RAMLS3
   //CLADataLS1       : > RAMLS3

#if defined(__TI_EABI__)
   .const_cla      : LOAD = FLASH_BANK0,
                      RUN = RAMLS3,
                      RUN_START(Cla1ConstRunStart),
                      LOAD_START(Cla1ConstLoadStart),
                      LOAD_SIZE(Cla1ConstLoadSize),
                      ALIGN(4)
#else
   .const_cla      : LOAD = FLASH_BANK0,
                      RUN = RAMLS3,
                      RUN_START(_Cla1ConstRunStart),
                      LOAD_START(_Cla1ConstLoadStart),
                      LOAD_SIZE(_Cla1ConstLoadSize),
                      ALIGN(4)
#endif


}

/*
//===========================================================================
// End of file.
//===========================================================================
*/
