//+------------------------------------------------------------------+
//|                                            DynamicRS+Channel.mq4 |
//|                                 Copyright © 2007, Nick A. Zhilin |
//|                                                  rebus58@mail.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, Nick A. Zhilin"
#property link      "rebus58@mail.ru"

extern int Filter=15;

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Yellow
#property indicator_color2 Red
#property indicator_color3 Aqua

//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorShortName("DynamicRS+Channel");
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,ExtMapBuffer3);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| DynamicRS+Channel                                                |
//+------------------------------------------------------------------+
int start()
  {
//----
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int i=Bars-counted_bars;
   if(counted_bars==0) i-=1+1;
   
   while(i>=0)
     {
      if(High[i]<High[i+1] && High[i]<ExtMapBuffer1[i+1]-Filter*Point)
         ExtMapBuffer1[i]=High[i];
      else if(Low[i]>Low[i+1] && Low[i]>ExtMapBuffer1[i+1]+Filter*Point)
         ExtMapBuffer1[i]=Low[i];
      else
         ExtMapBuffer1[i]=ExtMapBuffer1[i+1];

      ExtMapBuffer2[i]=ExtMapBuffer1[i]+Filter*Point;
      ExtMapBuffer3[i]=ExtMapBuffer1[i]-Filter*Point;

      i--;
     }

//----
   return(0);
  }
//+------------------------------------------------------------------+
