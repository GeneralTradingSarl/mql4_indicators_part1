//+------------------------------------------------------------------+
//|                                                AutoDayFibs V1.0  |
//|                                                                  |
//|              Copyright © 2005, Jason Robinson                    |
//|               (jasonrobinsonuk,  jnrtrading)                     |
//|                http://www.jnrtrading.co.uk                       |
//|                                                                  |
//|                    Created by jnrtrading                         |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, Jason Robinson (jnrtrading)"
#property link      "http://www.jnrtrading.co.uk"

#property indicator_chart_window
extern int daysBackForHigh = 1;
extern int daysBackForLow = 1;
//---- buffers
double Rates[][6];
//----
double fib000,
       fib236,
       fib382,
       fib50,
       fib618,
       fib100,
       fib1618,
       fib2618,
       fib4236,
       range,
       prevRange,
       high,
       low;
bool objectsExist, highFirst;
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
//---- 
   ObjectDelete("fib000");
   ObjectDelete("fib000_label");
   ObjectDelete("fib236");
   ObjectDelete("fib236_label");
   ObjectDelete("fib382");
   ObjectDelete("fib382_label");
   ObjectDelete("fib50");
   ObjectDelete("fib50_label");
   ObjectDelete("fib618");
   ObjectDelete("fib618_label");
   ObjectDelete("fib100");
   ObjectDelete("fib100_label");
   ObjectDelete("fib1618");
   ObjectDelete("fib1618_label");
   ObjectDelete("fib2618");
   ObjectDelete("fib2618_label");
   ObjectDelete("fib4236");
   ObjectDelete("fib4236_label");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i = 0;
   prevRange = 0;
   objectsExist = false;
   int copied=ArrayCopyRates(Rates, Symbol(), PERIOD_D1);   
   
   if (copied<40) return(-1);
   if (copied<daysBackForHigh) return(-1);
   if (copied<daysBackForLow) return(-1);
   
   high = Rates[daysBackForHigh][3];
   low = Rates[daysBackForLow][2];
   range = high - low;
//----
   while(true) 
     {
       if(High[i] == high) 
         {
           highFirst = true;
           break;
         }
       else 
           if(Low[i] == low) 
             {
               highFirst = false;
               break;
             }
       i++;
     }
   // Delete Objects if necessary
   if(prevRange != range) 
     {
       ObjectDelete("fib000");
       ObjectDelete("fib000_label");
       ObjectDelete("fib236");
       ObjectDelete("fib236_label");
       ObjectDelete("fib382");
       ObjectDelete("fib382_label");
       ObjectDelete("fib50");
       ObjectDelete("fib50_label");
       ObjectDelete("fib618");
       ObjectDelete("fib618_label");
       ObjectDelete("fib100");
       ObjectDelete("fib100_label");
       ObjectDelete("fib1618");
       ObjectDelete("fib1618_label");
       ObjectDelete("fib2618");
       ObjectDelete("fib2618_label");
       ObjectDelete("fib4236");
       ObjectDelete("fib4236_label");
       objectsExist = false;
       prevRange = range;
     }
//----
   if(highFirst == true) 
     {
       fib000 = low;
       fib236 = (range * 0.236) + low;
       fib382 = (range * 0.382) + low;
       fib50 = (high + low) / 2;
       fib618 = (range * 0.618) + low;
       fib100 = high;
       fib1618 = (range * 0.618) + high;
       fib2618 = (range * 0.618) + (high + range);
       fib4236 = (range * 0.236) + high + (range * 3);
     }
   else 
       if(highFirst == false) 
         {
           fib000 = high;
           fib236 = high - (range * 0.236);
           fib382 = high - (range * 0.382);
           fib50  = (high + low) / 2;
           fib618 = high - (range * 0.618);
           fib100 = low;
           fib1618 = low - (range * 0.618);
           fib2618 = (low - range) - (range * 0.618);// + (high + range);
           fib4236 = low - (range * 3) - (range * 0.236);// + high + (range * 3);
         }
//----   
   if(objectsExist == false) 
     {
       ObjectCreate("fib000", OBJ_HLINE, 0, Time[40], fib000);
       ObjectSet("fib000", OBJPROP_STYLE, STYLE_DASHDOTDOT);
       ObjectSet("fib000", OBJPROP_COLOR, Red);
       ObjectCreate("fib000_label", OBJ_TEXT, 0, Time[0], fib000);
       ObjectSetText("fib000_label","                             0.0", 8, "Times", Black);
       //----
       ObjectCreate("fib236", OBJ_HLINE, 0, Time[40], fib236);
       ObjectSet("fib236", OBJPROP_STYLE, STYLE_DASHDOTDOT);
       ObjectSet("fib236", OBJPROP_COLOR, Red);
       ObjectCreate("fib236_label", OBJ_TEXT, 0, Time[0], fib236);
       ObjectSetText("fib236_label","                             23.6", 8, "Times", Black);
       //----
       ObjectCreate("fib382", OBJ_HLINE, 0, Time[40], fib382);
       ObjectSet("fib382", OBJPROP_STYLE, STYLE_DASHDOTDOT);
       ObjectSet("fib382", OBJPROP_COLOR, Red);
       ObjectCreate("fib382_label", OBJ_TEXT, 0, Time[0], fib382);
       ObjectSetText("fib382_label","                             38.2", 8, "Times", Black);
       //----
       ObjectCreate("fib50", OBJ_HLINE, 0, Time[40], fib50);
       ObjectSet("fib50", OBJPROP_STYLE, STYLE_DASHDOTDOT);
       ObjectSet("fib50", OBJPROP_COLOR, Red);
       ObjectCreate("fib50_label", OBJ_TEXT, 0, Time[0], fib50);
       ObjectSetText("fib50_label","                             50.0", 8, "Times", Black);
       //----
       ObjectCreate("fib618", OBJ_HLINE, 0, Time[40], fib618);
       ObjectSet("fib618", OBJPROP_STYLE, STYLE_DASHDOTDOT);
       ObjectSet("fib618", OBJPROP_COLOR, Red);
       ObjectCreate("fib618_label", OBJ_TEXT, 0, Time[0], fib618);
       ObjectSetText("fib618_label","                             61.8", 8, "Times", Black);
       //----
       ObjectCreate("fib100", OBJ_HLINE, 0, Time[40], fib100);
       ObjectSet("fib100", OBJPROP_STYLE, STYLE_DASHDOTDOT);
       ObjectSet("fib100", OBJPROP_COLOR, Red);
       ObjectCreate("fib100_label", OBJ_TEXT, 0, Time[0], fib100);
       ObjectSetText("fib100_label","                             100.0", 8, "Times", Black);
       //----
       ObjectCreate("fib1618", OBJ_HLINE, 0, Time[40], fib1618);
       ObjectSet("fib1618", OBJPROP_STYLE, STYLE_DASHDOTDOT);
       ObjectSet("fib1618", OBJPROP_COLOR, Red);
       ObjectCreate("fib1618_label", OBJ_TEXT, 0, Time[0], fib1618);
       ObjectSetText("fib1618_label","                             161.8", 8, "Times", Black);
       //----
       ObjectCreate("fib2618", OBJ_HLINE, 0, Time[40], fib2618);
       ObjectSet("fib2618", OBJPROP_STYLE, STYLE_DASHDOTDOT);
       ObjectSet("fib2618", OBJPROP_COLOR, Red);
       ObjectCreate("fib2618_label", OBJ_TEXT, 0, Time[0], fib2618);
       ObjectSetText("fib2618_label","                             261.8", 8, "Times", Black);
       //----
       ObjectCreate("fib4236", OBJ_HLINE, 0, Time[40], fib4236);
       ObjectSet("fib4236", OBJPROP_STYLE, STYLE_DASHDOTDOT);
       ObjectSet("fib4236", OBJPROP_COLOR, Red);
       ObjectCreate("fib4236_label", OBJ_TEXT, 0, Time[0], fib4236);
       ObjectSetText("fib4236_label","                             423.6", 8, "Times", Black);
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+