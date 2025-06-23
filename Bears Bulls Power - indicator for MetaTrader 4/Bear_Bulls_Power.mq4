//+------------------------------------------------------------------+
//|                                             Bear_Bulls_Power.mq4 |
//|                              Copyright © 2006, Eng. Waddah Attar |
//|                                          waddahattar@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Waddah Attar"
#property link      "waddahattar@hotmail.com"
//----
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Green
#property indicator_color2 Red
#property indicator_level1 0.0
//----
extern int MyPeriod = 13;
//----
double ExtBuffer1[];
double ExtBuffer2[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexBuffer(0, ExtBuffer1);
   SetIndexStyle(0,DRAW_HISTOGRAM,0,2);
//----
   SetIndexBuffer(1, ExtBuffer2);
   SetIndexStyle(1,DRAW_HISTOGRAM,0,2);
//----   
   IndicatorShortName("Bear_Bulls_Power (" + MyPeriod + ") ");
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   double ma, pBears ,pBulls ,v;
   int i, limit;
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0) 
       return(-1);
   if(counted_bars > 0) 
       counted_bars--;
   limit = Bars - counted_bars; 
   for(i = 0; i < limit; i++)
     {
       ma = iMA(NULL, 0, MyPeriod, 0, MODE_EMA, PRICE_CLOSE, i);
       pBulls = High[i] - ma;
       pBears = Low[i] - ma;
       v = (pBears + pBulls) / 2;
       if(v >= 0)
         {
           ExtBuffer1[i] = v;
           ExtBuffer2[i] = 0;
         }
       else
         {
           ExtBuffer1[i] = 0;
           ExtBuffer2[i] = v;
         }
     }
   return(0);
  }
//+------------------------------------------------------------------+

