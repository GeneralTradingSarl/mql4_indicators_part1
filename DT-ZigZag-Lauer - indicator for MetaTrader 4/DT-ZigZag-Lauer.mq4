//+------------------------------------------------------------------+
//|                                              DT-ZigZag-Lauer.mq4 |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, klot"
#property link      "klot@mail.ru"
//----
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Blue
//---- input parameters
extern int       depth=5;
extern int GrossPeriod=240;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
datetime daytimes[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,159);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexEmptyValue(0,0.0);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,159);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexEmptyValue(1,0.0);
//----
//---- 
   if (Period()>GrossPeriod) { Alert("DT-ZigZag: Текущий таймфрейм должен быть меньше чем ", GrossPeriod); return(0); }
   // Все Time[] серии времени отсортировано в направлении убывания 
   ArrayCopySeries(daytimes,MODE_TIME,Symbol(),GrossPeriod);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- 
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   int    limit=300,bigshift;
   double zigzag1;
   if (counted_bars<0) return(-1);
   if (counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//---- 
   for(int i=0; i<limit; i++)
     {
      if(Time[i]>=daytimes[0]) bigshift=0;
      else
        {
         bigshift=ArrayBsearch(daytimes,Time[i-1],WHOLE_ARRAY,0,MODE_DESCEND);
         if(Period()<=GrossPeriod) bigshift++;
        }
      for(int cnt=bigshift; cnt<(100+bigshift); cnt++)
        {
         zigzag1=iCustom(NULL,GrossPeriod,"ZigZag",depth,5,3,0,cnt+1);
         if(zigzag1!=0)break;
        }
      if(iClose(NULL,0,i+1)<=zigzag1) ExtMapBuffer2[i]=zigzag1; else ExtMapBuffer2[i]=0.0;
      if(iClose(NULL,0,i+1)>=zigzag1)ExtMapBuffer1[i]=zigzag1; else ExtMapBuffer1[i]=0.0;
      ObjectsRedraw();
     }
   // Comment("zigzag1 = ",zigzag1);
//----
   return(0);
  }
//+------------------------------------------------------------------+