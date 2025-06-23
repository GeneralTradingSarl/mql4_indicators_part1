//+------------------------------------------------------------------+
//|                                                      Awesome_Signal.mq4 |
//|                      Copyright © 2005, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+

// Расширен и дополнен Asystem2000
// Расширение: строится сигнальная линия
// Дополнения:
// 1. Введена возможность настройки быстрой, медленной и сигнальной линий
// 2. Введена возможность настройки смещения сигнальной линии

#property  copyright "Copyright © 2005, MetaQuotes Software Corp."
#property  link      "http://www.metaquotes.net/"
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

//---- indicator buffers
double     ExtBuffer0[];
double     ExtBuffer1[];
double     ExtBuffer2[];
double     SignalBuffer[];
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
    SetIndexShift( 3, SignalShift); 
   
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
   int    limit;
   int    counted_bars=IndicatorCounted();
   double prev,current;
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   if(counted_bars==0) limit--;
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
//---- done
   return(0);
  }
//+------------------------------------------------------------------+

