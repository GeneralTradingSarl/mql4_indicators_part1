
//+------------------------------------------------------------------+
//|                                                    DayOfWeek.mq4 |
//|                          Copyright c 2006, Gordago Software Ltd. |
//|                                           http://www.gordago.com |
//+------------------------------------------------------------------+
#property copyright "Copyright c 2006, Gordago Software Ltd."
#property link      "http://www.gordago.com"
//----
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 SpringGreen
//---- input parameters
extern int       prmWeek=2;
//---- buffers
double ExtMapBuffer1[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,108);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexEmptyValue(0,0.0);
//----
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
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int pos = Bars - counted_bars;
   if(counted_bars==0) pos--;
     while(pos>=0){
      if (prmWeek==TimeDayOfWeek(Time[pos]))
         ExtMapBuffer1[pos]=High[pos]+Point*3;
      else
         ExtMapBuffer1[pos]=0.0;
      pos--;
     }
   return(0);
  }
//+------------------------------------------------------------------+
   