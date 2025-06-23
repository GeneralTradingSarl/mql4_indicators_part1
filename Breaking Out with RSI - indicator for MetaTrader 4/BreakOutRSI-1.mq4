//+------------------------------------------------------------------+
//|                                                BreakOutRSI-1.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+

#property indicator_chart_window

      double RSI;
      int    i, Dig, Trend;
      double AvgHighs, AvgLows;
      string TrendTxt, RSIState;
      color  TrendColor;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init(){}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
      Comment("");
      ObjectDelete("Trend");
      ObjectDelete("BrLong");
      ObjectDelete("BrShort");
      ObjectDelete("RSI");
      ObjectDelete("B-Range");
      ObjectDelete("B-Range2");
      ObjectDelete("A-Range");
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
      if(Close[0]>10)  {Dig=3; }  else
      if(Close[0]<10)  {Dig=5; }

      RSI  = iRSI(NULL,0,14,PRICE_OPEN,0);   

      double Top    = iHigh(NULL,0,iHighest(NULL,0,MODE_HIGH,16,1));
      double Bottom = iLow (NULL,0,iLowest (NULL,0,MODE_LOW, 16,1));
   
      AvgHighs = (High[1]+High[2]+High[3]+High[4]+High[5]+High[6]+High[7]+High[8]+High[9]+High[10]+High[11]+High[12]+High[13]+High[14]+High[15]+High[16])/16;
      AvgLows = (Low[1]+Low[2]+Low[3]+Low[4]+Low[5]+Low[6]+Low[7]+Low[8]+Low[9]+Low[10]+Low[11]+Low[12]+Low[13]+Low[14]+Low[15]+Low[16])/16;

         ObjectDelete("B-Range");
         ObjectCreate("B-Range", OBJ_RECTANGLE, 0, 0,0, 0,0);
         ObjectSet   ("B-Range", OBJPROP_STYLE, STYLE_SOLID);
         ObjectSet   ("B-Range", OBJPROP_COLOR, C'128,60,0');
         ObjectSet   ("B-Range", OBJPROP_BACK,  false);
         ObjectSet   ("B-Range", OBJPROP_TIME1 ,Time[17]);
         ObjectSet   ("B-Range", OBJPROP_PRICE1,Top);
         ObjectSet   ("B-Range", OBJPROP_TIME2 ,Time[0]+Time[0]-Time[1]);
         ObjectSet   ("B-Range", OBJPROP_PRICE2,Bottom);

         ObjectDelete("B-Range2");
         ObjectCreate("B-Range2", OBJ_RECTANGLE, 0, 0,0, 0,0);
         ObjectSet   ("B-Range2", OBJPROP_STYLE, STYLE_SOLID);
         ObjectSet   ("B-Range2", OBJPROP_COLOR, C'128,60,0');
         ObjectSet   ("B-Range2", OBJPROP_BACK,  true);
         ObjectSet   ("B-Range2", OBJPROP_TIME1 ,Time[0]+Time[0]-Time[1]);
         ObjectSet   ("B-Range2", OBJPROP_PRICE1,Top);
         ObjectSet   ("B-Range2", OBJPROP_TIME2 ,Time[0]+Time[0]-Time[2]);
         ObjectSet   ("B-Range2", OBJPROP_PRICE2,Bottom);

         ObjectDelete("A-Range");
         ObjectCreate("A-Range", OBJ_RECTANGLE, 0, 0,0, 0,0);
         ObjectSet   ("A-Range", OBJPROP_STYLE, STYLE_SOLID);
         ObjectSet   ("A-Range", OBJPROP_COLOR, C'75,50,50');
         ObjectSet   ("A-Range", OBJPROP_BACK,  true);
         ObjectSet   ("A-Range", OBJPROP_TIME1 ,Time[0]+Time[0]-Time[1]);
         ObjectSet   ("A-Range", OBJPROP_PRICE1,AvgHighs);
         ObjectSet   ("A-Range", OBJPROP_TIME2 ,Time[0]+Time[0]-Time[2]);
         ObjectSet   ("A-Range", OBJPROP_PRICE2,AvgLows);
  

      if (Close[0]>=Top) {Trend=2;}
      if (Close[0]>=AvgHighs && Close[0]<Top) {Trend=1;}
      if (Close[0]<AvgHighs && Close[0]>AvgLows) {Trend=0;}
      if (Close[0]<=AvgLows && Close[0]>Bottom) {Trend=-1;}
      if (Close[0]<=Bottom) {Trend=-2;}
      if (Trend==2){TrendTxt="Breaking-out Upwards";TrendColor=Aqua;}
      if (Trend==1){TrendTxt="Trending Up";TrendColor=Aqua;}
      if (Trend==0){TrendTxt="Range Bound";TrendColor=White;}
      if (Trend==-1){TrendTxt="Trending Down";TrendColor=Red;}
      if (Trend==-2){TrendTxt="Breaking-out Downwards";TrendColor=Red;}
      if (Trend==1 || Trend == 2 && RSI >=50)
         {RSIState="Favourable";}
         else if (Trend==-1 || Trend==-2 && RSI < 50)
                   {RSIState="Favourable";}
                    else if (Trend ==0){RSIState="";}
      else RSIState="Unfavourable";
      
      Comment(
   
       "\n"+"\n"+
       RSIState+" RSI:"+"\n"+
       "Breakout Long:"+"\n"+       
       "Breakout Short:"
          );                

      ObjectCreate("Trend", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("Trend",TrendTxt,12,"Arial Black", TrendColor);
      ObjectSet("Trend", OBJPROP_CORNER, 0);
      ObjectSet("Trend", OBJPROP_XDISTANCE, 4);
      ObjectSet("Trend", OBJPROP_YDISTANCE, 13);

      ObjectCreate("RSI", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("RSI",DoubleToStr(RSI,1),8,"Arial Black", White);
      ObjectSet("RSI", OBJPROP_CORNER, 0);
      ObjectSet("RSI", OBJPROP_XDISTANCE, 90);
      ObjectSet("RSI", OBJPROP_YDISTANCE, 34);

      ObjectCreate("BrLong", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("BrLong",DoubleToStr(Top,Dig),8,"Arial Black", Red);
      ObjectSet("BrLong", OBJPROP_CORNER, 0);
      ObjectSet("BrLong", OBJPROP_XDISTANCE, 90);
      ObjectSet("BrLong", OBJPROP_YDISTANCE, 47);

      ObjectCreate("BrShort", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("BrShort",DoubleToStr(Bottom,Dig),8,"Arial Black", Red);
      ObjectSet("BrShort", OBJPROP_CORNER, 0);
      ObjectSet("BrShort", OBJPROP_XDISTANCE, 90);
      ObjectSet("BrShort", OBJPROP_YDISTANCE, 58);

  return(0);
  }
//+------------------------------------------------------------------+