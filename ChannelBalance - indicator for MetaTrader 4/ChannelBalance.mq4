//+------------------------------------------------------------------+
//|                                               ChannelBalance.mq4 |
//|                                  Copyright © 2010, Shon Shampain |
//|                                       http://www.zencowsgomu.com |
//|                                                                  |
//|       Visit http://www.ZenCowsGoMu.com, an oasis of sanity       |
//|                      for currency traders.                       |
//|                                                                  |
//|       Original out-of-the-box thinking, ideas, indicators,       |
//|                    educational EAs and more.                     |
//|                                                                  |
//|         Home of the consistent T4 Forex trading signal.          |
//|            +396 pips June 2010, +1835 pips 2010 YTD              |
//|             Backtesting profitably since 1-1-2002.               |
//+------------------------------------------------------------------+

#property copyright "Shon Shampain"
#property link      "http://www.zencowsgomu.com"

#property indicator_separate_window

#property indicator_buffers 4
#property indicator_color4 Aqua

extern int max_periods = 20;
extern bool tenths = true;
int d;
double mult;
double high, low;
double upper [];
double lower [];
double middle [];
double bal [];

int init()
{
   d = Digits;
   if (tenths) d -= 1;
   mult = 1.0;
   for (int x = 0; x < d; x++)
      mult *= 10.0;

   SetIndexBuffer(0, upper);
   SetIndexBuffer(1, lower);
   SetIndexBuffer(2, middle);
   SetIndexBuffer(3, bal);
   
   SetLevelValue(0, 50.0);
   SetLevelStyle(STYLE_DOT, 1, Silver);

   return(0);
}

int deinit()
{
   return(0);
}

void get_high_low(int i, int max)
{
   high = 0.0;
   low = 99999.9;
   for (int j = 0; j < max; j++)
   {
      if (High[i+j] > high) high = High[i+j];
      if (Low[i+j] < low) low = Low[i+j];
   }
}

double calc_channel_balance(int i, int max)
{
   double avg_price, range, pct, total;
   double dmax = max;
   total = 0.0;
   for (int j = 0; j < max; j++)
   {
      avg_price = (High[i+j] + Low[i+j]) / 2.0;

      range = upper[i+j] - lower[i+j];
      
      if (range == 0.0) pct = 0.0;
      else pct = (avg_price - lower[i+j]) / range;
      
      total += pct;
   }
   total /= dmax;
   return(total);
}

int start()
{
   int counted_bars = IndicatorCounted();
   int i = Bars - counted_bars - 1;
   while (i >= 0)
   {
      if (i + max_periods > Bars)
      {
         upper[i] = EMPTY_VALUE;
         lower[i] = EMPTY_VALUE;
         middle[i] = EMPTY_VALUE;
         bal[i] = EMPTY_VALUE;
      }
      else
      {
         get_high_low(i, max_periods);
         upper[i] = high;
         lower[i] = low;
         middle[i] = (high + low) / 2.0;
         double val = calc_channel_balance(i, max_periods) * 100.0;
         bal[i] = val;
      }
      i--;
   }
   return(0);
}