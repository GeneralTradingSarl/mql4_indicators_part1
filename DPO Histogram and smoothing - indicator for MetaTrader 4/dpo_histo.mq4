//+--------------------------------------------------------------------+
//|          DPO - Detrended Price Oscillator Histo and smoothing.mq4  |
//+--------------------------------------------------------------------+
// https://www.tradingview.com/script/LaP3eRml-Untrend-Price-DPO-Indicator/
#property description "MT4 Code by Max Michael 2022"
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1  Green
#property indicator_width1  3 
#property indicator_color2  Red
#property indicator_width2  3
#property indicator_color3 Blue
#property indicator_width3  1
#property strict

extern int     Length = 21;
extern int  Smoothing = 30;
extern int    MaxBars = 500;

double histo_up[], histo_dn[], dpo[], ema[];

int init()
{
   SetIndexBuffer(0,histo_up); SetIndexStyle(0,DRAW_HISTOGRAM); SetIndexEmptyValue(0,0);
   SetIndexBuffer(1,histo_dn); SetIndexStyle(1,DRAW_HISTOGRAM); SetIndexEmptyValue(1,0);
   SetIndexBuffer(2,dpo);      SetIndexStyle(2,DRAW_LINE);      SetIndexEmptyValue(2,0);
   SetIndexBuffer(3,ema);      SetIndexStyle(3,DRAW_NONE);      SetIndexEmptyValue(3,0);
   string short_name = "DPO("+string(Length)+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
   if(MaxBars>Bars-1) MaxBars=Bars-1;
   SetIndexDrawBegin(0,Bars-MaxBars+Length+1);
   return(0);
}

int start()
{
   int CountedBars=IndicatorCounted();
   if (CountedBars<0) return(-1);
   int limit = Bars-CountedBars-1;
   if (limit > MaxBars) limit=MaxBars;
   int ma_per = Length/2+1;
   
   for(int i=limit; i>=0; i--)
   {
      dpo[i] = Close[i] - iMA(NULL,0,Length,ma_per,MODE_SMA,PRICE_CLOSE,i);
   }
   
   for (int i=limit; i>=0; i--)
   {
      ema[i] = iMAOnArray(dpo,0,Smoothing,0,MODE_EMA,i);
   }
   
   for(int i=limit; i>=0; i--)
   {   
      if (dpo[i] > 0) { histo_up[i]=ema[i]; histo_dn[i]=0; }
      else            { histo_dn[i]=ema[i]; histo_up[i]=0; }
   }
   return(0);
}
