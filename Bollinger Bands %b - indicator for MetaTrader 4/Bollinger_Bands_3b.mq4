
//+-------------------------------------------------------------------+
//|                                            Bollinger Bands %b.mq4 |
//|                       Copyright © 2004, MetaQuotes Software Corp. |
//|                                         http://www.metaquotes.net |
//|                                     Modified by Alejandro Galindo |
//|                                                                   |
//|                                            You are free to use it |
//|                                                                   |
//|       If you want and if this work/modification is helpful to you |
//|              you can send me a PayPal donation to ag@elcactus.com |
//+-------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Yellow
//---- input parameters
extern int BBPeriod=20;
extern int StdDeviation=2;
//---- buffers
double BLGBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- indicator line
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,BLGBuffer);
//---- name for DataWindow and indicator subwindow label
   short_name="BBpB("+BBPeriod+","+StdDeviation+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
//----
   SetIndexDrawBegin(0,BBPeriod);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Momentum                                                         |
//+------------------------------------------------------------------+
int start()
  {
   int i,counted_bars=IndicatorCounted();
//----
   if(Bars<=BBPeriod) return(0);
//---- initial zero
   if(counted_bars<1)
      for(i=1;i<=BBPeriod;i++) BLGBuffer[Bars-i]=0.0;
//----
   i=Bars-BBPeriod-1;
   if(counted_bars>=BBPeriod) i=Bars-counted_bars-1;
   while(i>=0)
     {
      BLGBuffer[i]=(Close[i]-iBands(NULL,0,BBPeriod,StdDeviation,0,0,MODE_HIGH,i))/(iBands(NULL,0,BBPeriod,StdDeviation,0,0,MODE_LOW,i)-iBands(NULL,0,BBPeriod,StdDeviation,0,0,MODE_HIGH,i));
      i--;
     }
   return(0);
  }
//+------------------------------------------------------------------+