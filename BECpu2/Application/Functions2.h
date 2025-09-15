/*
 * Functions.h
 *
 *  Created on: Apr 9, 2025
 *      Author: user
 */

#ifndef APPLICATION_FUNCTIONS2_H_
#define APPLICATION_FUNCTIONS2_H_


// Interrupt handler functions
void interrupt FindPosMgrIsr();


// Algorithms
/////////////////////////////////////////////////
/*
 * Ready regression structure for new cycle
 */
void ClearRegression(struct CRegression * r);

/*
 * Add a data item to a regression structure
 */
void RegressionAddXY( struct CRegression * r , float x , float y ) ;

/*
 * Solve regression based on collected data
 */
short RegressionSolve( struct CRegression * r , float *a , float *b );

/*
 * Find the time to reach a given current level
 */
float TimeForCurrent( float I , float r , float L , float Vdc);


/* Utility
 *
 */
void ClearMem(short unsigned *ptr_in , short unsigned n);



// PrjMCAN
void setupMCAN2(long unsigned CanId[], long unsigned CanIDMask[] ,  long unsigned ExtCanId[], long unsigned ExtCanIDMask[] );

void RtCanService(void);
short SetMsg2HW(struct CCanMsg  *pMsg );
void SetBootUpMessage( void );
void SetExtendedBootUpMessage( void );
void SetLLCBootUpMessage( void );
void RTDealBlockUpload(void);
void DealBlockDloadRt();
void BlockUploadConfirmService( struct CCanMsg *pMsg) ;
short PutCanSlaveQueue( struct CCanMsg * pMsg);


// Hardware drivers
void setupGpioCAN(void);

// Low level
void TestAvailableConnections(void);
void RtUartService(void);


// Loader
void IdleSealLoader (void) ;

// Seal basics
void GoSeal(void) ;

#endif /* APPLICATION_FUNCTIONS2_H_ */
