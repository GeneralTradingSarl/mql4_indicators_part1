//+-----------------------------------------------------------------------+
//|                                                   BrainTrend1Stop.mq4 |
//|                                   Copyright © 2005. Alejandro Galindo |
//|                                                   http://elCactus.com |
//+-----------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Blue
//---- input parameters
extern int AveragePeriod=10;
extern int Reg=1;
//---- buffers
double Buffer1[];
double Buffer2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicator line
   IndicatorBuffers(2);
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexBuffer(0,Buffer1);
   SetIndexBuffer(1,Buffer2);
   SetIndexArrow(0,159);
   SetIndexArrow(1,159);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| BrainTrend1Stop                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int i,shift,counted_bars=IndicatorCounted();
   double value=0, price=0, trend=0, dK=0, AvgRange=0, WATR=0;
   int bar=0;
   int CountBars=500;
   if (CountBars>=Bars) CountBars=Bars;
   SetIndexDrawBegin(0,Bars-CountBars+11+1);
   SetIndexDrawBegin(1,Bars-CountBars+11+1);
//---- initial zero
   AvgRange=0;
   for(i=1;i<=AveragePeriod;i++)
     {
      dK=1+(AveragePeriod-i)/AveragePeriod;
      AvgRange=AvgRange+ dK*MathAbs(High[i]-Low[i]);
     }
   if (Point>=0.01) { WATR=(AvgRange/AveragePeriod)*Point; }
   else { WATR=AvgRange/AveragePeriod; }
//----
   if (Close[Bars-1] > Open[Bars-1])
     {
      value=Close[Bars - 1] * (1 - WATR);
      trend=1;
      Buffer2[Bars-1]=value;
     }
   if (Close[Bars-1] < Open[Bars-1])
     {
      value=Close[Bars - 1] * (1 + WATR);
      trend=-1;
      Buffer1[Bars-1]=value;
     }
   bar=CountBars-11-1;
   while(bar>=0)
     {
      Buffer1[shift]=0;
      Buffer2[shift]=0;
      //----
      if (Reg==2)
        {
         AvgRange=0;
         for(i=1;i<=AveragePeriod;i++)
           {
            dK=1+(AveragePeriod-i)/AveragePeriod;
            AvgRange=AvgRange+ dK*MathAbs(High[bar + i]-Low[bar + i]);
           }
         if (Point>=0.01) { WATR=(AvgRange/AveragePeriod)*Point; }
         else { WATR=AvgRange/AveragePeriod; }
        }
      if (trend>=0)
        {
         if (Close[bar] > price) { price=Close[bar]; }
         value=price * (1 - WATR);
         if (Close[bar] < value)
           {
            price=Close[bar];
            value=price * (1 + WATR);
            trend=-1;
           }
        }
      else
        {
         if (trend<=0)
           {
            if (Close[bar] < price) { price=Close[bar]; }
            value=price * (1 + WATR);
            if (Close[bar] > value)
              {
               price=Close[bar];
               value=price * (1 - WATR);
               trend=1;
              }
           }
        }
      if (trend==-1) { Buffer1[bar]=value; }
      if (trend==1) { Buffer2[bar]=value; }
      //----
      bar--;
     }
   return(0);
  }
//+------------------------------------------------------------------+

