/*
 * Functions.h
 *
 *  Created on: Apr 9, 2025
 *      Author: user
 */

#ifndef APPLICATION_FUNCTIONS_H_
#define APPLICATION_FUNCTIONS_H_


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

#endif /* APPLICATION_FUNCTIONS_H_ */
