//+------------------------------------------------------------------+
//|                                                         ARSI.mq4 |
//|                                     Copyright ?2009, Walter Choy |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2009, Walter Choy"
#property link      ""

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Orange

//---- input parameters
extern int       period = 20;

double ARSI[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ARSI);
   SetIndexLabel(0, "ARSI");
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
   int    i;
   double sc;
//----
   i = Bars - counted_bars;
   
   while (i>0){
      if (Bars - period <= i){
         ARSI[i] = Close[i];
      } else {
         sc = (MathAbs(iRSI(NULL, 0 , period, PRICE_CLOSE, i) / 100 - 0.5) * 2);
         ARSI[i] = ARSI[i+1] + sc * (Close[i] - ARSI[i+1]);
      }
      i--;
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+