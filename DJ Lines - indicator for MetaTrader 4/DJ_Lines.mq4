//+------------------------------------------------------------------+ 
//| DJ_Lines.mq4                                                     | 
//| Copyright © 2005, MetaQuotes Software Corp.                      | 
//| http://www.metaquotes.net                                        | 
//+------------------------------------------------------------------+ 
/* 
Name := HiLoClose 
Author := hawt and PUMBA 
Link := hawt77@bigmir.net 
*/
#property indicator_chart_window
#property indicator_buffers 7
#property indicator_color1 White
#property indicator_color2 Red
#property indicator_color3 Red
#property indicator_color4 Yellow
#property indicator_color5 Yellow
#property indicator_color6 LimeGreen
#property indicator_color7 LimeGreen
//---- input parameters5 
extern int show_comment=1; // рисовать ли комментарий (0 - нет, 1 - да) 
extern int how_long=1000; // сколько баров обрабатывать (-1 - все) 
//---- indicator buffers 
double E2[];
double ff[];
double E4[];
double E5[];
double E6[];
double E7[];
double E8[];
//+------------------------------------------------------------------+ 
//| Custom indicator initialization function                         | 
//+------------------------------------------------------------------+ 
int init()
  {
   SetIndexBuffer(0, E2);
   SetIndexBuffer(1, ff);
   SetIndexBuffer(2, E4);
   SetIndexBuffer(3, E5);
   SetIndexBuffer(4, E6);
   SetIndexBuffer(5, E7);
   SetIndexBuffer(6, E8);
//----
   SetIndexStyle(0, DRAW_LINE,1,2);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexStyle(2, DRAW_LINE);
   SetIndexStyle(3, DRAW_LINE);
   SetIndexStyle(4, DRAW_LINE);
   SetIndexStyle(5, DRAW_LINE);
   SetIndexStyle(6, DRAW_LINE);
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
   double P, S, R, P1, P2, P3, C1, C2, C3;
   // правильные таймфремы для нашего индикатора - все, что меньше D1 
     if (Period()>=PERIOD_D1) {
      Comment("WARNING: Invalid timeframe! Valid value < D1.");
      return(0);
     }
   // решаем с какого бара мы начнем считать наш индикатор 
     if (how_long==-1) 
     {
      begin_bar=Bars;
      } else {
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
         P=(yesterday_high + yesterday_low + yesterday_close)/3;
         R=yesterday_high;
         S=yesterday_low;
         P1=2 * P - S;
         C1=2 * P - R;
         P2=P + (P1 - C1);
         C2=P - (P1 - C1);
         P3=R + (2 * (P - S));
         C3=S - (2 * (R - P));
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
      E2[cnt]=P;
      ff[cnt]=P1;
      E4[cnt]=C1;
      E5[cnt]=P2;
      E6[cnt]=C2;
      E7[cnt]=P3;
      E8[cnt]=C3;
      // рисуем линии сопротивления и поддержки уровня 1,2 или 3 
     }
     if (show_comment==1) 
     {
      P=(yesterday_high + yesterday_low + yesterday_close)/3;
      R=yesterday_high;
      S=yesterday_low;
      P1=2 * P - S;
      C1=2 * P - R;
      P2=P + (P1 - C1);
      C2=P - (P1 - C1);
      P3=R + (2 * (P - S));
      C3=S - (2 * (R - P));
//----
      Comment("Current H=", R, ", L=", S, ", HLС/3=", P, " C2=", C2, ", H-L=", (R-S)/Point );
     }
   return(0);
  }
//+------------------------------------------------------------------+