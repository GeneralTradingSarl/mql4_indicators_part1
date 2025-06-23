//+------------------------------------------------------------------+
//|                                         Custom Aroon Up & Dn.mq4 |
//|                                                        rafcamara |
//|                                                                  |
//+------------------------------------------------------------------+
#property  copyright "rafcamara"
#property  link      "rafcamara@yahoo.com"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 2
#property  indicator_color1  DodgerBlue
#property  indicator_color2  Red
//---- indicator parameters
extern int AroonPeriod=14;
//---- indicator buffers
double     AroonUpBuffer[];
double     AroonDnBuffer[];
double     HighBarBuffer[];
double     LowBarBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- 2 additional buffers are used for counting.
   IndicatorBuffers(4);
   SetIndexBuffer(0,AroonUpBuffer);
   SetIndexBuffer(1,AroonDnBuffer);
   SetIndexBuffer(2,HighBarBuffer);
   SetIndexBuffer(3,LowBarBuffer);
//---- drawing settings
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,1);
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,1);
   SetIndexDrawBegin(0,200);
   SetIndexDrawBegin(1,200);
   IndicatorDigits(1);
//---- indicator buffers mapping
   if(!SetIndexBuffer(0,AroonUpBuffer) && !SetIndexBuffer(1,AroonDnBuffer)
      && !SetIndexBuffer(2,HighBarBuffer) && !SetIndexBuffer(3,LowBarBuffer))
      Print("cannot set indicator buffers!");
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("Aroon Up & Dn("+(string)AroonPeriod+")");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Aroon Up & Dn                                                    |
//+------------------------------------------------------------------+
int start()
  {
   int      ArPer,limit,i;
   double   UpBarDif,DnBarDif;
   int      counted_bars=IndicatorCounted();
   ArPer=AroonPeriod;                  //Short name
//---- check for possible errors
   if(counted_bars<0) return(-1);
   if(AroonPeriod<1) return(-1);
//---- initial zero
   if(counted_bars<1)
     {
      for(i=1;i<=ArPer;i++) HighBarBuffer[Bars-i]=0.0;
      for(i=1;i<=ArPer;i++) LowBarBuffer[Bars-i]=0.0;
      for(i=1;i<=ArPer;i++) AroonUpBuffer[Bars-i]=0.0;
      for(i=1;i<=ArPer;i++) AroonDnBuffer[Bars-i]=0.0;
     }
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//----Calculation---------------------------
   for(i=0; i<limit; i++)
     {
      HighBarBuffer[i]=Highest(NULL,0,MODE_HIGH,ArPer,i);   //Periods from HH  	   
      LowBarBuffer[i]=Lowest(NULL,0,MODE_LOW,ArPer,i);        //Periods from LL
      UpBarDif=i-HighBarBuffer[i];                          //Period substraction
      DnBarDif=i-LowBarBuffer[i];                             //Period substraction
      AroonUpBuffer[i]=100+(100/ArPer)*(UpBarDif);            //Adjusted Aroon Up
      AroonDnBuffer[i]=100+(100/ArPer)*(DnBarDif);            //Adjusted Aroon Down
     }
   return(0);
  }
//+---------------------------------------------------------------+
