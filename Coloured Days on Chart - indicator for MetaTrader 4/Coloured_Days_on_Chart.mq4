//+------------------------------------------------------------------+
//|                                  Coloured Days on Chart.mq4 v1.0 |
//|                   Copyright © 2008, Jason Robinson (jnrtrading). |
//|                                   http://www.spreadtrade2win.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, Jason Robinson (jnrtrading)."
#property link      "http://www.spreadtrade2win.com"

#property indicator_chart_window
extern int No_of_days_to_colour = 20;
extern color Colour1 = LightGray;
extern color Colour2 = DarkGray;
double Days[][6];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
ArrayCopyRates(Days,Symbol(),PERIOD_D1);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   for (int i = No_of_days_to_colour; i >= 0; i--) {
      ObjectDelete("Day"+i);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//---
   
   for (int i = 0; i <= No_of_days_to_colour; i++) {
      ObjectCreate("Day"+i,OBJ_RECTANGLE,0,Days[i][0]+86400,Days[i][3],Days[i][0],Days[i][2]);
      if (i % 2 == 0)
         ObjectSet("Day"+i,OBJPROP_COLOR,Colour1);
      else
         ObjectSet("Day"+i,OBJPROP_COLOR,Colour2);
   }

   
//----
   return(0);
  }
//+------------------------------------------------------------------+