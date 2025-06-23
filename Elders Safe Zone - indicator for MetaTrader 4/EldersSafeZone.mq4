//+------------------------------------------------------------------+
//|                                             Elders Safe Zone.mq4 |
//|                                                        Cubesteak |
//|                                                www.cubesteak.net |
//+------------------------------------------------------------------+
#property copyright "Cubesteak"
#property link      "www.cubesteak.net"
//----
#property  indicator_buffers 1
#property indicator_color1 Red
#property indicator_chart_window
//----
extern int LookBack=10;
extern int StopFactor=3;
extern int EMALength=13;
extern color LineColor=Aquamarine;
//----
double ExtBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexBuffer(0,ExtBuffer);
   SetIndexStyle(0,DRAW_LINE,2,1,LineColor);
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
   double SafeStop=0;
   int    counted_bars=IndicatorCounted();
   int limit=Bars - LookBack - 3;
   for(int shift=limit;shift>=0;shift--)
     {
      double EMA0=iMA(Symbol(),0,EMALength,0,MODE_EMA,0,shift);
      double EMA1=iMA(Symbol(),0,EMALength,0,MODE_EMA,0,shift+1);
      double EMA2=iMA(Symbol(),0,EMALength,0,MODE_EMA,0,shift+2);
      double PreSafeStop=ExtBuffer[shift+1];
      double Pen=0;
      int Counter=0;
      if (EMA0 > EMA1)
        {
         for(int value1=0;value1<=LookBack; value1++)
           {
            if (Low[shift+value1] < Low[shift+value1+1])
              {
               Pen=Low[shift+value1+1] - Low[shift+value1] + Pen;
               Counter=Counter + 1;
              }
           }
         if (Counter!=0) SafeStop=Close[shift] - (StopFactor * (Pen/Counter));
         else SafeStop=Close[shift] - (StopFactor * Pen);
         if ((SafeStop < PreSafeStop) && (EMA1 > EMA2)) SafeStop=PreSafeStop;
        }
      if (EMA0 < EMA1)
        {
         for(value1=0;value1<=LookBack; value1++)
           {
            if (High[shift+value1] > High[shift+value1+1])
              {
               Pen=High[shift+value1] - High[shift+value1+1] + Pen;
               Counter=Counter + 1;
              }
           }
         if (Counter!=0) SafeStop=Close[shift] + (StopFactor * (Pen/Counter));
         else SafeStop=Close[shift] + (StopFactor * Pen);
         if ((SafeStop > PreSafeStop) && (EMA1 < EMA2)) SafeStop=PreSafeStop;
        }
      PreSafeStop=SafeStop;
      ExtBuffer[shift]=SafeStop;
     }
//----
//----
   return(0);
  }
//+------------------------------------------------------------------+