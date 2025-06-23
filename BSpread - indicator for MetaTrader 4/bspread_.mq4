//+-------------------------------------------------------------------+
//|                                                       BSpread.mq4 |
//|                                                 Morteza Yaghmouri |
//|                                              http://www.btrend.ir |
//+-------------------------------------------------------------------+
#property copyright "2016 , Morteza Yaghmouri"
#property link      "http://www.btrend.ir"
#property version   "1.0"
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//|  indicator Properties                                            |
//+------------------------------------------------------------------+
extern string  PartA="# Location settings ";
extern int     Location=4; // Indicator location on chart
extern string  Location_tips=" 1 : top-right, 2 : botton-left, 3 : botton-right, 4 : top-left"; //location description
extern string  PartB="# Font settings ";
extern string  Font="Tahoma"; // Indicator font
extern color   Color=Red;     // Indicator color
extern int     Size=10;      //  Indicator font size
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   if(Location!=0)
     {
      ObjectCreate("bspread",OBJ_LABEL,0,0,0);
      ObjectSet("bspread",OBJPROP_CORNER,Location);
      ObjectSet("bspread",OBJPROP_XDISTANCE,7);
      ObjectSet("bspread",OBJPROP_YDISTANCE,12);
     }
   return(0);
  }
//+------------------------------------------------------------------+
//|  indicator Delete function                                       |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete("bspread");
   return(0);
  }
//+------------------------------------------------------------------+
//| indicator Create function                                        |
//+------------------------------------------------------------------+
int start()
  {
   ObjectSetText("bspread","Spread : "+DoubleToStr(MarketInfo(Symbol(),MODE_SPREAD),1),Size,Font,Color);

   return(0);
  }
//+------------------------------------------------------------------+
