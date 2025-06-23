//+------------------------------------------------------------------+
//|                                                Complex_pairs.mq4 |
//|                                              SemSemFX@rambler.ru |
//|              http://onix-trade.net/forum/index.php?showtopic=107 |
//|                 http://forum.alpari-idc.ru/viewtopic.php?t=46916 |
//+------------------------------------------------------------------+
#property copyright "SemSemFX@rambler.ru"
#property link      "http://onix-trade.net/forum/index.php?showtopic=107"
#property link      "http://forum.alpari-idc.ru/viewtopic.php?t=46916"
//----
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Green
//---- buffers
double pair[];
//---- parameters
// for monthly
int mn_per=12;
int mn_fast=3;
// for weekly
int w_per=9;
int w_fast=3;
// for daily
int d_per=5;
int d_fast=3;
// for H4
int h4_per=12;
int h4_fast=2;
// for H1
int h1_per=24;
int h1_fast=8;
// for M30
int m30_per=16;
int m30_fast=2;
// for M15
int m15_per=16;
int m15_fast=4;
// for M5
int m5_per=12;
int m5_fast=3;
// for M1
int m1_per=30;
int m1_fast=10;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,pair);
   IndicatorShortName(Symbol() + "(" + Period() + "): ");
   SetIndexLabel(0, Symbol());
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int counted_bars=IndicatorCounted();
   double OPEN,HIGH,LOW,CLOSE;
//---- проверка на возможные ошибки
   if(counted_bars<0) return(-1);
//---- последний посчитанный бар будет пересчитан
   if(counted_bars>0) counted_bars-=10;
//----   
   limit=Bars-counted_bars;
//---- основной цикл
   int Price=6;
   int Mode=3;
   int per1,per2;
   switch(Period())
     {
      case 1:     per1=m1_per; per2=m1_fast; break;
      case 5:     per1=m5_per; per2=m5_fast; break;
      case 15:    per1=m15_per;per2=m15_fast; break;
      case 30:    per1=m30_per;per2=m30_fast; break;
      case 60:    per1=h1_per; per2=h1_fast; break;
      case 240:   per1=h4_per; per2=h4_fast; break;
      case 1440:  per1=d_per;  per2=d_fast; break;
      case 10080: per1=w_per;  per2=w_fast; break;
      case 43200: per1=mn_per; per2=mn_fast; break;
     }
   for(int i=0; i<limit; i++)
     {
        if (Symbol()=="EURUSD")
        {
         OPEN=EUR(Mode,PRICE_OPEN,i,per1,per2)-USD(Mode,PRICE_OPEN,i,per1,per2);
         HIGH=EUR(Mode,PRICE_HIGH,i,per1,per2)-USD(Mode,PRICE_HIGH,i,per1,per2);
         LOW=EUR(Mode,PRICE_LOW,i,per1,per2)-USD(Mode,PRICE_LOW,i,per1,per2);
         CLOSE=EUR(Mode,PRICE_CLOSE,i,per1,per2)-USD(Mode,PRICE_CLOSE,i,per1,per2);
        }
        if (Symbol()=="EURGBP")
        {
         OPEN=EUR(Mode,PRICE_OPEN,i,per1,per2)-GBP(Mode,PRICE_OPEN,i,per1,per2);
         HIGH=EUR(Mode,PRICE_HIGH,i,per1,per2)-GBP(Mode,PRICE_HIGH,i,per1,per2);
         LOW=EUR(Mode,PRICE_LOW,i,per1,per2)-GBP(Mode,PRICE_LOW,i,per1,per2);
         CLOSE=EUR(Mode,PRICE_CLOSE,i,per1,per2)-GBP(Mode,PRICE_CLOSE,i,per1,per2);
        }
        if (Symbol()=="EURCHF")
        {
         OPEN=EUR(Mode,PRICE_OPEN,i,per1,per2)-CHF(Mode,PRICE_OPEN,i,per1,per2);
         HIGH=EUR(Mode,PRICE_HIGH,i,per1,per2)-CHF(Mode,PRICE_HIGH,i,per1,per2);
         LOW=EUR(Mode,PRICE_LOW,i,per1,per2)-CHF(Mode,PRICE_LOW,i,per1,per2);
         CLOSE=EUR(Mode,PRICE_CLOSE,i,per1,per2)-CHF(Mode,PRICE_CLOSE,i,per1,per2);
        }
        if (Symbol()=="EURJPY")
        {
         OPEN=EUR(Mode,PRICE_OPEN,i,per1,per2)-JPY(Mode,PRICE_OPEN,i,per1,per2);
         HIGH=EUR(Mode,PRICE_HIGH,i,per1,per2)-JPY(Mode,PRICE_HIGH,i,per1,per2);
         LOW=EUR(Mode,PRICE_LOW,i,per1,per2)-JPY(Mode,PRICE_LOW,i,per1,per2);
         CLOSE=EUR(Mode,PRICE_CLOSE,i,per1,per2)-JPY(Mode,PRICE_CLOSE,i,per1,per2);
        }
        if (Symbol()=="GBPUSD")
        {
         OPEN=GBP(Mode,PRICE_OPEN,i,per1,per2)-USD(Mode,PRICE_OPEN,i,per1,per2);
         HIGH=GBP(Mode,PRICE_HIGH,i,per1,per2)-USD(Mode,PRICE_HIGH,i,per1,per2);
         LOW=GBP(Mode,PRICE_LOW,i,per1,per2)-USD(Mode,PRICE_LOW,i,per1,per2);
         CLOSE=GBP(Mode,PRICE_CLOSE,i,per1,per2)-USD(Mode,PRICE_CLOSE,i,per1,per2);
        }
        if (Symbol()=="GBPCHF")
        {
         OPEN=GBP(Mode,PRICE_OPEN,i,per1,per2)-CHF(Mode,PRICE_OPEN,i,per1,per2);
         HIGH=GBP(Mode,PRICE_HIGH,i,per1,per2)-CHF(Mode,PRICE_HIGH,i,per1,per2);
         LOW=GBP(Mode,PRICE_LOW,i,per1,per2)-CHF(Mode,PRICE_LOW,i,per1,per2);
         CLOSE=GBP(Mode,PRICE_CLOSE,i,per1,per2)-CHF(Mode,PRICE_CLOSE,i,per1,per2);
        }
        if (Symbol()=="GBPJPY")
        {
         OPEN=GBP(Mode,PRICE_OPEN,i,per1,per2)-JPY(Mode,PRICE_OPEN,i,per1,per2);
         HIGH=GBP(Mode,PRICE_HIGH,i,per1,per2)-JPY(Mode,PRICE_HIGH,i,per1,per2);
         LOW=GBP(Mode,PRICE_LOW,i,per1,per2)-JPY(Mode,PRICE_LOW,i,per1,per2);
         CLOSE=GBP(Mode,PRICE_CLOSE,i,per1,per2)-JPY(Mode,PRICE_CLOSE,i,per1,per2);
        }
        if (Symbol()=="USDCHF")
        {
         OPEN=USD(Mode,PRICE_OPEN,i,per1,per2)-CHF(Mode,PRICE_OPEN,i,per1,per2);
         HIGH=USD(Mode,PRICE_HIGH,i,per1,per2)-CHF(Mode,PRICE_HIGH,i,per1,per2);
         LOW=USD(Mode,PRICE_LOW,i,per1,per2)-CHF(Mode,PRICE_LOW,i,per1,per2);
         CLOSE=USD(Mode,PRICE_CLOSE,i,per1,per2)-CHF(Mode,PRICE_CLOSE,i,per1,per2);
        }
        if (Symbol()=="USDJPY")
        {
         OPEN=USD(Mode,PRICE_OPEN,i,per1,per2)-JPY(Mode,PRICE_OPEN,i,per1,per2);
         HIGH=USD(Mode,PRICE_HIGH,i,per1,per2)-JPY(Mode,PRICE_HIGH,i,per1,per2);
         LOW=USD(Mode,PRICE_LOW,i,per1,per2)-JPY(Mode,PRICE_LOW,i,per1,per2);
         CLOSE=USD(Mode,PRICE_CLOSE,i,per1,per2)-JPY(Mode,PRICE_CLOSE,i,per1,per2);
        }
        if (Symbol()=="CHFJPY")
        {
         OPEN=CHF(Mode,PRICE_OPEN,i,per1,per2)-JPY(Mode,PRICE_OPEN,i,per1,per2);
         HIGH=CHF(Mode,PRICE_HIGH,i,per1,per2)-JPY(Mode,PRICE_HIGH,i,per1,per2);
         LOW=CHF(Mode,PRICE_LOW,i,per1,per2)-JPY(Mode,PRICE_LOW,i,per1,per2);
         CLOSE=CHF(Mode,PRICE_CLOSE,i,per1,per2)-JPY(Mode,PRICE_CLOSE,i,per1,per2);
        }
      pair[i]=(OPEN+HIGH+LOW+CLOSE)/4;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
  double USD(int Mode, int Price, int i, int per1, int per2)
  {
   return(
            (iMA("EURUSD",0,per1,0,Mode,Price,i)-
            iMA("EURUSD",0,per2,0,Mode,Price,i))*10000
            +
            (iMA("GBPUSD",0,per1,0,Mode,Price,i)-
            iMA("GBPUSD",0,per2,0,Mode,Price,i))*10000
            +
            (iMA("USDCHF",0,per2,0,Mode,Price,i)-
            iMA("USDCHF",0,per1,0,Mode,Price,i))*10000
            +
            (iMA("USDJPY",0,per2,0,Mode,Price,i)-
            iMA("USDJPY",0,per1,0,Mode,Price,i))*100
          );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  double EUR(int Mode, int Price, int i, int per1, int per2)
  {
   return(
            (iMA("EURUSD",0,per2,0,Mode,Price,i)-
            iMA("EURUSD",0,per1,0,Mode,Price,i))*10000
            +
            (iMA("EURGBP",0,per2,0,Mode,Price,i)-
            iMA("EURGBP",0,per1,0,Mode,Price,i))*10000
            +
            (iMA("EURCHF",0,per2,0,Mode,Price,i)-
            iMA("EURCHF",0,per1,0,Mode,Price,i))*10000
            +
            (iMA("EURJPY",0,per2,0,Mode,Price,i)-
            iMA("EURJPY",0,per1,0,Mode,Price,i))*100
          );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  double GBP(int Mode, int Price, int i, int per1, int per2)
  {
   return(
            (iMA("GBPUSD",0,per2,0,Mode,Price,i)-
            iMA("GBPUSD",0,per1,0,Mode,Price,i))*10000
            +
            (iMA("EURGBP",0,per1,0,Mode,Price,i)-
            iMA("EURGBP",0,per2,0,Mode,Price,i))*10000
            +
            (iMA("GBPCHF",0,per2,0,Mode,Price,i)-
            iMA("GBPCHF",0,per1,0,Mode,Price,i))*10000
            +
            (iMA("GBPJPY",0,per2,0,Mode,Price,i)-
            iMA("GBPJPY",0,per1,0,Mode,Price,i))*100
          );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  double CHF(int Mode, int Price, int i, int per1, int per2)
  {
   return(
            (iMA("USDCHF",0,per1,0,Mode,Price,i)-
            iMA("USDCHF",0,per2,0,Mode,Price,i))*10000
            +
            (iMA("EURCHF",0,per1,0,Mode,Price,i)-
            iMA("EURCHF",0,per2,0,Mode,Price,i))*10000
            +
            (iMA("GBPCHF",0,per1,0,Mode,Price,i)-
            iMA("GBPCHF",0,per2,0,Mode,Price,i))*10000
            +
            (iMA("CHFJPY",0,per2,0,Mode,Price,i)-
            iMA("CHFJPY",0,per1,0,Mode,Price,i))*100
          );
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  double JPY(int Mode, int Price, int i, int per1, int per2)
  {
   return(
            (iMA("USDJPY",0,per1,0,Mode,Price,i)-
            iMA("USDJPY",0,per2,0,Mode,Price,i))*100
            +
            (iMA("EURJPY",0,per1,0,Mode,Price,i)-
            iMA("EURJPY",0,per2,0,Mode,Price,i))*100
            +
            (iMA("GBPJPY",0,per1,0,Mode,Price,i)-
            iMA("GBPJPY",0,per2,0,Mode,Price,i))*100
            +
            (iMA("CHFJPY",0,per1,0,Mode,Price,i)-
            iMA("CHFJPY",0,per2,0,Mode,Price,i))*100
          );
  }
//+------------------------------------------------------------------+