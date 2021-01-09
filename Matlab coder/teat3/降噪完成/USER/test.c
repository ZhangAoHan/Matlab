#include "sys.h"
#include "usart.h"		
#include "delay.h"	 
#include "lcd.h"
#include "touch.h"  
#include "w25q128.h"  
#include "text.h"	
#include <math.h>
void init_display(void);
double cc(const double b_y1[9], const double y2[9]);
		double a[9];
		double b[9];
int main(void)
{				 
 u8 i;
	double kk;
	Stm32_Clock_Init(9);	//ϵͳʱ������
	delay_init(72);	  		//��ʱ��ʼ��
	uart_init(72,115200); 	//���ڳ�ʼ��Ϊ115200
	LCD_Init();
//	W25QXX_Init();				//��ʼ��W25Q128 ��SPI2
//	tp_dev.init();			//��������ʼ�� 
	while(font_init()) 			//����ֿ�
	{;}  
//		LCD_DrawRectangle(10,10,150,80);
//		LCD_ShowString(11,11,80,16,16,"right");
//		LCD_DrawRectangle(10,100,150,170);
//		LCD_ShowString(11,101,64,16,16,"left");
//		Show_Str(150,200,48,24,"У׼",24,0);
//		Show_Str(0,10,96,24,"���ݳ���",24,0);
//		Show_Str(0,50,96,24,"������",24,0);
//		Show_Str(0,90,96,24,"��������",24,0);
		//		Show_Str(0,50,96,24,"������",24,0);
				LCD_Clear(WHITE); 
		Show_Str(12,0,240,24,"Matlab Coder ʵ��",24,0);
 
		init_display();
		Show_Str(0,60,144,24,"ʵ�����飺",24,0);
				Show_Str(0,150,144,24,"��������",24,0);
for(i=1;i<10;i++)
{
	a[i]=i;
	b[i]=i+7;
	LCD_ShowxNum(0+i*10,90,a[i],1,16,0);
LCD_ShowxNum(0+i*20,120,b[i],2,16,0);
}

  	while(1)
	{

			kk=cc(a,b);
		kk=kk*10000;
		Show_Str(120,150,24,24,"0.",24,0);
		LCD_ShowxNum(144,150,kk,4,24,0);
				}
				
				
				
//display();
		
} 


void init_display(void)  //
{
	Show_Str(80,30,96,24,"PCC�㷨",24,0);
}

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

    /* ?XY */
    X += b_y1[i] * b_y1[i];

    /* ?X.^2 */
    Y += y2[i] * y2[i];

    /* ?Y.^2 */
  }

  return XY / sqrt(X * Y);
}

