//+------------------------------------------------------------------+
//|                                                        DayBB.mq4 |
//|                                 Copyright 2010-2015, Excstrategy |
//|                                        http://www.ExcStrategy.ru |
//+------------------------------------------------------------------+
#property copyright "ExcStrategy"
#property link      "http://www.ExcStrategy.ru"
#property version   "1.1"
#property description "Bollinger bands"
#property strict
//+------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Lime
#property indicator_width1 1  
#property indicator_color2 Red
#property indicator_width2 1  
#property indicator_color3 Magenta
#property indicator_width3 1  
//---- input parameters
extern double Deviation= 3;
extern int Bands_shift = 1;
extern int Applied_price=0;
//----
extern int DaysForCalculation=2;
//---- buffers
double BufferHigh1[];
double BufferLow1[];
double BufferHigh2[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(3);
//---- indicator lines
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexBuffer(0,BufferHigh1);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexBuffer(1,BufferLow1);
   SetIndexStyle(2,DRAW_ARROW);
   SetIndexBuffer(2,BufferHigh2);
//----
   SetIndexArrow(0,159);
   SetIndexArrow(1,159);
   SetIndexArrow(2,159);
//---- 
   SetIndexLabel(0,"Bands Upper");
   SetIndexLabel(1,"Bands Lower");
   SetIndexLabel(2,"Bands Average");
//----
   DaysForCalculation=DaysForCalculation+1;
//----    
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   if(Period()>1400)
     {
      Alert("Error! Period can not be greater than D1");
      return(0);
     }
//----
   int counted_bars=IndicatorCounted();
   int barsday;
   bool rangeday;
   datetime Time1=Time[0],Time2;
//----
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
//----
   for(int i=0; i<limit; i++)
     {
      //----
      rangeday= false;
      barsday = 0;
      //----
      Time2=Time[i]+(1440*60*DaysForCalculation);
      if(Time1<Time2)
         if(i<Bars-MathRound(1500/Period()))
            for(int a=i; a<i+1441; a++)
              {
               //----
               barsday++;
               //----
               if(TimeDayOfYear(Time[a])!=TimeDayOfYear(Time[a+1])) a=i+1442;
              }
      //----
      BufferHigh1[i]= iBands(NULL,0,barsday,Deviation,Bands_shift,Applied_price,1,i);
      BufferLow1[i] = iBands(NULL,0,barsday,Deviation,Bands_shift,Applied_price,2,i);
      BufferHigh2[i]= iBands(NULL,0,barsday,Deviation,Bands_shift,Applied_price,0,i);
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
