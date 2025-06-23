//+------------------------------------------------------------------+
//|                                               Average of ATR.mq4 |
//|                                     Copyright 2015, FXMatics.com |
//|                                          http://www.fxmatics.com |
//+------------------------------------------------------------------+
#property copyright   "2015, FXMatics.com"
#property link        "http://www.fxmatics.com"
#property description "Average of ATR"
#property strict

//--- indicator settings
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1  DodgerBlue
#property indicator_color2  Lime
//--- input parameter
input int InpAtrPeriod=7; // ATR Period
input int InpAvgPeriod=3; // AVG Period
//--- buffers
double ExtATRBuffer[];
double ExtTRBuffer[];
double ExtATR2Buffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(void)
  {
   string short_name;
//--- 1 additional buffer used for counting.
   IndicatorBuffers(3);
   IndicatorDigits(Digits);
//--- indicator line
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtATRBuffer);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtATR2Buffer);
   SetIndexBuffer(2,ExtTRBuffer);
//--- name for DataWindow and indicator subwindow label
   short_name="Average of ATR("+IntegerToString(InpAtrPeriod)+", "+IntegerToString(InpAvgPeriod)+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,"ATR");
   SetIndexLabel(1,"AATR");
//--- check for input parameter
   if(InpAtrPeriod<=0) 
     {
      Print("Wrong input parameter ATR Period=",InpAtrPeriod);
      return(INIT_FAILED);
        } else if(InpAvgPeriod<=0) {
      Print("Wrong input parameter AATR Period=",InpAvgPeriod);
      return(INIT_FAILED);
     }
//---
   SetIndexDrawBegin(0,InpAtrPeriod);
   SetIndexDrawBegin(0,InpAtrPeriod*InpAvgPeriod);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Average True Range                                               |
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
   int i,limit;
//--- check for bars count and input parameter
   if(rates_total<=InpAtrPeriod || InpAtrPeriod<=0)
      return(0);
//--- counting from 0 to rates_total
   ArraySetAsSeries(ExtATRBuffer,false);
   ArraySetAsSeries(ExtTRBuffer,false);
   ArraySetAsSeries(ExtATR2Buffer,false);
   ArraySetAsSeries(high,false);
   ArraySetAsSeries(low,false);
//--- preliminary calculations
   if(prev_calculated==0)
     {
      ExtTRBuffer[0]=0.0;
      ExtATRBuffer[0]=0.0;
      ExtATR2Buffer[0]=0.0;
      //--- filling out the array of True Range values for each period
      for(i=1; i<rates_total; i++)
         ExtTRBuffer[i]=(high[i]-low[i])/Point;
      //--- first AtrPeriod values of the indicator are not calculated
      double firstValue=0.0;
      for(i=1; i<=InpAtrPeriod; i++)
        {
         ExtATRBuffer[i]=0.0;
         firstValue+=ExtTRBuffer[i];
        }
      //--- calculating the first value of the indicator
      firstValue/=InpAtrPeriod;
      ExtATRBuffer[InpAtrPeriod]=firstValue;
      limit=InpAtrPeriod+1;
     }
   else
      limit=prev_calculated-1;
//--- the main loop of calculations
   for(i=limit; i<rates_total; i++)
     {
      ExtTRBuffer[i]=(high[i]-low[i])/Point;
      ExtATRBuffer[i]=ExtATRBuffer[i-1]+(ExtTRBuffer[i]-ExtTRBuffer[i-InpAtrPeriod])/InpAtrPeriod;
      CalculateAATR(rates_total,prev_calculated);
     }

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

void CalculateAATR(int rates_total,int prev_calculated)
  {
   int i,limit;
//--- first calculation or number of bars was changed
   if(prev_calculated==0)

     {
      limit=InpAvgPeriod;
      //--- calculate first visible value
      double firstValue=0;
      for(i=0; i<limit; i++)
         firstValue+=ExtATRBuffer[i];
      firstValue/=InpAvgPeriod;
      ExtATR2Buffer[limit-1]=firstValue;
     }
   else
      limit=prev_calculated-1;
//--- main loop
   for(i=limit; i<rates_total && !IsStopped(); i++)
      ExtATR2Buffer[i]=ExtATR2Buffer[i-1]+(ExtATRBuffer[i]-ExtATRBuffer[i-InpAvgPeriod])/InpAvgPeriod;
//---
  }
//+------------------------------------------------------------------+
