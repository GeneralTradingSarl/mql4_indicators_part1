//+------------------------------------------------------------------+
//|                                             Fibo-Average-2B.mq4  |
//|                                                Copyright © 2011  |
//|                                            basisforex@gmail.com  |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2011"
#property  link      "basisforex@gmail.com"
//----------------------------------
#property  indicator_chart_window
#property  indicator_buffers 2
#property  indicator_color1  Blue
#property  indicator_color2  Yellow
//+------------------------------------------------------------------+
extern int       FiboNumPeriod=15;//   Numbers in the following integer sequence;
extern int       nAppliedPrice= 0;//    PRICE_CLOSE=0; PRICE_OPEN=1; PRICE_HIGH=2; PRICE_LOW=3; PRICE_MEDIAN=4; PRICE_TYPICAL=5; PRICE_WEIGHTED=6;
extern int       maPeriod=55;//   Averaging period for calculation;
extern int       maMethod= 0;//    MODE_SMA=0; MODE_EMA=1; MODE_SMMA=2; MODE_LWMA=3;
//----
double           MainBuffer[];
double           maBuffer[];
int F[];
//+------------------------------------------------------------------+
int init()
  {
   SetIndexBuffer(0,MainBuffer);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(1,maBuffer);
   SetIndexStyle(1,DRAW_LINE,STYLE_DOT);

   ArrayResize(F,FiboNumPeriod+1);
   ArrayInitialize(F,0);
   for(int j=0; j<FiboNumPeriod; j++)
     {
      if(j == 0) F[j+1] = 1;
      if(j == 1) F[j+1] = 2;
      if(j>= 2) F[j+1] = F[j] + F[j-1];
     }
   return(0);
  }
//+------------------------------------------------------------------+
int start()
  {
   int    i,j;
   double A;
   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+F[FiboNumPeriod-1];
   i=limit;
//----
   while(i>=0)
     {
      for(j=0; j<FiboNumPeriod; j++)
        {
         A+=(AppliedPrice(nAppliedPrice,i+F[j]));
        }
      MainBuffer[i]=A/FiboNumPeriod;
      A=0;
      i--;
     }
   i=limit;
   while(i>=0)
     {
      maBuffer[i]=iMAOnArray(MainBuffer,0,maPeriod,0,maMethod,i);
      i--;
     }
//---- 
   return(0);
  }
//+------------------------------------------------------------------+
double AppliedPrice(int nAppliedPrice1,int nIndex)
  {
   double aPrice;
   switch(nAppliedPrice1)
     {
      case 0:  aPrice = Close[nIndex];                                         break;
      case 1:  aPrice = Open[nIndex];                                          break;
      case 2:  aPrice = High[nIndex];                                          break;
      case 3:  aPrice = Low[nIndex];                                           break;
      case 4:  aPrice = (High[nIndex]+Low[nIndex]) / 2.0;                      break;
      case 5:  aPrice = (High[nIndex]+Low[nIndex] + Close[nIndex]) / 3.0;      break;
      case 6:  aPrice = (High[nIndex]+Low[nIndex] + 2 * Close[nIndex]) / 4.0;  break;
      default: aPrice = 0.0;
     }
   return(aPrice);
  }
//+------------------------------------------------------------------+
