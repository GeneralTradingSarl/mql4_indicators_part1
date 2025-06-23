//+------------------------------------------------------------------+
//|                                                  DollarIndex.mq4 |
//|                                  Copyright © 2010, Shon Shampain |
//|                                       http://www.zencowsgomu.com |
//|                                                                  |
//|       Visit http://www.zencowsgomu.com, an oasis of sanity       |
//|                      for currency traders.                       |
//|                                                                  |
//|       Original out-of-the-box thinking, ideas, indicators,       |
//|                    educational EAs and more.                     |
//|                                                                  |
//|         Home of the consistent T4 Forex trading signal.          |
//|             Backtesting profitably since 1-1-2002.               |
//+------------------------------------------------------------------+

#property copyright "Shon Shampain"
#property link      "http://www.zencowsgomu.com"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Aqua

extern bool tenths = true;
int NUM_PAIRS = 7;
string currencies [7];
double mult [7];
double Index [];

int init()
{
   currencies[0] = "EURUSD";
   currencies[1] = "GBPUSD";
   currencies[2] = "USDJPY";
   currencies[3] = "USDCHF";
   currencies[4] = "AUDUSD";
   currencies[5] = "USDCAD";
   currencies[6] = "NZDUSD";
   
   for (int z = 0; z < NUM_PAIRS; z++)
   {
      int d = MarketInfo(currencies[z], MODE_DIGITS);
      if (tenths) d -= 1;
      mult[z] = 1.0;
      for (int x = 0; x < d; x++)
         mult[z] *= 10.0;
   }
   
   SetIndexBuffer(0, Index);
      
   SetLevelValue(0, 0.0);
   SetLevelStyle(STYLE_DOT, 1, Silver);
  
   return(0);
}

int deinit()
{
   return(0);
}
   
int start()
{
   int counted_bars;
   int i;
   int z;
   double value;
   
   counted_bars = IndicatorCounted();
   
   i = Bars - counted_bars - 1;
   while(i>=0)
   {
      value = 0.0;
      for (z = 0; z < NUM_PAIRS; z++)
      {
         bool short_usd = (StringFind(StringSubstr(currencies[z], 3), "USD") != -1);
         double pips = (iClose(currencies[z], Period(), i) - iOpen(currencies[z], Period(), i)) * mult[z];
         double weighted_pips = pips * iVolume(currencies[z], Period(), i);
         if (short_usd) value -= weighted_pips;
         else value += weighted_pips;
      }
      Index[i] = value;
      i--;
   }
   
   return(0);
}

