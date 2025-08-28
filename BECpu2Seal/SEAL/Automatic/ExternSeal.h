#ifndef EXTERN_SEAL_DEF_H
#define EXTERN_SEAL_DEF_H
typedef const short unsigned * bPtr;
void (*InitFunc)(void)=Seal_initialize;
void (*SetupFunc)(void)=SetupDrive;
MicroInterp_T G_MicroInterp;
SetupReportBuf_T G_SetupReportBuf;
FeedbackBuf_T G_FeedbackBuf;
DrvCommandBuf_T G_DrvCommandBuf;
CANCyclicBuf_T *G_pCANCyclicBuf_out;
CANCyclicBuf_T *G_pCANCyclicBuf_in;
UartCyclicBuf_T *G_pUartCyclicBuf_in;
UartCyclicBuf_T *G_pUartCyclicBuf_out;
UFuncDescriptor_T IdleLoopFuncs[8] ={
{.desc={.func = (voidFunc) IdleLoopCAN, .FunType =E_Func_Idle, .Priority=8, .nInts = 1 , .Ts = 0.001 , .Algn=0, .Ticker = 0}},
{.desc={.func = (voidFunc) IdleLoopUART, .FunType =E_Func_Idle, .Priority=7, .nInts = 1 , .Ts = 0.001 , .Algn=0, .Ticker = 0}},
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}},
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}},
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}},
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}},
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}},
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}}};
UFuncDescriptor_T IsrFuncs[8] ={
{.desc={.func = (voidFunc) ISR100uProfiler, .FunType =E_Func_ISR, .Priority=8, .nInts = 2, .Ts=0.0001, .Algn=0, .Ticker = 0}},
{.desc={.func = (voidFunc) ISR100uController, .FunType =E_Func_ISR, .Priority=7, .nInts = 2, .Ts=0.0001, .Algn=0, .Ticker = 0}},
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}},
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}},
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}},
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}},
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}},
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}}};
UFuncDescriptor_T AbortFuncs[8] ={
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}},
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}},
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}},
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}},
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}},
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}},
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}},
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}}};
UFuncDescriptor_T ExceptionFuncs[8] ={
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}},
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}},
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}},
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}},
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}},
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}},
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}},
{.desc={.func = ((voidFunc)0UL), .FunType = E_Func_None, .Priority=0 , .nInts = 1, .Ts=0.001 ,.Algn=0, .Ticker = 0}}};
const short unsigned * BufferPtrs[16] = {(bPtr)&G_DrvCommandBuf,(bPtr)&G_FeedbackBuf,(bPtr)&G_SetupReportBuf,(bPtr)&G_pCANCyclicBuf_in,(bPtr)&G_pCANCyclicBuf_out,(bPtr)&G_pUartCyclicBuf_in,(bPtr)&G_pUartCyclicBuf_out,(bPtr)&G_SEALVerControl,0U,0U,0U,0U,0U,0U,0U,0U};
#endif
