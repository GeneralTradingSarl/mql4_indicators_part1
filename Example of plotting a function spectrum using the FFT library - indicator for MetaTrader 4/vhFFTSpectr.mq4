//+------------------------------------------------------------------+
//|                                            ##FFTSpectr.mq4      |
//|                                          Copyright © 2009, sHell |
//|                                                  diakin@narod.ru |
//+------------------------------------------------------------------+

//Based on
//+------------------------------------------------------------------+
//|                                           i_i_SpecktrAnalis_1.mq4|
//|                                          Copyright © 2006, klot. |
//|                                                     klot@mail.ru |
//+------------------------------------------------------------------+

// Пример использования быстрого преобразования фурье (БПФ)\ Fast Fourier transform (FFT)
// В качестве тестовой задается функция из трех синусоид с разными частотами и амплитудами.
// Для перехода к ценам разкомментарьте  sig=Close[i];



#property copyright "Copyright © 2009, sHell"
#property link      "diakin@narod.ru"
//---
#include <stdlib.mqh>
#define pi 3.14159265358979323846
//---
#import "#_lib_FFT.ex4"
void realfastfouriertransform(double& a[], int tnn, bool inversefft);
#import
//---
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red

//---- buffers
double SpectrBuffer[];
//---
extern double n=8;// Задает размер массива - количество свечей на которых производятся вычисления. При n=8 число свечей = 2^8=256 свечей


// параметры тестовой функции
extern double a1=1.0;// Амплитуда периодической функции
extern double f1=1.0;// Частота периодической функции
extern double ff1=0;// Фаза периодической функции

extern double a2=4.0;// Амплитуда периодической функции
extern double f2=4.0;// Частота периодической функции
extern double ff2=0;// Фаза периодической функции

extern double a3=8.0;// Амплитуда периодической функции
extern double f3=8.0;// Частота периодической функции
extern double ff3=0;// Фаза периодической функции



//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
SetIndexStyle(0,DRAW_HISTOGRAM);
SetIndexBuffer(0,SpectrBuffer);
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
   int tnn1=MathPow(2,n);//  размер массива должен быть степенью двойки
   double aa[];
   int N=ArrayResize(aa,tnn1);
   SetIndexDrawBegin(0,Bars-N);

   // Построение спектра 
   double sig;
   for(int i=0; i<=N-1; i++)
   {

//
   sig=a1*MathCos(f1*i/N*(2.0*pi)+ff1*pi)+a2*MathCos(f2*i/N*(2.0*pi)+ff2*pi)+a3*MathCos(f3*i/N*(2.0*pi)+ff3*pi); // Обыкновенная периодическая функция - к рынку не имееет отношения
 //sig=Close[i]; // рыночные цены
 //sig=iRSI(NULL,0,14,PRICE_CLOSE,i+1); // ????????
   aa[i]=sig;
      
   }
   
   // Прямое преобразование Фурье - после выпонения функции в массиве aa[] - спектрограмма
   realfastfouriertransform(aa, tnn1, false); 
   
   //--- Вывод спектрограммы на экран
   for( i=0; i<=(N-1)/2; i++)
   {
   // Модуль комплексного числа
      SpectrBuffer[i]=(MathSqrt(aa[i*2]*aa[i*2]+aa[i*2+1]*aa[i*2+1]))/(N/2); 
   }


   //--- обратное преобразование фурье
   /*
   //realfastfouriertransform(aa, tnn1, true);
   for( i=0; i<=N; i++)
   {
      SpectrBuffer[i]=aa[i];
   }*/

   //----
   return(0);
  }
  
//+------------------------------------------------------------------+


//--------------------------------------------------------------------+

// не знаю зачем эта функция ;)
void InSigNormalize(double& aa[])
{
   double sum_sqrt;
   int element_count=ArraySize(aa);
   sum_sqrt=0;

   for( int i=0; i<=element_count-1; i++)
   {
      sum_sqrt+=MathPow(aa[i],2);
   }
   sum_sqrt=MathSqrt(sum_sqrt);
   
   if (sum_sqrt!=0)
   {
      for( i=0; i<=element_count-1; i++)
      {
         aa[i]=aa[i]/sum_sqrt;
      }
   }
   return;
}
//---------------------------------------------------------------------+