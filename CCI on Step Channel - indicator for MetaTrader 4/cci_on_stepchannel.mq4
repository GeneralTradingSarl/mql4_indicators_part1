//+------------------------------------------------------------------+
//|                                            CCI_OnStepChannel.mq4 |
//| CCI on StepChannel v1.00                  Copyright 2015, fxborg |
//|                                   http://fxborg-labo.hateblo.jp/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, fxborg"
#property link      "http://fxborg-labo.hateblo.jp/"
#property version   "1.00"
//---
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_type1 DRAW_LINE
#property indicator_type2 DRAW_HISTOGRAM
#property indicator_type3 DRAW_HISTOGRAM
#property indicator_level1    -80.0
#property indicator_level2     80.0
#property indicator_levelcolor clrSilver
#property indicator_levelstyle STYLE_DOT
//---
#property indicator_color1 DarkGray
#property indicator_color2 DodgerBlue
#property indicator_color3 DeepPink
#property indicator_label1 "CCI"
#property indicator_label2 "CCI Upper"
#property indicator_label3 "CCI Lower"
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 1 
#property indicator_style1 STYLE_SOLID
#property indicator_style2 STYLE_SOLID
#property indicator_style3 STYLE_SOLID
//--- input parameters
input string Description1="--- Step Channel Settings---";
input double InpScaleFactor=2.25; // Scale factor
input int    InpMaPeriod=3;       // Smooth Period
input int    InpVolatilityPeriod=70; //  Volatility Period
input string Description2="--- CCI Settings ---";
input int InpCCIPeriod=32; // CCI Period
//---
int    InpFastPeriod=(int)MathRound(InpVolatilityPeriod/7); //  Fast Period
int    InpMode=2; //  1:Simple Mode 2:hybrid Mode
ENUM_MA_METHOD InpMaMethod=MODE_SMMA; // Ma Method 
//---- will be used as indicator buffers
double UpperBuffer[];
double MiddleBuffer[];
double LowerBuffer[];
//---
double UpperMaBuffer[];
double MiddleMaBuffer[];
double LowerMaBuffer[];
//---
double CCI_Buffer[];
double CCI_H_Buffer[];
double CCI_L_Buffer[];
double PriceBuffer[];
double BaseBuffer[];
//---
double HighBuffer[];
double LowBuffer[];
double CloseBuffer[];
double StdDevBuffer[];
//---- declaration of global variables
int min_rates_total;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//---- Initialization of variables of data calculation starting point
   min_rates_total=1+InpFastPeriod+InpVolatilityPeriod+InpMaPeriod+InpMaPeriod+1+InpCCIPeriod+1;
//--- indicator buffers mapping
   IndicatorBuffers(14);
//--- indicator buffers
   SetIndexBuffer(0,CCI_Buffer);
   SetIndexBuffer(1,CCI_H_Buffer);
   SetIndexBuffer(2,CCI_L_Buffer);
   SetIndexBuffer(3,UpperMaBuffer);
   SetIndexBuffer(4,MiddleMaBuffer);
   SetIndexBuffer(5,LowerMaBuffer);
   SetIndexBuffer(6,UpperBuffer);
   SetIndexBuffer(7,MiddleBuffer);
   SetIndexBuffer(8,LowerBuffer);
   SetIndexBuffer(9,HighBuffer);
   SetIndexBuffer(10,LowBuffer);
   SetIndexBuffer(11,CloseBuffer);
   SetIndexBuffer(12,StdDevBuffer);
   SetIndexBuffer(13,PriceBuffer);
//---
   SetIndexEmptyValue(0,EMPTY_VALUE);
   SetIndexEmptyValue(1,EMPTY_VALUE);
   SetIndexEmptyValue(2,EMPTY_VALUE);
   SetIndexEmptyValue(3,0);
   SetIndexEmptyValue(4,0);
   SetIndexEmptyValue(5,0);
   SetIndexEmptyValue(6,0);
   SetIndexEmptyValue(7,0);
   SetIndexEmptyValue(8,0);
   SetIndexEmptyValue(9,0);
   SetIndexEmptyValue(10,0);
   SetIndexEmptyValue(11,0);
   SetIndexEmptyValue(12,0);
   SetIndexEmptyValue(13,0);
//---
   SetIndexDrawBegin(0,min_rates_total);
   SetIndexDrawBegin(1,min_rates_total);
   SetIndexDrawBegin(2,min_rates_total);
//---
   string short_name="CCI on Step Channel ("
                     +IntegerToString(InpCCIPeriod)+","
                     +IntegerToString(InpScaleFactor)+","
                     +IntegerToString(InpMaPeriod)+","
                     +IntegerToString(InpVolatilityPeriod)+")";
   IndicatorShortName(short_name);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   int i,j,first;
//--- check for bars count
   if(rates_total<=min_rates_total)
      return(0);
//---
   MathSrand(int(TimeLocal()));
//--- indicator buffers
   ArraySetAsSeries(CCI_Buffer,false);
   ArraySetAsSeries(CCI_H_Buffer,false);
   ArraySetAsSeries(CCI_L_Buffer,false);
   ArraySetAsSeries(UpperMaBuffer,false);
   ArraySetAsSeries(LowerMaBuffer,false);
   ArraySetAsSeries(MiddleMaBuffer,false);
   ArraySetAsSeries(UpperBuffer,false);
   ArraySetAsSeries(LowerBuffer,false);
   ArraySetAsSeries(MiddleBuffer,false);
   ArraySetAsSeries(HighBuffer,false);
   ArraySetAsSeries(LowBuffer,false);
   ArraySetAsSeries(CloseBuffer,false);
   ArraySetAsSeries(StdDevBuffer,false);
   ArraySetAsSeries(PriceBuffer,false);
   ArraySetAsSeries(BaseBuffer,false);
//--- rate data
   ArraySetAsSeries(high,false);
   ArraySetAsSeries(low,false);
   ArraySetAsSeries(close,false);
   ArraySetAsSeries(time,false);
//+----------------------------------------------------+
//| Set StdDev Buffeer                                 |
//+----------------------------------------------------+
   first=InpFastPeriod+1-1;
   if(first+1<prev_calculated)
      first=prev_calculated-2;
   else
     {
      for(i=0; i<first; i++)
        {
         PriceBuffer[i]=(high[i]+low[i]+close[i])/3;
         StdDevBuffer[i]=EMPTY_VALUE;
        }
     }
//---
   for(i=first; i<rates_total-1 && !IsStopped(); i++)
     {
      StdDevBuffer[i]=iStdDev(Symbol(),PERIOD_CURRENT,InpFastPeriod,0,InpMaMethod,PRICE_CLOSE,rates_total-i);
      PriceBuffer[i]=(high[i]+low[i]+close[i])/3;
     }
//+----------------------------------------------------+
//| Set Median Buffeer                                 |
//+----------------------------------------------------+
   first=InpFastPeriod+InpVolatilityPeriod+InpMaPeriod+InpMaPeriod+1;
   if(first+1<prev_calculated)
      first=prev_calculated-2;
   else
     {
      for(i=0; i<first; i++)
        {
         MiddleBuffer[i]=close[i];
         HighBuffer[i]=high[i];
         LowBuffer[i]=low[i];
        }
     }
//---
   for(i=first; i<rates_total-1 && !IsStopped(); i++)
     {
      //---
      if(!random(20) && rates_total-i>min_rates_total*2 && MiddleBuffer[i]!=0) continue;
      //---
      double h,l,c,hsum=0.0,lsum=0.0,csum=0.0;
      //---
      for(j=0;j<InpMaPeriod;j++)
        {
         hsum += high[i-j];
         lsum += low[i-j];
         csum += close[i-j];
        }
      //---
      h=hsum/InpMaPeriod;
      l=lsum/InpMaPeriod;
      c=csum/InpMaPeriod;
      //--- Base Volatility
      double sd=0.0;
      for(j=(i-InpVolatilityPeriod+1);j<=i;j++)
         sd+=StdDevBuffer[j];
      //--- Ma Buffer
      double v=sd/InpVolatilityPeriod;
      double base=v*InpScaleFactor;
      //--- Hybrid Mode
      if((h-base)>HighBuffer[i-1]) HighBuffer[i]=h;
      else if(h+base<HighBuffer[i-1]) HighBuffer[i]=h+base;
      else HighBuffer[i]=HighBuffer[i-1];
      //---
      if(l+base<LowBuffer[i-1]) LowBuffer[i]=l;
      else if((l-base)>LowBuffer[i-1]) LowBuffer[i]=l-base;
      else LowBuffer[i]=LowBuffer[i-1];
      //---
      if((c-base/2)>CloseBuffer[i-1]) CloseBuffer[i]=c-base/2;
      else if(c+base/2<CloseBuffer[i-1]) CloseBuffer[i]=c+base/2;
      else CloseBuffer[i]=CloseBuffer[i-1];
      //---
      MiddleBuffer[i]=(HighBuffer[i]+LowBuffer[i]+CloseBuffer[i]*2)/4;
      UpperBuffer[i]=HighBuffer[i] + base/2;
      LowerBuffer[i]=LowBuffer[i]  - base/2;
      //---
      hsum=0.0;
      lsum=0.0;
      csum=0.0;
      //---
      for(j=0;j<InpMaPeriod;j++)
        {
         hsum += UpperBuffer[i-j];
         lsum += LowerBuffer[i-j];
         csum += MiddleBuffer[i-j];
        }
      //---
      UpperMaBuffer[i]=hsum/InpMaPeriod;
      LowerMaBuffer[i]=lsum/InpMaPeriod;
      MiddleMaBuffer[i]=csum/InpMaPeriod;
     }
//+----------------------------------------------------+
//| Set CCI Buffeer                                    |
//+----------------------------------------------------+
   first=InpCCIPeriod+1-1;
   if(first+1<prev_calculated)
      first=prev_calculated-2;
   else
     {
      for(i=0; i<first; i++)
         CCI_Buffer[i]=EMPTY_VALUE;
     }
//---      
   for(i=first; i<rates_total-1 && !IsStopped(); i++)
     {
      double sum=0;
      for(j=0;j<InpCCIPeriod;j++)
         sum+=MathAbs(PriceBuffer[i-j]-MiddleMaBuffer[i]);
      //---
      sum*=0.015/InpCCIPeriod;
      if(sum==0.0)
         CCI_Buffer[i]=0.0;
      else
         CCI_Buffer[i]=(PriceBuffer[i]-MiddleMaBuffer[i])/sum;
      //---
      if(0<CCI_Buffer[i]) CCI_H_Buffer[i]=CCI_Buffer[i];
      if(0>CCI_Buffer[i]) CCI_L_Buffer[i]=CCI_Buffer[i];
     }
//----    
   return(rates_total);
  }
//+----------------------------------------------------+
//| random func                                        |
//+----------------------------------------------------+
bool random(int x)
  {
   int ran=MathRand();
   bool res=(MathMod(ran,x)==0);
   return(res);
  }
//+------------------------------------------------------------------+
