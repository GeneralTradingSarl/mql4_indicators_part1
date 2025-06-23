//+------------------------------------------------------------------+
//|                                          ATR Value Indicator.mq4 |
//|                               Copyright 2016-2022, Hossein Nouri |
//|                           https://www.mql5.com/en/users/hsnnouri |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016-2022, Hossein Nouri"
#property description "Fully Coded By Hossein Nouri"
#property description "Email : hsn.nouri@gmail.com"
#property description "Skype : hsn.nouri"
#property description "Telegram : @hypernova1990"
#property description "Website : http://www.metatraderprogrammer.ir"
#property description "MQL5 Profile : https://www.mql5.com/en/users/hsnnouri"
#property description " "
#property description "Feel free to contact me for MQL4/MQL5 coding."
#property link      "https://www.mql5.com/en/users/hsnnouri"
#property version   "1.12"
#property strict
#property indicator_chart_window

//--- v1.10
// Added timeframe visulization for multi sample support
// Added custom timeframe for ATR
// Added movement capability by offset
// Code optimization
//--- v1.11
// Position adjustment added
//--- v1.12
// Fixed overlapping and copying on loading from a template

//--- input parameters
enum ENUM_VALUE_TYPE
{
   Points=0,
   Pips=1,
};
enum ENUM_CORNER
{
   LEFT_UPPER,// Left Upper
   LEFT_LOWER,// Left Lower
   RIGHT_UPPER,// Right Upper
   RIGHT_LOWER,// Right Lower
};
input ENUM_TIMEFRAMES   InpATRTimeframe         = PERIOD_CURRENT;                         // ATR Timeframe
input int               InpATRPeriod            = 14;                                     // ATR Period
input double            InpMultiplier           = 2.0;                                    // Multiplier
input string            DescStyle               = "======== Style ========";              // Description
input ENUM_CORNER       InpPosition             = RIGHT_UPPER;                            // Position
input int               InpOffsetX              = 0;                                      // Offset X
input int               InpOffsetY              = 30;                                     // Offset Y
input ENUM_VALUE_TYPE   InpDisplay              = 0;                                      // Display Mode
input color             InpLabelColor           = clrRed;                                 // Color
input int               InpFontSize             = 10;                                     // Font Size
input string            DescVisulizations       = "===== Visulizations =====";            // Description
input bool              InpTimeframeAll         = true;                                   // All Timeframes
input bool              InpTimeframeM1          = false;                                  // M1
input bool              InpTimeframeM5          = false;                                  // M5
input bool              InpTimeframeM15         = false;                                  // M15
input bool              InpTimeframeM30         = false;                                  // M30
input bool              InpTimeframeH1          = false;                                  // H1
input bool              InpTimeframeH4          = false;                                  // H4
input bool              InpTimeframeD1          = false;                                  // D1
input bool              InpTimeframeW1          = false;                                  // W1
input bool              InpTimeframeMN1         = false;                                  // MN1
//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+
string               OBJ_PATTERN;
string               OBJ_NAME;
int                  Visibility;
ENUM_BASE_CORNER     TextCorner;
ENUM_ANCHOR_POINT    TextAnchor;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void SetVisibility()
{
   Visibility=0;
   if(InpTimeframeAll)
   {
      Visibility+=OBJ_ALL_PERIODS;
      return;
   }
   if(InpTimeframeM1)         Visibility+=OBJ_PERIOD_M1;
   if(InpTimeframeM5)         Visibility+=OBJ_PERIOD_M5;
   if(InpTimeframeM15)        Visibility+=OBJ_PERIOD_M15;
   if(InpTimeframeM30)        Visibility+=OBJ_PERIOD_M30;
   if(InpTimeframeH1)         Visibility+=OBJ_PERIOD_H1;
   if(InpTimeframeH4)         Visibility+=OBJ_PERIOD_H4;
   if(InpTimeframeD1)         Visibility+=OBJ_PERIOD_D1;
   if(InpTimeframeW1)         Visibility+=OBJ_PERIOD_W1;
   if(InpTimeframeMN1)        Visibility+=OBJ_PERIOD_MN1;

   if(Visibility==0)          Visibility=OBJ_NO_PERIODS;

}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
{
   SetVisibility();
   SetTextPosition();
//--- indicator buffers mapping
   OBJ_PATTERN = "ATRInd_"+(string) ChartID();
   CleanUpChart();
   OBJ_NAME=OBJ_PATTERN+"_"+GetTFName()+"_"+IntegerToString(InpATRPeriod)+"_"+GetTFName(InpATRTimeframe)+"_"+DoubleToStr(InpMultiplier,2)+"_";
   ShowATR();
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   ObjectDelete(OBJ_NAME);
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
   ShowATR();
//--- return value of prev_calculated for next call
   return(rates_total);
}
//+------------------------------------------------------------------+
void ShowATR()
{
   static double ATR;

   ATR = iATR(_Symbol,InpATRTimeframe,InpATRPeriod,0);
   ATR = (ATR * InpMultiplier) * MathPow(10,Digits - InpDisplay);
   DrawATROnChart(ATR);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawATROnChart(double ATR)
{
   string Dis;
   if(InpDisplay==0) Dis=" Points";
   if(InpDisplay==1) Dis=" Pips";

   string Output = StringFormat("%s%s of ATR(%s,%s): %s %s  ",DoubleToStr(InpMultiplier * 100,0),"%",IntegerToString(InpATRPeriod),GetTFName(InpATRTimeframe),DoubleToStr(ATR,0),Dis);
   if(ObjectFind(OBJ_NAME) < 0)
   {
      ObjectCreate(OBJ_NAME, OBJ_LABEL, 0, 0, 0);
      ObjectSet(OBJ_NAME, OBJPROP_CORNER, TextCorner);
      ObjectSet(OBJ_NAME,OBJPROP_ANCHOR,TextAnchor);
      ObjectSet(OBJ_NAME, OBJPROP_YDISTANCE, InpOffsetY);
      ObjectSet(OBJ_NAME, OBJPROP_XDISTANCE, InpOffsetX);
      ObjectSet(OBJ_NAME,OBJPROP_SELECTABLE,false);
      ObjectSetText(OBJ_NAME, Output, InpFontSize, "Arial", InpLabelColor);
      ObjectSetInteger(0,OBJ_NAME,OBJPROP_TIMEFRAMES,Visibility);
   }

   ObjectSetText(OBJ_NAME, Output);

   WindowRedraw();
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string GetTFName(int _TF=-1)
{
   if(_TF==-1 || _TF==0)       _TF=_Period;
   if(_TF==1)  return "M1";
   if(_TF==5)  return "M5";
   if(_TF==15)  return "M15";
   if(_TF==30)  return "M30";
   if(_TF==60)  return "H1";
   if(_TF==240)  return "H4";
   if(_TF==1440)  return "D1";
   if(_TF==10080)  return "W1";
   if(_TF==43200)  return "MN1";
   return "";
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetTextPosition()
{
   if(InpPosition==LEFT_UPPER)
   {
      TextCorner=CORNER_LEFT_UPPER;
      TextAnchor=ANCHOR_LEFT_UPPER;
   }
   else if(InpPosition==LEFT_LOWER)
   {
      TextCorner=CORNER_LEFT_LOWER;
      TextAnchor=ANCHOR_LEFT_LOWER;
   }
   else if(InpPosition==RIGHT_UPPER)
   {
      TextCorner=CORNER_RIGHT_UPPER;
      TextAnchor=ANCHOR_RIGHT_UPPER;
   }
   else if(InpPosition==RIGHT_LOWER)
   {
      TextCorner=CORNER_RIGHT_LOWER;
      TextAnchor=ANCHOR_RIGHT_LOWER;
   }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CleanUpChart()
{
   int TotalObjects = ObjectsTotal(0,0,OBJ_LABEL);
   string ObjName="";
   for(int i=TotalObjects-1; i>=0; i--)
   {
      ObjName = ObjectName(0,i,0,OBJ_LABEL);
      if(StringFind(ObjName,"ATRInd_")!=-1)
      {
         if(StringFind(ObjName,OBJ_PATTERN)==-1)
         {
            ObjectDelete(0,ObjName);
         }
      }
   }
}
//+------------------------------------------------------------------+
