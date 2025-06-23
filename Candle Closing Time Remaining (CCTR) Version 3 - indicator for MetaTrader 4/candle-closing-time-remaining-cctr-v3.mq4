//+------------------------------------------------------------------+
//| Candle Closing Time Remaining-(CCTR).mq4                         |
//| Copyright 2013-2016,Foad Tahmasebi                               |
//| Version 3.0                                                      |
//+------------------------------------------------------------------+
#property description "Display candle closing time"
#property copyright "Copyright 2013-2016, Foad Tahmasebi <tahmasebi.f@gmail.com>"
#property version   "3.0"
#property indicator_chart_window
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum lctn 
  {
   l1=0,     // Top-Left
   l2=1,     // Top-Right
   l3=2,     // Bottom-Left
   l4=3,// Bottom-Right
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum onoff 
  {
   on=1,     // On
   off=0,     // Off
  };

//--- input parameters
input lctn           location=l1; // Lable Location
input onoff displayServerTime=on; // Display Server Time
input onoff         playAlert=off; // Sound alert when the candle is closed
input string customAlertSound=""; // Custom alert sound
input int            fontSize=9; // Font Size
input color            colour=Silver; // Colour

//--- variables
double leftTime;
string sTime;
int days;
string sCurrentTime;
bool alert_played=false;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void init()
  {
   if(location!=0)
     {
      ObjectCreate("CandleClosingTimeRemaining-CCTR",OBJ_LABEL,0,0,0);
      ObjectSet("CandleClosingTimeRemaining-CCTR",OBJPROP_CORNER,location);
      ObjectSet("CandleClosingTimeRemaining-CCTR",OBJPROP_XDISTANCE,5);
      ObjectSet("CandleClosingTimeRemaining-CCTR",OBJPROP_YDISTANCE,3);
     }
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void deinit()
  {
   ObjectDelete("CandleClosingTimeRemaining-CCTR");
   Comment("");
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
void start()
  {
   sCurrentTime=TimeToStr(TimeCurrent(),TIME_SECONDS);

   leftTime=(Period()*60)-(TimeCurrent()-Time[0]);
   if(playAlert==1 && !alert_played && leftTime<=5)
     {
      if(customAlertSound!="")
        {
         PlaySound(customAlertSound);
           }else{
         PlaySound("alert2.wav");
        }
      alert_played=true;
     }

   if(leftTime>5)
     {
      alert_played=false;
     }

   sTime=TimeToStr(leftTime,TIME_SECONDS);
   if(DayOfWeek()==0 || DayOfWeek()==6)
     {
      if(location==0)
        {
         Comment("CCTR: "+"Market Is Closed");
           }else{
         ObjectSetText("CandleClosingTimeRemaining-CCTR","Market Is Closed",fontSize,"verdana",colour);
        }
        }else{
      if(Period()==PERIOD_MN1 || Period()==PERIOD_W1)
        {
         days=((leftTime/60)/60)/24;
         if(location==0)
           {
            if(!displayServerTime)
              {
               Comment("CCTR: "+days+"D - "+sTime);
                 }else{
               Comment("CCTR: "+days+"D - "+sTime+" ["+sCurrentTime+"]");
              }
              }else{
            if(!displayServerTime)
              {
               ObjectSetText("CandleClosingTimeRemaining-CCTR",days+"D - "+sTime,fontSize,"verdana",colour);
                 }else{
               ObjectSetText("CandleClosingTimeRemaining-CCTR",days+"D - "+sTime+" ["+sCurrentTime+"]",fontSize,"verdana",colour);
              }
           }
           }else{
         if(location==0)
           {
            if(!displayServerTime)
              {
               Comment("CCTR: "+sTime);
                 }else{
               Comment("CCTR: "+sTime+" ["+sCurrentTime+"]");
              }
              }else{
            if(!displayServerTime)
              {
               ObjectSetText("CandleClosingTimeRemaining-CCTR",sTime,fontSize,"verdana",colour);
                 }else{
               ObjectSetText("CandleClosingTimeRemaining-CCTR",sTime+" ["+sCurrentTime+"]",fontSize,"verdana",colour);
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
