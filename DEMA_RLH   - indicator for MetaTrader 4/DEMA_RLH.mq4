//+------------------------------------------------------------------+
//|                                                   DEMA_RLH       |
//|                                    Copyright © 2006, Robert Hill |
//|                                       http://www.metaquotes.net/ |
//|                                                                  |
//| Based on the formula developed by Patrick Mulloy                 |
//|                                                                  |
//| It can be used in place of EMA or to smooth other indicators.    |
//|                                                                  |
//| DEMA = 2 * EMA - EMA of EMA                                      |
//|                                                                  |
//|  Red is EMA, Green is EMA of EMA, Yellow is DEMA                 |
//|                                                                  |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2006, Robert Hill "
#property  link      "http://www.metaquotes.net/"
//---- indicator settings
#property  indicator_chart_window
#property  indicator_buffers 3
#property  indicator_color1  Red
#property  indicator_color2  Green
#property  indicator_color3  Yellow
#property  indicator_width1  2
#property  indicator_width2  2
#property  indicator_width3  2
//----
extern int EMA_Period=14;
//---- buffers
double Dema[];
double Ema[];
double EmaOfEma[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- drawing settings
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexDrawBegin(0,EMA_Period);
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS)+2);
//---- 3 indicator buffers mapping
   SetIndexBuffer(0,Ema);
   SetIndexBuffer(1,EmaOfEma);
   SetIndexBuffer(2,Dema);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("DEMA("+EMA_Period+")");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int i;
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+EMA_Period;
//----
   for(i=limit; i>=0; i--)
      Ema[i]=iMA(NULL,0,EMA_Period,0,MODE_EMA,PRICE_CLOSE,i);
   for(i=limit; i >=0; i--)
      EmaOfEma[i]=iMAOnArray(Ema,0,EMA_Period,0,MODE_EMA,i);
   //========== COLOR CODING ===========================================               
   for(i=limit; i >=0; i--)
      Dema[i]=2 * Ema[i] - EmaOfEma[i];
   return(0);
  }
//+------------------------------------------------------------------+

-----------+
