//+------------------------------------------------------------------+
//|                                                            EVWMA |
//|                               Copyright © 2004, Poul_Trade_Forum |
//|                                                         Aborigen |
//|                                          http://forex.kbpauk.ru/ |
//+------------------------------------------------------------------+
#property copyright "Poul Trade Forum"
#property link      "http://forex.kbpauk.ru/"
//----
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 DeepPink
//----
extern int VolumeDivisor=1;
extern int N=100;
//----
double  ScaledVol=0,VolDiff=0;
double X[100],Y[100];
bool Violation=false;
//---- buffers
double EVWMA[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- indicator line
   SetIndexStyle(0,DRAW_LINE,EMPTY,2,DeepPink);
   SetIndexBuffer(0,EVWMA);
   SetIndexEmptyValue(0,0);
//---- name for DataWindow and indicator subwindow label
   short_name="EVWMA";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
//----
   SetIndexDrawBegin(0,1);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+1;

   for(int shift=limit; shift>=0;shift--)
     {
      ScaledVol=Volume[shift]/VolumeDivisor;
      VolDiff=N-ScaledVol;
      if(VolDiff<0 && Violation==false) Violation=true;
      if(Violation==true) EVWMA[shift]=EVWMA[shift+1];
      else EVWMA[shift]=(VolDiff*EVWMA[shift+1]+ScaledVol*Close[shift])/N;
      Violation=false;
      //----
     }
   return(0);
  }
//+------------------------------------------------------------------+
