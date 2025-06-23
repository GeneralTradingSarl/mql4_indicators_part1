//+------------------------------------------------------------------+
//|                                                       ADXdon.mq4 |
//|                      Copyright © 2005, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"
//----
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 Green
#property indicator_color2 Red
#property indicator_color3 Blue
#property indicator_level1 20
//---- input parameters
extern int ADXPeriod=14,DiPlusPeriod=34,DiMinusPeriod=34;
//---- buffers
double ADXBuffer[];
double PlusDiBuffer[];
double MinusDiBuffer[];
double PlusSdiBuffer[];
double MinusSdiBuffer[];
double TRBuffer[];
double TempBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- 3 additional buffers are used for counting.
   IndicatorBuffers(7);
//---- indicator buffers
   SetIndexBuffer(0,ADXBuffer);
   SetIndexBuffer(1,PlusDiBuffer);
   SetIndexBuffer(2,MinusDiBuffer);
   SetIndexBuffer(3,PlusSdiBuffer);
   SetIndexBuffer(4,MinusSdiBuffer);
   SetIndexBuffer(5,TempBuffer);
   SetIndexBuffer(6,TRBuffer);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("ADX("+ADXPeriod+", DI-: "+DiMinusPeriod+", DI+: "+DiPlusPeriod+")");
   SetIndexLabel(0,"ADX");
   SetIndexLabel(1,"+DI");
   SetIndexLabel(2,"-DI");
//----
   SetIndexDrawBegin(0,ADXPeriod);
   SetIndexDrawBegin(1,ADXPeriod);
   SetIndexDrawBegin(2,ADXPeriod);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Average Directional Movement Index                               |
//+------------------------------------------------------------------+
int start()
  {
   double pdm,mdm,tr;
   double price_high,price_low;
   int    starti,i,counted_bars=IndicatorCounted();

   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+1;
      
   i=limit;
   starti=i;
//----
   while(i>=0)
     {
      price_low=Low[i];
      price_high=High[i];
      //----
      pdm=0.0;
      mdm=0.0;
      if(price_high>High[i+1])
         pdm=price_high-High[i+1];
      if(price_low<Low[i+1])
         mdm=Low[i+1]-price_low;
      if(pdm<mdm)
         pdm=0.0;
      else if(mdm<pdm)
         mdm=0.0;
      //---- absolute true range
      double num1=MathAbs(price_high-price_low);
      double num2=MathAbs(price_high-Close[i+1]);
      double num3=MathAbs(price_low-Close[i+1]);
      tr=MathMax(num1,num2);
      tr=MathMax(tr,num3);
      //---- counting plus/minus direction
      PlusSdiBuffer[i]=pdm;
      MinusSdiBuffer[i]=mdm;
      TRBuffer[i]=tr;
      //----
      i--;
     }
//---- apply EMA to +DI
   for(i=0; i<limit; i++)
     {
      //----    apply EMA to TR
      TRBuffer[i]=iMAOnArray(TRBuffer,0,ADXPeriod,0,MODE_EMA,i);
      PlusDiBuffer[i]=PlusDiBuffer[i+1];
      MinusDiBuffer[i]=MinusDiBuffer[i+1];
      if(TRBuffer[i]!=0)
        {
         PlusDiBuffer[i]=iMAOnArray(PlusSdiBuffer,0,DiPlusPeriod,0,MODE_EMA,i)/TRBuffer[i];
         //----    apply EMA to -DI
         MinusDiBuffer[i]=iMAOnArray(MinusSdiBuffer,0,DiMinusPeriod,0,MODE_EMA,i)/TRBuffer[i];
        }
     }
//---- Directional Movement (DX)
   //i=Bars-2;
//TempBuffer[i+1]=0;
   i=starti;
   while(i>=0)
     {
      double div=MathAbs(PlusDiBuffer[i]+MinusDiBuffer[i]);
      if(div==0.00) TempBuffer[i]=TempBuffer[i+1];
      else TempBuffer[i]=MathAbs(PlusDiBuffer[i]-MinusDiBuffer[i])/div;
      i--;
     }
//---- ADX is exponential moving average on DX
   for(i=0; i<limit; i++)
     {
      ADXBuffer[i]=iMAOnArray(TempBuffer,0,ADXPeriod,0,MODE_EMA,i)*100.0;
      PlusDiBuffer[i]=PlusDiBuffer[i]*100.0;
      MinusDiBuffer[i]=MinusDiBuffer[i]*100.0;
     }
//----
   return(0);
  }
//+------------------------------------------
//+------------------------------------------------------------------+
