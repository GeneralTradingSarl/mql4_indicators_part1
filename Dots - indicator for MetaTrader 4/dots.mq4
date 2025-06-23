//+------------------------------------------------------------------+
//|Based on NonLagDOT.mq4 by TrendLaboratory                         |
//|http://finance.groups.yahoo.com/group/TrendLaboratory             |
//|igorad2003@yahoo.co.uk                                            |
//|                                                         Dots.mq4 |
//|                                  Copyright © 2011, EarnForex.com |
//|                                         http://www.earnforex.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, EarnForex"
#property link      ""
/*
   Uses price curve angle calculations to come up with simple price indication.
   Simple strategy: enter when 2 dots of same color appear; exit, when different color dot appears.
*/
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 RoyalBlue
#property indicator_width1 2
#property indicator_color2 Red
#property indicator_width2 2
//---- input parameters
extern int    Length       = 10;
extern int    AppliedPrice = 0;
extern int    Filter       = 0;
extern double Deviation    = 0;
extern int    Shift        = 0;
//---- indicator buffers
double UpBuffer[];
double DnBuffer[];
//---- global variables
double Cycle=4;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(2);
//---
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexBuffer(0,UpBuffer);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexBuffer(1,DnBuffer);
//---
   SetIndexEmptyValue(0,EMPTY_VALUE);
   SetIndexEmptyValue(1,EMPTY_VALUE);
//---
   SetIndexArrow(0,159);
   SetIndexArrow(1,159);
//---
   SetIndexLabel(0,"Up");
   SetIndexLabel(1,"Dn");
//---
   SetIndexShift(0,Shift);
   SetIndexShift(1,Shift);
//---
   SetIndexDrawBegin(0,Length*Cycle+Length);
   SetIndexDrawBegin(1,Length*Cycle+Length);
//---
   IndicatorShortName("Dots("+Length+")");
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS));
//---
   return(0);
  }
//+------------------------------------------------------------------+
//| Dots                                                             |
//+------------------------------------------------------------------+
int start()
  {
   int    i,shift,counted_bars=IndicatorCounted(),limit,trend=0;
   double alfa,beta,t,Sum,Weight,g,price,MABuffer_prev=0,MABuffer=0;
   double pi=3.1415926535;
//---
   double Coeff = 3 * pi;
   double Phase = Length - 1;
   int Len=Length*Cycle+Phase;
//---
   if(counted_bars < 0) return(0);
   if(counted_bars>0) limit=Bars-counted_bars;
   else limit=Bars-Len-1;
//---
   for(shift=limit; shift>=0; shift--)
     {
      Weight=0; Sum=0; t=0;
      //---
      for(i=0; i<=Len-1; i++)
        {
         g=1.0/(Coeff*t+1);
         if(t<= 0.5) g = 1;
         beta = MathCos(pi * t);
         alfa = g * beta;
         price= iMA(NULL,0,1,0,MODE_SMA,AppliedPrice,shift+i);
         Sum+=alfa*price;
         Weight+=alfa;
         if(t<1) t+=1.0/(Phase-1);
         else if(t<Len-1) t+=(2*Cycle-1)/(Cycle*Length-1);
        }
      //---
      MABuffer_prev=MABuffer;
      if(Weight>0) MABuffer=(1.0+Deviation/100)*Sum/Weight;
      //---
      if(Filter>0)
         if(MathAbs(MABuffer-MABuffer_prev)<Filter*Point) MABuffer=MABuffer_prev;
      //---
      if(MABuffer-MABuffer_prev>Filter*Point) trend=1;
      else if(MABuffer_prev-MABuffer>Filter*Point) trend=-1;
      //---
      if(trend>0) UpBuffer[shift]=MABuffer;
      else if(trend<0) DnBuffer[shift]=MABuffer;
     }
//---
   return(0);
  }
//+------------------------------------------------------------------+
