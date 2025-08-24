/*
 * File: mod_CTxUEiaB.c
 *
 * Code generated for Simulink model 'Seal'.
 *
 * Model version                  : 11.61
 * Simulink Coder version         : 25.1 (R2025a) 21-Nov-2024
 * C/C++ source code generated on : Tue Aug 19 09:56:33 2025
 */

#include "rtwtypes.h"
#include "mod_CTxUEiaB.h"
#include <math.h>

/* Function for MATLAB Function: '<S5>/UART message response' */
real_T mod_CTxUEiaB(real_T x)
{
  real_T r;
  r = fmod(x, 10.0);
  if (r == 0.0) {
    r = 0.0;
  } else if (r < 0.0) {
    r += 10.0;
  }

  return r;
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
