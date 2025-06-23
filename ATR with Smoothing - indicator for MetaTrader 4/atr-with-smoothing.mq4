//+------------------------------------------------------------------+
//|                                           ATR-with-smoothing.mq4 |
//|                                           Copyright 2021, Vitor  |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "Email: nocerahargreaves4181@gmail.com"
#property version "1.10"
#property strict
#property indicator_separate_window

#property indicator_buffers 1

#property indicator_label1 "ATR"
#property indicator_color1 clrBlue
#property indicator_width1 2

//------------------------ Inputs -----------------------------------
enum SMOOTING_MODE
  {
   RMA = 0,    //RMA
   SMA = 1,    //SMA
   EMA = 2,    //EMA
   WMA = 3     //WMA
  };

input int Length = 14;
input SMOOTING_MODE Smoothing = RMA;

//------------------------ Buffers ----------------------------------
double ExtATR[];

//------------------------ Globals ----------------------------------
bool started = false;
double alpha, lastATR;
int History;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   IndicatorBuffers(1);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtATR);
   ArraySetAsSeries(ExtATR, true);
   ArrayInitialize(ExtATR, 0);

//--- setting number of bars to all available bars
   History = ArraySize(Close)-Length;

//--- smoothing coefficient for RMA and EMA
   switch(Smoothing)
     {
      case RMA:
         alpha = 1.0/Length;
         break;
      case EMA:
         alpha = 2.0/(Length+1);
         break;
     }
//---
   IndicatorShortName("ATR(" + IntegerToString(Length) + ", " + EnumToString(Smoothing) + ")");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {

   int h = Bars - IndicatorCounted() -1;
   if(h > History-1)
     {
      h = History-1;
     }

//--- get the first data (SMA of true range data)
   if(!started)
     {
      double sum = 0;
      for(int i=0; i<Length; i++)
        {
         sum += trueRange(i+h);
        }
      ExtATR[h] = sum/Length;
      lastATR = ExtATR[h];
      h--;
     }

   while(h >= 0)
     {

      double sum = 0;
      int i;

      switch(Smoothing)
        {
         //--- rma
         case RMA:
            ExtATR[h] = alpha*trueRange(h) + (1-alpha)*lastATR;
            lastATR = ExtATR[h];
            break;
         //--- sma
         case SMA:
            for(i=0; i<Length; i++)
              {
               sum += trueRange(i+h);
              }
            ExtATR[h] = sum/Length;
            break;
         //--- ema
         case EMA:
            ExtATR[h] = alpha*trueRange(h) + (1-alpha)*lastATR;
            lastATR = ExtATR[h];
            break;
         //--- wma
         case WMA:
            for(i=0; i<Length; i++)
              {
               sum += (Length-i)*trueRange(i+h);
              }
            ExtATR[h] = sum/(Length*(Length+1)/2);
            break;
        }

      h--;

     }

//--- return value of prev_calculated for next call
   return(rates_total);
  }

//+------------------------------------------------------------------+
//| calculate true range                                             |
//+------------------------------------------------------------------+
double trueRange(int shift)
  {

   double t1 = High[shift] - Low[shift];
   double t2 = MathAbs(High[shift] - Close[shift+1]);
   double t3 = MathAbs(Low[shift] - Close[shift+1]);

   return MathMax(MathMax(t1, t2), t3);
  }
//+------------------------------------------------------------------+
