//+------------------------------------------------------------------+
//|                                                                  |
//|                 Copyright © 1999-2008, MetaQuotes Software Corp. |
//|                                         http://www.metaquotes.ru |
//+------------------------------------------------------------------+
#property link "jpygbp@yahoo.com"
#property indicator_buffers 5
#property indicator_separate_window
//----
#property indicator_color1 HotPink //macd
#property indicator_color2 Lime    //signal
#property indicator_color3 Gray    //histogram
#property indicator_color4 Blue    //macd[1]
#property indicator_color5 Black   //zero line
//---- buffers
double Buffer1[]; //macd
double Buffer2[]; //signal
double Buffer3[]; //histogram
double Buffer4[]; //macd[1]
double Buffer5[]; //zero line
//----
extern int FastEMA=9;
extern int SlowEMA=64;
extern int SignalSMA=112;
//extern bool plotMACD = true;
//extern bool plotSignalLine = true;
//extern bool plotHistogram = true;
//extern bool plotMACDOneBarAgo = true;
//extern bool plotZeroLine = true;
extern bool plotArrows=false;
extern double HistThreshold=0;
//----
int limit=0;
int fontsize=10;
int i=0;
bool InLTrade=false;
bool InSTrade=false;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   ObjectsDeleteAll();
//---- indicators
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,2);//macd
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,2);//signal
   SetIndexStyle(2,DRAW_HISTOGRAM,STYLE_SOLID,2);//hist
   SetIndexStyle(3,DRAW_LINE,STYLE_SOLID,2);//macd[1]
   SetIndexStyle(4,DRAW_LINE,STYLE_SOLID,1);//zero
   //
   SetIndexBuffer(0,Buffer1);
   SetIndexBuffer(1,Buffer2);
   SetIndexBuffer(2,Buffer3);
   SetIndexBuffer(3,Buffer4);
   SetIndexBuffer(4,Buffer5);
   //
   SetIndexDrawBegin(1,SignalSMA);
   //
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS)+1);
   //
   IndicatorShortName("MACD("+FastEMA+","+SlowEMA+","+SignalSMA+")");
   //
   SetIndexLabel(0,"MACD");
   SetIndexLabel(1,"Signal");
   SetIndexLabel(2,"Histogram");
   SetIndexLabel(3,"MACD[1]");
   SetIndexLabel(4,"Zero");
   //----
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string NewArrow(datetime T1, double P1, color collor)
  {
   string N=StringConcatenate("A",collor,"-",TimeToStr(T1));
   int AC=SYMBOL_STOPSIGN;
   if(collor==Blue)
      AC=SYMBOL_ARROWUP;
   if(collor==Red)
      AC=SYMBOL_ARROWDOWN;
   //----
   ObjectCreate(N, OBJ_ARROW, 0, T1, P1);
   ObjectSet(N, OBJPROP_ARROWCODE, AC);
   ObjectSet(N, OBJPROP_COLOR, collor);
   ObjectSet(N, OBJPROP_WIDTH, 1);
   ObjectsRedraw();
   return(N);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectsRedraw();
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);//---- check for possible errors
   if(counted_bars>0) counted_bars--;//---- last counted bar will be recounted
   limit=Bars-counted_bars;
   //----
   for(i=0; i<limit; i++)//---- macd counted in the 1-st buffer histogram
      Buffer1[i]=iMA(NULL,0,FastEMA,0,MODE_EMA,PRICE_CLOSE,i)-iMA(NULL,0,SlowEMA,0,MODE_EMA,PRICE_CLOSE,i);
   //----
   for(i=0; i<limit; i++)//---- signal line counted in the 2-nd buffer line
      Buffer2[i]=iMAOnArray(Buffer1,Bars,SignalSMA,0,MODE_SMA,i);
   //----
   for(i=0; i<limit; i++)//---- histogram is the difference between macd and signal line
     {
      Buffer3[i]=Buffer1[i]-Buffer2[i];
      Buffer5[i]=0;
     }
   //----
   for(i=1; i<limit; i++)//---- macd[1]
      Buffer4[i]=iMA(NULL,0,FastEMA,0,MODE_EMA,PRICE_CLOSE,i-1)-iMA(NULL,0,SlowEMA,0,MODE_EMA,PRICE_CLOSE,i-1);
   //----
   if (plotArrows)
     {
      ObjectsDeleteAll();
      InLTrade=false;
      InSTrade=false;
      for(int i=Bars;i>=0;i--)
        {
         if ((Buffer3[i-1]  > 0) && (Buffer3[i] < 0) && Buffer3[i-1] > HistThreshold)//Long Begin
           {
            string upArrow1=NewArrow(Time[i-1], High[i-1]+0.0005, Blue);
            InLTrade=true;
           }
         if ((Buffer3[i-1]  < 0) && (Buffer3[i] > 0) && Buffer3[i-1] < -HistThreshold)//Short Begin
           {
            string dnArrow1=NewArrow(Time[i-1], Low[i-1]-0.0003, Red);
            InSTrade=true;
            InLTrade=false;
           }
         if ((InSTrade ==true) && (Buffer3[i-1] > Buffer3[i]))//Short End
           {
            string upArrow2=NewArrow(Time[i-1], Low[i-1]-0.0003, Aqua);
            InSTrade=false;
           }
         if ((InLTrade==true) && (Buffer3[i-1] < Buffer3[i]))//Long End
           {
            string dnArrow2=NewArrow(Time[i-1], High[i-1]+0.0005, Aqua);
            InLTrade=false;
           }
        }
     }
   //----
   return(0);
  }
//+------------------------------------------------------------------+