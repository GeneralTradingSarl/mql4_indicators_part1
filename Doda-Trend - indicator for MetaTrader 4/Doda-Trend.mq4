//+------------------------------------------------------------------+
//|                                                   Doda-Trend.mq4 |
//|                              Copyright © 2010, InvestmentKit.com |
//|                                     http://www.InvestmentKit.com |
//|                                        http://www.DodaCharts.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, InvestmentKit.com"
#property link      "http://www.InvestmentKit.com"

#property indicator_chart_window


double myatr, mystd;
string atrresult;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
//----
ObjectCreate("myatr",OBJ_LABEL,0,0,0);
ObjectCreate("myatrheading",OBJ_LABEL,0,0,0);

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectDelete("myatr");   
   ObjectDelete("myatrheading");   
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
myatr = iATR(NULL,0,14,0);
mystd = iStdDev(NULL,0,14,0,MODE_EMA,PRICE_CLOSE,0);

if (myatr > mystd) atrresult = "Range-Bound";
if (myatr < mystd) atrresult = "Trending";

///////////////////////////////////////////////////////

ObjectSetText("myatrheading","Trend Indicator v1.0 by InvestmentKit.com", 10, "Arial", Red);
ObjectSet("myatrheading",OBJPROP_XDISTANCE,2);
ObjectSet("myatrheading",OBJPROP_YDISTANCE,40);
ObjectSet("myatrheading", OBJPROP_CORNER, 2);

ObjectSetText("myatr",StringConcatenate("Current Trend: ", atrresult), 10, "Arial", Red);
ObjectSet("myatr",OBJPROP_XDISTANCE,2);
ObjectSet("myatr",OBJPROP_YDISTANCE,20);
ObjectSet("myatr", OBJPROP_CORNER, 2);
//----
   return(0);
  }
//+------------------------------------------------------------------+