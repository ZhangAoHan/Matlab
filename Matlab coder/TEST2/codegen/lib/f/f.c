/*
 * File: f.c
 *
 * MATLAB Coder version            : 4.2
 * C/C++ source code generated on  : 09-Jul-2020 16:08:39
 */

/* Include Files */
#include <math.h>
#include "f.h"

/* Function Definitions */

/*
 * �������źŵ����ϵ��  Խ��Խ��(1����ȫһ�������ƣ�  -1����ȫ�����)
 *  y1��y2���볤����ͬ
 * Arguments    : const double b_y1[1000]
 *                const double y2[1000]
 * Return Type  : double
 */
double f(const double b_y1[1000], const double y2[1000])
{
  double XY;
  double X;
  double Y;
  int i;
  XY = 0.0;
  X = 0.0;
  Y = 0.0;
  for (i = 0; i < 1000; i++) {
    XY += b_y1[i] * y2[i];

    /* ��XY */
    X += b_y1[i] * b_y1[i];

    /* ��X.^2 */
    Y += y2[i] * y2[i];

    /* ��Y.^2 */
  }

  return XY / sqrt(X * Y);
}

/*
 * File trailer for f.c
 *
 * [EOF]
 */
