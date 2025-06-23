//+------------------------------------------------------------------+
//|                                                  EMABands_v1.mq4 |
//|                                  Copyright © 2006, Forex-TSD.com |
//|                         Written by IgorAD,igorad2003@yahoo.co.uk |   
//|            http://finance.groups.yahoo.com/group/TrendLaboratory |                                      
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, Forex-TSD.com "
#property link      "http://www.forex-tsd.com/"
//----
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Blue
#property indicator_color2 Aqua
#property indicator_color3 Red
#property indicator_color4 Magenta
//---- input parameters
extern int Length=3;
extern int MA_mode=1;
extern int Delta=15;
//---- indicator buffers
double UpBuffer1[];
double UpBuffer2[];
double DnBuffer1[];
double DnBuffer2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
  int init()
  {
   string short_name;
//---- indicator line
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(0,UpBuffer1);
   SetIndexBuffer(1,UpBuffer2);
   SetIndexBuffer(2,DnBuffer1);
   SetIndexBuffer(3,DnBuffer2);
//---- name for DataWindow and indicator subwindow label
   short_name="EMABands("+Length+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,"Up1");
   SetIndexLabel(1,"Up2");
   SetIndexLabel(2,"Dn1");
   SetIndexLabel(3,"Dn2");
//----
   SetIndexDrawBegin(0,Length);
   SetIndexDrawBegin(1,Length);
   SetIndexDrawBegin(2,Length);
   SetIndexDrawBegin(3,Length);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| EMABands_v1                                                      |
//+------------------------------------------------------------------+
int start()
  {
   int shift,limit, counted_bars=IndicatorCounted();
//----
   if(counted_bars > 0) limit=Bars-counted_bars;
   if(counted_bars < 0) return(0);
   if(counted_bars ==0) limit=Bars-Length-1;
//----
   for(shift=limit;shift>=0;shift--)
     {
      UpBuffer1[shift]=iMA(NULL,0,Length,0,MA_mode,PRICE_HIGH,shift);
      UpBuffer2[shift]=UpBuffer1[shift] + Delta*Point;
      DnBuffer1[shift]=iMA(NULL,0,Length,0,MA_mode,PRICE_LOW,shift);
      DnBuffer2[shift]=DnBuffer1[shift] - Delta*Point;
     }
   return(0);
  }
//+------------------------------------------------------------------+