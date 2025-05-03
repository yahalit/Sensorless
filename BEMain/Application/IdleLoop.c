/*
 * IdleLoop.c
 *
 *  Created on: May 14, 2023
 *      Author: yahal
 */
#include "StructDef.h"

const long unsigned JtagPass[2] = {0x90abcdef,0xffffffff} ;
#pragma DATA_SECTION(JtagPass, ".statistics");
#pragma RETAIN(JtagPass );
