//+---------------------------------------------------------------------------------+
//|                                                   corelation.mq4                |
//|                                Copyright © 2008, Borys Chekmasov                |
//|                                     http://uatrader.blogspot.com                |
//+---------------------------------------------------------------------------------+
// Индикатор предназначен для поиска кореляций между различными иструментами        |
// Позволяет накладывать график одного инструмента поверх другого                   |
// Входные параметры:
// simbol_name - тикер который накладывается на график
// bars_for_autoscale - количество баров, по которым производится массштабирование
// если ноль, то максимальное количество баров
// inverse - переворачивает график вверх ногами
// MA - показывать или нет скользящую среднюю для накладываемого графика
// MAPeriod - период скользящей средней
// MAOnly - показывать только скользящую среднюю (скрывает график)
#property copyright "Copyright © 2008, Borys Chekmasov"
#property link      "http://uatrader.blogspot.com"
//---
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 clrGold
#property indicator_color2 clrDodgerBlue
//входные параметры
extern string simbol_name="EURUSD";
extern int bars_for_autoscale=200;
extern bool inverse=false;
extern bool MA=false;
extern int MAPeriod=14;
extern bool MAOnly = false;
//---
double simbolBuffer[];
double MABuffer[];
//+------------------------------------------------------------------+
//| инициализация                                                    |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexBuffer(0,simbolBuffer);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(1,MABuffer);
   SetIndexStyle(1,DRAW_LINE);
   return (0);
  }
//+------------------------------------------------------------------+
//| основной цикл                                                    |
//+------------------------------------------------------------------+
int start()
  {
   double simbol_scale=1;
   double simbol_offset=0;
   int i,k;
   int cb=IndicatorCounted();
   i = Bars-cb-1;
   k = bars_for_autoscale;
   if(bars_for_autoscale==0) k=Bars;
   if(bars_for_autoscale>=Bars) k=Bars-1;

   double max_scale=iClose(simbol_name,0,1);
   double min_scale=iClose(simbol_name,0,1);
   double max_scale2=Close[1];
   double min_scale2=Close[1];
   while(k>=0)
     {

      if(max_scale<iClose(simbol_name,0,k)) max_scale=iClose(simbol_name,0,k);
      if(min_scale>iClose(simbol_name,0,k)) min_scale=iClose(simbol_name,0,k);
      if(max_scale2<Close[k])max_scale2=Close[k];
      if(min_scale2>Close[k])min_scale2=Close[k];


      k--;
     }

   simbol_scale=(max_scale2-min_scale2)/(max_scale-min_scale);
   if(!inverse)
     {
      simbol_offset=max_scale2-simbol_scale*max_scale;
     }
   else
     {
      simbol_offset=max_scale2+simbol_scale*min_scale;
     }

   while(i>=0)
     {

      if(!inverse)
        {
         if(!MAOnly) simbolBuffer[i]=simbol_scale*(iClose(simbol_name,0,i))+simbol_offset;
         if(MA)MABuffer[i]=(iMA(simbol_name,0,MAPeriod,0,0,PRICE_CLOSE,i))*simbol_scale+simbol_offset;
        }
      else
        {
         if(!MAOnly) simbolBuffer[i]=simbol_offset-simbol_scale*(iClose(simbol_name,0,i));
         if(MA)MABuffer[i]=simbol_offset-simbol_scale*(iMA(simbol_name,0,MAPeriod,0,0,PRICE_CLOSE,i));
        }
      i--;
     }

   return(0);
  }
//+------------------------------------------------------------------+
