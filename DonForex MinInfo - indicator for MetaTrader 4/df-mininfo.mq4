//+------------------------------------------------------------------+
//|                                                   DF-MinInfo.mq4 |
//|                                         Copyright 2014, DonForex |
//|                                          http://www.donforex.com |
//|                                                      B600+ READY |
//+------------------------------------------------------------------+
#property copyright   "Copyright 2014, DonForex"
#property link        "http://donforex.com"
#property description "DonForex - MinInfo indicator"
#property version     "1.03"
#property strict

#property indicator_chart_window

extern string     Copyright_DonForex          = "http://donforex.com";
extern color      Up_Color                    = ForestGreen;
extern color      Down_Color                  = OrangeRed;
extern color      Last_Digit_Color            = C'77,77,77';
extern color      TextColor                   = DarkSeaGreen;
extern color      SeparatorColor              = DimGray;
extern int        PosX                        = 1100; // Position settings in pixels
extern int        PosY                        = 30;   // Position settings in pixels
extern int        Refresh_MilliSeconds        = 1000;  // As its name

double Prev_Price = 0.0;
int Price_Length  = 0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {

   ObjectCreate("DF_MI_Line0",OBJ_LABEL,0,0,0,0,0);
   ObjectSet("DF_MI_Line0",OBJPROP_CORNER,0);
   ObjectSet("DF_MI_Line0",OBJPROP_XDISTANCE,PosX+17);
   ObjectSet("DF_MI_Line0",OBJPROP_YDISTANCE,PosY+0);
   ObjectSetText("DF_MI_Line0","----------------------------------",8,"Tahoma",SeparatorColor);

   ObjectCreate("DF_MI_Line1",OBJ_LABEL,0,0,0,0,0);
   ObjectSet("DF_MI_Line1",OBJPROP_CORNER,0);
   ObjectSet("DF_MI_Line1",OBJPROP_XDISTANCE,PosX+17);
   ObjectSet("DF_MI_Line1",OBJPROP_YDISTANCE,PosY+52);
   ObjectSetText("DF_MI_Line1","----------------------------------",8,"Tahoma",SeparatorColor);

   ObjectCreate("DF_MI_CopyRight",OBJ_LABEL,0,0,0,0,0);
   ObjectSet("DF_MI_CopyRight",OBJPROP_CORNER,0);
   ObjectSet("DF_MI_CopyRight",OBJPROP_XDISTANCE,PosX+38);
   ObjectSet("DF_MI_CopyRight",OBJPROP_YDISTANCE,PosY+60);
   ObjectSetText("DF_MI_CopyRight",CharToStr(169)+" http://donforex.com",7,"Tahoma",TextColor);

   ObjectCreate("DF_MI_Spread",OBJ_LABEL,0,0,0,0,0);
   ObjectSet("DF_MI_Spread",OBJPROP_CORNER,0);
   ObjectSet("DF_MI_Spread",OBJPROP_XDISTANCE,PosX+18);
   ObjectSet("DF_MI_Spread",OBJPROP_YDISTANCE,PosY+10);
   ObjectSetText("DF_MI_Spread",StringConcatenate("Spread:  -"),8,"Tahoma",TextColor);

   ObjectCreate("DF_MI_Time",OBJ_LABEL,0,0,0,0,0);
   ObjectSet("DF_MI_Time",OBJPROP_CORNER,0);
   ObjectSet("DF_MI_Time",OBJPROP_XDISTANCE,PosX+80);
   ObjectSet("DF_MI_Time",OBJPROP_YDISTANCE,PosY+10);
   ObjectSetText("DF_MI_Time",StringConcatenate("Time:  -"),8,"Tahoma",TextColor);

   ObjectCreate("DF_MI_PriceDisplay_LD",OBJ_LABEL,0,0,0,0,0);
   ObjectSet("DF_MI_PriceDisplay_LD",OBJPROP_CORNER,0);
   ObjectSet("DF_MI_PriceDisplay_LD",OBJPROP_XDISTANCE,PosX+18);
   ObjectSet("DF_MI_PriceDisplay_LD",OBJPROP_YDISTANCE,PosY+18);
   ObjectSetText("DF_MI_PriceDisplay_LD","  -",24,"Source Sans Pro",TextColor);

   ObjectCreate("DF_MI_PriceDisplay",OBJ_LABEL,0,0,0,0,0);
   ObjectSet("DF_MI_PriceDisplay",OBJPROP_CORNER,0);
   ObjectSet("DF_MI_PriceDisplay",OBJPROP_XDISTANCE,PosX+18);
   ObjectSet("DF_MI_PriceDisplay",OBJPROP_YDISTANCE,PosY+18);
   ObjectSetText("DF_MI_PriceDisplay","  -",24,"Source Sans Pro",TextColor);

   Price_Length=StringLen(DoubleToStr(Close[0],Digits));

   if(Refresh_MilliSeconds<100) Refresh_MilliSeconds=100;
   if(Refresh_MilliSeconds>5000) Refresh_MilliSeconds=5000;
   EventSetMillisecondTimer(Refresh_MilliSeconds);

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----

   int obj_total=ObjectsTotal();
   for(int i=obj_total; i>=0; i--)
     {
      string Obj_Name=ObjectName(i);
      if(StringFind(Obj_Name,"DF_MI_",0)>-1) ObjectDelete(Obj_Name);
     }

//----
   return(0);
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

   ObjectSetText("DF_MI_Spread",StringConcatenate("Spread:",MarketInfo(Symbol(),MODE_SPREAD)),8,"Tahoma",TextColor);

   string Price_String=StringFormat(StringConcatenate("%.",Price_Length-1,"s"),DoubleToStr(Close[0],Digits));

   if(Price_Length>=7)
     {
      ObjectSet("DF_MI_PriceDisplay_LD",OBJPROP_XDISTANCE,PosX+27);
      ObjectSet("DF_MI_PriceDisplay",OBJPROP_XDISTANCE,PosX+27);
     }
   else if(Price_Length==6)
     {
      ObjectSet("DF_MI_PriceDisplay_LD",OBJPROP_XDISTANCE,PosX+34);
      ObjectSet("DF_MI_PriceDisplay",OBJPROP_XDISTANCE,PosX+34);
     }
   else if(Price_Length<=5)
     {
      ObjectSet("DF_MI_PriceDisplay_LD",OBJPROP_XDISTANCE,PosX+41);
      ObjectSet("DF_MI_PriceDisplay",OBJPROP_XDISTANCE,PosX+41);
     }

   ObjectSetText("DF_MI_PriceDisplay_LD",DoubleToStr(Close[0],Digits),28,"Source Sans Pro",Last_Digit_Color);

   if(Close[0]>Prev_Price)
     {
      ObjectSetText("DF_MI_PriceDisplay",Price_String,28,"Source Sans Pro",Up_Color);
     }
   if(Close[0]<Prev_Price)
     {
      ObjectSetText("DF_MI_PriceDisplay",Price_String,28,"Source Sans Pro",Down_Color);
     }

   Prev_Price=Close[0];

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
void OnTimer()
  {

//----
   datetime closetime=Time[0]+PeriodSeconds()-TimeCurrent();

   if(Period()<=PERIOD_D1) ObjectSetText("DF_MI_Time",StringConcatenate("Time: ",TimeToStr(closetime,TIME_SECONDS)),8,"Tahoma",TextColor);
   else if(Period()>PERIOD_D1) ObjectSetText("DF_MI_Time",StringConcatenate("Time max: Daily"),8,"Tahoma",TextColor);

//----
   return;
  }
//+------------------------------------------------------------------+
