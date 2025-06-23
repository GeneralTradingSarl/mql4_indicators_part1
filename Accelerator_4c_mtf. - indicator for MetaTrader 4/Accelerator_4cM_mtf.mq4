//+------------------------------------------------------------------+
//|                                                Accelerator_4c_mtf|
//|                      Copyright © 2005, MetaQuotes Software Corp. |
//|                                     mtf 2007_ForexTSD  keris ki  |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2005, MetaQuotes Software Corp."
#property  link      "http://www.metaquotes.net/"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 5
#property  indicator_color1  CLR_NONE
#property  indicator_color2  LimeGreen
#property  indicator_color3  Red
#property  indicator_color4  Lime
#property  indicator_color5  Red
//----
#property indicator_width3 2
#property indicator_width4 2
//----
extern int TimeFrame=30;
extern int MA1_Period  =7;
extern int MA2_Period  =14;
extern int MA3_Period  =3;
extern int MA_Mode=MODE_SMA;
extern int MA_Price= PRICE_MEDIAN;
extern int SigLineShift =0;
extern int MaxBarsToCount  =15000;
//----
extern string  TimeFrames="M1;5,15,30,60H1;240H4;1440D1;10080W1;43200MN|0-CurrentTF";
extern string  note_MA_Method_Price="SMA0 EMA1 SMMA2 LWMA3||0O,1C 2H3L,4Md 5Tp 6WghC: Md(HL/2)4,Tp(HLC/3)5,Wgh(HLCC/4)6";
extern string  defaults="5,34,5; SMA,PRICE_MEDIAN";
//---- indicator buffers
double     ExtBuffer0[];
double     ExtBuffer1[];
double     ExtBuffer2[];
double     ExtBuffer3[];
double     ExtBuffer4[];
double     ExtBuffer11[];
double     ExtBuffer21[];
double     ExtBuffer5[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- 2 additional buffers are used for counting.
   IndicatorBuffers(8);
//---- drawing settings
   SetIndexStyle(0,DRAW_LINE);
   SetIndexShift(0,SigLineShift);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexStyle(3,DRAW_HISTOGRAM);
   SetIndexStyle(4,DRAW_HISTOGRAM);
   //
   IndicatorDigits(Digits+2);
   SetIndexDrawBegin(0,38);
   SetIndexDrawBegin(1,38);
   SetIndexDrawBegin(2,38);
   SetIndexDrawBegin(3,38);
   SetIndexDrawBegin(4,38);
   SetIndexDrawBegin(5,38);
   SetIndexDrawBegin(6,38);
//---- 4 indicator buffers mapping
   SetIndexBuffer(0,ExtBuffer0);
   SetIndexBuffer(1,ExtBuffer1);
   SetIndexBuffer(2,ExtBuffer2);
   SetIndexBuffer(3,ExtBuffer11);
   SetIndexBuffer(4,ExtBuffer21);
   SetIndexBuffer(5,ExtBuffer3);
   SetIndexBuffer(6,ExtBuffer4);
   SetIndexBuffer(7,ExtBuffer5);
//---- name for DataWindow and indicator subwindow label
   SetIndexLabel(0,NULL);
   SetIndexLabel(1,NULL);
   SetIndexLabel(2,NULL);
   SetIndexLabel(3,NULL);
   SetIndexLabel(4,NULL);
   SetIndexLabel(5,NULL);
   SetIndexLabel(6,NULL);
//----
   switch(TimeFrame)
     {
      case 1: string TimeFrameStr="M1";  break;
      case 5     :   TimeFrameStr="M5";  break;
      case 15    :   TimeFrameStr="M15"; break;
      case 30    :   TimeFrameStr="M30"; break;
      case 60    :   TimeFrameStr="H1";  break;
      case 240   :   TimeFrameStr="H4";  break;
      case 1440  :   TimeFrameStr="D1";  break;
      case 10080 :   TimeFrameStr="W1";  break;
      case 43200 :   TimeFrameStr="MN1"; break;
      default :    TimeFrameStr  ="TF 0";
     }
   IndicatorShortName("ACC ["+TimeFrameStr+"]");
//----
   if (TimeFrame<Period()) TimeFrame=Period();
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Accelerator/Decelerator Oscillator                               |
//+------------------------------------------------------------------+
int start()
  {
   double prev,current;
   datetime TimeArray[],TimeArray1[];
   int    i,y=0;
   // Plot defined time frame on to current time frame
   ArrayCopySeries(TimeArray, MODE_TIME,Symbol(),TimeFrame);
   ArrayCopySeries(TimeArray1,MODE_TIME,Symbol(),TimeFrame);
//----
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+1;   
//----
   for(i=0,y=0;i<limit;i++)
     {
      if (y<ArraySize(TimeArray)){ if (Time[i]<TimeArray[y]) y++;}
      ExtBuffer3[i]=iMA(NULL,TimeFrame,MA1_Period,0,MA_Mode,MA_Price,y)
      -  iMA(NULL,TimeFrame,MA2_Period,0,MA_Mode,MA_Price,y);
      ExtBuffer5[y]=ExtBuffer3[i];
     }
//---- signal line counted in the 2-nd additional buffer
   for(y=0,i=0; i<limit; i++)
     {
      if (y<ArraySize(TimeArray1)){ if (Time[i]<TimeArray1[y]) y++;}
      ExtBuffer4[i]=iMAOnArray(ExtBuffer5,0,MA3_Period,0,MA_Mode,y);
     }
//---- dispatch values between 2 buffers
   bool up=true;
   for(i=limit-1; i>=0; i--)
     {
      current=ExtBuffer3[i]-ExtBuffer4[i];
      prev=ExtBuffer3[i+1]-ExtBuffer4[i+1];
//----
      if(current>prev) up=true;
      if(current<prev) up=false;
      if(!up)
        {
         if(current>0)
           {
            ExtBuffer1 [i]=current;
            ExtBuffer11[i]=0.0;
            ExtBuffer2 [i]=0.0;
            ExtBuffer21[i]=0.0;
           }
         else
           {
            ExtBuffer21[i]=current;
            ExtBuffer1 [i]=0.0;
            ExtBuffer2 [i]=0.0;
            ExtBuffer11[i]=0.0;
           }
        }
      else
        {
         if  (current>0)
           {
            ExtBuffer11[i]=current;
            ExtBuffer2 [i]=0.0;
            ExtBuffer1 [i]=0.0;
            ExtBuffer21[i]=0.0;
           }
         else
           {
            ExtBuffer2 [i]=current;
            ExtBuffer11[i]=0.0;
            ExtBuffer1 [i]=0.0;
            ExtBuffer21[i]=0.0;
           }
        }

      ExtBuffer0[i]=current;
     }
//---- done
   return(0);
  }
//+------------------------------------------------------------------+

