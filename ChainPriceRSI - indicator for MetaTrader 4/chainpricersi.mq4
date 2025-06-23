//+------------------------------------------------------------------+
//|                                                ChainPriceRSI.mq4 |
//|                 Copyright 2014,  Roy Philips Jacobs ~ 13/08/2014 |
//|                                           http://www.gol2you.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014,  Roy Philips Jacobs ~ 13/08/2014"
#property link      "http://www.gol2you.com ~ Forex Videos"
#property description "Forex Indicator ChainPriceRSI ~ Based on the RSI and MA indicators."
#property description "Chain Price RSI Indicator is an indicator of Trend Lines Arrow with Direction to open orders."
#property version   "1.00"
#property strict
//--
#include <MovingAverages.mqh>
//--
#property indicator_separate_window
#property indicator_buffers 10
#property indicator_color1 clrNONE
#property indicator_color2 clrRed
#property indicator_color3 clrNONE
#property indicator_color4 clrNONE
#property indicator_color5 clrBlue
#property indicator_color6 clrNONE
#property indicator_color7 clrWhite
#property indicator_color8 clrNONE
//--
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 1
#property indicator_width4 1
#property indicator_width5 1
#property indicator_width6 1
#property indicator_width7 1
#property indicator_width8 1
//--
input string ChainPriceRSI="Copyright © 2014 3RJ ~ Roy Philips-Jacobs";
input int RSIPeriod=14; // RSI Period
input int TrendPeriod=34;
input int MovePeriod=3;
input int BasePeriod=6;
//-- indicator_buffers
double RSIbuf[];
double Trendbuf[];
double maMvbuf[];
double maBsbuf[];
double maMvBbuf[];
double maBsBbuf[];
double maMvSbuf[];
double maBsSbuf[];
double ma3[],ma10[];
//--
string symbol;
string CopyR;
//--
void EventSetTimer();
//---
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator property
   symbol=_Symbol;
   CopyR="Copyright © 2014 3RJ ~ Roy Philips-Jacobs";
//---  
//--- indicator buffers mapping
   IndicatorBuffers(10);
   //---
   SetIndexBuffer(0,RSIbuf);
   SetIndexBuffer(1,Trendbuf);
   SetIndexBuffer(2,maMvbuf);
   SetIndexBuffer(3,maBsbuf);   
   SetIndexBuffer(4,maMvBbuf);
   SetIndexBuffer(5,maBsBbuf);
   SetIndexBuffer(6,maMvSbuf);
   SetIndexBuffer(7,maBsSbuf);
   SetIndexBuffer(8,ma3);
   SetIndexBuffer(9,ma10);
//--- set levels   
   IndicatorSetInteger(INDICATOR_LEVELS,4);
   IndicatorSetDouble(INDICATOR_LEVELVALUE,0,20);
   IndicatorSetDouble(INDICATOR_LEVELVALUE,1,38);
   IndicatorSetString(INDICATOR_LEVELTEXT,1,"Sell above or equal to level-38");
   IndicatorSetDouble(INDICATOR_LEVELVALUE,2,62);
   IndicatorSetString(INDICATOR_LEVELTEXT,2,"Buy below or equal to level-62");
   IndicatorSetDouble(INDICATOR_LEVELVALUE,3,80);
//--- set maximum and minimum for subwindow 
   IndicatorSetDouble(INDICATOR_MINIMUM,0);
   IndicatorSetDouble(INDICATOR_MAXIMUM,100);
   //--- indicator line drawing
   SetIndexStyle(0,DRAW_NONE);
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,EMPTY,clrRed);
   SetIndexStyle(2,DRAW_NONE);
   SetIndexStyle(3,DRAW_NONE);   
   SetIndexStyle(4,DRAW_ARROW,STYLE_SOLID,EMPTY,clrBlue);
   SetIndexArrow(4,217);
   SetIndexStyle(5,DRAW_NONE);
   SetIndexStyle(6,DRAW_ARROW,STYLE_SOLID,EMPTY,clrWhite);
   SetIndexArrow(6,218);
   SetIndexStyle(7,DRAW_NONE);
   SetIndexStyle(8,DRAW_NONE);
   SetIndexStyle(9,DRAW_NONE);
   //--- name for DataWindow and indicator subwindow label
   SetIndexLabel(0,"RSI("+string(RSIPeriod)+")");
   SetIndexLabel(1,"Trend("+string(TrendPeriod)+")");
   SetIndexLabel(2,"Move("+string(MovePeriod)+")");
   SetIndexLabel(3,"Base("+string(BasePeriod)+")");
   SetIndexLabel(4,"Buy Level");
   SetIndexLabel(5,NULL);
   SetIndexLabel(6,"Sell Level");
   SetIndexLabel(7,NULL);
   SetIndexLabel(8,NULL);
   SetIndexLabel(9,NULL);
   //--
   IndicatorShortName("ChainPriceRSI ");
   IndicatorDigits(Digits);
   //--
//---
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
//----
   return;
  }
//---
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
   if(ChainPriceRSI!=CopyR) return(0);
//---
   int i,limit;
   bool buy,sell;
//--- check for bars count
   if(rates_total<=TrendPeriod) return(0);
//--- last counted bar will be recounted
   limit=rates_total-prev_calculated;
   if(prev_calculated>0) limit++;
   //--
   
//--- counting from rates_total to 0 
   ArraySetAsSeries(RSIbuf,true);
   ArraySetAsSeries(Trendbuf,true);
   ArraySetAsSeries(maMvbuf,true);
   ArraySetAsSeries(maBsbuf,true);
   ArraySetAsSeries(maMvBbuf,true);
   ArraySetAsSeries(maBsBbuf,true);
   ArraySetAsSeries(maMvSbuf,true);
   ArraySetAsSeries(maBsSbuf,true);
   ArraySetAsSeries(ma3,true);
   ArraySetAsSeries(ma10,true);
   ArraySetAsSeries(low,true);
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(close,true);
   //--
//--- main cycle
   for(i=limit-1; i>=0; i--)
     {
       //---
       RSIbuf[i]=iRSI(symbol,0,RSIPeriod,PRICE_CLOSE,i);
       SmoothedMAOnBuffer(rates_total,prev_calculated,0,TrendPeriod,RSIbuf,Trendbuf);
       SmoothedMAOnBuffer(rates_total,prev_calculated,0,MovePeriod,RSIbuf,maMvbuf);
       SimpleMAOnBuffer(rates_total,prev_calculated,0,BasePeriod,RSIbuf,maBsbuf);
       ma3[i]=iMA(symbol,0,3,0,MODE_SMA,PRICE_WEIGHTED,i);
       ma10[i]=iMA(symbol,0,10,0,MODE_SMA,PRICE_WEIGHTED,i);
       //--
       if((maMvbuf[i]>maBsbuf[i])&&((ma3[i]-ma10[i])>(ma3[i+1]-ma10[i+1]))) {buy=true; sell=false;}
       if((maMvbuf[i]<maBsbuf[i])&&((ma3[i]-ma10[i])<(ma3[i+1]-ma10[i+1]))) {sell=true; buy=false;}
       //--
       if(buy) {maMvBbuf[i]=maMvbuf[i]; maBsBbuf[i]=maBsbuf[i]; maMvSbuf[i]=EMPTY_VALUE; maBsSbuf[i]=EMPTY_VALUE;}
       if(sell) {maMvSbuf[i]=maMvbuf[i]; maBsSbuf[i]=maBsbuf[i]; maMvBbuf[i]=EMPTY_VALUE; maBsBbuf[i]=EMPTY_VALUE;}
       //---
     }
   //---
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+