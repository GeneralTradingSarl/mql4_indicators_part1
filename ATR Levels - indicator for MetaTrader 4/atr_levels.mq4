//+------------------------------------------------------------------+
//|                                                   ATR Marks.mq4  |
//|                                                   Bill Jones     |
//|                                            Colorado Springs, CO  |
//+------------------------------------------------------------------+
#property copyright "2014 - Bill Jones"

#property indicator_chart_window
//----
input int ATRPeriod=14;     // ATR Period Parameter
//----
double   H4,L4,fullatr,shiftnbr;
int      dayshift,dayshiftold=-1;
int      NbrDigits;
bool     ErrFlag=true;      // True = print an error
datetime OldBar=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete("ATRHigh Line");
   ObjectDelete("ATRLow Line");
   ObjectDelete("ATR Label");
   ObjectDelete("ATRDay Line");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   if(IndicatorCounted() < 1) return(0);
   if(Time[0] == OldBar)      return(0);
   OldBar=Time[0];

//----
   if(Period()>1440) // Day chart is the largest to display values on.
     {
      if(ErrFlag)
        {
         ErrFlag=false;
         Print("Error - Chart period is greater than 1 day.");
        }
      return(-1); // then exit
     }
   NbrDigits=Digits-1;    // Digits must be either 3 or 5.  2 & 4 Digit accounts do not work here.
   if(NbrDigits>2)
      shiftnbr=10000;
   else
      shiftnbr=100;

   int BarsPerChart=WindowBarsPerChart()-5;         // Don't check all of the bars

   dayshift=0;
   while(dayshift<BarsPerChart)
     {
      if(TimeToStr(Time[dayshift],TIME_MINUTES)=="22:00") break;  // Find the 5pm NY bar.
      dayshift++;
     }

   if(dayshift == dayshiftold) return(0);
   dayshiftold = dayshift;

   ObjectDelete("ATRHigh Line");
   ObjectDelete("ATRLow Line");
   ObjectDelete("ATR Label");
   ObjectDelete("ATRDay Line");

   fullatr=iATR(Symbol(),PERIOD_D1,ATRPeriod,1);
   L4 = Close[dayshift] - fullatr;
   H4 = Close[dayshift] + fullatr;
//----

//----
   if(ObjectFind("ATRDay Line")!=0)
     {
      ObjectCreate("ATRDay Line",OBJ_VLINE,0,Time[dayshift],0);
      ObjectSet("ATRDay Line",OBJPROP_COLOR,Red);
      ObjectSet("ATRDay Line",OBJPROP_WIDTH,1);
     }

//----
   if(ObjectFind("ATRHigh Line")!=0)
     {
      ObjectCreate("ATRHigh Line",OBJ_TREND,0,Time[dayshift],H4,Time[0],H4);
      ObjectSet("ATRHigh Line",OBJPROP_COLOR,Red);
      ObjectSet("ATRHigh Line",OBJPROP_WIDTH,1);
     }

//----
   if(ObjectFind("ATRLow Line")!=0)
     {
      ObjectCreate("ATRLow Line",OBJ_TREND,0,Time[dayshift],L4,Time[0],L4);
      ObjectSet("ATRLow Line",OBJPROP_COLOR,Red);
      ObjectSet("ATRLow Line",OBJPROP_WIDTH,1);
     }

//----
   if(ObjectFind("ATR Label")!=0)
     {
      ObjectCreate("ATR Label",OBJ_TEXT,0,Time[dayshift+5],H4);
      ObjectSetText("ATR Label","ATR: "+DoubleToStr((fullatr*shiftnbr),0),10,"Verdana",White);
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
