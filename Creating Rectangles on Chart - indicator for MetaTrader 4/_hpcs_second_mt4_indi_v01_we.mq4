//+------------------------------------------------------------------+
//|                                 _HPCS_Second_MT4_Indi_V01_WE.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   
//--- indicator buffers mapping
   if(!ObjectCreate(NULL,"BOX",OBJ_RECTANGLE,0,Time[1],Open[1],Time[3],Open[3]))
   {
   Print("Object Not Created");
   }
   Print("Object Created Successfully");
   ObjectSetInteger(NULL,"BOX",OBJPROP_COLOR,clrBlue);
   ObjectSetInteger(0,"BOX",OBJPROP_WIDTH,5);

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

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
