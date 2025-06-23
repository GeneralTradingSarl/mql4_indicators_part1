//+------------------------------------------------------------------+
//|                                          EMA_Trend_Indicator.mq4 |
//|                                Copyright © 2006, Robert L Hill   |
//+------------------------------------------------------------------+
// Uses an idea from david to use EMAs to determine trend
#property copyright "Copyright © 2005, Metaquotes"
#property link      "mailto:metaquotes@metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Blue
#property indicator_color2 Red
#property indicator_color3 Magenta
#property indicator_color4 DodgerBlue
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 1
#property indicator_width4 1
//---- input parameters
extern int FastMAPeriod=21;
extern int SlowMAPeriod=34;
//---- buffers
double fastEMA_HighBuffer[];
double fastEMA_LowBuffer[];
double slowEMA_HighBuffer[];
double slowEMA_LowBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorDigits(MarketInfo(Symbol(), MODE_DIGITS) + 1);
   //---- indicators
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, slowEMA_HighBuffer);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(1, slowEMA_LowBuffer);
   SetIndexStyle(2, DRAW_LINE);
   SetIndexBuffer(2, fastEMA_HighBuffer);
   SetIndexStyle(3, DRAW_LINE);
   SetIndexBuffer(3, fastEMA_LowBuffer);
   SetIndexDrawBegin(0, SlowMAPeriod);
   //---- name for DataWindow and indicator subwindow label
   IndicatorShortName("MA Trend ");
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
   int limit;
   int counted_bars = IndicatorCounted();
//---- check for possible errors
   if(counted_bars < 0) 
       return(-1);
//---- last counted bar will be recounted
   if(counted_bars > 0) 
       counted_bars--;
   limit = Bars - counted_bars;
//----
   for(int i = limit; i >= 0; i--)
     {
       fastEMA_HighBuffer[i] = iMA(NULL, 0, FastMAPeriod, 0, MODE_EMA, PRICE_HIGH, i);
       fastEMA_LowBuffer[i] = iMA(NULL, 0, FastMAPeriod, 0, MODE_EMA, PRICE_LOW, i);
       slowEMA_HighBuffer[i] = iMA(NULL, 0, SlowMAPeriod, 0, MODE_EMA, PRICE_HIGH, i);
       slowEMA_LowBuffer[i] = iMA(NULL, 0, SlowMAPeriod, 0, MODE_EMA, PRICE_LOW, i);
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+