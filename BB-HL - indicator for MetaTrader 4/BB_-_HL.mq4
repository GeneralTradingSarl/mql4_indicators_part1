//+------------------------------------------------------------------+
//|                                                        BB-HL.mq4 |
//|                                Copyright © 2005, David W. Thomas |
//|                                           mailto:davidwt@usa.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, David W. Thomas"
#property link      "mailto:davidwt@usa.net"
//----
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 clrMediumSeaGreen
#property indicator_color2 clrMediumSeaGreen
#property indicator_color3 clrMediumSeaGreen
//---- input parameters
extern int       Per=20;
extern double    nDev=2.0;
//---- buffers
double MABuffer[];
double UpperBandBuffer[];
double LowerBandBuffer[];
double DevsBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(4);
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,MABuffer);
   SetIndexDrawBegin(0,Per);
   SetIndexEmptyValue(0,0.0);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,UpperBandBuffer);
   SetIndexDrawBegin(1,2*Per);
   SetIndexEmptyValue(1,0.0);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,LowerBandBuffer);
   SetIndexDrawBegin(2,2*Per);
   SetIndexEmptyValue(2,0.0);
   SetIndexBuffer(3,DevsBuffer);
//----
   string short_name="BB-HL("+(string)Per+","+DoubleToStr(nDev,1)+")";
   IndicatorShortName(short_name);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
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
   int    limit;
   int    counted_bars=IndicatorCounted();
   double d1,d2,ma;
   int i;
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   if(counted_bars==0) limit-=Per;
   if(Bars<=Per) return(0);
//---- simple moving average and deviations
   for(i=limit; i>=0; i--)
     {
      ma=iMA(NULL, 0, Per, 0, MODE_SMA, PRICE_MEDIAN, i);
      d1=High[i] - ma;
      d1*=d1;
      d2=Low[i]-ma;
      d2*=d2;
      MABuffer[i]=ma;
      DevsBuffer[i]=MathMax(d1,d2);
     }
//---- compute the bands
   UpperBandBuffer[limit]=0.0;
   LowerBandBuffer[limit]=0.0;
   for(i=limit; i>=0; i--)
     {
      d1=0;
      for(int j=i; j<i+Per; j++)
         d1+=DevsBuffer[j];
      d1/=Per;
      d2=nDev * MathSqrt(d1);
      ma=MABuffer[i];
      UpperBandBuffer[i]=ma + d2;
      LowerBandBuffer[i]=ma - d2;
     }
   return(0);
  }
//+------------------------------------------------------------------+
