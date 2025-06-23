//+------------------------------------------------------------------+
//|                                       3 TimeFrames Indicator.mq4 |
//|                   Copyright 2005-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright   "2005-2014, MetaQuotes Software Corp."
#property link        "http://www.mql4.com"
#property description "3 TimeFrame Indicator by pipPod"
#property strict
//--- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 9
#property  indicator_color1  clrLimeGreen
#property  indicator_color2  clrFireBrick
#property  indicator_color3  clrYellow
#property  indicator_color4  clrLimeGreen
#property  indicator_color5  clrFireBrick
#property  indicator_color6  clrYellow
#property  indicator_color7  clrLimeGreen
#property  indicator_color8  clrFireBrick
#property  indicator_color9  clrYellow
#property  indicator_width1  2
#property  indicator_width2  2
#property  indicator_width4  2
#property  indicator_width5  2
#property  indicator_width7  2
#property  indicator_width8  2
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum indicators
  {
   INDICATOR_MACD,
   INDICATOR_STOCHASTIC,
   INDICATOR_RSI,
   INDICATOR_CCI
  };

input indicators Indicator=INDICATOR_MACD;
//--- indicator parameters
input int InpFastEMA=12;   // Fast EMA Period
input int InpSlowEMA=26;   // Slow EMA Period
input int InpSignalSMA=9;  // Signal SMA Period

input int InpKPeriod=5; // K Period
input int InpDPeriod=3; // D Period
input int InpSlowing=3; // Slowing

input int InpRSIPeriod=8; // RSI Period
input int InpRSISignal=3; // RSI Signal

input int InpCCIPeriod=14; // CCI Period
input int InpCCISignal=3; // CCI Signal

input ENUM_APPLIED_PRICE InpPrice=PRICE_CLOSE;

input ENUM_TIMEFRAMES TimeFrame_1=PERIOD_M15;
input ENUM_TIMEFRAMES TimeFrame_2=PERIOD_H1;
input ENUM_TIMEFRAMES TimeFrame_3=PERIOD_H4;

input int BarsToCount=30;
//--- indicator buffers
double    IndexBuffer_1A[];
double    IndexBuffer_1B[];
double    SignalBuffer_1[];
double    IndexBuffer_2A[];
double    IndexBuffer_2B[];
double    SignalBuffer_2[];
double    IndexBuffer_3A[];
double    IndexBuffer_3B[];
double    SignalBuffer_3[];

double    Index_1,
          Signal1,
          Index_2,
          Signal2,
          Index_3,
          Signal3;
//--- right input parameters flag
bool      ExtParameters=false;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(void)
  {
   IndicatorDigits(1);
//--- indicator buffers mapping
   SetIndexBuffer(0,IndexBuffer_1A);
   SetIndexBuffer(1,IndexBuffer_1B);
   SetIndexBuffer(2,SignalBuffer_1);
   SetIndexBuffer(3,IndexBuffer_2A);
   SetIndexBuffer(4,IndexBuffer_2B);
   SetIndexBuffer(5,SignalBuffer_2);
   SetIndexBuffer(6,IndexBuffer_3A);
   SetIndexBuffer(7,IndexBuffer_3B);
   SetIndexBuffer(8,SignalBuffer_3);
//--- drawing settings
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexStyle(3,DRAW_HISTOGRAM);
   SetIndexStyle(4,DRAW_HISTOGRAM);
   SetIndexStyle(5,DRAW_LINE);
   SetIndexStyle(6,DRAW_HISTOGRAM);
   SetIndexStyle(7,DRAW_HISTOGRAM);
   SetIndexStyle(8,DRAW_LINE);

   SetIndexDrawBegin(0,Bars-BarsToCount);
   SetIndexDrawBegin(1,Bars-BarsToCount);
   SetIndexDrawBegin(2,Bars-BarsToCount);
   SetIndexDrawBegin(3,Bars-(BarsToCount*2+4));
   SetIndexDrawBegin(4,Bars-(BarsToCount*2+4));
   SetIndexDrawBegin(5,Bars-(BarsToCount*2+4));
   SetIndexDrawBegin(6,Bars-(BarsToCount*3+8));
   SetIndexDrawBegin(7,Bars-(BarsToCount*3+8));
   SetIndexDrawBegin(8,Bars-(BarsToCount*3+8));

   string sTimeFrame_1,
          sTimeFrame_2,
          sTimeFrame_3;
   switch(TimeFrame_1)
     {
      case PERIOD_MN1: sTimeFrame_1 = "MN1 ";break;
      case PERIOD_W1:  sTimeFrame_1 = "W1 "; break;
      case PERIOD_D1:  sTimeFrame_1 = "D1 "; break;
      case PERIOD_H4:  sTimeFrame_1 = "H4 "; break;
      case PERIOD_H1:  sTimeFrame_1 = "H1 "; break;
      case PERIOD_M30: sTimeFrame_1 = "M30 ";break;
      case PERIOD_M15: sTimeFrame_1 = "M15 ";break;
      case PERIOD_M5:  sTimeFrame_1 = "M5 "; break;
      case PERIOD_M1:  sTimeFrame_1 = "M1 "; break;
      default:         sTimeFrame_1 = "";    break;
     }
   switch(TimeFrame_2)
     {
      case PERIOD_MN1: sTimeFrame_2 = "MN1 ";break;
      case PERIOD_W1:  sTimeFrame_2 = "W1 "; break;
      case PERIOD_D1:  sTimeFrame_2 = "D1 "; break;
      case PERIOD_H4:  sTimeFrame_2 = "H4 "; break;
      case PERIOD_H1:  sTimeFrame_2 = "H1 "; break;
      case PERIOD_M30: sTimeFrame_2 = "M30 ";break;
      case PERIOD_M15: sTimeFrame_2 = "M15 ";break;
      case PERIOD_M5:  sTimeFrame_2 = "M5 "; break;
      case PERIOD_M1:  sTimeFrame_2 = "M1 "; break;
      default:         sTimeFrame_2 = "";    break;
     }
   switch(TimeFrame_3)
     {
      case PERIOD_MN1: sTimeFrame_3 = "MN1 ";break;
      case PERIOD_W1:  sTimeFrame_3 = "W1 "; break;
      case PERIOD_D1:  sTimeFrame_3 = "D1 "; break;
      case PERIOD_H4:  sTimeFrame_3 = "H4 "; break;
      case PERIOD_H1:  sTimeFrame_3 = "H1 "; break;
      case PERIOD_M30: sTimeFrame_3 = "M30 ";break;
      case PERIOD_M15: sTimeFrame_3 = "M15 ";break;
      case PERIOD_M5:  sTimeFrame_3 = "M5 "; break;
      case PERIOD_M1:  sTimeFrame_3 = "M1 "; break;
      default:         sTimeFrame_3 = "";    break;
     }
   string shortname,
          label_1,
          label_2,
          label_3,
          label_4,
          label_5,
          label_6,
          label_7,
          label_8,
          label_9;
   switch(Indicator)
     {
      case INDICATOR_MACD: shortname="MACD "+sTimeFrame_3+sTimeFrame_2+sTimeFrame_1+"("+
                                     IntegerToString(InpFastEMA)+","+
                                     IntegerToString(InpSlowEMA)+","+
                                     IntegerToString(InpSignalSMA)+")";
         label_1="MACD "+sTimeFrame_1;
         label_2="MACD "+sTimeFrame_1;
         label_3="Signal "+sTimeFrame_1;
         label_4="MACD "+sTimeFrame_2;
         label_5="MACD "+sTimeFrame_2;
         label_6="Signal "+sTimeFrame_2;
         label_7="MACD "+sTimeFrame_3;
         label_8="MACD "+sTimeFrame_3;
         label_9="Signal "+sTimeFrame_3; break;
      case INDICATOR_STOCHASTIC: shortname="Stoch "+sTimeFrame_3+sTimeFrame_2+sTimeFrame_1+"("+
                                      IntegerToString(InpKPeriod)+","+
                                      IntegerToString(InpDPeriod)+","+
                                      IntegerToString(InpSlowing)+")";
         label_1="Stochastic "+sTimeFrame_1;
         label_2="Stochastic "+sTimeFrame_1;
         label_3="Signal "+sTimeFrame_1;
         label_4="Stochastic "+sTimeFrame_2;
         label_5="Stochastic "+sTimeFrame_2;
         label_6="Signal "+sTimeFrame_2;
         label_7="Stochastic "+sTimeFrame_3;
         label_8="Stochastic "+sTimeFrame_3;
         label_9="Signal "+sTimeFrame_3; break;
      case INDICATOR_RSI: shortname="RSI "+sTimeFrame_3+sTimeFrame_2+sTimeFrame_1+"("+
                                    IntegerToString(InpRSIPeriod)+","+
                                    IntegerToString(InpRSISignal)+")";
         label_1="RSI "+sTimeFrame_1;
         label_2="RSI "+sTimeFrame_1;
         label_3="Signal "+sTimeFrame_1;
         label_4="RSI "+sTimeFrame_2;
         label_5="RSI "+sTimeFrame_2;
         label_6="Signal "+sTimeFrame_2;
         label_7="RSI "+sTimeFrame_3;
         label_8="RSI "+sTimeFrame_3;
         label_9="Signal "+sTimeFrame_3; break;
      case INDICATOR_CCI: shortname="CCI "+sTimeFrame_3+sTimeFrame_2+sTimeFrame_1+"("+
                                    IntegerToString(InpCCIPeriod)+","+
                                    IntegerToString(InpCCISignal)+")";
         label_1="CCI "+sTimeFrame_1;
         label_2="CCI "+sTimeFrame_1;
         label_3="Signal "+sTimeFrame_1;
         label_4="CCI "+sTimeFrame_2;
         label_5="CCI "+sTimeFrame_2;
         label_6="Signal "+sTimeFrame_2;
         label_7="CCI "+sTimeFrame_3;
         label_8="CCI "+sTimeFrame_3;
         label_9="Signal "+sTimeFrame_3; break;
     }
//--- name for DataWindow and indicator subwindow label
   IndicatorShortName(shortname);
   SetIndexLabel(0,label_1);
   SetIndexLabel(1,label_2);
   SetIndexLabel(2,label_3);
   SetIndexLabel(3,label_4);
   SetIndexLabel(4,label_5);
   SetIndexLabel(5,label_6);
   SetIndexLabel(6,label_7);
   SetIndexLabel(7,label_8);
   SetIndexLabel(8,label_9);
//--- check for input parameters
   if(InpFastEMA<=1 || InpSlowEMA<=1 || InpSignalSMA<=1 || InpFastEMA>=InpSlowEMA ||
      InpKPeriod<=1 || InpDPeriod<=1 || InpSlowing<1 ||
      InpRSIPeriod<=1 || InpRSISignal<=1 || InpCCIPeriod<=1 || InpCCISignal<=1)
     {
      Print("Wrong input parameters");
      ExtParameters=false;
      return(INIT_FAILED);
     }
   else
      ExtParameters=true;
//--- initialization done
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| 3 Timeframes Indicator Calculation                               |
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
   int i,j,k,limit;
//---
   if(rates_total<=BarsToCount || !ExtParameters)
      return(0);
//--- last counted bar will be recounted
   limit=rates_total-prev_calculated;
   if(prev_calculated==0)
     {
      for(i=0;i<rates_total;i++)
        {
         IndexBuffer_1A[i]=EMPTY_VALUE;
         IndexBuffer_1B[i]=EMPTY_VALUE;
         SignalBuffer_1[i]=EMPTY_VALUE;
         IndexBuffer_2A[i]=EMPTY_VALUE;
         IndexBuffer_2B[i]=EMPTY_VALUE;
         SignalBuffer_2[i]=EMPTY_VALUE;
         IndexBuffer_3A[i]=EMPTY_VALUE;
         IndexBuffer_3B[i]=EMPTY_VALUE;
         SignalBuffer_3[i]=EMPTY_VALUE;
        }
      limit=BarsToCount;
     }
   if(prev_calculated>0 && NewBar(time[0]))
     {
      limit=BarsToCount;
      IndexBuffer_1A[limit+1]=EMPTY_VALUE;
      IndexBuffer_1B[limit+1]=EMPTY_VALUE;
      SignalBuffer_1[limit+1]=EMPTY_VALUE;
      IndexBuffer_2A[limit*2+5]=EMPTY_VALUE;
      IndexBuffer_2B[limit*2+5]=EMPTY_VALUE;
      SignalBuffer_2[limit*2+5]=EMPTY_VALUE;
      IndexBuffer_3A[limit*3+9]=EMPTY_VALUE;
      IndexBuffer_3B[limit*3+9]=EMPTY_VALUE;
      SignalBuffer_3[limit*3+9]=EMPTY_VALUE;
     }
   if(prev_calculated>0)
      limit++;
//--- 
   for(i=0,j=BarsToCount+4,k=BarsToCount*2+8; i<limit; i++,j++,k++)
     {
      switch(Indicator)
        {
         case INDICATOR_MACD:
            Index_1=iMacd(NULL,TimeFrame_1,InpFastEMA,InpSlowEMA,InpSignalSMA,InpPrice,MODE_MAIN,i);
            Signal1=iMacd(NULL,TimeFrame_1,InpFastEMA,InpSlowEMA,InpSignalSMA,InpPrice,MODE_SIGNAL,i);

            Index_2=iMacd(NULL,TimeFrame_2,InpFastEMA,InpSlowEMA,InpSignalSMA,InpPrice,MODE_MAIN,i);
            Signal2=iMacd(NULL,TimeFrame_2,InpFastEMA,InpSlowEMA,InpSignalSMA,InpPrice,MODE_SIGNAL,i);

            Index_3=iMacd(NULL,TimeFrame_3,InpFastEMA,InpSlowEMA,InpSignalSMA,InpPrice,MODE_MAIN,i);
            Signal3=iMacd(NULL,TimeFrame_3,InpFastEMA,InpSlowEMA,InpSignalSMA,InpPrice,MODE_SIGNAL,i); break;

         case INDICATOR_STOCHASTIC:
            Index_1=iStoch(NULL,TimeFrame_1,InpKPeriod,InpDPeriod,InpSlowing,0,MODE_MAIN,i);
            Signal1=iStoch(NULL,TimeFrame_1,InpKPeriod,InpDPeriod,InpSlowing,0,MODE_SIGNAL,i);

            Index_2=iStoch(NULL,TimeFrame_2,InpKPeriod,InpDPeriod,InpSlowing,0,MODE_MAIN,i);
            Signal2=iStoch(NULL,TimeFrame_2,InpKPeriod,InpDPeriod,InpSlowing,0,MODE_SIGNAL,i);

            Index_3=iStoch(NULL,TimeFrame_3,InpKPeriod,InpDPeriod,InpSlowing,0,MODE_MAIN,i);
            Signal3=iStoch(NULL,TimeFrame_3,InpKPeriod,InpDPeriod,InpSlowing,0,MODE_SIGNAL,i); break;

         case INDICATOR_RSI:
            Index_1=iRSi(NULL,TimeFrame_1,InpRSIPeriod,InpRSISignal,InpPrice,MODE_MAIN,i);
            Signal1=iRSi(NULL,TimeFrame_1,InpRSIPeriod,InpRSISignal,InpPrice,MODE_SIGNAL,i);

            Index_2=iRSi(NULL,TimeFrame_2,InpRSIPeriod,InpRSISignal,InpPrice,MODE_MAIN,i);
            Signal2=iRSi(NULL,TimeFrame_2,InpRSIPeriod,InpRSISignal,InpPrice,MODE_SIGNAL,i);

            Index_3=iRSi(NULL,TimeFrame_3,InpRSIPeriod,InpRSISignal,InpPrice,MODE_MAIN,i);
            Signal3=iRSi(NULL,TimeFrame_3,InpRSIPeriod,InpRSISignal,InpPrice,MODE_SIGNAL,i); break;

         case INDICATOR_CCI:
            Index_1=iCCi(NULL,TimeFrame_1,InpCCIPeriod,InpCCISignal,InpPrice,MODE_MAIN,i);
            Signal1=iCCi(NULL,TimeFrame_1,InpCCIPeriod,InpCCISignal,InpPrice,MODE_SIGNAL,i);

            Index_2=iCCi(NULL,TimeFrame_2,InpCCIPeriod,InpCCISignal,InpPrice,MODE_MAIN,i);
            Signal2=iCCi(NULL,TimeFrame_2,InpCCIPeriod,InpCCISignal,InpPrice,MODE_SIGNAL,i);

            Index_3=iCCi(NULL,TimeFrame_3,InpCCIPeriod,InpCCISignal,InpPrice,MODE_MAIN,i);
            Signal3=iCCi(NULL,TimeFrame_3,InpCCIPeriod,InpCCISignal,InpPrice,MODE_SIGNAL,i); break;
        }

      if(Index_1>Signal1)
        {
         IndexBuffer_1A[i] = Index_1;
         IndexBuffer_1B[i] = EMPTY_VALUE;
        }
      else
        {
         IndexBuffer_1B[i] = Index_1;
         IndexBuffer_1A[i] = EMPTY_VALUE;
        }
      SignalBuffer_1[i]=Signal1;

      if(Index_2>Signal2)
        {
         IndexBuffer_2A[j] = Index_2;
         IndexBuffer_2B[j] = EMPTY_VALUE;
        }
      else
        {
         IndexBuffer_2B[j] = Index_2;
         IndexBuffer_2A[j] = EMPTY_VALUE;
        }
      SignalBuffer_2[j]=Signal2;

      if(Index_3>Signal3)
        {
         IndexBuffer_3A[k] = Index_3;
         IndexBuffer_3B[k] = EMPTY_VALUE;
        }
      else
        {
         IndexBuffer_3B[k] = Index_3;
         IndexBuffer_3A[k] = EMPTY_VALUE;
        }
      SignalBuffer_3[k]=Signal3;
      //--- done
     }
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
const bool NewBar(const datetime& time)
  {
   static datetime time_prev;
   if(time_prev!=time)
     {
      time_prev=time;
      return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
const double iMacd(const string symbol,
                   const ENUM_TIMEFRAMES timeframe,
                   const int fastema,
                   const int slowema,
                   const int signalsma,
                   const ENUM_APPLIED_PRICE price,
                   const int mode,
                   const int idx)
  {
   double macd;
   int deci;
   if(_Digits==2 || _Digits==3) deci=100;
   else                         deci=10000;
   if(_Symbol=="XAUUSD")        deci=10;
   macd=deci*iMACD(symbol,timeframe,fastema,slowema,signalsma,price,mode,idx);
   return(macd);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
const double iStoch(const string symbol,
                    const ENUM_TIMEFRAMES timeframe,
                    const int kperiod,
                    const int dperiod,
                    const int slowing,
                    const int pricefield,
                    const int mode,
                    const int idx)
  {
   double stoch;
   stoch=iStochastic(symbol,timeframe,kperiod,dperiod,slowing,MODE_SMA,pricefield,mode,idx)-50;
   return(stoch);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
const double iRSi(const string symbol,
                  const ENUM_TIMEFRAMES timeframe,
                  const int period,
                  const int signal,
                  const ENUM_APPLIED_PRICE price,
                  const int mode,
                  const int idx)
  {
   double rsi;
   if(mode==MODE_SIGNAL)
     {
      double rsisignal[1];
      ArrayResize(rsisignal,signal);
      double sum=0.0;
      for(int i=0;i<signal;i++)
        {
         rsisignal[i]=iRSI(symbol,timeframe,period,price,idx+i)-50;
         sum+=rsisignal[i];
        }
      rsi=sum/signal;
     }
   else
      rsi=iRSI(symbol,timeframe,period,price,idx)-50;

   return(rsi);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
const double iCCi(const string symbol,
                  const ENUM_TIMEFRAMES timeframe,
                  const int period,
                  const int signal,
                  const ENUM_APPLIED_PRICE price,
                  const int mode,
                  const int idx)
  {
   double cci;
   double mul=1.5/period;
   if(mode==MODE_SIGNAL)
     {
      double ccisignal[1];
      ArrayResize(ccisignal,signal);
      double sum=0.0;
      for(int i=0;i<signal;i++)
        {
         ccisignal[i]=iCCI(symbol,timeframe,period,price,idx+i)*mul;
         sum+=ccisignal[i];
        }
      cci=sum/signal;
     }
   else
      cci=iCCI(symbol,timeframe,period,price,idx)*mul;

   return(cci);
  }
//+------------------------------------------------------------------+
