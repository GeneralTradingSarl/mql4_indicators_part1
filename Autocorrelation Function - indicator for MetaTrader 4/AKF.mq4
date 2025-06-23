//+------------------------------------------------------------------+
//|                                                          AKF.mq4 |
//+------------------------------------------------------------------+
#property copyright "Привалов"
#property link      "Skype privalov-sv"


#property indicator_separate_window // Индик. рисуется в основном окне
#property indicator_minimum -1.0    // Границы окна
#property indicator_maximum  1.0
#property indicator_level1   0.0    // линия нуля
#property indicator_buffers 1       // Количество буферов
#property indicator_color1 Red      // Цвет линии

extern int      History=1440;
extern bool      WriteToFile=true;

double   AKF[];            // Открытие индикаторных массивов
double   X[],Y[],Mu[];
datetime CountedBar=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   ArrayResize(AKF,History+1);
   ArrayResize(X,History+1);
   ArrayResize(Y,History+1);
   ArrayResize(Mu,History+1);
//--------------------------------------------------------------------
   IndicatorDigits(8);
   SetIndexBuffer(0,AKF);                  // Назначение массива буферу
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,1);// Стиль линии
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
   int i,m;
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit--;

   if(counted_bars<History+1) return(0);
//----
   if(Time[0]==CountedBar) { return(0);}
   CountedBar = Time[0];

   if(Bars<History)
     {
      Alert(": Недостаточно баров на графике");
      return(0);
     }
// необходимо расчитать массив мю - содержит значения лин. регресии 
// формируем массивы X и Y
   for(i=0; i<=History; i++)
     {
      X[i]=Time[i]-Time[History];
      Y[i]=Close[i];
     }
   double A=0,B=0;                // обнуляю коэффициенты лин. регресcии
   double SKO=0.0,AKF_norm=0.0;

   LinearRegr(X,Y,History,A,B);

   for(i=0; i<=History; i++)
     {
      Mu[i]=A*X[i]+B;
      SKO += MathPow( Y[i] - Mu[i], 2 );
     }
   SKO/=History;
   Print("  A =",DoubleToStr(A,8)," B =",DoubleToStr(B,8));

//-------------------------------------------------------------------------------------------	
// Расчёт АКФ
   for(m=0; m<=History; m++)
     {
      double summ=0.0;
      for(i=0; i<=History; i++)
        {
         if(i+m>History) continue;
         summ+=(Y[i]-Mu[i]) *(Y[i+m]-Mu[i+m]);
        }
      AKF[m]=1/SKO*summ;
     }

// 5. Нормировка
// Полученный массив AKFm  просто делим на значение, которое находиться в 0 ячейке	
   for(m=History; m>=0; m --) AKF[m]/=AKF[0];

   return(0);
  }
//+------------------------------------------------------------------+
//| Рассчет коэффициентов A и B в уравнении                          |
//| y(x)=A*x+B                                                       |
//| используються формулы http://forum.mql4.com/ru/10780/page5       |
//+------------------------------------------------------------------+

void LinearRegr(double &_X[],double &_Y[],int N,double &A,double &B)
  {
   double mo_X=0.0,mo_Y=0.0,var_0=0.0,var_1=0.0;
   int i;
   for(i=0; i<N; i++)
     {
      mo_X +=_X[i];
      mo_Y +=_Y[i];
     }
   mo_X /=N;
   mo_Y /=N;

   for(i=0; i<N; i++)
     {
      var_0 +=(_X[i]-mo_X)*(_Y[i]-mo_Y);
      var_1 +=(_X[i]-mo_X)*(_X[i]-mo_X);
     }
   A = var_0 / var_1;
   B = mo_Y - A * mo_X;
  }
//+------------------------------------------------------------------+
