//+------------------------------------------------------------------+
//|                                                    BBflat_sw.mq4 |
//|                                                          by Raff |
//+------------------------------------------------------------------+
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 Aqua
#property indicator_color2 Red
#property indicator_color3 Red
#property indicator_color4 Yellow
#property indicator_levelcolor  SlateGray
#property indicator_level1 0.0004
#property indicator_level2 -0.0004
//----
extern int period=9;
extern int shift=0;
extern int method=0;
extern int price=0;
extern double deviation=1.5;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
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
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,ExtMapBuffer4);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int limit, counted_bars=IndicatorCounted();
   double ima, std;
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   for(int i=0; i<limit; i++)
     {
      ima=iMA(NULL,0,period,shift,method,price,i);
      std=deviation*iStdDev(NULL,0,period,shift,method,price,i);
      ExtMapBuffer1[i]=0;
      ExtMapBuffer2[i]=std;
      ExtMapBuffer3[i]=-std;
      ExtMapBuffer4[i]=Close[i]-ima;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+