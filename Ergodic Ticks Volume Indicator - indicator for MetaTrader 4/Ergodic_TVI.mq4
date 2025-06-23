//+------------------------------------------------------------------+
//|                                   Ergodic Ticks Volume Indicator |
//|                                         Copyright © William Blau |
//|                                    Coded/Verified by Profitrader |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, Profitrader."
#property link      "profitrader@inbox.ru"
//----
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Yellow
#property indicator_color2 Red
//---- input parameters
extern int TVI_r=12;
extern int TVI_s=12;
extern int Ergodic_r=5;
//---- buffers
double Ergodic_TVI[];
double Ergodic_Signal[];
double TVI[];
double TVI_EMA[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorShortName("Ergodic TVI("+TVI_r+","+TVI_s+","+Ergodic_r+")");
   IndicatorBuffers(4);
   SetIndexBuffer(0,Ergodic_TVI);
   SetIndexBuffer(1,Ergodic_Signal);
   SetIndexBuffer(2,TVI);
   SetIndexBuffer(3,TVI_EMA);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexLabel(0,"Erg-TVI");
   SetIndexLabel(1,"Signal");
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
   int i,counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;

   for(i=0; i<limit; i++)
      TVI[i]=iCustom(NULL,0,"Ticks Volume Indicator",TVI_r,TVI_s,1,0,i);
   for(i=limit-1; i>=0; i--)
      TVI_EMA[i]=iMAOnArray(TVI,0,Ergodic_r,0,MODE_EMA,i);
   for(i=limit-1; i>=0; i--)
      Ergodic_TVI[i]=iMAOnArray(TVI_EMA,0,5,0,MODE_EMA,i);
   for(i=limit-1; i>=0; i--)
      Ergodic_Signal[i]=iMAOnArray(Ergodic_TVI,0,5,0,MODE_EMA,i);
//----
   return(0);
  }
//+------------------------------------------------------------------+