//+------------------------------------------------------------------+
//|                                                   18_28Cross.mq4 |
//|                      Copyright © 2006, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
//----
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red
//----
double CrossUp[];
double CrossDown[];
extern int FasterMode=1; //0=sma, 1=ema, 2=smma, 3=lwma
extern int FasterMA  =18;
extern int SlowerMode=1; //0=sma, 1=ema, 2=smma, 3=lwma
extern int SlowerMA  =28;
extern int SoundAlert=1; // 0 = disabled
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_ARROW,EMPTY);
   SetIndexArrow(0,233);
   SetIndexBuffer(0,CrossUp);
   SetIndexStyle(1,DRAW_ARROW,EMPTY);
   SetIndexArrow(1,234);
   SetIndexBuffer(1,CrossDown);
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
   int limit,i,counter;
   double fasterMAnow,slowerMAnow,fasterMAprevious,slowerMAprevious,fasterMAafter,slowerMAafter;
   double Range,AvgRange;
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+MathMax(9,MathMax(FasterMA,SlowerMA));
//----
   for(i=0; i<=limit; i++)
     {
      counter=i;
      Range=0;
      AvgRange=0;
      for(counter=i;counter<=i+9;counter++)
        {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
        }
      Range=AvgRange/10;
      fasterMAnow=iMA(NULL,0,FasterMA,0,FasterMode,PRICE_CLOSE,i);
      fasterMAprevious=iMA(NULL,0,FasterMA,0,FasterMode,PRICE_CLOSE,i+1);
      fasterMAafter=iMA(NULL,0,FasterMA,0,FasterMode,PRICE_CLOSE,i-1);
      slowerMAnow=iMA(NULL,0,SlowerMA,0,SlowerMode,PRICE_CLOSE,i);
      slowerMAprevious=iMA(NULL,0,SlowerMA,0,SlowerMode,PRICE_CLOSE,i+1);
      slowerMAafter=iMA(NULL,0,SlowerMA,0,SlowerMode,PRICE_CLOSE,i-1);
      //----
      if((fasterMAnow>slowerMAnow) && (fasterMAprevious<slowerMAprevious) && (fasterMAafter>slowerMAafter))
        {
         CrossUp[i]=Low[i]-Range*0.5;
        }
      else if((fasterMAnow<slowerMAnow) && (fasterMAprevious>slowerMAprevious) && (fasterMAafter<slowerMAafter))
        {
         CrossDown[i]=High[i]+Range*0.5;
        }
     }
//----     
   return(0);
  }
//+------------------------------------------------------------------+
