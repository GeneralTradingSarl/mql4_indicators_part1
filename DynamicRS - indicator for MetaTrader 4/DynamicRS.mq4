//+------------------------------------------------------------------+
//|                                                    DynamicRS.mq4 |
//|                                 Copyright © 2007, Nick A. Zhilin |
//|                                                  rebus58@mail.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, Nick A. Zhilin"
#property link      "rebus58@mail.ru"

extern int IPeriod=16;

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Yellow

//---- buffers
double ExtMapBuffer1[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorShortName("DynamicRS");
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| DynamicRS                                                        |
//+------------------------------------------------------------------+
int start()
  {
   int i,counted_bars=IndicatorCounted();

//----
   i=Bars-counted_bars-1;
   while(i>=0)
     {
      if(High[i]<High[i+1] && High[i]<High[i+IPeriod] && High[i]<ExtMapBuffer1[i+1])   
         ExtMapBuffer1[i]=High[i];
      else if(Low[i]>Low[i+1] && Low[i]>Low[i+IPeriod] && Low[i]>ExtMapBuffer1[i+1])
         ExtMapBuffer1[i]=Low[i];
      else
         ExtMapBuffer1[i]=ExtMapBuffer1[i+1];
         
      i--;
     }


//----
   return(0);
  }
//+------------------------------------------------------------------+