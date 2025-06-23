//+------------------------------------------------------------------+
//|                                               FibonacciPivot.mq4 |
//|                                         Copyright © 2010, LeMan. |
//|                                      modification © 2015, noloxe |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, LeMan. && modification 2015, noloxe"
//----
#property indicator_chart_window
#property indicator_buffers 18
#property indicator_color1 LimeGreen
#property indicator_color2 LimeGreen
#property indicator_color3 LimeGreen
#property indicator_color4 LimeGreen
#property indicator_color5 LimeGreen
#property indicator_color6 LimeGreen
#property indicator_color7 LimeGreen
#property indicator_color8 LimeGreen
#property indicator_color9 DarkOrange
#property indicator_color10 DarkOrange
#property indicator_color11 DarkOrange
#property indicator_color12 DarkOrange
#property indicator_color13 DarkOrange
#property indicator_color14 DarkOrange
#property indicator_color15 DarkOrange
#property indicator_color16 DarkOrange
#property indicator_color17 Blue
#property indicator_color18 Black
//----
extern bool mondayGAP=false;
extern int Days=5;
extern double koeff=0.55;
extern string kof0 = "-- The recommended values of koeff ---";
extern string kof1 = "0.55 - to squeeze levels";
extern string kof2 = "0.89 - to squeeze levels";
extern string kof3 = "1.00 - changes won't be";
extern string kof4 = "1.44 - to stretch levels";
extern string kof5 = "2.33 - to stretch levels";
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
double ExtMapBuffer6[];
double ExtMapBuffer7[];
double ExtMapBuffer8[];
double ExtMapBuffer9[];
double ExtMapBuffer10[];
double ExtMapBuffer11[];
double ExtMapBuffer12[];
double ExtMapBuffer13[];
double ExtMapBuffer14[];
double ExtMapBuffer15[];
double ExtMapBuffer16[];
double ExtMapBuffer17[];
double ExtMapBuffer18[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(18);
   IndicatorDigits(Digits);
//---- indicators
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexBuffer(3,ExtMapBuffer4);
   SetIndexBuffer(4,ExtMapBuffer5);
   SetIndexBuffer(5,ExtMapBuffer6);
   SetIndexBuffer(6,ExtMapBuffer7);
   SetIndexBuffer(7,ExtMapBuffer8);
   SetIndexBuffer(8,ExtMapBuffer9);
   SetIndexBuffer(9,ExtMapBuffer10);
   SetIndexBuffer(10,ExtMapBuffer11);
   SetIndexBuffer(11,ExtMapBuffer12);
   SetIndexBuffer(12,ExtMapBuffer13);
   SetIndexBuffer(13,ExtMapBuffer14);
   SetIndexBuffer(14,ExtMapBuffer15);
   SetIndexBuffer(15,ExtMapBuffer16);
   SetIndexBuffer(16,ExtMapBuffer17);
   SetIndexBuffer(17,ExtMapBuffer18);
   SetIndexStyle(0,DRAW_LINE,2);
   SetIndexStyle(1,DRAW_LINE,2);
   SetIndexStyle(2,DRAW_LINE,2);
   SetIndexStyle(3,DRAW_LINE,1);
   SetIndexStyle(4,DRAW_LINE,1);
   SetIndexStyle(5,DRAW_LINE);
   SetIndexStyle(6,DRAW_LINE);
   SetIndexStyle(7,DRAW_LINE);
   SetIndexStyle(8,DRAW_LINE,2);
   SetIndexStyle(9,DRAW_LINE,2);
   SetIndexStyle(10,DRAW_LINE,2);
   SetIndexStyle(11,DRAW_LINE,1);
   SetIndexStyle(12,DRAW_LINE,1);
   SetIndexStyle(13,DRAW_LINE);
   SetIndexStyle(14,DRAW_LINE);
   SetIndexStyle(15,DRAW_LINE);
   SetIndexStyle(16,DRAW_LINE,2);
   SetIndexStyle(17,DRAW_LINE,2);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//----
   if(Period()>1439)
     {
      Comment("FibonacciPivot: Timeframe must be less D1 candles");
      return(-1);
     }
//----
   int i,limit2,limit,PrevDay,counted_bars;
   double hhv,llv,cl,tr,optoday;
//----   
   counted_bars=IndicatorCounted();
   if(counted_bars < 0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   if(Days!=0) limit2=Days*1440/Period();        // calculation number of days for drawing
   else limit2=limit;
   limit=fmin(limit,limit2);
   if(counted_bars==0) limit--;
//----
   for(i=limit; i>=0; i--)
     {
      PrevDay=iBarShift(Symbol(),PERIOD_D1,Time[i])+1;
      cl=iClose(NULL,PERIOD_D1,PrevDay);
      hhv = iHigh(NULL, PERIOD_D1, PrevDay);
      llv = iLow(NULL, PERIOD_D1, PrevDay);
      tr=hhv-llv;                                     // height of a day candle of previous day
      ExtMapBuffer17[i]=cl;                           // Level of Closing of previous day
      //----
      if(TimeDayOfWeek(Time[i])==1) // if Monday
        {
         optoday=iOpen(NULL,PERIOD_D1,PrevDay-1);
         ExtMapBuffer18[i]=optoday;                 // Level Opening of Monday. It is possible to hide — EMPTY_VALUE
         if(mondayGAP==true)
           {
            cl=optoday;                               // if GAP — levels drawing from Opening of Monday
           }
        }
      ExtMapBuffer1[i]=cl+tr*0.236*koeff;
      ExtMapBuffer2[i] = cl+tr*0.382*koeff;
      ExtMapBuffer3[i] = cl+tr*0.50*koeff;
      ExtMapBuffer4[i] = cl+tr*0.618*koeff;
      ExtMapBuffer5[i] = cl+tr*0.764*koeff;
      ExtMapBuffer6[i] = cl+tr*1*koeff;
      ExtMapBuffer7[i] = cl+tr*1.618*koeff;
      ExtMapBuffer8[i] = cl+tr*2.618*koeff;
      ExtMapBuffer9[i]=cl-tr*0.236*koeff;
      ExtMapBuffer10[i] = cl-tr*0.382*koeff;
      ExtMapBuffer11[i] = cl-tr*0.50*koeff;
      ExtMapBuffer12[i] = cl-tr*0.618*koeff;
      ExtMapBuffer13[i] = cl-tr*0.764*koeff;
      ExtMapBuffer14[i] = cl-tr*1*koeff;
      ExtMapBuffer15[i] = cl-tr*1.618*koeff;
      ExtMapBuffer16[i] = cl-tr*2.618*koeff;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
