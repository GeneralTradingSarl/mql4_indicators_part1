//+------------------------------------------------------------------+
//|                                                      Blue_Spread |
//|                                      Copyright 2015, SelfTraders |
//|                                               http://www.stfx.tk |
//+------------------------------------------------------------------+
#property copyright "SelfTraders"
#property link      "http://www.stfx.tk"
#property indicator_chart_window

int init  (){return(0);}
int deinit(){Comment("");ObjectDelete("RT1");ObjectDelete("RT2");ObjectDelete("RT3");return(0);}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start ()
  {
   Comment("");ObjectDelete("RT1");ObjectDelete("RT2");ObjectDelete("RT3");
   double MBID=MarketInfo(Symbol(),MODE_BID   );
   double MASK=MarketInfo(Symbol(),MODE_ASK   );
   double MSPR=MarketInfo(Symbol(),MODE_SPREAD);
   double timeX;
   if(Period()==1   )timeX=60;if(Period()==5    )timeX=300;if(Period()==15   )timeX=900;
   if(Period()==30  )timeX=1800;if(Period()==60   )timeX=3600;if(Period()==240  )timeX=14400;
   if(Period()==1440)timeX=86400;if(Period()==10080)timeX=604800;if(Period()==43200)timeX=2592000;
   ObjectCreate("RT1",OBJ_RECTANGLE,0,Time[3000]+timeX/2,MBID,TimeCurrent()+timeX*5,MASK);
   ObjectSet("RT1",OBJPROP_COLOR,Blue);
   ObjectCreate("RT2",OBJ_RECTANGLE,0,TimeCurrent()+timeX*5,MBID,TimeCurrent()+timeX*1000,MASK);
   ObjectSet("RT2",OBJPROP_COLOR,DarkBlue);
   ObjectCreate("RT3",OBJ_TEXT,0,TimeCurrent()+timeX*10,(4*MASK+MBID)/5);
   ObjectSetText("RT3",DoubleToStr(MSPR/10,1),8,"Lucida console",White);
   return(0);
  }
//+------------------------------------------------------------------+
