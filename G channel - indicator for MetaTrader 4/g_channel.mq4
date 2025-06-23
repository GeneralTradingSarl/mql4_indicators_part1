//+------------------------------------------------------------------+
//|                                                    G Channel.mq4 |
//|                                          Copyright 2021,Kaustubh |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021,Kaustubh"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 5
#property indicator_plots   5
//--- plot Upper
#property indicator_label1  "Upper"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrCrimson
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2
//--- plot Lower
#property indicator_label2  "Lower"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrMidnightBlue
#property indicator_style2  STYLE_SOLID
#property indicator_width2  2
//--- plot Middle
#property indicator_label3  "Middle"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrOrangeRed
#property indicator_style3  STYLE_SOLID
#property indicator_width3  2
//--- plot a
#property indicator_label4  "a"
#property indicator_type4   DRAW_NONE

//--- plot b
#property indicator_label5  "b"
#property indicator_type5   DRAW_NONE

#define src             getPrice(InputPrice, open, close, high, low, i)
#define nz              NonZero
#define max             MathMax
#define min             MathMin
#define abs             MathAbs

//--- input parameters
input int                        ChannelPeriod  =100;
input ENUM_APPLIED_PRICE         InputPrice     = PRICE_CLOSE;     // Input price
//input ENUM_TIMEFRAMES            TimeFrame      = PERIOD_CURRENT; //Multi-TimeFrame period

//--- indicator buffers
double         UpperBuffer[];
double         LowerBuffer[];
double         MiddleBuffer[];
double         aBuffer[];
double         bBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,UpperBuffer);
   SetIndexBuffer(1,LowerBuffer);
   SetIndexBuffer(2,MiddleBuffer);
   SetIndexBuffer(3,aBuffer);
   SetIndexBuffer(4,bBuffer);

   for(int i = 0; i <= 5; i++)
      SetIndexEmptyValue(i, 0.0);

   for(int i = 3; i <= 5; i++)
      SetIndexLabel(i, "");


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
//---
   int limit = rates_total - 1 - ChannelPeriod;
   if(prev_calculated > 0)
      limit = rates_total - prev_calculated + 1;

   for(int i = limit; i >= 0; i--)
     {

      aBuffer[i] = max(src, nz(aBuffer[i + 1])) - nz(aBuffer[i+1] - bBuffer[i+1]) / ChannelPeriod;
      bBuffer[i] = min(src, nz(bBuffer[i + 1])) + nz(aBuffer[i+1] - bBuffer[i+1])/ ChannelPeriod;
      UpperBuffer[i] = aBuffer[i];
      LowerBuffer[i] = bBuffer[i];
      MiddleBuffer[i] = (aBuffer[i] + bBuffer[i]) / 2;
     }

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getPrice(ENUM_APPLIED_PRICE tprice, const double &open[], const double &close[], const double &high[], const double &low[], int i)
  {
   if(i >= 0)
      switch(tprice)
        {
         case PRICE_CLOSE:
            return(close[i]);
         case PRICE_OPEN:
            return(open[i]);
         case PRICE_HIGH:
            return(high[i]);
         case PRICE_LOW:
            return(low[i]);
         case PRICE_MEDIAN:
            return((high[i] + low[i]) / 2.0);
         case PRICE_TYPICAL:
            return((high[i] + low[i] + close[i]) / 3.0);
         case PRICE_WEIGHTED:
            return((high[i] + low[i] + close[i] + close[i]) / 4.0);
        }
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double NonZero(double _a, double _b = 0)
  {
   if(_a == 0 || _a == EMPTY_VALUE)
      return _b;
   else
      return _a;
  }
//+------------------------------------------------------------------+

//ORIGINL CODE FROM TRADINGVIEW by Alex Grover

//@version=4
//study("G-Channels",overlay=true)
//length = input(100),src = input(close)
////----
//a = 0.,b = 0.
//a := max(src,nz(a[1])) - nz(a[1] - b[1])/length
//b := min(src,nz(b[1])) + nz(a[1] - b[1])/length
//avg = avg(a,b)
////----
//plot(a,"Upper",color=color.blue,linewidth=2,transp=0)
//plot(avg,"Average",color=color.orange,linewidth=2,transp=0)
//plot(b,"Lower",color=color.blue,linewidth=2,transp=0)

//+------------------------------------------------------------------+
