//+---------------------------------------------------------------------+
//|                                              MLS-HL4.mq4            |
//| The Method of Least Squares                                         |
//|      High and Low ver. 4.1                                          |
//|             Copyright © Trofimov 2008                               |
//+---------------------------------------------------------------------+
//| Метод наименьших квадратов                                          |
//|   по верхней и нижней отметке свечи                                 |
//| Описание: Расчёт минимального квадратичного отлонения от прямой     |
//|           в пунктах. Если рынок колеблется в пределах тангенса      |
//|           угла наклона линии тренда к горизонтальной прямой         |
//|           то тренд развивается уверенно и равномерно.               |
//| Авторское право принадлежит Трофимову Евгению Витальевичу, 2008     |
//+---------------------------------------------------------------------+


#property copyright "Copyright © Trofimov Evgeniy Vitalyevich, 2008-2010"
#property link      "http://multitest.semico.ru/mnk.htm"

//---- Свойства индикатора
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 DodgerBlue
#property indicator_width1 2
//#property indicator_color2 DarkSeaGreen
//#property indicator_width2 0
#property indicator_level1 0
//---- Входящие параметры
extern int MyPeriod=12;
extern bool ReDraw=true; //-если включен, то перерисовывает нулевой бар при каждом новом тике
                          // если выключен, то нулевой бар содержит фиксированное значение, вычисленное по предыдущим (готовым) барам
//---- Массив данных индикатора
double MLS_Angel[],MLS_b[],MLS_p[];
//datetime LastTime;
//+------------------------------------------------------------------+
//|                Функция инициализации индикатора                  |
//+------------------------------------------------------------------+
int init()
  {
//---- x дополнительных буфера, используемых для расчета
   IndicatorBuffers(3);
   IndicatorDigits(Digits);
//---- параметры рисования (установка начального бара)
   SetIndexDrawBegin(0,MyPeriod);
   SetIndexDrawBegin(1,MyPeriod);
   SetIndexDrawBegin(2,MyPeriod);
//---- x распределенных буфера индикатора
   SetIndexBuffer(0,MLS_Angel);
   SetIndexBuffer(1,MLS_b);
   SetIndexBuffer(2,MLS_p);
//---- имя индикатора и подсказки для линий
   IndicatorShortName("MLS-HL4 ("+MyPeriod+") = ");
   SetIndexLabel(0,"a");
   SetIndexLabel(1,"b");
   SetIndexLabel(2,"p");
   SetIndexStyle(1,DRAW_NONE, EMPTY, EMPTY, CLR_NONE);
   SetIndexStyle(2,DRAW_NONE, EMPTY, EMPTY, CLR_NONE);
   return(0);
  }
//+------------------------------------------------------------------+
//|                Функция индикатора                                |
//+------------------------------------------------------------------+
int start() {
   int limit, RD;
   if(ReDraw) RD=1;
   // Пропущенные бары
   int counted_bars=IndicatorCounted();
//---- обходим возможные ошибки
   if(counted_bars<0) return(-1);
//---- новые бары не появились и поэтому ничего рисовать не нужно
   limit=Bars-counted_bars-1+RD;
   
   if(counted_bars==0) limit-=RD+MyPeriod;
   
   //Print("limit=", limit, ", Bars=",Bars,", IndicatorCounted()=",IndicatorCounted());
//---- основные переменные
   double k1, i1, j1, k2, i2, j2;
   double a, b, y, S, H, L;
   int x, mini_x;
   double p;
//---- основной цикл
   for(int t=limit-RD; t>-RD; t--) {
      k1=0; i1=0; j1=0; k2=0; i2=0;
      for(x=t+MyPeriod-1; x>=t; x--) { // составляем нормальные уравнения k1=a*i1+b*j1 и k2=a*i2+b*j2
         mini_x=x-t;
         H=High[x];//Point;
         L=Low[x];//Point;
         k1=k1+H*mini_x;    k2=k2+H;
         k1=k1+L*mini_x;    k2=k2+L;
         i1=i1+2*mini_x*mini_x;  i2=i2+2*mini_x;
         j1=j1+2*mini_x;           
      }//Next x
      j2=MyPeriod*2;
      //Решаем систему уравнений
      a=(k1*j2-j1*k2)/(i1*j2-j1*i2);
      //if(a==0) Print("t=", t,", k1=", k1,", k2=",k2,", j1=",j1,", j2=",j2);
      b=(k2-i2*a)/j2;
      //Теперь все точки High и Low, на данный момент времени,
      //приблизительно расположены вдоль прямой, описаной уравнением y=ax+b,
      //где x - это номер свечи, а y - значение цены.
      MLS_Angel[t]=-a/Point;
      if(!ReDraw && t==1) MLS_Angel[0]=-a/Point;
      MLS_b[t]=b;
      p=MLS_Angel[t+1]+(MLS_Angel[t+1]-MLS_Angel[t+2]); //Что должно получиться в текущей ячейке
      MLS_p[t]=MLS_Angel[t]-p;//Поворот угла относительно касательной
   }//Next t
   return(0);
}
//+------------------------------------------------------------------+

