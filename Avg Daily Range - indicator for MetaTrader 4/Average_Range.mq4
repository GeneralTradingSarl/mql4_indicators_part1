//+------------------------------------------------------------------+
//|                                              Avg Daily Range.mq4 |
//|                 Copyright © 2005, tageiger aka fxid10t@yahoo.com |
//|                                        http://www.metatrader.org |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, tageiger aka fxid10t@yahoo.com"
#property link      "http://www.metatrader.org"
//----
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Yellow
#property indicator_color2 SpringGreen
#property indicator_color3 Tomato
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double rng,sum_rng,avg_rng;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,ExtMapBuffer3);
//----
  return(0);}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  int deinit()   {return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  int start()
  {
   int    counted_bars=IndicatorCounted();
   rng=0;sum_rng=0;avg_rng=0;
   for(int i=0;i<Bars;i++)
     {
      rng=(iHigh(Symbol(),Period(),i)-iLow(Symbol(),Period(),i));
      sum_rng+=rng;
     }
   int db=iBars(Symbol(),Period());
   avg_rng=sum_rng/db;
   //----
   for(int s=0;s<Bars;s++)
     {
      ExtMapBuffer2[s]=(iOpen(Symbol(),Period(),s)+(avg_rng/2));
      ExtMapBuffer3[s]=(iOpen(Symbol(),Period(),s)-(avg_rng/2));
     }
   Comment("Last Tick: ",TimeToStr(CurTime(),TIME_DATE|TIME_SECONDS),"\n",
           "Sum of Period Ranges:",sum_rng,"\n",
           "Average Range:",avg_rng,"\n",
           "Total Bars:",i+1);
   return(0);
  }
//+------------------------------------------------------------------+