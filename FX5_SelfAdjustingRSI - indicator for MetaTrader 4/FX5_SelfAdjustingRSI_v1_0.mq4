//+------------------------------------------------------------------+
//|                                         FX5_SelfAdjustingRSI.mq4 |
//|                                                              FX5 |
//|                                                    hazem@uk2.net |
//+------------------------------------------------------------------+
#property copyright "FX5"
#property link      "hazem@uk2.net"
//----
#property indicator_separate_window
#property indicator_minimum 1
#property indicator_maximum 100
#property indicator_buffers 3
#property indicator_level1  20
#property indicator_level2  50
#property indicator_level3  80
//---- input parameters
extern int    rsiPeriod = 14;
extern double diviation = 2;
extern bool   MA_Method = true;
extern color  rsiColor=clrBlue;
extern color  overBoughtColor=clrRed;
extern color  overSoldColor=clrGreen;
//---- buffers
double rsi[];
double upperBorder[];
double lowerBorder[];
double absDiviation[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE,EMPTY,EMPTY,rsiColor);
   SetIndexStyle(1,DRAW_LINE,EMPTY,EMPTY,overBoughtColor);
   SetIndexStyle(2,DRAW_LINE,EMPTY,EMPTY,overSoldColor);
//----   
   SetIndexBuffer(0,rsi);
   SetIndexBuffer(1,upperBorder);
   SetIndexBuffer(2,lowerBorder);
//----   
   SetIndexDrawBegin(0,rsiPeriod);
   SetIndexDrawBegin(1,rsiPeriod*2);
   SetIndexDrawBegin(2,rsiPeriod*2);
//----   
   SetIndexLabel(0,"RSI");
   SetIndexLabel(1,"OverBought");
   SetIndexLabel(2,"OverSold");
//----
   IndicatorShortName("FX5_SelfAdjustingRSI( "+rsiPeriod+" )");
   IndicatorBuffers(4);
   SetIndexBuffer(3,absDiviation);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
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
   int countedBars=IndicatorCounted();
//----   
   if(MA_Method==true)
      MovingAverageMethod(countedBars);
   else
      StandardDeviationMethod(countedBars);
//----         
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MovingAverageMethod(int countedBars)
  {
   if(countedBars<0)
      countedBars=0;
   int limit=Bars-countedBars;
   if(countedBars==0) limit-=rsiPeriod;

//----      
   for(int i=limit; i>=0; i--)
     {
      rsi[i]=iRSI(NULL,0,rsiPeriod,PRICE_CLOSE,i);
      double smoothedRSI=GetSmoothedRSI(i);
      absDiviation[i]=MathAbs(rsi[i]-smoothedRSI);
      double kDiviation=diviation*GetAbsDiviationAverage(i);
      upperBorder[i] = 50 + kDiviation;
      lowerBorder[i] = 50 - kDiviation;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void StandardDeviationMethod(int countedBars)
  {
   if(countedBars<0)
      countedBars=0;
//----
   for(int i=Bars-countedBars; i>=0; i--)
     {
      rsi[i]=iRSI(NULL,0,rsiPeriod,PRICE_CLOSE,i);
      double rsiDiviation=iStdDevOnArray(rsi,0,rsiPeriod,0,
                                         MODE_SMA,i);
      double kDiviation=diviation*rsiDiviation;
      upperBorder[i] = 50 + kDiviation;
      lowerBorder[i] = 50 - kDiviation;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetSmoothedRSI(int shift)
  {
   double sum= 0;
   for(int i = shift; i<shift+rsiPeriod; i++)
     {
      sum+=rsi[i];
     }
   return(sum / rsiPeriod);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetAbsDiviationAverage(int shift)
  {
   double sum= 0;
   for(int i = shift; i<shift+rsiPeriod; i++)
     {
      sum+=absDiviation[i];
     }
   return(sum / rsiPeriod);
  }
//+------------------------------------------------------------------+
