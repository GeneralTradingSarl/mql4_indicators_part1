//+------------------------------------------------------------------+
//|                      lukas1 arrows & curves.mq4       v.14       |
//|       Изменения:                                                 | 
//|       1. Убраны ненужные (лишние) коэффициены, не участвующие    |
//|          в расчетах Kmin, Kmax, RISK                             |
//|       2. Математика индикатора все расчеты выполняет             |
//|          внутри одного цикла, это увеличило скорость обсчёта.    |
//|       3. Выключено мерцание стрелок.                             |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, lukas1"
#property link      "http://www.alpari-idc.ru/"
//----
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Blue
#property indicator_color2 Red
#property indicator_color3 Green
#property indicator_color4 Green
//---- input parameters
extern int SSP       = 6;     //период линейного разворота индикатора
extern int CountBars = 2250;  //расчетный период 
extern int SkyCh     = 13;    //чувствительность к пробою канала 
                              //Должна быть в диапазоне 0-50. 0 - нет стрелок. Больше 50 - перерегулирование
int    i;
double high,low,smin,smax;
double val1[];      // буфер для бай
double val2[];      // буфер для селл
double Sky_BufferH[];
double Sky_BufferL[];
bool   uptrend,old;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0, 233);        // стрелка для бай
   SetIndexBuffer(0, val1);      // индекс буфера для бай
   SetIndexDrawBegin(0,2*SSP);
//
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1, 234);        // стрелка для селл
   SetIndexBuffer(1, val2);      // индекс буфера для селл
   SetIndexDrawBegin(1,2*SSP);
//
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,Sky_BufferH);
   SetIndexLabel(2,"High");
   SetIndexDrawBegin(2,2*SSP);
//
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,Sky_BufferL);
   SetIndexLabel(3,"Low");
   SetIndexDrawBegin(3,2*SSP);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Calculation of SilverTrend lines                                 | 
//+------------------------------------------------------------------+
int start()
  {
   if(Bars<=SSP+1) return(0);

   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+SSP;

//---- initial zero
   uptrend       =false;
   old           =false;
   GlobalVariableSet("goSELL", 0); // задали существование и обнулили goSELL=0
   GlobalVariableSet("goBUY", 0);  // задали существование и обнулили goBUY =0
//----
   for(i=limit-SSP; i>=0; i--) // уменьш значение shift на 1 за проход;
     {
      high= High[iHighest(Symbol(),0,MODE_HIGH,SSP,i)];
      low = Low[iLowest(Symbol(),0,MODE_LOW,SSP,i)];
      smax = high - (high - low)*SkyCh / 100; // smax ниже high с учетом коэфф.SkyCh
      smin = low + (high - low)*SkyCh / 100;  // smin выше low с учетом коэфф.SkyCh
      val1[i] = 0;
      val2[i] = 0;
      if(Close[i]<smin && i!=0) // выключено мерцание стрелок (i!=0)
        {
         uptrend=false;
        }
      if(Close[i]>smax && i!=0) // выключено мерцание стрелок (i!=0)	
        {
         uptrend=true;
        }
      if(uptrend!=old && uptrend==false)
        {
         val2[i]=high; // если условия выполнены то рисуем val1
         if(i==0) GlobalVariableSet("goBUY",1);
        }
      if(uptrend!=old && uptrend==true)
        {
         val1[i]=low; // если условия выполнены то рисуем val2
         if(i==0) GlobalVariableSet("goSELL",1);
        }
      old=uptrend;
      Sky_BufferH[i]=high - (high - low)*SkyCh / 100;
      Sky_BufferL[i]=low +  (high - low)*SkyCh / 100;
     }
   return(0);
  }
//+------------------------------------------------------------------+
