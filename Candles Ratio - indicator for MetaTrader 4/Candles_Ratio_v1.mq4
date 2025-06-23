//+------------------------------------------------------------------+
//|                                                Candles_Ratio.mq4 |
//|                               Copyright © 2010, Vladimir Hlystov |
//|                                         http://cmillion.narod.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, Vladimir Hlystov"
#property link      "WWW: http://cmillion.narod.ru  MAIL: cmillion@narod.ru"

#property indicator_separate_window
#property indicator_buffers    1
#property indicator_color1     Green
//+------------------------------------------------------------------+
extern int PeriodCN=20;
double K[];
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,K);
   return(0);
  }
//+------------------------------------------------------------------+
int start()
  {
   if (Bars<PeriodCN) return(-1);
   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+PeriodCN;

   ObjectDelete("startline");
   ObjectCreate("startline",OBJ_VLINE,0,Time[PeriodCN],0,0,0,0,0);
   ObjectSet("startline",OBJPROP_COLOR,Green);
   for(int n=0; n<limit; n++)
     {
      double B=0,M=0;
      for(int j=n; j<PeriodCN+n; j++)
        {
         if(Open[j]<Close[j]) B+=Close[j]-Open[j];
         else                  M+=Open[j]-Close[j];
        }
      K[n]=B/M;
     }
   return(0);
  }
//+------------------------------------------------------------------+
