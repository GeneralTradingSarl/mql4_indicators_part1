//+-------------------------------------------------------------------------+
//| BullsBearsEyes.mq4                                                      |
//| EmeraldKing , transport_david                                           |
//| http://finance.groups.yahoo.com/group/MetaTrader_Experts_and_Indicators/|
//+-------------------------------------------------------------------------+
#property copyright "Copyright © 2005"
#property link      "http://finance.groups.yahoo.com/group/MetaTrader_Experts_and_Indicators/"
//----
#property indicator_separate_window
#property indicator_minimum -0.05
#property indicator_maximum 1.05
#property indicator_color1 Orange
#property indicator_level2 1.0
#property indicator_level3 0.75
#property indicator_level4 0.50
#property indicator_level5 0.25
#property indicator_level6 0.0
//---- input parameters
extern double periods=13;
extern double timeperiods=0;
extern double gamma=0.6;
extern int CountBars=300;
//----
double L0=0;
double L1=0;
double L2=0;
double L3=0;
double L0A=0;
double L1A=0;
double L2A=0;
double L3A=0;
double LRSI=0;
double CU=0;
double CD=0;
double val1[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
//----
   SetIndexBuffer(0,val1);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- TODO: add your code here
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   if (CountBars>Bars) CountBars=Bars;
   SetIndexDrawBegin(0,Bars-CountBars);
//----
   int i;
   int    counted_bars=IndicatorCounted();
//----
   i=CountBars-1;
   while(i>=0)
     {
      L0A=L0;
      L1A=L1;
      L2A=L2;
      L3A=L3;
      L0=((1 - gamma)*(iBullsPower(NULL, timeperiods, periods,PRICE_CLOSE,i)
                       +iBearsPower(NULL, timeperiods, periods,PRICE_CLOSE,i))) + (gamma*L0A);
      L1=- gamma *L0 + L0A + gamma *L1A;
      L2=- gamma *L1 + L1A + gamma *L2A;
      L3=- gamma *L2 + L2A + gamma *L3A;
//----
      CU=0;
      CD=0;
//----
      if (L0>=L1) CU=L0 - L1; else CD=L1 - L0;
      if (L1>=L2) CU=CU + L1 - L2; else CD=CD + L2 - L1;
      if (L2>=L3) CU=CU + L2 - L3; else CD=CD + L3 - L2;
      if (CU + CD!=0) LRSI=CU/(CU + CD);
      val1[i]=LRSI;
      i--;
     }
   return(0);
  }
//+------------------------------------------------------------------+