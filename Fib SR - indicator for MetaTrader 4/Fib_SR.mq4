//+------------------------------------------------------------------+
//|                                                       Fib SR.mq4 |
//|                                      Copyright © 2006, Eli hayun |
//|                                          http://www.elihayun.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, Eli hayun"
#property link      "http://www.elihayun.com"
//----
#property indicator_chart_window
//----
#define FIB_SUP1 "FIB_SUP_1"
#define FIB_SUP2 "FIB_SUP_2"
#define FIB_RES1 "FIB_RES_1"
#define FIB_RES2 "FIB_RES_2"
//----
extern color clrSup1=DeepSkyBlue;
extern color clrSup2=Aqua;
extern color clrRes1=Coral;
extern color clrRes2=Tan;
//----
double A, B, D, E;
double A1, B1, D1, E1;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   Recalc();
   ObjectDelete(FIB_SUP1);
   ObjectDelete(FIB_SUP2);
   ObjectDelete(FIB_RES1);
   ObjectDelete(FIB_RES2);
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
   static datetime dt=0;
   if (dt!=iTime(NULL, PERIOD_D1,0))
     {
      Recalc();
      dt=iTime(NULL, PERIOD_D1,0);
     }
   if (NewBar())
     {
      ObjectDelete(FIB_SUP1);
      ObjectDelete(FIB_SUP2);
      ObjectDelete(FIB_RES1);
      ObjectDelete(FIB_RES2);
      //
      ObjectCreate(FIB_SUP1, OBJ_RECTANGLE, 0, iTime(NULL, PERIOD_D1, 0), B, Time[0], B1);  ObjectSet(FIB_SUP1, OBJPROP_COLOR, clrSup1);
      ObjectCreate(FIB_SUP2, OBJ_RECTANGLE, 0, iTime(NULL, PERIOD_D1, 0), A, Time[0], A1);  ObjectSet(FIB_SUP2, OBJPROP_COLOR, clrSup2);
      ObjectCreate(FIB_RES1, OBJ_RECTANGLE, 0, iTime(NULL, PERIOD_D1, 0), D, Time[0], D1);  ObjectSet(FIB_RES1, OBJPROP_COLOR, clrRes1);
      ObjectCreate(FIB_RES2, OBJ_RECTANGLE, 0, iTime(NULL, PERIOD_D1, 0), E, Time[0], E1);  ObjectSet(FIB_RES2, OBJPROP_COLOR, clrRes2);
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
bool NewBar()
  {
   static datetime dt=0;
   if (dt!=Time[0])
     {
      dt=Time[0];
      return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Recalc()
  {
   double C=iClose(NULL, PERIOD_D1, 1); // Yesterday close
   double L=iLow(NULL, PERIOD_D1, 1); // Yesterday Low
   double H=iHigh(NULL, PERIOD_D1, 1); // Yesterday High
   double R=(H-L);
//----
   C=(H+L+C)/3;
   D=(R/2) + C;
   B=C - (R/2);
   E=R + C;
   A=C - R;
//----
   B1=C -(R * 0.618 );
   A1=C -(R * 1.382 );
//----
   D1=C +(R * 0.618 );
   E1=C +(R * 1.382 );
  }
//+------------------------------------------------------------------+