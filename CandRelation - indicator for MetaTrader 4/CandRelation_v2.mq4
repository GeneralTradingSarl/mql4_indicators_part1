//+------------------------------------------------------------------+
//|                                              CandRelation_v2.mq4 |
//|                                Copyright © 2008, Алексей Сергеев |
//+------------------------------------------------------------------+
#property indicator_separate_window

#property indicator_buffers 3
#property indicator_color1 Green
#property indicator_color2 Blue
#property indicator_color3 Crimson
#property indicator_level1 0.3
#property indicator_level2 0.5
#property indicator_level3 0.7
#property indicator_maximum 1
#property indicator_minimum 0

//---- buffers
double Buf1[];
double Buf2[];
double Buf3[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0,DRAW_LINE); SetIndexBuffer(0,Buf1);
   SetIndexStyle(1,DRAW_LINE); SetIndexBuffer(1,Buf2);
   SetIndexStyle(2,DRAW_LINE); SetIndexBuffer(2,Buf3);
   IndicatorDigits(Digits+2);
   return(0);
  }
int deinit() {   return(0);  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit--;

   double HS,LS,BD,CC;
   for(int i=0; i<limit; i++)
     {
      CC=MathMax(High[i]-Low[i], Point);
      HS=(High[i]-MathMax(Open[i],Close[i]))/CC; // доля верхней тени в свече
      LS=(MathMin(Open[i], Close[i])-Low[i])/CC; // доля нижней тени в свече
      BD=(MathAbs(Open[i]-Close[i]))/CC;// доля тела свечи в тени
      Buf1[i]=HS; Buf2[i]=BD; Buf3[i]=LS;
     }
   return(0);
  }
//+------------------------------------------------------------------+
