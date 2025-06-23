//+------------------------------------------------------------------+
//|                                                        Drive.mq4 |
//|                                       Copyright © 2005, systrad5 |
//|                                                         25/07/05 |
//|               Feedback or comments welcome at systrad5@yahoo.com |
//+------------------------------------------------------------------+
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Green
#property indicator_color2 Red
//---- input parameters
extern int Depth = 16;
//---- buffers
double UpBuffer[];
double DownBuffer[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
//---- additional buffers
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, UpBuffer);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(1, DownBuffer);
   //---- name for DataWindow and indicator subwindow label
   string short_name = "Drive(" + Depth + ")";
   IndicatorShortName(short_name);
   SetIndexLabel(0, "DriveUp");
   SetIndexLabel(1, "DriveDn");   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int i, j;
   double UpCnt, DnCnt;      
   if(Bars <= Depth + 10) 
       return(0);
//---- last counted bar will be recounted
   int counted_bars = IndicatorCounted();
   int limit = Bars - counted_bars;
   if(counted_bars > 0) 
       limit++;
//---- Load prices into CBuffer[0]
   for(i = 0; i < limit; i++)
     {
       UpCnt = 0;
       DnCnt = 0;
       for(j = 0; j < Depth; j++)
         {
           UpCnt = UpCnt + (High[i+j] - Open[i+j]) + (Close[i+j] - Low[i+j]);
           DnCnt = DnCnt + (Open[i+j] - Low[i+j]) + (High[i+j] - Close[i+j]);
         }
       UpBuffer[i] = (UpCnt / (2 * Depth)) / Point;
       DownBuffer[i] = (DnCnt / (2 * Depth)) / Point;
     }
   return(0);
  }
//+------------------------------------------------------------------+

