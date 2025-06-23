//+------------------------------------------------------------------+
//|                                                         AggZ.mq4 |
//|                                     Copyright ?2010, Walter Choy |
//|                                             brother3th@yahoo.com |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2010, Walter Choy"
#property link      "brother3th@yahoo.com"

// The calculation is simple:
//
// AggZ = (-1*(10-day z-score)+(200-day z-score))/2
//
// where z-score = (close - sma(closing prices over last n periods))/(standard deviation(closing prices over last n periods))
//
// buy above 0, sell below 0 as a basic strategy.


#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 OrangeRed
//---- input parameters
extern int       fast_z_period=10;
extern int       slow_z_period=252;
//---- buffers
double AggZBuffer[];
double z_score_fast[];
double z_score_slow[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorBuffers(3);

   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,AggZBuffer);
   SetIndexLabel(0, "AggZ");
   SetIndexDrawBegin(0, slow_z_period);
   
   SetIndexBuffer(1,z_score_fast);
   SetIndexBuffer(2,z_score_slow);

   IndicatorShortName("AggZ ("+fast_z_period+","+slow_z_period+")");
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
   int    counted_bars=IndicatorCounted();
   int    i, j;
   double std_fast, std_slow, ma_fast, ma_slow;
//----
   i = Bars - counted_bars - 1;
   j = i;
   while(i>=0){
      // z-score = (close - sma(closing prices over last n periods))/(standard deviation(closing prices over last n periods))
      ma_fast = iMA(NULL, 0,  fast_z_period, 0, MODE_SMA, PRICE_CLOSE, i);
      std_fast = iStdDev(NULL, 0, fast_z_period, 0, MODE_SMA, PRICE_CLOSE, i);
      if (std_fast > 0) z_score_fast[i] = (Close[i] - ma_fast)/std_fast;
      
      ma_slow = iMA(NULL, 0,  slow_z_period, 0, MODE_SMA, PRICE_CLOSE, i);
      std_slow = iStdDev(NULL, 0, slow_z_period, 0, MODE_SMA, PRICE_CLOSE, i);
      if (std_slow > 0) z_score_slow[i] = (Close[i] - ma_slow)/std_slow;
      i--;
   }
   
   while(j>=0){
      // AggZ = (-1*(10-day z-score)+(200-day z-score))/2
      AggZBuffer[j] = (-1 * z_score_fast[j] + z_score_slow[j]) / 2;
      j--;
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+