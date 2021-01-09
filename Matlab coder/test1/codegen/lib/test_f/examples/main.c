/*
 * File: main.c
 *
 * MATLAB Coder version            : 4.2
 * C/C++ source code generated on  : 08-Jul-2020 16:34:44
 */

/*************************************************************************/
/* This automatically generated example C main file shows how to call    */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/
/* Include Files */
#include "test_f.h"
#include "main.h"
#include "test_f_terminate.h"
#include "test_f_initialize.h"

/* Function Declarations */
static short argInit_int16_T(void);
static void main_test_f(void);

/* Function Definitions */

/*
 * Arguments    : void
 * Return Type  : short
 */
static short argInit_int16_T(void)
{
  return 0;
}

/*
 * Arguments    : void
 * Return Type  : void
 */
static void main_test_f(void)
{
  short y;

  /* Initialize function 'test_f' input arguments. */
  /* Call the entry-point 'test_f'. */
  y = test_f(argInit_int16_T(), argInit_int16_T());
}

/*
 * Arguments    : int argc
 *                const char * const argv[]
 * Return Type  : int
 */
int main(int argc, const char * const argv[])
{
  (void)argc;
  (void)argv;

  /* Initialize the application.
     You do not need to do this more than one time. */
  test_f_initialize();

  /* Invoke the entry-point functions.
     You can call entry-point functions multiple times. */
  main_test_f();

  /* Terminate the application.
     You do not need to do this more than one time. */
  test_f_terminate();
  return 0;
}

/*
 * File trailer for main.c
 *
 * [EOF]
 */
