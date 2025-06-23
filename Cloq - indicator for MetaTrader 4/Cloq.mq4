//+------------------------------------------------------------------+
//|                                                         Cloq.mq4 |
//|                                                      Derk Wehler |
//|                                             derkwehler@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Derk Wehler"
#property link      "derkwehler@gmail.com"
//=============================================================================
// Instructions
//   CloqCorner   - 0 = top left, 1 = top right, 2 = bottom left, 3 = bottom right
//   DispGMT      - Display GMT Time
//   DispLocal	   - Display Local Time
//   DispLondon	- Display London Time
//   DispTokyo	   - Display Tokyo Time
//   DispNY		   - Display New York Time
//   DispBroker	- Display Brokers Time
//   LabelColor	- Color of city label
//   ClockColor	- Color of clock
//==============================================================================
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red
//----
extern int         CloqCorner   =2;
extern bool         DispGMT     =true;
extern bool         DispLocal  =true;
extern bool         DispLondon  =false;
extern bool         DispTokyo  =false;
extern bool         DispNY     =false;
extern bool         DispBroker  =true;
extern color        LabelColor  =Black;
extern color        ClockColor  =Black;
//----
int   Offset=100;
//---- buffers
double ExtMapBuffer1[];
int LondonTZ  =-1;
int TokyoTZ  =8;
int NewYorkTZ   =-5;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   if (IsDST())
      TokyoTZ+=0;
//----
   Print("TimeZoneLocal: ",TimeZoneLocal());
   Print("TimeZoneServer: ",TimeZoneServer());
   datetime brokerTime  =TimeCurrent();
   datetime GMT      =TimeGMT();
   datetime local      =TimeLocal();
   datetime london   =GMT + (LondonTZ  * 3600);
   datetime tokyo      =GMT + (TokyoTZ   * 3600);
   datetime newyork   =GMT + (NewYorkTZ * 3600);
//----
   string GMTs   =TimeToStr(GMT,          TIME_MINUTES);
   string locals   =TimeToStr(TimeLocal(),    TIME_MINUTES);
   string londons   =TimeToStr(london,       TIME_MINUTES);
   string tokyos   =TimeToStr(tokyo,          TIME_MINUTES);
   string newyorks=TimeToStr(newyork,       TIME_MINUTES);
   string brokers   =TimeToStr(TimeCurrent(),    TIME_MINUTES);
//----
   if (DispLocal)
     {
      ObjectSetText( "locl", "Local:", 10, "Arial", LabelColor );
      ObjectSetText( "loct", locals, 10, "Arial", ClockColor );
     }
   if (DispGMT)
     {
      ObjectSetText( "gmtl", "GMT", 10, "Arial", LabelColor );
      ObjectSetText( "gmtt", GMTs, 10, "Arial", ClockColor );
     }
   if (DispNY)
     {
      ObjectSetText( "nyl", "New York:", 10, "Arial", LabelColor );
      ObjectSetText( "nyt", newyorks, 10, "Arial", ClockColor );
     }
   if (DispLondon)
     {
      ObjectSetText( "lonl", "London:", 10, "Arial", LabelColor );
      ObjectSetText( "lont", londons, 10, "Arial", ClockColor );
     }
   if (DispTokyo)
     {
      ObjectSetText( "tokl", "Tokyo:", 10, "Arial", LabelColor );
      ObjectSetText( "tokt", tokyos, 10, "Arial", ClockColor );
     }
   if (DispBroker)
     {
      ObjectSetText( "brol", "Broker:", 10, "Arial", LabelColor );
      ObjectSetText( "brot", brokers, 10, "Arial", ClockColor );
     }

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ObjectMakeLabel(string n, int xoff, int yoff)
  {
   ObjectCreate(n, OBJ_LABEL, 0, 0, 0);
   ObjectSet(n, OBJPROP_CORNER, CloqCorner);
   ObjectSet(n, OBJPROP_XDISTANCE, xoff);
   ObjectSet(n, OBJPROP_YDISTANCE, yoff);
   ObjectSet(n, OBJPROP_BACK, true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, ExtMapBuffer1);
//----
   int top=Offset;
   if (DispLocal)
     {
      ObjectMakeLabel("locl", 90, top );
      ObjectMakeLabel("loct", 45, top );
      top-=15;
     }
   if (DispGMT)
     {
      ObjectMakeLabel("gmtl", 90, top );
      ObjectMakeLabel("gmtt", 45, top );
      top-=15;
     }
   if (DispNY)
     {
      ObjectMakeLabel("nyl", 90, top );
      ObjectMakeLabel("nyt", 45, top );
      top-=15;
     }
   if (DispLondon)
     {
      ObjectMakeLabel("lonl", 90, top );
      ObjectMakeLabel("lont", 45, top );
      top-=15;
     }
   if (DispTokyo)
     {
      ObjectMakeLabel("tokl", 90, top );
      ObjectMakeLabel("tokt", 45, top );
      top-=15;
     }
   if (DispBroker)
     {
      ObjectMakeLabel("brol", 90, top );
      ObjectMakeLabel("brot", 45, top );
     }
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete( "locl" );
   ObjectDelete( "loct" );
   ObjectDelete( "nyl" );
   ObjectDelete( "nyt" );
   ObjectDelete( "gmtl" );
   ObjectDelete( "gmtt" );
   ObjectDelete( "lonl" );
   ObjectDelete( "lont" );
   ObjectDelete( "tokl" );
   ObjectDelete( "tokt" );
   ObjectDelete( "brol" );
   ObjectDelete( "brot" );
   return(0);
  }
//=================================================================================================
//===================================   Timezone Functions   ======================================
//=================================================================================================
#import "kernel32.dll"
int  GetTimeZoneInformation(int& TZInfoArray[]);
#import
//----
#define TIME_ZONE_ID_UNKNOWN   0
#define TIME_ZONE_ID_STANDARD  1
#define TIME_ZONE_ID_DAYLIGHT  2
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsDST()   // DST is the one over the winter
  {
   int TZInfoArray[43];
   switch(GetTimeZoneInformation(TZInfoArray))
     {
      case TIME_ZONE_ID_UNKNOWN:
         Print("WARNING: TIMEZONE ID UNKNOWN, Cloq may give wrong time!  Returning FALSE");
         return(false);
      case TIME_ZONE_ID_STANDARD:
         Print("TZ ---> STANDARD");
         return(false);
      case TIME_ZONE_ID_DAYLIGHT:
         Print("TZ ---> DAYLIGHT SAVINGS");
         return(true);
      default:
         Print("Unkown return value from GetTimeZoneInformation in kernel32.dll. Returning FALSE");
         return(false);
     }
  }
// Local timezone in hours, adjusting for daylight saving
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TimeZoneLocal()
  {
   int TZInfoArray[43];
   switch(GetTimeZoneInformation(TZInfoArray))
     {
      case TIME_ZONE_ID_UNKNOWN:
         Print("Error obtaining PC timezone from GetTimeZoneInformation in kernel32.dll. Returning 0");
         return(0);
      case TIME_ZONE_ID_STANDARD:
         //		Print("PC timezone is STANDARD");
         return(TZInfoArray[0]/(-60.0));
      case TIME_ZONE_ID_DAYLIGHT:
         //		Print("PC timezone is DAYLIGHT");
         return((TZInfoArray[0]+TZInfoArray[42])/(-60.0));
      default:
         Print("Unkown return value from GetTimeZoneInformation in kernel32.dll. Returning 0");
         return(0);
     }
  }
// Server timezone in hours
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TimeZoneServer()
  {
   long ServerToLocalDiffMinutes=(TimeCurrent()-TimeLocal())/60;
   // round to nearest 30 minutes to allow for inaccurate PC clock
   long nHalfHourDiff=(long)MathRound(ServerToLocalDiffMinutes/30.0);
   ServerToLocalDiffMinutes=nHalfHourDiff*30;
   return(TimeZoneLocal() + ServerToLocalDiffMinutes/60.0);
  }
// Uses local PC time, local PC timezone, and server time to calculate GMT time at arrival of last tick
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*datetime _TimeGMT()
  {
   // two ways of calculating
   // 1. From PC time, which may not be accurate
   // 2. From server time. Most accurate except when server is down on weekend
   datetime dtGmtFromLocal=TimeLocal() - (datetime)(TimeZoneLocal()*3600);
   datetime dtGmtFromServer=TimeCurrent() - (datetime)(TimeZoneServer()*3600);
//----
   Print("TimeZoneLocal returned: ", TimeZoneLocal());
   // return local-derived value if server value is out by more than 5 minutes, eg during weekend
   if (dtGmtFromLocal > dtGmtFromServer + 300)
     {
      return(dtGmtFromLocal);
     }
   else
     {
      return(dtGmtFromServer);
     }
  }*/
//+------------------------------------------------------------------+