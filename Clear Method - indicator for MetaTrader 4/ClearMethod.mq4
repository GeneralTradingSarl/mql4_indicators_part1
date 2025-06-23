// This indicator is based on the article: Getting Clear With Short-Term Swings by Ron Black
//
// http://www.traders.com/Documentation/FEEDbk_docs/2010/09/Black.html
// http://www.traders.com/Documentation/FEEDbk_docs/2010/09/TradersTips.html
//
// To set up colored candle charts:
// - switch to Line Chart
// - in Chart Properties window, set Line Chart Color to None (the entire price graph will disappear)
// - copy the ClearMethod.mq4 file to the Indicator directory, it will be used by iCustom()
// - add ClearMethodCandles1 (this must be the first), then ClearMethodCandles2 to the chart
// - if you use black backgrounded chart, set IsBlackChart parameter to true for both indicator

#property indicator_chart_window

#property indicator_buffers 3
#property indicator_color1 White
#property indicator_color2 C'64, 128, 128'
#property indicator_color3 C'128, 64, 128'

int maxHistoryBarsToCount = 50000;

bool IsPrevBarUpSwing;
double PrevBarHighestHigh;
double PrevBarLowestHigh;
double PrevBarHighestLow;
double PrevBarLowestLow;

double IsUpSwingBuffer[];
double UpSwingLineBuffer[];
double DownSwingLineBuffer[];

int init() {
   SetIndexStyle(0, DRAW_NONE);
   SetIndexBuffer(0, IsUpSwingBuffer);
   SetIndexStyle(1, DRAW_LINE, STYLE_SOLID, 2);
   SetIndexBuffer(1, UpSwingLineBuffer);
   SetIndexStyle(2, DRAW_LINE, STYLE_SOLID, 2);
   SetIndexBuffer(2, DownSwingLineBuffer);
   
   SetIndexEmptyValue(1, 0.0);
   SetIndexEmptyValue(2, 0.0);
   
   IsPrevBarUpSwing = false;
   PrevBarHighestHigh = High[Bars - 1];
   PrevBarLowestHigh = High[Bars - 1];
   PrevBarHighestLow = Low[Bars - 1];
   PrevBarLowestLow = Low[Bars - 1]; 
     
   return(0);
}

int start() {
   int countedBars = IndicatorCounted();
   int countFrom = MathMin(Bars - countedBars - 1, maxHistoryBarsToCount);

   if (countFrom >= 0 && countFrom < Bars) {
      countIndicator(countFrom);
   }
   return(0);
}

int countIndicator(int countFrom) {
   int i;
   bool isUpSwing = IsPrevBarUpSwing;
   double highestHigh = PrevBarHighestHigh;
   double lowestHigh = PrevBarLowestHigh;
   double highestLow = PrevBarHighestLow;
   double lowestLow = PrevBarLowestLow;

   for (i = countFrom; i >= 0; i--) {
      if (isUpSwing) { 

         highestHigh = MathMax(High[i], highestHigh); 
         highestLow = MathMax(Low[i], highestLow); 

         if (High[i] < highestLow) { 
            isUpSwing = false;
            lowestLow = Low[i];
            lowestHigh = High[i];
         }
      } 

      if (!isUpSwing) { 

         lowestLow = MathMin(Low[i], lowestLow); 
         lowestHigh = MathMin(High[i], lowestHigh); 

         if (Low[i] > lowestHigh) { 
            isUpSwing = true;
            highestHigh = High[i]; 
            highestLow = Low[i]; 
         } 
      } 

      if (isUpSwing) {
         IsUpSwingBuffer[i] = 1.0;
         UpSwingLineBuffer[i] = highestLow;
         DownSwingLineBuffer[i] = 0.0;
      } else {
         IsUpSwingBuffer[i] = 0.0;
         UpSwingLineBuffer[i] = 0.0;
         DownSwingLineBuffer[i] = lowestHigh;
      }
      
      if (i == 1) {
         IsPrevBarUpSwing = isUpSwing;
         PrevBarHighestHigh = highestHigh;
         PrevBarLowestHigh = lowestHigh;
         PrevBarHighestLow = highestLow;
         PrevBarLowestLow = lowestLow;
      }
   }
   return(0);
}

