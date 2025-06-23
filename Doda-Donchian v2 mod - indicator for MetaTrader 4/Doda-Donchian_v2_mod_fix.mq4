//+------------------------------------------------------------------+
//|                                         Doda-Donchian v2 mod.mq4 |
//|                             Copyright © 2010, Gopal Krishan Doda |
//|                                          mod by Iwan Sulistiawan |
//|                                        http://www.DodaCharts.com |
//+------------------------------------------------------------------+

#property indicator_chart_window
#property indicator_buffers 5
#property indicator_color1 CLR_NONE
#property indicator_color2 CLR_NONE
#property indicator_color3 DarkViolet
#property indicator_color4 CLR_NONE
#property indicator_color5 CLR_NONE
#property indicator_width1 3
#property indicator_width2 3
#property indicator_width3 2
#property indicator_width4 CLR_NONE
#property indicator_width5 CLR_NONE


extern int ChannelPeriod = 24;
extern int EMAPeriod = 120;
extern int StartEMAShift = 6;
extern int EndEMAShift = 0;
extern double AngleTreshold = 0.32;
string note1="Change font colors automatically? True = Yes";
extern bool   Bid_Ask_Colors=True;
string note2="Default Price Font Color";
extern color  FontColorPrice=Black;
string note3="Font Size";
extern int    FontSizePrice=26;
string note4="Font Type";
string FontType="Rockwell";
extern int Corner=1;
extern color pivotColor = Blue;
extern color pivotlevelColor = Blue;
extern color CandleTimeColor = Blue;
extern color StopLossColor = Blue;

int XDistance=1;
int YDistance=5;
double   Old_Price;
int signalcondition = 0;
int CrossTime;
double CrossPrice;
string dbl2str;
string str_concat;
double UpperLine[];
double LowerLine[];
double MidLine[];
double BuyBuffer[];
double SellBuffer[];
double s1[];
bool BuySignal = FALSE;
bool SellSignal = FALSE;

int init() {
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, UpperLine);
   SetIndexLabel(0, "UpperLine");
   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(1, LowerLine);
   SetIndexLabel(1, "LowerLine");
   SetIndexStyle(2, DRAW_LINE);
   SetIndexBuffer(2, MidLine);
   SetIndexLabel(2, "MidLine");
   SetIndexStyle(3, DRAW_ARROW, EMPTY);
   SetIndexArrow(3, SYMBOL_ARROWUP);
   SetIndexBuffer(3, BuyBuffer);
   SetIndexLabel(3, "Buy");
   SetIndexStyle(4, DRAW_ARROW, EMPTY);
   SetIndexArrow(4, SYMBOL_ARROWDOWN);
   SetIndexBuffer(4, SellBuffer);
   SetIndexLabel(4, "Sell");
   ObjectCreate("myPriceLabel", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("myPrice", OBJ_TEXT, 0, CrossTime, CrossPrice);
   ObjectCreate("myPips", OBJ_LABEL, 0, 0, 0);

   IndicatorShortName("Doda-Donchian v2(" + ChannelPeriod + ")");
   SetIndexDrawBegin(0, ChannelPeriod);
   SetIndexDrawBegin(1, ChannelPeriod);

   ObjectCreate("mysl", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("support1", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("support2", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("support3", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("resistance1", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("resistance2", OBJ_LABEL, 0, 0, 0);
   ObjectCreate("resistance3", OBJ_LABEL, 0, 0, 0);
   return (0);
}

int deinit() {
   ObjectDelete("mysl");

   ObjectDelete("myPips");
   ObjectDelete("myPriceLabel");
   ObjectDelete("myHline2");
   ObjectDelete("myVline2");
   ObjectDelete("S1");
   ObjectDelete("S2");
   ObjectDelete("S3");
   ObjectDelete("R1");
   ObjectDelete("R2");
   ObjectDelete("R3");
   ObjectDelete("pivot");
   ObjectDelete("Support 1");
   ObjectDelete("Support 2");
   ObjectDelete("Support 3");
   ObjectDelete("pivot level");
   ObjectDelete("Resistance 1");
   ObjectDelete("Resistance 2");
   ObjectDelete("Resistance 3");
   ObjectDelete("support1");
   ObjectDelete("support2");
   ObjectDelete("support3");
   ObjectDelete("resistance1");
   ObjectDelete("resistance2");
   ObjectDelete("resistance3");
   ObjectDelete("Market_Price_Label");
   ObjectDelete("time");
   return (0);
}

int start() {
   double barvalue[1][6];
   double close;
   double high;
   double low;
   int start;
   double fEndMA;
   double fStartMA;
   double fAngle;
   int digits;
   double k;
   int m,s,l;
   
   ArrayCopyRates(barvalue, Symbol(), PERIOD_D1);
   if (DayOfWeek() == 1) {
      if (TimeDayOfWeek(iTime(Symbol(), PERIOD_D1, 1)) == 5) {
         close = barvalue[1][4];
         high = barvalue[1][3];
         low = barvalue[1][2];
      } else {
         for (int j = 5; j >= 0; j--) {
            if (TimeDayOfWeek(iTime(Symbol(), PERIOD_D1, j)) == 5) {
               close = barvalue[j][4];
               high = barvalue[j][3];
               low = barvalue[j][2];
            }
         }
      }
   } else {
      close = barvalue[1][4];
      high = barvalue[1][3];
      low = barvalue[1][2];
   }
   double rangehl = high - low;
   double pivot = (high + low + close) / 3.0;
   double R3 = pivot + 1.0 * rangehl;
   double R2 = pivot + 0.618 * rangehl;
   double R1 = pivot + rangehl / 2.0;
   double S1 = pivot - rangehl / 2.0;
   double S2 = pivot - 0.618 * rangehl;
   double S3 = pivot - 1.0 * rangehl;
   drawLine(R3, "R3", DarkGreen, 0);
   drawLabel("Resistance 3", R3, DarkGreen);
   drawLine(R2, "R2", ForestGreen, 0);
   drawLabel("Resistance 2", R2, ForestGreen);
   drawLine(R1, "R1", Green, 0);
   drawLabel("Resistance 1", R1, Green);
   drawLine(pivot, "pivot", pivotColor, 0);
   drawLabel("Pivot level", pivot, pivotlevelColor);
   drawLine(S1, "S1", Red, 0);
   drawLabel("Support 1", S1, Red);
   drawLine(S2, "S2", Crimson, 0);
   drawLabel("Support 2", S2, Crimson);
   drawLine(S3, "S3", Maroon, 0);
   drawLabel("Support 3", S3, Maroon);
   int counted_indicators = IndicatorCounted();
   if (Bars <= ChannelPeriod) return (0);
   if (counted_indicators >= ChannelPeriod) start = Bars - counted_indicators - 1;
   else start = Bars - ChannelPeriod - 1;
   BuyBuffer[0] = 0;
   SellBuffer[0] = 0;
   for (int i = start; i >= 0; i--) {
      UpperLine[i] = High[iHighest(NULL, 0, MODE_HIGH, ChannelPeriod, i)];
      LowerLine[i] = Low[iLowest(NULL, 0, MODE_LOW, ChannelPeriod, i)];
      MidLine[i] = (UpperLine[i] + LowerLine[i]) / 2.0;
      fEndMA = iMA(NULL, 0, EMAPeriod, 0, MODE_EMA, PRICE_MEDIAN, i + EndEMAShift);
      fStartMA = iMA(NULL, 0, EMAPeriod, 0, MODE_EMA, PRICE_MEDIAN, i + StartEMAShift);
      fAngle = 10000.0 * (fEndMA - fStartMA) / (StartEMAShift - EndEMAShift);
      if (UpperLine[i + 1] < High[i] && fAngle > AngleTreshold) BuyBuffer[i] = High[i];
      if (LowerLine[i + 1] > Low[i] && fAngle < (-AngleTreshold)) SellBuffer[i] = Low[i];
      
      if (Close[i] > MidLine[i] && BuySignal == FALSE) {
         signalcondition = TRUE;
         CrossPrice = Close[i];
         CrossTime = Time[i];
         BuySignal = TRUE;
         SellSignal = FALSE;
      }
      if (Close[i] < MidLine[i] && SellSignal == FALSE) {
         signalcondition = FALSE;
         CrossPrice = Close[i];
         CrossTime = Time[i];
         BuySignal = FALSE;
         SellSignal = TRUE;
      }
   }
   if (signalcondition == TRUE) {
      ObjectDelete("myHline2");
      ObjectDelete("myVline2");
      ObjectCreate("myHline2", OBJ_HLINE, 0, CrossTime, CrossPrice, 0, 0);
      ObjectCreate("myVline2", OBJ_VLINE, 0, CrossTime, CrossPrice, 0, 0);
      ObjectSet("myHline2", OBJPROP_COLOR, LimeGreen);
      ObjectSet("myVline2", OBJPROP_COLOR, LimeGreen);
      ObjectSetText("myPrice", StringConcatenate("", CrossPrice), 18, "Arial", LimeGreen);
      ObjectSetText("myPriceLabel", StringConcatenate("Buy Price @: ", DoubleToStr(CrossPrice, Digits)), 10, "Arial", LimeGreen);
      ObjectSet("myPriceLabel", OBJPROP_XDISTANCE, 2);
      ObjectSet("myPriceLabel", OBJPROP_YDISTANCE, 40);
      ObjectSet("myPriceLabel", OBJPROP_CORNER, Corner);
      if (Symbol() == "AUDNZD" || Symbol() == "GBPAUD" || Symbol() == "EURAUD" || Symbol() == "EURCAD") ObjectSetText("myPips", StringConcatenate("Profit in Pips: ", NormalizeDouble(Close[0] - CrossPrice, Digits) / Point), 10, "Arial", LimeGreen);
      else ObjectSetText("myPips", StringConcatenate("Profit in Pips: ", NormalizeDouble(Close[0] - CrossPrice, Digits) / Point), 10, "Arial", LimeGreen);
      ObjectSet("myPips", OBJPROP_XDISTANCE, 2);
      ObjectSet("myPips", OBJPROP_YDISTANCE, 56);
      ObjectSet("myPips", OBJPROP_CORNER, Corner);
      dbl2str = DoubleToStr(CrossPrice, Digits);
      str_concat = StringConcatenate("Profit in Pips: ", NormalizeDouble(Close[0] - CrossPrice, Digits) / Point / 10.0);
   }
   if (signalcondition == FALSE) {
      ObjectDelete("myHline2");
      ObjectDelete("myVline2");
      ObjectCreate("myHline2", OBJ_HLINE, 0, CrossTime, CrossPrice, 0, 0);
      ObjectCreate("myVline2", OBJ_VLINE, 0, CrossTime, CrossPrice, 0, 0);
      ObjectSet("myHline2", OBJPROP_COLOR, Red);
      ObjectSet("myVline2", OBJPROP_COLOR, Red);
      ObjectSetText("myPrice", StringConcatenate("", CrossPrice), 18, "Arial", Red);
      ObjectSetText("myPriceLabel", StringConcatenate("Sell Price @: ", DoubleToStr(CrossPrice, Digits)), 10, "Arial", Red);
      ObjectSet("myPriceLabel", OBJPROP_XDISTANCE, 2);
      ObjectSet("myPriceLabel", OBJPROP_YDISTANCE, 40);
      ObjectSet("myPriceLabel", OBJPROP_CORNER, Corner);
      if (Symbol() == "AUDNZD" || Symbol() == "GBPAUD" || Symbol() == "EURAUD" || Symbol() == "EURCAD") ObjectSetText("myPips", StringConcatenate("Profit in Pips: ", NormalizeDouble(CrossPrice - Close[0], Digits) / Point), 10, "Arial", Red);
      else ObjectSetText("myPips", StringConcatenate("Profit in Pips: ", NormalizeDouble(CrossPrice - Close[0], Digits) / Point), 10, "Arial", Red);
      ObjectSet("myPips", OBJPROP_XDISTANCE, 2);
      ObjectSet("myPips", OBJPROP_YDISTANCE, 56);
      ObjectSet("myPips", OBJPROP_CORNER, Corner);
      dbl2str = DoubleToStr(CrossPrice, Digits);
      str_concat = StringConcatenate("Profit in Pips: ", NormalizeDouble(CrossPrice - Close[0], Digits) / Point / 10.0);
   }

   ObjectSetText("mysl", "Stop Loss: " + DoubleToStr(MidLine[0], Digits), 10, "Arial", StopLossColor);
   ObjectSet("mysl", OBJPROP_XDISTANCE, 2);
   ObjectSet("mysl", OBJPROP_YDISTANCE, 70);
   ObjectSet("mysl", OBJPROP_CORNER, Corner);
   ObjectSetText("support1", "Support1: " + DoubleToStr(S1, Digits), 10, "Arial", Red);
   ObjectSet("support1", OBJPROP_XDISTANCE, 2);
   ObjectSet("support1", OBJPROP_YDISTANCE, 130);
   ObjectSet("support1", OBJPROP_CORNER, Corner);
   ObjectSetText("support2", "Support2: " + DoubleToStr(S2, Digits), 10, "Arial", Red);
   ObjectSet("support2", OBJPROP_XDISTANCE, 2);
   ObjectSet("support2", OBJPROP_YDISTANCE, 145);
   ObjectSet("support2", OBJPROP_CORNER, Corner);
   ObjectSetText("support3", "Support3: " + DoubleToStr(S3, Digits), 10, "Arial", Red);
   ObjectSet("support3", OBJPROP_XDISTANCE, 2);
   ObjectSet("support3", OBJPROP_YDISTANCE, 160);
   ObjectSet("support3", OBJPROP_CORNER, Corner);
   ObjectSetText("resistance1", "Resistance1: " + DoubleToStr(R1, Digits), 10, "Arial", ForestGreen);
   ObjectSet("resistance1", OBJPROP_XDISTANCE, 2);
   ObjectSet("resistance1", OBJPROP_YDISTANCE, 85);
   ObjectSet("resistance1", OBJPROP_CORNER, Corner);
   ObjectSetText("resistance2", "Resistance2: " + DoubleToStr(R2, Digits), 10, "Arial", ForestGreen);
   ObjectSet("resistance2", OBJPROP_XDISTANCE, 2);
   ObjectSet("resistance2", OBJPROP_YDISTANCE, 100);
   ObjectSet("resistance2", OBJPROP_CORNER, Corner);
   ObjectSetText("resistance3", "Resistance3: " + DoubleToStr(R3, Digits), 10, "Arial", ForestGreen);
   ObjectSet("resistance3", OBJPROP_XDISTANCE, 2);
   ObjectSet("resistance3", OBJPROP_YDISTANCE, 115);
   ObjectSet("resistance3", OBJPROP_CORNER, Corner);
   Comment("Doda-Donchian v2 mod by isulistiawan");
   
   
   //---Market Price start

   if (Bid_Ask_Colors==True)
     {
      if (Bid > Old_Price) FontColorPrice=Lime;
      if (Bid < Old_Price) FontColorPrice=Red;
      Old_Price=Bid;
     }
     
   
   string sub=StringSubstr(Symbol(), 3, 3);
   if(sub == "JPY") digits = 2;
   else digits = 4;
   
  
   string Market_Price=DoubleToStr(Bid, digits);
  
      
   ObjectCreate("Market_Price_Label", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Market_Price_Label", Market_Price, FontSizePrice, FontType, FontColorPrice);
   ObjectSet("Market_Price_Label", OBJPROP_CORNER, Corner);
   ObjectSet("Market_Price_Label", OBJPROP_XDISTANCE, XDistance+15);
   ObjectSet("Market_Price_Label", OBJPROP_YDISTANCE, YDistance);
   
   //--Candle Time
   

   m=Time[0]+Period()*60-CurTime();
   k=m/60.0;
   s=m%60;
   m=(m-m%60)/60;
//   Comment( m + " minutes " + s + " seconds left to bar end");
	
	
   ObjectDelete("time");
   
   if(ObjectFind("time") != 0)
   {
   ObjectCreate("time", OBJ_TEXT, 0, Time[0], Close[0]+ 0.0005);
   ObjectSetText("time", "                       "+m+":"+s, 10, "Rockwell", CandleTimeColor);
   }
   else
   {
   ObjectMove("time", 0, Time[0], Close[0]+0.0005);
   }
   
   
   return (0);
}

void drawLabel(string linename, double a_price_8, color colorline) {
   if (ObjectFind(linename) != 0) {
      ObjectCreate(linename, OBJ_TEXT, 0, Time[10], a_price_8);
      ObjectSetText(linename, linename, 8, "Arial", CLR_NONE);
      ObjectSet(linename, OBJPROP_COLOR, colorline);
      return;
   }
   ObjectMove(linename, 0, Time[10], a_price_8);
}

void drawLine(double priceline, string drawline, color colorline, int ai_20) {
   if (ObjectFind(drawline) != 0) {
      ObjectCreate(drawline, OBJ_HLINE, 0, Time[0], priceline, Time[0], priceline);
      if (ai_20 == 1) ObjectSet(drawline, OBJPROP_STYLE, STYLE_SOLID);
      else ObjectSet(drawline, OBJPROP_STYLE, STYLE_DOT);
      ObjectSet(drawline, OBJPROP_COLOR, colorline);
      ObjectSet(drawline, OBJPROP_WIDTH, 1);
      return;
   }
   ObjectDelete(drawline);
   ObjectCreate(drawline, OBJ_HLINE, 0, Time[0], priceline, Time[0], priceline);
   if (ai_20 == 1) ObjectSet(drawline, OBJPROP_STYLE, STYLE_SOLID);
   else ObjectSet(drawline, OBJPROP_STYLE, STYLE_DOT);
   ObjectSet(drawline, OBJPROP_COLOR, colorline);
   ObjectSet(drawline, OBJPROP_WIDTH, 1);
}