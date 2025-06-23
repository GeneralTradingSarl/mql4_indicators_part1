//+------------------------------------------------------------------+
//|                                     CurrencyPairsCorrelation.mq4 |
//|                                                 Copyright © 2011 |
//|                                             basisforex@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011"
#property link      "basisforex@gmail.com"
//----
#property indicator_separate_window
#property indicator_buffers 6
#property indicator_color1 Blue
#property indicator_color2 Yellow
#property indicator_color3 Green
#property indicator_color4 Red
#property indicator_color5 Green
#property indicator_color6 Red
//---- input parameters --------------
extern double    ActiveLevel  = 3.618;
extern double    PassiveLevel  = 1.618;
//-----
extern string    symbol1     = "EURUSD";
extern int       MAPeriod1   = 13;
extern int       MAMethod1   = 0;
extern int       MAPrice1    = 0;
extern int       MaAvg1      = 5;
extern int       MaMet1      = 0;
//----
extern string    symbol2     = "USDCHF";
extern int       MAPeriod2   = 13;
extern int       MAMethod2   = 0;
extern int       MAPrice2    = 0;
extern int       MaAvg2      = 5;
extern int       MaMet2      = 0;
//-----
double LineBuffer1[];
double LineBuffer2[];
double HistBuffer1[];
double HistBuffer12[];
double HistBuffer2[];
double HistBuffer21[];
double temp1[];
double temp2[];
//+------------------------------------------------------------------+
int init()
 {
   IndicatorBuffers(8);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, LineBuffer1);
   SetIndexLabel(0, "EURUSD");
   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(1, LineBuffer2);
   SetIndexLabel(1, "USDCHF");
   SetIndexStyle(2, DRAW_HISTOGRAM, EMPTY, 2);
   SetIndexBuffer(2, HistBuffer1);
   SetIndexStyle(3, DRAW_HISTOGRAM, EMPTY, 2);
   SetIndexBuffer(3, HistBuffer2);
   SetIndexStyle(4, DRAW_HISTOGRAM, EMPTY, 2);
   SetIndexBuffer(4, HistBuffer12);
   SetIndexStyle(5, DRAW_HISTOGRAM, EMPTY, 2);
   SetIndexBuffer(5, HistBuffer21);
   //---
   SetIndexBuffer(6, temp1);
   SetIndexBuffer(7, temp2);
   //----
   return(0);
 }
//+------------------------------------------------------------------+
int start()
 {
   int i, counted_bars = IndicatorCounted();
   //----
   if(MAPeriod1 <= 1)    return(0);
   if(Bars <= MAPeriod1) return(0);
   //---- last counted bar will be recounted
   int limit = Bars - counted_bars;
   if(counted_bars > 0) limit++;
   //---- moving average
   for(i = 0; i < limit; i++)
    {
      temp1[i] = (iClose(symbol1, 0, i) - iMA(symbol1, 0, MAPeriod1, 0, MAMethod1, MAPrice1, i)) * 10000;
      temp2[i] = (iClose(symbol2, 0, i) - iMA(symbol2, 0, MAPeriod2, 0, MAMethod2, MAPrice2, i)) * 10000;
    }
   for(i = 0; i < limit; i++)
    {
      LineBuffer1[i] = iMAOnArray(temp1, 0, MaAvg1, 0, MaMet1, i);
    } 
   for(i = 0; i < limit; i++)
    {     
      LineBuffer2[i] = iMAOnArray(temp2, 0, MaAvg2, 0, MaMet2, i);
    } 
   for(i = 0; i < limit; i++)
    {     
      if(LineBuffer1[i] > LineBuffer2[i] && LineBuffer1[i] > 0 && LineBuffer2[i] < 0 && LineBuffer1[i] >= ActiveLevel && LineBuffer2[i] <= -PassiveLevel)
       {
         HistBuffer1[i] = LineBuffer1[i];
         HistBuffer12[i] = LineBuffer2[i];
       }
      else if(LineBuffer1[i] < LineBuffer2[i] && LineBuffer1[i] < 0 && LineBuffer2[i] > 0 && LineBuffer2[i] >= ActiveLevel && LineBuffer1[i] <= -PassiveLevel)
       {
         HistBuffer2[i] = LineBuffer1[i];
         HistBuffer21[i] = LineBuffer2[i];
       } 
      else
       {
         HistBuffer1[i] = 0;
         HistBuffer12[i] = 0;
         HistBuffer2[i] = 0;
         HistBuffer21[i] = 0;
       } 
    }  
//----   
   return(0);
 }
  