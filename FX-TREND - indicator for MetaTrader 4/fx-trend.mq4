//+------------------------------------------------------------------+
//|                         FerruFx_Multi_info+_light_chart_v1.1.mq4 |
//|                                        Copyright © 2007, FerruFx |
//|                                                                  |
//+------------------------------------------------------------------+

// Version "Light": only the results are displayed

// Version "Light" v1.1: you can choose which indicators and TF you want to calculate the trend

#property indicator_chart_window

#property indicator_minimum 0
#property indicator_maximum 1

//---- Positionning the boxs

//---- Positionning the boxs



extern string    Trend_box2             = "=== Trend Box2 ===";
 bool      box_trend2             =    true;
extern int       X_trend2               =    840;
extern int       Y_trend2               =      20;







//---- Level to change the strength "weak" to "strong"
 double TrendStrongLevel = 75.00;

//---- Indicators to calculate the trend
 string    Trend_calculation     = "=== Trend calculation and display ===";
 bool      display_fast_MA       =     false;
 bool      display_medium_MA     =     false;
 bool      display_slow_MA       =     false;
 bool      display_CCI           =     false;
 bool      display_MACD          =     false;
 bool      display_ADX           =     false;
 bool      display_BULLS         =     false;
 bool      display_BEARS         =     false;
 bool      display_STOCH         =     false;
 bool      display_RSI           =     false;
 bool      display_FORCE         =     false;
 bool      display_MOMENTUM      =     false;
 bool      display_DeMARKER      =     false;
 bool      display_WAE           =     true;

//---- Timeframes to display and calculate the trend
 string    TF_calculation        = "=== If display false, set coef to 0 ===";
 string    Coefs_TF              = "3 TF true, SUM of their coef must be 3";
 bool      display_M1            =     false;
 double    coef_m1               =      1.0;
 bool      display_M5            =     false;
 double    coef_m5               =      1.0;
 bool      display_M15           =     false;
 double    coef_m15              =      1.0;
 bool      display_M30           =     false;
 double    coef_m30              =      1.0;
 bool      display_H1            =     false;
 double    coef_H1               =      1.0;
 bool      display_H4            =     false;
 double    coef_H4               =      1.0;
 bool      display_D1            =     true;
 double    coef_D1               =      1.0;

//---- Indicators parameters
 string    Shift_Settings_test_only        = "=== Format: 2007.05.07 00:00 ===";
 datetime  look_time_shift       = D'2007.05.07 00:00';  // Shift for test if "test" is true
 double    shift_indicators      =                   0;  // Shift for indicators if "test" is false
 bool      test                  =               false;



int TimeZone=0;
bool pivots = true;
bool alert = true;

double yesterday_high=0;
double yesterday_open=0;
double yesterday_low=0;
double yesterday_close=0;
double today_open=0;
double today_high=0;
double today_low=0;

double rates_h1[2][6];
double rates_d1[2][6];



//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {



//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----

   
   ObjectDelete("Trend_UP");
   ObjectDelete("line9");
   ObjectDelete("Trend_UP_text");
   ObjectDelete("Trend_UP_value");
   ObjectDelete("Trend_DOWN_text");
   ObjectDelete("Trend_DOWN_value");
   ObjectDelete("line10");
   ObjectDelete("line12");
   ObjectDelete("Trend");
   ObjectDelete("Trend_comment");
   ObjectDelete("line13");
   ObjectDelete("line11");
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
  
double UP_1, UP_2, UP_3, UP_4, UP_5, UP_6, UP_7, UP_8, UP_9, UP_10;
double UP_11, UP_12, UP_13, UP_14, UP_15, UP_16, UP_17, UP_18, UP_19, UP_20;
double UP_21, UP_22, UP_23, UP_24, UP_25, UP_26, UP_27, UP_28, UP_29, UP_30;
double UP_31, UP_32, UP_33, UP_34, UP_35, UP_36, UP_37, UP_38, UP_39, UP_40;
double UP_41, UP_42, UP_43, UP_44, UP_45, UP_46, UP_47, UP_48, UP_49, UP_50;
double UP_51, UP_52, UP_53, UP_54, UP_55, UP_56, UP_57, UP_58, UP_59, UP_60;
double UP_61, UP_62, UP_63, UP_64;

double DOWN_1, DOWN_2, DOWN_3, DOWN_4, DOWN_5, DOWN_6, DOWN_7, DOWN_8, DOWN_9, DOWN_10;
double DOWN_11, DOWN_12, DOWN_13, DOWN_14, DOWN_15, DOWN_16, DOWN_17, DOWN_18, DOWN_19, DOWN_20;
double DOWN_21, DOWN_22, DOWN_23, DOWN_24, DOWN_25, DOWN_26, DOWN_27, DOWN_28, DOWN_29, DOWN_30;
double DOWN_31, DOWN_32, DOWN_33, DOWN_34, DOWN_35, DOWN_36, DOWN_37, DOWN_38, DOWN_39, DOWN_40;
double DOWN_41, DOWN_42, DOWN_43, DOWN_44, DOWN_45, DOWN_46, DOWN_47, DOWN_48, DOWN_49, DOWN_50;
double DOWN_51, DOWN_52, DOWN_53, DOWN_54, DOWN_55, DOWN_56, DOWN_57, DOWN_58, DOWN_59, DOWN_60;
double DOWN_61, DOWN_62, DOWN_63, DOWN_64;

double UP_65, UP_66, UP_67, UP_68, UP_69, UP_70;
double UP_71, UP_72, UP_73, UP_74, UP_75, UP_76, UP_77, UP_78, UP_79, UP_80;
double UP_81, UP_82, UP_83, UP_84, UP_85, UP_86, UP_87, UP_88, UP_89, UP_90;
double UP_91, UP_92, UP_93, UP_94, UP_95, UP_96, UP_97, UP_98, UP_99, UP_100;
double UP_101, UP_102, UP_103, UP_104, UP_105, UP_106, UP_107, UP_108, UP_109, UP_110;
double UP_111, UP_112;

double DOWN_65, DOWN_66, DOWN_67, DOWN_68, DOWN_69, DOWN_70;
double DOWN_71, DOWN_72, DOWN_73, DOWN_74, DOWN_75, DOWN_76, DOWN_77, DOWN_78, DOWN_79, DOWN_80;
double DOWN_81, DOWN_82, DOWN_83, DOWN_84, DOWN_85, DOWN_86, DOWN_87, DOWN_88, DOWN_89, DOWN_90;
double DOWN_91, DOWN_92, DOWN_93, DOWN_94, DOWN_95, DOWN_96, DOWN_97, DOWN_98, DOWN_99, DOWN_100;
double DOWN_101, DOWN_102, DOWN_103, DOWN_104, DOWN_105, DOWN_106, DOWN_107, DOWN_108, DOWN_109, DOWN_110;
double DOWN_111, DOWN_112;
  
double count_m1, count_m5, count_m15, count_m30, count_h1, count_h4, count_d1;

  if ( display_M1 == true) { count_m1 = 1; }
  if ( display_M5 == true) { count_m5 = 1; }
  if ( display_M15 == true) { count_m15 = 1; }
  if ( display_M30 == true) { count_m30 = 1; }
  if ( display_H1 == true) { count_h1 = 1; }
  if ( display_H4 == true) { count_h4 = 1; }
  if ( display_D1 == true) { count_d1 = 1; }
  

  
   
// Shift calculation for indicators (tests only)

   double shift_1, shift_5, shift_15, shift_30, shift_60, shift_240, shift_1440, shift_10080;
   
   if( test == true )
   {
    shift_1=iBarShift(NULL,PERIOD_M1,look_time_shift,false);
    shift_5=iBarShift(NULL,PERIOD_M5,look_time_shift,false);
    shift_15=iBarShift(NULL,PERIOD_M15,look_time_shift,false);
    shift_30=iBarShift(NULL,PERIOD_M30,look_time_shift,false);
    shift_60=iBarShift(NULL,PERIOD_H1,look_time_shift,false);
    shift_240=iBarShift(NULL,PERIOD_H4,look_time_shift,false);
    shift_1440=iBarShift(NULL,PERIOD_D1,look_time_shift,false);
    shift_10080=iBarShift(NULL,PERIOD_W1,look_time_shift,false);
   }
   else
   {
    shift_1=shift_indicators;
    shift_5=shift_indicators;
    shift_15=shift_indicators;
    shift_30=shift_indicators;
    shift_60=shift_indicators;
    shift_240=shift_indicators;
    shift_1440=shift_indicators;
    shift_10080=shift_indicators;
   }
   
// Indicator (Moving Average)

   // FAST
   
   if( display_fast_MA == true )
   {
   if( display_M1 == true )
   {
   double FastMA_1_1 = iCustom(NULL,PERIOD_H4, "FX-AO",0,0);
   double FastMA_2_1 = iCustom(NULL,PERIOD_H4, "FX-AO",0,1);
   if ((FastMA_1_1 < FastMA_2_1)) { UP_1 = 1; DOWN_1 = 0; }
   if ((FastMA_1_1 > FastMA_2_1)) { UP_1 = 0; DOWN_1 = 1; }
   }
  
   if( display_M5 == true )
   {   
   double FastMA_1_5 = iCustom(NULL,PERIOD_D1, "FX-AO",0,0);
   double FastMA_2_5 = iCustom(NULL,PERIOD_D1, "FX-AO",0,1);
   if ((FastMA_1_5 < FastMA_2_5)) { UP_2 = 1; DOWN_2 = 0; }
   if ((FastMA_1_5 > FastMA_2_5)) { UP_2 = 0; DOWN_2 = 1; }
   }
   
   if( display_M15 == true )
   {   
   double FastMA_1_15 = iCustom(NULL,PERIOD_W1, "FX-AO",0,0);
   double FastMA_2_15 = iCustom(NULL,PERIOD_W1, "FX-AO",0,1);
   if ((FastMA_1_15 < FastMA_2_15)) { UP_3 = 1; DOWN_3 = 0; }
   if ((FastMA_1_15 > FastMA_2_15)) { UP_3 = 0; DOWN_3 = 1; }
   }
   
   if( display_M30 == true )
   {   
   double FastMA_1_30 = iCustom(NULL,PERIOD_H4, "FX-AO",0,0);
   double FastMA_2_30 = iCustom(NULL,PERIOD_H4, "FX-AO",0,1);
   if ((FastMA_1_30 < FastMA_2_30)) { UP_4 = 1; DOWN_4 = 0; }
   if ((FastMA_1_30 > FastMA_2_30)) { UP_4 = 0; DOWN_4 = 1; }
   }
   
   if( display_H1 == true )
   {  
   double FastMA_1_60 = iCustom(NULL,PERIOD_D1, "FX-AO",0,0);
   double FastMA_2_60 = iCustom(NULL,PERIOD_D1, "FX-AO",0,1);
   if ((FastMA_1_60 < FastMA_2_60)) { UP_5 = 1; DOWN_5 = 0; }
   if ((FastMA_1_60 > FastMA_2_60)) { UP_5 = 0; DOWN_5 = 1; }
   }
   
   if( display_H4 == true )
   {
   double FastMA_1_240 = iCustom(NULL,PERIOD_W1, "FX-AO",0,0);
   double FastMA_2_240 = iCustom(NULL,PERIOD_W1, "FX-AO",0,1);
   if ((FastMA_1_240 < FastMA_2_240)) { UP_6 = 1; DOWN_6 = 0; }
   if ((FastMA_1_240 > FastMA_2_240)) { UP_6 = 0; DOWN_6 = 1; }
   }
   
   if( display_D1 == true )
   {
   double FastMA_1_1440 = iCustom(NULL,PERIOD_H4, "FX-AO",0,0);
   double FastMA_2_1440 = iCustom(NULL,PERIOD_H4, "FX-AO",0,1);
   if ((FastMA_1_1440 < FastMA_2_1440)) { UP_7 = 1; DOWN_7 = 0; }
   if ((FastMA_1_1440 > FastMA_2_1440)) { UP_7 = 0; DOWN_7 = 1; }
   }
   }
   
   // MEDIUM
   
   if( display_medium_MA == true )
   {
   if( display_M1 == true )
   {
   double MediumMA_1_1 = iCustom(NULL, PERIOD_H4, "FX-BAR",0,0);
   double MediumMA_2_1 = iCustom(NULL, PERIOD_H4, "FX-BAR",0,1);
   if ((MediumMA_1_1 < MediumMA_2_1)) { UP_9 = 1; DOWN_9 = 0; }
   if ((MediumMA_1_1 > MediumMA_2_1)) { UP_9 = 0; DOWN_9 = 1; }
   }
   
   if( display_M5 == true )
   {
   double MediumMA_1_5 = iCustom(NULL, PERIOD_H4, "FX-BAR",0,0);
   double MediumMA_2_5 = iCustom(NULL, PERIOD_H4, "FX-BAR",0,1);
   if ((MediumMA_1_5 < MediumMA_2_5)) { UP_10 = 1; DOWN_10 = 0; }
   if ((MediumMA_1_5 > MediumMA_2_5)) { UP_10 = 0; DOWN_10 = 1; }
   }
   
   if( display_M15 == true )
   {
   double MediumMA_1_15 = iCustom(NULL, PERIOD_H4, "FX-BAR",0,0);
   double MediumMA_2_15 = iCustom(NULL, PERIOD_H4, "FX-BAR",0,1);
   if ((MediumMA_1_15 < MediumMA_2_15)) { UP_11 = 1; DOWN_11 = 0; }
   if ((MediumMA_1_15 > MediumMA_2_15)) { UP_11 = 0; DOWN_11 = 1; }
   }
   
   if( display_M30 == true )
   {
   double MediumMA_1_30 = iCustom(NULL, PERIOD_D1, "FX-BAR",0,0);
   double MediumMA_2_30 = iCustom(NULL, PERIOD_D1, "FX-BAR",0,1);
   if ((MediumMA_1_30 < MediumMA_2_30)) { UP_12 = 1; DOWN_12 = 0; }
   if ((MediumMA_1_30 > MediumMA_2_30)) { UP_12 = 0; DOWN_12 = 1; }
   }
   
   if( display_H1 == true )
   {
   double MediumMA_1_60 = iCustom(NULL, PERIOD_D1, "FX-BAR",0,0);
   double MediumMA_2_60 = iCustom(NULL, PERIOD_D1, "FX-BAR",0,1);
   if ((MediumMA_1_60 < MediumMA_2_60)) { UP_13 = 1; DOWN_13 = 0; }
   if ((MediumMA_1_60 > MediumMA_2_60)) { UP_13 = 0; DOWN_13 = 1; }
   }
   
   if( display_H4 == true )
   {
   double MediumMA_1_240 = iCustom(NULL, PERIOD_W1, "FX-BAR",0,0);
   double MediumMA_2_240 = iCustom(NULL, PERIOD_W1, "FX-BAR",0,1);
   if ((MediumMA_1_240 < MediumMA_2_240)) { UP_14 = 1; DOWN_14 = 0; }
   if ((MediumMA_1_240 > MediumMA_2_240)) { UP_14 = 0; DOWN_14 = 1; }
   }
   
   if( display_D1 == true )
   {
   double MediumMA_1_1440 = iCustom(NULL, PERIOD_W1, "FX-BAR",0,0);
   double MediumMA_2_1440 = iCustom(NULL, PERIOD_W1, "FX-BAR",0,1);
   if ((MediumMA_1_1440 < MediumMA_2_1440)) { UP_15 = 1; DOWN_15 = 0; }
   if ((MediumMA_1_1440 > MediumMA_2_1440)) { UP_15 = 0; DOWN_15 = 1; }
   }
   }
   
   // SLOW
   
   if( display_slow_MA == true )
   {
   if( display_M1 == true )
   {
   double SlowMA_1_1 = iCustom(NULL, PERIOD_H4, "FX-AO",0,0);
   double SlowMA_2_1 = iCustom(NULL, PERIOD_H4, "FX-AO",0,1);
   if ((SlowMA_1_1 < SlowMA_2_1)) { UP_17 = 1; DOWN_17 = 0; }
   if ((SlowMA_1_1 > SlowMA_2_1)) { UP_17 = 0; DOWN_17 = 1; }
   }
   
   if( display_M5 == true )
   {
   double SlowMA_1_5 = iCustom(NULL, PERIOD_H4, "FX-AO",0,0);
   double SlowMA_2_5 = iCustom(NULL, PERIOD_H4, "FX-AO",0,1);
   if ((SlowMA_1_5 < SlowMA_2_5)) { UP_18 = 1; DOWN_18 = 0; }
   if ((SlowMA_1_5 > SlowMA_2_5)) { UP_18 = 0; DOWN_18 = 1; }
   }
   
   if( display_M15 == true )
   {
   double SlowMA_1_15 = iCustom(NULL, PERIOD_H4, "FX-AO",0,0);
   double SlowMA_2_15 = iCustom(NULL, PERIOD_H4, "FX-AO",0,1);
   if ((SlowMA_1_15 < SlowMA_2_15)) { UP_19 = 1; DOWN_19 = 0; }
   if ((SlowMA_1_15 > SlowMA_2_15)) { UP_19 = 0; DOWN_19 = 1; }
   }
   
   if( display_M30 == true )
   {
   double SlowMA_1_30 = iCustom(NULL, PERIOD_D1, "FX-AO",0,0);
   double SlowMA_2_30 = iCustom(NULL, PERIOD_D1, "FX-AO",0,1);
   if ((SlowMA_1_30 < SlowMA_2_30)) { UP_20 = 1; DOWN_20 = 0; }
   if ((SlowMA_1_30 > SlowMA_2_30)) { UP_20 = 0; DOWN_20 = 1; }
   }
   
   if( display_H1 == true )
   {
   double SlowMA_1_60 = iCustom(NULL, PERIOD_D1, "FX-AO",0,0);
   double SlowMA_2_60 = iCustom(NULL, PERIOD_D1, "FX-AO",0,1);
   if ((SlowMA_1_60 < SlowMA_2_60)) { UP_21 = 1; DOWN_21 = 0; }
   if ((SlowMA_1_60 > SlowMA_2_60)) { UP_21 = 0; DOWN_21 = 1; }
   }
   
   if( display_H4 == true )
   {
   double SlowMA_1_240 = iCustom(NULL, PERIOD_W1, "FX-AO",0,0);
   double SlowMA_2_240 = iCustom(NULL, PERIOD_W1, "FX-AO",0,1);
   if ((SlowMA_1_240 < SlowMA_2_240)) { UP_22 = 1; DOWN_22 = 0; }
   if ((SlowMA_1_240 > SlowMA_2_240)) { UP_22 = 0; DOWN_22 = 1; }
   }
   
   if( display_D1 == true )
   {
   double SlowMA_1_1440 = iCustom(NULL, PERIOD_W1, "FX-AO",0,0);
   double SlowMA_2_1440 = iCustom(NULL, PERIOD_W1, "FX-AO",0,1);
   if ((SlowMA_1_1440 < SlowMA_2_1440)) { UP_23 = 1; DOWN_23 = 0; }
   if ((SlowMA_1_1440 > SlowMA_2_1440)) { UP_23 = 0; DOWN_23 = 1; }
   }
   }
   
// Indicator (CCI)
   
   if( display_CCI == true )
   {
   if( display_M1 == true )
   {
   double CCI_1=iCustom(NULL, PERIOD_H4, "FX-BAR",0,0);
   double CCI_2=iCustom(NULL, PERIOD_H4, "FX-BAR",0,1);
   if ((CCI_1 < CCI_2)) { UP_25 = 1; DOWN_25 = 0; }
   if ((CCI_1 > CCI_2)) { UP_25 = 0; DOWN_25 = 1; }
   }
   
   if( display_M5 == true )
   {
   double CCI_5=iCustom(NULL, PERIOD_H4, "FX-BAR",0,0);
   double CCI_6=iCustom(NULL, PERIOD_H4, "FX-BAR",0,1);
   if ((CCI_5 < CCI_6)) { UP_26 = 1; DOWN_26 = 0; }
   if ((CCI_5 > CCI_6)) { UP_26 = 0; DOWN_26 = 1; }
   }
   
   if( display_M15 == true )
   {
   double CCI_15=iCustom(NULL, PERIOD_H4, "FX-BAR",0,0);
   double CCI_16=iCustom(NULL, PERIOD_H4, "FX-BAR",0,1);
   if ((CCI_15 < CCI_16)) { UP_27 = 1; DOWN_27 = 0; }
   if ((CCI_15 > CCI_16)) { UP_27 = 0; DOWN_27 = 1; }
   }
   
   if( display_M30 == true )
   {
   double CCI_30=iCustom(NULL, PERIOD_D1, "FX-BAR",0,0);
   double CCI_31=iCustom(NULL, PERIOD_D1, "FX-BAR",0,1);
   if ((CCI_30 < CCI_31)) { UP_28 = 1; DOWN_28 = 0; }
   if ((CCI_30 > CCI_31)) { UP_28 = 0; DOWN_28 = 1; }
   }
   
   if( display_H1 == true )
   {
   double CCI_60=iCustom(NULL, PERIOD_D1, "FX-BAR",0,0);
   double CCI_61=iCustom(NULL, PERIOD_D1, "FX-BAR",0,1);
   if ((CCI_60 < CCI_61)) { UP_29 = 1; DOWN_29 = 0; }
   if ((CCI_60 > CCI_61)) { UP_29 = 0; DOWN_29 = 1; }
   }
   
   if( display_H4 == true )
   {
   double CCI_240=iCustom(NULL, PERIOD_W1, "FX-BAR",0,0);
   double CCI_241=iCustom(NULL, PERIOD_W1, "FX-BAR",0,1);
   if ((CCI_240 < CCI_241)) { UP_30 = 1; DOWN_30 = 0; }
   if ((CCI_240 > CCI_241)) { UP_30 = 0; DOWN_30 = 1; }
   }
   
   if( display_D1 == true )
   {
   double CCI_1440=iCustom(NULL, PERIOD_W1, "FX-BAR",0,0);
   double CCI_1441=iCustom(NULL, PERIOD_W1, "FX-BAR",0,1);
   if ((CCI_1440 < CCI_1441)) { UP_31 = 1; DOWN_31 = 0; }
   if ((CCI_1440 > CCI_1441)) { UP_31 = 0; DOWN_31 = 1; }
   }
   }
   
// Indicator (MACD)
   
   if( display_MACD == true )
   {
   if( display_M1 == true )
   {
   double MACD_m_1=iCustom(NULL, PERIOD_H4, "FX-AO",0,0);
   double MACD_s_1=iCustom(NULL, PERIOD_H4, "FX-AO",0,1);
   if ((MACD_m_1 > MACD_s_1)) { UP_33 = 1; DOWN_33 = 0; }
   if ((MACD_m_1 < MACD_s_1)) { UP_33 = 0; DOWN_33 = 1; }
   }
   
   if( display_M5 == true )
   {
   double MACD_m_5=iCustom(NULL, PERIOD_H4, "FX-AO",0,0);
   double MACD_s_5=iCustom(NULL, PERIOD_H4, "FX-AO",0,1);
   if ((MACD_m_5 > MACD_s_5)) { UP_34 = 1; DOWN_34 = 0; }
   if ((MACD_m_5 < MACD_s_5)) { UP_34 = 0; DOWN_34 = 1; }
   }
   
   if( display_M15 == true )
   {
   double MACD_m_15=iCustom(NULL, PERIOD_H4, "FX-AO",0,0);
   double MACD_s_15=iCustom(NULL, PERIOD_H4, "FX-AO",0,1);
   if ((MACD_m_15 > MACD_s_15)) { UP_35 = 1; DOWN_35 = 0; }
   if ((MACD_m_15 < MACD_s_15)) { UP_35 = 0; DOWN_35 = 1; }
   }
   
   if( display_M30 == true )
   {
   double MACD_m_30=iCustom(NULL, PERIOD_D1, "FX-AO",0,0);
   double MACD_s_30=iCustom(NULL, PERIOD_D1, "FX-AO",0,1);
   if ((MACD_m_30 > MACD_s_30)) { UP_36 = 1; DOWN_36 = 0; }
   if ((MACD_m_30 < MACD_s_30)) { UP_36 = 0; DOWN_36 = 1; }
   }
   
   if( display_H1 == true )
   {
   double MACD_m_60=iCustom(NULL, PERIOD_D1, "FX-AO",0,0);
   double MACD_s_60=iCustom(NULL, PERIOD_D1, "FX-AO",0,1);
   if ((MACD_m_60 > MACD_s_60)) { UP_37 = 1; DOWN_37 = 0; }
   if ((MACD_m_60 < MACD_s_60)) { UP_37 = 0; DOWN_37 = 1; }
   }
   
   if( display_H4 == true )
   {
   double MACD_m_240=iCustom(NULL, PERIOD_W1, "FX-AO",0,0);
   double MACD_s_240=iCustom(NULL, PERIOD_W1, "FX-AO",0,1);
   if ((MACD_m_240 > MACD_s_240)) { UP_38 = 1; DOWN_38 = 0; }
   if ((MACD_m_240 < MACD_s_240)) { UP_38 = 0; DOWN_38 = 1; }
   }
   
   if( display_D1 == true )
   {
   double MACD_m_1440=iCustom(NULL, PERIOD_W1, "FX-AO",0,0);
   double MACD_s_1440=iCustom(NULL, PERIOD_W1, "FX-AO",0,1);
   if ((MACD_m_1440 > MACD_s_1440)) { UP_39 = 1; DOWN_39 = 0; }
   if ((MACD_m_1440 < MACD_s_1440)) { UP_39 = 0; DOWN_39 = 1; }
   }
   }
   
// Indicator (ADX)
   
   if( display_ADX == true )
   {
   if( display_M1 == true )
   {
   double ADX_plus_1=iCustom(NULL, PERIOD_H4, "FX-BAR",0,0);
   double ADX_minus_1=iCustom(NULL, PERIOD_H4, "FX-BAR",0,1);
   if ((ADX_plus_1 > ADX_minus_1)) { UP_41 = 1; DOWN_41 = 0; }
   if ((ADX_plus_1 < ADX_minus_1)) { UP_41 = 0; DOWN_41 = 1; }
   }
   
   if( display_M5 == true )
   {
   double ADX_plus_5=iCustom(NULL, PERIOD_H4, "FX-BAR",0,0);
   double ADX_minus_5=iCustom(NULL, PERIOD_H4, "FX-BAR",0,1);
   if ((ADX_plus_5 > ADX_minus_5)) { UP_42 = 1; DOWN_42 = 0; }
   if ((ADX_plus_5 < ADX_minus_5)) { UP_42 = 0; DOWN_42 = 1; }
   }
   
   if( display_M15 == true )
   {
   double ADX_plus_15=iCustom(NULL, PERIOD_H4, "FX-BAR",0,0);
   double ADX_minus_15=iCustom(NULL, PERIOD_H4, "FX-BAR",0,1);
   if ((ADX_plus_15 > ADX_minus_15)) { UP_43 = 1; DOWN_43 = 0; }
   if ((ADX_plus_15 < ADX_minus_15)) { UP_43 = 0; DOWN_43 = 1; }
   }
   
   if( display_M30 == true )
   {
   double ADX_plus_30=iCustom(NULL, PERIOD_D1, "FX-BAR",0,0);
   double ADX_minus_30=iCustom(NULL, PERIOD_D1, "FX-BAR",0,1);
   if ((ADX_plus_30 > ADX_minus_30)) { UP_44 = 1; DOWN_44 = 0; }
   if ((ADX_plus_30 < ADX_minus_30)) { UP_44 = 0; DOWN_44 = 1; }
   }
   
   if( display_H1 == true )
   {
   double ADX_plus_60=iCustom(NULL, PERIOD_D1, "FX-BAR",0,0);
   double ADX_minus_60=iCustom(NULL, PERIOD_D1, "FX-BAR",0,1);
   if ((ADX_plus_60 > ADX_minus_60)) { UP_45 = 1; DOWN_45 = 0; }
   if ((ADX_plus_60 < ADX_minus_60)) { UP_45 = 0; DOWN_45 = 1; }
   }
   
   if( display_H4 == true )
   {
   double ADX_plus_240=iCustom(NULL, PERIOD_W1, "FX-BAR",0,0);
   double ADX_minus_240=iCustom(NULL, PERIOD_W1, "FX-BAR",0,1);
   if ((ADX_plus_240 > ADX_minus_240)) { UP_46 = 1; DOWN_46 = 0; }
   if ((ADX_plus_240 < ADX_minus_240)) { UP_46 = 0; DOWN_46 = 1; }
   }
   
   if( display_D1 == true )
   {
   double ADX_plus_1440=iCustom(NULL, PERIOD_W1, "FX-BAR",0,0);
   double ADX_minus_1440=iCustom(NULL, PERIOD_W1, "FX-BAR",0,1);
   if ((ADX_plus_1440 > ADX_minus_1440)) { UP_47 = 1; DOWN_47 = 0; }
   if ((ADX_plus_1440 < ADX_minus_1440)) { UP_47 = 0; DOWN_47 = 1; }
   }
   }
   
// Indicator (BULLS)
   
   if( display_BULLS == true )
   {
   if( display_M1 == true )
   {
   double bulls_1=iCustom(NULL, PERIOD_H4, "FX-AO",0,0);
   double bulls_2=iCustom(NULL, PERIOD_H4, "FX-AO",0,1);
   if ((bulls_1 > bulls_2)) { UP_49 = 1; DOWN_49 = 0; }
   if ((bulls_1 < bulls_2)) { UP_49 = 0; DOWN_49 = 1; }
   }
   
   if( display_M5 == true )
   {
   double bulls_5=iCustom(NULL, PERIOD_H4, "FX-AO",0,0);
   double bulls_6=iCustom(NULL, PERIOD_H4, "FX-AO",0,1);
   if ((bulls_5 > bulls_6)) { UP_50 = 1; DOWN_50 = 0; }
   if ((bulls_5 < bulls_6)) { UP_50 = 0; DOWN_50 = 1; }
   }
   
   if( display_M15 == true )
   {
   double bulls_15=iCustom(NULL, PERIOD_H4, "FX-AO",0,0);
   double bulls_16=iCustom(NULL, PERIOD_H4, "FX-AO",0,1);
   if ((bulls_15 > bulls_16)) { UP_51 = 1; DOWN_51 = 0; }
   if ((bulls_15 < bulls_16)) { UP_51 = 0; DOWN_51 = 1; }
   }
   
   if( display_M30 == true )
   {
   double bulls_30=iCustom(NULL, PERIOD_D1, "FX-AO",0,0);
   double bulls_31=iCustom(NULL, PERIOD_D1, "FX-AO",0,1);
   if ((bulls_30 > bulls_31)) { UP_52 = 1; DOWN_52 = 0; }
   if ((bulls_30 < bulls_31)) { UP_52 = 0; DOWN_52 = 1; }
   }
   
   if( display_H1 == true )
   {
   double bulls_60=iCustom(NULL, PERIOD_D1, "FX-AO",0,0);
   double bulls_61=iCustom(NULL, PERIOD_D1, "FX-AO",0,1);
   if ((bulls_60 > bulls_61)) { UP_53 = 1; DOWN_53 = 0; }
   if ((bulls_60 < bulls_61)) { UP_53 = 0; DOWN_53 = 1; }
   }
   
   if( display_H4 == true )
   {
   double bulls_240=iCustom(NULL, PERIOD_W1, "FX-AO",0,0);
   double bulls_241=iCustom(NULL, PERIOD_W1, "FX-AO",0,1);
   if ((bulls_240 > bulls_241)) { UP_54 = 1; DOWN_54 = 0; }
   if ((bulls_240 < bulls_241)) { UP_54 = 0; DOWN_54 = 1; }
   }
   
   if( display_D1 == true )
   {
   double bulls_1440=iCustom(NULL, PERIOD_W1, "FX-AO",0,0);
   double bulls_1441=iCustom(NULL, PERIOD_W1, "FX-AO",0,1);
   if ((bulls_1440 > bulls_1441)) { UP_55 = 1; DOWN_55 = 0; }
   if ((bulls_1440 < bulls_1441)) { UP_55 = 0; DOWN_55 = 1; }
   }
   }
   
// Indicator (BEARS)
   
   if( display_BEARS == true )
   {
   if( display_M1 == true )
   {
   double bears_1=iCustom(NULL, PERIOD_H4, "FX-BAR",0,0);
   double bears_2=iCustom(NULL, PERIOD_H4, "FX-BAR",0,1);
   if ((bears_1 > bears_2)) { UP_57 = 1; DOWN_57 = 0; }
   if ((bears_1 < bears_2)) { UP_57 = 0; DOWN_57 = 1; }
   }
   
   if( display_M5 == true )
   {
   double bears_5=iCustom(NULL, PERIOD_H4, "FX-BAR",0,0);
   double bears_6=iCustom(NULL, PERIOD_H4, "FX-BAR",0,1);
   if ((bears_5 > bears_6)) { UP_58 = 1; DOWN_58 = 0; }
   if ((bears_5 < bears_6)) { UP_58 = 0; DOWN_58 = 1; }
   }
   
   if( display_M15 == true )
   {
   double bears_15=iCustom(NULL, PERIOD_H4, "FX-BAR",0,0);
   double bears_16=iCustom(NULL, PERIOD_H4, "FX-BAR",0,1);
   if ((bears_15 > bears_16)) { UP_59 = 1; DOWN_59 = 0; }
   if ((bears_15 < bears_16)) { UP_59 = 0; DOWN_59 = 1; }
   }
   
   if( display_M30 == true )
   {
   double bears_30=iCustom(NULL, PERIOD_D1, "FX-BAR",0,0);
   double bears_31=iCustom(NULL, PERIOD_D1, "FX-BAR",0,1);
   if ((bears_30 > bears_31)) { UP_60 = 1; DOWN_60 = 0; }
   if ((bears_30 < bears_31)) { UP_60 = 0; DOWN_60 = 1; }
   }
   
   if( display_H1 == true )
   {
   double bears_60=iCustom(NULL, PERIOD_D1, "FX-BAR",0,0);
   double bears_61=iCustom(NULL, PERIOD_D1, "FX-BAR",0,1);
   if ((bears_60 > bears_61)) { UP_61 = 1; DOWN_61 = 0; }
   if ((bears_60 < bears_61)) { UP_61 = 0; DOWN_61 = 1; }
   }
   
   if( display_H4 == true )
   {
   double bears_240=iCustom(NULL, PERIOD_W1, "FX-BAR",0,0);
   double bears_241=iCustom(NULL, PERIOD_W1, "FX-BAR",0,1);
   if ((bears_240 > bears_241)) { UP_62 = 1; DOWN_62 = 0; }
   if ((bears_240 < bears_241)) { UP_62 = 0; DOWN_62 = 1; }
   }
   
   if( display_D1 == true )
   {
   double bears_1440=iCustom(NULL, PERIOD_W1, "FX-BAR",0,0);
   double bears_1441=iCustom(NULL, PERIOD_W1, "FX-BAR",0,1);
   if ((bears_1440 > bears_1441)) { UP_63 = 1; DOWN_63 = 0; }
   if ((bears_1440 < bears_1441)) { UP_63 = 0; DOWN_63 = 1; }
   }
   }
   
// Indicator (STOCH)

   if( display_STOCH == true )
   {
   if( display_M1 == true )
   {
   double stoch_m_1=iCustom(NULL, PERIOD_H4, "FX-AO",0,0);
   double stoch_s_1=iCustom(NULL, PERIOD_H4, "FX-AO",0,1);
   if (stoch_m_1 >= stoch_s_1) { UP_65 = 1; DOWN_65 = 0; }
   if (stoch_m_1 < stoch_s_1) { UP_65 = 0; DOWN_65 = 1; }
   }
   
   if( display_M5 == true )
   {
   double stoch_m_5=iCustom(NULL, PERIOD_H4, "FX-AO",0,0);
   double stoch_s_5=iCustom(NULL, PERIOD_H4, "FX-AO",0,1);
   if (stoch_m_5 >= stoch_s_5) { UP_66 = 1; DOWN_66 = 0; }
   if (stoch_m_5 < stoch_s_5) { UP_66 = 0; DOWN_66 = 1; }
   }
   
   if( display_M15 == true )
   {
   double stoch_m_15=iCustom(NULL, PERIOD_H4, "FX-AO",0,0);
   double stoch_s_15=iCustom(NULL, PERIOD_H4, "FX-AO",0,1);
   if (stoch_m_15 >= stoch_s_15) { UP_67 = 1; DOWN_67 = 0; }
   if (stoch_m_15 < stoch_s_15) { UP_67 = 0; DOWN_67 = 1; }
   }
   
   if( display_M30 == true )
   {
   double stoch_m_30=iCustom(NULL, PERIOD_D1, "FX-AO",0,0);
   double stoch_s_30=iCustom(NULL, PERIOD_D1, "FX-AO",0,1);
   if (stoch_m_30 >= stoch_s_30) { UP_68 = 1; DOWN_68 = 0; }
   if (stoch_m_30 < stoch_s_30) { UP_68 = 0; DOWN_68 = 1; }
   }
   
   if( display_H1 == true )
   {
   double stoch_m_60=iCustom(NULL, PERIOD_D1, "FX-AO",0,0);
   double stoch_s_60=iCustom(NULL, PERIOD_D1, "FX-AO",0,1);
   if (stoch_m_60 >= stoch_s_60) { UP_69 = 1; DOWN_69 = 0; }
   if (stoch_m_60 < stoch_s_60) { UP_69 = 0; DOWN_69 = 1; }
   }
   
   if( display_H4 == true )
   {
   double stoch_m_240=iCustom(NULL, PERIOD_W1, "FX-AO",0,0);
   double stoch_s_240=iCustom(NULL, PERIOD_W1, "FX-AO",0,1);
   if (stoch_m_240 >= stoch_s_240) { UP_70 = 1; DOWN_70 = 0; }
   if (stoch_m_240 < stoch_s_240) { UP_70 = 0; DOWN_70 = 1; }
   }
   
   if( display_D1 == true )
   {
   double stoch_m_1440=iCustom(NULL, PERIOD_W1, "FX-AO",0,0);
   double stoch_s_1440=iCustom(NULL, PERIOD_W1, "FX-AO",0,1);
   if (stoch_m_1440 >= stoch_s_1440) { UP_71 = 1; DOWN_71 = 0; }
   if (stoch_m_1440 < stoch_s_1440) { UP_71 = 0; DOWN_71 = 1; }
   }
   }
   
// Indicator (RSI)
   
   if( display_RSI == true )
   {
   if( display_M1 == true )
   {
   double rsi_1=iCustom(NULL, PERIOD_H4, "FX-BAR",0,0);
   double rsi_2=iCustom(NULL, PERIOD_H4, "FX-BAR",0,1);
   if (rsi_1 >= rsi_2) { UP_73 = 1; DOWN_73 = 0; }
   if (rsi_1 < rsi_2) { UP_73 = 0; DOWN_73 = 1; }
   }
   
   if( display_M5 == true )
   {
   double rsi_5=iCustom(NULL, PERIOD_H4, "FX-BAR",0,0);
   double rsi_6=iCustom(NULL, PERIOD_H4, "FX-BAR",0,1);
   if (rsi_5 >= rsi_6) { UP_74 = 1; DOWN_74 = 0; }
   if (rsi_5 < rsi_6) { UP_74 = 0; DOWN_74 = 1; }
   }
   
   if( display_M15 == true )
   {
   double rsi_15=iCustom(NULL, PERIOD_H4, "FX-BAR",0,0);
   double rsi_16=iCustom(NULL, PERIOD_H4, "FX-BAR",0,1);
   if (rsi_15 >= rsi_16) { UP_75 = 1; DOWN_75 = 0; }
   if (rsi_15 < rsi_16) { UP_75 = 0; DOWN_75 = 1; }
   }
   
   if( display_M30 == true )
   {
   double rsi_30=iCustom(NULL, PERIOD_D1, "FX-BAR",0,0);
   double rsi_31=iCustom(NULL, PERIOD_D1, "FX-BAR",0,1);
   if (rsi_30 >= rsi_31) { UP_76 = 1; DOWN_76 = 0; }
   if (rsi_30 < rsi_31) { UP_76 = 0; DOWN_76 = 1; }
   }
   
   if( display_H1 == true )
   {
   double rsi_60=iCustom(NULL, PERIOD_D1, "FX-BAR",0,0);
   double rsi_61=iCustom(NULL, PERIOD_D1, "FX-BAR",0,1);
   if (rsi_60 >= rsi_61) { UP_77 = 1; DOWN_77 = 0; }
   if (rsi_60 < rsi_61) { UP_77 = 0; DOWN_77 = 1; }
   }
   
   if( display_H4 == true )
   {
   double rsi_240=iCustom(NULL, PERIOD_W1, "FX-BAR",0,0);
   double rsi_241=iCustom(NULL, PERIOD_W1, "FX-BAR",0,1);
   if (rsi_240 >= rsi_241) { UP_78 = 1; DOWN_78 = 0; }
   if (rsi_240 < rsi_241) { UP_78 = 0; DOWN_78 = 1; }
   }
   
   if( display_D1 == true )
   {
   double rsi_1440=iCustom(NULL, PERIOD_W1, "FX-BAR",0,0);
   double rsi_1441=iCustom(NULL, PERIOD_W1, "FX-BAR",0,1);
   if (rsi_1440 >= rsi_1441) { UP_79 = 1; DOWN_79 = 0; }
   if (rsi_1440 < rsi_1441) { UP_79 = 0; DOWN_79 = 1; }
   }
   }
   
// Indicator (FORCE INDEX)
   
   if( display_FORCE == true )
   {
   if( display_M1 == true )
   {
   double fi_1=iCustom(NULL, PERIOD_H4, "FX-AO",0,0);
   double fi_2=iCustom(NULL, PERIOD_H4, "FX-AO",0,1);
   if (fi_1 > fi_2) { UP_81 = 1; DOWN_81 = 0; }
   if (fi_1 < fi_2) { UP_81 = 0; DOWN_81 = 1; }
   }
   
   if( display_M5 == true )
   {
   double fi_5=iCustom(NULL, PERIOD_H4, "FX-AO",0,0);
   double fi_6=iCustom(NULL, PERIOD_H4, "FX-AO",0,1);
   if (fi_5 > fi_6) { UP_82 = 1; DOWN_82 = 0; }
   if (fi_5 < fi_6) { UP_82 = 0; DOWN_82 = 1; }
   }
   
   if( display_M15 == true )
   {
   double fi_15=iCustom(NULL, PERIOD_H4, "FX-AO",0,0);
   double fi_16=iCustom(NULL, PERIOD_H4, "FX-AO",0,1);
   if (fi_15 > fi_16) { UP_83 = 1; DOWN_83 = 0; }
   if (fi_15 < fi_16) { UP_83 = 0; DOWN_83 = 1; }
   }
   
   if( display_M30 == true )
   {
   double fi_30=iCustom(NULL, PERIOD_D1, "FX-AO",0,0);
   double fi_31=iCustom(NULL, PERIOD_D1, "FX-AO",0,1);
   if (fi_30 > fi_31) { UP_84 = 1; DOWN_84 = 0; }
   if (fi_30 < fi_31) { UP_84 = 0; DOWN_84 = 1; }
   }
   
   if( display_H1 == true )
   {
   double fi_60=iCustom(NULL, PERIOD_D1, "FX-AO",0,0);
   double fi_61=iCustom(NULL, PERIOD_D1, "FX-AO",0,1);
   if (fi_60 > fi_61) { UP_85 = 1; DOWN_85 = 0; }
   if (fi_60 < fi_61) { UP_85 = 0; DOWN_85 = 1; }
   }
   
   if( display_H4 == true )
   {
   double fi_240=iCustom(NULL, PERIOD_W1, "FX-AO",0,0);
   double fi_241=iCustom(NULL, PERIOD_W1, "FX-AO",0,1);
   if (fi_240 > fi_241) { UP_86 = 1; DOWN_86 = 0; }
   if (fi_240 < fi_241) { UP_86 = 0; DOWN_86 = 1; }
   }
   
   if( display_D1 == true )
   {
   double fi_1440=iCustom(NULL, PERIOD_W1, "FX-AO",0,0);
   double fi_1441=iCustom(NULL, PERIOD_W1, "FX-AO",0,1);
   if (fi_1440 > fi_1441) { UP_87 = 1; DOWN_87 = 0; }
   if (fi_1440 < fi_1441) { UP_87 = 0; DOWN_87 = 1; }
   }
   }
   
// Indicator (MOMENTUM)
   
   if( display_MOMENTUM == true )
   {
   if( display_M1 == true )
   {
   double momentum_1=iCustom(NULL, PERIOD_H4, "FX-BAR",0,0);
   double momentum_2=iCustom(NULL, PERIOD_H4, "FX-BAR",0,1);
   if (momentum_1 >= momentum_2) { UP_89 = 1; DOWN_89 = 0; }
   if (momentum_1 < momentum_2) { UP_89 = 0; DOWN_89 = 1; }
   }
   
   if( display_M5 == true )
   {
   double momentum_5=iCustom(NULL, PERIOD_H4, "FX-BAR",0,0);
   double momentum_6=iCustom(NULL, PERIOD_H4, "FX-BAR",0,1);
   if (momentum_5 >= momentum_6) { UP_90 = 1; DOWN_90 = 0; }
   if (momentum_5 < momentum_6) { UP_90 = 0; DOWN_90 = 1; }
   }
   
   if( display_M15 == true )
   {
   double momentum_15=iCustom(NULL, PERIOD_H4, "FX-BAR",0,0);
   double momentum_16=iCustom(NULL, PERIOD_H4, "FX-BAR",0,1);
   if (momentum_15 >= momentum_16) { UP_91 = 1; DOWN_91 = 0; }
   if (momentum_15 < momentum_16) { UP_91 = 0; DOWN_91 = 1; }
   }
   
   if( display_M30 == true )
   {
   double momentum_30=iCustom(NULL, PERIOD_D1, "FX-BAR",0,0);
   double momentum_31=iCustom(NULL, PERIOD_D1, "FX-BAR",0,1);
   if (momentum_30 >= momentum_31) { UP_92 = 1; DOWN_92 = 0; }
   if (momentum_30 < momentum_31) { UP_92 = 0; DOWN_92 = 1; }
   }
   
   if( display_H1 == true )
   {
   double momentum_60=iCustom(NULL, PERIOD_D1, "FX-BAR",0,0);
   double momentum_61=iCustom(NULL, PERIOD_D1, "FX-BAR",0,1);
   if (momentum_60 >= momentum_61) { UP_93 = 1; DOWN_93 = 0; }
   if (momentum_60 < momentum_61) { UP_93 = 0; DOWN_93 = 1; }
   }
   
   if( display_H4 == true )
   {
   double momentum_240=iCustom(NULL, PERIOD_W1, "FX-BAR",0,0);
   double momentum_241=iCustom(NULL, PERIOD_W1, "FX-BAR",0,1);
   if (momentum_240 >= momentum_241) { UP_94 = 1; DOWN_94 = 0; }
   if (momentum_240 < momentum_241) { UP_94 = 0; DOWN_94 = 1; }
   }
   
   if( display_D1 == true )
   {
   double momentum_1440=iCustom(NULL, PERIOD_W1, "FX-BAR",0,0);
   double momentum_1441=iCustom(NULL, PERIOD_W1, "FX-BAR",0,1);
   if (momentum_1440 >= momentum_1441) { UP_95 = 1; DOWN_95 = 0; }
   if (momentum_1440 < momentum_1441) { UP_95 = 0; DOWN_95 = 1; }
   }
   }
   
// Indicator (DE MARKER)
   
   
   if(display_DeMARKER == true )
   {
   if( display_M1 == true )
   {
   double demarker_1_0=iCustom(NULL, PERIOD_H4, "FX-AO",0,0);
   double demarker_1_1=iCustom(NULL, PERIOD_H4, "FX-AO",0,1);
   if (demarker_1_0 >= demarker_1_1) { UP_97 = 1; DOWN_97 = 0; }
   if (demarker_1_0 < demarker_1_1) { UP_97 = 0; DOWN_97 = 1; }
   }
   
   if( display_M5 == true )
   {
   double demarker_5_0=iCustom(NULL, PERIOD_H4, "FX-AO",0,0);
   double demarker_5_1=iCustom(NULL, PERIOD_H4, "FX-AO",0,1);
   if (demarker_5_0 >= demarker_5_1) { UP_98 = 1; DOWN_98 = 0; }
   if (demarker_5_0 < demarker_5_1) { UP_98 = 0; DOWN_98 = 1; }
   }
   
   if( display_M15 == true )
   {
   double demarker_15_0=iCustom(NULL, PERIOD_H4, "FX-AO",0,0);
   double demarker_15_1=iCustom(NULL, PERIOD_H4, "FX-AO",0,1);
   if (demarker_15_0 >= demarker_15_1) { UP_99 = 1; DOWN_99 = 0; }
   if (demarker_15_0 < demarker_15_1) { UP_99 = 0; DOWN_99 = 1; }
   }
   
   if( display_M30 == true )
   {
   double demarker_30_0=iCustom(NULL, PERIOD_D1, "FX-AO",0,0);
   double demarker_30_1=iCustom(NULL, PERIOD_D1, "FX-AO",0,1);
   if (demarker_30_0 >= demarker_30_1) { UP_100 = 1; DOWN_100 = 0; }
   if (demarker_30_0 < demarker_30_1) { UP_100 = 0; DOWN_100 = 1; }
   }
   
   if( display_H1 == true )
   {
   double demarker_60_0=iCustom(NULL, PERIOD_D1, "FX-AO",0,0);
   double demarker_60_1=iCustom(NULL, PERIOD_D1, "FX-AO",0,1);
   if (demarker_60_0 >= demarker_60_1) { UP_101 = 1; DOWN_101 = 0; }
   if (demarker_60_0 < demarker_60_1) { UP_101 = 0; DOWN_101 = 1; }
   }
   
   if( display_H4 == true )
   {
   double demarker_240_0=iCustom(NULL, PERIOD_W1, "FX-AO",0,0);
   double demarker_240_1=iCustom(NULL, PERIOD_W1, "FX-AO",0,1);
   if (demarker_240_0 >= demarker_240_1) { UP_102 = 1; DOWN_102 = 0; }
   if (demarker_240_0 < demarker_240_1) { UP_102 = 0; DOWN_102 = 1; }
   }
   
   if( display_D1 == true )
   {
   double demarker_1440_0=iCustom(NULL, PERIOD_W1, "FX-AO",0,0);
   double demarker_1440_1=iCustom(NULL, PERIOD_W1, "FX-AO",0,1);
   if (demarker_1440_0 >= demarker_1440_1) { UP_103 = 1; DOWN_103 = 0; }
   if (demarker_1440_0 < demarker_1440_1) { UP_103 = 0; DOWN_103 = 1; }
   }
   }
   
// Indicator (Waddah Attar Explosion)
   
   if( display_WAE == true )
   {
   if( display_M1 == true )
   {
   double wae_histo_up_1_0 = iCustom(NULL, PERIOD_H4, "FX-BAR",0,0);
   double wae_histo_up_1_1 = iCustom(NULL, PERIOD_H4, "FX-BAR",0,1);
   if (wae_histo_up_1_0 > wae_histo_up_1_1) { UP_105 = 1; DOWN_105 = 0; }
   if (wae_histo_up_1_0 < wae_histo_up_1_1) { UP_105 = 0; DOWN_105 = 1; }
   }
   
   if( display_M5 == true )
   {
   double wae_histo_up_5_0 = iCustom(NULL, PERIOD_H4, "FX-BAR",0,0);
   double wae_histo_up_5_1 = iCustom(NULL, PERIOD_H4, "FX-BAR",0,1);
      if (wae_histo_up_5_0 > wae_histo_up_5_1) { UP_106 = 1; DOWN_106 = 0; }
   if (wae_histo_up_5_0 < wae_histo_up_5_1) { UP_106 = 0; DOWN_106 = 1; }
   }
   
   if( display_M15 == true )
   {
   double wae_histo_up_15_0 = iCustom(NULL, PERIOD_H4, "FX-BAR",0,0);
   double wae_histo_up_15_1 = iCustom(NULL, PERIOD_H4, "FX-BAR",0,1);
    if (wae_histo_up_15_0 > wae_histo_up_15_1) { UP_107 = 1; DOWN_107 = 0; }
   if (wae_histo_up_15_0 < wae_histo_up_15_1) { UP_107 = 0; DOWN_107 = 1; }
   }
   
   if( display_M30 == true )
   {
   double wae_histo_up_30_0 = iCustom(NULL, PERIOD_D1, "FX-BAR",0,0);
   double wae_histo_up_30_1 = iCustom(NULL, PERIOD_D1, "FX-BAR",0,1);
   if (wae_histo_up_30_0 > wae_histo_up_30_1) { UP_108 = 1; DOWN_108 = 0; }
   if (wae_histo_up_30_0 < wae_histo_up_30_1) { UP_108 = 0; DOWN_108 = 1; }
   }
   
   if( display_H1 == true )
   {
   double wae_histo_up_60_0 = iCustom(NULL, PERIOD_D1, "FX-BAR",0,0);
   double wae_histo_up_60_1 = iCustom(NULL, PERIOD_D1, "FX-BAR",0,1);
  if (wae_histo_up_60_0 > wae_histo_up_60_1) { UP_109 = 1; DOWN_109 = 0; }
   if (wae_histo_up_60_0 < wae_histo_up_60_1) { UP_109 = 0; DOWN_109 = 1; }
   }
   
   if( display_H4 == true )
   {
   double wae_histo_up_240_0 =iCustom(NULL, PERIOD_W1, "FX-BAR",0,0);
   double wae_histo_up_240_1 = iCustom(NULL, PERIOD_W1, "FX-BAR",0,1);
  if (wae_histo_up_240_0 > wae_histo_up_240_1) { UP_110 = 1; DOWN_110 = 0; }
   if (wae_histo_up_240_0 < wae_histo_up_240_1) { UP_110 = 0; DOWN_110 = 1; }
   }
   
   if( display_D1 == true )
   {
   double wae_histo_up_1440_0 = iClose(NULL,0,0);
   double wae_histo_up_1440_1 = iCustom(NULL, 1440, "zzf",0,0);
  if (wae_histo_up_1440_0 > wae_histo_up_1440_1) { UP_111 = 1; DOWN_111 = 0; }
   if (wae_histo_up_1440_0 < wae_histo_up_1440_1) { UP_111 = 0; DOWN_111 = 1; }
   }
   }

//---- Count Indicators

   double Indy_count = UP_1 + UP_9 + UP_17 + UP_25 + UP_33 + UP_41 + UP_49 + UP_57 + UP_65 + UP_73 + UP_81 + UP_89 + UP_97 + UP_105
                     + UP_2 + UP_10 + UP_18 + UP_26 + UP_34 + UP_42 + UP_50 + UP_58 + UP_66 + UP_74 + UP_82 + UP_90 + UP_98 + UP_106
                     + UP_3 + UP_11 + UP_19 + UP_27 + UP_35 + UP_43 + UP_51 + UP_59 + UP_67 + UP_75 + UP_83 + UP_91 + UP_99 + UP_107
                     + UP_4 + UP_12 + UP_20 + UP_28 + UP_36 + UP_44 + UP_52 + UP_60 + UP_68 + UP_76 + UP_84 + UP_92 + UP_100 + UP_108
                     + UP_5 + UP_13 + UP_21 + UP_29 + UP_37 + UP_45 + UP_53 + UP_61 + UP_69 + UP_77 + UP_85 + UP_93 + UP_101 + UP_109
                     + UP_6 + UP_14 + UP_22 + UP_30 + UP_38 + UP_46 + UP_54 + UP_62 + UP_70 + UP_78 + UP_86 + UP_94 + UP_102 + UP_110
                     + UP_7 + UP_15 + UP_23 + UP_31 + UP_39 + UP_47 + UP_55 + UP_63 + UP_71 + UP_79 + UP_87 + UP_95 + UP_103 + UP_111
                     + DOWN_1 + DOWN_9 + DOWN_17 + DOWN_25 + DOWN_33 + DOWN_41 + DOWN_49 + DOWN_57 + DOWN_65 + DOWN_73 + DOWN_81 + DOWN_89 + DOWN_97 + DOWN_105
                     + DOWN_2 + DOWN_10 + DOWN_18 + DOWN_26 + DOWN_34 + DOWN_42 + DOWN_50 + DOWN_58 + DOWN_66 + DOWN_74 + DOWN_82 + DOWN_90 + DOWN_98 + DOWN_106
                     + DOWN_3 + DOWN_11 + DOWN_19 + DOWN_27 + DOWN_35 + DOWN_43 + DOWN_51 + DOWN_59 + DOWN_67 + DOWN_75 + DOWN_83 + DOWN_91 + DOWN_99 + DOWN_107
                     + DOWN_4 + DOWN_12 + DOWN_20 + DOWN_28 + DOWN_36 + DOWN_44 + DOWN_52 + DOWN_60 + DOWN_68 + DOWN_76 + DOWN_84 + DOWN_92 + DOWN_100 + DOWN_108
                     + DOWN_5 + DOWN_13 + DOWN_21 + DOWN_29 + DOWN_37 + DOWN_45 + DOWN_53 + DOWN_61 + DOWN_69 + DOWN_77 + DOWN_85 + DOWN_93 + DOWN_101 + DOWN_109
                     + DOWN_6 + DOWN_14 + DOWN_22 + DOWN_30 + DOWN_38 + DOWN_46 + DOWN_54 + DOWN_62 + DOWN_70 + DOWN_78 + DOWN_86 + DOWN_94 + DOWN_102 + DOWN_110
                     + DOWN_7 + DOWN_15 + DOWN_23 + DOWN_31 + DOWN_39 + DOWN_47 + DOWN_55 + DOWN_63 + DOWN_71 + DOWN_79 + DOWN_87 + DOWN_95 + DOWN_103 + DOWN_111;
                       
//---- Calculation of the trend. Let's give TFs more "force"
   
   double UP_m1 = (UP_1 + UP_9 + UP_17 + UP_25 + UP_33 + UP_41 + UP_49 + UP_57 + UP_65 + UP_73 + UP_81 + UP_89 + UP_97 + UP_105);
   double UP_m5 = (UP_2 + UP_10 + UP_18 + UP_26 + UP_34 + UP_42 + UP_50 + UP_58 + UP_66 + UP_74 + UP_82 + UP_90 + UP_98 + UP_106);
   double UP_m15 = (UP_3 + UP_11 + UP_19 + UP_27 + UP_35 + UP_43 + UP_51 + UP_59 + UP_67 + UP_75 + UP_83 + UP_91 + UP_99 + UP_107);
   double UP_m30 = (UP_4 + UP_12 + UP_20 + UP_28 + UP_36 + UP_44 + UP_52 + UP_60 + UP_68 + UP_76 + UP_84 + UP_92 + UP_100 + UP_108);
   double UP_H1 = (UP_5 + UP_13 + UP_21 + UP_29 + UP_37 + UP_45 + UP_53 + UP_61 + UP_69 + UP_77 + UP_85 + UP_93 + UP_101 + UP_109);
   double UP_H4 = (UP_6 + UP_14 + UP_22 + UP_30 + UP_38 + UP_46 + UP_54 + UP_62 + UP_70 + UP_78 + UP_86 + UP_94 + UP_102 + UP_110);
   double UP_D1 = (UP_7 + UP_15 + UP_23 + UP_31 + UP_39 + UP_47 + UP_55 + UP_63 + UP_71 + UP_79 + UP_87 + UP_95 + UP_103 + UP_111);
   
   double TrendUP = UP_m1 + UP_m5 + UP_m15 + UP_m30 + UP_H1 + UP_H4 + UP_D1;
   
   double DOWN_m1 = (DOWN_1 + DOWN_9 + DOWN_17 + DOWN_25 + DOWN_33 + DOWN_41 + DOWN_49 + DOWN_57 + DOWN_65 + DOWN_73 + DOWN_81 + DOWN_89 + DOWN_97 + DOWN_105);
   double DOWN_m5 = (DOWN_2 + DOWN_10 + DOWN_18 + DOWN_26 + DOWN_34 + DOWN_42 + DOWN_50 + DOWN_58 + DOWN_66 + DOWN_74 + DOWN_82 + DOWN_90 + DOWN_98 + DOWN_106);
   double DOWN_m15 = (DOWN_3 + DOWN_11 + DOWN_19 + DOWN_27 + DOWN_35 + DOWN_43 + DOWN_51 + DOWN_59 + DOWN_67 + DOWN_75 + DOWN_83 + DOWN_91 + DOWN_99 + DOWN_107);
   double DOWN_m30 = (DOWN_4 + DOWN_12 + DOWN_20 + DOWN_28 + DOWN_36 + DOWN_44 + DOWN_52 + DOWN_60 + DOWN_68 + DOWN_76 + DOWN_84 + DOWN_92 + DOWN_100 + DOWN_108);
   double DOWN_H1 = (DOWN_5 + DOWN_13 + DOWN_21 + DOWN_29 + DOWN_37 + DOWN_45 + DOWN_53 + DOWN_61 + DOWN_69 + DOWN_77 + DOWN_85 + DOWN_93 + DOWN_101 + DOWN_109);
   double DOWN_H4 = (DOWN_6 + DOWN_14 + DOWN_22 + DOWN_30 + DOWN_38 + DOWN_46 + DOWN_54 + DOWN_62 + DOWN_70 + DOWN_78 + DOWN_86 + DOWN_94 + DOWN_102 + DOWN_110);
   double DOWN_D1 = (DOWN_7 + DOWN_15 + DOWN_23 + DOWN_31 + DOWN_39 + DOWN_47 + DOWN_55 + DOWN_63 + DOWN_71 + DOWN_79 + DOWN_87 + DOWN_95 + DOWN_103 + DOWN_111);
   
   double TrendDOWN = DOWN_m1 + DOWN_m5 + DOWN_m15 + DOWN_m30 + DOWN_H1 + DOWN_H4 + DOWN_D1;
      string Trend_UP = DoubleToStr(((TrendUP/Indy_count)*100),0);
   string Trend_DOWN = DoubleToStr((100 - StrToDouble(Trend_UP)),0);
  
                                  
   // UPBuffer[0] = Trend_UP;
   // DOWNBuffer[0] = Trend_DOWN;
   



//---- Result of the trend

   if( box_trend2 == true )
   {
   
   ObjectCreate("Trend_UP", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Trend_UP",Symbol(),9, "Verdana", DarkOrange);
   ObjectSet("Trend_UP", OBJPROP_CORNER, 0);
   ObjectSet("Trend_UP", OBJPROP_XDISTANCE, 920+X_trend2-900);
   ObjectSet("Trend_UP", OBJPROP_YDISTANCE, 1+Y_trend2);
   

   

   


   

   
   string trend2;
   string comment2;
   color coltrend2;
   color colcomment2;
   double xt2, xc2;
   
   if(StrToDouble(Trend_UP) >= TrendStrongLevel) { trend2 = "UP"; coltrend2 = Lime; xt2 = 935; comment2 = "[TREND]"; xc2 = 921; colcomment2 = Lime; /* if (alert == true) { Alert(TimeToStr(TimeCurrent(),TIME_SECONDS)," Trend UP > "TrendStrongLevel"% on ",Symbol()," ", Bid); PlaySound("tick.wav"); } */ }
   else if(StrToDouble(Trend_UP) < TrendStrongLevel && StrToDouble(Trend_UP) >= 50) { trend2 = "UP"; coltrend2 = Lime; xt2 = 935; comment2 = "[TREND]"; xc2 = 924; colcomment2 = Orange; }
   else if(StrToDouble(Trend_DOWN) >= TrendStrongLevel) { trend2 = "DOWN"; coltrend2 = Red; xt2 = 918; comment2 = "[TREND]"; xc2 = 921; colcomment2 = Red; /* if (alert == true) { Alert(TimeToStr(TimeCurrent(),TIME_SECONDS)," Trend DOWN > "TrendStrongLevel"% on ",Symbol()," ", Bid); PlaySound("tick.wav"); } */ }
   else if(StrToDouble(Trend_DOWN) < TrendStrongLevel && StrToDouble(Trend_DOWN) > 50) { trend2 = "DOWN"; coltrend2 = Red; xt2 = 918; comment2 = "[TREND]"; xc2 = 924; colcomment2 = Orange; }
   
   ObjectCreate("line10", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("line10","----------------",8, "Verdana", coltrend2);
   ObjectSet("line10", OBJPROP_CORNER, 0);
   ObjectSet("line10", OBJPROP_XDISTANCE, 907+X_trend2-900);
   ObjectSet("line10", OBJPROP_YDISTANCE, 16+Y_trend2);
   
   ObjectCreate("line12", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("line12","----------------",8, "Verdana", coltrend2);
   ObjectSet("line12", OBJPROP_CORNER, 0);
   ObjectSet("line12", OBJPROP_XDISTANCE, 907+X_trend2-900);
   ObjectSet("line12", OBJPROP_YDISTANCE, 20+Y_trend2);
   
   ObjectCreate("Trend", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Trend",trend2,18, "Impact", coltrend2);
   ObjectSet("Trend", OBJPROP_CORNER, 0);
   ObjectSet("Trend", OBJPROP_XDISTANCE, xt2+X_trend2-900);
   ObjectSet("Trend", OBJPROP_YDISTANCE, 30+Y_trend2);
   
   ObjectCreate("Trend_comment", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("Trend_comment",comment2,10, "Verdana", colcomment2);
   ObjectSet("Trend_comment", OBJPROP_CORNER, 0);
   ObjectSet("Trend_comment", OBJPROP_XDISTANCE, xc2+X_trend2-903);
   ObjectSet("Trend_comment", OBJPROP_YDISTANCE, 57+Y_trend2);
   
   ObjectCreate("line13", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("line13","----------------",8, "Verdana", coltrend2);
   ObjectSet("line13", OBJPROP_CORNER, 0);
   ObjectSet("line13", OBJPROP_XDISTANCE, 907+X_trend2-900);
   ObjectSet("line13", OBJPROP_YDISTANCE, 73+Y_trend2);
   
   ObjectCreate("line11", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("line11","----------------",8, "Verdana", coltrend2);
   ObjectSet("line11", OBJPROP_CORNER, 0);
   ObjectSet("line11", OBJPROP_XDISTANCE, 907+X_trend2-900);
   ObjectSet("line11", OBJPROP_YDISTANCE, 77+Y_trend2);
   
   }   // if( box_trend == true )




 
   // HIGH
    
      double   val125 = iHigh(NULL,60,1)+2*Point+((MarketInfo(Symbol(),MODE_SPREAD))*Point);
      
     
   // LOW
    
      double   val127 =iLow(NULL,60,1)-2*Point;
     
   
    if((val125 > 0) && (val127 > 0))
           Comment("\n\n   HIGH(1)+2ï.+SPREÀD    ",val125,"\n","\n    LOW(1)-2ï.                  ",val127);
   
   

               
   return(0);
  }
//+----------------------------------------------
   