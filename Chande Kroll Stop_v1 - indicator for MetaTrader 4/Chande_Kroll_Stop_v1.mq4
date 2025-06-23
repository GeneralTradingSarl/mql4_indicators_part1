//+------------------------------------------------------------------+
//|                                         Chande_Kroll_Stop_v1.mq4 |
//|                                  Copyright © 2006, Forex-TSD.com |
//|                         Written by IgorAD,igorad2003@yahoo.co.uk |   
//|            http://finance.groups.yahoo.com/group/TrendLaboratory |                                      
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, Forex-TSD.com "
#property link      "http://www.forex-tsd.com/"
//----
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red
//---- input parameters
extern int    Length    =20;
extern int    ATRPeriod =10;
extern double Kv        =3;
//---- indicator buffers
double UpTrend[];
double DnTrend[];
double smin[];
double smax[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
  int init()
  {
   string short_name;
//---- indicator line
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   IndicatorBuffers(4);
   SetIndexBuffer(0,UpTrend);
   SetIndexBuffer(1,DnTrend);
   SetIndexBuffer(2,smin);
   SetIndexBuffer(3,smax);
//---- name for DataWindow and indicator subwindow label
   short_name="Chande Kroll Stop("+Length+","+ATRPeriod+","+Kv+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,"UpTrend");
   SetIndexLabel(1,"DnTrend");
//----
   SetIndexDrawBegin(0,Length);
   SetIndexDrawBegin(1,Length);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Chande_Kroll_Stop_v1                                             |
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
      smin[shift]=High[Highest(NULL,0,MODE_HIGH,ATRPeriod,shift)] - Kv*iATR(NULL,0,ATRPeriod,shift);
      smax[shift]=Low [Lowest (NULL,0,MODE_LOW ,ATRPeriod,shift)] + Kv*iATR(NULL,0,ATRPeriod,shift);
      //
      UpTrend[shift]=-10000000;
      DnTrend[shift]= 10000000;
//----
      for(int i=Length-1;i>=0;i--)
        {
         UpTrend[shift]=MathMax( UpTrend[shift], smin[shift+i]);
         DnTrend[shift]=MathMin( DnTrend[shift], smax[shift+i]);
        }
     }
   return(0);
  }
//+------------------------------------------------------------------+