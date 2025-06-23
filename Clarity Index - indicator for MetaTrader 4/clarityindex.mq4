//+------------------------------------------------------------------+
//|                                                 ClarityIndex.mq4 |
//|                                       Copyright 2020, PuguForex. |
//|                          https://www.mql5.com/en/users/puguforex |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, PuguForex."
#property link      "https://www.mql5.com/en/users/puguforex"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Black
#property indicator_width1 2
#property indicator_level1 0.0
#property indicator_levelstyle STYLE_DOT
#property indicator_levelcolor Silver

extern int            Lookback  = 14; //Lookback Period
extern int            Smoothing = 14; //Smoothing Period
extern ENUM_MA_METHOD Method    = MODE_EMA; //Smoothing Method
//
//
//
//
//

double ci[],bulls[],bears[],pos[],neg[],vi[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(6);
//--- indicator buffers mapping
      SetIndexBuffer(0,ci);
      SetIndexBuffer(1,bulls);
      SetIndexBuffer(2,bears);
      SetIndexBuffer(3,pos);
      SetIndexBuffer(4,neg);
      SetIndexBuffer(5,vi);
//---
   return(0);
  }
int deinit() { return(0); } 
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   int limit,counted_bars=IndicatorCounted();

   if(counted_bars<0)   return(-1);
   if(counted_bars>0) counted_bars--;
         limit = MathMin(Bars-counted_bars,Bars-1);

//---
   
   for(int i=limit; i>=0; i--)
   {
      bulls[i] = (i<Bars-1) ? Close[i]>Close[i+1] ? High[i]-Low[i] : 0 : 0;
      bears[i] = (i<Bars-1) ? Close[i]<Close[i+1] ? High[i]-Low[i] : 0 : 0;
      pos[i]   = bulls[i]==0 ? 0 : 1;
      neg[i]   = bears[i]==0 ? 0 : 1;
      
      double bullsSum = 1;
      double bearsSum = 1;
      double posSum   = 1;
      double negSum   = 1;
      double volSum   = 1;
      int k           = 1;
      
      for (k=1; k<Lookback && (i+k)<Bars; k++)
      {
       volSum   += (int)Volume[i+k];
       bullsSum += bulls[i+k];
       bearsSum += bears[i+k];
       posSum   += pos[i+k];
       negSum   += neg[i+k];
      }
      
      double gain = (volSum/Lookback)*(bullsSum/Lookback)*posSum;
      double loss = (volSum/Lookback)*(bearsSum/Lookback)*negSum;
      
      vi[i] = gain-loss;
      ci[i] = iMAOnArray(vi,0,Smoothing,0,Method,i);
   }   
   
//--- return value of prev_calculated for next call
   return(0);
  }
//+------------------------------------------------------------------+
