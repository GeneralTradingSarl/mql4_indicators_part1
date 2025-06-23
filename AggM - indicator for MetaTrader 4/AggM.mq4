//+------------------------------------------------------------------+
//|                                                         AggM.mq4 |
//|                                     Copyright ?2010, Walter Choy |
//|                                             brother3th@yahoo.com |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2010, Walter Choy"
#property link      "brother3th@yahoo.com"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red
#property indicator_minimum 0
#property indicator_maximum 1
#property indicator_level1 0.2
#property indicator_level2 0.7
//---- input parameters
extern int       fast_m_period=10;
extern int       slow_m_period=252;
//---- buffers
double AggMBuffer[];
double MvalueBuffer[];

double tmpArray[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorBuffers(2);
   
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,AggMBuffer);
   SetIndexLabel(0, "AggM");
   SetIndexEmptyValue(0, 0.0);
   SetIndexDrawBegin(0, slow_m_period);
  
   SetIndexBuffer(1, MvalueBuffer);
   
   IndicatorShortName("AggM (" + fast_m_period + "," + slow_m_period + ")");

   ArrayResize(tmpArray, slow_m_period * 3);
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
//----
   i = Bars - counted_bars - 1;
   j = i;
   

   while(i>=0){
      double rank_long = PercentRank(slow_m_period, i);
      double rank_short = 1 - PercentRank(fast_m_period, i);
      MvalueBuffer[i] = (rank_long + rank_short)/2;
      i--;
   }
   while(j>=0){
      AggMBuffer[j] = (MvalueBuffer[j+1]*0.4) + (MvalueBuffer[j]*0.6);
      j--;
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| PercentRank function                                             |
//+------------------------------------------------------------------+
double PercentRank(int r_period, int shift){
   double pcrank, rank;
   int i;
   
   ArrayCopy(tmpArray, High, 0, shift, r_period);
   ArrayCopy(tmpArray, Low, r_period, shift, r_period);
   ArrayCopy(tmpArray, Close, r_period * 2, shift, r_period);
   ArraySort(tmpArray, r_period * 3);
   rank = ArrayBsearch(tmpArray, Close[shift], r_period * 3);
   pcrank = rank /(r_period * 3 - 1);
   
   return (pcrank);   
}

//+------------------------------------------------------------------+