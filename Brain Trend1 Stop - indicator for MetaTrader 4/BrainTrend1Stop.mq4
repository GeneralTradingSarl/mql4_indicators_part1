//+------------------------------------------------------------------+
//|                                              BrainTrend1Stop.mq4 |
//|                                     BrainTrading Inc. System 7.0 |
//|                                      http://www.braintrading.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, MetaQuotes Software Corp."
#property link      "http://www.braintrading.comt"
//----
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Magenta
#property indicator_color2 Aqua
//---- input parameters
extern int       NumBars=500;
extern int       EnableAlerts=0;
extern int       SignalID=0;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,115);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexEmptyValue(0,0.0);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,115);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexEmptyValue(1,0.0);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
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
   int    counted_bars=IndicatorCounted();
//---- 
   double    RISK=3;
   double    value2=0;
   double    value3=0;
   double    value11=0;
   double    x1=70;
   double    x2=30;
   double    i1=0;
   double    TrueCount=0;
   double    Counter=0;
   double    Range=0;
   double    AvgRange=0;
   double    MRO1=0;
   double    MRO2=0;
   double    val1=0;
   double    val2=0;
   int    shift=0;
   double    p=0;
   double    r=0;
   double    s=1.5;
   double    value4=0;
   double    value5=0;
   double    abrs=0;
   double    f=7;
   double    d=2.3;
   double    range1=0;
   double    r1=0;
   double    h11=0;
   double    h12=0;
   double    h13=0;
   double    Const=0;
   double    orig=0;
   double    st=0;
   double    h2=0;
   double    h1=0;
   double    h10=0;
   double    sxs=0;
   double    sms=0;
   double    temp=0;
   double    h5=0;
   int    a1=0;
   int    bs=0;
   int    bs1=0;
   double    r1s=0;
   double    r2s=0;
   double    r3s=0;
   double    r4s=0;
   double    pt=0;
   double    pts=0;
   double    r2=0;
   double    r3=0;
   double    r4=0;
   double    tt=0;
//----
   st=1;
   if (st==1)
     {
      value11=9;
      x1=53;
      x2=47;
      if (Bars < abrs)abrs=Bars - 11; else abrs=NumBars - 11;
//----
      shift=abrs;
      while(shift>=0)
        {
         Range=iATR(NULL,0,f,shift);
         range1=iATR(NULL,0,10,shift);
         value2=iStochastic(NULL,0,value11,value11,1,0,0,0,shift);
         val1=0;
         val2=0;
         if (value2 < x2 && MathAbs(Close[shift] - Close[shift + 2]) > Range/d && p!=1 )
           {
            value3=High[shift] + range1 * s/4;
            val1=value3;
            p=1;
            r=val1;
            bs=r;
            ExtMapBuffer1[shift]=val1;
            ExtMapBuffer2[shift]=0;
           }
         if (value2 > x1 && MathAbs(Close[shift] - Close[shift + 2]) > Range/d && p!=2)
           {
            value3=Low[shift] - range1 * s/4;
            val2=value3;
            p=2;
            r=val2;
            bs=r;
            ExtMapBuffer1[shift]=0;
            ExtMapBuffer2[shift]=val2;
           }
         value4=High[shift] + range1 * s;
         value5=Low[shift] - range1 * s;
         if (val1==0 && val2==0 && p==1 )
           {
            if (value4 < r)
              {
               r=value4;
               bs=r;
               ExtMapBuffer1[shift]=r;
               ExtMapBuffer2[shift]=0;
              }
            else
              {
               r=r;
               bs=r;
               ExtMapBuffer1[shift]=r;
               ExtMapBuffer2[shift]=0;
              }
           }
         if(val1==0 && val2==0 && p==2)
           {
            if (value5 > r)
              {
               r=value5;
               bs=r;
               ExtMapBuffer1[shift]=0;
               ExtMapBuffer2[shift]=r;

              }
            else
              {
               r=r;
               bs=r;
               ExtMapBuffer1[shift]=0;
               ExtMapBuffer2[shift]=r;
              }
           }
         shift--;
        }
     }
   if (EnableAlerts==1)
     {
      if (bs > 0 && bs!=bs1 )
        {
         bs1=bs;
         //----
         Alert("BT1Stop value for " , Symbol() , " is " , bs , " Current Close=" , Close[0] , " M" + (string)Period());
         //a1 = FileOpen("alert1" + SignalID,";");
         //FileWrite(a1,"BT1Stop value for " , Symbol() , " is " , bs , " Current Close=" , Close[0] , " M" + Period());
         //FileClose(a1);
        }
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+