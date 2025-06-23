//+------------------------------------------------------------------+
//|                                                     #DT-Pirsonq4 |
//|                                           Copyright © 2007, klot |
//|                                                     klot@mail.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, klot"
#property link      "klot@mail.ru"
//----
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Aqua
#property indicator_level1 0.0
extern    int N=20;
//---- indicator buffers
double Pirson[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_SECTION);
//---- indicator buffers mapping
   SetIndexBuffer(0,Pirson);
   SetIndexEmptyValue(0,0.0);
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
//----
   double X,Y,Sx,Sy;
   double sum=0.0;
//----
     for( int shift=Bars-N-1; shift>=0; shift--) 
     {
      X=iMA(NULL,0,N,0,MODE_SMA,PRICE_CLOSE,shift);
      Y=iMA(NULL,0,N,0,MODE_SMA,PRICE_CLOSE,shift+1);
      //----
      sum=0;
        for( int i=N-1; i>=0; i--) 
        {
         sum+=(Close[shift+i]-X)*(Close[shift+i+1]-Y);
        }
      //---
      Sx=iStdDev(NULL,0,N,0,MODE_SMA,PRICE_CLOSE,shift);
      Sy=iStdDev(NULL,0,N,0,MODE_SMA,PRICE_CLOSE,shift+1);
      //---
      Pirson[shift]=sum/((N-1)*Sx*Sy);
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+