
#ifdef REC_VARS_OWNER
// Flags = 0 for long , 2 + float (see more options in the CRecorderSig definition)
//struct CRecorderSig RecorderSig[SIG_TABLE_SIZE] ;
//unsigned long RecorderBuffer[REC_BUF_LEN]; //<! Recorder buffer

unsigned long volatile RecorderBuffer[REC_BUF_LEN]; //<! Recorder buffer
#pragma DATA_SECTION(RecorderBuffer, ".data"); // Assure in DMA-accesible RAM

#else
extern const struct CRecorderSig RecorderSigRaw[] ;
//extern const short unsigned NREC_SIG ;

//extern unsigned long RecorderBuffer[]; //<! Recorder buffer
extern unsigned long  volatile RecorderBuffer[] ;

#endif

