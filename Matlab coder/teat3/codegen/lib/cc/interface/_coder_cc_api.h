/*
 * File: _coder_cc_api.h
 *
 * MATLAB Coder version            : 4.2
 * C/C++ source code generated on  : 21-Jul-2020 13:45:38
 */

#ifndef _CODER_CC_API_H
#define _CODER_CC_API_H

/* Include Files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_cc_api.h"

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern real_T cc(real_T b_y1[9], real_T y2[9]);
extern void cc_api(const mxArray * const prhs[2], int32_T nlhs, const mxArray
                   *plhs[1]);
extern void cc_atexit(void);
extern void cc_initialize(void);
extern void cc_terminate(void);
extern void cc_xil_shutdown(void);
extern void cc_xil_terminate(void);

#endif

/*
 * File trailer for _coder_cc_api.h
 *
 * [EOF]
 */
