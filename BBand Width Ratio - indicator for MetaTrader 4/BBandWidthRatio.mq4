//+------------------------------------------------------------------+
//|                                              BBandWidthRatio.mq4 |
//|                                                             Maji |
//+------------------------------------------------------------------+
#property copyright "Maji"
#property link      "None"
//----
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Blue
//---- input parameters
extern int       BB_Period=20;
extern double    Deviation=2.0;
//----
double buf1[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0, DRAW_LINE, EMPTY, 2);
   IndicatorDigits(MarketInfo(Symbol(), MODE_DIGITS));
   SetIndexDrawBegin(0,BB_Period);
   SetIndexLabel(0,"BBandWidthRatio");
   SetIndexBuffer(0, buf1);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i, j;
   double ave, sko, sum;
   int counted_bars=IndicatorCounted();
   double MA, Up, Dn;
//----
   if(Bars<=BB_Period) return(0);
//----
   i=Bars-BB_Period;
   if(counted_bars>BB_Period) i=Bars-counted_bars-1;
   if (Bars<=BB_Period) return;
   for(i=Bars-BB_Period; i>=0; i--)
     {
      //    buf2[i] = iMA(NULL,0,BB_Period,0,MODE_SMA,PRICE_CLOSE,i);
      MA=iMA(NULL,0,BB_Period,0,MODE_SMA,PRICE_CLOSE,i);
      sum=0;
      for(j=0; j<BB_Period; j++) sum+=Close[i+j];
      ave=sum/BB_Period;
      sum=0;
      for(j=0; j<BB_Period; j++) sum+=(Close[i+j]-ave)*(Close[i+j]-ave);
      sko=MathSqrt(sum/BB_Period);
      //    buf4[i] = buf2[i]+(Deviation*sko);
      //    buf3[i] = buf2[i]-(Deviation*sko);
      Up=MA+(Deviation*sko);
      Dn=MA-(Deviation*sko);
      //    buf1[i] = 2*(Deviation*sko)/buf2[i];
      buf1[i]=2*(Deviation*sko)/MA;
     }
   return(0);
  }
//+------------------------------------------------------------------+