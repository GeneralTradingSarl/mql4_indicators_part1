//+------------------------------------------------------------------+
//|                                                 #MTF Candles.mq4 |
//|                                      Copyright © 2006, Eli Hayun |
//|                                          http://www.elihayun.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, Eli Hayun"
#property link      "http://www.elihayun.com"
//----
#property indicator_chart_window
//---- input parameters
extern int       CandlesTF=240;
extern color     UpCandleColor=LightBlue;
extern color     DownCandleColor=Red;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
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
//----
   double dif=MathAbs(Time[1] - Time[2]);
   int ix=0;
   datetime dtStart=dif * 8 + Time[0];
   for(int ii=0; ii<8; ii+=2)
     {
      ObjectDelete("rect"+ii); ObjectDelete("OTrnd"+ii); ObjectDelete("CTrnd"+ii);
      ObjectCreate("rect"+ii,OBJ_TREND, 0, dtStart, iLow(NULL, CandlesTF,ix), dtStart, iHigh(NULL,CandlesTF,ix));
      color clr=DownCandleColor; if (iOpen(NULL, CandlesTF,ix) < iClose(NULL, CandlesTF,ix)) clr=UpCandleColor;
      ObjectSet("rect"+ii, OBJPROP_COLOR, clr);
      ObjectSet("rect"+ii, OBJPROP_WIDTH, 3);
      ObjectSet("rect"+ii, OBJPROP_RAY, False);
      ObjectCreate("OTrnd"+ii, OBJ_TREND, 0, dtStart, iOpen(NULL, CandlesTF,ix), dtStart-dif, iOpen(NULL,CandlesTF,ix));
      ObjectSet("OTrnd"+ii, OBJPROP_WIDTH, 2);
      ObjectSet("OTrnd"+ii, OBJPROP_RAY, False);
      ObjectSet("CTrnd"+ii, OBJPROP_WIDTH, 2);
      ObjectCreate("CTrnd"+ii, OBJ_TREND, 0, dtStart, iClose(NULL, CandlesTF,ix), dtStart+dif, iClose(NULL,CandlesTF,ix));
      ObjectSet("CTrnd"+ii, OBJPROP_WIDTH, 2);
      ObjectSet("CTrnd"+ii, OBJPROP_RAY, False);
      dtStart-=dif * 2;
      ix++;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+