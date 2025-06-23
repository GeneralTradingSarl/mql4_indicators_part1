//+------------------------------------------------------------------+
//| Fibonacci-based moving Averages.mq4  PART-1                      |
//| FOR EDUCATIONAL PURPOSE AND FREE INDICATOR                       | 
//| Copyright © 2010, WWMMACAU.                                      | 
//| WWMMACAU@GMAIL.COM                                               |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, WWMMACAU"
#property link      "WWMMACAU@GMAIL.COM"

#property indicator_chart_window

#property indicator_buffers 8
#property indicator_color1 Lime
#property indicator_color2 Lime
#property indicator_color3 Lime
#property indicator_color4 Lime
#property indicator_color5 DarkOrange
#property indicator_color6 DarkViolet
#property indicator_color7 RoyalBlue
#property indicator_color8 Blue


#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2
#property indicator_width4 2
#property indicator_width5 2
#property indicator_width6 2
#property indicator_width7 2
#property indicator_width8 5


//---- input parameters
extern int FastMAPeriod1=34;     
extern int FastMAPeriod2=34;     
extern int FastMAPeriod3=34;
extern int FastMAPeriod4=55;
extern int FastMAPeriod5=89;
extern int FastMAPeriod6=144;
extern int FastMAPeriod7=200;



//---- buffers
double fastEMA_HighBuffer0[];    
double fastEMA_LowBuffer[];     
double fastEMA_MiddleBuffer[];
double fastEMA_HighBuffer1[];
double fastEMA_HighBuffer2[];
double fastEMA_HighBuffer3[];
double fastEMA_HighBuffer4[];

                                
//---- variables

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   int    draw_begin;
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS)+1);
   //---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,fastEMA_HighBuffer0);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,fastEMA_HighBuffer0);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,fastEMA_LowBuffer);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,fastEMA_MiddleBuffer);
   SetIndexStyle(4,DRAW_LINE);
   SetIndexBuffer(4,fastEMA_HighBuffer1);
   SetIndexStyle(5,DRAW_LINE);
   SetIndexBuffer(5,fastEMA_HighBuffer2);
   SetIndexStyle(6,DRAW_LINE);
   SetIndexBuffer(6,fastEMA_HighBuffer3);
   SetIndexStyle(7,DRAW_LINE);
   SetIndexBuffer(7,fastEMA_HighBuffer4);
   SetIndexStyle(8,DRAW_LINE);
   
   
    
   
   
   
//   SetIndexDrawBegin(0,fastEMA_HighBuffer0);
   SetIndexDrawBegin(0,draw_begin);
   
   
   //---- index labels
   SetIndexLabel(1,"EMA 34 High");
   SetIndexLabel(2,"EMA 34 Low");
   SetIndexLabel(3,"EMA 34 Close");
   SetIndexLabel(4,"EMA 55 Close");
   SetIndexLabel(5,"EMA 89 Close");
   SetIndexLabel(6,"EMA 144 Close");
   SetIndexLabel(7,"EMA 200 Close");
                                                 
   IndicatorShortName("Fib-based MA Trend-P1 ");
   //----
   return(0);
   
   }
   //+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   int limit;
   int counted_bars = IndicatorCounted();
   //---- check for possible errors
   if (counted_bars<0) return(-1);
   //---- last counted bar will be recounted
   if (counted_bars>0) counted_bars--;
   limit = Bars - counted_bars;
   
   for(int i=0; i<limit; i++)
   //for(int i=limit; i>=0; i--)
   {
     fastEMA_HighBuffer0[i] = iMA(NULL,0,FastMAPeriod1,0,MODE_EMA,PRICE_HIGH,i);
     fastEMA_LowBuffer[i] = iMA(NULL,0,FastMAPeriod2,0,MODE_EMA,PRICE_LOW,i);
     fastEMA_MiddleBuffer[i] = iMA(NULL,0,FastMAPeriod3,0,MODE_EMA,PRICE_CLOSE,i);   
     fastEMA_HighBuffer1[i] = iMA(NULL,0,FastMAPeriod4,0,MODE_EMA,PRICE_CLOSE,i);
     fastEMA_HighBuffer2[i] = iMA(NULL,0,FastMAPeriod5,0,MODE_EMA,PRICE_CLOSE,i);
     fastEMA_HighBuffer3[i] = iMA(NULL,0,FastMAPeriod6,0,MODE_EMA,PRICE_CLOSE,i);
     fastEMA_HighBuffer4[i] = iMA(NULL,0,FastMAPeriod7,0,MODE_EMA,PRICE_CLOSE,i);
                
     
   }
   
   //----
   return(0);
}
//+------------------------------------------------------------------+