//+------------------------------------------------------------------+
//|                                               Complex_Common.mq4 |
//|                                              SemSemFX@rambler.ru |
//|              http://onix-trade.net/forum/index.php?showtopic=107 |
//|                 http://forum.alpari-idc.ru/viewtopic.php?t=46916 |
//+------------------------------------------------------------------+
#property copyright "SemSemFX@rambler.ru"
#property link      "http://onix-trade.net/forum/index.php?showtopic=107"
#property link      "http://forum.alpari-idc.ru/viewtopic.php?t=46916"
//----
#property indicator_separate_window
#property indicator_buffers 5
#property indicator_color1 Green
#property indicator_color2 Navy
#property indicator_color3 Red
#property indicator_color4 Black
#property indicator_color5 Maroon
//---- buffers
double USD[];
double EUR[];
double GBP[];
double CHF[];
double JPY[];
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
   IndicatorShortName("USD:Зеленый; EUR:Синий; GBP:Красный; CHF:Черный; JPY:Коричневый");
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,USD);
   SetIndexLabel(0, "USD");
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,EUR);
   SetIndexLabel(1, "EUR");
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,GBP);
   SetIndexLabel(2, "GBP");
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,CHF);
   SetIndexLabel(3, "CHF");
   SetIndexStyle(4,DRAW_LINE);
   SetIndexBuffer(4,JPY);
   SetIndexLabel(4, "JPY");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int counted_bars=IndicatorCounted();
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
      USD[i]=
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
      ;
      EUR[i]=
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
      ;
      GBP[i]=
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
      ;
      CHF[i]=
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
      ;
      JPY[i]=
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
      ;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+