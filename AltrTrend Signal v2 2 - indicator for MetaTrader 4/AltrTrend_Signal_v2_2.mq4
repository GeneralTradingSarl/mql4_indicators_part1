//+------------------------------------------------------------------+
//|                                       AltrTrend_Signal_v2_2.mq4  |
//|                                       Ramdass - Conversion only  |
//+------------------------------------------------------------------+
#property  copyright "Author - OlegVS, GOODMAN"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 SkyBlue
#property indicator_color2 Crimson

//---- input parameters
extern int K=30;
extern double Kstop= 0.5;
extern int Kperiod = 150;
extern int PerADX=14;
extern int CountBars=350;

//---- buffers
double val1[];
double val2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {

//---- indicator line
   IndicatorBuffers(2);
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,108);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,108);
   SetIndexBuffer(0,val1);
   SetIndexBuffer(1,val2);
   if(CountBars>=Bars)
      CountBars=Bars;
   SetIndexDrawBegin(0,Bars-CountBars+PerADX);
   SetIndexDrawBegin(1,Bars-CountBars+PerADX);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| AltrTrend_Signal_v2_2                                            |
//+------------------------------------------------------------------+
int start()
  {
   int i,shift,counted_bars=IndicatorCounted();
   int i1,i2;
   double Range,AvgRange,smin,smax,SsMax,SsMin,SSP,price;
   bool uptrend=false,old=false;
//----
   if(Bars<=PerADX+1)
      return(0);
//---- initial zero
   if(counted_bars<PerADX+1)
     {
      for(i=1; i<=PerADX; i++)
        {
         val1[CountBars-i]=0.0;
         val2[CountBars-i]=0.0;
        }
     }
//----
   for(shift=CountBars-PerADX; shift>=0; shift--)
     {
      SSP=MathCeil(Kperiod/iADX(NULL,0,PerADX,PRICE_CLOSE,MODE_MAIN,1));
      Range=0;
      AvgRange=0;
      for(i1=shift; i1<=shift+SSP; i1++)
        {
         AvgRange=AvgRange+MathAbs(High[i1]-Low[i1]);
        }
      Range=AvgRange/(SSP+1);
      //----
      SsMax = High[shift];
      SsMin = Low[shift];
      for(i2= shift; i2<= shift+SSP-1; i2++)
        {
         price=High[i2];
         if(SsMax<price)
            SsMax=price;
         price=Low[i2];
         if(SsMin>= price)
            SsMin = price;
        }
      //----
      smin = SsMin + (SsMax - SsMin)*K / 100;
      smax = SsMax - (SsMax - SsMin)*K / 100;
      val1[shift] = 0;
      val2[shift] = 0;
      if(Close[shift]<smin)
        {
         uptrend=false;
        }
      if(Close[shift]>smax)
        {
         uptrend=true;
        }
      if(uptrend!=old && uptrend==true)
        {
         val1[shift]=Low[shift]-Range*Kstop;
        }
      if(uptrend!=old && uptrend==false)
        {
         val2[shift]=High[shift]+Range*Kstop;
        }
      old=uptrend;

     }
   return(0);
  }
//+------------------------------------------------------------------+
