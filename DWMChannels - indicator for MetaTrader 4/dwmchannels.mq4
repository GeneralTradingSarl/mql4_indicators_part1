//+------------------------------------------------------------------+
//|                                                  DWMChannels.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 6
#property indicator_plots   6
//--- plot Daily High
#property indicator_label1  "Daily High"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot Daily Low
#property indicator_label2  "Daily Low"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot Weekly High
#property indicator_label3  "Weekly High"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrGreen
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- plot Weekly Low
#property indicator_label4  "Weekly Low"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrGreen
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1

//--- plot Monthly High
#property indicator_label5  "Monthly High"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrBlue
#property indicator_style5  STYLE_SOLID
#property indicator_width5  1
//--- plot Monthly Low
#property indicator_label6  "Monthly Low"
#property indicator_type6   DRAW_LINE
#property indicator_color6  clrBlue
#property indicator_style6  STYLE_SOLID
#property indicator_width6  1
//--- input parameters
//--- indicator buffers
double         DailyHighBuffer[];
double         DailyLowBuffer[];
double         WeeklyHighBuffer[];
double         WeeklyLowBuffer[];
double         MonthlyHighBuffer[];
double         MonthlyLowBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,DailyHighBuffer);
   SetIndexBuffer(1,DailyLowBuffer);
   SetIndexBuffer(2,WeeklyHighBuffer);
   SetIndexBuffer(3,WeeklyLowBuffer);
   SetIndexBuffer(4,MonthlyHighBuffer);
   SetIndexBuffer(5,MonthlyLowBuffer);

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   int i,limit;
//--- Get the number of bars available for the current symbol and chart period 
   int bars=Bars(Symbol(),0);
   Print("Bars = ",bars,", rates_total = ",rates_total,",  prev_calculated = ",prev_calculated);
   Print("time[0] = ",time[0]," time[rates_total-1] = ",time[rates_total-1]);
//--- last counted bar will be recounted
   limit=rates_total-prev_calculated;
   int startDayShfit=limit -1,endDayShfit=limit -1;
   int startWeekShfit=limit -1,endWeekShfit=limit -1;
   int startMonthShfit=limit -1,endMonthShfit=limit -1;
   for(i=limit-1; i>=0;i--)
     {
      datetime shiftDateTime=time[i];
      int shiftDay=TimeDay(shiftDateTime);
      int shiftWeak=TimeDayOfWeek(shiftDateTime);
      string ShiftTimeString=TimeToString(shiftDateTime,TIME_MINUTES|TIME_SECONDS);
      if(ShiftTimeString=="00:00:00")
        {
         endDayShfit=i+1;
         if(startDayShfit>endDayShfit)
            DailyChannels(startDayShfit,endDayShfit);
         startDayShfit=i;
        }
      if(ShiftTimeString=="00:00:00" && shiftWeak==5)
        {
         endWeekShfit=i+1;
         if(startWeekShfit>endWeekShfit)
            WeeklyChannels(startWeekShfit,endWeekShfit);
         startWeekShfit=i;
        }
      if(ShiftTimeString=="00:00:00" && shiftDay==1)
        {
         endMonthShfit=i+1;
         if(startMonthShfit>endMonthShfit)
            MonthlyChannels(startMonthShfit,endMonthShfit);
         startMonthShfit=i;
        }
     }
//--- return value of prev_calculated for next call 
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DailyChannels(int start,int end)
  {
   int highIndex=iHighest(NULL,NULL,MODE_HIGH,start-end+1,end);
   double highValue=iHigh(NULL,NULL,highIndex);
   int lowIndex=iLowest(NULL,NULL,MODE_LOW,start-end+1,end);
   double lowValue=iLow(NULL,NULL,lowIndex);
   for(int i=start;i>=end;i--)
     {
      DailyHighBuffer[i]= highValue;
      DailyLowBuffer[i] = lowValue;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WeeklyChannels(int start,int end)
  {
   int highIndex=iHighest(NULL,NULL,MODE_HIGH,start-end+1,end);
   double highValue=iHigh(NULL,NULL,highIndex);
   int lowIndex=iLowest(NULL,NULL,MODE_LOW,start-end+1,end);
   double lowValue=iLow(NULL,NULL,lowIndex);
   for(int i=start;i>=end;i--)
     {
      WeeklyHighBuffer[i]= highValue;
      WeeklyLowBuffer[i] = lowValue;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MonthlyChannels(int start,int end)
  {
   int highIndex=iHighest(NULL,NULL,MODE_HIGH,start-end+1,end);
   double highValue=iHigh(NULL,NULL,highIndex);
   int lowIndex=iLowest(NULL,NULL,MODE_LOW,start-end+1,end);
   double lowValue=iLow(NULL,NULL,lowIndex);
   for(int i=start;i>=end;i--)
     {
      MonthlyHighBuffer[i]=highValue;
      MonthlyLowBuffer[i]=lowValue;
     }
  }
//+------------------------------------------------------------------+
