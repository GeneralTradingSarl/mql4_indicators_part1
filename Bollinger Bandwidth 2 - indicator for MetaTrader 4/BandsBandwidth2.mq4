//+------------------------------------------------------------------+
//|                                              BandsBandwidth2.mq4 |
//|                                Copyright © 2009, Investors Haven |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, Investors Haven"
#property link      ""

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Yellow
#property indicator_color2 Purple
#property indicator_color3 Purple
#property indicator_width1 2
#property indicator_width2 3
#property indicator_width3 3

//---- indicator parameters
extern int    BandsPeriod=20;
extern int    BandsShift=0;
extern double BandsDeviations=2.0;
extern color  TextColor = Purple;
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
  
   // IndicatorBuffers(1);
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,MovingBuffer);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,UpperBuffer);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,LowerBuffer);
   SetIndexStyle(3, 12);
   SetIndexBuffer(3,Bandwidth);
//----
   SetIndexDrawBegin(0,BandsPeriod+BandsShift);
   SetIndexDrawBegin(1,BandsPeriod+BandsShift);
   SetIndexDrawBegin(2,BandsPeriod+BandsShift);
   SetIndexDrawBegin(3,BandsPeriod+BandsShift);
   
   ObjectCreate( "BollingerBandwidth", OBJ_LABEL, 0,0,0,0,0,0,0);
   ObjectSet( "BollingerBandwidth", OBJPROP_CORNER, 0);
   ObjectSet( "BollingerBandwidth", OBJPROP_XDISTANCE, 5);
   ObjectSet( "BollingerBandwidth", OBJPROP_YDISTANCE, 15);
   ObjectSetText(  "BollingerBandwidth", "", 12, "Arial", TextColor);

//----
   return(0);
  }

//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectDelete("BollingerBandwidth"); 
//----
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
   if(Bars<=BandsPeriod) return(0);
//----  
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+BandsPeriod;
//---- initial zero
   /*if(counted_bars<1)
      for(i=1;i<=BandsPeriod;i++)
        {
         MovingBuffer[Bars-i]=EMPTY_VALUE;
         UpperBuffer[Bars-i]=EMPTY_VALUE;
         LowerBuffer[Bars-i]=EMPTY_VALUE;
         Bandwidth[Bars-i]=EMPTY_VALUE;
        }
//----
   int limit=Bars-counted_bars;
   if(counted_bars>0) limit++;*/
   
   for(i=0; i<limit; i++)
      MovingBuffer[i]=iMA(NULL,0,BandsPeriod,BandsShift,MODE_SMA,PRICE_CLOSE,i);
//----
   //i=Bars-BandsPeriod+1;
   //if(counted_bars>BandsPeriod-1) i=Bars-counted_bars-1;
   i=limit;
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
      LowerBuffer[i]=oldval-deviation;
      Bandwidth[i]=MathFloor((UpperBuffer[i] - LowerBuffer[i])*10000);
      i--;
     }
     string BollText = StringConcatenate("Bollinger Bandwidth: ", Bandwidth[0]);
     ObjectSetText("BollingerBandwidth", BollText, 12, "Arial", TextColor );   
//----
   return(0);
  }
//+------------------------------------------------------------------+