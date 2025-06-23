//+------------------------------------------------------------------+
//|                        Digital PCCI Filter                       |
//|                      Copyright (c) Sergey Iljukhin, Novosibirsk. |
//|                       email sergey[at]tibet.ru http://fx.qrz.ru/ |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2005, Sergey Iljukhin, Novosibirsk"
#property link      "http://fx.qrz.ru/"
// --- Parameters: P1=50, D1=14, A1=3
// --- P2=54, D2=51, A2=50, Ripple=0.08, Delay=11
// --- Order [Auto]=20, Calculate method=2
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red
//---- buffers
double FilterBuffer[];
//+------------------------------------------------------------------+
//| Digital filter indicator initialization function                 |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- indicator line
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,FilterBuffer);
   SetIndexDrawBegin(0,20);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Digital filter main function                                     |
//+------------------------------------------------------------------+
int start()
  {
   int i,counted_bars=IndicatorCounted();
   double response;
//----
   if(Bars<=20) return(0);
//---- initial zero
   if(counted_bars<20)
      for(i=1;i<=0;i++) FilterBuffer[Bars-i]=0.0;
//----
   i=Bars-20-1;
   if(counted_bars>=20) i=Bars-counted_bars-1;
   while(i>=0)
     {
      response=
      // 0*((High[i+0]+Low[i+0])/2)
      // 0*((High[i+1]+Low[i+1])/2)
      +0.0328596706665*((High[i+2]+Low[i+2])/2)
      +0.02766391536906*((High[i+3]+Low[i+3])/2)
      +0.0372462661561*((High[i+4]+Low[i+4])/2)
      +0.0471931369620*((High[i+5]+Low[i+5])/2)
      +0.0569044599702*((High[i+6]+Low[i+6])/2)
      +0.0657924462253*((High[i+7]+Low[i+7])/2)
      +0.0730704081225*((High[i+8]+Low[i+8])/2)
      +0.0782920581838*((High[i+9]+Low[i+9])/2)
      +0.0809776383446*((High[i+10]+Low[i+10])/2)
      +0.0809776383446*((High[i+11]+Low[i+11])/2)
      +0.0782920581838*((High[i+12]+Low[i+12])/2)
      +0.0730704081225*((High[i+13]+Low[i+13])/2)
      +0.0657924462253*((High[i+14]+Low[i+14])/2)
      +0.0569044599702*((High[i+15]+Low[i+15])/2)
      +0.0471931369620*((High[i+16]+Low[i+16])/2)
      +0.0372462661561*((High[i+17]+Low[i+17])/2)
      +0.02766391536906*((High[i+18]+Low[i+18])/2)
      +0.0328596706665*((High[i+19]+Low[i+19])/2);
      FilterBuffer[i]=(High[i]+Low[i])/2-response;
      i--;
     }
   return(0);
  }
//+------------------------------------------------------------------+