//+------------------------------------------------------------------+
//|                                                    ColorOsMA.mq4 |
//|                                                           duckfu |
//|                                         http://www.dopeness.org/ |
//+------------------------------------------------------------------+
#property  copyright "duckfu"
#property  link      "http://www.dopeness.org/"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 2
#property  indicator_color1  DodgerBlue
#property  indicator_color2  FireBrick
//---- indicator parameters
extern int FastEMA=8;
extern int SlowEMA=12;
extern int SignalSMA=9;
//---- indicator buffers
double OsMAUpBuffer[];
double OsMADownBuffer[];
double OsMABuffer[];
double MACDBuffer[];
double SignalBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- 2 additional buffers are used for counting.
   IndicatorBuffers(5);
//---- drawing settings
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,2);
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID,2);
   SetIndexDrawBegin(0,SignalSMA);
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS)+2);
//---- 3 indicator buffers mapping
   SetIndexBuffer(0,OsMAUpBuffer);
   SetIndexBuffer(1,OsMADownBuffer);
   SetIndexBuffer(2,OsMABuffer);
   SetIndexBuffer(3,MACDBuffer);
   SetIndexBuffer(4,SignalBuffer);

//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("ColorOsMA("+FastEMA+","+SlowEMA+","+SignalSMA+")");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Moving Average of Oscillator                                     |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+MathMax(FastEMA,SlowEMA);

//---- macd counted in the 1-st additional buffer
   for(int i=0; i<limit; i++)
     {
      MACDBuffer[i]=iMA(NULL,0,FastEMA,0,MODE_EMA,PRICE_CLOSE,i)-iMA(NULL,0,SlowEMA,0,MODE_EMA,PRICE_CLOSE,i);
     }
//---- signal line counted in the 2-nd additional buffer
   for(i=0; i<limit; i++)
     {
      SignalBuffer[i]=iMAOnArray(MACDBuffer,0,SignalSMA,0,MODE_SMA,i);
     }
//---- main loop
   for(i=0; i<limit; i++)
     {
      OsMABuffer[i]=(MACDBuffer[i]-SignalBuffer[i]);
      if(OsMABuffer[i]>0)
        {
         OsMAUpBuffer[i]=OsMABuffer[i];
         OsMADownBuffer[i]=0;
        }
      else if(OsMABuffer[i]<0)
        {
         OsMADownBuffer[i]=OsMABuffer[i];
         OsMAUpBuffer[i]=0;
        }
      else
        {
         OsMAUpBuffer[i]=0;
         OsMADownBuffer[i]=0;
        }
     }
//---- done
   return(0);
  }
//+------------------------------------------------------------------+
