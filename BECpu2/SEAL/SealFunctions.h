/*
 * SealFunctions.h
 *
 *  Created on: 23 Aug 2025
 *      Author: Yahali
 */

#ifndef SEAL_SEALFUNCTIONS_H_
#define SEAL_SEALFUNCTIONS_H_


void PrepSetupReportBuf(SetupReportBuf_T *pSetupReport) ;
void PrepFeedbackBuf(FeedbackBuf_T * pFeedbackBuf);
void UpdateDrvCmdBuf(DrvCommandBuf_T *pDrvCommandBuf);

void ThrowSealException( E_SealFatality fatality , short unsigned ExpCode );

#endif /* SEAL_SEALFUNCTIONS_H_ */
