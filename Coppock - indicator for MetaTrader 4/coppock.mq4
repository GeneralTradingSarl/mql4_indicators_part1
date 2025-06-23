//+------------------------------------------------------------------+
//|                                                      Coppock.mq4 |
//|                              Based on Coppock.mq4 by Robert Hill |
//|                                  Copyright © 2010, EarnForex.com |
//|                                        http://www.earnforex.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, EarnForex.com"
#property link      "http://www.earnforex.com"
/*
   Classical Coppock indicator. Should be applied on monthly timeframe.
   Periods shouldn't be changed. Change timeframe and parameters for
   experimental Coppock usage.  
*/
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 1
#property  indicator_color1  Red
//---- indicator parameters
extern int     ROC1Period = 14;
extern int     ROC2Period = 11;
extern int     MAPeriod   = 10;
extern string  strType    = "Moving Average Types:";
extern string  strm0      = "0 = SMA,  1 = EMA";
extern string  strm1      = "2 = SMMA, 3 = LWMA";
extern int     MAType     = 3;
//---- indicator buffers
double Coppock[];
double ROCSum[];
//---- variables
int    DrawBegin;
string strMAType;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- drawing settings
   IndicatorBuffers(2);
   SetIndexStyle(0,DRAW_HISTOGRAM);
//--- The longest period
   DrawBegin=MathMax(ROC1Period,ROC2Period)+MAPeriod;
   SetIndexDrawBegin(0,DrawBegin);
   IndicatorDigits(Digits);
//---- indicator buffers mapping
   SetIndexBuffer(0,Coppock);
   SetIndexBuffer(1,ROCSum);
//---
   SetIndexEmptyValue(0, 0.0);
   SetIndexEmptyValue(1, 0.0);
//---
   switch(MAType)
     {
      case 1:
         strMAType="EMA";
         break;
      case 2:
         strMAType="SMMA";
         break;
      case 3:
         strMAType="LWMA";
         break;
      default:
         strMAType="SMA";
         break;
     }
   IndicatorShortName("Coppock("+ROC1Period+", "+ROC2Period+") "+strMAType+"("+MAPeriod+")");
//---
   SetIndexLabel(0,"Coppock");
   return(0);
  }
//+------------------------------------------------------------------+
//| Coppock                                                          |
//+------------------------------------------------------------------+
int start()
  {
   int limit,i;
   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars < 0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   if(limit-Bars<DrawBegin) limit=Bars-DrawBegin;
//---- ROC calculations
   for(i=0; i<limit; i++)
      ROCSum[i]=(Close[i]-Close[i+ROC1Period])/Close[i+ROC1Period]+(Close[i]-Close[i+ROC2Period])/Close[i+ROC2Period];
//---
   for(i=0; i<limit; i++)
      Coppock[i]=iMAOnArray(ROCSum,0,MAPeriod,0,MAType,i);
//---
   return(0);
  }
//+------------------------------------------------------------------+
