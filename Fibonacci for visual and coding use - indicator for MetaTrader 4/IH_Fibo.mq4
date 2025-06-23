//+------------------------------------------------------------------+
//|                                                      IH_Fibo.mq4 |
//|                                 Copyright © 2010,Investors Haven |
//|                                    http://www.InvestorsHaven.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010,Investors Haven"
#property link      "http://www.InvestorsHaven.com"

#property indicator_chart_window
#property indicator_buffers 8


double   Retrace382 = 0.0;
double   Retrace50 = 0.0;
double   Retrace618 = 0.0;
double   Extend1382 = 0.0;
double   Extend1618 = 0.0;
datetime PrevTime = 0;
// buffers
double FibHigh[];
double FibLow[];
double FibTrend[];
double FibRetrace382[];
double FibRetrace50[];
double FibRetrace618[];
double FibExtend1382[];
double FibExtend1618[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   datetime PrevTime = 0;
   ObjectCreate("High", OBJ_HLINE, 0,0,0);
   ObjectSet("High", OBJPROP_WIDTH, 2);
   ObjectSet("High", OBJPROP_STYLE, STYLE_SOLID);   
   ObjectSet("High",OBJPROP_COLOR, Turquoise);
   ObjectCreate("Low", OBJ_HLINE, 0,0,0); 
   ObjectSet("Low", OBJPROP_WIDTH, 2);
   ObjectSet("Low", OBJPROP_STYLE, STYLE_SOLID);      
   ObjectSet("Low",OBJPROP_COLOR, Turquoise); 
   ObjectCreate("Trend", OBJ_TREND, 0,0,0); 
   ObjectSet("Trend", OBJPROP_RAY, true);
   ObjectSet("Trend", OBJPROP_WIDTH, 1);
   ObjectSet("Trend", OBJPROP_STYLE, STYLE_DASH);
   ObjectSet("Trend",OBJPROP_COLOR, Salmon); 
   
   ObjectCreate("Retrace382_Line", OBJ_HLINE, 0,0,0);
   ObjectSet("Retrace382_Line", OBJPROP_WIDTH, 1);
   ObjectSet("Retrace382_Line",OBJPROP_STYLE, STYLE_DOT);
   ObjectSet("Retrace382_Line",OBJPROP_COLOR, Turquoise);
   ObjectCreate("Retrace50_Line", OBJ_HLINE, 0,0,0);      
   ObjectSet("Retrace50_Line", OBJPROP_WIDTH, 1);
   ObjectSet("Retrace50_Line",OBJPROP_STYLE, STYLE_DOT);
   ObjectSet("Retrace50_Line",OBJPROP_COLOR, Turquoise);
   ObjectCreate("Retrace618_Line", OBJ_HLINE, 0,0,0);
   ObjectSet("Retrace618_Line", OBJPROP_WIDTH, 1);   
   ObjectSet("Retrace618_Line",OBJPROP_STYLE, STYLE_DOT);
   ObjectSet("Retrace618_Line",OBJPROP_COLOR, Turquoise);
   ObjectCreate("Extend1382_Line", OBJ_HLINE, 0,0,0);      
   ObjectSet("Extend1382_Line", OBJPROP_WIDTH, 1);
   ObjectSet("Extend1382_Line",OBJPROP_STYLE, STYLE_DOT);
   ObjectSet("Extend1382_Line",OBJPROP_COLOR, Turquoise);
   ObjectCreate("Extend1618_Line", OBJ_HLINE, 0,0,0);
   ObjectSet("Extend1618_Line", OBJPROP_WIDTH, 1);   
   ObjectSet("Extend1618_Line",OBJPROP_STYLE, STYLE_DOT);
   ObjectSet("Extend1618_Line",OBJPROP_COLOR, Turquoise);  

   SetIndexBuffer(0,FibHigh);
   SetIndexBuffer(1,FibLow);
   SetIndexBuffer(2,FibTrend);
   SetIndexBuffer(3,FibRetrace382);
   SetIndexBuffer(4,FibRetrace50);
   SetIndexBuffer(5,FibRetrace618);
   SetIndexBuffer(6,FibExtend1382);
   SetIndexBuffer(7,FibExtend1618);
   



//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
      datetime CurrTime = iTime(Symbol(),0,1);

      if( CurrTime != PrevTime )
      {  
  
         int    counted_bars=IndicatorCounted();
   
         int bar = WindowFirstVisibleBar();
         int shiftLowest = iLowest(NULL, 0, MODE_LOW, bar - 1, 1);
         int shiftHighest = iHighest(NULL, 0, MODE_HIGH, bar - 1, 1);   
         double MyHigh = High[shiftHighest];
         double MyLow = Low[shiftLowest];
         bool isSwingDown = shiftHighest > shiftLowest;

         ObjectSet("High", 1, MyHigh);
         FibHigh[0] = MyHigh;
         ObjectSet("Low", 1, MyLow);
         FibLow[0] = MyLow;

         if (isSwingDown == true)// && Ask > MyLow + 5*PipPoints)
         {
            FibTrend[0] = 2;
            Retrace382 = MyHigh - ((MyHigh - MyLow)* 0.382);
            FibRetrace382[0] = Retrace382;
            Retrace50 =  MyHigh - ((MyHigh - MyLow)* 0.5);
            FibRetrace50[0] = Retrace50;
            Retrace618 = MyHigh - ((MyHigh - MyLow)* 0.618);
            FibRetrace618[0] = Retrace618;
            Extend1382 = MyLow - ((MyHigh - MyLow)* 0.382);
            FibExtend1382[0] = Extend1382;
            Extend1618 = MyLow - ((MyHigh - MyLow)* 0.618);
            FibExtend1618[0] = Extend1618;
            ObjectSet("Trend", 0, Time[shiftHighest]);
            ObjectSet("Trend", 1, MyHigh);
            ObjectSet("Trend", 2, Time[shiftLowest]);
            ObjectSet("Trend", 3, MyLow);
      
            ObjectSet("Retrace382_Line", 1, Retrace382);
            ObjectSet("Retrace50_Line", 1, Retrace50);
            ObjectSet("Retrace618_Line", 1, Retrace618);
            ObjectSet("Extend1382_Line", 1, Extend1382);
            ObjectSet("Extend1618_Line", 1, Extend1618);
      
         }
         else if (isSwingDown == false) // && Bid < MyHigh - 5*PipPoints)
         {
            FibTrend[0] = 1;
            Retrace382 = MyLow + ((MyHigh - MyLow)* 0.382);
            FibRetrace382[0] = Retrace382;
            Retrace50 =  MyLow + ((MyHigh - MyLow)* 0.5);
            FibRetrace50[0] = Retrace50;
            Retrace618 = MyLow + ((MyHigh - MyLow)* 0.618);
            FibRetrace618[0] = Retrace618;
            Extend1382 = MyHigh + ((MyHigh - MyLow)* 0.382);
            FibExtend1382[0] = Extend1382;
            Extend1618 = MyHigh + ((MyHigh - MyLow)* 0.618);
            FibExtend1618[0] = Extend1618;
            ObjectSet("Trend", 0, Time[shiftLowest]);
            ObjectSet("Trend", 1, MyLow);
            ObjectSet("Trend", 2, Time[shiftHighest]);
            ObjectSet("Trend", 3, MyHigh);
      
            ObjectSet("Retrace382_Line", 1, Retrace382);
            ObjectSet("Retrace50_Line", 1, Retrace50);
            ObjectSet("Retrace618_Line", 1, Retrace618);
            ObjectSet("Extend1382_Line", 1, Extend1382);
            ObjectSet("Extend1618_Line", 1, Extend1618);
         }
      }
      PrevTime = Time[0];
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+