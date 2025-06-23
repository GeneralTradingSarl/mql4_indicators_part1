//+------------------------------------------------------------------+
//|                                                      bbhisto.mq4 |
//|                                     Copyright © 2005, Nick Bilak |
//|        http://metatrader.50webs.com/         beluck[at]gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, Nick Bilak"
#property link      "http://metatrader.50webs.com/"
//----
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 Lime
#property indicator_color2 Aqua
#property indicator_color3 Magenta
//---- input parameters
extern int bolingerPeriod=13;
//---- buffers
double bb[];
double up[];
double lo[];
//----
int i,j;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,bb);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexBuffer(1,up);
   SetIndexEmptyValue(1,EMPTY_VALUE);
   SetIndexArrow(1,159);
   SetIndexStyle(2,DRAW_ARROW);
   SetIndexBuffer(2,lo);
   SetIndexEmptyValue(2,EMPTY_VALUE);
   SetIndexArrow(2,159);
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
   int counted_bars=IndicatorCounted();
   int shift,limit;
   double diff,d,ku,kd,km;
//----
   if (counted_bars<0) return(-1);
   if (counted_bars>0) counted_bars--;
   limit=Bars-31;
   if(counted_bars>=31) limit=Bars-counted_bars-1;
//----
   for(shift=limit+30;shift>=0;shift--)
     {
      bb[shift]=0;
      d=iStdDev(NULL,0,bolingerPeriod,MODE_SMA,0,PRICE_CLOSE,shift);
      if(d<0.0001) d=0.0001;
      bb[shift]=((Close[shift]+2*d - iMA(NULL,0,bolingerPeriod,0,MODE_SMA,PRICE_CLOSE,shift)) /
         (4*d))*4-2;
      bb[shift]=bb[shift]/3;
      up[shift]=EMPTY_VALUE;
      lo[shift]=EMPTY_VALUE;
      if (bb[shift]>0)
        {
         up[shift]=1;
        }
      if (bb[shift]<0)
        {
         lo[shift]=-1;
        }
     }
   return(0);
  }
//+------------------------------------------------------------------+