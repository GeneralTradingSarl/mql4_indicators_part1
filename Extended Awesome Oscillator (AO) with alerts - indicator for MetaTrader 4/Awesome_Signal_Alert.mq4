//+------------------------------------------------------------------+
//|                                               Awesome_Signal.mq4 |
//|                      Copyright © 2005, MetaQuotes Software Corp. |
//|                                         http://www.fxservice.eu/ |
//|                                             contact@fxservice.eu |
//+------------------------------------------------------------------+

#property  copyright "Kalenzo contact@fxservice.eu"
#property  link      "http://www.fxservice.eu/"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 4
#property  indicator_color1  Black
#property  indicator_color2  Green
#property  indicator_color3  Red
#property  indicator_color4  Gold

extern int Fast = 5;
extern int Slow = 34;
extern int Signal=5;
extern int SignalShift=0;
extern bool EnableSignalLineAlert=true;
extern bool EnableZeroLineCrossoverAlert=true;

//---- indicator buffers
double     ExtBuffer0[];
double     ExtBuffer1[];
double     ExtBuffer2[];
double     SignalBuffer[];
int a=0,b=0,c=0,d=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- drawing settings
   SetIndexStyle(0,DRAW_NONE);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexStyle(3,DRAW_LINE,STYLE_SOLID);
   SetIndexShift(3,SignalShift);

   IndicatorDigits(Digits+1);
   SetIndexDrawBegin(0,34);
   SetIndexDrawBegin(1,34);
   SetIndexDrawBegin(2,34);
   SetIndexDrawBegin(3,34);

//---- 3 indicator buffers mapping
   SetIndexBuffer(0,ExtBuffer0);
   SetIndexBuffer(1,ExtBuffer1);
   SetIndexBuffer(2,ExtBuffer2);
   SetIndexBuffer(3,SignalBuffer);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("AO");
   SetIndexLabel(1,NULL);
   SetIndexLabel(2,NULL);
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Awesome Oscillator                                               |
//+------------------------------------------------------------------+
int start()
  {
   double prev,current;
//---- last counted bar will be recounted

   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+1;

//---- macd
   for(int i=0; i<limit; i++)
      ExtBuffer0[i]=iMA(NULL,0,Fast,0,MODE_SMA,PRICE_MEDIAN,i)-iMA(NULL,0,Slow,0,MODE_SMA,PRICE_MEDIAN,i);
//---- dispatch values between 2 buffers
   bool up=true;
   for(i=limit-1; i>=0; i--)
     {
      current=ExtBuffer0[i];
      prev=ExtBuffer0[i+1];
      if(current>prev) up=true;
      if(current<prev) up=false;
      if(!up)
        {
         ExtBuffer2[i]=current;
         ExtBuffer1[i]=0.0;
        }
      else
        {
         ExtBuffer1[i]=current;
         ExtBuffer2[i]=0.0;
        }
     }
// ----- Draw signal
   for(i=0; i<limit; i++)
      SignalBuffer[i]=iMAOnArray(ExtBuffer0,Bars,Signal,0,MODE_SMA,i);

   if(EnableSignalLineAlert)
     {
      if(ExtBuffer0[0]<SignalBuffer[0] && ExtBuffer0[1]>=SignalBuffer[1] && Bars>a)
        {
         Alert(Symbol()+" Period "+Period()+" AO CROSSED Signal (SELL)");
         a=Bars;
        }

      if(ExtBuffer0[0]>SignalBuffer[0] && ExtBuffer0[1]<=SignalBuffer[1] && Bars>b)
        {
         Alert(Symbol()+" Period "+Period()+" AO CROSSED Signal (BUY)");
         b=Bars;
        }
     }

   if(EnableZeroLineCrossoverAlert)
     {
      if(ExtBuffer0[0]<0 && ExtBuffer0[1]>=0 && Bars>c)
        {
         Alert(Symbol()+" Period "+Period()+" AO CROSSED ZERO LINE (SELL)");
         c=Bars;
        }

      if(ExtBuffer0[0]>0 && ExtBuffer0[1]<=0 && Bars>d)
        {
         Alert(Symbol()+" Period "+Period()+" AO CROSSED ZERO LINE (BUY)");
         d=Bars;
        }
     }

//---- done
   return(0);
  }
//+------------------------------------------------------------------+
