//+------------------------------------------------------------------+
//|                                                 Donchian Channel |
//+------------------------------------------------------------------+

#property  copyright "ps"
#property  link      ""
//---- indicator settings
#property  indicator_chart_window
#property  indicator_buffers 2
#property  indicator_color1  Gold
#property  indicator_color2  Gold
#property  indicator_width1  1
#property  indicator_width2  1

//---- indicator parameters
extern int periods=20;

//---- indicator buffers
double     upper[];
double     lower[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- drawing settings
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   
//---- indicator buffers mapping
   SetIndexBuffer(0,upper);
   SetIndexBuffer(1,lower);
   
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("Donchian Channel("+periods+")");
   SetIndexLabel(0,"Upper");
   SetIndexLabel(1,"Lower");
   
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| now do the dance.                           |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int counted_bars=IndicatorCounted();
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;

//---- calculate values
   for(int i=0; i<limit; i++) {
      upper[i]=iHigh(Symbol(),Period(),iHighest(Symbol(),Period(),MODE_HIGH,periods,i));
      lower[i]=iLow(Symbol(),Period(),iLowest(Symbol(),Period(),MODE_LOW,periods,i));
   }
   
   return(0);
  }
  