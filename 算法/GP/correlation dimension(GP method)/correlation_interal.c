#include <math.h>
#include "mex.h"
#include "stdio.h"
#include "stdlib.h"
#include "matrix.h"

//---------------------------------------------------------------------------
// �����������
#define M prhs[0]           // Ƕ��ά��
#define X prhs[1]           // ʱ�����У���������
#define R prhs[2]           // ��������r
#define T prhs[3]           // ʱ���ӳ�

// �����������
#define S plhs[0]

// ���� C ���㺯�� (�ú��������ܺͱ��ļ�������)
double GUANLIAN_JIFEN();
double MAX_VECTOR();
double Heaviside();
double ABS();

//---------------------------------------------------------------------------
void mexFunction (int nlhs, mxArray *plhs[],         // ��������������������������
             int nrhs, const mxArray *prhs[])   // ��������������������������
{
      double *px,r,*ps;
      int m,t,N;

    // ȡ���������
    m = (int) *mxGetPr(M);      // Ƕ��ά��       
    px = mxGetPr(X);            // ʱ�����У���������
    N = mxGetN(X);              // ���г���
    r = *mxGetPr(R);            // ��������r                
    t = (int) *mxGetPr(T);      // ʱ���ӳ�      
    
    // Ϊ������������ڴ�ռ�
    S = mxCreateDoubleMatrix(1,1,mxREAL);
    
    // ȡ���������ָ��
    ps = mxGetPr(S);

    // ���� C ���㺯�� (�ú��������ܺͱ��ļ�������)
    *ps = GUANLIAN_JIFEN(m,px,N,r,t);
    return;
}

//---------------------------------------------------------------------------
// ����������֣����ع�������ֵ
double GUANLIAN_JIFEN( int m,          // Ƕ��ά��
                     double *px,     // ʱ�����У���������
                     int N,          // ���г���
                     double r,       // ��������r
                     int t)          // ʱ���ӳ�
{
    double d_ij,*pd_vector,temp,c,d;
    int i,j,j1,j2,xn_cols;
    
    pd_vector = malloc(m*sizeof(double));       // ����һ������Ϊ m �� double ������
    xn_cols = N-(m-1)*t;                        // xn ����

    // �μ�<<����ʱ�����з�����Ӧ��>> P67 ʽ(3.23)
    temp = 0;
    for (j1=0; j1<xn_cols; j1++)
    {   for (j2=j1+1; j2<xn_cols; j2++)
        {   for (i=0;i<m;i++)
            {
                d = *(px+i*t+j1) - *(px+i*t+j2);
                *(pd_vector+i) = ABS(d);
            }
            d_ij = MAX_VECTOR(pd_vector,m);     // �����������ֵ
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
// �����������ֵ
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
// ����Heaviside����ֵ
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
// �������ֵ
double ABS(double x)
{
    double y;
    if (x>=0)
        y = x;
    else
        y = -x;
    return y;
}
