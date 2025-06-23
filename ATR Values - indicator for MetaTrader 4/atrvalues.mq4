//+------------------------------------------------------------------+
//|                                                    atrValues.mq4 |
//|                                    Copyright 2015, Mohit Marwaha |
//|                                                marwaha1@gmail.com|
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Mohit Marwaha"
#property link      "marwaha1@gmail.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//---
extern int atrPeriod=10;
extern int infoCorner=0;
extern int shift=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   Comment("Copyright MohitMarwaha");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectsDeleteAll();
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
   double atr1=iATR(Symbol(),1,atrPeriod,shift);
   double atr5=iATR(Symbol(),5,atrPeriod,shift);
   double atr15=iATR(Symbol(),15,atrPeriod,shift);
   double atr30=iATR(Symbol(),30,atrPeriod,shift);
   double atr60=iATR(Symbol(),60,atrPeriod,shift);
   double atr240=iATR(Symbol(),240,atrPeriod,shift);
   double atr1440=iATR(Symbol(),1440,atrPeriod,shift);
   double atr10080=iATR(Symbol(),10080,atrPeriod,shift);
   double atr43200=iATR(Symbol(),43200,atrPeriod,shift);
//---
   ObjectCreate("ObjName1",OBJ_LABEL,0,0,0);
   ObjectSetText("ObjName1","ATR"+IntegerToString(atrPeriod,0)+": M1="+DoubleToStr(atr1,5),8,"Verdana",Red);
   ObjectSet("ObjName1",OBJPROP_CORNER,infoCorner);
   ObjectSet("ObjName1",OBJPROP_XDISTANCE,10);
   ObjectSet("ObjName1",OBJPROP_YDISTANCE,25);
//---
   ObjectCreate("ObjName2",OBJ_LABEL,0,0,0);
   ObjectSetText("ObjName2","ATR"+IntegerToString(atrPeriod,0)+": M5="+DoubleToStr(atr5,5),8,"Verdana",Red);
   ObjectSet("ObjName2",OBJPROP_CORNER,infoCorner);
   ObjectSet("ObjName2",OBJPROP_XDISTANCE,10);
   ObjectSet("ObjName2",OBJPROP_YDISTANCE,40);
//---
   ObjectCreate("ObjName3",OBJ_LABEL,0,0,0);
   ObjectSetText("ObjName3","ATR"+IntegerToString(atrPeriod,0)+": M15="+DoubleToStr(atr15,5),8,"Verdana",Red);
   ObjectSet("ObjName3",OBJPROP_CORNER,infoCorner);
   ObjectSet("ObjName3",OBJPROP_XDISTANCE,10);
   ObjectSet("ObjName3",OBJPROP_YDISTANCE,55);
//---
   ObjectCreate("ObjName4",OBJ_LABEL,0,0,0);
   ObjectSetText("ObjName4","ATR"+IntegerToString(atrPeriod,0)+": M30="+DoubleToStr(atr30,5),8,"Verdana",Red);
   ObjectSet("ObjName4",OBJPROP_CORNER,infoCorner);
   ObjectSet("ObjName4",OBJPROP_XDISTANCE,10);
   ObjectSet("ObjName4",OBJPROP_YDISTANCE,70);
//---
   ObjectCreate("ObjName5",OBJ_LABEL,0,0,0);
   ObjectSetText("ObjName5","ATR"+IntegerToString(atrPeriod,0)+": M60="+DoubleToStr(atr60,5),8,"Verdana",Red);
   ObjectSet("ObjName5",OBJPROP_CORNER,infoCorner);
   ObjectSet("ObjName5",OBJPROP_XDISTANCE,10);
   ObjectSet("ObjName5",OBJPROP_YDISTANCE,85);
//---
   ObjectCreate("ObjName6",OBJ_LABEL,0,0,0);
   ObjectSetText("ObjName6","ATR"+IntegerToString(atrPeriod,0)+": M240="+DoubleToStr(atr240,5),8,"Verdana",Red);
   ObjectSet("ObjName6",OBJPROP_CORNER,infoCorner);
   ObjectSet("ObjName6",OBJPROP_XDISTANCE,10);
   ObjectSet("ObjName6",OBJPROP_YDISTANCE,100);
//---
   ObjectCreate("ObjName7",OBJ_LABEL,0,0,0);
   ObjectSetText("ObjName7","ATR"+IntegerToString(atrPeriod,0)+": M1440="+DoubleToStr(atr1440,5),8,"Verdana",Red);
   ObjectSet("ObjName7",OBJPROP_CORNER,infoCorner);
   ObjectSet("ObjName7",OBJPROP_XDISTANCE,10);
   ObjectSet("ObjName7",OBJPROP_YDISTANCE,115);
//---
   ObjectCreate("ObjName8",OBJ_LABEL,0,0,0);
   ObjectSetText("ObjName8","ATR"+IntegerToString(atrPeriod,0)+": M10080="+DoubleToStr(atr10080,5),8,"Verdana",Red);
   ObjectSet("ObjName8",OBJPROP_CORNER,infoCorner);
   ObjectSet("ObjName8",OBJPROP_XDISTANCE,10);
   ObjectSet("ObjName8",OBJPROP_YDISTANCE,130);
//---
   ObjectCreate("ObjName9",OBJ_LABEL,0,0,0);
   ObjectSetText("ObjName9","ATR"+IntegerToString(atrPeriod,0)+": M43200="+DoubleToStr(atr43200,5),8,"Verdana",Red);
   ObjectSet("ObjName9",OBJPROP_CORNER,infoCorner);
   ObjectSet("ObjName9",OBJPROP_XDISTANCE,10);
   ObjectSet("ObjName9",OBJPROP_YDISTANCE,145);
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
