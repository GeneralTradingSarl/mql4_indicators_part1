//+------------------------------------------------------------------+
//|                                           Combined MA Signal.mq4 |
//|                                                  Edi Dimitrovski |
//|                                              http://maktrade.org |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""

#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 LightSeaGreen
#property indicator_color2 Silver
#property indicator_color3 Green
#property indicator_color4 Red
#property indicator_width3 1
#property indicator_width4 1
//---- input parameters
extern int       Signal=8;
extern bool      Slow=0;
extern bool      Repaint=0;
extern double    FilterPoints=8;
//---- indicator buffers
double ExtSilverBuffer[];
double ExtGreenBuffer[];
double ExtBlueBuffer[];
double ExtRedBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- drawing settings
//----
   SetIndexDrawBegin(0,Signal);
   SetIndexDrawBegin(1,Signal);
   SetIndexDrawBegin(2,Signal);
   SetIndexDrawBegin(3,Signal);
   IndicatorDigits(Digits+1);
//---- indicator style
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexStyle(2,DRAW_ARROW);
   SetIndexStyle(3,DRAW_ARROW);
   SetIndexArrow(2,241);
   SetIndexArrow(3,242);
//---- indicator buffers mapping
   SetIndexBuffer(0,ExtSilverBuffer);
   SetIndexBuffer(1,ExtGreenBuffer);
   SetIndexBuffer(2,ExtBlueBuffer);
   SetIndexBuffer(3,ExtRedBuffer);
   SetIndexEmptyValue(2,0.0);
   SetIndexEmptyValue(3,0.0);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("CMA("+Signal+","+Slow+","+Repaint+")");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Moving Average of Oscillator                                     |
//+------------------------------------------------------------------+
int start()
  {
   int count, limit;
   double dif,buf1,buf2;
   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//---- counted 2 buffers
   for(int i=0; i<limit; i++)
    {
     ExtGreenBuffer[i]=0.0;
     ExtSilverBuffer[i]=0.0;
     buf1=0;
     buf2=0;
     count=Signal;
     while(count>0)
      {
       dif=
          iMA(NULL,0,(count*2),0,3,0,i)
         -iMA(NULL,0,(count*3),0,3,4,i)
         +iMA(NULL,0,(count*2),0,3,4,i)
         -iMA(NULL,0,(count*3),0,3,1,i);
       if(count>=Signal/2)ExtGreenBuffer[i]+=dif;
       if(dif!=0.0)dif/=(count+1)/2;
       if(count+1<=Signal)ExtSilverBuffer[i]+=dif;
       count--;
      }
    }
//---- counted 2 additional buffers
   for(i=0; i<limit; i++)
    {
     if ((ExtGreenBuffer[i]>ExtGreenBuffer[i+1] || ExtGreenBuffer[i]>0.0)
      && ExtSilverBuffer[i]>ExtSilverBuffer[i+1]+Point*FilterPoints && 
          (ExtSilverBuffer[i]>0.0 || !Slow) && 
           (!(ExtRedBuffer[i]<0.0)
             || Repaint)) ExtBlueBuffer[i]=2*Point;
     else if ((ExtGreenBuffer[i]<ExtGreenBuffer[i+1] || ExtGreenBuffer[i]<0.0)
      && ExtSilverBuffer[i]+Point*FilterPoints<ExtSilverBuffer[i+1] && 
          (ExtSilverBuffer[i]<0.0 || !Slow) && 
           (!(ExtBlueBuffer[i]>0.0)
             || Repaint)) ExtRedBuffer[i]=-2*Point;
    }
//---- 
//---- done
   return(0);
  }
//+------------------------------------------------------------------+

