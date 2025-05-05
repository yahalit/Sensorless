/*
 * BITTimerAlloc.h
 *
 *  Created on: May 13, 2023
 *      Author: yahal
 */

#ifndef APPLICATION_BITTIMERALLOC_H_
#define APPLICATION_BITTIMERALLOC_H_

//#define NSYS_TIMER_CMP_ARRAY 16
#define TIMER_ARR_STAM_WAIT_IDLE 0 // Reserved
#define TIMER_RELEASE_BRAKE   2 // Time for brake release after motor on
#define TIMER_OVERLAP_BRAKE   3 // Time for overlapping brake release action and motor on
#define TIMER_ENGAGE_BRAKE   4 // Time for brake engage before motor off
#define TIMER_MCAN_BUSOFF   5 // Timer for MCAN Bus off recovery
#define TIMER_AUTO_MOTOROFF 6 // Timer for automatic motor shut down on motion convergence
#define TIMER_AUTO_MIN_MOTORON 7 // Timer for prevention of auto shutting too early


#endif /* APPLICATION_BITTIMERALLOC_H_ */
