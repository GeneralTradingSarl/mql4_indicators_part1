//+------------------------------------------------------------------+
//|                                                       CosMod.mq4 |
//|                                                    Infinite Eith |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Infinite Eith"
#property link      "http://www.metaquotes.net"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 DodgerBlue

extern int KPeriod=14;

 double MA; 
double KBuffer[];

int init()
  {
   string short_name;

   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,KBuffer);

   short_name="CosMod("+KPeriod+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);

   SetIndexDrawBegin(0,KPeriod);

   return(0);
  }

int start()
  {
   
   int i,counted_bars=IndicatorCounted();

   MA=iMA(NULL,0,14,0,MODE_SMA,PRICE_CLOSE,0);
   
   if(Bars<=KPeriod) return(0);

   if(counted_bars<1)
      for(i=1;i<=KPeriod;i++) KBuffer[Bars-i]=0.0;

   i=Bars-KPeriod-1;
   if(counted_bars>=KPeriod) i=Bars-counted_bars-1;
   while(i>=0)
     {
      KBuffer[i]=MathCos(MathMod(Close[i],MA));
      i--;
     }
   return(0);
  }
                       

                                     