  //+----------------------------------------------------------------+
//|                                           Ergodic Oscillator.mq4 |
//|                      Copyright © 2005, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red
#property indicator_level1 0
#property indicator_level2 20
#property indicator_level3 -20
//---- input parameters
extern int First_R = 8;
extern int Second_S = 5;
extern int SignalPeriod = 5;
extern int Mode_Smooth = 1;
//---- buffers
double ErgodicBuffer[];
double Signal_Buffer[];
double TSI_Siganl_Buffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorBuffers(3);
//----
   SetIndexBuffer(2, TSI_Siganl_Buffer);
//----
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, ErgodicBuffer);
   SetIndexLabel(0, "Ergodic");
   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(1, Signal_Buffer);
   SetIndexLabel(1, "Signal");
   IndicatorShortName("ErgodicOsc"+"("+First_R+","+Second_S+","+SignalPeriod+")");
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
   int limit, i;
   limit = Bars - counted_bars - 1;
   for(i = limit; i >= 0; i--)
     {
       TSI_Siganl_Buffer[i] = iCustom(NULL, 0, "TSI-Osc", First_R, Second_S, 
                                      SignalPeriod, Mode_Smooth, 1, i);
     }
//----
   for(i = limit; i >= 0; i--)
     {
       ErgodicBuffer[i] = iMAOnArray(TSI_Siganl_Buffer, 0, 5, 0, MODE_EMA, i);
     }
//----
   for(i = limit; i >= 0; i--)
     {
       Signal_Buffer[i] = iMAOnArray(ErgodicBuffer, 0, 5, 0, MODE_EMA, i);
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+