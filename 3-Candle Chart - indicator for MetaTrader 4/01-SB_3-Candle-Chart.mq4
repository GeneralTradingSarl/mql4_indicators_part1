//+------------------------------------------------------------------+
//|                                                01-SB_3-Candle-Chart.mq4 |
//|                                                    Serge Beaudet |
//|                                                                  |
//+------------------------------------------------------------------+
// CANDLESTICK PATTERN TO VISUALIZE THE PRICE ACTION BETWEEN
// EURO OPEN    TO    POWER HOURS     TO    US CLOSE
// THREE CANDLESTICKS PER DAY
// THE SBnumber, (Named after my initials of course :-) ), IS AN OFFSET TO THE PATTERN
// BY PLAYING WITH IT WE ARE GETTING SURPRISING RESULTS
// NOTE THAT YOU NEED TO ENTER THE OFFSET IN HOUR BETWEEN GMT AND YOUR MT4 BROKER'S TIME
// THE CIRCLED NUMBERS ARE THE DAY OF THE WEEK, 0 BEEING MONDAY
#property copyright "Serge Beaudet"
#property link      "mailto:dcapitainebeaudet@gmail.com"
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Green
// Arrays for indicator buffers
// Constants
#define numberofbars 500
extern int  timeoffset=2;  //Offset from the time of the broker to GMT
extern int  SBnumber=0;  // Special offset to adjust the requested periods
// Variables
int currentbar;
double openhr[];
double pwrOtime,pwrOLprice, pwrOHprice, pwrOOprice, pwrOCprice;
double pwrCtime,pwrCLprice, pwrCHprice, pwrCOprice, pwrCCprice;
double usCtime,usCLprice, usCHprice, usCOprice, usCCprice;
double pwrM1,pwrM2;
double pwrHighest,pwrLowest;
double eurOtime,eurOLprice, eurOHprice,eurOOprice,eurOCprice;
double eurM1,eurM2;
double usM1,usM2;
double usHighest,usLowest;
double eurHighest,eurLowest;
int nopwrzone;
int noeurzone;
int nouszone;
string currencyused;
int timeoweek;
int dayoweek;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   if (Period()==60)  // Indicator only work on 1 hour charts
   {
   SetIndexBuffer(0,openhr);
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,140);
   SetIndexEmptyValue(0,0.0);  
   // Title
   currencyused=Symbol();
   ObjectCreate("currencyshown",OBJ_LABEL,0,0,0,0,0);
   ObjectSet("currencyshown",OBJPROP_XDISTANCE,0);
   ObjectSet("currencyshown",OBJPROP_YDISTANCE,3);
   ObjectSet("currencyshown",OBJPROP_COLOR,Black);
   ObjectSetText("currencyshown",currencyused,10,"Arial",Blue);
   ObjectCreate("title",OBJ_LABEL,0,0,0,0,0);
   ObjectSet("title",OBJPROP_XDISTANCE,60);
   ObjectSet("title",OBJPROP_YDISTANCE,3);
   ObjectSet("title",OBJPROP_COLOR,Black);
   ObjectSetText("title","3-CANDLE_CHART",10,"Arial",Black);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
  int x;
//----
   x=noeurzone;
   while (x>0)
   {
   ObjectDelete("eurzone"+x);
   ObjectDelete("eurzoneH"+x);
   ObjectDelete("eurzoneL"+x);
   x--;
   }
   x=nopwrzone;
   while (x>0)
   {
   ObjectDelete("powerzone"+x);
   ObjectDelete("powerzoneH"+x);
   ObjectDelete("powerzoneL"+x);
   ObjectDelete("day1"+x);
   x--;
   }
   x=nouszone;
   while (x>0)
   {
   ObjectDelete("uszone"+x);
   ObjectDelete("uszoneH"+x);
   ObjectDelete("uszoneL"+x); 
   x--;
   }
   ObjectDelete("title");
   ObjectDelete("currencyshown");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   string tempstmp;
   if (Period()==60)  // Indicator only work on 1 hour charts
      {      
      currentbar=numberofbars;
      nopwrzone=0;
      noeurzone=0;
      nouszone=0;
      while (currentbar > 0)
         {
         tempstmp=TimeHour(Time[currentbar])-timeoffset+SBnumber;
         if (tempstmp=="-1") tempstmp="23";
         if (tempstmp=="-2") tempstmp="22";
          
         //-
         if (tempstmp=="8") // Opening of London
            {
            //openhr[currentbar]=Close[currentbar]; 
            eurOtime=Time[currentbar];
            eurOLprice=Low[currentbar];
            eurOHprice=High[currentbar];
            eurOOprice=Open[currentbar];
            eurOCprice=Close[currentbar];     
            }
         if (tempstmp=="10") eurM1=Time[currentbar];
         //--
         if (tempstmp=="11") eurM2=Time[currentbar];
         //--
         //----------------------------------------------------------------------------------------------
         if (tempstmp=="13") // Opening of New York
            {
            //openhr[currentbar]=Open[currentbar];  
            eurHighest=High[iHighest(NULL,0,MODE_HIGH,6,currentbar)];
            eurLowest=Low[iLowest(NULL,0,MODE_LOW,6,currentbar)];
            pwrOtime=Time[currentbar];
            pwrOLprice=Low[currentbar];
            pwrOHprice=High[currentbar];
            pwrOOprice=Open[currentbar];
            pwrOCprice=Close[currentbar];
            // routine to display EUR open to POWER HOURS 
            noeurzone=noeurzone+1;
            ObjectCreate("eurzone"+noeurzone, OBJ_RECTANGLE,0,eurOtime, eurOOprice,pwrOtime,pwrOCprice); 
            if (eurOOprice>pwrOCprice)
               { 
               ObjectSet("eurzone"+noeurzone,OBJPROP_COLOR,FireBrick);
               ObjectCreate("eurzoneH"+noeurzone, OBJ_RECTANGLE,0,eurM1, eurOOprice,eurM2,eurHighest);
               ObjectSet("eurzoneH"+noeurzone,OBJPROP_COLOR,Black);
               ObjectCreate("eurzoneL"+noeurzone, OBJ_RECTANGLE,0,eurM1, pwrOCprice,eurM2,eurLowest);
               ObjectSet("eurzoneL"+noeurzone,OBJPROP_COLOR,Black);
               } 
            else 
               {
               ObjectSet("eurzone"+noeurzone,OBJPROP_COLOR,Black);
               ObjectSet("eurzone"+noeurzone, OBJPROP_BACK, 0);
               ObjectSet("eurzone"+noeurzone, OBJPROP_WIDTH, 2);
               ObjectCreate("eurzoneH"+noeurzone, OBJ_RECTANGLE,0,eurM1, pwrOCprice,eurM2,eurHighest);
               ObjectSet("eurzoneH"+noeurzone,OBJPROP_COLOR,Black);
               ObjectCreate("eurzoneL"+noeurzone, OBJ_RECTANGLE,0,eurM1, eurOOprice,eurM2,eurLowest);
               ObjectSet("eurzoneL"+noeurzone,OBJPROP_COLOR,Black);
               }
         }
         //--
         if (tempstmp=="14") pwrM1=Time[currentbar];
         //--
         if (tempstmp=="16") pwrM2=Time[currentbar];
         //----------------------------------------------------------------------------------------------
         if (tempstmp=="17") // Close of London
            {
            //openhr[currentbar]=Close[currentbar];
            //--
            pwrHighest=High[iHighest(NULL,0,MODE_HIGH,5,currentbar)];
            pwrLowest=Low[iLowest(NULL,0,MODE_LOW,5,currentbar)];
            pwrCtime=Time[currentbar];
            pwrCLprice=Low[currentbar];
            pwrCHprice=High[currentbar];
            pwrCOprice=Open[currentbar];
            pwrCCprice=Close[currentbar];
            // Routine to display POWER HOURS open to close
            nopwrzone=nopwrzone+1;
            if (pwrOtime==0) pwrOtime=pwrCtime;
            ObjectCreate("powerzone"+nopwrzone, OBJ_RECTANGLE,0,pwrOtime, pwrOOprice,pwrCtime,pwrCCprice);
            if (pwrCCprice<pwrOOprice)
               { 
               ObjectSet("powerzone"+nopwrzone,OBJPROP_COLOR,FireBrick);
               ObjectCreate("powerzoneH"+nopwrzone, OBJ_RECTANGLE,0,pwrM1, pwrOOprice,pwrM2,pwrHighest);
               ObjectSet("powerzoneH"+nopwrzone,OBJPROP_COLOR,Black);
               ObjectCreate("powerzoneL"+nopwrzone, OBJ_RECTANGLE,0,pwrM1, pwrCCprice,pwrM2,pwrLowest);
               ObjectSet("powerzoneL"+nopwrzone,OBJPROP_COLOR,Black);
               } 
            else 
               {
               ObjectSet("powerzone"+nopwrzone,OBJPROP_COLOR,Black);
               ObjectSet("powerzone"+nopwrzone, OBJPROP_BACK, 0);
               ObjectSet("powerzone"+nopwrzone, OBJPROP_WIDTH, 2);
               ObjectCreate("powerzoneH"+nopwrzone, OBJ_RECTANGLE,0,pwrM1, pwrCCprice,pwrM2,pwrHighest);
               ObjectSet("powerzoneH"+nopwrzone,OBJPROP_COLOR,Black);
               ObjectCreate("powerzoneL"+nopwrzone, OBJ_RECTANGLE,0,pwrM1, pwrOOprice,pwrM2,pwrLowest);
               ObjectSet("powerzoneL"+nopwrzone,OBJPROP_COLOR,Black);
               }
         timeoweek=TimeDayOfWeek(eurOtime);
         if (timeoweek==1) dayoweek=129;
         if (timeoweek==2) dayoweek=130;
         if (timeoweek==3) dayoweek=131;
         if (timeoweek==4) dayoweek=132;
         if (timeoweek==5) dayoweek=133;
         ObjectCreate("day1"+noeurzone, OBJ_ARROW, 0, pwrM2, pwrLowest);
         ObjectSet("day1"+noeurzone,OBJPROP_COLOR,Black);
         ObjectSet("day1"+noeurzone,OBJPROP_ARROWCODE,dayoweek);
         ObjectSet("day1"+noeurzone,OBJPROP_WIDTH,2);
          }
          //--
         if (tempstmp=="19") usM1=Time[currentbar];
         //--
         if (tempstmp=="20") usM2=Time[currentbar];
         //----------------------------------------------------------------------------------------------
         if (tempstmp=="22") // Close of New York
            {
            //openhr[currentbar]=Close[currentbar];
            //--
            usHighest=High[iHighest(NULL,0,MODE_HIGH,6,currentbar)];
            usLowest=Low[iLowest(NULL,0,MODE_LOW,6,currentbar)];
            usCtime=Time[currentbar];
            usCLprice=Low[currentbar];
            usCHprice=High[currentbar];
            usCOprice=Open[currentbar];
            usCCprice=Close[currentbar];
            // Routine to display POWER HOURS close to US close
            nouszone=nouszone+1;
            if (pwrCtime==0) pwrCtime=usCtime;
            ObjectCreate("uszone"+nouszone, OBJ_RECTANGLE,0,pwrCtime, pwrCOprice,usCtime,usCCprice);
            if (usCCprice<pwrCOprice)
               { 
               ObjectSet("uszone"+nouszone,OBJPROP_COLOR,FireBrick);
               ObjectCreate("uszoneH"+nouszone, OBJ_RECTANGLE,0,usM1, pwrCOprice,usM2,usHighest);
               ObjectSet("uszoneH"+nouszone,OBJPROP_COLOR,Black);
               ObjectCreate("uszoneL"+nouszone, OBJ_RECTANGLE,0,usM1, usCCprice,usM2,usLowest);
               ObjectSet("uszoneL"+nouszone,OBJPROP_COLOR,Black);
               } 
            else 
               {
               ObjectSet("uszone"+nouszone,OBJPROP_COLOR,Black);
               ObjectSet("uszone"+nouszone, OBJPROP_BACK, 0);
               ObjectSet("uszone"+nouszone, OBJPROP_WIDTH, 2);
               ObjectCreate("uszoneH"+nouszone, OBJ_RECTANGLE,0,usM1, usCCprice,usM2,usHighest);
               ObjectSet("uszoneH"+nouszone,OBJPROP_COLOR,Black);
               ObjectCreate("uszoneL"+nouszone, OBJ_RECTANGLE,0,usM1, pwrCOprice,usM2,usLowest);
               ObjectSet("uszoneL"+nouszone,OBJPROP_COLOR,Black);
            } 
      }
      currentbar--; 
      }      
   }
//----  
//----
   return(0);
  }
//+------------------------------------------------------------------+