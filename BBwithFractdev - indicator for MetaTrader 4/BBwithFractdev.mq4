//+------------------------------------------------------------------+
//|                                               BBwithFractdev.mq4 |
//|                                           Ким Игорь В. aka KimIV |
//|                                              http://www.kimiv.ru |
//|                                                                  |
//| Полосы Боллинджера с дробным коэффициентом отклонения            |
//+------------------------------------------------------------------+
#property copyright "Ким Игорь В. aka KimIV"
#property link      "http://www.kimiv.ru"
//----
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Green
#property indicator_color2 Blue
#property indicator_color3 Green
//---- input parameters
extern int    BB_Period=13;     // Период средней и отклонения
extern double Deviation=2.618;  // Коэффициент отклонения
//---- indicator buffers
double buf1[];
double buf2[];
double buf3[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
  void init()
  {
   SetIndexStyle(0, DRAW_LINE);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexStyle(2, DRAW_LINE);
   IndicatorDigits(MarketInfo(Symbol(), MODE_DIGITS));
//----
   SetIndexBuffer(0, buf1);
   SetIndexBuffer(1, buf2);
   SetIndexBuffer(2, buf3);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
  void start()
  {
   int i, j;
   double ave, sko, sum;
   if (Bars<=BB_Period) return;
   for(i=Bars-BB_Period; i>=0; i--)
     {
      buf2[i]=iMA(NULL,0,BB_Period,0,MODE_SMA,PRICE_CLOSE,i);
      sum=0;
      for(j=0; j<BB_Period; j++) sum+=Close[i+j];
      ave=sum/BB_Period;
      sum=0;
      for(j=0; j<BB_Period; j++) sum+=(Close[i+j]-ave)*(Close[i+j]-ave);
      sko=MathSqrt(sum/BB_Period);
      buf1[i]=buf2[i]+(Deviation*sko);
      buf3[i]=buf2[i]-(Deviation*sko);
     }
  }
//+------------------------------------------------------------------+

