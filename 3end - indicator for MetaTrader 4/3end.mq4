

//+------------------------------------------------------------------+
//|                                                    3perekosa.mq4 |
//+------------------------------------------------------------------+
#property copyright "Поручик & aka KimIV"
#property link      "http://www.kimiv.ru"
//----
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 Aqua
#property indicator_color2 Yellow
#property indicator_color3 Green
#property indicator_color4 Red
//------- Глобальные переменные --------------------------------------
//------- Внешние параметры индикатора -------------------------------
extern string NameCross   ="GBPCHF"; // Наименование кросса
extern string NameMain1   ="GBPUSD"; // Наименование основной пары 1
extern string NameMain2   ="USDCHF"; // Наименование основной пары 2
extern int    NumberOfBars=1000;     // Количество баров обсчёта (0-все)
extern bool   Perevorot   =false;    // Переворачивает индюка относительно горизонтальной оси.
//------- Буферы индикатора ------------------------------------------
double buf0[], buf1[], buf2[], buf3[];
double C=0,P=0,P1=0,P2=0,P3=0;
 
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
  void init()
  {
   SetIndexBuffer(0, buf0);
   SetIndexLabel (0, "P");
   SetIndexStyle (0, DRAW_LINE, STYLE_SOLID, 1);
   SetIndexEmptyValue(0, 0);
   SetIndexBuffer(1, buf1);
   SetIndexLabel (1, Symbol());
   SetIndexStyle (1, DRAW_LINE, STYLE_DOT, 1);
   SetIndexEmptyValue(1, 0);
   SetIndexBuffer(2, buf2);
   SetIndexLabel (2, "DOTS");
   SetIndexStyle (2, DRAW_ARROW, 1,3);
   SetIndexArrow (2,164);
   SetIndexEmptyValue(1, 0);
   SetIndexBuffer(3, buf3);
   SetIndexLabel (3, "DOTS");
   SetIndexStyle (3, DRAW_ARROW, 1,3);
   SetIndexArrow (3,164);
   SetIndexEmptyValue(1, 0);
  }
 
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
  void deinit()
  {
   Comment("");
  }
 
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
  void start()
  {
   int LoopBegin, sh;
   if (NumberOfBars==0) LoopBegin=Bars-1;
   else LoopBegin=NumberOfBars-1;
   int barscross=iBars(NameCross,0);
   int barsmain2=iBars(NameMain2,0);
   int barsmain1=iBars(NameMain1,0);
   int limit=MathMin(MathMin(barsmain1,barsmain2),barscross);
   LoopBegin=MathMin(Bars-1, LoopBegin);
   LoopBegin=MathMin(limit,LoopBegin);
   for(sh=LoopBegin; sh>=0; sh--)
     {
      P1=(iClose(NameMain1, 0, sh)*iClose(NameMain2, 0, sh)-iClose(NameCross, 0, sh))*3;
      P2=(iClose(NameMain1, 0, sh)-iClose(NameCross, 0, sh)/iClose(NameMain2, 0, sh))*3;
      P3=(iClose(NameMain2, 0, sh)-iClose(NameCross, 0, sh)/iClose(NameMain1, 0, sh))*3;
        if (Perevorot) {P1=P1*(-1);P2=P2*(-1);P3=P3*(-1);
     }
      C=iClose(Symbol(), 0, sh);
      P1=P1+C;
      P2=P2+C;
      P3=P3+C;
      P=(P1+P2+P3)/3;
      //    Comment(P," ",P1," ",P2," ",P3);
      buf0[sh]=P;
      buf1[sh]=C;
      if (P>C) buf2[sh]=C;
      if (P<C) buf3[sh]=C;
     }
  }
//+------------------------------------------------------------------+

