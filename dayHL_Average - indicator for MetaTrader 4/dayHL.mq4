//+------------------------------------------------------------------+
//| dayHL_Average.mq4                                                |
//+------------------------------------------------------------------+
/*
Name := dayHL_Average
Author := KCBT
Link := http://www.kcbt.ru/forum/index.php?
*/
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Red
#property indicator_color3 Red
//---- input parameters5
extern int show_comment=1; // рисовать ли комментарий (0 - нет, 1 - да)
extern int how_long=1000; // сколько баров обрабатывать (-1 - все)
//---- indicator buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(1, ExtMapBuffer2);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(2, ExtMapBuffer3);
   SetIndexStyle(2, DRAW_LINE);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   Comment("");
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int cnt=0; // счетчик баров
   int begin_bar=0; // бар, с которого начинает работу индикатор
   int prev_day, cur_day; // идентификаторы текущего и предыдущего дня
   double day_high=0; // дневной high
   double day_low=0; // дневной low
   double yesterday_high=0; // наибольшая цена предыдущего дня
   double yesterday_low=0; // наименьшая цена предыдущего дня
   double yesterday_close=0; // цена закрытия предыдущего дня
   double P, S, R;
   // правильные таймфремы для нашего индикатора - все, что меньше D1
     if (Period()>=PERIOD_D1) 
     {
      Comment("WARNING: Invalid timeframe! Valid value < D1.");
      return(0);
     }
   // решаем с какого бара мы начнем считать наш индикатор
     if (how_long==-1) 
     {
      begin_bar=Bars;
      }
       else 
      {
      begin_bar=how_long;
     }
   // обходим бары слева направо (0-й бар тоже используем, т.к. из него мы берём только high и low)
     for(cnt=begin_bar; cnt>=0; cnt--) 
     {
      cur_day=TimeDay(Time[cnt]);
        if (prev_day!=cur_day) 
        {
         yesterday_close=Close[cnt+1];
         yesterday_high=day_high;
         yesterday_low=day_low;
         P=(yesterday_high + yesterday_low )/2;
         R=yesterday_high;
         S=yesterday_low;
         // т.к. начался новый день, то инициируем макс. и мин. текущего (уже) дня
         day_high=High[cnt];
         day_low=Low[cnt];
         // запомним данный день, как текущий
         prev_day=cur_day;
        }
      // продолжаем накапливать данные
      day_high=MathMax(day_high, High[cnt]);
      day_low=MathMin(day_low, Low[cnt]);
      // рисуем pivot-линию по значению, вычисленному по параметрам вчерашнего дня
      ExtMapBuffer2[cnt]=P;
      // рисуем линии сопротивления и поддержки уровня 1,2 или 3
      ExtMapBuffer1[cnt]=R; // сопротивление
      ExtMapBuffer3[cnt]=S; // поддержка
     }
     if (show_comment==1) 
     {
      P=(yesterday_high + yesterday_low )/2;
      R=yesterday_high;
      S=yesterday_low;
      Comment("Current H=", R, ", L=", S, ", HL/2=", P, ", H-L=", (R-S)/Point );
     }
   return(0);
  }
//+------------------------------------------------------------------+