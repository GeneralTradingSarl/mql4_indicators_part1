 //+------------------------------------------------------------------+
//|                                               BandsBandwidth.mq4 |
//|                                Copyright © 2009, Investors Haven |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, Investors Haven"
#property link      ""

#property indicator_separate_window
//#property indicator_minimum 0
//#property indicator_maximum 10000
#property indicator_buffers 1
#property indicator_color1 LightSeaGreen
#property indicator_width1 2
#property indicator_style1 0

//---- indicator parameters
extern int    BandsPeriod=20;
extern int    BandsShift=0;
extern double BandsDeviations=2.0;
//---- buffers
double MovingBuffer[];
double UpperBuffer[];
double LowerBuffer[];
double Bandwidth[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
  //---- 3 additional buffers are used for counting.
   IndicatorBuffers(4);
  //---- indicators
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0,Bandwidth);
   SetIndexStyle(1,12);
   SetIndexBuffer(1,MovingBuffer);
   SetIndexStyle(2,12);
   SetIndexBuffer(2,UpperBuffer);
   SetIndexStyle(3,12);
   SetIndexBuffer(3,LowerBuffer);
//----
   SetIndexDrawBegin(0,BandsPeriod+BandsShift);
   SetIndexDrawBegin(1,BandsPeriod+BandsShift);
   SetIndexDrawBegin(2,BandsPeriod+BandsShift);
   SetIndexDrawBegin(3,BandsPeriod+BandsShift);
   IndicatorShortName("Bollinger Bandwidth");
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS) - 5);

   return(0);
  }
//+------------------------------------------------------------------+
//| Bollinger Bands                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int    i,k;
   double deviation;
   double sum,oldval,newres;
//   Print("here");

   if(Bars<=BandsPeriod) return(0);
   
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+BandsPeriod;
         
/*//---- initial zero
   if(counted_bars<1)
      for(i=1;i<=BandsPeriod;i++)
        {
         MovingBuffer[Bars-i]=EMPTY_VALUE;
         UpperBuffer[Bars-i]=EMPTY_VALUE;
         LowerBuffer[Bars-i]=EMPTY_VALUE;
         Bandwidth[Bars-i]=EMPTY_VALUE;
         Print("Buffers cleaned");
        }
*/        
//----
   /*int limit=Bars-counted_bars;
   if(counted_bars>0) limit++;*/
   
   for(i=0; i<limit; i++)
      MovingBuffer[i]=iMA(NULL,0,BandsPeriod,BandsShift,MODE_SMA,PRICE_CLOSE,i);
//----
//   i=Bars-BandsPeriod+1;
//   if(counted_bars>BandsPeriod-1) i=Bars-counted_bars-1;
   i=limit;
//   Print("i is:", i);
   while(i>=0)
     {
      sum=0.0;
      k=i+BandsPeriod-1;
      oldval=MovingBuffer[i];
      while(k>=i)
        {
         newres=Close[k]-oldval;
         sum+=newres*newres;
         k--;
        }
      deviation=BandsDeviations*MathSqrt(sum/BandsPeriod);
      UpperBuffer[i]=oldval+deviation;
      //Print("UpperBuffer is:", UpperBuffer[i]);
      LowerBuffer[i]=oldval-deviation;
      //Print("LowerBuffer is:", LowerBuffer[i]);
      Bandwidth[i]=MathFloor((UpperBuffer[i] - LowerBuffer[i])*10000);
      //Print("Bandwidth is:", Bandwidth[i]);
      i--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+