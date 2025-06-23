//+------------------------------------------------------------------+
//|                                         Chaikin's Volatility.mq4 |
//|                                                          Kalenzo |
//|                                      bartlomiej.gorski@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Kalenzo"
#property link      "bartlomiej.gorski@gmail.com"
//----
#property indicator_separate_window
#property indicator_buffers 5
//----
#property indicator_color1 Red
#property indicator_color2 Blue
//---- input parameters
extern int       iPeriod=13;
extern int       maPeriod=13;
extern int       maSlowPeriod=26;
//---- buffers
double chakin[];
double Slowchakin[];
double hl[];
double emahl[];
double Slowemahl[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorBuffers(5);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,chakin);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,Slowchakin);
   //
   SetIndexStyle(2,DRAW_NONE);
   SetIndexBuffer(2,hl);
   SetIndexStyle(3,DRAW_NONE);
   SetIndexBuffer(3,emahl);
   SetIndexStyle(4,DRAW_NONE);
   SetIndexBuffer(4,Slowemahl);
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
   int limit;
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+MathMax(maPeriod,maSlowPeriod);
//----
   for(int c=0;c<=limit ;c++) hl[c]=High[c]-Low[c];
   for(int e=0;e<=limit ;e++)
     {
      emahl[e]= iMAOnArray(hl,0,maPeriod,0,MODE_EMA,e);
      Slowemahl[e]= iMAOnArray(hl,0,maSlowPeriod,0,MODE_EMA,e);
     }
   for(int i=0 ;i<=limit-iPeriod;i++)
     {
      chakin[i] =((emahl[i]-emahl[i+iPeriod])/emahl[i+iPeriod])*100;
      Slowchakin[i] =((Slowemahl[i]-Slowemahl[i+iPeriod])/Slowemahl[i+maSlowPeriod])*100;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+