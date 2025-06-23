//+------------------------------------------------------------------+
//|                                       Dolly_Trading Times #3.mq4 |
//|                      Copyright © 2006, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
#property link      "Code used from  i-ParamonWorkTime.mq4"
//----
#property indicator_chart_window
//----
extern int    TradingTimes_NumberOfDays=1;
extern string Broker_GMT_Offset        ="02:00";
extern string EUROPE_Open              ="08:00";
extern color  EUROPE_Color             =Purple;
extern color  EUROPE_TEXT_Color        =Violet;
extern bool   Show_EUROPE_Open         =true;
//----
extern string LONDON_Open              ="10:00";
extern color  LONDON_Color             =MidnightBlue;
extern color  LONDON_TEXT_Color        =DodgerBlue;
extern bool   Show_LONDON_Open         =true;
//----
extern string US_Open                  ="15:00";
extern color  US_Color                 =Indigo;
extern color  US_TEXT_Color            =MediumPurple;
extern bool   Show_US_Open             =true;
//----
extern string EUROPE1_Close            ="17:00";
extern color  EUROPE1_Color            =Maroon;
extern color  EUROPE1_TEXT_Color       =Crimson;
extern bool   Show_EUROPE1_Close       =true;
//----
extern bool Show_Daily_Trade_TEXT      =true;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
  void init() 
  {
   DeleteObjects();
     for(int i=0; i<TradingTimes_NumberOfDays; i++) 
     {
      CreateObjects("DollyTIME1"+i, EUROPE_Color);
      CreateObjects("DollyTIME2"+i, LONDON_Color);
      CreateObjects("DollyTIME3"+i, US_Color);
      CreateObjects("DollyTIME4"+i, EUROPE1_Color);
     }
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
  void deinit() 
  {
   DeleteObjects();
   ObjectDelete("TT1");ObjectDelete("TT2");ObjectDelete("TT3");
   ObjectDelete("TT4");ObjectDelete("TT5");ObjectDelete("TT6");
   ObjectDelete("TT7");ObjectDelete("TT8");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  void CreateObjects(string TRADETIMES, color cl) 
  {
   ObjectCreate(TRADETIMES, OBJ_TREND, 0, 0,0, 0,0);
   ObjectSet(TRADETIMES, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet(TRADETIMES, OBJPROP_WIDTH,3);
   ObjectSet(TRADETIMES, OBJPROP_COLOR, cl);
   ObjectSet(TRADETIMES, OBJPROP_BACK, True);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  void DeleteObjects() 
  {
     for(int i=0; i<TradingTimes_NumberOfDays; i++) 
     {
      ObjectDelete("DollyTIME1"+i);
      ObjectDelete("DollyTIME2"+i);
      ObjectDelete("DollyTIME3"+i);
      ObjectDelete("DollyTIME4"+i);
     }
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
void start()
  {
   datetime dt=CurTime();
     for(int i=0; i<TradingTimes_NumberOfDays; i++) 
     {
      if (Show_EUROPE_Open==true)
        {
        DrawObjects(dt, "DollyTIME1"+i, EUROPE_Open, EUROPE_Open);
        }
      if (Show_LONDON_Open==true)
        {
        DrawObjects(dt, "DollyTIME2"+i, LONDON_Open, LONDON_Open);
        }
      if (Show_US_Open==true)
        {
        DrawObjects(dt, "DollyTIME3"+i, US_Open, US_Open);
        }
      if (Show_EUROPE1_Close==true)
        {
        DrawObjects(dt, "DollyTIME4"+i, EUROPE1_Close, EUROPE1_Close);
        }
      dt=decDateTradeDay(dt);
      while(TimeDayOfWeek(dt)>5) dt=decDateTradeDay(dt);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  void DrawObjects(datetime dt, string TRADETIMES, string tb, string te) 
  {
   datetime t1, t2;
   double   p1, p2;
   int      b1, b2;
//----
   t1=StrToTime(TimeToStr(dt, TIME_DATE)+" "+tb);
   t2=StrToTime(TimeToStr(dt, TIME_DATE)+" "+te);
   b1=iBarShift(NULL, 0, t1);
   b2=iBarShift(NULL, 0, t2);
   p1=High[Highest(NULL, 0, MODE_HIGH, b1-b2, b2)];
   p2=Low [Lowest (NULL, 0, MODE_LOW , b1-b2, b2)];
//----
   ObjectSet(TRADETIMES, OBJPROP_TIME1 , t1);
   ObjectSet(TRADETIMES, OBJPROP_PRICE1, p1);
   ObjectSet(TRADETIMES, OBJPROP_TIME2 , t2);
   ObjectSet(TRADETIMES, OBJPROP_PRICE2, p2);
//----
   if (Show_Daily_Trade_TEXT==true)
     {
      ObjectDelete("TT1");
      TT1( "TT1", 460, 12,4);
      ObjectSetText( "TT1","EUROPE Open" , 9, "Arial", EUROPE_TEXT_Color);
      //
      ObjectDelete("TT2");
      TT2( "TT2", 460, 12,4);
      ObjectSetText( "TT2",""+EUROPE_Open+"" , 9, "Arial", Silver);
      //
      ObjectDelete("TT3");
      TT3( "TT3", 475, 12,4);
      ObjectSetText( "TT3","LONDON Open" , 9, "Arial", LONDON_TEXT_Color);
      //
      ObjectDelete("TT4");
      TT4( "TT4", 475, 12,4);
      ObjectSetText( "TT4",""+LONDON_Open+"" , 9, "Arial", Silver);
      //
      ObjectDelete("TT5");
      TT5( "TT5", 490, 12,4);
      ObjectSetText( "TT5","US Open" , 9, "Arial", US_TEXT_Color);
      //
      ObjectDelete("TT6");
      TT6( "TT6", 490, 12,4);
      ObjectSetText( "TT6",""+US_Open+"" , 9, "Arial", Silver);
      //
      ObjectDelete("TT7");
      TT7( "TT7", 505, 12,4);
      ObjectSetText( "TT7","EUROPE Close" , 9, "Arial", EUROPE1_TEXT_Color );
      //
      ObjectDelete("TT8");
      TT8( "TT8", 505, 12,4);
      ObjectSetText( "TT8",""+EUROPE1_Close+"" , 9, "Arial", Silver);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  datetime decDateTradeDay (datetime dt) 
  {
   int ty=TimeYear(dt);
   int tm=TimeMonth(dt);
   int td=TimeDay(dt);
   int th=TimeHour(dt);
   int ti=TimeMinute(dt);
   td--;
     if (td==0) 
     {
      tm--;
        if (tm==0) 
        {
         ty--;
         tm=12;
        }
      if (tm==1 || tm==3 || tm==5 || tm==7 || tm==8 || tm==10 || tm==12) td=31;
      if (tm==2) if (MathMod(ty, 4)==0) td=29; else td=28;
      if (tm==4 || tm==6 || tm==9 || tm==11) td=30;
     }
   return(StrToTime(ty+"."+tm+"."+td+" "+th+":"+ti));
  }
//+------------------------------------------------------------------+
int TT1( string Text, int xOffset, int yOffset,int iCorner) //TITLE
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20);
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int TT2( string Text, int xOffset, int yOffset,int iCorner) //TITLE
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 120);
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int TT3( string Text, int xOffset, int yOffset,int iCorner) //TITLE
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20);
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int TT4( string Text, int xOffset, int yOffset,int iCorner) //TITLE
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 120);
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int TT5( string Text, int xOffset, int yOffset,int iCorner) //TITLE
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20);
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int TT6( string Text, int xOffset, int yOffset,int iCorner) //TITLE
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 120);
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int TT7( string Text, int xOffset, int yOffset,int iCorner) //TITLE
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 20);
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int TT8( string Text, int xOffset, int yOffset,int iCorner) //TITLE
  { 
   ObjectCreate(Text,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet   (Text,OBJPROP_CORNER    , iCorner);
   ObjectSet   (Text,OBJPROP_XDISTANCE , 120);
   ObjectSet   (Text,OBJPROP_YDISTANCE , xOffset );
   ObjectSet   (Text,OBJPROP_BACK      , True );
  }
//+------------------------------------------------------------------+