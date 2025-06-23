//+------------------------------------------------------------------+
//|                                                   5_34_5.mq4     |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "Conversion from MQII perky_z@yahoo.com"
//----
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 LightBlue
#property indicator_color2 Red
//---- input parameters
int shift=0, loopbegin=0, prevbars=0;
double FastMA=0, SlowMA=0, prev=0;
bool first=true;
//---- buffers
double TrendBuffer[];
double LoBuffer[];
double Ma534=0, Ma534_1=0,Ma534_2=0,Ma534_3=0,Ma534_4=0,Ma534_5=0 ;
int CB=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- 3 additional buffers are used for counting.
   IndicatorBuffers(3);
//---- indicator buffers
   SetIndexBuffer(0,TrendBuffer);
   SetIndexBuffer(1,LoBuffer);
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,1,LightBlue);
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,1,Red);
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS));
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("5_34_5");
   //SetIndexDrawBegin(0,TrendBuffer);
   //SetIndexDrawBegin(1,LoBuffer);
   return(0);
  }
//+------------------------------------------------------------------+
//| Average Directional Movement Index                               |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit--;
      
   for(CB=limit;CB>=0; CB--)
     {
      // iMA(NULL,0,55,0,MODE_EMA,PRICE_CLOSE,0)
      Ma534=iMA(NULL,0,5,0,MODE_SMA, PRICE_MEDIAN,CB)-iMA(NULL,0,34,0,MODE_SMA,PRICE_MEDIAN,CB);
      //if CB>=1 then 
      Ma534_1=iMA(NULL,0,5,0,MODE_SMA,PRICE_MEDIAN,CB)-iMA(NULL,0,34,0,MODE_SMA,PRICE_MEDIAN,CB);
      //if CB>=2 then 
      Ma534_2=iMA(NULL,0,5,0,MODE_SMA,PRICE_MEDIAN,CB-1)-iMA(NULL,0,34,0,MODE_SMA,PRICE_MEDIAN,CB-1);
      //if CB>=3 then 
      Ma534_3=iMA(NULL,0,5,0,MODE_SMA,PRICE_MEDIAN,CB-2)-iMA(NULL,0,34,0,MODE_SMA,PRICE_MEDIAN,CB-2);
      //if CB>=4 then 
      Ma534_4=iMA(NULL,0,5,0,MODE_SMA,PRICE_MEDIAN,CB-3)-iMA(NULL,0,34,0,MODE_SMA,PRICE_MEDIAN,CB-3);
      //if CB>=5 then 
      Ma534_5=iMA(NULL,0,5,0,MODE_SMA,PRICE_MEDIAN,CB-4)-iMA(NULL,0,34,0,MODE_SMA,PRICE_MEDIAN,CB-4);
      //SetIndexValue(CB,Ma534);
      //if CB>5 then
      //SetIndexValue2(CB,(Ma534_1+Ma534_3+Ma534_2+Ma534_4+Ma534_5)/5);
      //Ma5345=iMA(0,MODE_SMA,CB);
      //SetIndexValue2(CB,Ma5345);
      TrendBuffer[CB]=Ma534;
      LoBuffer[CB]=((Ma534_1+Ma534_3+Ma534_2+Ma534_4+Ma534_5)/5);
     }
   return(0);
  }
       // prevent to previous bars recounting
//+------------------------------------------------------------------+