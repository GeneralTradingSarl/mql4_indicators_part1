//+------------------------------------------------------------------+
//|                                           Damiani_volatmeter.mq4 |
//|                         Copyright © 2006, Luis Guilherme Damiani |
//|                                      http://www.damianifx.com.br |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, Luis Guilherme Damiani"
#property link      "http://www.damianifx.com.br"
//----
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 Silver
#property indicator_color2 FireBrick
#property indicator_color3 Lime
//---- input parameters
extern int       Viscosity=7;
extern int       Sedimentation=50;
extern double    Threshold_level=1.1;
extern bool      lag_supressor=true;
double    lag_s_K=0.5;
//---- buffers
double thresholdBuffer[];
double vol_m[];
double vol_t[];
double ind_c[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,thresholdBuffer);
   SetIndexStyle(1,DRAW_SECTION);
   SetIndexBuffer(1,vol_m);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,vol_t);
//----
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
   double vol=0;
//int    changed_bars=IndicatorCounted();
//Comment("ATR ratio= "+short_atr+" / "+long_atr);
//int limit=Bars-changed_bars;
//if (limit>Sedimentation+5)limit=limit-Sedimentation;

   int counted_bars=IndicatorCounted();
   
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+MathMax(3,Sedimentation);

   ArrayResize(ind_c,ArraySize(vol_m));
   
   for(int i=limit-3;i>=0;i--)
     {
      double sa=iATR(NULL,0,Viscosity,i);
      double s1=ind_c[i+1];
      double s3=ind_c[i+3];
      double atr=NormalizeDouble(sa,Digits);
      if(lag_supressor)
         vol=sa/iATR(NULL,0,Sedimentation,i)+lag_s_K*(s1-s3);
      else
         vol=sa/iATR(NULL,0,Sedimentation,i);
      //vol_m[i]=vol;
      double anti_thres=iStdDev(NULL,0,Viscosity,0,MODE_LWMA,PRICE_TYPICAL,i);
      anti_thres=anti_thres/
                 iStdDev(NULL,0,Sedimentation,0,MODE_LWMA,PRICE_TYPICAL,i);
      double t=Threshold_level;
      t=t-anti_thres;
      //----
      if(vol>t)
        {
         vol_t[i]=vol;
         vol_m[i]=vol;
         IndicatorShortName("DAMIANI Signal/Noise: TRADE  /  ATR= "+DoubleToStr(atr,Digits)+"    values:");
        }
      else
        {
         vol_t[i]=vol;
         vol_m[i]=EMPTY_VALUE;
         IndicatorShortName("DAMIANI Signal/Noise: DO NOT trade  /  ATR= "+DoubleToStr(atr,Digits)+"    values:");
        }
      ind_c[i]=vol;
      thresholdBuffer[i]=t;
     }
//---- 
   return(0);
  }
//+------------------------------------------------------------------+
