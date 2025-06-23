//+------------------------------------------------------------------+
//|                                                   Ask_Shadow.mq4 |
//|                              transport_david , David W Honeywell |
//|                                        transport.david@gmail.com |
//+------------------------------------------------------------------+
#property copyright "transport_david , David W Honeywell"
#property link      "transport.david@gmail.com"
//----
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Red
//---- input parameters
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM, 0, 1, Coral);
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexStyle(1,DRAW_HISTOGRAM, 0, 1, Coral);
   SetIndexBuffer(1, ExtMapBuffer2);
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
   double spread, Top, TopPlus;
   int counted_bars=IndicatorCounted();
   if  (counted_bars<0) return(-1);
   if  (counted_bars>0) counted_bars--;
   int i;
//---- 
   for(i=counted_bars-1; i>=0; i--)
     {
      spread=(Ask-Bid);
      TopPlus=(High[i]+spread);
      Top=(High[i]);
      ExtMapBuffer1[i]=TopPlus;
      ExtMapBuffer2[i]=Top;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+