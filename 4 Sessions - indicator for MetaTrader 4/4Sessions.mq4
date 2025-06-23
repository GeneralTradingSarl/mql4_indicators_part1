//+------------------------------------------------------------------+
//|                                                    4Sessions v2.3|
//|                                                   Andrew Kuptsov |
//|                                                                  |
//+------------------------------------------------------------------+

#property copyright "Andrew Kuptsov"
#property indicator_chart_window

#define       ASIA    "Asia"
#define       EUROPE  "Europe"
#define       AMERICA "America"
#define       PACIFIC "Pacific"

extern int    Winter = 2;
extern int    Summer = 3;

extern int    Days             = 5;
extern bool   ShowDescription  = true;
extern bool   ShowPips         = true;
extern bool   AsBackground     = true;
extern bool   ShowNextSessions = true;
extern int    Width            = 1;
extern int    Style            = 0;

extern string AsiaDesc       = "Asia";
extern color  AsiaColor      = Aqua;
extern string AsiaOpen       = "00:00";
extern string AsiaClose      = "09:00";

extern string EuropeDesc     = "Europe";
extern color  EuropeColor    = DarkKhaki;
extern string EuropeOpen     = "06:00";
extern string EuropeClose    = "15:00";

extern string AmericaDesc    = "America";
extern color  AmericaColor   = LightSalmon;
extern string AmericaOpen    = "13:00";
extern string AmericaClose   = "22:00";

extern string PacificDesc    = "Pacific";
extern color  PacificColor   = LightSteelBlue;
extern string PacificOpen    = "20:00";
extern string PacificClose   = "04:00";

bool bREDRAWN=false;
int  iBarsInit=0;
//+------------------------------------------------------------------+
datetime Yesterday(datetime dtDate)
  {
   dtDate-=dtDate%86400;
   
   int ind1=iBarShift( NULL,0,dtDate,false )+1;
   if (ind1<0) return(Time[0]);
   if (ind1>Bars) return(Time[0]);

   if(dtDate>=TimeCurrent())
      return( Time[0] );
   else
      return( Time[ind1] );
  }
//+------------------------------------------------------------------+
datetime Tomorrow(datetime dtDate)
  {
   datetime dtResult;

   dtDate -= dtDate%86400;
   dtDate += 86399;

   int ind1=iBarShift( NULL,0,dtDate,false )-1;
   if (ind1<0) return(dtDate);
   if (ind1>Bars) return(dtDate);

   if(dtDate>=TimeCurrent())
      dtResult=dtDate+1;
   else
      dtResult=Time[ind1];

   if(dtResult==0) dtResult=dtDate+1;

   return(dtResult);
  }
//+------------------------------------------------------------------+
int DST(datetime dtDate)
  {
   int      iYear;
   datetime dtLastSunday,dtMarch,dtOctober;

   iYear=TimeYear(dtDate);

   for(int i=24; i<=31; i++)
     {
      dtLastSunday=StrToTime(iYear+"."+"03."+i+" 02:00");
      if(TimeDayOfWeek(dtLastSunday)==0) dtMarch=dtLastSunday;

      dtLastSunday=StrToTime(iYear+"."+"10."+i+" 02:00");
      if(TimeDayOfWeek(dtLastSunday)==0) dtOctober=dtLastSunday;
     }

   if(dtDate < dtMarch) return(Winter);
   else if(dtDate >= dtMarch && dtDate < dtOctober) return(Summer);
   else if(dtDate >= dtOctober) return(Winter);
   return(0);
  }
//+------------------------------------------------------------------+
void DrawSession(string   sSessionName,
                 string   sSessionDesc,
                 datetime dtDayToDraw,
                 string   sSessionOpen,
                 string   sSessionClose,
                 color    clrSessionColor)
  {
   string   sDayToDraw;
   datetime dtSessionOpen,dtSessionClose;
   double   dHigh,dLow;
   int      iFirstBar,iLastBar,iHourCorrection;

   sDayToDraw       = TimeToStr(dtDayToDraw,TIME_DATE);
   iHourCorrection  = DST(dtDayToDraw);

   sSessionOpen     = TimeToStr( StrToTime(sSessionOpen)  + iHourCorrection,TIME_MINUTES );
   sSessionClose    = TimeToStr( StrToTime(sSessionClose) + iHourCorrection - 1,TIME_MINUTES );

   if(StrToTime(sSessionOpen)>=StrToTime(sSessionClose))
     {
      dtSessionClose=StrToTime(TimeToStr(Tomorrow(dtDayToDraw),TIME_DATE)+" "+sSessionClose);

      sDayToDraw     = TimeToStr(dtDayToDraw,TIME_DATE);
      dtSessionOpen  = StrToTime(sDayToDraw+" "+sSessionOpen);
     }
   else
     {
      dtSessionOpen  = StrToTime(sDayToDraw+" "+sSessionOpen);
      dtSessionClose = StrToTime(sDayToDraw+" "+sSessionClose);
     }

   if(ObjectFind(sSessionName)==-1) ObjectCreate(sSessionName,OBJ_RECTANGLE,0,0,0,0,0);

   ObjectSet(sSessionName,OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|
             OBJ_PERIOD_M5|
             OBJ_PERIOD_M15|
             OBJ_PERIOD_M30|
             OBJ_PERIOD_H1);
   ObjectSet(sSessionName,OBJPROP_TIME1,dtSessionOpen);
   ObjectSet(sSessionName,OBJPROP_TIME2,dtSessionClose);
   ObjectSet(sSessionName,OBJPROP_COLOR,clrSessionColor);
   ObjectSet(sSessionName,OBJPROP_BACK,AsBackground);
   ObjectSet(sSessionName,OBJPROP_WIDTH,Width);
   ObjectSet(sSessionName,OBJPROP_STYLE,Style);

   if(TimeCurrent()>=dtSessionOpen)
     {
      iLastBar  = iBarShift(NULL,0,dtSessionClose,false);
      iFirstBar = iBarShift(NULL,0,dtSessionOpen,false);
      dHigh     = High[ iHighest( NULL,0,MODE_HIGH,iFirstBar-iLastBar+1,iLastBar ) ];
      dLow      = Low [  iLowest( NULL,0,MODE_LOW, iFirstBar-iLastBar+1,iLastBar ) ];

      ObjectSet(sSessionName,OBJPROP_PRICE1,dHigh);
      ObjectSet(sSessionName,OBJPROP_PRICE2,dLow);
     }
   else
     {
      if(ShowNextSessions)
        {
         ObjectSet(sSessionName,OBJPROP_PRICE1,WindowPriceMax(0)+100);
         ObjectSet(sSessionName,OBJPROP_PRICE2,0);
        }
     }

   if(ShowDescription)
     {
      if(ShowPips)
        {
         double dPips;

         dPips        = (dHigh-dLow)*MathPow(10,Digits);
         sSessionDesc = sSessionDesc+" "+DoubleToStr(dPips,0);
        }

      ObjectSetText(sSessionName,sSessionDesc);
     }
  }
//+------------------------------------------------------------------+
void DrawAllSessions()
  {
   datetime dtDayToDraw;
   dtDayToDraw=TimeCurrent()+86400;

   for(int i=0; i<=Days; i++)
     {
      DrawSession(PACIFIC+i,
                  PacificDesc,
                  dtDayToDraw,
                  PacificOpen,
                  PacificClose,
                  PacificColor);

      DrawSession(AMERICA+i,
                  AmericaDesc,
                  dtDayToDraw,
                  AmericaOpen,
                  AmericaClose,
                  AmericaColor);

      DrawSession(EUROPE+i,
                  EuropeDesc,
                  dtDayToDraw,
                  EuropeOpen,
                  EuropeClose,
                  EuropeColor);

      DrawSession(ASIA+i,
                  AsiaDesc,
                  dtDayToDraw,
                  AsiaOpen,
                  AsiaClose,
                  AsiaColor);

      dtDayToDraw=Yesterday(dtDayToDraw);
     }
  }
//+------------------------------------------------------------------+
int init()
  {
   Winter *= 3600;
   Summer *= 3600;

   if(Days==0) Days=1;
   if(Style>=5) Style=0;

   iBarsInit=Bars;

   DrawAllSessions();

   return(0);
  }
//+------------------------------------------------------------------+
int deinit()
  {
   if(UninitializeReason()!=3)
     {
      for(int i=0; i<=Days; i++)
        {
         ObjectDelete(ASIA+i);
         ObjectDelete(EUROPE+i);
         ObjectDelete(AMERICA+i);
         ObjectDelete(PACIFIC+i);
        }
     }

   return(0);
  }
//+------------------------------------------------------------------+
int start()
  {
   if(Period()<PERIOD_H4)
     {
      int     iBarsCur,iBarsDiff;
      double  dNow;

      iBarsCur  = Bars;
      iBarsDiff = iBarsCur-iBarsInit;
      dNow      = Hour()+Minute()/100.0;

      if(iBarsDiff>1)
        {
         DrawAllSessions();

         iBarsInit=iBarsCur;
         return(0);
        }
      else if(iBarsDiff==1)
        {
         iBarsInit=iBarsCur;
        }

      if(dNow>=0.00 && dNow<0.01)
        {
         if(!bREDRAWN)
           {
            DrawAllSessions();

            bREDRAWN=true;
            return(0);
           }
        }

      datetime dtTheTime;
      datetime dtDayToDraw;

      dtTheTime   = TimeCurrent();
      dtDayToDraw = dtTheTime;

      for(int i=1; i<=2; i++)
        {
         datetime dtOpen,dtClose;

         dtOpen  = ObjectGet(PACIFIC+i,OBJPROP_TIME1);
         dtClose = ObjectGet(PACIFIC+i,OBJPROP_TIME2);

         if(dtTheTime>=dtOpen && dtTheTime<=dtClose)
            DrawSession(PACIFIC+i,
                        PacificDesc,
                        dtDayToDraw,
                        PacificOpen,
                        PacificClose,
                        PacificColor);

         dtOpen  = ObjectGet(AMERICA+i,OBJPROP_TIME1);
         dtClose = ObjectGet(AMERICA+i,OBJPROP_TIME2);

         if(dtTheTime>=dtOpen && dtTheTime<=dtClose)
            DrawSession(AMERICA+i,
                        AmericaDesc,
                        dtDayToDraw,
                        AmericaOpen,
                        AmericaClose,
                        AmericaColor);

         dtOpen  = ObjectGet(EUROPE+i,OBJPROP_TIME1);
         dtClose = ObjectGet(EUROPE+i,OBJPROP_TIME2);

         if(dtTheTime>=dtOpen && dtTheTime<=dtClose)
            DrawSession(EUROPE+i,
                        EuropeDesc,
                        dtDayToDraw,
                        EuropeOpen,
                        EuropeClose,
                        EuropeColor);

         dtOpen  = ObjectGet(ASIA+i,OBJPROP_TIME1);
         dtClose = ObjectGet(ASIA+i,OBJPROP_TIME2);

         if(dtTheTime>=dtOpen && dtTheTime<=dtClose)
            DrawSession(ASIA+i,
                        AsiaDesc,
                        dtDayToDraw,
                        AsiaOpen,
                        AsiaClose,
                        AsiaColor);

         dtDayToDraw=Yesterday(dtDayToDraw);
        }
     }

   return(0);
  }
//+------------------------------------------------------------------+
