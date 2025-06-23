//+------------------------------------------------------------------+
//|                                                      BB_OsMA.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014,  Roy Philips Jacobs ~ 2014/12/13"
#property link      "http://www.mql5.com"
#property link      "http://www.gol2you.com ~ Forex Videos"
#property version   "1.00"
#property strict
//--
#property description "BB_OsMA indicator is the Forex indicators for MT4."
#property description "BB_OsMA indicator is the OsMA indicator in the form of spheroid,"
#property description "with a deviation as the upper and lower bands."
/*
Update 01: 26/01/2016 ~ Correction bugs.
Update 02: 08/02/2016 ~ error Correction.
*/
//--
#include <MovingAverages.mqh>
//--
#property indicator_separate_window
#property indicator_buffers 8
#property indicator_color1 clrNONE
#property indicator_color2 clrNONE
#property indicator_color3 clrNONE
#property indicator_color4 clrWhite
#property indicator_color5 clrRed
#property indicator_color6 clrBlue
#property indicator_color7 clrYellow
#property indicator_color8 clrNONE
//--
#property indicator_width4 1
#property indicator_width5 1
#property indicator_width6 1
#property indicator_width7 1
//--
//--
extern string    BB_OsMA="Copyright © 2014 By 3RJ ~ Roy Philips-Jacobs";
extern int   OsMAFastEMA=26;   // Fast EMA Period
extern int   OsMASlowEMA=130;   // Slow EMA Period
extern int OsMASignalEMA=13;  // Signal SMA Period
extern double     StdDev=2.0; // Standard Deviation
//--- buffers
double OsMABuffer[];
double exOsMAMacd[];
double exOsMASign[];
double OsMABuffUp[];
double OsMABuffDn[];
double OsMAUpBand[];
double OsMALoBand[];
double OsMAAvg[];
double OsMADev;
//--
int OsAvgPeriod=20;
int OsDevPeriod=20;
//--
string symbol;
string CopyRight;
//--
void EventSetTimer();
//----
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator property
   symbol=_Symbol;
   CopyRight="Copyright © 2014 By 3RJ ~ Roy Philips-Jacobs";
//--- indicator buffers mapping
   IndicatorBuffers(8);
//--
   SetIndexBuffer(0,OsMABuffer);
   SetIndexBuffer(1,exOsMAMacd);
   SetIndexBuffer(2,exOsMASign);
   SetIndexBuffer(3,OsMABuffUp);
   SetIndexBuffer(4,OsMABuffDn);
   SetIndexBuffer(5,OsMAUpBand);
   SetIndexBuffer(6,OsMALoBand);
   SetIndexBuffer(7,OsMAAvg);
//--- indicator line drawing
   SetIndexStyle(0,DRAW_NONE);
   SetIndexStyle(1,DRAW_NONE);
   SetIndexStyle(2,DRAW_NONE);
//--
   SetIndexStyle(3,DRAW_ARROW);
   SetIndexArrow(3,108);
   SetIndexStyle(4,DRAW_ARROW);
   SetIndexArrow(4,108);
   SetIndexStyle(5,DRAW_LINE,STYLE_SOLID,EMPTY);
   SetIndexStyle(6,DRAW_LINE,STYLE_SOLID,EMPTY);
//-
   SetIndexStyle(7,DRAW_NONE);
//--
   SetIndexDrawBegin(3,OsAvgPeriod);
   SetIndexDrawBegin(4,OsAvgPeriod);
   SetIndexDrawBegin(5,OsAvgPeriod);
   SetIndexDrawBegin(6,OsAvgPeriod);
//--- name for DataWindow and indicator subwindow label
   SetIndexLabel(0,NULL);
   SetIndexLabel(1,NULL);
   SetIndexLabel(2,NULL);
   SetIndexLabel(3,"OsMAUps");
   SetIndexLabel(4,"OsMADown");
   SetIndexLabel(5,"UpperBand");
   SetIndexLabel(6,"LowerBand");
   SetIndexLabel(7,NULL);
//--
   IndicatorShortName("BB_OsMA("+string(OsMAFastEMA)+","+string(OsMASlowEMA)+","+string(OsMASignalEMA)+")");
   IndicatorDigits(Digits);
//--
//--- initialization done
   return(INIT_SUCCEEDED);
  }
//---
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//----
   EventKillTimer();
   GlobalVariablesDeleteAll();
//---
   ObjectsDeleteAll(ChartFirst());
//--
//----
   return;
  }
//----
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
   if(BB_OsMA!=CopyRight) return(0);
//---   
   int x,BarCnt;
//---
   if(rates_total<=OsMASlowEMA) return(0);
//--- last counted bar will be recounted
   BarCnt=rates_total-prev_calculated;
   if(prev_calculated>0)
      BarCnt++;
//--
   ArrayResize(OsMABuffer,BarCnt);
   ArrayResize(exOsMAMacd,BarCnt);
   ArrayResize(exOsMASign,BarCnt);
//-
   ArraySetAsSeries(OsMABuffer,true);
   ArraySetAsSeries(exOsMAMacd,true);
   ArraySetAsSeries(exOsMASign,true);
//--
//--- macd counted in the 1-st buffer
   for(x=BarCnt-2; x>=0; x--)
     {exOsMAMacd[x]=iMA(symbol,0,OsMAFastEMA,0,1,6,x)-iMA(symbol,0,OsMASlowEMA,0,1,6,x);}
//--
//--- signal line counted in the 2-nd buffer
   ExponentialMAOnBuffer(rates_total,prev_calculated,0,OsMASignalEMA,exOsMAMacd,exOsMASign);
//---
//--- main loop
   for(x=BarCnt-2; x>=0; x--)
     {OsMABuffer[x]=(exOsMAMacd[x]-exOsMASign[x])*(OsMASlowEMA/OsMAFastEMA);}
//--
//----
   for(x=BarCnt-2; x>=0; x--)
     {
      OsMAAvg[x]=iMAOnArray(OsMABuffer,0,OsAvgPeriod,0,0,x);
      OsMADev=iStdDevOnArray(OsMABuffer,0,OsAvgPeriod,0,0,x);
      OsMAUpBand[x]=OsMAAvg[x]+(StdDev*OsMADev);
      OsMALoBand[x]=OsMAAvg[x]-(StdDev*OsMADev);
      OsMABuffUp[x]=OsMABuffer[x];  // OsMA Uptrend
      OsMABuffDn[x]=OsMABuffer[x];  // OPsMA Downtrend
      //----
      if(OsMABuffer[x]>OsMABuffer[x+1])
         OsMABuffDn[x]=EMPTY_VALUE;
      //----
      if(OsMABuffer[x]<OsMABuffer[x+1])
         OsMABuffUp[x]=EMPTY_VALUE;
     }
//--
//---- done
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
