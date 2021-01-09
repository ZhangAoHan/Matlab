/*
 * File: test_f.c
 *
 * MATLAB Coder version            : 4.2
 * C/C++ source code generated on  : 08-Jul-2020 16:34:44
 */

/* Include Files */
#include "test_f.h"

/* Function Definitions */

/*
 * Arguments    : short a
 *                short b
 * Return Type  : short
 */
short test_f(short a, short b)
{
  int i0;
  i0 = a + b;
  if (i0 > 32767) {
    i0 = 32767;
  } else {
    if (i0 < -32768) {
      i0 = -32768;
    }
  }

  return (short)i0;
}

/*
 * File trailer for test_f.c
 *
 * [EOF]
 */
