//+-------------------------------------------------------------------+
//|                                                            BO.mq4 |
//+-------------------------------------------------------------------+
//  Необходимо наличие NavelSMA.mq4
//  Presence NavelSMA.mq4 is necessary 
//---------------------------------------------------------------------
#property copyright "Copyright © 2008, Bookkeeper"
#property link      "yuzefovich@gmail.com"
//----
#property indicator_separate_window

#property indicator_buffers 3
#property indicator_color1  Blue
#property indicator_color2  Green
#property indicator_color3  Red
#property indicator_level1  1
#property indicator_level2 -1
//----
extern int  Period1=5; 
extern int  Period2=34; 
//----                                      
double      BO[];
double      ExtBuffer1[];
double      ExtBuffer2[];
//---------------------------------------------------------------------
void deinit()
{
  return;
}
//---------------------------------------------------------------------
int init()
{
   string short_name="BO("+Period1+","+Period2+")";
   IndicatorBuffers  (3);
   SetIndexBuffer    (0,BO);
   SetIndexBuffer    (1,ExtBuffer1);
   SetIndexBuffer    (2,ExtBuffer2);
   SetIndexStyle     (0,DRAW_NONE);
   SetIndexStyle     (1,DRAW_HISTOGRAM);
   SetIndexStyle     (2,DRAW_HISTOGRAM);
   SetIndexLabel     (1,NULL);
   SetIndexLabel     (2,NULL);
   IndicatorShortName(short_name);
   return(0);
}
//---------------------------------------------------------------------
int start()
{
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+1;
   int pos=limit;

   while(pos>=0)
   {
      double h0=iMA(NULL,0,Period1,0,MODE_SMA,PRICE_HIGH,pos);
      double l0=iMA(NULL,0,Period1,0,MODE_SMA,PRICE_LOW,pos);
      double h2=iMA(NULL,0,Period2,0,MODE_SMA,PRICE_HIGH,pos);
      double l2=iMA(NULL,0,Period2,0,MODE_SMA,PRICE_LOW,pos);
      double n=iCustom(NULL,0,"NavelSMA",Period1,0,0,pos);
      if(h0==l0 || h2==l2) BO[pos]=BO[pos+1];
      else BO[pos]=(n-l2)/(h2-l2)-(n-l0)/(h0-l0);
      pos--;
   }   
   bool up=true;
   double prev,current;
   for(int i=limit; i>=0; i--)
     {
      current=BO[i];
      prev=BO[i+1];
      if(current>prev) up=true;
      if(current<prev) up=false;
      if(!up)
        {
         ExtBuffer2[i]=current;
         ExtBuffer1[i]=0.0;
        }
      else
        {
         ExtBuffer1[i]=current;
         ExtBuffer2[i]=0.0;
        }
     }
   return(0);
}
//---------------------------------------------------------------------

