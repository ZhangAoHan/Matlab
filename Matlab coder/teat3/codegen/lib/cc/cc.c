/*
 * File: cc.c
 *
 * MATLAB Coder version            : 4.2
 * C/C++ source code generated on  : 21-Jul-2020 13:45:38
 */

/* Include Files */
#include <math.h>
#include "cc.h"

/* Function Definitions */

/*
 * 输入待比较的两个时序信号 y1  y2
 * 求两个信号的相关系数  越大越好(1：完全一样（相似）  -1：完全不相关)
 *  y1和y2必须长度相同
 * Arguments    : const double b_y1[9]
 *                const double y2[9]
 * Return Type  : double
 */
double cc(const double b_y1[9], const double y2[9])
{
  double XY;
  double X;
  double Y;
  int i;
  XY = 0.0;
  X = 0.0;
  Y = 0.0;
  for (i = 0; i < 9; i++) {
    XY += b_y1[i] * y2[i];

    /* ∑XY */
    X += b_y1[i] * b_y1[i];

    /* ∑X.^2 */
    Y += y2[i] * y2[i];

    /* ∑Y.^2 */
  }

  return XY / sqrt(X * Y);
}

/*
 * File trailer for cc.c
 *
 * [EOF]
 */
