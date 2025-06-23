//+------------------------------------------------------------------+
//|                                                    4MAs Trend.mq4|
//|                                                                  |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 1
#property indicator_buffers 3
#property indicator_color1 Red
#property indicator_color2 LimeGreen
#property indicator_color3 Gold
//---- input parameters
extern int Minutes=60;
extern int MA1_Value=5;
extern int MA1_Mode=0;
extern int MA2_Value=13;
extern int MA2_Mode=0;
extern int MA3_Value=34;
extern int MA3_Mode=3;
extern int MA4_Value=55;
extern int MA4_Mode=3;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
string TimeFrameStr;
double MA1,MA2,MA3,MA4;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,2,Red);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID,2, LimeGreen);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_HISTOGRAM,STYLE_SOLID,2, Gold);
   SetIndexBuffer(2,ExtMapBuffer3);
//----
   switch(Minutes)
     {
      case 1 : TimeFrameStr="Period_M1"; break;
      case 5 : TimeFrameStr="Period_M5"; break;
      case 15 : TimeFrameStr="Period_M15"; break;
      case 30 : TimeFrameStr="Period_M30"; break;
      case 60 : TimeFrameStr="Period_H1"; break;
      case 240 : TimeFrameStr="Period_H4"; break;
      case 1440 : TimeFrameStr="Period_D1"; break;
      case 10080 : TimeFrameStr="Period_W1"; break;
      case 43200 : TimeFrameStr="Period_MN1"; break;
      default : TimeFrameStr="Current Timeframe"; Minutes=0;
     }
   IndicatorShortName("Flat Trend w 4 MAs ("+TimeFrameStr+")");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
     for(int i=0; i < 300; i++){
      ExtMapBuffer1[i]=0;
      ExtMapBuffer2[i]=0;
      ExtMapBuffer3[i]=0;
//----
      MA1=iMA(NULL,Minutes,MA1_Value,0,MA1_Mode,PRICE_CLOSE,i);
      MA2=iMA(NULL,Minutes,MA2_Value,0,MA2_Mode,PRICE_CLOSE,i);
      MA3=iMA(NULL,Minutes,MA3_Value,0,MA3_Mode,PRICE_CLOSE,i);
      MA4=iMA(NULL,Minutes,MA4_Value,0,MA4_Mode,PRICE_CLOSE,i);
//----
      if(MA1 > MA2 && MA2 > MA3 && MA3 > MA4 )ExtMapBuffer2[i]=1;
      if(MA1 < MA2 && MA2 < MA3 && MA3 < MA4 )ExtMapBuffer1[i]=1;
      if(ExtMapBuffer1[i]==0 && ExtMapBuffer2[i]==0)  {ExtMapBuffer3[i]=1;}
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+