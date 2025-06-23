//+------------------------------------------------------------------+
//|                                                    DIGISTOCH.mq4 |
//|                      Copyright © 2006, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
//+---------------------------------------------------------------------+
//| Author: Muhammad Hamizi Jaminan                                     |
//| Nick: hymns                                                         |
//|                                                                     |
//| Date: December 13, 2006                                             |
//| Custom Indicator: DigiStoch.mq4                                     |
//| Version: 1.0.1"                                                     |
//| Description: Multi TimeFrame Digital Stochastic Indicator           |
//|                                                                     |
//| Change Logs                                                         |
//| Version 1.0.1                                                       |
//|  - Fix little bugs for color and arrow. When price overbought or    |
//|  oversold color change to bearish or bullish begin color. Should be | 
//|  overbought or oversold color and arrow.                            |
//|                                                                     |
//| Version 1.0                                                         |
//| Release DigiStoch ;)                                                |
//+---------------------------------------------------------------------+
#property indicator_separate_window
//----
extern int K_period=8;
extern int D_period=3;
extern int S_period=3;
extern bool Show_Stoch_Value=true;
extern bool Show_Legend=true;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorShortName("DIGISTOCH");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectsDeleteAll(0,OBJ_LABEL);
   ObjectDelete("ObjLabel1"); ObjectDelete("ObjLabel2"); ObjectDelete("ObjLabel3"); ObjectDelete("ObjLabel4");
   ObjectDelete("ObjLabel5"); ObjectDelete("ObjLabel6"); ObjectDelete("ObjLabel7"); ObjectDelete("ObjLabel8");
   ObjectDelete("ObjLabel9"); ObjectDelete("ObjLabel10"); ObjectDelete("ObjLabel11"); ObjectDelete("ObjLabel12");
   ObjectDelete("ObjLabel9a"); ObjectDelete("ObjLabel10a"); ObjectDelete("ObjLabel11a"); ObjectDelete("ObjLabel12a");
   ObjectDelete("ObjLabel13"); ObjectDelete("ObjLabel14"); ObjectDelete("ObjLabel15"); ObjectDelete("ObjLabel16");
   ObjectDelete("ObjLabel13a"); ObjectDelete("ObjLabel14a"); ObjectDelete("ObjLabel15a"); ObjectDelete("ObjLabel16a");
   ObjectDelete("SSIG1"); ObjectDelete("SSIG2"); ObjectDelete("SSIG3"); ObjectDelete("SSIG4"); ObjectDelete("SSIG5"); ObjectDelete("SSIG6");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   //m1 data
   double stoch_main_m1=iStochastic(NULL,PERIOD_M1,K_period,D_period,S_period,MODE_SMA,1,MODE_MAIN,0);
   double stoch_sig_m1=iStochastic(NULL,PERIOD_M1,K_period,D_period,S_period,MODE_SMA,1,MODE_SIGNAL,0);
   //m5 data
   double stoch_main_m5=iStochastic(NULL,PERIOD_M5,K_period,D_period,S_period,MODE_SMA,1,MODE_MAIN,0);
   double stoch_sig_m5=iStochastic(NULL,PERIOD_M5,K_period,D_period,S_period,MODE_SMA,1,MODE_SIGNAL,0);
   //m15 data
   double stoch_main_m15=iStochastic(NULL,PERIOD_M15,K_period,D_period,S_period,MODE_SMA,1,MODE_MAIN,0);
   double stoch_sig_m15=iStochastic(NULL,PERIOD_M15,K_period,D_period,S_period,MODE_SMA,1,MODE_SIGNAL,0);
   //m30 data
   double stoch_main_m30=iStochastic(NULL,PERIOD_M30,K_period,D_period,S_period,MODE_SMA,1,MODE_MAIN,0);
   double stoch_sig_m30=iStochastic(NULL,PERIOD_M30,K_period,D_period,S_period,MODE_SMA,1,MODE_SIGNAL,0);
   //h1 data
   double stoch_main_h1=iStochastic(NULL,PERIOD_H1,K_period,D_period,S_period,MODE_SMA,1,MODE_MAIN,0);
   double stoch_sig_h1=iStochastic(NULL,PERIOD_H1,K_period,D_period,S_period,MODE_SMA,1,MODE_SIGNAL,0);
   //h4 data
   double stoch_main_h4=iStochastic(NULL,PERIOD_H4,K_period,D_period,S_period,MODE_SMA,1,MODE_MAIN,0);
   double stoch_sig_h4=iStochastic(NULL,PERIOD_H4,K_period,D_period,S_period,MODE_SMA,1,MODE_SIGNAL,0);
   //define color
   color stoch_color_m1, stoch_color_m5, stoch_color_m15, stoch_color_m30, stoch_color_h1, stoch_color_h4;
   //define string    
   string stoch_level_m1, stoch_level_m5, stoch_level_m15, stoch_level_m30, stoch_level_h1, stoch_level_h4,
   stoch_arrow_m1, stoch_arrow_m5, stoch_arrow_m15, stoch_arrow_m30, stoch_arrow_h1, stoch_arrow_h4;
   //m1 up trend
   if ((stoch_main_m1>=stoch_sig_m1) && (stoch_sig_m1 < 20) && (stoch_sig_m1!=0)) { stoch_color_m1=YellowGreen; }
   if ((stoch_main_m1>=stoch_sig_m1) && (stoch_sig_m1>=20) && (stoch_sig_m1<=80)) { stoch_color_m1=Lime; }
   if ((stoch_main_m1>=stoch_sig_m1) && (stoch_sig_m1 > 80)) { stoch_color_m1=Green; }
   //m1 down trend
   if ((stoch_main_m1<=stoch_sig_m1) && (stoch_sig_m1 > 80) && (stoch_sig_m1!=100)) { stoch_color_m1=Tomato; }
   if ((stoch_main_m1<=stoch_sig_m1) && (stoch_sig_m1>=20) && (stoch_sig_m1<=80)) { stoch_color_m1=Red; }
   if ((stoch_main_m1<=stoch_sig_m1) && (stoch_sig_m1 < 20)) { stoch_color_m1=FireBrick; }
   //m5 up trend
   if ((stoch_main_m5>=stoch_sig_m5) && (stoch_sig_m5 < 20) && (stoch_sig_m5!=0)) { stoch_color_m5=YellowGreen; }
   if ((stoch_main_m5>=stoch_sig_m5) && (stoch_sig_m5>=20) && (stoch_sig_m5<=80)) { stoch_color_m5=Lime; }
   if ((stoch_main_m5>=stoch_sig_m5) && (stoch_sig_m5 > 80)) { stoch_color_m5=Green; }
   //m5 down trend
   if ((stoch_main_m5<=stoch_sig_m5) && (stoch_sig_m5 > 80) && (stoch_sig_m5!=100)) { stoch_color_m5=Tomato; }
   if ((stoch_main_m5<=stoch_sig_m5) && (stoch_sig_m5>=20) && (stoch_sig_m5<=80)) { stoch_color_m5=Red; }
   if ((stoch_main_m5<=stoch_sig_m5) && (stoch_sig_m5 < 20)) { stoch_color_m5=FireBrick; }
   //m15 up trend
   if ((stoch_main_m15>=stoch_sig_m15) && (stoch_sig_m15 < 20) && (stoch_sig_m15!=0)) { stoch_color_m15=YellowGreen; }
   if ((stoch_main_m15>=stoch_sig_m15) && (stoch_sig_m15>=20) && (stoch_sig_m15<=80)) { stoch_color_m15=Lime; }
   if ((stoch_main_m15>=stoch_sig_m15) && (stoch_sig_m15 > 80)) { stoch_color_m15=Green; }
   //m15 down trend
   if ((stoch_main_m15<=stoch_sig_m15) && (stoch_sig_m15 > 80) && (stoch_sig_m15!=100)) { stoch_color_m15=Tomato; }
   if ((stoch_main_m15<=stoch_sig_m15) && (stoch_sig_m15>=20) && (stoch_sig_m15<=80)) { stoch_color_m15=Red; }
   if ((stoch_main_m15<=stoch_sig_m15) && (stoch_sig_m15 < 20)) { stoch_color_m15=FireBrick; }
   //m30 up trend
   if ((stoch_main_m30>=stoch_sig_m30) && (stoch_sig_m30 < 20) && (stoch_sig_m30!=0)) { stoch_color_m30=YellowGreen; }
   if ((stoch_main_m30>=stoch_sig_m30) && (stoch_sig_m30>=20) && (stoch_sig_m30<=80)) { stoch_color_m30=Lime; }
   if ((stoch_main_m30>=stoch_sig_m30) && (stoch_sig_m30 > 80)) { stoch_color_m30=Green; }
   //m30 down trend
   if ((stoch_main_m30<=stoch_sig_m30) && (stoch_sig_m30 > 80) && (stoch_sig_m30!=100)) { stoch_color_m30=Tomato; }
   if ((stoch_main_m30<=stoch_sig_m30) && (stoch_sig_m30>=20) && (stoch_sig_m30<=80)) { stoch_color_m30=Red; }
   if ((stoch_main_m30<=stoch_sig_m30) && (stoch_sig_m30 < 20)) { stoch_color_m30=FireBrick; }
   //h1 up trend
   if ((stoch_main_h1>=stoch_sig_h1) && (stoch_sig_h1 < 20) && (stoch_sig_h1!=0)) { stoch_color_h1=YellowGreen; }
   if ((stoch_main_h1>=stoch_sig_h1) && (stoch_sig_h1>=20) && (stoch_sig_h1<=80)) { stoch_color_h1=Lime; }
   if ((stoch_main_h1>=stoch_sig_h1) && (stoch_sig_h1 > 80)) { stoch_color_h1=Green; }
   //h1 down trend
   if ((stoch_main_h1<=stoch_sig_h1) && (stoch_sig_h1 > 80) && (stoch_sig_h1!=100)) { stoch_color_h1=Tomato; }
   if ((stoch_main_h1<=stoch_sig_h1) && (stoch_sig_h1>=20) && (stoch_sig_h1<=80)) { stoch_color_h1=Red; }
   if ((stoch_main_h1<=stoch_sig_h1) && (stoch_sig_h1 < 20)) { stoch_color_h1=FireBrick; }
   //h4 up trend
   if ((stoch_main_h4>=stoch_sig_h4) && (stoch_sig_h4 < 20) && (stoch_sig_h4!=0)) { stoch_color_h4=YellowGreen; }
   if ((stoch_main_h4>=stoch_sig_h4) && (stoch_sig_h4>=20) && (stoch_sig_h4<=80)) { stoch_color_h4=Lime; }
   if ((stoch_main_h4>=stoch_sig_h4) && (stoch_sig_h4 > 80)) { stoch_color_h4=Green; }
   //h4 down trend
   if ((stoch_main_h4<=stoch_sig_h4) && (stoch_sig_h4 > 80) && (stoch_sig_h4!=100)) { stoch_color_h4=Tomato; }
   if ((stoch_main_h4<=stoch_sig_h4) && (stoch_sig_h4>=20) && (stoch_sig_h4<=80)) { stoch_color_h4=Red; }
   if ((stoch_main_h4<=stoch_sig_h4) && (stoch_sig_h4 < 20)) { stoch_color_h4=FireBrick; }
   //Signal Labels           
   ObjectCreate("ObjLabel1", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0); //LABEL
   ObjectSetText("ObjLabel1","SIGNAL",8, "Arial Bold", Silver);
   ObjectSet("ObjLabel1", OBJPROP_CORNER, 0);
   ObjectSet("ObjLabel1", OBJPROP_XDISTANCE, 105);
   ObjectSet("ObjLabel1", OBJPROP_YDISTANCE, 3);
   //
   ObjectCreate("SSIG1", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0);//M1 SIGNAL
   ObjectSetText("SSIG1","M1",9, "Arial Bold", stoch_color_m1);
   ObjectSet("SSIG1", OBJPROP_CORNER, 0);
   ObjectSet("SSIG1", OBJPROP_XDISTANCE, 150);
   ObjectSet("SSIG1", OBJPROP_YDISTANCE, 3);
   //
   ObjectCreate("SSIG2", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0);//M5 SIGNAL
   ObjectSetText("SSIG2","M5",9, "Arial Bold", stoch_color_m5);
   ObjectSet("SSIG2", OBJPROP_CORNER, 0);
   ObjectSet("SSIG2", OBJPROP_XDISTANCE, 175);
   ObjectSet("SSIG2", OBJPROP_YDISTANCE, 3);
   //
   ObjectCreate("SSIG3", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0);//M15 SIGNAL
   ObjectSetText("SSIG3","M15",9, "Arial Bold", stoch_color_m15);
   ObjectSet("SSIG3", OBJPROP_CORNER, 0);
   ObjectSet("SSIG3", OBJPROP_XDISTANCE, 200);
   ObjectSet("SSIG3", OBJPROP_YDISTANCE, 3);
   //
   ObjectCreate("SSIG4", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0);//M30 SIGNAL
   ObjectSetText("SSIG4","M30",9, "Arial Bold", stoch_color_m30);
   ObjectSet("SSIG4", OBJPROP_CORNER, 0);
   ObjectSet("SSIG4", OBJPROP_XDISTANCE, 230);
   ObjectSet("SSIG4", OBJPROP_YDISTANCE, 3);
   //
   ObjectCreate("SSIG5", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0);//H1 SIGNAL
   ObjectSetText("SSIG5","H1",9, "Arial Bold", stoch_color_h1);
   ObjectSet("SSIG5", OBJPROP_CORNER, 0);
   ObjectSet("SSIG5", OBJPROP_XDISTANCE, 260);
   ObjectSet("SSIG5", OBJPROP_YDISTANCE, 3);
   //
   ObjectCreate("SSIG6", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0);//H4 SIGNAL
   ObjectSetText("SSIG6","H4",9, "Arial Bold", stoch_color_h4);
   ObjectSet("SSIG6", OBJPROP_CORNER, 0);
   ObjectSet("SSIG6", OBJPROP_XDISTANCE, 280);
   ObjectSet("SSIG6", OBJPROP_YDISTANCE, 3);
   //Show Digital Stochastic Value
   if (Show_Stoch_Value==true)
     {
      //stochastic value
      string stoch_m1_val=stoch_sig_m1;
      string stoch_m5_val=stoch_sig_m5;
      string stoch_m15_val=stoch_sig_m15;
      string stoch_m30_val=stoch_sig_m30;
      string stoch_h1_val=stoch_sig_h1;
      string stoch_h4_val=stoch_sig_h4;
//----
      if (stoch_main_m1>=stoch_sig_m1 && stoch_sig_m1 > 0) { stoch_arrow_m1="Ù"; }
      if (stoch_main_m1<=stoch_sig_m1 && stoch_sig_m1 < 100) { stoch_arrow_m1="Ú"; }
      if (stoch_main_m5>=stoch_sig_m5 && stoch_sig_m5 > 0) { stoch_arrow_m5="Ù"; }
      if (stoch_main_m5<=stoch_sig_m5 && stoch_sig_m5 < 100) { stoch_arrow_m5="Ú"; }
      if (stoch_main_m15>=stoch_sig_m15 && stoch_sig_m15 > 0) { stoch_arrow_m15="Ù"; }
      if (stoch_main_m15<=stoch_sig_m15 && stoch_sig_m15 < 100) { stoch_arrow_m15="Ú"; }
      if (stoch_main_m30>=stoch_sig_m30 && stoch_sig_m30 > 0) { stoch_arrow_m30="Ù"; }
      if (stoch_main_m30<=stoch_sig_m30 && stoch_sig_m30 < 100) { stoch_arrow_m30="Ú"; }
      if (stoch_main_h1>=stoch_sig_h1 && stoch_sig_h1 > 0) { stoch_arrow_h1="Ù"; }
      if (stoch_main_h1<=stoch_sig_h1 && stoch_sig_h1 < 100) { stoch_arrow_h1="Ú"; }
      if (stoch_main_h4>=stoch_sig_h4 && stoch_sig_h4 > 0) { stoch_arrow_h4="Ù"; }
      if (stoch_main_h4<=stoch_sig_h4 && stoch_sig_h4 < 100) { stoch_arrow_h4="Ú"; }
      //stochastic value
      ObjectCreate("ObjLabel15", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0);
      ObjectSetText("ObjLabel15","STOCHASTIC",8, "Arial Bold", Silver);
      ObjectSet("ObjLabel15", OBJPROP_CORNER, 0);
      ObjectSet("ObjLabel15", OBJPROP_XDISTANCE, 310);
      ObjectSet("ObjLabel15", OBJPROP_YDISTANCE, 3);
      //stoch m1 value
      ObjectCreate("ObjLabel9", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0);
      ObjectSetText("ObjLabel9","M1  : "+StringSubstr(stoch_m1_val,0,5)+" ",8, "Arial Bold", stoch_color_m1);
      ObjectSet("ObjLabel9", OBJPROP_CORNER, 0);
      ObjectSet("ObjLabel9", OBJPROP_XDISTANCE, 380);
      ObjectSet("ObjLabel9", OBJPROP_YDISTANCE, 2);
      //arrow m1
      ObjectCreate("ObjLabel9a", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0);
      ObjectSetText("ObjLabel9a",stoch_arrow_m1,8, "Wingdings", stoch_color_m1);
      ObjectSet("ObjLabel9a", OBJPROP_CORNER, 0);
      ObjectSet("ObjLabel9a", OBJPROP_XDISTANCE, 435);
      ObjectSet("ObjLabel9a", OBJPROP_YDISTANCE, 3);
      //stoch m30 value
      ObjectCreate("ObjLabel10", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0);
      ObjectSetText("ObjLabel10","M30: "+StringSubstr(stoch_m30_val,0,5),8, "Arial Bold", stoch_color_m30);
      ObjectSet("ObjLabel10", OBJPROP_CORNER, 0);
      ObjectSet("ObjLabel10", OBJPROP_XDISTANCE, 380);
      ObjectSet("ObjLabel10", OBJPROP_YDISTANCE, 12);
      //arrow m30
      ObjectCreate("ObjLabel10a", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0);
      ObjectSetText("ObjLabel10a",stoch_arrow_m30,8, "Wingdings", stoch_color_m30);
      ObjectSet("ObjLabel10a", OBJPROP_CORNER, 0);
      ObjectSet("ObjLabel10a", OBJPROP_XDISTANCE, 435);
      ObjectSet("ObjLabel10a", OBJPROP_YDISTANCE, 13);
      //stoch m5 value            
      ObjectCreate("ObjLabel11", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0);
      ObjectSetText("ObjLabel11","M5: "+StringSubstr(stoch_m5_val,0,5),8, "Arial Bold", stoch_color_m5);
      ObjectSet("ObjLabel11", OBJPROP_CORNER, 0);
      ObjectSet("ObjLabel11", OBJPROP_XDISTANCE, 460);
      ObjectSet("ObjLabel11", OBJPROP_YDISTANCE, 2);
      //arrow m5
      ObjectCreate("ObjLabel11a", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0);
      ObjectSetText("ObjLabel11a",stoch_arrow_m5,8, "Wingdings", stoch_color_m5);
      ObjectSet("ObjLabel11a", OBJPROP_CORNER, 0);
      ObjectSet("ObjLabel11a", OBJPROP_XDISTANCE, 510);
      ObjectSet("ObjLabel11a", OBJPROP_YDISTANCE, 3);
      //stoch h1 value
      ObjectCreate("ObjLabel12", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0);
      ObjectSetText("ObjLabel12","H1 : "+StringSubstr(stoch_h1_val,0,5),8, "Arial Bold", stoch_color_h1);
      ObjectSet("ObjLabel12", OBJPROP_CORNER, 0);
      ObjectSet("ObjLabel12", OBJPROP_XDISTANCE, 460);
      ObjectSet("ObjLabel12", OBJPROP_YDISTANCE, 12);
      //arrow h1
      ObjectCreate("ObjLabel12a", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0);
      ObjectSetText("ObjLabel12a",stoch_arrow_h1,8, "Wingdings", stoch_color_h1);
      ObjectSet("ObjLabel12a", OBJPROP_CORNER, 0);
      ObjectSet("ObjLabel12a", OBJPROP_XDISTANCE, 510);
      ObjectSet("ObjLabel12a", OBJPROP_YDISTANCE, 13);
      //stoch m15 value        
      ObjectCreate("ObjLabel13", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0);
      ObjectSetText("ObjLabel13","M15: "+StringSubstr(stoch_m15_val,0,5),8, "Arial Bold", stoch_color_m15);
      ObjectSet("ObjLabel13", OBJPROP_CORNER, 0);
      ObjectSet("ObjLabel13", OBJPROP_XDISTANCE, 535);
      ObjectSet("ObjLabel13", OBJPROP_YDISTANCE, 2);
      //arrow m15
      ObjectCreate("ObjLabel13a", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0);
      ObjectSetText("ObjLabel13a",stoch_arrow_m15,8, "Wingdings", stoch_color_m15);
      ObjectSet("ObjLabel13a", OBJPROP_CORNER, 0);
      ObjectSet("ObjLabel13a", OBJPROP_XDISTANCE, 590);
      ObjectSet("ObjLabel13a", OBJPROP_YDISTANCE, 3);
      //stoch h4 value
      ObjectCreate("ObjLabel14", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0);
      ObjectSetText("ObjLabel14","H4   : "+StringSubstr(stoch_h4_val,0,5),8, "Arial Bold", stoch_color_h4);
      ObjectSet("ObjLabel14", OBJPROP_CORNER, 0);
      ObjectSet("ObjLabel14", OBJPROP_XDISTANCE, 535);
      ObjectSet("ObjLabel14", OBJPROP_YDISTANCE, 12);
      //arrow h4
      ObjectCreate("ObjLabel14a", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0);
      ObjectSetText("ObjLabel14a",stoch_arrow_h4,8, "Wingdings", stoch_color_h4);
      ObjectSet("ObjLabel14a", OBJPROP_CORNER, 0);
      ObjectSet("ObjLabel14a", OBJPROP_XDISTANCE, 590);
      ObjectSet("ObjLabel14a", OBJPROP_YDISTANCE, 13);
     }
   //Show Legend
   if (Show_Legend==true)
     {
      ObjectCreate("ObjLabel2", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0);
      ObjectSetText("ObjLabel2","LEGEND",8, "Arial Bold", Silver);
      ObjectSet("ObjLabel2", OBJPROP_CORNER, 0);
      ObjectSet("ObjLabel2", OBJPROP_XDISTANCE, 615);
      ObjectSet("ObjLabel2", OBJPROP_YDISTANCE, 3);
      //
      ObjectCreate("ObjLabel3", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0);
      ObjectSetText("ObjLabel3","* TREND UP",8, "Arial Bold", Lime);
      ObjectSet("ObjLabel3", OBJPROP_CORNER, 0);
      ObjectSet("ObjLabel3", OBJPROP_XDISTANCE, 665);
      ObjectSet("ObjLabel3", OBJPROP_YDISTANCE, 2);
      //
      ObjectCreate("ObjLabel4", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0);
      ObjectSetText("ObjLabel4","* TREND DN",8, "Arial Bold", Red);
      ObjectSet("ObjLabel4", OBJPROP_CORNER, 0);
      ObjectSet("ObjLabel4", OBJPROP_XDISTANCE, 665);
      ObjectSet("ObjLabel4", OBJPROP_YDISTANCE, 12);
      //
      ObjectCreate("ObjLabel5", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0);
      ObjectSetText("ObjLabel5","* OVERBOUGHT",8, "Arial Bold", Green);
      ObjectSet("ObjLabel5", OBJPROP_CORNER, 0);
      ObjectSet("ObjLabel5", OBJPROP_XDISTANCE, 735);
      ObjectSet("ObjLabel5", OBJPROP_YDISTANCE, 2);
      //
      ObjectCreate("ObjLabel6", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0);
      ObjectSetText("ObjLabel6","* OVERSOLD",8, "Arial Bold", FireBrick);
      ObjectSet("ObjLabel6", OBJPROP_CORNER, 0);
      ObjectSet("ObjLabel6", OBJPROP_XDISTANCE, 735);
      ObjectSet("ObjLabel6", OBJPROP_YDISTANCE, 12);
      //
      ObjectCreate("ObjLabel7", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0);
      ObjectSetText("ObjLabel7","* BULLISH START",8, "Arial Bold", YellowGreen);
      ObjectSet("ObjLabel7", OBJPROP_CORNER, 0);
      ObjectSet("ObjLabel7", OBJPROP_XDISTANCE, 825);
      ObjectSet("ObjLabel7", OBJPROP_YDISTANCE, 2);
      //
      ObjectCreate("ObjLabel8", OBJ_LABEL, WindowFind("DIGISTOCH"), 0, 0);
      ObjectSetText("ObjLabel8","* BEARISH START",8, "Arial Bold", Tomato);
      ObjectSet("ObjLabel8", OBJPROP_CORNER, 0);
      ObjectSet("ObjLabel8", OBJPROP_XDISTANCE, 825);
      ObjectSet("ObjLabel8", OBJPROP_YDISTANCE, 12);
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+