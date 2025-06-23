//+------------------------------------------------------------------+
//|                                                ForexOFFTrend.mq4 |
//|                             SilverTrend  rewritten by CrazyChart |
//|                                                 http://viac.ru/  |
//+------------------------------------------------------------------+
#property copyright "SilverTrend  rewritten by CrazyChart"
#property link      "http://viac.ru/ "

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Blue
//---- input parameters
extern int    CountBars = 300;
extern int    SSP = 7;
extern double Kmin = 1.6;
extern double Kmax = 50.6; //24 21.6 21.6 
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0, DRAW_LINE, 0, 2);
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexStyle(1, DRAW_LINE, 0, 2);
   SetIndexBuffer(1, ExtMapBuffer2);
//----
   if(CountBars >= Bars) 
       CountBars = Bars;
   SetIndexDrawBegin(0, Bars - CountBars + SSP);
   SetIndexDrawBegin(1, Bars - CountBars + SSP);
//----
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
   int i, i2,loopbegin,counted_bars=IndicatorCounted();
   double SsMax, SsMin, K, val1, val2, smin, smax, price;  
//----
   if(Bars <= SSP + 1) 
       return(0);
//----
   if(counted_bars < SSP + 1)
     {
       for(i = 1; i <= SSP; i++) 
           ExtMapBuffer1[CountBars-i] = 0.0;
       for(i = 1; i <= SSP; i++) 
           ExtMapBuffer2[CountBars-i] = 0.0;
     }
   for(i = CountBars - SSP; i >= 0; i--) 
     { 
       SsMax = High[Highest(NULL, 0, MODE_HIGH, SSP, i - SSP + 1)]; 
       SsMin = Low[Lowest(NULL, 0, MODE_LOW, SSP, i - SSP + 1)]; 
       smin = SsMin - (SsMax - SsMin)*Kmin / 100; 
       smax = SsMax - (SsMax - SsMin)*Kmax / 100;  
       ExtMapBuffer1[i-SSP+6] = smax; 
       ExtMapBuffer2[i-SSP-1] = smax; 
       val1 = ExtMapBuffer1[0]; 
       val2 = ExtMapBuffer2[0]; 
       //----
       if(val1 > val2) 
           Comment("покупка buy ", val1); 
       //----
       if(val1 < val2) 
           Comment("продажа sell ", val2); 
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+