//+------------------------------------------------------------------+
//|                                          FX5_NellyElliotWave.mq4 |
//|                                            FX5, Copyright © 2007 |
//|                                                    hazem@uk2.net |
//+------------------------------------------------------------------+
#property copyright "FX5, Copyright © 2007"
#property link      "hazem@uk2.net"

#property indicator_chart_window
#property indicator_buffers 8

#define Sunday 0
#define Monday 1

//---- input parameters
extern string    segment_0="*** Daily Close Settings ***";
extern bool      enableCustomDailyClose=false;
extern string    dailyCloseTime="00:00";
extern string    segment_1="*** Waves Display Setting ***";
extern bool      showMonthlyWaves= true;
extern bool      showWeeklyWaves = true;
extern bool      showDailyWaves=true;
extern bool      showQuarterDailyWaves=true;
extern string    segment_2="*** Waves Color Settings ***";
extern color     monthlyWavesColor= clrBlueViolet;
extern color     weeklyWavesColor = clrGreen;
extern color     dailyWavesColor=clrBlue;
extern color     quarterDailyWavesColor=clrYellow;
extern string    segment_3="*** SwingPoints Color Settings ***";
extern color     monthlySwingColor= clrYellow;
extern color     weeklySwingColor = clrFireBrick;
extern color     dailySwingColor=clrRed;
extern color     quarterDailySwingColor=clrChocolate;
//---- buffers
double monthlyWaves[];
double monthlySwings[];
double weeklyWaves[];
double weeklySwings[];
double dailyWaves[];
double dailySwings[];
double quarterDailyWaves[];
double quarterDailySwings[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   datetime time=StrToTime(dailyCloseTime);
   dailyCloseTime=TimeToStr(time,TIME_MINUTES);

//---- indicators
   int timeFrame=Period();

   int monthlyWidth= 2;
   int weeklyWidth = 2;
   int dailyWidth=2;
   int quarterDailyWidth=1;

   if(timeFrame>=PERIOD_D1)
      weeklyWidth= 1;
   if(timeFrame >= PERIOD_H4)
      dailyWidth = 1;

   SetIndexStyle(0,DRAW_SECTION,STYLE_SOLID,monthlyWidth,monthlyWavesColor);
   SetIndexStyle(2,DRAW_SECTION,STYLE_SOLID,weeklyWidth,weeklyWavesColor);
   SetIndexStyle(4,DRAW_SECTION,STYLE_SOLID,dailyWidth,dailyWavesColor);
   SetIndexStyle(6,DRAW_SECTION,STYLE_SOLID,quarterDailyWidth,quarterDailyWavesColor);

   SetIndexStyle(1,DRAW_ARROW,EMPTY,monthlyWidth,monthlySwingColor);
   SetIndexStyle(3,DRAW_ARROW,EMPTY,weeklyWidth,weeklySwingColor);
   SetIndexStyle(5,DRAW_ARROW,EMPTY,dailyWidth,dailySwingColor);
   SetIndexStyle(7,DRAW_ARROW,EMPTY,quarterDailyWidth,quarterDailySwingColor);

   SetIndexArrow(1,159);
   SetIndexArrow(3,159);
   SetIndexArrow(5,159);
   SetIndexArrow(7,159);

   SetIndexBuffer(0,monthlyWaves);
   SetIndexBuffer(1,monthlySwings);
   SetIndexBuffer(2,weeklyWaves);
   SetIndexBuffer(3,weeklySwings);
   SetIndexBuffer(4,dailyWaves);
   SetIndexBuffer(5,dailySwings);
   SetIndexBuffer(6,quarterDailyWaves);
   SetIndexBuffer(7,quarterDailySwings);

   SetIndexEmptyValue(0,0);
   SetIndexEmptyValue(1,0);
   SetIndexEmptyValue(2,0);
   SetIndexEmptyValue(3,0);
   SetIndexEmptyValue(4,0);
   SetIndexEmptyValue(5,0);
   SetIndexEmptyValue(6,0);
   SetIndexEmptyValue(7,0);

   IndicatorDigits(Digits);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   Comment("");

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   Comment("Designed & Prgramed By: FX5\n","***hazem@uk2.net***");
   int countedBars=IndicatorCounted();
   if(countedBars<0)
      countedBars=0;

   int timeFrame=Period();

   if(showMonthlyWaves)
     {
      if(timeFrame==PERIOD_D1 || timeFrame==PERIOD_H4)
         IdentifyMonthlyWaves(countedBars);
     }

   if(showWeeklyWaves)
     {
      if(timeFrame==PERIOD_D1 || timeFrame==PERIOD_H4 ||
         timeFrame==PERIOD_H1)
         IdentifyWeeklyWaves(countedBars);
     }
   if(showDailyWaves)
     {
      if(timeFrame==PERIOD_H4 || timeFrame==PERIOD_H1 || 
         timeFrame == PERIOD_M30 ||timeFrame == PERIOD_M15 ||
         timeFrame == PERIOD_M5 || timeFrame == PERIOD_M1)
         IdentifyDailyWaves(countedBars);
     }
   if(showQuarterDailyWaves)
     {
      if(timeFrame==PERIOD_H1 || timeFrame==PERIOD_M30 || 
         timeFrame == PERIOD_M15 || timeFrame == PERIOD_M5 ||
         timeFrame == PERIOD_M1)
         IdentifyQuarterDailyWaves(countedBars);
     }

   return(0);
  }
//+------------------------------------------------------------------+
void IdentifyMonthlyWaves(int countedBars)
  {
   int lastShift=-1;
   int limit=Bars-countedBars;
   if(countedBars==0) limit--;

   for(int i=limit; i>=0; i--)
     {
      int lastClose=GetLastMonthlyClose(i);

      if(lastShift==lastClose)
         continue;
      else
         lastShift=lastClose;

      int lastOpen=GetLastMonthlyClose(lastClose);

      if(lastClose==-1 || lastOpen==-1)
         continue;

      int highShift= GetHighestHighShift(lastClose+1,lastOpen-lastClose);
      int lowShift = GetLowestLowShift(lastClose+1,lastOpen-lastClose);

      double highPrice= High[highShift];
      double lowPrice = Low[lowShift];

      if(highShift>lowShift)
        {
         monthlyWaves[lastOpen]=highPrice;
         int middleShift=lastClose+MathCeil((lastOpen-lastClose+1)/2);
         monthlyWaves[middleShift]=lowPrice;
        }
      else
        {
         monthlyWaves[lastOpen]=lowPrice;
         middleShift=lastClose+MathCeil((lastOpen-lastClose+1)/2);
         monthlyWaves[middleShift]=highPrice;
        }

      int swing_0 = GetLastMonthlySwing(i);
      int swing_1 = GetLastMonthlySwing(swing_0);
      int swing_2 = GetLastMonthlySwing(swing_1);
      int swing_3 = GetLastMonthlySwing(swing_2);
      if(swing_0>=0 && swing_1>=0 && swing_2>=0 && swing_3>=0)
        {
         if(monthlyWaves[swing_1]>monthlyWaves[swing_0] && monthlyWaves[swing_1]>monthlyWaves[swing_2])
            monthlySwings[swing_1]=monthlyWaves[swing_1];

         if(monthlyWaves[swing_1]<monthlyWaves[swing_0] && monthlyWaves[swing_1]<monthlyWaves[swing_2])
            monthlySwings[swing_1]=monthlyWaves[swing_1];

         if(monthlyWaves[swing_2]>monthlyWaves[swing_1] && monthlyWaves[swing_2]>monthlyWaves[swing_3])
            monthlySwings[swing_2]=monthlyWaves[swing_2];

         if(monthlyWaves[swing_2]<monthlyWaves[swing_1] && monthlyWaves[swing_2]<monthlyWaves[swing_3])
            monthlySwings[swing_2]=monthlyWaves[swing_2];
        }
     }
  }
//+------------------------------------------------------------------+
void IdentifyWeeklyWaves(int countedBars)
  {
   int lastShift=-1;
   int limit=Bars-countedBars;
   if(countedBars==0) limit--;
   for(int i=limit; i>=0; i--)
     {
      int lastWeekClose=GetLastWeeklyClose(i);

      if(lastShift==lastWeekClose)
         continue;
      else
         lastShift=lastWeekClose;

      int lastWeekOpen=GetLastWeeklyClose(lastWeekClose);

      if(lastWeekClose==-1 || lastWeekOpen==-1)
         continue;

      int weekHighShift= GetHighestHighShift(lastWeekClose+1,lastWeekOpen-lastWeekClose);
      int weekLowShift = GetLowestLowShift(lastWeekClose+1,lastWeekOpen-lastWeekClose);

      double weekHighPrice= High[weekHighShift];
      double weekLowPrice = Low[weekLowShift];

      if(weekHighShift>weekLowShift)
        {
         weeklyWaves[lastWeekOpen]=weekHighPrice;
         int middleWeekShift=lastWeekClose+MathCeil((lastWeekOpen-lastWeekClose+1)/2);
         weeklyWaves[middleWeekShift]=weekLowPrice;
        }
      else
        {
         weeklyWaves[lastWeekOpen]=weekLowPrice;
         middleWeekShift=lastWeekClose+MathCeil((lastWeekOpen-lastWeekClose+1)/2);
         weeklyWaves[middleWeekShift]=weekHighPrice;
        }

      int swing_0 = GetLastWeeklySwing(i);
      int swing_1 = GetLastWeeklySwing(swing_0);
      int swing_2 = GetLastWeeklySwing(swing_1);
      int swing_3 = GetLastWeeklySwing(swing_2);
      if(swing_0>=0 && swing_1>=0 && swing_2>=0 && swing_3>=0)
        {
         if(weeklyWaves[swing_1]>weeklyWaves[swing_0] && weeklyWaves[swing_1]>weeklyWaves[swing_2])
            weeklySwings[swing_1]=weeklyWaves[swing_1];

         if((swing_2>=0) && weeklyWaves[swing_1]<weeklyWaves[swing_0] && weeklyWaves[swing_1]<weeklyWaves[swing_2])
            weeklySwings[swing_1]=weeklyWaves[swing_1];

         if(weeklyWaves[swing_2]>weeklyWaves[swing_1] && weeklyWaves[swing_2]>weeklyWaves[swing_3])
            weeklySwings[swing_2]=weeklyWaves[swing_2];

         if(weeklyWaves[swing_2]<weeklyWaves[swing_1] && weeklyWaves[swing_2]<weeklyWaves[swing_3])
            weeklySwings[swing_2]=weeklyWaves[swing_2];
        }
     }
  }
//+------------------------------------------------------------------+
void IdentifyDailyWaves(int countedBars)
  {
   int lastShift=-1;
   int limit=Bars-countedBars;
   if(countedBars==0) limit--;
   for(int i=limit; i>=0; i--)
     {
      int lastDayClose=GetLastDailyClose(i);

      if(lastShift==lastDayClose)
         continue;
      else
         lastShift=lastDayClose;

      int lastDayOpen=GetLastDailyClose(lastDayClose);

      if(lastDayClose==-1 || lastDayOpen==-1)
         continue;

      int dayHighShift= GetHighestHighShift(lastDayClose+1,lastDayOpen-lastDayClose);
      int dayLowShift = GetLowestLowShift(lastDayClose+1,lastDayOpen-lastDayClose);

      double dayHighPrice= High[dayHighShift];
      double dayLowPrice = Low[dayLowShift];
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
      if(dayHighShift>dayLowShift)
        {
         dailyWaves[lastDayOpen]=dayHighPrice;
         int middleDayShift=lastDayClose+MathCeil((lastDayOpen-lastDayClose+1)/2);
         dailyWaves[middleDayShift]=dayLowPrice;
        }
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
      else
        {
         dailyWaves[lastDayOpen]=dayLowPrice;
         middleDayShift=lastDayClose+MathCeil((lastDayOpen-lastDayClose+1)/2);
         dailyWaves[middleDayShift]=dayHighPrice;
        }

      int swing_0 = GetLastDailySwing(i);
      int swing_1 = GetLastDailySwing(swing_0);
      int swing_2 = GetLastDailySwing(swing_1);
      int swing_3 = GetLastDailySwing(swing_2);
      if(swing_0>=0 && swing_1>=0 && swing_2>=0 && swing_3>=0)
        {
         if(dailyWaves[swing_1]>dailyWaves[swing_0] && dailyWaves[swing_1]>dailyWaves[swing_2])
            dailySwings[swing_1]=dailyWaves[swing_1];

         if(dailyWaves[swing_1]<dailyWaves[swing_0] && dailyWaves[swing_1]<dailyWaves[swing_2])
            dailySwings[swing_1]=dailyWaves[swing_1];

         if(dailyWaves[swing_2]>dailyWaves[swing_1] && dailyWaves[swing_2]>dailyWaves[swing_3])
            dailySwings[swing_2]=dailyWaves[swing_2];

         if(dailyWaves[swing_2]<dailyWaves[swing_1] && dailyWaves[swing_2]<dailyWaves[swing_3])
            dailySwings[swing_2]=dailyWaves[swing_2];
        }
     }
  }
//+------------------------------------------------------------------+
void IdentifyQuarterDailyWaves(int countedBars)
  {
   int lastShift=-1;
   int limit=Bars-countedBars;
   if(countedBars==0) limit--;
   for(int i=limit; i>=0; i--)
     {
      int lastClose=GetLastQuarterDailyClose(i);

      if(lastShift==lastClose)
         continue;
      else
         lastShift=lastClose;

      int lastOpen=GetLastQuarterDailyClose(lastClose);

      if(lastClose==-1 || lastOpen==-1)
         continue;

      int highShift= GetHighestHighShift(lastClose+1,lastOpen-lastClose);
      int lowShift = GetLowestLowShift(lastClose+1,lastOpen-lastClose);

      double highPrice= High[highShift];
      double lowPrice = Low[lowShift];
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
      if(highShift>lowShift)
        {
         quarterDailyWaves[lastOpen]=highPrice;
         int middleShift=lastClose+MathCeil((lastOpen-lastClose+1)/2);
         quarterDailyWaves[middleShift]=lowPrice;
        }
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
      else
        {
         quarterDailyWaves[lastOpen]=lowPrice;
         middleShift=lastClose+MathCeil((lastOpen-lastClose+1)/2);
         quarterDailyWaves[middleShift]=highPrice;
        }

      int swing_0 = GetLastQuarterDailySwing(i);
      int swing_1 = GetLastQuarterDailySwing(swing_0);
      int swing_2 = GetLastQuarterDailySwing(swing_1);
      int swing_3 = GetLastQuarterDailySwing(swing_2);
      if(swing_0>=0 && swing_1>=0 && swing_2>=0 && swing_3>=0)
        {
         if(quarterDailyWaves[swing_1]>quarterDailyWaves[swing_0] && quarterDailyWaves[swing_1]>quarterDailyWaves[swing_2])
            quarterDailySwings[swing_1]=quarterDailyWaves[swing_1];

         if(quarterDailyWaves[swing_1]<quarterDailyWaves[swing_0] && quarterDailyWaves[swing_1]<quarterDailyWaves[swing_2])
            quarterDailySwings[swing_1]=quarterDailyWaves[swing_1];

         if(quarterDailyWaves[swing_2]>quarterDailyWaves[swing_1] && quarterDailyWaves[swing_2]>quarterDailyWaves[swing_3])
            quarterDailySwings[swing_2]=quarterDailyWaves[swing_2];

         if(quarterDailyWaves[swing_2]<quarterDailyWaves[swing_1] && quarterDailyWaves[swing_2]<quarterDailyWaves[swing_3])
            quarterDailySwings[swing_2]=quarterDailyWaves[swing_2];
        }
     }
  }
//+------------------------------------------------------------------+
int GetLastMonthlySwing(int shift)
  {
   for(int i=shift+1;(i<Bars-1); i++)
     {
      if(monthlyWaves[i]!=0)
         return(i);
     }
   return(-1);
  }
//+------------------------------------------------------------------+
int GetLastWeeklySwing(int shift)
  {
   for(int i=shift+1;(i<Bars-1); i++)
     {
      if(weeklyWaves[i]!=0)
         return(i);
     }
   return(-1);
  }
//+------------------------------------------------------------------+
int GetLastDailySwing(int shift)
  {
   for(int i=shift+1;(i<Bars-1); i++)
     {
      if(dailyWaves[i]!=0)
         return(i);
     }
   return(-1);
  }
//+------------------------------------------------------------------+
int GetLastQuarterDailySwing(int shift)
  {
   for(int i=shift+1;(i<Bars-1); i++)
     {
      if(quarterDailyWaves[i]!=0)
         return(i);
     }
   return(-1);
  }
//+------------------------------------------------------------------+
int GetLastMonthlyClose(int shift)
  {
   for(int i=shift+1;(i<Bars-1); i++)
     {
      if(TimeDay(Time[i])<TimeDay(Time[i+1]))
         return(i);
     }
   return(-1);
  }
//+------------------------------------------------------------------+
int GetLastWeeklyClose(int shift)
  {
   for(int i=shift+1;(i<Bars-1); i++)
     {
      if(TimeDayOfWeek(Time[i])<TimeDayOfWeek(Time[i+1]))
         return(i);
     }
   return(-1);
  }
//+------------------------------------------------------------------+
int GetLastDailyClose(int shift)
  {
   if(enableCustomDailyClose)
     {
      for(int i=shift+1;(i<Bars-1); i++)
         //+------------------------------------------------------------------+
         //|                                                                  |
         //+------------------------------------------------------------------+
        {
         string candleDateString=TimeToStr(Time[i],TIME_DATE);
         datetime closeTime=StrToTime(candleDateString+" "+dailyCloseTime);

         if(closeTime<Time[shift] && closeTime>=Time[i])
            return(i);
        }
     }
   else
     {
      for(i=shift+1;(i<Bars-1); i++)
         //+------------------------------------------------------------------+
         //|                                                                  |
         //+------------------------------------------------------------------+
        {
         if(TimeDayOfWeek(Time[i])!=TimeDayOfWeek(Time[i+1]) &&
            TimeDayOfWeek(Time[i])!=Monday && TimeDayOfWeek(Time[i+1])!=Sunday)
            return(i);
        }
     }
   return(-1);
  }
//+------------------------------------------------------------------+
int GetLastQuarterDailyClose(int shift)
  {
   if(enableCustomDailyClose)
     {
      int colonIndex= StringFind(dailyCloseTime,":",0);
      if(colonIndex == -1)
         return(-1);

      string closeHourString=StringSubstr(dailyCloseTime,0,colonIndex);
      int closeHour=StrToInteger(closeHourString);
     }
   else
      closeHour=0;

   for(int i=shift+1; i<Bars; i++)
     {
      string candleDateString=TimeToStr(Time[i],TIME_DATE);

      int quarterHour=HourSum(closeHour,0);
      datetime closeTime=StrToTime(candleDateString+" "+DoubleToStr(quarterHour,0)+":00");
      if(closeTime<Time[shift] && closeTime>=Time[i])
         return(i);

      quarterHour=HourSum(closeHour,6);
      closeTime=StrToTime(candleDateString+" "+DoubleToStr(quarterHour,0)+":00");
      if(closeTime<Time[shift] && closeTime>=Time[i])
         return(i);

      quarterHour=HourSum(closeHour,12);
      closeTime=StrToTime(candleDateString+" "+DoubleToStr(quarterHour,0)+":00");
      if(closeTime<Time[shift] && closeTime>=Time[i])
         return(i);

      quarterHour=HourSum(closeHour,18);
      closeTime=StrToTime(candleDateString+" "+DoubleToStr(quarterHour,0)+":00");
      if(closeTime<Time[shift] && closeTime>=Time[i])
         return(i);
     }
   return(-1);
  }
//+------------------------------------------------------------------+
int HourSum(int firstHour,int secondHour)
  {
   int sum = firstHour + secondHour;
   if(sum >= 24)
      sum -= 24;

   return(sum);
  }
//+------------------------------------------------------------------+
int GetHighestHighShift(int start,int count)
  {
   int highestShift=-1;
   double highestPrice=-1;
   for(int i=start; i<start+count; i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      if(High[i]>highestPrice)
        {
         highestShift = i;
         highestPrice = High[i];
        }
     }
   return(highestShift);
  }
//+------------------------------------------------------------------+
int GetLowestLowShift(int start,int count)
  {
   int lowestShift=-1;
   double lowestPrice=9999999;
   for(int i=start; i<start+count; i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      if(Low[i]<lowestPrice)
        {
         lowestShift = i;
         lowestPrice = Low[i];
        }
     }
   return(lowestShift);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
