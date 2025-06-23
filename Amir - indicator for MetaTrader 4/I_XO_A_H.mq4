//+------------------------------------------------------------------+
//|                                                         Amir.mq4 |
//|                                           Copyright © 2005, Amir |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, Amir"
#property link      ""
//----
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 clrGreen
#property indicator_color2 clrRed
//---- input parameters
extern int       BoxSize=15;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
int Cur=0;
int KirUp=0;
int KirDn=0;
int kr=0;
int no=0;
double valueh=0;
double valuel=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexLabel(0,"XOUP");
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexLabel(1,"XODOWN");
   IndicatorShortName("I-XO-A-H");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- TODO: add your code here
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int CurrentBar;
   double Hi,Lo,Curb;
   int    counted_bars=IndicatorCounted();
   int limit;
   limit=Bars-counted_bars;
   if(counted_bars==0) limit--;
//---- TODO: add your code here
//----Calculation---------------------------
   for(int i=0;i<=limit;i++)
     {
      CurrentBar=limit-i;
      if(Cur<1)
        {
         Hi=Close[CurrentBar];
         Lo=Close[CurrentBar];
         Cur=1;
        }
      Curb=Close[CurrentBar];
      if(Curb>(Hi+BoxSize*Point))
        {
         Cur+=1;
         Hi=Curb;
         Lo=Curb-BoxSize*Point;
         KirUp=1;
         KirDn=0;
         kr+=1;
         no=0;
        }
      if(Curb<(Lo-BoxSize*Point))
        {
         Cur+=1;
         Lo=Curb;
         Hi=Curb+BoxSize*Point;
         KirUp=0;
         KirDn=1;
         no+=1;
         kr=0;
        }
      valueh=kr;
      valuel=0-no;
      ExtMapBuffer1[CurrentBar]=valueh;
      ExtMapBuffer2[CurrentBar]=valuel;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
