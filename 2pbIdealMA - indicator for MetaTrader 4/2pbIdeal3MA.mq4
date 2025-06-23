// 22.01.2009 Редактировал Николай Косицин
//+X================================================================X+
//|                                   Moving Average 2p-Ideal3MA.mq4 |
//|                     2p-IdealMA code: Copyright © 2009,   Neutron | 
//|      2p-Ideal3MA indicator: Copyright © 2009,   Nikolay Kositsin | 
//|                              Khabarovsk,   farria@mail.redcom.ru | 
//+X================================================================X+
#property copyright "Copyright © 2009, Nikolay Kositsin"
#property link      "farria@mail.redcom.ru"
//---- отрисовка индикатора в основном окне
#property indicator_chart_window
//---- количество индикаторных буферов
#property  indicator_buffers 1
//---- цвет линиии индикаторов
#property indicator_color1 Yellow
//---- входные параметры эксперта
extern double x1 =0.1;
extern double x2 = 0.1;
extern double z1 =0.1;
extern double z2 = 0.1;
extern double w1 =0.1;
extern double w2 = 0.1;
//---- индикаторные буферы
double MovingBuffer[];
//---- 
int StartBar;
//---- объявление переменных времени
datetime time2;
//---- объявление переменных с плавающей точкой
double Moving0_0, Moving1_0, Moving2_0;
double Moving0_1, Moving1_1, Moving2_1;
double Moving0_1_, Moving1_1_, Moving2_1_;
//+X================================================================X+
//|  2p-IdealMA function                                             |
//+X================================================================X+
double GetIdealMASmooth(double W1_, double W2_,
                       double Series1, double Series0, double Resalt1)
 {
//---+
   double Resalt0, dSeries, dSeries2;
   dSeries = Series0 - Series1;
   dSeries2 = dSeries * dSeries - 1.0;
   
   Resalt0 = (W1_ * (Series0 - Resalt1) + 
                   Resalt1 + W2_ * Resalt1 * dSeries2) 
                                    / (1.0 + W2_ * dSeries2);	
   return(Resalt0);
//---+ 
 }
//+X================================================================X+
//|  initialization function                                         |
//+X================================================================X+
int init()
 {
//---+
   //---- стиль изображения индикатора
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 3);
   //---- буфер для первой линии индикатора
   SetIndexBuffer(0, MovingBuffer);
   //---- минимальное количество баров для расчёта
   StartBar = 2;
   //----
   return(0);
//---+
 }
//+X================================================================X+
//|  start function                                                  |
//+X================================================================X+
int start()
 {
//---+
   //---- проверка количества баров 
                           //на достаточность для дальнейшего расчёта
   if (Bars - 1 < StartBar)
                       return(-1);                     
   //---- 
   datetime Tnew;
   //---- Введение целых переменных и получение уже посчитанных баров 
   int MaxBar, limit, bar, counted_bars = IndicatorCounted();  
   //---- проверка на возможные ошибки
   if (counted_bars < 0)
                  return(-1);
   //---- последний посчитанный бар должен быть пересчитан
   if (counted_bars > 0)
              counted_bars--;
   //---- определение номера самого старого бара,
            //начиная с которого будет произедён пересчёт всех баров
   MaxBar = Bars - 2;       
   //---- определение номера самого старого бара,
            //начиная с которого будет произедён пересчёт новых баров
   limit = Bars - counted_bars - 1; 
   
   //---- инициализация нуля   
   if (limit >= MaxBar)
     {
      
	   Moving0_0 = Close[MaxBar];
      Moving1_0 = Close[MaxBar];
      Moving2_0 = Close[MaxBar];
      //---- 
      Moving0_1 = Close[MaxBar + 1];
      Moving1_1 = Close[MaxBar + 1];
      Moving2_1 = Close[MaxBar + 1];
      //----
      limit = MaxBar;
      MovingBuffer[MaxBar] = Close[MaxBar];
	   MovingBuffer[MaxBar + 1] = Close[MaxBar + 1]; 
     } 
     
   //+---+ восстановление значений переменных
   if (limit < MaxBar)
    {
     Tnew = Time[limit + 1];
     //---- 
     if (Tnew == time2)
      {
       Moving0_1 = Moving0_1_;
       Moving1_1 = Moving1_1_;
       Moving2_1 = Moving2_1_;
      }
     else
      {
       if (Tnew > time2)
            Print("Ошибка восстановления переменных!!! Tnew > time2");
       else Print("Ошибка восстановления переменных!!! Tnew < time2");
       Print("Будет произведён пересчёт индикатора на всех барах!");
       return(-1);  
      }
    }
   //+---+
   //---- ВЫЧИСЛЕНИЕ ИНДИКАТОРА  
	for( bar = limit; bar >= 0; bar--)
	 {
	   //+---+ Сохранение значений переменных
      if (bar == 1)
       if((limit == 1 && time2 == Time[2]) || limit > 1)
        {
         time2 = Time[2];
         Moving0_1_ = Moving0_1;
         Moving1_1_ = Moving1_1;
         Moving2_1_ = Moving2_1;
        }
      //+---+   
	  
      Moving0_0 = GetIdealMASmooth(x1, x2, 
                      Close[bar + 1], Close[bar], Moving0_1);
      //----                       
      Moving1_0 = GetIdealMASmooth(z1, z2, 
                            Moving0_1, Moving0_0, Moving1_1);
      //----                       
      Moving2_0 = GetIdealMASmooth(w1, w2, 
                            Moving1_1, Moving1_0, Moving2_1);
      //----                       
      Moving0_1 = Moving0_0;
      Moving1_1 = Moving1_0;
      Moving2_1 = Moving2_0;
      //---- 
      MovingBuffer[bar] = Moving2_0;
    }
   //----
   return(0);
//---+
 }
//+X----------------------------------------------------------------X+

