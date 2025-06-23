//+------------------------------------------------------------------+
//|                                       ADX BARS              .mq4 |
//|                                              Perky Aint no turkey|
//|                                                                  |
//+------------------------------------------------------------------+
#property  copyright "Perky"
#property  link      "Perky_z@yahoo.com"
//---- indicator settings
#property  indicator_chart_window
#property  indicator_buffers 2
#property  indicator_color1  Red
#property  indicator_color2  DodgerBlue
//---- indicator parameters
extern int ADXPeriod=14;
//---- indicator buffers
double     ind_buffer1[];
double     ind_buffer2[];
//double     ind_buffer3[];
double        HighBarBuffer[];
double        LowBarBuffer[];
double     ArOscBuffer[];
double b4plusdi,b4minusdi,nowplusdi,nowminusdi;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//----additional buffers are used for counting.
   IndicatorBuffers(5);
   SetIndexBuffer(2,HighBarBuffer);
   SetIndexBuffer(3,LowBarBuffer);
   SetIndexBuffer(4,ArOscBuffer);
//---- drawing settings
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,2);
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID,2);
//SetIndexDrawBegin(0,1500);
//SetIndexDrawBegin(1,1500);  
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS)+1);
//---- indicator buffers mapping
   SetIndexBuffer(0,ind_buffer1);
   SetIndexBuffer(1,ind_buffer2);
   SetIndexBuffer(2,HighBarBuffer);
   SetIndexBuffer(3,LowBarBuffer);
   SetIndexBuffer(4,ArOscBuffer);
//---- name for DataWindow and indicator subwindow label
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Aroon Oscilator                                                  |
//+------------------------------------------------------------------+
int start()
  {
   double   ArOsc=0;
   int      ArPer,i;
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+ADXPeriod;
//----Calculation---------------------------
   for(i=0; i<limit; i++)
     {
      // b4plusdi = iADX( NULL,0,14,PRICE_CLOSE,MODE_PLUSDI,i-1);
      nowplusdi=iADX(NULL,0,ADXPeriod,PRICE_CLOSE,MODE_PLUSDI,i);
      //b4minusdi = iADX(NULL,0,14,PRICE_CLOSE,MODE_MINUSDI,i-1);
      nowminusdi=iADX(NULL,0,ADXPeriod,PRICE_CLOSE,MODE_MINUSDI,i);
      //----
      if(nowminusdi>nowplusdi)
        {
         ind_buffer2[i]=Low[i];
         ind_buffer1[i]=High[i];
        }
      if(nowplusdi>nowminusdi)
        {
         ind_buffer1[i]=Low[i];
         ind_buffer2[i]=High[i];
        }
     }
//---- done
   return(0);
  }
//+------------------------------------------------------------------+
