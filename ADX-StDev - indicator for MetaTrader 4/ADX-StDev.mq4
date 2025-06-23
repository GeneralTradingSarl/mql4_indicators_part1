//+------------------------------------------------------------------+
//|                                                    ADX-StDev.mq4 |
//|                                                 Copyright © 2011 |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011"
//-----
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 Gold
#property indicator_color2 Green
#property indicator_color3 Red
#property indicator_color4 Aqua
//-----
extern int ADXPeriod   = 5;// ADX
extern int ADXMode     = 1;// 0=MODE_SMA; 1=MODE_EMA; 2=MODE_SMMA; 3=MODE_LWMA.
extern int StdPeriod   = 3;// Standard Deviation 
extern int StdMode     = 0;// 0=MODE_SMA; 1=MODE_EMA; 2=MODE_SMMA; 3=MODE_LWMA.

//-----
double ADXBuffer[];
double PlusDiBuffer[];
double MinusDiBuffer[];
double PlusSdiBuffer[];
double MinusSdiBuffer[];
double TempBuffer[];
double subBuffer[];
//+------------------------------------------------------------------+
int init()
 {
   IndicatorBuffers(7);
   //----
   SetIndexStyle(0, DRAW_HISTOGRAM);
   SetIndexBuffer(0, ADXBuffer);
   SetIndexBuffer(1, PlusDiBuffer);
   SetIndexBuffer(2, MinusDiBuffer);
   SetIndexStyle(3, DRAW_LINE, STYLE_DOT);
   SetIndexBuffer(3, subBuffer);
   SetIndexBuffer(4, PlusSdiBuffer);
   SetIndexBuffer(5, MinusSdiBuffer);
   SetIndexBuffer(6, TempBuffer);   
   //----
   SetIndexLabel(0, "ADX");
   SetIndexLabel(1, "+DI");
   SetIndexLabel(2, "-DI");
   SetIndexLabel(3, "StDev");
   //----
   SetIndexDrawBegin(0,ADXPeriod);
   SetIndexDrawBegin(1,ADXPeriod);
   SetIndexDrawBegin(2,ADXPeriod);
   //----
   return(0);
 }
//+------------------------------------------------------------------+
int start()
 {
   double pdm,mdm,tr;
   double price_high,price_low;
   int    starti,i,counted_bars=IndicatorCounted();
   //----
   i=Bars-2;
   PlusSdiBuffer[i+1]=0;
   MinusSdiBuffer[i+1]=0;
   if(counted_bars >= i) i = Bars - counted_bars - 1;
   starti = i;
   //----
   while(i>=0)
    {
      price_low=Low[i];
      price_high=High[i];
      //----
      pdm=price_high-High[i+1];
      mdm=Low[i+1]-price_low;
      if(pdm<0) pdm=0;  // +DM
      if(mdm<0) mdm=0;  // -DM
      if(pdm==mdm) { pdm=0; mdm=0; }
      else if(pdm<mdm) pdm=0;
           else if(mdm<pdm) mdm=0;
      //----
      double num1 = MathAbs(price_high - price_low);
      double num2 = MathAbs(price_high - Close[i+1]);
      double num3 = MathAbs(price_low - Close[i+1]);
      tr = MathMax(num1, num2);
      tr = MathMax(tr, num3);
      //---- counting plus/minus direction
      if(tr == 0) { PlusSdiBuffer[i] = 0; MinusSdiBuffer[i] = 0; }
      else        { PlusSdiBuffer[i] = 100.0 * pdm / tr; MinusSdiBuffer[i] = 100.0 * mdm / tr; }
      //----
      i--;
    }
   //---- last counted bar will be recounted
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0) counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit--;
   //---- apply EMA to +DI
   for(i = 0; i <= limit; i++)
    {
      PlusDiBuffer[i]=iMAOnArray(PlusSdiBuffer, Bars, ADXPeriod, 0, ADXMode, i);
    }  
   //---- apply EMA to -DI
   for(i=0; i<=limit; i++)
      MinusDiBuffer[i] = iMAOnArray(MinusSdiBuffer, Bars, ADXPeriod, 0, ADXMode, i);
   //---- Directional Movement (DX)
   i = Bars - 2;
   TempBuffer[i+1] = 0;
   i = starti;
   while(i >= 0)
    {
      double div=MathAbs(PlusDiBuffer[i] + MinusDiBuffer[i]);
      if(div == 0.00) TempBuffer[i] = 0;
      else TempBuffer[i] = 100 * (MathAbs(PlusDiBuffer[i] - MinusDiBuffer[i]) / div);
      i--;
    }
   //---- ADX is exponential moving average and  Standard Deviation 
   for(i = 0; i < limit; i++)
    {
      ADXBuffer[i] = iMAOnArray(TempBuffer, Bars, ADXPeriod, 0, ADXMode, i);
      subBuffer[i] = iStdDevOnArray(TempBuffer, Bars, StdPeriod, 0, StdMode, i);
    }  
   //----
   return(0);
 }
//+------------------------------------------------------------------+