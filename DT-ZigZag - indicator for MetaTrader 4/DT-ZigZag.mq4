//+------------------------------------------------------------------+ 
//|                                                    DT-ZigZag.mq4 | 
//+------------------------------------------------------------------+ 
#property copyright "klot"
#property link      "klot@mail.ru"
//----
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red
//---- input parameters 
extern int GrossPeriod=60;
extern int ExtDepth=12;
extern int ExtDeviation=5;
extern int ExtBackstep=3;
//---- buffers 
double ExtMapBuffer1[];
datetime daytimes[];
bool copied=false;
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
//---- 
   if(Period()>GrossPeriod) { Alert("DT-ZigZag: Текущий таймфрейм должен быть меньше чем ",GrossPeriod); return(0); }
   copied=false;
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
   if(!copied)
     {
      copied=(ArrayCopySeries(daytimes,MODE_TIME,Symbol(),GrossPeriod)>0);
      if(!copied) return(0);
     }
   int    limit,bigshift;
   int    counted_bars=IndicatorCounted();
//---- 
   if(counted_bars<0) return(-1);
//----
   limit=Bars-counted_bars;
   if(counted_bars==0) limit=MathMin(limit,ArraySize(daytimes));
//----
   for(int i=1; i<limit; i++)
     {
      if(Time[i]>=daytimes[0]) bigshift=0;
      else
        {
         bigshift=ArrayBsearch(daytimes,Time[i-1],WHOLE_ARRAY,0,MODE_DESCEND);
         if(Period()<=GrossPeriod) bigshift++;
        }
      ExtMapBuffer1[i]=iCustom(NULL,GrossPeriod,"ZigZag",ExtDepth,ExtDeviation,ExtBackstep,0,bigshift);
     }
//---- 
   return(0);
  }
//+------------------------------------------------------------------+ 
