//+------------------------------------------------------------------+
//|                                                AcceleratedMA.mq4 |
//|                                       when-money-makes-money.com |
//|                                       when-money-makes-money.com |
//+------------------------------------------------------------------+
#property copyright "when-money-makes-money.com"
#property link      "when-money-makes-money.com"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red
//---- buffers
double ma[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ma);
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
extern int p=50;
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
   for(int i=Bars-counted_bars-1;i>=0;i--){
      ma[i]=iMA(Symbol(),Period(),p,0,MODE_SMA,PRICE_CLOSE,i)+(iATR(Symbol(),Period(),p,i)*iCCI(Symbol(),Period(),p,PRICE_CLOSE,i)/100);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+