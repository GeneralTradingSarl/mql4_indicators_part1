//+------------------------------------------------------------------+
//|                               Bunnygirl Cross and Daily Open.mq4 |
//|                                Copyright © 2005, David W. Thomas |
//|                                           mailto:davidwt@usa.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, David W. Thomas"
#property link      "mailto:davidwt@usa.net"
//----
#property indicator_chart_window
#property indicator_buffers 6
#property indicator_color1 DarkViolet
#property indicator_color2 Blue
#property indicator_color3 Red
#property indicator_color4 Gray
#property indicator_color5 Blue
#property indicator_color6 Red
//---- input parameters
extern int PipsForBounce=3;
extern int TimeZoneOfData=2;
extern int ma_method=MODE_LWMA;
//---- buffers
double DailyOpenBuffer[];
double BuyFilterBuffer[];
double SellFilterBuffer[];
double CrossBounceBuffer[];
double BuySymbolBuffer[];
double SellSymbolBuffer[];
//---- variables
int indexbegin=0;
string mastrtype="";
double dailyopen=0,
      crossamount,
      filter=0;
datetime crosstime=0;
bool crossdir=true;
bool FilterTradingTime=true;
int beginfiltertime=0;
int endfiltertime=24;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, DailyOpenBuffer);
   SetIndexLabel(0, "Daily Open");
   SetIndexEmptyValue(0, 0.0);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(1, BuyFilterBuffer);
   SetIndexLabel(1, "Buy Filter");
   SetIndexEmptyValue(1, 0.0);
   SetIndexStyle(2, DRAW_LINE);
   SetIndexBuffer(2, SellFilterBuffer);
   SetIndexLabel(2, "Sell Filter");
   SetIndexEmptyValue(2, 0.0);
   SetIndexStyle(3, DRAW_LINE, STYLE_DOT);
   SetIndexBuffer(3, CrossBounceBuffer);
   SetIndexLabel(3, "Cross/Bounce");
   SetIndexEmptyValue(3, 0.0);
   SetIndexStyle(4, DRAW_ARROW);
   SetIndexArrow(4, 233);
   SetIndexBuffer(4, BuySymbolBuffer);
   SetIndexLabel(4, "Cross Up Symbol");
   SetIndexEmptyValue(4, 0.0);
   SetIndexStyle(5, DRAW_ARROW);
   SetIndexArrow(5, 234);
   SetIndexBuffer(5, SellSymbolBuffer);
   SetIndexLabel(5, "Cross Down Symbol");
   SetIndexEmptyValue(5, 0.0);
//----
   indexbegin=Bars - 10;
   if (indexbegin < 0)
      indexbegin=0;
   if (Symbol()=="EURUSD")
      filter=10 * Point;
   else
      filter=15 * Point;
   if (ma_method==MODE_EMA)
      mastrtype="EMA";
   else
      mastrtype="WMA";
   Print(" Cross of ", mastrtype, " with a filter of ", filter/Point, " pips.");
   if (FilterTradingTime)
     {
      beginfiltertime=6 + TimeZoneOfData;
      endfiltertime=17 + TimeZoneOfData;
      Print(" Only shows buy/sell filters from ", beginfiltertime, " to ", endfiltertime, " hours (chart time).");
     }
   else
     {
      beginfiltertime=0;
      endfiltertime=24;
      Print(" Show buy/sell filters at all times.");
     }
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- TODO: add your code here
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i;
   int counted_bars=IndicatorCounted();
   string crossdirstr="";
//---- check for possible errors
   if (counted_bars < 0) counted_bars=0;
//---- last counted bar will be recounted
   if (counted_bars > 0) counted_bars--;
   if (counted_bars > indexbegin) counted_bars=indexbegin;
   if (Period()==30)
     {
      double ma20c, ma20p1, ma20p2,
      diff0, diff1, diff2;

      for(i=indexbegin-counted_bars; i>=0; i--)
        {
         if ((TimeMinute(Time[i])==0) && (TimeHour(Time[i]) - TimeZoneOfData==0))
            dailyopen=Open[i];
         DailyOpenBuffer[i]=dailyopen;
         ma20c=iMA(NULL, PERIOD_M30, 20, 0, ma_method, PRICE_CLOSE, i);
         ma20p1=iMA(NULL, PERIOD_M30, 20, 0, ma_method, PRICE_CLOSE, i+1);
         ma20p2=iMA(NULL, PERIOD_M30, 20, 0, ma_method, PRICE_CLOSE, i+2);
         diff0=iMA(NULL, PERIOD_M30, 5, 0, ma_method, PRICE_CLOSE, i) - ma20c;
         diff1=iMA(NULL, PERIOD_M30, 5, 0, ma_method, PRICE_CLOSE, i+1) - ma20p1;
         diff2=iMA(NULL, PERIOD_M30, 5, 0, ma_method, PRICE_CLOSE, i+2) - ma20p2;
         // bull signals:
         if (diff0 > 0)
           {
            if (diff1 < 0) // simple bull cross.
              {
               crossdir=true;
               // determine which bar is closer to the cross:
               if (MathAbs(diff0) < MathAbs(diff1))
                 {
                  crosstime=Time[i];
                  crossamount=ma20c;
                 }
               else
                 {
                  crosstime=Time[i+1];
                  crossamount=ma20p1;
                 }
              }
            else
               if (diff1==0 && diff2 < 0) // exact cross on last bar.
                 {
                  crossdir=true;
                  crosstime=Time[i+1];
                  crossamount=ma20p1;
                 }
               else
                  if (diff1 > 0 && diff2 > diff1 && diff0>=diff1 && diff1<=PipsForBounce*Point) // a bounce.
                    {
                     crossdir=true;
                     crosstime=Time[i+1];
                     crossamount=ma20p1;
                    }
           }
         else
            // bear signals:
            if (diff0 < 0)
              {
               if (diff1 > 0) // simple bear cross.
                 {
                  crossdir=false;
                  // determine which bar is closer to the cross:
                  if (MathAbs(diff0) < MathAbs(diff1))
                    {
                     crosstime=Time[i];
                     crossamount=ma20c;
                    }
                  else
                     crosstime=Time[i+1];
                  crossamount=ma20p1;
                    {
                    }
                 }
               else
                  if (diff1==0 && diff2 > 0) // exact cross on last bar.
                    {
                     crossdir=false;
                     crosstime=Time[i+1];
                     crossamount=ma20p1;
                    }
                  else
                     if (diff1 < 0 && diff2 < diff1 && diff0<=diff1 && MathAbs(diff1)<=PipsForBounce*Point) // a bounce.
                       {
                        crossdir=false;
                        crosstime=Time[i+1];
                        crossamount=ma20p1;
                       }
              }
         CrossBounceBuffer[i]=crossamount;
         if (TimeHour(Time[i])>=beginfiltertime && TimeHour(Time[i])<=endfiltertime)
           {
            if (crossdir)
              {
               BuyFilterBuffer[i]=crossamount + filter + Ask - Bid;
               SellFilterBuffer[i]=0;
               if (i > 0 && BuyFilterBuffer[i]!=BuyFilterBuffer[i+1])//crosstime == Time[i])
                  BuySymbolBuffer[i]=BuyFilterBuffer[i] + 5*Point;
              }
            else
              {
               SellFilterBuffer[i]=crossamount - filter;
               BuyFilterBuffer[i]=0;
               if (i > 0 && SellFilterBuffer[i]!=SellFilterBuffer[i+1])//crosstime == Time[i])
                  SellSymbolBuffer[i]=SellFilterBuffer[i] - 5*Point;
              }
           }
         if (crosstime==Time[i+1] && TimeHour(Time[i+1])>=beginfiltertime && TimeHour(Time[i+1])<=endfiltertime)
           {
            CrossBounceBuffer[i+1]=crossamount;
            if (crossdir)
              {
               BuyFilterBuffer[i+1]=crossamount + filter + Ask - Bid;
               BuySymbolBuffer[i+1]=BuyFilterBuffer[i+1] + 5*Point;
               BuySymbolBuffer[i]=0.0;
              }
            else
              {
               SellFilterBuffer[i+1]=crossamount - filter;
               SellSymbolBuffer[i+1]=SellFilterBuffer[i+1] - 5*Point;
               SellSymbolBuffer[i]=0.0;
              }
           }
        }
     }
   else
      if (Period() < 30)
        {
         // diff formula from aircom@strategybuilderfx.com.
         int diff=(TimeMinute(Time[0]) - TimeMinute(iTime(NULL, PERIOD_M30, 0)))/Period() + 1;
         int per30=30/Period();
         int j;
         for(i=indexbegin-counted_bars; i>=0; i--)
           {
            j=(i + per30 - diff)/per30;
            dailyopen=iCustom(NULL, PERIOD_M30, "Bunnygirl Cross and Daily Open",
                              PipsForBounce, TimeZoneOfData, ma_method, 0, j);
            DailyOpenBuffer[i]=dailyopen;
            crossamount=iCustom(NULL, PERIOD_M30, "Bunnygirl Cross and Daily Open",
                              PipsForBounce, TimeZoneOfData, ma_method, 3, j);
            CrossBounceBuffer[i]=crossamount;
            if (CrossBounceBuffer[i+1]!=crossamount)
               crosstime=Time[i];
            BuyFilterBuffer[i]=iCustom(NULL, PERIOD_M30, "Bunnygirl Cross and Daily Open",
                              PipsForBounce, TimeZoneOfData, ma_method, 1, j);
            SellFilterBuffer[i]=iCustom(NULL, PERIOD_M30, "Bunnygirl Cross and Daily Open",
                              PipsForBounce, TimeZoneOfData, ma_method, 2, j);
            if (i > 0 && BuyFilterBuffer[i] > 0.0 && BuyFilterBuffer[i+1]==0.0)
               BuySymbolBuffer[i]=BuyFilterBuffer[i] + 5*Point;
            else if (i > 0 && SellFilterBuffer[i] > 0.0 && SellFilterBuffer[i+1]==0.0)
                  SellSymbolBuffer[i]=SellFilterBuffer[i] - 5*Point;
           }
         crossdir=BuyFilterBuffer[0]!=0.0;
        }
      else
        {
         dailyopen=iCustom(NULL, PERIOD_M30, "Bunnygirl Cross and Daily Open",
                              PipsForBounce, TimeZoneOfData, ma_method, 0, 0);
         crossamount=iCustom(NULL, PERIOD_M30, "Bunnygirl Cross and Daily Open",
                           PipsForBounce, TimeZoneOfData, ma_method, 3, 0);
         BuyFilterBuffer[0]=iCustom(NULL, PERIOD_M30, "Bunnygirl Cross and Daily Open",
                           PipsForBounce, TimeZoneOfData, ma_method, 1, 0);
         SellFilterBuffer[0]=iCustom(NULL, PERIOD_M30, "Bunnygirl Cross and Daily Open",
                           PipsForBounce, TimeZoneOfData, ma_method, 2, 0);
         crossdir=BuyFilterBuffer[0]!=0.0;
        }

   if (crossdir)
      crossdirstr="bull";
   else
      crossdirstr="bear";
   if (crosstime!=0)  // use of Digits suggested by aircom@strategybuilderfx.com.
      Comment("Current daily open = ", DoubleToStr(dailyopen,Digits), "\nLast ", mastrtype, " cross/bounce: ", TimeToStr(crosstime), ", ", crossdirstr, " at ", DoubleToStr(crossamount,Digits));
   else
      Comment("Current daily open = ", DoubleToStr(dailyopen,Digits), "\nLast ", mastrtype, " cross/bounce: ", crossdirstr, " at ", DoubleToStr(crossamount,Digits));
   return(0);
  }
//+------------------------------------------------------------------+