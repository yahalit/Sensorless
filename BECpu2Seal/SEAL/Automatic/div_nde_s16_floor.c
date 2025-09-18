/*
 * File: div_nde_s16_floor.c
 *
 * Code generated for Simulink model 'Seal'.
 *
 * Model version                  : 11.134
 * Simulink Coder version         : 25.1 (R2025a) 21-Nov-2024
 * C/C++ source code generated on : Tue Sep  2 11:12:31 2025
 */

#include "div_nde_s16_floor.h"
#include "rtwtypes.h"

int16_T div_nde_s16_floor(int16_T numerator, int16_T denominator)
{
  return (((numerator < 0) != (denominator < 0)) && (numerator % denominator !=
           0) ? -1 : 0) + numerator / denominator;
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
