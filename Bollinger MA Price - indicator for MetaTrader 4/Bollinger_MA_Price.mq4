//+------------------------------------------------------------------+
//|                                           Bollinger MA Price.mq4 |
//|                                                        Paladin80 |
//|                                                  forevex@mail.ru |
//+------------------------------------------------------------------+
#property copyright "Paladin80"
#property link      "forevex@mail.ru"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 LightSeaGreen
#property indicator_color2 LightSeaGreen
#property indicator_color3 LightSeaGreen
//---- indicator parameters
extern int    BandsPeriod=20;
extern int    BandsShift=0;
extern double BandsDeviations=2.0;
extern int    MA_method=0;
extern int    Applied_price=0;
bool          error=false;
/* MA_method: 0 - Simple moving average,
              1 - Exponential moving average,
              2 - Smoothed moving average,
              3 - Linear weighted moving average.
Applied_price: 0 - Close price,
               1 - Open price,
               2 - High price,
               3 - Low price,
               4 - Median price,
               5 - Typical price,
               6 - Weighted close price, */
//---- buffers
double MovingBuffer[];
double UpperBuffer[];
double LowerBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,MovingBuffer);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,UpperBuffer);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,LowerBuffer);
//----
   SetIndexDrawBegin(0,BandsPeriod+BandsShift);
   SetIndexDrawBegin(1,BandsPeriod+BandsShift);
   SetIndexDrawBegin(2,BandsPeriod+BandsShift);
//----
   if(MA_method<0 || MA_method>3)
     {
      error=true;
      Alert("Please select correct MA_method (0-3) for indicator Bollinger MA Price");
     }
   if(Applied_price<0 || Applied_price>6)
     {
      error=true;
      Alert("Please select correct Applied_price (0-6) for indicator Bollinger MA Price");
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Bollinger Bands                                                  |
//+------------------------------------------------------------------+
int start()
  {
//----
   if(error==true) return(0);
//----
   int    i,k;
   double deviation;
   double sum,oldval,newres;
//----
   if(Bars<=BandsPeriod) return(0);

   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+BandsPeriod;

   for(i=0; i<limit; i++)
      MovingBuffer[i]=iMA(NULL,0,BandsPeriod,BandsShift,MA_method,Applied_price,i);
//----
   i=limit;
   while(i>=0)
     {
      sum=0.0;
      k=i+BandsPeriod-1;
      oldval=MovingBuffer[i];
      while(k>=i)
        {
         //----
         switch(Applied_price)
           {
            case 0: newres=Close[k]-oldval; break;
            case 1: newres=Open[k]-oldval; break;
            case 2: newres=High[k]-oldval; break;
            case 3: newres=Low[k]-oldval; break;
            case 4: newres=(High[k]+Low[k])/2-oldval; break;
            case 5: newres=(High[k]+Low[k]+Close[k])/3-oldval; break;
            case 6: newres=(High[k]+Low[k]+Close[k]+Close[k])/4-oldval; break;
           }
         //----
         sum+=newres*newres;
         k--;
        }
      deviation=BandsDeviations*MathSqrt(sum/BandsPeriod);
      UpperBuffer[i]=oldval+deviation;
      LowerBuffer[i]=oldval-deviation;
      i--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
dsPeriod);
      UpperBuffer[i]=oldval+deviation;
      LowerBuffer[i]=oldval-deviation;
      i--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+