//+------------------------------------------------------------------+
//|                                                    LK_FDI_v2.mq4 |
//|                                 Copyright © 2009, Leif Karlsson. |
//|                                        Leffemannen1973@telia.com |
//+------------------------------------------------------------------+
//| Please feel free to copy, modify and / or redistribute this      |
//| software / source code in any way you see fit.                   |
//+------------------------------------------------------------------+
//+ ********************* Shameless Ad. **************************** +
//+ * I do custom programing jobs in C, Java, X86 Assembler & MQL4 * +
//+ ***** Pleace do not hesitate to get in contact if you nead ***** +
//+ ***** something special: EA, indicator or somthing else. ******* +
//+ ****************** Leffemannen1973@telia.com ******************* +
//+ **************************************************************** +
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, Leif Kalrsson"
#property link      "mailto://Leffemannen1973@telia.com"
//+------------------------------------------------------------------+
#property  indicator_separate_window
#property  indicator_buffers 3
#property  indicator_color1  Blue
#property  indicator_color2  Yellow
#property  indicator_color3  Green
#property  indicator_width1  1
//+------------------------------------------------------------------+
extern int WindowSize=60;
extern int SmoothPeriod=5;
extern bool LinearWeighted=true;
extern string AppliedPriceText1 = "Close: 0, Open: 1, High: 2, Low: 3";
extern string AppliedPriceText2 = "Median: 4, Typical: 5, Weighted: 6";
extern int AppliedPrice=0;
extern int PriceShift=0;
extern bool dFDI=true;
extern double RandomLevel=1.5;
extern int MaxBars=4000;
//+------------------------------------------------------------------+
double RangeBuffer[];
double TrendBuffer[];
double dFDIBuffer[];
double Price[];
double dPrice[];
double Alpha=0.0;
//+------------------------------------------------------------------+
int init() 
  {

   IndicatorDigits(Digits+1);

   IndicatorBuffers(5);

   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(0,RangeBuffer);
   SetIndexBuffer(1,TrendBuffer);
   SetIndexBuffer(2,dFDIBuffer);
   SetIndexBuffer(3,Price);
   SetIndexBuffer(4,dPrice);
   SetLevelValue(0,RandomLevel);

   IndicatorShortName("LK_FDI_V2, WindowSize: "+WindowSize+", SmoothPeriod: "+SmoothPeriod+" ");

   Alpha=2.0/(SmoothPeriod+1.0);

   return(0);
  }
//+------------------------------------------------------------------+
double FDI(double &Data[],int p,bool w,int Shift) 
  {
   double Df=0.0;
   double Temp=0.0;
   double Range=0.0;
   int i=0;

   Range=Data[ArrayMaximum(Data,p,Shift)]-Data[ArrayMinimum(Data,p,Shift)];

   i=p-2;
   while(i>=0) 
     {
      if(Range==0.0) Temp=1.0;
      else Temp=(Data[i+Shift]-Data[i+1+Shift])/Range;
      if(w) Df = Df+(p-1-i)*MathSqrt(Temp*Temp+1.0/(p*p));
      else Df=Df+MathSqrt(Temp*Temp+1.0/(p*p));
      i--;
     }
   if(w) Df=Df/(p/2.0);
   Df=1.0+MathLog(2.0*Df)/MathLog(2.0*p);

   return(Df);
  }
//+------------------------------------------------------------------+
int start() 
  {
   //int j = 0;
   //int i = IndicatorCounted();
   //if(i < 0) return(-1);
   //i=Bars-i;
   
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+WindowSize;

   int j=0;
   int i=limit;      
   if(i>MaxBars) 
     {
      i=MaxBars;
      ArrayInitialize(TrendBuffer, 1.5);
      ArrayInitialize(RangeBuffer, 1.5);
      ArrayInitialize(dFDIBuffer,1.7);
      i--;
      j=i+WindowSize;
     }
   else j=i;

   while(j>=0) 
     {
      Price[j]=iMA(NULL,0,1,0,0,AppliedPrice,j+PriceShift);
      dPrice[j]=Price[j]-iMA(NULL,0,1,0,0,AppliedPrice,j+PriceShift+1);
      j--;
     }

   while(i>=0) 
     {
      double Df=FDI(Price,WindowSize,LinearWeighted,i);

      if(RangeBuffer[i+1]==EMPTY_VALUE) Df=(1.0-Alpha)*TrendBuffer[i+1]+Alpha*Df;
      else Df=(1.0-Alpha)*RangeBuffer[i+1]+Alpha*Df;

      if(dFDI) dFDIBuffer[i]=(1.0-Alpha)*dFDIBuffer[i+1]+Alpha*FDI(dPrice,WindowSize,LinearWeighted,i);
      else dFDIBuffer[i]=EMPTY_VALUE;

      if(Df>RandomLevel) 
        {
         RangeBuffer[i] = Df;
         TrendBuffer[i] = EMPTY_VALUE;
         if(RangeBuffer[i+1]==EMPTY_VALUE) RangeBuffer[i+1]=TrendBuffer[i+1];
           } else {
         TrendBuffer[i] = Df;
         RangeBuffer[i] = EMPTY_VALUE;
         if(TrendBuffer[i+1]==EMPTY_VALUE) TrendBuffer[i+1]=RangeBuffer[i+1];
        }
      i--;
     }

   return(0);
  }
//+------------------------------------------------------------------+
