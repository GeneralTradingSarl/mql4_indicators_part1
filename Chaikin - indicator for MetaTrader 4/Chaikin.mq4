//+------------------------------------------------------------------+
//|                                                      Chaikin.mq4 |
//|                      Copyright © 2006, Yury V. Reshetov          |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2006, Yury V. Reshetov ICQ: 282715499"
#property  link      "http://antigedel.boom.ru/"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 1
#property  indicator_color1  clrSilver
//---- indicator parameters
extern int FastEMA=12;
extern int SlowEMA=26;
extern int SignalSMA=9;
//---- indicator buffers
double     ind_buffer1[];
double     ind_buffer2[];
double     ind_buffer3[];
double     ind_buffer4[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- 2 additional buffers are used for counting.
   IndicatorBuffers(4);
//---- drawing settings
   SetIndexStyle(0,DRAW_LINE);
   SetIndexDrawBegin(0,SignalSMA);
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS)+2);
//---- 3 indicator buffers mapping
   SetIndexBuffer(0,ind_buffer1);
   SetIndexBuffer(1,ind_buffer2);
   SetIndexBuffer(2,ind_buffer3);
   SetIndexBuffer(3,ind_buffer4);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("Chaikin");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Moving Average of Oscillator                                     |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   if(counted_bars==0) limit--;
//---- macd counted in the 1-st additional buffer
   for(int i=0; i<limit; i++)
      ind_buffer2[i]=iOBV(NULL,0,PRICE_CLOSE,i);
//---- signal line counted in the 2-nd additional buffer
   for(i=0; i<limit; i++)
     {
      ind_buffer3[i]=iMAOnArray(ind_buffer2,Bars,10,0,MODE_SMA,i);
      ind_buffer4[i]=iMAOnArray(ind_buffer2,Bars,3,0,MODE_SMA,i);
     }
//---- main loop
   for(i=0; i<limit; i++)
      ind_buffer1[i]=ind_buffer2[i]-ind_buffer3[i];
//---- done
   return(0);
  }
//+------------------------------------------------------------------+
