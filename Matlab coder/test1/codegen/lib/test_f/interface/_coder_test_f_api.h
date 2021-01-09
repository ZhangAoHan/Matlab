/*
 * File: _coder_test_f_api.h
 *
 * MATLAB Coder version            : 4.2
 * C/C++ source code generated on  : 08-Jul-2020 16:34:44
 */

#ifndef _CODER_TEST_F_API_H
#define _CODER_TEST_F_API_H

/* Include Files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_test_f_api.h"

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern int16_T test_f(int16_T a, int16_T b);
extern void test_f_api(const mxArray * const prhs[2], int32_T nlhs, const
  mxArray *plhs[1]);
extern void test_f_atexit(void);
extern void test_f_initialize(void);
extern void test_f_terminate(void);
extern void test_f_xil_shutdown(void);
extern void test_f_xil_terminate(void);

#endif

/*
 * File trailer for _coder_test_f_api.h
 *
 * [EOF]
 */
