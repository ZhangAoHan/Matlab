/*
 * File: _coder_f_api.h
 *
 * MATLAB Coder version            : 4.2
 * C/C++ source code generated on  : 09-Jul-2020 16:08:39
 */

#ifndef _CODER_F_API_H
#define _CODER_F_API_H

/* Include Files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_f_api.h"

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern real_T f(real_T b_y1[1000], real_T y2[1000]);
extern void f_api(const mxArray * const prhs[2], int32_T nlhs, const mxArray
                  *plhs[1]);
extern void f_atexit(void);
extern void f_initialize(void);
extern void f_terminate(void);
extern void f_xil_shutdown(void);
extern void f_xil_terminate(void);

#endif

/*
 * File trailer for _coder_f_api.h
 *
 * [EOF]
 */
