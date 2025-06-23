//+------------------------------------------------------------------+
//|                                              BearsBullsPower.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                              https://www.mql5.com/en/users/3rjfx |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link        "http://www.mql5.com"
#property link      "https://www.mql5.com/en/users/3rjfx"
#property strict
//--
//--- indicator settings
#property indicator_separate_window
#property indicator_buffers 3
#property  indicator_width1  2
#property  indicator_width2  2
#property  indicator_width3  2
#property indicator_label1 "BullsPower"
#property indicator_label2 "BearsPower"
//--- input parameter
input int    InpPeriod  = 13; // Power Period
input color  BullsColor = clrAqua;    // Bulls Color
input color  BearsColor = clrYellow;  // Beasr Color
//--- buffers
double ExtBearsBuffer[];
double ExtBullsBuffer[];
double ExtBullBuffer1[];
double ExtTempBuffer1[];
//--
string short_name;
//---------//
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- 1 additional buffer used for counting.
   IndicatorBuffers(4);
   IndicatorDigits(Digits);
//--- indicator line
   SetIndexStyle(0,DRAW_HISTOGRAM,EMPTY,EMPTY,BullsColor);
   SetIndexStyle(1,DRAW_HISTOGRAM,EMPTY,EMPTY,BearsColor);
   SetIndexStyle(2,DRAW_HISTOGRAM,EMPTY,EMPTY,BullsColor);
   //--
   SetIndexBuffer(0,ExtBullsBuffer);
   SetIndexBuffer(1,ExtBearsBuffer);
   SetIndexBuffer(2,ExtBullBuffer1);
   SetIndexBuffer(3,ExtTempBuffer1);
   SetIndexLabel(2,NULL);
//--- name for DataWindow and indicator subwindow label
   short_name="BBPower("+IntegerToString(InpPeriod)+")";
   IndicatorShortName(short_name);
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
   int limit=rates_total-prev_calculated;
//---
   if(rates_total<=InpPeriod)
      return(0);
//---
   if(prev_calculated>0)
      limit++;
   for(int i=0; i<limit; i++)
     {
      ExtTempBuffer1[i]=iMA(NULL,0,InpPeriod,0,MODE_EMA,PRICE_CLOSE,i);
      ExtBullsBuffer[i]=high[i]-ExtTempBuffer1[i];
      ExtBearsBuffer[i]=low[i]-ExtTempBuffer1[i];
      if(ExtBullsBuffer[i]<0.0) ExtBullBuffer1[i]=ExtBullsBuffer[i];
     }
   //--
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
