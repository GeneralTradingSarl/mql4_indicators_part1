//+------------------------------------------------------------------+
//| 4Hour Vegas Model - 4 Hour Chart MA lines                        |
//|                                                           Spiggy |
//|                                                                  |
//| Versiom History:                                                 |
//|   02.08.2005 V0.2b - Corrected Exit Calculation to use Fibs      |
//|                      calculated from current SMA, not entry price|
//|   09.08.2005 V0.3  - Corrected Exit P&L Calculation, updated     |
//|                      alerts to show P&L before exit              |
//+------------------------------------------------------------------+
#property copyright "Spiggy"
#property link      "ian.sparkes@gmail.com"
//----
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Aqua
#property indicator_color2 Blue
#property indicator_color3 Red
#property indicator_color4 Green
//---- input parameters
extern bool      Alerts=true;
extern bool      PrintTags=True;
extern bool      LogTrades=False;
extern int       MA1=55;
extern int       MA2=8;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_ARROW);
   SetIndexArrow(2,1);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexStyle(3,DRAW_ARROW);
   SetIndexArrow(3,2);
   SetIndexBuffer(3,ExtMapBuffer4);
   //----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    limit;
   int    counted_bars=IndicatorCounted();
   double SMA55;
   double SMA55Prev;
   double SMA8;
   double SMA8Prev;
   string ValueIndex;
   string Direction;
   bool   BuyPrimed;
   bool   SellPrimed;
   bool   Bought1;
   bool   Bought2;
   bool   Bought3;
   bool   Sold1;
   bool   Sold2;
   bool   Sold3;
   double BoughtAt;
   double SoldAt;
   int    TagCount;
   string TagName;
   int    i;
   int    j;
   double RangeLimit;
   bool   InTrade=False;
   int    PandL=0;
   bool   FullTrade;
   int    LastTagOffsetAbove;
   int    CumulativeTagOffsetAbove;
   int    LastTagOffsetBelow;
   int    CumulativeTagOffsetBelow;
   int    LotsRemaining;
   double SMA8Interpolated;
   // Count all bars every time (bad for performance, but good for testing)
   if (PrintTags)
     {
      limit=Bars;
     }
   else
     {
      if(counted_bars<0) return(-1);
      if(counted_bars>0) counted_bars--;
      limit=Bars-counted_bars;
     }
   // Clean up for redraw
   ObjectsDeleteAll(0);
   TagCount=0;
   LastTagOffsetAbove=limit - 10;
   LastTagOffsetBelow=limit - 10;
//---- main loop
   for(i=limit-1; i>=0; i--)
     {
      //---- ma_shift set to 0 because SetIndexShift called abowe
      SMA55=iMA(NULL,0,MA1,0,MODE_SMA,PRICE_MEDIAN,i);
      SMA8 =iMA(NULL,0,MA2,0,MODE_SMA,PRICE_CLOSE,i);
      SMA55Prev=iMA(NULL,0,MA1,1,MODE_SMA,PRICE_MEDIAN,i);
      SMA8Prev =iMA(NULL,0,MA2,1,MODE_SMA,PRICE_CLOSE,i);
      //
      ExtMapBuffer1[i]=SMA8;
      ExtMapBuffer2[i]=SMA55;
      ExtMapBuffer3[i]=0;
      ExtMapBuffer4[i]=0;
      //
      Direction="----";
      ValueIndex=TimeToStr(Time[i]-(TimeDayOfWeek(Time[i])*86400),TIME_DATE);
      if(GlobalVariableGet(Symbol() + "-ThisWeekDirection-" + ValueIndex) > 0.0 )
        {
         Direction="UP  ";
        }
      if(GlobalVariableGet(Symbol() + "-ThisWeekDirection-" + ValueIndex) < 0.0 )
        {
         Direction="DOWN";
        }
      if (!InTrade)
        {
         // ------------- TRADE ENTRY --------------
         // Check the MA8/55 Crossovers
         if(Direction=="DOWN" )
           {
            // Check the SMA8 SM55 Crossover and prime the Sell signal
            if (( SMA8 > SMA55)&& (SMA8Prev < SMA55Prev))
              {
               SellPrimed=True;
               BuyPrimed=False;
              }
            // Trigger the sell signal
            if(SMA8 < SMA8Prev )
              {
               if (SellPrimed)
                 {
                  // We are opening a primed trade, do full lots 
                  FullTrade=True;
                 }
               else
                 {
                  // Otherwise do half lots
                  FullTrade=False;
                 }
               // Find the height of the tag - this should not cover any bars
               RangeLimit=High[i];
               for( j=i - 7;j < i + 7;j++)
                 {
                  if (High[j] > RangeLimit)
                    {
                     RangeLimit=High[j];
                    }
                 }
               SellPrimed=False;
               Sold1=True;
               Sold2=True;
               Sold3=True;
               // We have to calculate the value at which we would have triggered the signal
               // This is done by finding equality of SMA8Prev and SMA8
               SMA8Interpolated=SMA8Prev*8 - (Close[i+0]+Close[i+1]+Close[i+2]+Close[i+3]+Close[i+4]+Close[i+5]+Close[i+6]);
               SoldAt=SMA8Interpolated;
               InTrade=True;
               ExtMapBuffer3[i]=SoldAt;
               // Put the tag on the chart
               if (PrintTags)
                 {
                  if((LastTagOffsetAbove - i) < 10 )
                    {
                     CumulativeTagOffsetAbove=CumulativeTagOffsetAbove + 15;
                    }
                  else
                    {
                     CumulativeTagOffsetAbove=0;
                    }
                  LastTagOffsetAbove=i;
                  TagName="Entry" + TagCount;
                  ObjectCreate(TagName, OBJ_TEXT, 0, Time[i], RangeLimit+(70-CumulativeTagOffsetAbove)*Point);
                  ObjectSetText(TagName, "SELL " + TagCount + " (" + DoubleToStr(SoldAt,4) + ")", 8, "Arial", White);
                 }
               if(LogTrades )
                 {
                  if(FullTrade )
                    {
                     Print("Trade " + TagCount + " : " + Symbol() + ": SELL 100% " + DoubleToStr(Close[i],4) + " at " + TimeToStr(Time[i]));
                    }
                  else
                    {
                     Print("Trade " + TagCount + " : " + Symbol() + ": SELL  50% " + DoubleToStr(Close[i],4) + " at " + TimeToStr(Time[i]));
                    }
                 }
               if (Alerts)
                 {
                  if(i==0 )
                    {
                     Alert("["+TimeToStr(CurTime())+"] " + Symbol() + ": Sell! Quote ("+Bid+":"+Ask+")");
                    }
                 }
              }
           }
         if(Direction=="UP  " )
           {
            // Check the SMA8 SM55 Crossover and prime the Buy signal
            if (( SMA8 < SMA55)&& (SMA8Prev > SMA55Prev))
              {
               BuyPrimed=True;
               SellPrimed=False;
              }
            // Trigger the Buy signal or unprime the trigger
            if(SMA8 > SMA8Prev )
              {
               if (BuyPrimed)
                 {
                  // We are opening a primed trade, do full lots 
                  FullTrade=True;
                 }
               else
                 {
                  // Otherwise do half lots
                  FullTrade=False;
                 }
               // Find the height of the tag - this should not cover any bars
               RangeLimit=Low[i];
               for( j=i - 7;j < i + 7;j++)
                 {
                  if (Low[j] < RangeLimit)
                    {
                     RangeLimit=Low[j];
                    }
                 }
               BuyPrimed=False;
               Bought1=True;
               Bought2=True;
               Bought3=True;
               // We have to calculate the value at which we would have triggered the signal
               // This is done by finding equality of SMA8Prev and SMA8
               SMA8Interpolated=SMA8Prev*8 - (Close[i+0]+Close[i+1]+Close[i+2]+Close[i+3]+Close[i+4]+Close[i+5]+Close[i+6]);
               BoughtAt=SMA8Interpolated;
               InTrade=True;
               ExtMapBuffer4[i]=BoughtAt;
               //----
               if (PrintTags)
                 {
                  if((LastTagOffsetBelow - i) < 10 )
                    {
                     CumulativeTagOffsetBelow=CumulativeTagOffsetBelow + 15;
                    }
                  else
                    {
                     CumulativeTagOffsetBelow=0;
                    }
                  LastTagOffsetBelow=i;
                  TagName="Entry" + TagCount;
                  ObjectCreate(TagName, OBJ_TEXT, 0, Time[i], RangeLimit - (70 - CumulativeTagOffsetBelow)*Point);
                  ObjectSetText(TagName, "BUY " + TagCount + " (" + DoubleToStr(BoughtAt,4) + ")", 8, "Arial", White);
                 }
               if(LogTrades )
                 {
                  if(FullTrade )
                    {
                     Print("Trade " + TagCount + " : " + Symbol() + ": BUY 100% " + DoubleToStr(Close[i],4) + " at " + TimeToStr(Time[i]));
                    }
                  else
                    {
                     Print("Trade " + TagCount + " : " + Symbol() + ": BUY  50% " + DoubleToStr(Close[i],4) + " at " + TimeToStr(Time[i]));
                    }
                 }
               if (Alerts)
                 {
                  if(i==0 )
                    {
                     Alert("["+TimeToStr(CurTime())+"] " + Symbol() + ": Buy! Quote ("+Bid+":"+Ask+")");
                    }
                 }
              }
           }
        }
      else
        {
         // ------------- TRADE EXIT --------------
         if (Sold1 || Sold2 || Sold3)
           {
            // Trade Exit on SMA slope change
            if(SMA8 > SMA8Prev)
              {
               // Find how many lots there are open
               LotsRemaining=0;
               if (Sold1)
                 {
                  LotsRemaining++;
                 }
               if (Sold2)
                 {
                  LotsRemaining++;
                 }
               if (Sold3)
                 {
                  LotsRemaining++;
                 }
               // Find the height of the tag - this should not cover any bars
               RangeLimit=Low[i];
               for( j=i - 7;j < i + 7;j++)
                 {
                  if (Low[j] < RangeLimit)
                    {
                     RangeLimit=Low[j];
                    }
                 }
               if (PrintTags)
                 {
                  // Put the tag on the chart
                  ExtMapBuffer4[i]=Close[i];
                  if((LastTagOffsetBelow - i) < 10 )
                    {
                     CumulativeTagOffsetBelow=CumulativeTagOffsetBelow + 15;
                    }
                  else
                    {
                     CumulativeTagOffsetBelow=0;
                    }
                  LastTagOffsetBelow=i;
                  TagName="Exit" + TagCount;
                  ObjectCreate(TagName, OBJ_TEXT, 0, Time[i], RangeLimit-(70-CumulativeTagOffsetBelow)*Point );
                  ObjectSetText(TagName, "EXIT " + TagCount + " (" + LotsRemaining + " Lots for " + DoubleToStr((SoldAt-Close[i])/Point,0) + ")", 8, "Arial", White);
                 }
               if(LogTrades )
                 {
                  if(FullTrade )
                    {
                     Print("Trade " + TagCount + " : " + Symbol() + ": EXIT 100% " + DoubleToStr(Close[i],4) + " at " + TimeToStr(Time[i]) + " (" + DoubleToStr((SoldAt-Close[i])/Point,0) + ")");
                    }
                  else
                    {
                     Print("Trade " + TagCount + " : " + Symbol() + ": EXIT  50% " + DoubleToStr(Close[i],4) + " at " + TimeToStr(Time[i]) + " (" + DoubleToStr((SoldAt-Close[i])/Point,0) + ")");
                    }
                 }
               if (Alerts)
                 {
                  if(i==0 )
                    {
                     Alert("["+TimeToStr(CurTime())+"] " + Symbol() + ": Exit Shorts! PandL ("+DoubleToStr((SoldAt-Close[i])/Point,0)+")");
                    }
                 }
               if(FullTrade )
                 {
                  PandL=PandL + ((SoldAt-Close[i])/Point)*LotsRemaining;
                 }
               else
                 {
                  PandL=PandL + ((((SoldAt-Close[i])/Point)*LotsRemaining)/2);
                 }
               Sold1=False;
               Sold2=False;
               Sold3=False;
               InTrade=False;
               TagCount++;
              }
            // Exit on Fib 1
            if (Sold1)
              {
               if(Low[i] < (SMA55 - 144*Point))
                 {
                  // Find the height of the tag - this should not cover any bars
                  RangeLimit=Low[i];
                  for( j=i - 7;j < i + 7;j++)
                    {
                     if (Low[j] < RangeLimit)
                       {
                        RangeLimit=Low[j];
                       }
                    }
                  ExtMapBuffer4[i]=Close[i];
                  if (PrintTags)
                    {
                     if((LastTagOffsetBelow - i) < 10 )
                       {
                        CumulativeTagOffsetBelow=CumulativeTagOffsetBelow + 15;
                       }
                     else
                       {
                        CumulativeTagOffsetBelow=0;
                       }
                     LastTagOffsetBelow=i;
                     TagName="ExitFib1" + TagCount;
                     ObjectCreate(TagName, OBJ_TEXT, 0, Time[i], RangeLimit-(70-CumulativeTagOffsetBelow)*Point);
                     ObjectSetText(TagName, "EXIT1 " + TagCount + " (Fib1 " + DoubleToStr((SoldAt-Close[i])/Point,0) + ")", 8, "Arial", White);
                    }
                  Sold1=False;
                  //----
                  if(LogTrades )
                    {
                     if(FullTrade )
                       {
                        Print("Trade " + TagCount + " : " + Symbol() + ": FIB1 100% " + DoubleToStr(Close[i],4) + " at " + TimeToStr(Time[i]) + " (" + DoubleToStr((SoldAt-Close[i])/Point,0) + ")");
                       }
                     else
                       {
                        Print("Trade " + TagCount + " : " + Symbol() + ": FIB1  50% " + DoubleToStr(Close[i],4) + " at " + TimeToStr(Time[i]) + " (" + DoubleToStr((SoldAt-Close[i])/Point,0) + ")");
                       }
                    }
                  if (Alerts)
                    {
                     if(i==0 )
                       {
                        Alert("["+TimeToStr(CurTime())+"] " + Symbol() + ": Exit Short Fib1! PandL ("+DoubleToStr((SoldAt-Close[i])/Point,0)+")");
                       }
                    }
                  if(FullTrade )
                    {
                     PandL=PandL + ((SoldAt-Close[i])/Point);
                    }
                  else
                    {
                     PandL=PandL + ((SoldAt-Close[i])/Point)/2;
                    }
                 }
              }
            // Exit on Fib 2
            if (Sold2)
              {
               if(Low[i] < (SMA55 - 233*Point))
                 {
                  // Find the height of the tag - this should not cover any bars
                  RangeLimit=Low[i];
                  for( j=i - 7;j < i + 7;j++)
                    {
                     if (Low[j] < RangeLimit)
                       {
                        RangeLimit=Low[j];
                       }
                    }
                  ExtMapBuffer4[i]=Close[i];
                  if (PrintTags)
                    {
                     if((LastTagOffsetBelow - i) < 10 )
                       {
                        CumulativeTagOffsetBelow=CumulativeTagOffsetBelow + 15;
                       }
                     else
                       {
                        CumulativeTagOffsetBelow=0;
                       }
                     LastTagOffsetBelow=i;
                     TagName="ExitFib2" + TagCount;
                     ObjectCreate(TagName, OBJ_TEXT, 0, Time[i], RangeLimit-(70-CumulativeTagOffsetBelow)*Point);
                     ObjectSetText(TagName, "EXIT2 " + TagCount + " (Fib2 " + DoubleToStr((SoldAt-Close[i])/Point,0) + ")", 8, "Arial", White);
                    }
                  Sold2=False;
                  if(LogTrades )
                    {
                     if(FullTrade )
                       {
                        Print("Trade " + TagCount + " : " + Symbol() + ": FIB2 100% " + DoubleToStr(Close[i],4) + " at " + TimeToStr(Time[i]) + " (" + DoubleToStr((SoldAt-Close[i])/Point,0) + ")");
                       }
                     else
                       {
                        Print("Trade " + TagCount + " : " + Symbol() + ": FIB2  50% " + DoubleToStr(Close[i],4) + " at " + TimeToStr(Time[i]) + " (" + DoubleToStr((SoldAt-Close[i])/Point,0) + ")");
                       }
                    }
                  if (Alerts)
                    {
                     if(i==0 )
                       {
                        Alert("["+TimeToStr(CurTime())+"] " + Symbol() + ": Exit Short Fib2! PandL ("+DoubleToStr((SoldAt-Close[i])/Point,0)+")");
                       }
                    }
                  if(FullTrade )
                    {
                     PandL=PandL + ((SoldAt-Close[i])/Point);
                    }
                  else
                    {
                     PandL=PandL + ((SoldAt-Close[i])/Point)/2;
                    }
                 }
              }
            // Exit on Fib 3
            if (Sold3)
              {
               if(Low[i] < (SMA55 - 377*Point))
                 {
                  // Find the height of the tag - this should not cover any bars
                  RangeLimit=Low[i];
                  for( j=i - 7;j < i + 7;j++)
                    {
                     if (Low[j] < RangeLimit)
                       {
                        RangeLimit=Low[j];
                       }
                    }
                  ExtMapBuffer4[i]=Close[i];
                  if (PrintTags)
                    {
                     if((LastTagOffsetBelow - i) < 10 )
                       {
                        CumulativeTagOffsetBelow=CumulativeTagOffsetBelow + 15;
                       }
                     else
                       {
                        CumulativeTagOffsetBelow=0;
                       }
                     LastTagOffsetBelow=i;
                     TagName="ExitFib3" + TagCount;
                     ObjectCreate(TagName, OBJ_TEXT, 0, Time[i], RangeLimit-(70-CumulativeTagOffsetBelow)*Point);
                     ObjectSetText(TagName, "EXIT3 " + TagCount + " (Fib3 " + DoubleToStr((SoldAt-Close[i])/Point,0) + ")", 8, "Arial", White);
                    }
                  // We are now out of the trade
                  Sold3=False;
                  InTrade=False;
                  //----
                  if(LogTrades )
                    {
                     if(FullTrade )
                       {
                        Print("Trade " + TagCount + " : " + Symbol() + ": FIB3 100% " + DoubleToStr(Close[i],4) + " at " + TimeToStr(Time[i]) + " (" + DoubleToStr((SoldAt-Close[i])/Point,0) + ")");
                       }
                     else
                       {
                        Print("Trade " + TagCount + " : " + Symbol() + ": FIB3  50% " + DoubleToStr(Close[i],4) + " at " + TimeToStr(Time[i]) + " (" + DoubleToStr((SoldAt-Close[i])/Point,0) + ")");
                       }
                    }
                  if (Alerts)
                    {
                     if(i==0 )
                       {
                        Alert("["+TimeToStr(CurTime())+"] " + Symbol() + ": Exit Short Fib3! PandL ("+DoubleToStr((SoldAt-Close[i])/Point,0)+")");
                       }
                    }
                  if(FullTrade )
                    {
                     PandL=PandL + ((SoldAt-Close[i])/Point);
                    }
                  else
                    {
                     PandL=PandL + ((SoldAt-Close[i])/Point)/2;
                    }
                 }
              }
           }
         if (Bought1 || Bought2 || Bought3)
           {
            // Trade Exit on SMA slope change
            if(SMA8 < SMA8Prev)
              {
               // Find how many lots there are open
               LotsRemaining=0;
               if (Bought1)
                 {
                  LotsRemaining++;
                 }
               if (Bought2)
                 {
                  LotsRemaining++;
                 }
               if (Bought3)
                 {
                  LotsRemaining++;
                 }
               // Find the height of the tag - this should not cover any bars
               RangeLimit=High[i];
               for( j=i - 7;j < i + 7;j++)
                 {
                  if (High[j] > RangeLimit)
                    {
                     RangeLimit=High[j];
                    }
                 }
               // Put the tag on the chart
               ExtMapBuffer3[i]=Close[i];
               if (Alerts)
                 {
                  if(i==0 )
                    {
                     Alert("["+TimeToStr(CurTime())+"] " + Symbol() + ": Exit Longs! PandL ("+DoubleToStr((Close[i]-BoughtAt)/Point,0)+")");
                    }
                 }

               if (PrintTags)
                 {
                  if((LastTagOffsetAbove - i) < 10 )
                    {
                     CumulativeTagOffsetAbove=CumulativeTagOffsetAbove + 15;
                    }
                  else
                    {
                     CumulativeTagOffsetAbove=0;
                    }
                  LastTagOffsetAbove=i;
                  TagName="Exit" + TagCount;
                  ObjectCreate(TagName, OBJ_TEXT, 0, Time[i], RangeLimit+(70-CumulativeTagOffsetAbove)*Point );
                  ObjectSetText(TagName, "EXIT " + TagCount + " (" + LotsRemaining + " Lots for " + DoubleToStr((Close[i]-BoughtAt)/Point,0) + ")", 8, "Arial", White);
                 }
               if(LogTrades )
                 {
                  if(FullTrade )
                    {
                     Print("Trade " + TagCount + " : " + Symbol() + ": EXIT 100% " + DoubleToStr(Close[i],4) + " at " + TimeToStr(Time[i]) + " (" + DoubleToStr((Close[i]-BoughtAt)/Point,0) + ")");
                    }
                  else
                    {
                     Print("Trade " + TagCount + " : " + Symbol() + ": EXIT  50% " + DoubleToStr(Close[i],4) + " at " + TimeToStr(Time[i]) + " (" + DoubleToStr((Close[i]-BoughtAt)/Point,0) + ")");
                    }
                 }
               if(FullTrade )
                 {
                  PandL=PandL + ((Close[i]-BoughtAt)/Point)*LotsRemaining;
                 }
               else
                 {
                  PandL=PandL + (((Close[i]-BoughtAt)/Point)*LotsRemaining)/2;
                 }
               Bought1=False;
               Bought2=False;
               Bought3=False;
               InTrade=False;
               TagCount++;
              }
            // Exit on Fib 1
            if (Bought1)
              {
               if(High[i] > (SMA55 + 144*Point))
                 {
                  // Find the height of the tag - this should not cover any bars
                  RangeLimit=High[i];
                  for( j=i - 7;j < i + 7;j++)
                    {
                     if (High[j] > RangeLimit)
                       {
                        RangeLimit=High[j];
                       }
                    }
                  ExtMapBuffer3[i]=Close[i];
                  if (PrintTags)
                    {
                     if((LastTagOffsetAbove - i) < 10 )
                       {
                        CumulativeTagOffsetAbove=CumulativeTagOffsetAbove + 15;
                       }
                     else
                       {
                        CumulativeTagOffsetAbove=0;
                       }
                     LastTagOffsetAbove=i;
                     TagName="ExitFib1" + TagCount;
                     ObjectCreate(TagName, OBJ_TEXT, 0, Time[i], RangeLimit+(70-CumulativeTagOffsetAbove)*Point );
                     ObjectSetText(TagName, "EXIT1 " + TagCount + " (Fib1 " + DoubleToStr((Close[i]-BoughtAt)/Point,0) + ")", 8, "Arial", White);
                    }
                  Bought1=False;
                  if(LogTrades )
                    {
                     if(FullTrade )
                       {
                        Print("Trade " + TagCount + " : " + Symbol() + ": FIB3 100% " + DoubleToStr(Close[i],4) + " at " + TimeToStr(Time[i]) + " (" + DoubleToStr((Close[i]-BoughtAt)/Point,0) + ")");
                       }
                     else
                       {
                        Print("Trade " + TagCount + " : " + Symbol() + ": FIB3  50% " + DoubleToStr(Close[i],4) + " at " + TimeToStr(Time[i]) + " (" + DoubleToStr((Close[i]-BoughtAt)/Point,0) + ")");
                       }
                    }
                  if (Alerts)
                    {
                     if(i==0 )
                       {
                        Alert("["+TimeToStr(CurTime())+"] " + Symbol() + ": Exit Long Fib1! PandL ("+DoubleToStr((Close[i]-BoughtAt)/Point,0)+")");
                       }
                    }
                  if(FullTrade )
                    {
                     PandL=PandL + ((BoughtAt-Close[i])/Point);
                    }
                  else
                    {
                     PandL=PandL + ((BoughtAt-Close[i])/Point)/2;
                    }
                 }
              }
            // Exit on Fib 2
            if (Bought2)
              {
               if(High[i] > (SMA55 + 233*Point))
                 {
                  // Find the height of the tag - this should not cover any bars
                  RangeLimit=High[i];
                  for( j=i - 7;j < i + 7;j++)
                    {
                     if (High[j] > RangeLimit)
                       {
                        RangeLimit=High[j];
                       }
                    }
                  ExtMapBuffer3[i]=Close[i];
                  if (PrintTags)
                    {
                     if((LastTagOffsetAbove - i) < 10 )
                       {
                        CumulativeTagOffsetAbove=CumulativeTagOffsetAbove + 15;
                       }
                     else
                       {
                        CumulativeTagOffsetAbove=0;
                       }
                     LastTagOffsetAbove=i;
                     TagName="ExitFib2" + TagCount;
                     ObjectCreate(TagName, OBJ_TEXT, 0, Time[i], RangeLimit+(70-CumulativeTagOffsetAbove)*Point );
                     ObjectSetText(TagName, "EXIT2 " + TagCount + " (Fib2 " + DoubleToStr((Close[i]-BoughtAt)/Point,0) + ")", 8, "Arial", White);
                    }
                  Bought2=False;
                  //----
                  if(LogTrades )
                    {
                     if(FullTrade )
                       {
                        Print("Trade " + TagCount + " : " + Symbol() + ": FIB3 100% " + DoubleToStr(Close[i],4) + " at " + TimeToStr(Time[i]) + " (" + DoubleToStr((Close[i]-BoughtAt)/Point,0) + ")");
                       }
                     else
                       {
                        Print("Trade " + TagCount + " : " + Symbol() + ": FIB3  50% " + DoubleToStr(Close[i],4) + " at " + TimeToStr(Time[i]) + " (" + DoubleToStr((Close[i]-BoughtAt)/Point,0) + ")");
                       }
                    }
                  if (Alerts)
                    {
                     if(i==0 )
                       {
                        Alert("["+TimeToStr(CurTime())+"] " + Symbol() + ": Exit Long Fib2! PandL ("+DoubleToStr((Close[i]-BoughtAt)/Point,0)+")");
                       }
                    }
                  if(FullTrade )
                    {
                     PandL=PandL + ((BoughtAt-Close[i])/Point);
                    }
                  else
                    {
                     PandL=PandL + ((BoughtAt-Close[i])/Point)/2;
                    }
                 }
              }
            // Exit on Fib 3
            if (Bought3)
              {
               if(High[i] > (SMA55 + 377*Point))
                 {
                  // Find the height of the tag - this should not cover any bars
                  RangeLimit=Low[i];
                  for( j=i - 7;j < i + 7;j++)
                    {
                     if (Low[j] < RangeLimit)
                       {
                        RangeLimit=Low[j];
                       }
                    }
                  ExtMapBuffer3[i]=Close[i];
                  if (PrintTags)
                    {
                     if((LastTagOffsetAbove - i) < 10 )
                       {
                        CumulativeTagOffsetAbove=CumulativeTagOffsetAbove + 15;
                       }
                     else
                       {
                        CumulativeTagOffsetAbove=0;
                       }
                     LastTagOffsetAbove=i;
                     TagName="ExitFib3" + TagCount;
                     ObjectCreate(TagName, OBJ_TEXT, 0, Time[i], RangeLimit+(70-CumulativeTagOffsetAbove)*Point );
                     ObjectSetText(TagName, "EXIT3 " + TagCount + " (Fib3 " + DoubleToStr((Close[i]-BoughtAt)/Point,0) + ")", 8, "Arial", White);
                    }
                  // We are now out of the trade
                  Bought3=False;
                  InTrade=False;
                  //----
                  if(LogTrades )
                    {
                     if(FullTrade )
                       {
                        Print("Trade " + TagCount + " : " + Symbol() + ": FIB3 100% " + DoubleToStr(Close[i],4) + " at " + TimeToStr(Time[i]) + " (" + DoubleToStr((Close[i]-BoughtAt)/Point,0) + ")");
                       }
                     else
                       {
                        Print("Trade " + TagCount + " : " + Symbol() + ": FIB3  50% " + DoubleToStr(Close[i],4) + " at " + TimeToStr(Time[i]) + " (" + DoubleToStr((Close[i]-BoughtAt)/Point,0) + ")");
                       }
                    }
                  if (Alerts)
                    {
                     if(i==0 )
                       {
                        Alert("["+TimeToStr(CurTime())+"] " + Symbol() + ": Exit Long Fib3! PandL ("+DoubleToStr((Close[i]-BoughtAt)/Point,0)+")");
                       }
                    }
                  if(FullTrade )
                    {
                     PandL=PandL + ((BoughtAt-Close[i])/Point);
                    }
                  else
                    {
                     PandL=PandL + ((BoughtAt-Close[i])/Point)/2;
                    }
                 }
              }
           }
        }
     }
   Comment("Direction for W/B " + ValueIndex + ": " + Direction + ":(" + GlobalVariableGet(Symbol() + "-ThisWeekDirection-" + ValueIndex) + ")\nP&L: " + PandL);
   //----
   return(0);
  }
//+------------------------------------------------------------------+