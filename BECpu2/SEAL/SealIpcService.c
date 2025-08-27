/*
 * SealIpcService.h
 *
 *  Created on: 23 Aug 2025
 *      Author: Yahali
 */


#include "..\Application\StructDef2.h"
#include "SealHeaders.h"



void PrepSetupReportBuf(SetupReportBuf_T *pSetupReport)
{
    *pSetupReport = UM2S.M2S.SetupReportBuf ;
}

void PrepFeedbackBuf(FeedbackBuf_T * pFeedbackBuf)
{
    *pFeedbackBuf = UM2S.M2S.FeedbackBuf  ;
    pFeedbackBuf->SystemTime = SealState.SystemTime ;
}

void UpdateDrvCmdBuf(DrvCommandBuf_T *pDrvCommandBuf)
{
    US2M.S2M.DrvCommandBuf  = *pDrvCommandBuf ;
}
