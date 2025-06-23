//+------------------------------------------------------------------+
//|                                     Full_Bar_w_Spread_Shadow.mq4 |
//|                              transport_david , David W Honeywell |
//|                                        transport.david@gmail.com |
//+------------------------------------------------------------------+
#property copyright "transport_david , David W Honeywell"
#property link      "transport.david@gmail.com"
//----
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Lime
#property indicator_color2 Lime
#property indicator_color3 Coral
#property indicator_color4 Coral
//---- input parameters
//---- buffers
double ExtMapBuffer0[];
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM, 0, 1);
   SetIndexBuffer(0, ExtMapBuffer0);
   SetIndexStyle(1,DRAW_HISTOGRAM, 0, 1);
   SetIndexBuffer(1, ExtMapBuffer1);
   SetIndexStyle(2,DRAW_HISTOGRAM, 0, 1);
   SetIndexBuffer(2, ExtMapBuffer2);
   SetIndexStyle(3,DRAW_HISTOGRAM, 0, 1);
   SetIndexBuffer(3, ExtMapBuffer3);
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
   double spread, Hsplitprice, Lsplitprice, Top, TopPlus;
   int counted_bars=IndicatorCounted();
   if  (counted_bars<0) return(-1);
   if  (counted_bars>0) counted_bars--;
   int i;
//---- 
   for(i=counted_bars-1; i>=0; i--)
     { spread=(Ask-Bid);
      TopPlus=(High[i]+spread);
      Top=(High[i]);
      Hsplitprice=(Close[i]+spread);
      Lsplitprice=(Close[i]);
//----
      ExtMapBuffer0[i]=TopPlus;
      if (Top <  Hsplitprice) { ExtMapBuffer1[i]=Hsplitprice; }
      if (Top>=Hsplitprice) { ExtMapBuffer1[i]=Top; }
      ExtMapBuffer2[i]=Hsplitprice;
      ExtMapBuffer3[i]=Lsplitprice;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+