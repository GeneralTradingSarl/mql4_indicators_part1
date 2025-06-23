//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, Julien Loutre"
#property link      "http://www.forexcomm.com"
#property  indicator_chart_window
#property indicator_buffers  2
#property  indicator_color1  LightSkyBlue
#property  indicator_color2  Plum



extern int       Band_Period=48;
extern int       price_type=0; // 0 = High/Low | 1 = Open/Close

//---- buffers
double WWBuffer1[];
double WWBuffer2[];
double WWBuffer3[];

double ATR;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(2);

   SetIndexStyle(0,DRAW_LINE,1);
   SetIndexStyle(1,DRAW_LINE,1);

   SetIndexLabel(0,"High");
   SetIndexLabel(1,"Low");

   SetIndexBuffer(0,WWBuffer1);
   SetIndexBuffer(1,WWBuffer2);

   IndicatorDigits(Digits+2);

   IndicatorShortName("Automatic Fibonacci");

   ObjectCreate("AutoFibo",OBJ_FIBO,0,Time[0],High[0],Time[0],Low[0]);

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete("AutoFibo");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int    limit,i;
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+Band_Period;

   for(i=limit-1; i>=0; i--)
     {
      WWBuffer1[i] = getPeriodHigh(Band_Period,i);
      WWBuffer2[i] = getPeriodLow(Band_Period,i);

      ObjectSet("AutoFibo",OBJPROP_TIME1,Time[Band_Period]);
      ObjectSet("AutoFibo",OBJPROP_TIME2,Time[0]);
      if(Open[Band_Period]<Open[0])
        { // Up
         ObjectSet("AutoFibo",OBJPROP_PRICE1,getPeriodHigh(Band_Period,i));
         ObjectSet("AutoFibo",OBJPROP_PRICE2,getPeriodLow(Band_Period,i));
           } else {
         ObjectSet("AutoFibo",OBJPROP_PRICE1,getPeriodLow(Band_Period,i));
         ObjectSet("AutoFibo",OBJPROP_PRICE2,getPeriodHigh(Band_Period,i));
        }

     }
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getPeriodHigh(int period,int pos)
  {
   int i;
   double buffer=0;
   for(i=pos;i<=pos+period;i++)
     {
      if(price_type==0)
        {
         if(High[i]>buffer)
           {
            buffer=High[i];
           }
           } else {
         if(Open[i]>Close[i])
           { // Down
            if(Open[i]>buffer)
              {
               buffer=Open[i];
              }
              } else {
            if(Close[i]>buffer)
              {
               buffer=Close[i];
              }
           }
        }
     }
   return(buffer);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getPeriodLow(int period,int pos)
  {
   int i;
   double buffer=100000;
   for(i=pos;i<=pos+period;i++)
     {
      if(price_type==0)
        {
         if(Low[i]<buffer)
           {
            buffer=Low[i];
           }
           } else {
         if(Open[i]>Close[i])
           { // Down
            if(Close[i]<buffer)
              {
               buffer=Close[i];
              }
              } else {
            if(Open[i]<buffer)
              {
               buffer=Open[i];
              }
           }
        }
     }
   return(buffer);
  }
//+------------------------------------------------------------------+
