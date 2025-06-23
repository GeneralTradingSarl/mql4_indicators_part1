//+------------------------------------------------------------------+
//|                                                   ATR_Filter.mq4 |
//+------------------------------------------------------------------+
//|                                                   ATR_Filter.mq4 |
//|                          Copyright 2014, Toptahlil Software Corp |
//|                                      Emial : Toptahlil@yahoo.com |
//+------------------------------------------------------------------+
#property description "feedbacks: https://login.mql5.com/en/users/toptahlil/feedbacks"
#property copyright  "post a job for me: http://www.mql5.com/en/job/new?prefered=toptahlil"
#property link      "Emial : Toptahlil@yahoo.com"
#property description      "Skype ID : Toptahlil"
#property description      "MQL5  ID : Toptahlil"
#property version   "1.0"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red


extern int ATR_Period=34;
extern int MA_Period=34;
extern  ENUM_MA_METHOD MA_Method =MODE_SMMA;
extern int MA_Shift=0;
double B1[], B2[], B3[];

//----
int ExtCountedBars=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators

//---- drawing settings
   SetIndexStyle(0, DRAW_LINE);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(0,B1);
   SetIndexBuffer(1,B2);
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS));
//---- indicator short name
   IndicatorShortName("ATR_Filter");
   ArraySetAsSeries(B1,true);
   ArraySetAsSeries(B2,true);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   
   int    pos=Bars-2;
   int i;   
   if(ExtCountedBars>2) pos=Bars-ExtCountedBars-1;
//---- main calculation loop
   for(i=0;i<Bars;i++)
      {
      B1[i] = iATR(Symbol(),Period(),ATR_Period,i);
      }
   for(i=0;i<Bars;i++)
      {
      
      B2[i]= iMAOnArray(B1,0,MA_Period,MA_Shift,MA_Method,i);
      }  
   return(0);
   }

//+------------------------------------------------------------------+