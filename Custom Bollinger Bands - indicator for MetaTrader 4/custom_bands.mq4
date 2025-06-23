//+------------------------------------------------------------------+
//|                                                 Custom Bands.mq4 |
//|                   Copyright 2005-2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "2005-2014, MetaQuotes Software Corp."
#property link        "https://www.mql5.com"
#property description "Bollinger Bands with customizable moving average method and applied price"
#property strict

#include <MovingAverages.mqh>

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Red
#property indicator_color2 Red
#property indicator_color3 Red
//--- indicator parameters
input ENUM_MA_METHOD InpMovingMethod=MODE_SMA;   // Moving Average Method
input ENUM_APPLIED_PRICE InpAppliedPrice=PRICE_CLOSE;   // Applied Price
input int    InpBandsPeriod=20;      // Bands Period
input int    InpBandsShift=0;        // Bands Shift
input double InpBandsDeviations=2.0; // Bands Deviations
//--- buffers
double ExtMovingBuffer[];
double ExtUpperBuffer[];
double ExtLowerBuffer[];
double ExtStdDevBuffer[];
double ExtPriceBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(void)
  {
//--- 1 additional buffer used for counting
   IndicatorBuffers(5);
   IndicatorDigits(Digits);
//--- middle line
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMovingBuffer);
   SetIndexShift(0,InpBandsShift);
   SetIndexLabel(0,"Bands MA");
//--- upper band
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtUpperBuffer);
   SetIndexShift(1,InpBandsShift);
   SetIndexLabel(1,"Bands Upper");
//--- lower band
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,ExtLowerBuffer);
   SetIndexShift(2,InpBandsShift);
   SetIndexLabel(2,"Bands Lower");
//--- work buffer
   SetIndexBuffer(3,ExtStdDevBuffer);
   SetIndexBuffer(4,ExtPriceBuffer);
//--- check for input parameter
   if(InpBandsPeriod<=0)
     {
      Print("Wrong input parameter Bands Period=",InpBandsPeriod);
      return(INIT_FAILED);
     }
//---
   SetIndexDrawBegin(0,InpBandsPeriod+InpBandsShift);
   SetIndexDrawBegin(1,InpBandsPeriod+InpBandsShift);
   SetIndexDrawBegin(2,InpBandsPeriod+InpBandsShift);
//--- initialization done
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Bollinger Bands                                                  |
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
   int i,pos;
//---
   if(rates_total<=InpBandsPeriod || InpBandsPeriod<=0)
      return(0);
//--- counting from 0 to rates_total
   ArraySetAsSeries(ExtMovingBuffer,false);
   ArraySetAsSeries(ExtUpperBuffer,false);
   ArraySetAsSeries(ExtLowerBuffer,false);
   ArraySetAsSeries(ExtStdDevBuffer,false);
   ArraySetAsSeries(ExtPriceBuffer,false);
   ArraySetAsSeries(close,false);
   ArraySetAsSeries(open,false);
   ArraySetAsSeries(high,false);
   ArraySetAsSeries(low,false);
//--- initial zero
   if(prev_calculated<1)
     {
      for(i=0; i<InpBandsPeriod; i++)
        {
         ExtMovingBuffer[i]=EMPTY_VALUE;
         ExtUpperBuffer[i]=EMPTY_VALUE;
         ExtLowerBuffer[i]=EMPTY_VALUE;
        }
     }
//--- starting calculation
   if(prev_calculated>1)
      pos=prev_calculated-1;
   else
      pos=0;
//--- main cycle
   for(i=pos; i<rates_total && !IsStopped(); i++)
     {
      //--- price buffer
      switch(InpAppliedPrice)
        {
         case PRICE_CLOSE:
            ExtPriceBuffer[i]=close[i];
            break;
         case PRICE_OPEN:
            ExtPriceBuffer[i]=open[i];
            break;
         case PRICE_HIGH:
            ExtPriceBuffer[i]=high[i];
            break;
         case PRICE_LOW:
            ExtPriceBuffer[i]=low[i];
            break;
         case PRICE_MEDIAN:
            ExtPriceBuffer[i]=(high[i]+low[i])/2;
            break;
         case PRICE_TYPICAL:
         	ExtPriceBuffer[i]=(high[i]+low[i]+close[i])/3;
            break;
         case PRICE_WEIGHTED:
            ExtPriceBuffer[i]=(high[i]+low[i]+close[i]*2)/4;
            break;
        }
      //--- middle line
      switch(InpMovingMethod)
        {
         //--- Simple
         case  MODE_SMA:
            ExtMovingBuffer[i]=SimpleMA(i,InpBandsPeriod,ExtPriceBuffer);
            break;
            //--- Exponential
         case MODE_EMA:
            if(i==0)
            ExtMovingBuffer[i]=SimpleMA(i,InpBandsPeriod,ExtPriceBuffer);
            else
               ExtMovingBuffer[i]=ExponentialMA(i,InpBandsPeriod,ExtMovingBuffer[i-1],ExtPriceBuffer);
            break;
            //--- Smooted
         case MODE_SMMA:
            if(i==0)
            ExtMovingBuffer[i]=SimpleMA(i,InpBandsPeriod,ExtPriceBuffer);
            else
               ExtMovingBuffer[i]=SmoothedMA(i,InpBandsPeriod,ExtMovingBuffer[i-1],ExtPriceBuffer);
            break;
            break;
            //--- Linear Weighted
         case MODE_LWMA:
            ExtMovingBuffer[i]=LinearWeightedMA(i,InpBandsPeriod,ExtPriceBuffer);
            break;
         default:
            break;
        }
      //--- calculate and write down StdDev
      ExtStdDevBuffer[i]=StdDev_Func(i,ExtPriceBuffer,ExtMovingBuffer,InpBandsPeriod);
      //--- upper line
      ExtUpperBuffer[i]=ExtMovingBuffer[i]+InpBandsDeviations*ExtStdDevBuffer[i];
      //--- lower line
      ExtLowerBuffer[i]=ExtMovingBuffer[i]-InpBandsDeviations*ExtStdDevBuffer[i];
      //---
     }
//---- OnCalculate done. Return new prev_calculated.
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Calculate Standard Deviation                                     |
//+------------------------------------------------------------------+
double StdDev_Func(int position,const double &price[],const double &MAprice[],int period)
  {
//--- variables
   double StdDev_dTmp=0.0;
//--- check for position
   if(position>=period)
     {
      //--- calcualte StdDev
      for(int i=0; i<period; i++)
         StdDev_dTmp+=MathPow(price[position-i]-MAprice[position],2);
      StdDev_dTmp=MathSqrt(StdDev_dTmp/period);
     }
//--- return calculated value
   return(StdDev_dTmp);
  }
//+------------------------------------------------------------------+
