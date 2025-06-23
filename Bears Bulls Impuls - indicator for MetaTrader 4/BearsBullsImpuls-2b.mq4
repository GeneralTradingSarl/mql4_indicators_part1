//+------------------------------------------------------------------+
//|                                          BearsBullsImpuls-2b.mq4 |
//|                           Copyright © 2012, basisforex@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012, basisforex@gmail.com"
#property link      "basisforex@gmail.com"
//----------------------------------------
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Green
#property indicator_color2 Red
//----
extern int maPeriod = 13;
extern int maMODE   = 3;//  0=MODE_SMA; 1=MODE_EMA; 2=MODE_SMMA; 3=MODE_LWMA.
extern int maPRICE  = 5;//  0=PRICE_CLOSE; 1=PRICE_OPEN; 2=PRICE_HIGH; 3=PRICE_LOW; 4=PRICE_MEDIAN; 5=PRICE_TYPICAL; 6=PRICE_WEIGHTED. 
//----
double Buffer1[];
double Buffer2[];
//+------------------------------------------------------------------+
int init()
 {
   SetIndexBuffer(0, Buffer1);
   SetIndexStyle(0, DRAW_LINE, 0, 2);
   //----
   SetIndexBuffer(1, Buffer2);
   SetIndexStyle(1, DRAW_LINE, 0, 2);
   //----   
   IndicatorShortName("BearsBullsImpuls (" + maPeriod + ") ");
   return(0);
 }
//+------------------------------------------------------------------+
int start()
 {
   double Bears ,Bulls , ma, avg;
   int i, limit;
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0) return(-1);
   if(counted_bars > 0) counted_bars--;
   limit = Bars - counted_bars; 
   for(i = 0; i < limit; i++)
    {
       ma = iMA(NULL, 0, maPeriod, 0, maMODE, maPRICE, i);
       Bulls = High[i] - ma;
       Bears = Low[i] - ma;
       avg = Bears + Bulls;
       if(avg >= 0)
        {
           Buffer1[i] = 1.0;
           Buffer2[i] = -1.0;
        }
       else
        {
           Buffer1[i] = -1.0;
           Buffer2[i] = 1.0;
        }
    }
   return(0);
 }
//+------------------------------------------------------------------+