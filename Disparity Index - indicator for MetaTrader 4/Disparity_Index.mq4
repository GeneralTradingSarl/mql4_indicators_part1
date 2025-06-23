//+------------------------------------------------------------------+
//|                                              Disparity Index.mq4 |
//|                                                         Linuxser |
//|                                          contact me in Forex TSD |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
//----
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red
//---- input parameters
extern int DispPeriod = 13;
//---- buffers
double DispBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- indicator line
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, DispBuffer);
//---- name for DataWindow and indicator subwindow label
   short_name = "Disparity Index(" + DispPeriod + ")";
   IndicatorShortName(short_name);
   SetIndexLabel(0, short_name);
//----
   SetIndexDrawBegin(0, DispPeriod);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Momentum                                                         |
//+------------------------------------------------------------------+
int start()
  {
   int i, counted_bars = IndicatorCounted();
//----
   if(Bars <= DispPeriod) 
       return(0);
//---- initial zero
   if(counted_bars < 1)
       for(i = 1; i <= DispPeriod; i++) 
           DispBuffer[Bars-i] = 0.0;
//----
   i = Bars - DispPeriod - 1;
   if(counted_bars >= DispPeriod) 
       i = Bars - counted_bars - 1;
   while(i >= 0)
     {
       DispBuffer[i] = ((Close[i] - iMA(NULL, 0, DispPeriod, 0, 
                        MODE_EMA, PRICE_CLOSE, i)) / 
                        (iMA(NULL, 0, DispPeriod, 0, MODE_EMA, 
                        PRICE_CLOSE, i))*100);
       i--;
     }
   return(0);
  }
//+------------------------------------------------------------------+