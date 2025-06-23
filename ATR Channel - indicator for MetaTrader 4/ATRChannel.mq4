//+------------------------------------------------------------------+
//| ATRChannel.mq4
//| Copyright © Pointzero-indicator.com
//+------------------------------------------------------------------+
#property copyright "Copyright © Pointzero-indicator.com"
#property link      "http://www.pointzero-indicator.com"

//---- indicator settings
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 DodgerBlue

//---- indicator parameters
extern bool CalculateOnBarClose = true;
extern bool UseMedianPrice      = false;
extern int  ATRPeriod           = 14;

//---- indicator buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   // Drawing settings
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS));
   
   // Name and labels
   IndicatorShortName("ATRChannel");
   SetIndexLabel(0,"Upper Channel");
   SetIndexLabel(1,"Lower Channel");
   
   // Buffers
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexBuffer(1,ExtMapBuffer2);
   
   Comment("Copyright © http://www.pointzero-indicator.com");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
     // Start, limit, etc..
     int start = 0;
     int limit;
     int counted_bars = IndicatorCounted();

     // check for possible errors
     if(counted_bars < 0) 
        return(-1);
        
     // Only check these
     limit = Bars - 1 - counted_bars;
    
     // Check if ignore bar 0
     if(CalculateOnBarClose == true) start = 1;
    
     // Check the signal foreach bar
     for(int i = limit; i >= start; i--)
     {           
         // Median
         double high = iHigh(Symbol(), 0, i);
         double low  = iLow(Symbol(), 0, i);
         double median = (high + low) / 2;
         
         // Atr
         double atr = iATR(Symbol(), 0, ATRPeriod, i);
         
         // Draw
         if(UseMedianPrice)
         {
            ExtMapBuffer1[i] = median + atr;
            ExtMapBuffer2[i] = median - atr;
         } else {
            ExtMapBuffer1[i] = high + atr;
            ExtMapBuffer2[i] = low - atr;
         }
     }
   
   // Bye Bye
   return(0);
  }
//+------------------------------------------------------------------+