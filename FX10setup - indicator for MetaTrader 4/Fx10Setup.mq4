//+------------------------------------------------------------------+
//|                                                                  |
//|                 Copyright © 2000-2007, MetaQuotes Software Corp. |
//|                                         http://www.metaquotes.ru |
//+------------------------------------------------------------------+
#property copyright "palanka"
#property link      ""
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 LimeGreen
#property indicator_color2 Red
//----
extern double ParmMult=2.0; // multiply the standard parameters by this scale factor
//----
int shift=0;
bool first=true;
int prevbars=0;
bool RsiUp=false, RsiDown=false;
double signal_long[];
double signal_short[];
bool up=false;
bool down=false;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexBuffer(0,signal_long);
   SetIndexBuffer(1,signal_short);
   IndicatorShortName("Fx10Setup");
   SetIndexEmptyValue(0, 0.0) ;
   SetIndexEmptyValue(1, 0.0) ;
   //
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,233);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,234);
   //
   IndicatorDigits(1);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   /*if (prevbars==Bars)
      return(0);
   // check for additional bars loading or total reloading
   if ((Bars < prevbars) || (Bars - prevbars > 1))
      first=true;
//----
   prevbars=Bars;
   if (first)
     {
      if (Bars<=26 * ParmMult)
         return(0);
      first=false;
     }
   shift=Bars;
   */
   
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int shift = Bars - counted_bars;
   if(counted_bars==0) shift-=1+26*ParmMult;
   
   while(shift>=0)
     {
      signal_long[shift]=0.0;
      signal_short[shift]=0.0;
//----
      double fastMA=iMA(NULL, 0, 5 * ParmMult, 0, MODE_LWMA, PRICE_CLOSE, shift);
      double slowMA=iMA(NULL, 0, 10 * ParmMult, 0, MODE_SMA, PRICE_CLOSE, shift);
//----
      if (fastMA > slowMA)
        {
         RsiUp=iRSI(NULL, 0, 14 * ParmMult, PRICE_CLOSE, shift)>=55.0;
         //and iRSI(p1, 1) > iRSI(p1, 2)
         double Stoch0=iStochastic(NULL, 0, 5*ParmMult, 3*ParmMult, 3*ParmMult, MODE_SMA, PRICE_CLOSE, MODE_MAIN, shift);
         // double Stoch1 = iStochastic(NULL, 0, 5*ParmMult, 3*ParmMult, 3*ParmMult, MODE_SMA, PRICE_CLOSE, MODE_MAIN, shift + 1);
         double StochSig0=iStochastic(NULL, 0, 5*ParmMult, 3*ParmMult, 3*ParmMult, MODE_SMA, PRICE_CLOSE, MODE_SIGNAL, shift);
         bool StochUp=(Stoch0 > StochSig0);
         //and Stoch0 > Stoch1
         //and Stoch0 >= StochHigh
         double MacdCurrent=iMACD(NULL, 0, 12*ParmMult, 26*ParmMult, 9*ParmMult, PRICE_CLOSE, MODE_MAIN, shift);
         // double MacdPrevious = iMACD(NULL, 0, 12*ParmMult, 26*ParmMult, 9*ParmMult, PRICE_CLOSE, MODE_MAIN, shift + 1);
         double MacdSig0=iMACD(NULL, 0, 12*ParmMult, 26*ParmMult, 9*ParmMult, PRICE_CLOSE, MODE_SIGNAL, shift);
         bool MacdUp=(MacdCurrent > MacdSig0);
         //and  MacdCurrent > MacdPrevious
         //and MacdCurrent > 50
         if (StochUp && RsiUp && MacdUp)
            signal_long[shift]=High[shift] + 0.3/MathPow(10.0, Digits - 1);
        }
      else if (fastMA < slowMA)
           {
            RsiDown=iRSI(NULL, 0, 14 * ParmMult, PRICE_CLOSE, shift)<=45.0;
            //and iRSI(p1, 2) > iRSI(p1, 1)
            Stoch0=iStochastic(NULL, 0, 5*ParmMult, 3*ParmMult, 3*ParmMult, MODE_SMA, PRICE_CLOSE, MODE_MAIN, shift);
            // double Stoch1 = iStochastic(NULL, 0, 5*ParmMult, 3*ParmMult, 3*ParmMult, MODE_SMA, PRICE_CLOSE, MODE_MAIN, shift + 1);
            StochSig0=iStochastic(NULL, 0, 5*ParmMult, 3*ParmMult, 3*ParmMult, MODE_SMA, PRICE_CLOSE, MODE_SIGNAL, shift);
            bool StochDown=(Stoch0 < StochSig0);
            //and Stoch0 < Stoch1
            //and Stoch0 <= StochLow
            MacdCurrent=iMACD(NULL, 0, 12*ParmMult, 26*ParmMult, 9*ParmMult, PRICE_CLOSE, MODE_MAIN, shift);
            // double MacdPrevious = iMACD(NULL, 0, 12*ParmMult, 26*ParmMult, 9*ParmMult, PRICE_CLOSE, MODE_MAIN, shift + 1);
            MacdSig0=iMACD(NULL, 0, 12*ParmMult, 26*ParmMult, 9*ParmMult, PRICE_CLOSE, MODE_SIGNAL, shift);
            bool MacdDown=(MacdCurrent < MacdSig0);
            //and  MacdCurrent < MacdPrevious
            //and MacdCurrent < 50
            if (StochDown && RsiDown && MacdDown)
               signal_short[shift]=Low[shift] - 0.3/MathPow(10.0, Digits - 1);
           }
      shift--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+