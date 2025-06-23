//+------------------------------------------------------------------+
//|                                                    Envelopes.mq4 |
//|                      Copyright © 2005, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
//---- indicator settings
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red
//---- indicator parameters
extern int MA_Period=14;
extern int MA_Shift=0;
extern int MA_Method=0;
extern int Applied_Price=0;
extern double Deviation=0.1;
//---- indicator buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
//----
int ExtCountedBars=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   int    draw_begin;
   string short_name;
//---- drawing settings
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexShift(0,MA_Shift);
   SetIndexShift(1,MA_Shift);
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS));
   if(MA_Period<2) MA_Period=14;
   draw_begin=MA_Period-1;
//---- indicator short name
   IndicatorShortName("Env("+MA_Period+")");
   SetIndexLabel(0,"Env("+MA_Period+")Upper");
   SetIndexLabel(1,"Env("+MA_Period+")Lower");
   SetIndexDrawBegin(0,draw_begin);
   SetIndexDrawBegin(1,draw_begin);
//---- indicator buffers mapping
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexBuffer(1,ExtMapBuffer2);
   if(Deviation<0.1) Deviation=0.1;
   if(Deviation>100.0) Deviation=100.0;
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   if(Bars<=MA_Period) return(0);
   ExtCountedBars=IndicatorCounted();
//---- check for possible errors
   if (ExtCountedBars<0) return(-1);
//---- last counted bar will be recounted
   if (ExtCountedBars>0) ExtCountedBars--;
   limit=Bars-ExtCountedBars;
//---- EnvelopesM counted in the buffers
   for(int i=0; i<limit; i++)
     { 
      ExtMapBuffer1[i] = (1+Deviation/100)*iMA(NULL,0,MA_Period,0,MA_Method,Applied_Price,i);
      ExtMapBuffer2[i] = (1-Deviation/100)*iMA(NULL,0,MA_Period,0,MA_Method,Applied_Price,i);
     }
//---- done
   return(0);
  }
//+------------------------------------------------------------------+