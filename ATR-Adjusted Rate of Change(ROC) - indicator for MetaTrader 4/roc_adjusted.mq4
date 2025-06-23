//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

#property copyright "Salman Soltaniyan"
#property link      "https://www.mql5.com/en/users/salmansoltaniyan"
#property version   "1.00"
#property strict

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red      // ROC line color
#property indicator_level1 0
#property indicator_level2 0
#property indicator_levelcolor clrGray
#property indicator_levelstyle STYLE_DOT
#property indicator_levelwidth 1
enum ENUM_ROC_TYPE
  {
   PERCENT_BASED =0,
   ATR_ADJUSTED =1
  };
//---- Input parameters

extern int    Length = 14;    // How many candle lookback
input ENUM_ROC_TYPE roc_type = PERCENT_BASED; //ROC Type(ATR-adjusted or Percent-based)
extern int  atr_period = 100;  // ATR period


//---- Buffers
double RocBuffer[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//---- Bind our arrays to indicator buffers
   IndicatorBuffers(1);
   SetIndexStyle(0, DRAW_LINE, 0, 2, clrRed);    // ROC line


   SetIndexBuffer(0, RocBuffer);
   ArraySetAsSeries(RocBuffer, true);


// Short name for the indicator
   IndicatorShortName("Rate of Change (ROC)");

   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function (calculations)               |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime& time[],
                const double& open[],
                const double& high[],
                const double& low[],
                const double& close[],
                const long& tick_volume[],
                const long& volume[],
                const int& spread[])
  {
   int    limit;
// limit is our starting bar index to calculate
   limit = rates_total - prev_calculated - 1;

// Loop through all uncalculated bars in descending order
   for(int i = limit; i >= 0; i--)
     {

      //--- Make sure we have enough bars to look back "Length" bars
      if(i + Length < Bars && i+atr_period <Bars)
        {
         double oldPrice = Close[i + Length];
         if(oldPrice != 0)
            if(roc_type==PERCENT_BASED)
               RocBuffer[i] = (Close[i] - oldPrice)/oldPrice * 100.0;
            else
              {
               double atr= iATR(_Symbol, PERIOD_CURRENT, atr_period, i);
               RocBuffer[i] = (Close[i] - oldPrice)/atr;
              }
         else
            RocBuffer[i] = 0.0;
        }
      else
        {
         RocBuffer[i] = 0.0;
        }
     }

   return(rates_total-1);
  }
//+------------------------------------------------------------------+
