//+------------------------------------------------------------------+
//|                                                    ColorMACD.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#property  indicator_separate_window
#property  indicator_buffers 4
#property  indicator_color1   Red
#property  indicator_color2   Lime
#property  indicator_color3   Aqua
#property  indicator_color4   Magenta

#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 1
#property indicator_width4 1

#property indicator_level1  0
#property indicator_levelcolor Silver

extern int fast_ema_period=12;
extern int slow_ema_period=26;
extern int signal_period=9;

double UpBuffer[];
double DownBuffer[];
double ZeroBuffer[];
double SigMABuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexStyle(3,DRAW_LINE);

   SetIndexBuffer(0,UpBuffer);
   SetIndexBuffer(1,DownBuffer);
   SetIndexBuffer(2,ZeroBuffer);
   SetIndexBuffer(3,SigMABuffer);

   SetIndexDrawBegin(0,0);

   IndicatorShortName("MACD ("+fast_ema_period+", "+slow_ema_period+", "+signal_period+") ");

   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS)+2);

   SetIndexLabel(0,"UpBuffer");
   SetIndexLabel(1,"DownBuffer");
   SetIndexLabel(2,"ZeroBuffer");
   SetIndexLabel(3,"SigMABuffer");

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

   double myMACDmain,myMACDsignal;
   int limit,i;

   if(prev_calculated>0)

      limit=rates_total-prev_calculated;
   else
      limit=rates_total;

   for(i=0; i<limit; i++)
     {
      myMACDmain=iMACD(NULL,0,fast_ema_period,slow_ema_period,signal_period,PRICE_CLOSE,MODE_MAIN,i);
      myMACDsignal=iMACD(NULL,0,fast_ema_period,slow_ema_period,signal_period,PRICE_CLOSE,MODE_SIGNAL,i);

      SigMABuffer[i]=myMACDsignal;

      if((myMACDmain>0) && (myMACDmain>myMACDsignal))
        {
         UpBuffer[i]=myMACDmain;
        }
      else
        {
         if((myMACDmain<0) && (myMACDmain<myMACDsignal))
           {
            DownBuffer[i]=myMACDmain;
           }
         else
           {
            ZeroBuffer[i]=myMACDmain;
           }
        }
     }

   return(rates_total);
  }
//+------------------------------------------------------------------+
