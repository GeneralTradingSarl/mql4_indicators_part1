//+------------------------------------------------------------------+
//|                                                  day of week.mq4 |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window


//--- input parameters
input int fontsize= 10;     // Font Size
input string   fontstyle = "Verdana";  // Font family
input int      jarak = 100; //  distance from opening
input int      angle = 90;  //  Day Text skew

input color daycolor = clrLime;
input string   d1 = "Mon";  // day 1 name
input string   d2 = "Tue";  // day 2 name
input string   d3 = "Wed";  // day 3 name
input string   d4 = "Thu";  // day 4 name
input string   d5 = "Fri";  // day 5 name

input int dayscount = 999;  // calculated days
string hari[5];
string awal = "ddd_";

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

   hari[0] = d1;
   hari[1] = d2;
   hari[2] = d3;
   hari[3] = d4;
   hari[4] = d5;
//clear();
//show();
//---
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void deinit()
  {
   clear();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void start()
  {
   show();
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void show()
  {
   int li;
   int harian;
   string nama;
   int timeframe = Period();

   if(timeframe <= PERIOD_H1)
     {

      nama = "";
      li = MathMin(Bars, dayscount * 1440 / timeframe);
      for(int x = 0; x < li-1; x++)
        {
         if(TimeDayOfWeek(Time[x]) != TimeDayOfWeek(Time[x + 1]))
           {
            nama = awal + StringSubstr(TimeToStr(Time[x]),0,10);

            if(ObjectFind(nama) == -1)
              {
               harian = TimeDayOfWeek(Time[x]);

               ObjectCreate(nama, OBJ_TEXT, 0, Time[x], (Low[x] - (jarak * Point)));
               ObjectSetDouble(0,nama,OBJPROP_ANGLE,angle);
               ObjectSetText(nama, hari[harian - 1], fontsize, fontstyle, daycolor);
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void clear()
  {
   int li;
   string nama;
   int timeframe = Period();

   nama = "";
   li = MathMin(Bars, dayscount * 1440 / timeframe);
   for(int x = 0; x < li-1; x++)
     {
      if(TimeDayOfWeek(Time[x]) != TimeDayOfWeek(Time[x + 1]))
        {
         nama = awal + StringSubstr(TimeToStr(Time[x]),0,10);

         if(ObjectFind(nama)>-1)
            ObjectDelete(nama);
        }
     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
