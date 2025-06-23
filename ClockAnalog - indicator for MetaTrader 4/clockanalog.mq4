//+------------------------------------------------------------------+
//|                                                  ClockAnalog.mq5 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#include <ClockAnalog\CStockClock.mqh>
input string comment0="Position";
input int TopLeft=10;                  // Left position
input int TopHigh=15;                  // Top position
input string comment1="Colors and style";
input STOCK_SCHEME IptScheme=black;    // Color scheme
input color IptBlack=clrGreenYellow;   // Second hand color in black scheme
input color IptWhite=clrDarkOrange;    // Second hand color in white scheme
input ENUM_LINE_STYLE IptSecStyle=STYLE_SOLID; // Second hand style
input bool ShowSecond=true;            // Show second hand
input string comment2="Demo-mode";
input int year=0;                      // Year to show
input int month=0;                     // Month to show
input int day=0;                       // Day to show
//---
CStockClock *clock;
bool timer=true;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   ResetLastError();
   if(!EventSetTimer(1))
     {
      Print(__FUNCTION__," Error setting timer. Code: ",GetLastError());
      timer=false;
     }
   else
     {
      timer=true;
      clock=new CStockClock(TopLeft,TopHigh,"ClockAnalog",ShowSecond,IptScheme);
      if(year>0)
         clock.SetDebugDate(year,month,day);
      clock.DefaultsSkin();
      clock.SetExtSecond(IptBlack,IptWhite,IptSecStyle);
      clock.DefaultsSecond();
      clock.HandSecondMove();
      clock.DefaultsHours();
      clock.HandHourMove();
      clock.DefaultsMinute();
      clock.HandMinuteMove();
      clock.DefaultsHeader();
      clock.DefaultsHeaderLabel();
      clock.DefaultsMove();
      clock.DefaultsBack();
      clock.DefaultsHide();
      ChartRedraw(0);
     }
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
   if(timer) delete clock;
   DeleteAll();
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
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   clock.ProcessingDstEvent();
   clock.HandHourMove();
   clock.HandMinuteMove();
   clock.HandSecondMove();
   ChartRedraw(0);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   if(!clock.ClockHidden()) clock.EventBack(id,lparam,dparam,sparam);
   if(!clock.ClockHidden()) clock.EventMove(id,lparam,dparam,sparam);
   clock.EventHide(id,lparam,dparam,sparam);
   if(clock.ClockHidden())
     {
      clock.SetBackOn();
      clock.SetMoveOff();
     }
   ChartRedraw(0);
  }
//+------------------------------------------------------------------+
//| Delete objects by prefix                                         |
//+------------------------------------------------------------------+
void DeleteAll(void)
  {
   string obj_name;
   int obj_total=ObjectsTotal(0,0,-1);
   for(int i=obj_total-1;i>=0;i--)
     {
      obj_name=ObjectName(0,i,0,-1);
      if(StringFind(obj_name,"Clock",0)==0)
         ObjectDelete(0,obj_name);
     }
   ChartRedraw();
  }
//+------------------------------------------------------------------+
