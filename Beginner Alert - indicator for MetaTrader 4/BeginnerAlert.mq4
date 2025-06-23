//+------------------------------------------------------------------+
//|                                                     Beginner.mq4 |
//|                                                 Copyright © 2007 |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, Heaven"
#property link      "http://Beginner.com"
//----
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red
#define  SH_BUY   1
#define  SH_SELL  -1
//---- Входные параметры
extern bool SoundON=true;
extern int     AllBars=0;//Для скольки баров считать. 0 - для всех.
extern int     Otstup=30;//Отступ.
extern double  Per=9;//Период.
//----
int            SH,NB,i,UD;
double         R,SHMax,SHMin;
double         BufD[];
double         BufU[];
int flagval1=0;
int flagval2=0;
//+------------------------------------------------------------------+
//| Функция инициализации                                            |
//+------------------------------------------------------------------+
int init()
  {
   //В NB записываем количество баров для которых считаем индикатор
   if (Bars<AllBars+Per || AllBars==0) NB=Bars-Per; else NB=AllBars;
   IndicatorBuffers(2);
   IndicatorShortName("SHI_SilverTrendSig");
   SetIndexStyle(0,DRAW_ARROW,0,1);
   SetIndexStyle(1,DRAW_ARROW,0,1);
   SetIndexArrow(0,159);
   SetIndexArrow(1,159);
   SetIndexBuffer(0,BufU);
   SetIndexBuffer(1,BufD);
   SetIndexDrawBegin(0,Bars-NB);//Индикатор будетотображаться только для NB баров
   SetIndexDrawBegin(1,Bars-NB);
   ArrayInitialize(BufD,0.0);//Забьём оба буфера ноликами. Иначе будет мусор при смене таймфрейма.
   ArrayInitialize(BufU,0.0);
   return(0);
  }
//+------------------------------------------------------------------+
//| Функция деинициализации                                          |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//| Собсна индикатор                                                 |
//+------------------------------------------------------------------+
int start()
  {
   int CB=IndicatorCounted();
   /* Тут вот та самая оптимизационная фишка. В язык введена функция, которая возвращает количество
   посчитанных баров, причём очень хитро. При первом вызове индикатора это 0, всё понятно, ещё ничего
   не считалось, а затем выдаёт количество обсчитанных баров минус один. Т.е. если всего баров 100,
   то функция вернёт 99. Я ввёл такой код, выше у меня определялась NB - кол-во баров подлежащих
   обсчёту. В принципе этот параметр можно и выкинуть, однако для тех кто в танке (I80286) можно
   и оставить. Так вот, здесь, при первом вызове NB остаётся прежней, а при последующих уменьшается
   до последнего бара, т.е. 1 или 2, ну или сколько там осталось посчитать*/
   if(CB<0) return(-1); else if(NB>Bars-CB) NB=Bars-CB;
   for(SH=1;SH<NB;SH++)//Прочёсываем график от 1 до NB
     {
      for(R=0,i=SH;i<SH+10;i++) {R+=(10+SH-i)*(High[i]-Low[i]);}      R/=55;
//----
      SHMax=High[Highest(NULL,0,MODE_HIGH,Per,SH)];
      SHMin=Low[Lowest(NULL,0,MODE_LOW,Per,SH)];
      if (Close[SH]<SHMin+(SHMax-SHMin)*Otstup/100 && UD!=SH_SELL)
        {
         // Pop an Alert
         if (SH==1 && flagval1==0)
           {
            flagval1=1;
            flagval2=0;
            if (SoundON) Alert("BUY signal at Ask=",Ask,"\n Bid=",Bid,"\n Time=",TimeToStr(CurTime(),TIME_DATE)," ",TimeHour(CurTime()),":",TimeMinute(CurTime()),"\n Symbol=",Symbol()," Period=",Period());
           }
         BufU[SH]=Low[SH]-R*0.5; UD=SH_SELL;
        }
      if (Close[SH]>SHMax-(SHMax-SHMin)*Otstup/100 && UD!=SH_BUY)
        {
         // pop an Alert
         if (SH==1 && flagval2==0)
           {
            flagval2=1;
            flagval1=0;
            if (SoundON) Alert("SELL signal at Ask=",Ask,"\n Bid=",Bid,"\n Date=",TimeToStr(CurTime(),TIME_DATE)," ",TimeHour(CurTime()),":",TimeMinute(CurTime()),"\n Symbol=",Symbol()," Period=",Period());
           }
         BufD[SH]=High[SH]+R*0.5; UD=SH_BUY;
        }
     }
   return(0);
  }
//+------------------------------------------------------------------+