//+------------------------------------------------------------------+
//|                                                    ATR ratio.mq4 |
//|                         Copyright © 2005, Luis Guilherme Damiani |
//|                                      http://www.damianifx.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, Luis Guilherme Damiani"
#property link      "http://www.damianifx.com.br"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red
//---- input parameters
extern int    short_atr = 7;
extern int    long_atr = 49;
extern double triglevel = 0.87;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(1, ExtMapBuffer2);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("ATRr(" + short_atr + ", " + long_atr + ")");
   SetIndexLabel(0, "ATRrTL");
   SetIndexLabel(1, "ATRr"); 
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars = IndicatorCounted();
   for(int i = 0; i < Bars - counted_bars; i++)
     {
       ExtMapBuffer1[i] = triglevel;
       double dAtrShort = iATR(NULL, 0, short_atr, i);
       double dAtrLong = iATR(NULL, 0, long_atr, i);
       if(dAtrLong != 0) 
           ExtMapBuffer2[i] = dAtrShort / dAtrLong;   
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+