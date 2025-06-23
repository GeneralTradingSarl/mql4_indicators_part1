//+------------------------------------------------------------------+
//|                                                      AVAIndicator.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+





#property copyright "AVA Thibauld Robin"
#property link      "https://www.mql5.com/en/users/candlexbomb"
#property version   "1.00"
#property strict


#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 DeepSkyBlue // AVA Line

//--- input parameters
input int atrPeriod = 14; // Period for ATR
input int shortEmaPeriod = 2; // Short period for EMA
input int longEmaPeriod = 5;  // Long period for EMA

//--- indicator buffers
double AVA_Buffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   IndicatorBuffers(1);
   SetIndexBuffer(0, AVA_Buffer, INDICATOR_DATA);
   SetIndexStyle(0, DRAW_LINE);
   ArraySetAsSeries(AVA_Buffer, true);
   IndicatorShortName("AVA Oscillator");

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
// Ensure we have enough data
   int begin = longEmaPeriod + 1;
   if(rates_total < begin)
      return(0);

// A temporary buffer to store ATR values for EMA calculation
   double tempATRBuffer[];

// Allocate array size based on total number of rates
   ArrayResize(tempATRBuffer, rates_total);
   ArraySetAsSeries(tempATRBuffer, true);

// Calculate ATR for all required bars
   for(int i = 0; i < rates_total; i++)
     {
      tempATRBuffer[i] = iATR(NULL, 0, atrPeriod, i);
     }

// Calculate EMA on ATR values
   for(int j = 0; j < rates_total; j++)
     {
      double shortEMA = iMAOnArray(tempATRBuffer, rates_total, shortEmaPeriod, 0, MODE_EMA, j);
      double longEMA = iMAOnArray(tempATRBuffer, rates_total, longEmaPeriod, 0, MODE_EMA, j);

      // Ensure longEMA is not zero to avoid division by zero
      if(longEMA != 0)
        {
         double FAV = shortEMA / longEMA;
         AVA_Buffer[j] = (FAV - 1) * 100; // Normalize and scale for better visualization
        }
      else
        {
         AVA_Buffer[j] = EMPTY_VALUE;
        }
     }


   return(rates_total);
  }
//+------------------------------------------------------------------+
