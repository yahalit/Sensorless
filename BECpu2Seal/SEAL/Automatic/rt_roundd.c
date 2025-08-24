/*
 * File: rt_roundd.c
 *
 * Code generated for Simulink model 'Seal'.
 *
 * Model version                  : 11.61
 * Simulink Coder version         : 25.1 (R2025a) 21-Nov-2024
 * C/C++ source code generated on : Tue Aug 19 09:56:33 2025
 */

#include "rtwtypes.h"
#include "rt_roundd.h"
#include <math.h>

real_T rt_roundd(real_T u)
{
  real_T y;
  if (fabs(u) < 4.503599627370496E+15) {
    if (u >= 0.5) {
      y = floor(u + 0.5);
    } else if (u > -0.5) {
      y = 0.0;
    } else {
      y = ceil(u - 0.5);
    }
  } else {
    y = u;
  }

  return y;
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
