// ЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎ
//|                        Digital Low Pass (FATL/SATL, KGLP) Filter          |
//|                      Copyright (c) Sergey Iljukhin, Novosibirsk.          |
//|                       email sergey[at]tibet.ru http://fx.qrz.ru/          |
//|   ”крашательство faa1947:                                                 |
//|      добавлены полосы Ѕоллинджера                                         |
//|      раскраска                                                            |
//|      сглаживание                                                          |
//|   ¬ерси€ от 24.02.2010                                                    |
// ЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎ
#property copyright "Copyright (c) 2005, Sergey Iljukhin, Novosibirsk"
#property link      "http://fx.qrz.ru/"
// ---------------- »мпортируемые библиотеки ----------------------------------
#import  "DF.dll"
int      DigitalFilter(int      FType,
                       int      P1,
                       int      D1,
                       int      A1,
                       int      P2,
                       int      D2,
                       int      A2,
                       double   Ripple,
                       int      Delay,
                       double  &arr[]);
#import
//  -------------- »ндикатор в основном окне ----------------------------------
#property indicator_chart_window
// ----------------  ол-во видимых буферов индикатора -------------------------
#property indicator_buffers               4
// ---------------- ”становка цвета индикатора --------------------------------
#property   indicator_color1              Gold
#property   indicator_color2              Red
#property   indicator_color3              LightSeaGreen
#property   indicator_color4              LightSeaGreen
// ---------------- ”становка ширины линии -----------------------------------
#property   indicator_width1              2
#property   indicator_width2              2
#property   indicator_width3              1
#property   indicator_width4              1
//----------------- ¬нешние настройки индикатора ==========--------------------
extern   double   BandsDeviations         =  0.7;     // ¬еличина стандартного отклонени€
extern   int      BadsPeriod              =  14;      // ѕериод дл€ расчета канала Ѕоллинджера
int      BandsShift              =  0;       // —двиг относительно графика
                                             // ------------------- ¬нешние настройки фильтра ------------------------------
int      FType=0;
//                                           “ип фильтра: 
//                                              0 - ‘Ќ„ (FATL/SATL/KGLP), 
//                                              1 - ‘¬„ (KGHP), 
//                                              2 - полосовой (RBCI/KGBP), 
//                                              3 - режекторный (KGBS)
extern   int      P1          =  40;   // ѕериод отсечки
extern   int      D1          =  31;   // ѕериод отсечки переходного процесса, бар
extern   int      A1          =  50;   // «атухание в полосе задержки , дб
int      P2          =  0;    // ѕериод отсечки, бар
int      D2          =  0;    // ѕериод отсечки переходного процесса ,бар
int      A2          =  0;    // «атухание в полосе задержки, дб
double   Ripple=0.0864; // Ѕиени€ в полосе пропускани€, дб
extern   int      Delay       =  0;    // «адержка в барах
int      BarShift    =  0;    // —двиг графика, бар. ћинус - назад, плюс - вперед
extern   int      Deviation   =  0;    // —глаживает график - флэт в индикаторе        
string   _pr         =  "÷ена 0-cl,1-op,2-hi,3-lo,4-med,5-typ,6-wtd";
extern   int      _price      =  0;

// --------------- ѕрив€зка буферов -------------------------------------------
double   FilterBuffer[];
double   long1[];
double   short1[];
double   UpperBuffer[];
double   LowerBuffer[];
double   trend[];
// --------------- –абочие переменные -----------------------------------------
int      FilterOrder;
double   F[1000];
int      tf;
// ЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎ
//| Digital filter indicator initialization function                          |
// ЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎ
int init()
  {
// ------------------------ ¬ычисл€ем набор коэффициентов цифрового фильтра ---
   FilterOrder=DigitalFilter(FType,
                             P1,
                             D1,
                             A1,
                             P2,
                             D2,
                             A2,
                             Ripple,
                             Delay,
                             F);
// ---------------  ол-во буферов индикатора ----------------------------------   
   IndicatorBuffers(6);
//---------- ”становка параметров рисовани€ -----------------------------------
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,2);
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,2);

   SetIndexDrawBegin(0,FilterOrder);
   SetIndexDrawBegin(1,FilterOrder);

   SetIndexStyle(2,DRAW_LINE);
   SetIndexDrawBegin(2,FilterOrder);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexDrawBegin(3,FilterOrder+1);

// ----------------- ѕрив€зка номера индикатора к имени -----------------------
   SetIndexBuffer          (0,   long1);               // ¬идимый буфер
   SetIndexBuffer          (1,   short1);              // ¬идимый буфер

   SetIndexBuffer          (2,   UpperBuffer);        // ¬идимый буфер
   SetIndexBuffer          (3,   LowerBuffer);        // ¬идимый буфер

   SetIndexBuffer          (4,   FilterBuffer);       // –асчетный буфер
   SetIndexBuffer          (5,   trend);              // –асчетный буфер

   SetIndexEmptyValue      (0,   0.0);
   SetIndexEmptyValue      (1,   0.0);
   SetIndexEmptyValue      (2,   0.0);
   SetIndexEmptyValue      (3,   0.0);

   IndicatorShortName("FilterBands");
//------------------ ћетка дл€ линии индикатора ---------------------
   SetIndexLabel(0,"SATL-long");
   SetIndexLabel(1,"SATL_short");
   SetIndexLabel(2,"long");
   SetIndexLabel(3,"short");
//----
   tf=Period();
   return(0);
  }
// ЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎ
//| Digital filter main function                                              |
// ЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎ
int start()
  {
   static   int      prevTF=0;
   int      i,j,k;
   double   res               =  0;
   double   deviation;
   double   sum,
   oldval,
   newres;
//----
   if(Bars<=FilterOrder) return(0);
//----
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+FilterOrder+1;   
   
// --- ∆дать таймфрейм графика - принципиально ускор€ет работу индикатора -----

   i=limit;
   if(iTime(NULL,tf,1)!=prevTF)
     {
      prevTF=iTime(NULL,tf,1);
      while(i>=0)
        {
         res=0;
         for(j=0; j<FilterOrder; j++)
            res+=F[j]  *price(i+j);
         // ---------------- —глаживание, но лучше Deviation ---------------------------
         //         FilterBuffer[i]    =  (1.5  *  response             + 
         //                                1.0  *  FilterBuffer[i+1]    + 
         //                                0.5  *  FilterBuffer[i+2])   / 3;
         // --------------------- конец сглаживани€ ------------------------------------         
         FilterBuffer[i]=NormalizeDouble(res,Digits);
         if(MathAbs(FilterBuffer[i]-FilterBuffer[i+1])<
            Deviation   *Point)
            FilterBuffer[i]=FilterBuffer[i+1];
/*
// ------------------- –аскраска ----------------------------------------------
            if(FilterBuffer[i]   <=  FilterBuffer[i+1])
            {
               long[i]             =  0.0;
               short[i]             =  response;
            }
            else
            {
               long[i]             =  response;
               short[i]             =  0.0;
            }
 --------------------  онец раскраски ---------------------------------------*/
         sum               =  0.0;
         k                 =  i  +  BadsPeriod -  1;
         oldval            =  FilterBuffer[i];
         while(k>=i)
           {
            newres=price(k)-oldval;
            sum+=newres   *newres;
            k--;
           }
         deviation         =  BandsDeviations   *  MathSqrt(sum   /  BadsPeriod);
         UpperBuffer[i]    =  oldval   +  deviation;
         LowerBuffer[i]    =  oldval   -  deviation;
         i--;
        }
      // <-- раскрашиваем 
      for(int x=limit; x>=0; x--)
        {
         trend[x]=trend[x+1];
         if(FilterBuffer[x]>FilterBuffer[x+1])
            trend[x]=1;
         if(FilterBuffer[x]<FilterBuffer[x+1])
            trend[x]=-1;

         if(trend[x]>0)
           {
            long1[x]=FilterBuffer[x];
            if(trend[x+1]<0)
               long1[x+1]                  =  FilterBuffer[x+1];
            short1[x]                      =  0.0;
           }
         else
         if(trend[x]<0)
           {
            short1[x]=FilterBuffer[x];
            if(trend[x+1]>0)
               short1[x+1]              =  FilterBuffer[x+1];
            long1[x]                    =  0.0;
           }
        }
      // раскрашиваем -->
      //-------------------------------------------------------------------------
     }
   return(0);
  }
// ------------- ‘ункци€ получени€ цены по ее типу ----------------------------
double price(int i=0)
  {
   double   rrr;
   if(_price==0)
      return(iClose(Symbol(),tf,i));
   if(_price==1)
      return(iOpen(Symbol(),tf,i));
   if(_price==2)
      return(iHigh(Symbol(),tf,i));
   if(_price==3)
      return(iLow(Symbol(),tf,i));
   if(_price==4)
     {
      rrr=(iLow(Symbol(),tf,i)+
           iHigh(Symbol(),tf,i))/2;
      return(rrr);
     }
   if(_price==5)
     {
      rrr=(iLow(Symbol(),tf,i)+
           iClose(Symbol(),tf,i)+
           iHigh(Symbol(),tf,i))/3;  // “ипична€
      return(rrr);
     }
   if(_price==6)
     {
      rrr=(iLow(Symbol(),tf,i)+
           iClose(Symbol(),tf,i)+
           iClose(Symbol(),tf,i)+
           iHigh(Symbol(),tf,i))/4; // ¬звешенна€  
      return(rrr);
     }
   return(iClose(Symbol(),tf,i));
  }

// ЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎЎ

/*

  ÷ифровые фильтры дл€ MetaTrader 4.
 
  ¬нимание! ƒл€ работы требуетс€ три дополнительных DLL 
  содержащих блок математической обработки - bdsp.dll, lapack.dll, mkl_sport.dll,
  которые должны быть установлены в C:\Windows\System32\ 
  или р€дом с DF.dll в \experts\libraries\
 
  ѕеред использованием убедитесь:
  
  1. что установлены пункты "Allow DLL import" и "Confirm DLL function's call" в настройках Options->Expert Advisors
  2. „то в директории C:\Windows\System32\ имеютс€ Bdsp.dll, lapack.dll, mkl_support.dll - вспомогательные математические библиотеки. 
 
  ќписание входных параметров:
  
  Ftype - “ип фильтра: 0 - ‘Ќ„ (FATL/SATL/KGLP), 1 - ‘¬„ (KGHP), 
          2 - полосовой (RBCI/KGBP), 3 - режекторный (KGBS)
  P1 -    ѕериод отсечки P1, бар
  D1 -    ѕериод отсечки переходного процесса D1, бар
  A1 -    «атухание в полосе задержки ј1, дЅ
  P2 -    ѕериод отсечки P2, бар
  D2 -    ѕериод отсечки переходного процесса D2, бар
  A2 -    «атухание в полосе задержки ј2, дЅ
  Ripple - Ѕиени€ в полосе пропускани€, дЅ
  Delay - «адержка, бар

  ƒл€ ‘Ќ„ и ‘¬„ значени€ параметрой P2,D2,A2 игнорируютс€
  ”слови€ работы:
  ‘Ќ„: P1>D1
  ‘¬„: P1<D1
  ѕолосовой и режекторный: D2>P2>P1>D1

*/
//+------------------------------------------------------------------+
