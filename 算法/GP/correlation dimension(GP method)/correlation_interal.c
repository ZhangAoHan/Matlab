#include <math.h>
#include "mex.h"
#include "stdio.h"
#include "stdlib.h"
#include "matrix.h"

//---------------------------------------------------------------------------
// 定义输入参数
#define M prhs[0]           // 嵌入维数
#define X prhs[1]           // 时间序列（行向量）
#define R prhs[2]           // 给定正数r
#define T prhs[3]           // 时间延迟

// 定义输出参数
#define S plhs[0]

// 声明 C 运算函数 (该函数名不能和本文件名重名)
double GUANLIAN_JIFEN();
double MAX_VECTOR();
double Heaviside();
double ABS();

//---------------------------------------------------------------------------
void mexFunction (int nlhs, mxArray *plhs[],         // 输出参数个数，及输出参数数组
             int nrhs, const mxArray *prhs[])   // 输入参数个数，及输入参数数组
{
      double *px,r,*ps;
      int m,t,N;

    // 取得输入参数
    m = (int) *mxGetPr(M);      // 嵌入维数       
    px = mxGetPr(X);            // 时间序列（行向量）
    N = mxGetN(X);              // 序列长度
    r = *mxGetPr(R);            // 给定正数r                
    t = (int) *mxGetPr(T);      // 时间延迟      
    
    // 为输出变量分配内存空间
    S = mxCreateDoubleMatrix(1,1,mxREAL);
    
    // 取得输出参数指针
    ps = mxGetPr(S);

    // 调用 C 运算函数 (该函数名不能和本文件名重名)
    *ps = GUANLIAN_JIFEN(m,px,N,r,t);
    return;
}

//---------------------------------------------------------------------------
// 计算关联积分，返回关联积分值
double GUANLIAN_JIFEN( int m,          // 嵌入维数
                     double *px,     // 时间序列（行向量）
                     int N,          // 序列长度
                     double r,       // 给定正数r
                     int t)          // 时间延迟
{
    double d_ij,*pd_vector,temp,c,d;
    int i,j,j1,j2,xn_cols;
    
    pd_vector = malloc(m*sizeof(double));       // 声明一个长度为 m 的 double 型数组
    xn_cols = N-(m-1)*t;                        // xn 列数

    // 参见<<混沌时间序列分析及应用>> P67 式(3.23)
    temp = 0;
    for (j1=0; j1<xn_cols; j1++)
    {   for (j2=j1+1; j2<xn_cols; j2++)
        {   for (i=0;i<m;i++)
            {
                d = *(px+i*t+j1) - *(px+i*t+j2);
                *(pd_vector+i) = ABS(d);
            }
            d_ij = MAX_VECTOR(pd_vector,m);     // 计算数组最大值
            temp = temp + Heaviside(r-d_ij);            
        }
    }
    if (xn_cols<2)
        c = 0;
    else
        c = (double) 2/(xn_cols*(xn_cols-1))*temp;
    
    free(pd_vector);
        
    return c;
}

//---------------------------------------------------------------------------
// 计算数组最大值
double MAX_VECTOR(double *p_vector,
                  int len_vector)
{
    int i;    
    double max_value = *p_vector;
    for (i=1; i<len_vector; i++)
    {   if (*(p_vector+i)>max_value)
        {
            max_value = *(p_vector+i);
        }
    }
    return max_value;
}

//---------------------------------------------------------------------------
// 计算Heaviside函数值
double Heaviside(double x)
{
    double y;
    if (x>=0)
        y = 1;
    else
        y = 0;
    return y;
}

//---------------------------------------------------------------------------
// 计算绝对值
double ABS(double x)
{
    double y;
    if (x>=0)
        y = x;
    else
        y = -x;
    return y;
}
