//+------------------------------------------------------------------+
//|                                                 DPO_modified.mq4 |
//|                                   Copyright 2020, chartreaderpro |
//|                     https://www.mql5.com/en/market/product/69093 |
//+------------------------------------------------------------------+
#property copyright     "Copyright 2020, chartreaderpro"
#property link          "https://www.mql5.com/en/code/50863"
#property version       "1.00"
#property strict
#property description   "Detrended Price Oscillator - modified"
#property indicator_separate_window
#include <MovingAverages.mqh>

#property indicator_buffers      1
#property indicator_type1        DRAW_LINE
#property indicator_color1       Blue
#property indicator_levelstyle   STYLE_DOT
#property indicator_levelcolor   DarkGray
#property indicator_level1       0

//--- input parameters
input int                  InpDetrendPeriod  = 61;                // DPO Period
input ENUM_MA_METHOD       MAmethod          = MODE_SMA;          // MA Method 
input ENUM_APPLIED_PRICE   appliedprice      = PRICE_CLOSE;       // MA Applied price

//--- indicator buffers
double    ExtDPOBuffer[];
double    ExtMABuffer[];
double    Extprice[];
int       helpMABuffer;

int       ExtMAPeriod;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- get length of cycle for smoothing
   //ExtMAPeriod = InpDetrendPeriod / 2 + 1;
   ExtMAPeriod = InpDetrendPeriod;                 // change input period to equal MA period
//--- indicator buffers mapping
   IndicatorBuffers(3);
   SetIndexBuffer(0, ExtDPOBuffer, INDICATOR_DATA);
   SetIndexBuffer(1, ExtMABuffer, INDICATOR_CALCULATIONS);
   SetIndexBuffer(2, Extprice, INDICATOR_CALCULATIONS);
//--- set accuracy
   IndicatorSetInteger(INDICATOR_DIGITS, _Digits + 1);
//--- set first bar from what index will be drawn
   //PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, ExtMAPeriod - 1);
   SetIndexDrawBegin(0, ExtMAPeriod + 1);
   SetIndexEmptyValue(0, EMPTY_VALUE);
   SetIndexEmptyValue(1, EMPTY_VALUE);
   SetIndexEmptyValue(2, EMPTY_VALUE);
//--- name for DataWindow and indicator subwindow label
   string short_name = StringFormat("modified DPO(%d)", InpDetrendPeriod);

//--- set short name according to MA mode
   switch(MAmethod)
     {
      case MODE_EMA :
         short_name = short_name + " (EMA)";
         break;
      case MODE_LWMA :
         short_name = short_name + " (LWMA)";
         break;
      case MODE_SMA :
         short_name = short_name + " (SMA)";
         break;
      case MODE_SMMA :
         short_name = short_name + " (SMMA)";
         break;
      default :
         short_name = short_name;
     }

   IndicatorSetString(INDICATOR_SHORTNAME, short_name);
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
//--- check for bars count and input parameter
   if(Bars <= ExtMAPeriod || ExtMAPeriod < 2)return(0);
   
//--- counting from 0 to rates_total
   ArraySetAsSeries(ExtDPOBuffer,false);
   ArraySetAsSeries(ExtMABuffer,false);
   ArraySetAsSeries(Extprice,false);
   ArraySetAsSeries(open,false);
   ArraySetAsSeries(high,false);
   ArraySetAsSeries(low,false);
   ArraySetAsSeries(close,false);
   
   int start;
   
   int begin = 0;
   int first_index = begin + ExtMAPeriod + 1;
//--- preliminary filling
   if(prev_calculated < first_index)
     {
      ArrayInitialize(ExtDPOBuffer, EMPTY_VALUE);
      start = first_index;
      if(begin > 0)
         SetIndexDrawBegin(0, ExtMAPeriod + 1);
     }
   else
      start = prev_calculated - 1;
      
//---get price array if chosen MA applied price is PRICE_MEDIAN, PRICE_TYPICAL, or PRICE_WEIGHTED
   double price[];
   if(appliedprice >= 4)getLprice(rates_total, prev_calculated, begin, open, high, low, close, Extprice, appliedprice);      

//--- get MA buffer based on MA applied price and MA mode
   switch(appliedprice)
     {
      case PRICE_CLOSE :
         AverageOnArray(MAmethod, rates_total, prev_calculated, begin, ExtMAPeriod, close, ExtMABuffer);
         break;
      case PRICE_OPEN :
         AverageOnArray(MAmethod, rates_total, prev_calculated, begin, ExtMAPeriod, open, ExtMABuffer);
         break;
      case PRICE_HIGH :
         AverageOnArray(MAmethod, rates_total, prev_calculated, begin, ExtMAPeriod, high, ExtMABuffer);
         break;
      case PRICE_LOW :
         AverageOnArray(MAmethod, rates_total, prev_calculated, begin, ExtMAPeriod, low, ExtMABuffer);
         break;
      case PRICE_MEDIAN :
         AverageOnArray(MAmethod, rates_total, prev_calculated, begin, ExtMAPeriod, Extprice, ExtMABuffer);
         break;
      case PRICE_TYPICAL :
         AverageOnArray(MAmethod, rates_total, prev_calculated, begin, ExtMAPeriod, Extprice, ExtMABuffer);
         break;
      case PRICE_WEIGHTED :
         AverageOnArray(MAmethod, rates_total, prev_calculated, begin, ExtMAPeriod, Extprice, ExtMABuffer);
         break;
      default :
         AverageOnArray(MAmethod, rates_total, prev_calculated, begin, ExtMAPeriod, close, ExtMABuffer);
     }

//--- the main loop of calculations
   for(int i = start; i < rates_total && !IsStopped(); i++)
      ExtDPOBuffer[i] = close[i] - ExtMABuffer[i];
//--- OnCalculate done. Return new prev_calculated.
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| calculate average on array                                       |
//+------------------------------------------------------------------+
void AverageOnArray(const int mode, 
                     const int rates_total, 
                     const int prev_calculated, 
                     const int begin,
                     const int period, 
                     const double& source[], 
                     double& destination[])
  {
   switch(mode)
     {
      case MODE_EMA:
         ExponentialMAOnBuffer(rates_total, prev_calculated, begin, period, source, destination);
         break;
      case MODE_SMMA:
         SmoothedMAOnBuffer(rates_total, prev_calculated, begin, period, source, destination);
         break;
      case MODE_LWMA:
         {int WS;
         LinearWeightedMAOnBuffer(rates_total, prev_calculated, begin, period, source, destination, WS);
         break;}
      default:
         SimpleMAOnBuffer(rates_total, prev_calculated, begin, period, source, destination);
     }
  }
//+------------------------------------------------------------------+
//| get median , typical, & weighted prices (when requested)         |
//+------------------------------------------------------------------+
int getLprice(const  int      rates_total,
               const int      prev_calculated, 
               const int      begin, 
               const double   &op[], 
               const double   &hi[], 
               const double   &lo[], 
               const double   &cl[], 
               double         &destination[],
               ENUM_APPLIED_PRICE Lprice)
  {
   bool as_series_destination=ArrayGetAsSeries(destination);
   ArraySetAsSeries(destination,false);
   
   int start_position = prev_calculated - 1;
   if(start_position < 0){start_position = 0;}


//--- main loop
   for(int i = start_position; i < rates_total; i++)
     {
      if(Lprice == PRICE_WEIGHTED)destination[i] = (hi[i] + lo[i] + cl[i] * 2) / 4;
      if(Lprice == PRICE_TYPICAL)destination[i] = (hi[i] + lo[i] + cl[i]) / 3;
      if(Lprice == PRICE_MEDIAN)destination[i] = (hi[i] + lo[i]) / 2;
     }
   ArraySetAsSeries(destination,as_series_destination);
   return rates_total;
  }
//+------------------------------------------------------------------+




