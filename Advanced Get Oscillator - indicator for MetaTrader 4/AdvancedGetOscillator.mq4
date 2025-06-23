//+------------------------------------------------------------------+
//|                                      Advanced Get Oscillator.mq4 |
//|                      Copyright © 2007, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
//----
#property indicator_separate_window
#property indicator_buffers 3
//----
#property indicator_color1 SlateBlue
#property indicator_color2 White
#property indicator_color3 White
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(5);
//---- 3 additional buffers are used for counting.
   SetIndexBuffer(3, ExtMapBuffer4);
   SetIndexBuffer(4, ExtMapBuffer5);
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,ExtMapBuffer3);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
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
//----
//---- 
   int limit;
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//----
   for(int i=0; i<limit; i++)
      ExtMapBuffer4[i]=iMA(NULL,0,5,0,MODE_SMA,PRICE_MEDIAN ,i);
   for(i=0; i<limit; i++)
      ExtMapBuffer5[i]=iMA(NULL,0,34,0,MODE_SMA,PRICE_MEDIAN,i);
   for(i=0; i<limit; i++)
      ExtMapBuffer1[i]=ExtMapBuffer4[i]-ExtMapBuffer5[i];
   double pr=2.0/(38+1);
   int pos=Bars-2;
   if (counted_bars>2) pos=Bars-counted_bars-1;
   while(pos>=0)
     {
      if((pos==Bars-2))
        { ExtMapBuffer2[pos+1]=ExtMapBuffer1[pos+1];
         ExtMapBuffer3[pos+1]=ExtMapBuffer1[pos+1];
        }
      if (ExtMapBuffer1[pos]>=0)
        {
         ExtMapBuffer2[pos]=ExtMapBuffer1[pos]*pr+ExtMapBuffer2[pos+1]*(1-pr);
         ExtMapBuffer3[pos]=ExtMapBuffer3[pos+1];
        }
      else
        {
         ExtMapBuffer2[pos]=ExtMapBuffer2[pos+1];
         ExtMapBuffer3[pos]=ExtMapBuffer1[pos]*pr+ExtMapBuffer3[pos+1]*(1-pr);
        }
      pos--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+