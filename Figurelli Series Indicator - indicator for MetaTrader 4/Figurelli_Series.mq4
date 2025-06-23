//+------------------------------------------------------------------+
//|                                             Figurelli Series.mq4 |
//|                                                Rogerio Figurelli |
//|                                      figurelli@quantafinance.com |
//+------------------------------------------------------------------+
//|                                                    QuantaFinance |
//|                                     http://www.quantafinance.com |
//+------------------------------------------------------------------+
//|                                       Figurelli Series Indicator |
//|                        calculates multiple moving averages trend |
//+------------------------------------------------------------------+
#property copyright "QuantaFinance"
#property link      "http://www.quantafinance.com"

// Version 2009-09-01

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Black

//---- input parameters
extern int series=36; // number of series
extern int interval=6; // interval between series
extern int maxbars=1000;

//---- buffers
double Indicador[];
double Middle[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,Indicador);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,Middle);
   return(0);
}
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   int i;
   int counted_bars=IndicatorCounted();
   double sma;
   int tot_Ask,tot_Bid,tot;
   
   if (counted_bars<0) return(-1);
   int limit=Bars-counted_bars;
   if (limit>maxbars) limit=maxbars;
   for (int shift=0; shift<=limit; shift++) {
      tot_Ask=0;
      tot_Bid=0;
      for (i=0; i<series; i++) {
         sma=iMA(NULL,0,interval+i*interval,8,MODE_SMA,PRICE_CLOSE,shift);
         if (Close[shift]<sma) tot_Ask++;
         if (Close[shift]>sma) tot_Bid++;
      }
      tot=tot_Bid-tot_Ask;
      Indicador[shift]=tot;
      Middle[shift]=0;
   }
   return(0);
}
//+------------------------------------------------------------------+

