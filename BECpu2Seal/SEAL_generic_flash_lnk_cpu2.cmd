

MEMORY
{
   BEGIN            : origin = 0x100000, length = 0x000002  // Update the codestart location as needed

   //BOOT_RSVD        : origin = 0x000002, length = 0x0001AF     /* Part of M0, BOOT rom will use this for stack */
   //RAMM0            : origin = 0x0001B1, length = 0x00024F
   RAMM1              : origin = 0x0007f0, length = 0x000010	 // Stam

   // RAMD2            : origin = 0x008000, length = 0x002000  // Can be mapped to either CPU1 or CPU2. When configured to CPU1, use the address 0x01A000. User should comment/uncomment based on core selection
   // RAMD3            : origin = 0x00A000, length = 0x002000  // Can be mapped to either CPU1 or CPU2. When configured to CPU1, use the address 0x01C000. User should comment/uncomment based on core selection
   // RAMD4            : origin = 0x00C000, length = 0x002000  // Can be mapped to either CPU1 or CPU2. When configured to CPU1, use the address 0x01E000. User should comment/uncomment based on core selection
   // RAMD5            : origin = 0x00E000, length = 0x002000  // Can be mapped to either CPU1 or CPU2. When configured to CPU1, use the address 0x020000. User should comment/uncomment based on core selection
   //RAMD45            : origin = 0x00C000, length = 0x00c000  // Can be mapped to either CPU1 or CPU2. When configured to CPU1, use the address 0x01E000. User should comment/uncomment based on core selection

   RAMGS4             : origin = 0x018000, length = 0x00a000
   //RAMGS1           : origin = 0x012000, length = 0x002000
   //RAMGS2           : origin = 0x014000, length = 0x002000
   //RAMGS3           : origin = 0x016000, length = 0x002000
   //RAMGS4           : origin = 0x018000, length = 0x002000

   /* Flash Banks (128 sectors each) */
   // FLASH_BANK0     : origin = 0x080000, length = 0x20000  // Can be mapped to either CPU1 or CPU2. User should comment/uncomment based on core selection
   // FLASH_BANK1     : origin = 0x0A0000, length = 0x20000  // Can be mapped to either CPU1 or CPU2. User should comment/uncomment based on core selection
   // FLASH_BANK2     : origin = 0x0C0000, length = 0x20000  // Can be mapped to either CPU1 or CPU2. User should comment/uncomment based on core selection
   // FLASH_BANK3     : origin = 0x0E0002, length = 0x1FFFE  // Can be mapped to either CPU1 or CPU2. User should comment/uncomment based on core selection

   FLASH_MODULE_SETUP_CALL_PTR : origin = 0x10001c, length = 0x2
   FLASH_MODULE_INIT_CALL_PTR : origin = 0x10001e, length = 0x2
   FLASH_BUFFER_PTRS : origin = 0x100020, length = 0x20
   FLASH_ISR_FUNC_PTRS : origin = 0x100040, length = 0x20
   FLASH_IDLE_FUNC_PTRS : origin = 0x100060, length = 0x20
   FLASH_EXCEPTION_FUNC_PTRS : origin = 0x100080, length = 0x20
   FLASH_ABORT_FUNC_PTRS : origin = 0x1000a0, length = 0x20
   FLASH_SEAL_REV        : origin = 0x1000c0, length = 0x40
   FLASH_GENESIS_VERSE   : origin = 0x100100, length = 0xc4
   FLASH_DEVICE_SETUP    : origin = 0x100200, length = 0x40
   FLASH_BANK4     : origin = 0x100240, length = 0x1Fe00  // Can be mapped to either CPU1 or CPU2. User should comment/uncomment based on core selection



   //CPU1TOCPU2RAM    : origin = 0x03A000, length = 0x000400
   //CPU2TOCPU1RAM    : origin = 0x03B000, length = 0x000400

   //CLATOCPURAM      : origin = 0x001480,   length = 0x000080
   //CPUTOCLARAM      : origin = 0x001500,   length = 0x000080
   //CLATODMARAM      : origin = 0x001680,   length = 0x000080
   //DMATOCLARAM      : origin = 0x001700,   length = 0x000080

   //CANA_MSG_RAM     : origin = 0x049000, length = 0x000800
   //CANB_MSG_RAM     : origin = 0x04B000, length = 0x000800
   //RESET            : origin = 0x3FFFC0, length = 0x000002
}


SECTIONS
{
   codestart        : > BEGIN
   .text            : >> FLASH_BANK4, ALIGN(8)
   .cinit           : > FLASH_BANK4, ALIGN(8)
   .switch          : > FLASH_BANK4, ALIGN(8)
   //.reset           : > RESET, TYPE = DSECT /* not used, */

   .stack           : > RAMM1
//#if defined(__TI_EABI__)
   .bss             : > RAMGS4
   .bss:output      : > RAMGS4
   .init_array      : > FLASH_BANK4, ALIGN(8)
   .const           : > FLASH_BANK4, ALIGN(8)
   .data            : > RAMGS4
   .sysmem          : > RAMGS4


   .setupCall 		:> FLASH_MODULE_SETUP_CALL_PTR
   .moduleInit		:> FLASH_MODULE_INIT_CALL_PTR
   .FlashBuffers	:> FLASH_BUFFER_PTRS
   .IsrFuncs		:> FLASH_ISR_FUNC_PTRS
   .IdleFuncs		:> FLASH_IDLE_FUNC_PTRS
   .ExcptPtrs		:> FLASH_EXCEPTION_FUNC_PTRS
   .AbortPtr		:> FLASH_ABORT_FUNC_PTRS
   .GenesisVerse	:> FLASH_GENESIS_VERSE
   .SealRevision	:> FLASH_SEAL_REV
   .DeviceSetup 	:> FLASH_DEVICE_SETUP


   //ramgs0 : > RAMGS0, type=NOINIT
   //ramgs1 : > RAMGS1, type=NOINIT
   //ramgs2 : > RAMGS2, type=NOINIT


}

/*
//===========================================================================
// End of file.
//===========================================================================
*/
