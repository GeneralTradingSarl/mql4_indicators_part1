//+------------------------------------------------------------------+
//|                                                   myEnvelope.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Blue
#property indicator_color2 Orange
#property indicator_color3 Orange

extern int FastEMA = 13;
extern int SlowEMA = 21;
extern double n = 2.7;

double EMABuffer[];
double UpperBuffer[];
double LowerBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);
//   SetIndexDrawBegin(1,EMA);
//   IndicatorDigits(Digits+1);
//   IndicatorShortName("Envelope("+EMA+")");

   IndicatorBuffers(3);
   SetIndexEmptyValue(0,0.0);
   SetIndexBuffer(0,EMABuffer);
   SetIndexEmptyValue(1,0.0);
   SetIndexBuffer(1,UpperBuffer);
   SetIndexEmptyValue(2,0.0);
   SetIndexBuffer(2,LowerBuffer);

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
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
   int counted_bars=IndicatorCounted();
   double sd;
//----
   for(int i = 0;i < (Bars - counted_bars);i++){
      EMABuffer[i] = iMA(NULL,0,SlowEMA,0,MODE_EMA,PRICE_CLOSE,i);
   }
   sd = iStdDev(NULL,0,FastEMA,0,MODE_EMA,PRICE_CLOSE,0);
   for(i = 0;i < (Bars - counted_bars);i++){
      UpperBuffer[i] = EMABuffer[i] + n * sd;
      LowerBuffer[i] = EMABuffer[i] - n * sd;
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+