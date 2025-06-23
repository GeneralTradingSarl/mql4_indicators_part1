//+------------------------------------------------------------------+
//|                                              CCI MTF Colored.mq4 |
//|                                              Hamid Shojaee       |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 4


double      CCI;
double      CCIA[];
double      CCIB[];
double      CCIAX[];
double      CCIBX[];

input int      period = 14;
input ENUM_APPLIED_PRICE price = PRICE_CLOSE;
input ENUM_TIMEFRAMES timeframe = PERIOD_H1;


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,CCIA);
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,10,clrChartreuse);
   SetIndexLabel(0,"CCI +");
   SetIndexBuffer(1,CCIB);
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID,10,clrRed);
   SetIndexLabel(1,"CCI -");
   SetIndexBuffer(2,CCIAX);
   SetIndexStyle(2,DRAW_HISTOGRAM,STYLE_SOLID,10,clrDarkGreen);
   SetIndexLabel(2,"CCI ++");
   SetIndexBuffer(3,CCIBX);
   SetIndexStyle(3,DRAW_HISTOGRAM,STYLE_SOLID,10,clrMaroon);
   SetIndexLabel(3,"CCI --");
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
   for(int i=Bars-1; i>=1; i--)
     {
      CCI = iCCI(Symbol(),timeframe,period,price,i);

      if(CCI > 0 && CCI < 100)
        {
         CCIA[i] = CCI;
        }
      if(CCI < 0 && CCI > -100)
        {
         CCIB[i] = CCI;
        }
      if(CCI >= 100)
        {
         CCIAX[i] = CCI;
        }
      if(CCI <= -100)
        {
         CCIBX[i] = CCI;
        }


     }

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
