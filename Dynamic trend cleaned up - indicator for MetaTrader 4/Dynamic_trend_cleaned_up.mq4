// +------------------------------------------------------------------+ 
// | The percentage indicator basis on break                          | 
// | of the dynamic price channel                                     | 
// | BDPC_Percent.mq4                                                 |  
// | Copyright © 2004, OfficeFX Group                                 | 
// | http: // officefx.nm.ru                                          | 
// +------------------------------------------------------------------+ 
#property copyright " Copyright © 2004, OfficeFX Group "
#property link " http:// officefx.nm.ru "
//----
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Red   // BUY signal 
#property indicator_color2 Blue  // BUY signal 
#property indicator_color3 Green // SELL signal 
//----Indicator Buffers--------------------------------------------+
double DynamicLineTrend [];      // Data buffer for dynamic line trend 
double BUYSignals [];            // Data buffer for BUY signals 
double SELLSignals [];           // Data buffer for SELL signals 
//----User defines-------------------------------------------------
extern int Percent=15;           // Percent dynamic channel
extern int MaxPeriod=50;         // Maximal period for calculate trend 
 //----Variables----------------------------------------------------+ 
 int Shift=0;                    // Current bar for calculate trend 
//+------------------------------------------------------------------+ 
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
 int init ()
  {
   SetIndexStyle (0, DRAW_LINE);
   SetIndexBuffer(0, DynamicLineTrend);
   //
   SetIndexStyle (1, DRAW_ARROW);
   SetIndexArrow (1,233);
   SetIndexBuffer(1, BUYSignals);
   //
   SetIndexStyle (2, DRAW_ARROW);
   SetIndexArrow (2,234);
   SetIndexBuffer(2, SELLSignals);
   return(0);
  }
//+------------------------------------------------------------------+ 
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+ 
 int start ()
  {
   // Get digits of Symbol 
   double point=MarketInfo (Symbol (), MODE_POINT);
   // Set count bars for calculate trend
   int Counted_Bars=IndicatorCounted ()-MaxPeriod;
//----Calculation DynamicLineTrend---------------------------------+
   for( Shift=Counted_Bars; Shift>=0; Shift--)
     {
      // Calculate of maximal period 
      if (Close [Shift] <DynamicLineTrend [Shift+1])
        {
         // Calculate Upper trend
         DynamicLineTrend [Shift] =Close [Highest (NULL, 0, MODE_CLOSE, MaxPeriod, Shift+1)]-Percent*point;
        }
      if (Close [Shift]>=DynamicLineTrend [Shift+1])
        {
         // Calculate Down trend
         DynamicLineTrend [Shift] =Close [Lowest (NULL, 0, MODE_CLOSE, MaxPeriod, Shift+1)] +Percent*point;
        }
      // Checkcrosses DynamicLineTrend and Price
      if (Close [Shift+3]> DynamicLineTrend [Shift+2])
         if (Close [Shift+2] <DynamicLineTrend [Shift+3])
            BUYSignals [Shift] =Low [Shift]-10*point;
         else
            BUYSignals [Shift] =0;
      else
         BUYSignals [Shift] =0;
      if (Close [Shift+2] <DynamicLineTrend [Shift+1])
         if (Close [Shift+2]> DynamicLineTrend [Shift+3])
            SELLSignals [Shift] =High [Shift]-10*point;
         else
            SELLSignals [Shift] =0;
      else
         SELLSignals [Shift] =0;
     }
//-----
   return(0);
  }
//+------------------------------------------------------------------+