//+------------------------------------------------------------------+
//|                             Custom Aroon_Horn_Oscillator_v1.mq4  |
//|                                           www.forex-tsd.com  ik  |
//|                                         Has corrected - Ramdass  |
//+------------------------------------------------------------------+
#property  copyright "rafcamara"
#property  link      "rafcamara@yahoo.com   www.forex-tsd.com"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 4
#property  indicator_color1  DodgerBlue
#property  indicator_color2  Red
#property  indicator_color3  Snow
#property  indicator_color4  Green
#property indicator_style1 0
#property indicator_style2 0
#property indicator_style3 0
#property indicator_style4 0
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 1
#property indicator_width4 1
//---- indicator parameters
extern int AroonPeriod=10;
extern int Filter=50;
extern int CountBars=500;
//---- indicator buffers
double     ind_buffer1[];
double     ind_buffer2[];
double     ind_buffer3[];
double     HighBarBuffer[];
double     LowBarBuffer[];
double     ArOscBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- additional buffers are used for counting.
   IndicatorBuffers(6);
   SetIndexBuffer(4,HighBarBuffer);
   SetIndexBuffer(5,LowBarBuffer);
   SetIndexBuffer(3,ArOscBuffer);
   SetIndexBuffer(0,ind_buffer1);
   SetIndexBuffer(1,ind_buffer2);
   SetIndexBuffer(2,ind_buffer3);
//---- drawing settings
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexStyle(3,DRAW_LINE);
//----
   IndicatorDigits(0);
//-- indicator buffers mapping
   SetIndexBuffer(0,ind_buffer1);
   SetIndexBuffer(1,ind_buffer2);
   SetIndexBuffer(2,ind_buffer3);

   SetIndexLabel(0,"AroonUp("+AroonPeriod+"("+Filter+")");
   SetIndexLabel(1,"AroonDown("+AroonPeriod+"("+Filter+")");
   SetIndexLabel(2,"AroonOsc("+AroonPeriod+"("+Filter+")");

//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("AroonOsc_v1 ("+AroonPeriod+"("+Filter+")");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Aroon Oscilator                                                  |
//+------------------------------------------------------------------+
int start()
  {
   double   ArOsc,HighBar=0,LowBar=0;
   int      ArPer;
   int      limit,i;
//----
   ArPer=AroonPeriod;
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1;

//----Calculation---------------------------
   for(i=0; i<limit; i++)
     {
      HighBarBuffer[i]=Highest(NULL,0, MODE_HIGH, ArPer, i);    //Periods from HH  	   
      LowBarBuffer[i]=Lowest(NULL, 0, MODE_LOW, ArPer, i);      //Periods from LL
      ArOscBuffer[i]=100*(LowBarBuffer[i]-HighBarBuffer[i])/ArPer;      //Short formulation
     }
//---- dispatch values between 2 buffers
   for(i=limit-1; i>=0; i--)
     {
      ArOsc=ArOscBuffer[i];
      if(ArOsc>Filter)
        {
         ind_buffer1[i]=ArOsc;
         ind_buffer2[i]=0.0;
         ind_buffer3[i]=0.0;
        }
      if(ArOsc<-Filter)
        {
         ind_buffer1[i]=0.0;
         ind_buffer2[i]=ArOsc;
         ind_buffer3[i]=0.0;
        }
      if(ArOsc<=Filter && ArOsc>=-Filter)
        {
         ind_buffer1[i]=0.0;
         ind_buffer2[i]=0.0;
         ind_buffer3[i]=ArOsc;
        }
     }
//---- done
   return(0);
  }
//+------------------------------------------------------------------+
