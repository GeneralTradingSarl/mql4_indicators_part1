//+------------------------------------------------------------------+
//|                                             DonchainChannels.mq4 |
//|                                         Copyright 2014, RasoulFX |
//|                                     http://rasoulfx.blogspot.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, RasoulFX"
#property link      "http://rasoulfx.blogspot.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Red
#property indicator_color2 Blue
#property indicator_color3 Green
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 1

input int BarsToCount=20;

double     upper[];
double     middle[];
double     lower[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   IndicatorShortName("DCH("+IntegerToString(BarsToCount)+")");

   SetIndexBuffer(0,upper);
   SetIndexBuffer(1,middle);
   SetIndexBuffer(2,lower);

   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);
   
   SetIndexLabel(0,"Upper");
   SetIndexLabel(1,"Middle");  
   SetIndexLabel(2,"Lower");   
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
//---
   //static int old_bars;
   //if(old_bars == Bars) return(0);
   
   //int counted_bars = IndicatorCounted();
   //if(counted_bars>0) counted_bars--;
   
   //int limit = Bars - counted_bars;
   int limit = rates_total - prev_calculated;
   if(prev_calculated > 0) limit++;
   
   for(int i=0; i < limit; i++)
   {
      upper[i]=iHigh(Symbol(),Period(),iHighest(Symbol(),Period(),MODE_HIGH,BarsToCount,i));
      lower[i]=iLow(Symbol(),Period(),iLowest(Symbol(),Period(),MODE_LOW,BarsToCount,i));
      middle[i] = (upper[i]+lower[i])/2;   
   }
   
   //old_bars = Bars;   
//--- return value of prev_calculated for next call
   return(rates_total);
}
//+------------------------------------------------------------------+
