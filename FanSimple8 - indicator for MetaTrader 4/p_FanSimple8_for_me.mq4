//+------------------------------------------------------------------+
//|                                                                  |
//|                 Copyright © 2000-2007, MetaQuotes Software Corp. |
//|                                         http://www.metaquotes.ru |
//+------------------------------------------------------------------+
#include <stdlib.mqh>
//----
#property indicator_chart_window
#property indicator_buffers 8
/* Здесь можно исправить значения, эти значения используются по умолчанию при подключении индикатора */
/* Цвета набора средних (встав курсором на имени цвета, нажать F1 и увидеть имена остальных цветов) */
#property indicator_color1 Gold
#property indicator_color2 Blue
#property indicator_color3 PaleTurquoise
#property indicator_color4 DodgerBlue
#property indicator_color5 Aqua
#property indicator_color6 Magenta
#property indicator_color7 Gray
#property indicator_color8 White
/* Общий рубильник отображения правильности веера, позволяет отрубить разом отображение набора всех периодов */
extern bool DisplayFanStatus=false;
/* Общий рубильник отображения средних, позволяет отрубить разом отображение набора средних */
extern bool DisplayFan=true;
/* Значения периодов набора timeframe'ов в порядке следования слева направо (возможны повторения, 0-вые и неправильные значения включены в набор не будут) */
extern int Timeframe1=PERIOD_M1;
extern int Timeframe2=PERIOD_M5;
extern int Timeframe3=PERIOD_M15;
extern int Timeframe4=PERIOD_H1;
extern int Timeframe5=PERIOD_H4;
extern int Timeframe6=PERIOD_D1;
extern int Timeframe7=PERIOD_W1;
extern int Timeframe8=0;
extern int Timeframe9=0;
/* Дата и время, для которого индицируется правильность веера */
extern datetime TrackingTime=0;
/* Рисовать ли вертикальную линию через отслеживаемый бар */
extern bool Tracking=false;
/* Сдвигаем ли точку слежения с образовнием следущего бара */
extern bool Sliding=true;
/* Имя файла звука, воспроизводимого при сдвиге точки слежения */
extern string SlidingSound="";
/* Значения периодов набора средних, составляющих веер, правильность которого отслеживается (0-вые и неправильные значения включены в набор не будут) */
extern int MA1=55;
extern int MA2=21;
extern int MA3=5;
extern int MA4=0;
extern int MA5=0;
extern int MA6=0;
extern int MA7=0;
extern int MA8=0;
/* Индивидуальный рубильник отображения на каждую среднюю */
extern bool DisplayMA1=true;
extern bool DisplayMA2=true;
extern bool DisplayMA3=true;
extern bool DisplayMA4=true;
extern bool DisplayMA5=true;
extern bool DisplayMA6=true;
extern bool DisplayMA7=true;
extern bool DisplayMA8=true;
/* Имя фонта символов */
extern string FontName="Wingdings";
/* Размер символов */
extern int FontSize=12;
/* Символы нарисованного и стёртого указателя положения цены относительно веера */
extern int PriceOnSymbol=108; // Circle
extern int PriceOffSymbol=32; // Space
/* Цвета нарисованного указателя положения цены относительно веера */
extern color PriceColor=LimeGreen;
/* Символы указателя правильности веера */
extern int FanWrongSymbol=117; // Diamond
extern int FanUpSymbol=233; // Up Arrow
extern int FanDownSymbol=234; // Down Arrow
/* Цвета указателя правильности веера */
extern color FanWrongColor=DarkGray;
extern color FanUpColor=DodgerBlue;
extern color FanDownColor=OrangeRed;
/* Смещение влево (X) и вправо (Y) от правого верхнего угла */
extern int X=0;
extern int Y=0;
// Tracking vertical line label and color
#define TRACKING_NAME "Бар, отслеживаемый индикатором FanSimple"
#define TRACKING_COLOR DarkGray
//----
string RowName[3]={ "Цена выше веера",
                      "Статус веера",
   "Цена ниже веера" };
// Type of rendering codes
#define is_down    0
#define is_none    1
#define is_up      2
//----
int Timeframe[9];
string TimeframeNames[9];
int TimeframeInUse=0;
//----
int MAs[8];
int Xlat[8];
int MAsInUse=0;
//----
double MA1Buf[], MA2Buf[], MA3Buf[], MA4Buf[], MA5Buf[], MA6Buf[], MA7Buf[], MA8Buf[];

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string LabelName(int i, int j) { return(RowName[j] + "(" + (string)(i + 1) + "): " + TimeframeNames[i]); }
//----
int symcolor[3][2];
int syms[3][2];

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UpdateFanStatus(int i, int how)
  {
   string s=" ";
   ObjectSetText(LabelName(i, 1), StringSetChar(s, 0, symcolor[how][0]), FontSize, FontName, symcolor[how][1]);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UpdatePriceStatus(int i, int how)
  {
   string s=" ";
   ObjectSetText(LabelName(i, 0), StringSetChar(s, 0, syms[how][0]), FontSize, FontName, PriceColor);
   ObjectSetText(LabelName(i, 2), StringSetChar(s, 0, syms[how][1]), FontSize, FontName, PriceColor);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void InitTimeframe(int &P[], int PV)
  {
   if(PV!=0)
     {
      switch(PV)
        {
         case PERIOD_M1:  TimeframeNames[TimeframeInUse]="M1";  break;
         case PERIOD_M5:  TimeframeNames[TimeframeInUse]="M5";  break;
         case PERIOD_M15: TimeframeNames[TimeframeInUse]="M15"; break;
         case PERIOD_M30: TimeframeNames[TimeframeInUse]="M30"; break;
         case PERIOD_H1:  TimeframeNames[TimeframeInUse]="H1";  break;
         case PERIOD_H4:  TimeframeNames[TimeframeInUse]="H4";  break;
         case PERIOD_D1:  TimeframeNames[TimeframeInUse]="D1";  break;
         case PERIOD_W1:  TimeframeNames[TimeframeInUse]="W1";  break;
         case PERIOD_MN1: TimeframeNames[TimeframeInUse]="MN1"; break;
         default: return;
        }
      P[TimeframeInUse]=PV; TimeframeInUse++;
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void InitMAs(int &P[], int MA) { if(MA > 0) { P[MAsInUse]=MA; MAsInUse++; } }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   int i, j;
   if(DisplayFanStatus)
     {
      syms[0][0]=PriceOffSymbol; syms[0][1]=PriceOnSymbol;
      syms[1][0]=PriceOffSymbol; syms[1][1]=PriceOffSymbol;
      syms[2][0]=PriceOnSymbol; syms[2][1]=PriceOffSymbol;
      InitTimeframe(Timeframe, Timeframe1); InitTimeframe(Timeframe, Timeframe2); InitTimeframe(Timeframe, Timeframe3); InitTimeframe(Timeframe, Timeframe4);
      InitTimeframe(Timeframe, Timeframe5); InitTimeframe(Timeframe, Timeframe6); InitTimeframe(Timeframe, Timeframe7); InitTimeframe(Timeframe, Timeframe8);
      InitTimeframe(Timeframe, Timeframe9);
      InitMAs(MAs, MA1); InitMAs(MAs, MA2); InitMAs(MAs, MA3); InitMAs(MAs, MA4);
      InitMAs(MAs, MA5); InitMAs(MAs, MA6); InitMAs(MAs, MA7); InitMAs(MAs, MA8);
      for(i=0; i < MAsInUse; i++) Xlat[i]=i;
      for(i=0; i < MAsInUse - 1; i++)
         for(j=i + 1; j < MAsInUse; j++)
            if(MAs[Xlat[i]] > MAs[Xlat[j]]) { int k=Xlat[j]; Xlat[j]=Xlat[i]; Xlat[i]=k; }
      for(i=0; i < TimeframeInUse; i++)
         for(j=0; j < 3; j++)
           {
            string s=LabelName(i, j);
            //----
            ObjectCreate(s, OBJ_LABEL, 0, 0, 0);
            ObjectSet(s, OBJPROP_XDISTANCE, (TimeframeInUse - i - 1) * 13 * FontSize/10 + 2 * FontSize/10 + X);
            ObjectSet(s, OBJPROP_YDISTANCE, j * 16 * FontSize/10 + 3 * FontSize/10 + Y);
            ObjectSet(s, OBJPROP_BACK, true);
            ObjectSet(s, OBJPROP_CORNER, 1);
            ObjectSetText(s, " ", FontSize, FontName, Black);
           }
      //----
      if(Tracking)
        {
         ObjectCreate(TRACKING_NAME, OBJ_VLINE, 0, TrackingTime, 0);
         ObjectSet(TRACKING_NAME, OBJPROP_COLOR, TRACKING_COLOR);
        }
     }
//----
   if(DisplayFan)
     {
      string IndicatorName="FanSimple(";
      symcolor[0][0]=FanDownSymbol; symcolor[0][1]=FanDownColor;
      symcolor[1][0]=FanWrongSymbol; symcolor[1][1]=FanWrongColor;
      symcolor[2][0]=FanUpSymbol; symcolor[2][1]=FanUpColor;
      //----
      if(DisplayMA1 && MA1 > 0) IndicatorName=IndicatorName + (string)MA1; if(DisplayMA2 && MA2 > 0) IndicatorName=IndicatorName + ", " + (string)MA2;
      if(DisplayMA3 && MA3 > 0) IndicatorName=IndicatorName + ", " + (string)MA3; if(DisplayMA4 && MA4 > 0) IndicatorName=IndicatorName + ", " + (string)MA4;
      if(DisplayMA5 && MA5 > 0) IndicatorName=IndicatorName + ", " + (string)MA5; if(DisplayMA6 && MA6 > 0) IndicatorName=IndicatorName + ", " + (string)MA6;
      if(DisplayMA7 && MA7 > 0) IndicatorName=IndicatorName + ", " + (string)MA7; if(DisplayMA8 && MA8 > 0) IndicatorName=IndicatorName + ", " + (string)MA8;
      IndicatorShortName(IndicatorName + ")");
      IndicatorBuffers(8);
      SetIndexBuffer(0, MA1Buf); SetIndexBuffer(1, MA2Buf); SetIndexBuffer(2, MA3Buf); SetIndexBuffer(3, MA4Buf);
      SetIndexBuffer(4, MA5Buf); SetIndexBuffer(5, MA6Buf); SetIndexBuffer(6, MA7Buf); SetIndexBuffer(7, MA8Buf);
      SetIndexLabel(0, "Веер, " + (string)MA1 + "-я средняя"); SetIndexLabel(1, "Веер, " + (string)MA2 + "-я средняя");
      SetIndexLabel(2, "Веер, " + (string)MA3 + "-я средняя"); SetIndexLabel(3, "Веер, " + (string)MA4 + "-я средняя");
      SetIndexLabel(4, "Веер, " + (string)MA5 + "-я средняя"); SetIndexLabel(5, "Веер, " + (string)MA6 + "-я средняя");
      SetIndexLabel(6, "Веер, " + (string)MA7 + "-я средняя"); SetIndexLabel(7, "Веер, " + (string)MA8 + "-я средняя");
      //----
      for(i=0; i < 7; i++)
        {
         SetIndexStyle(i, DRAW_LINE, EMPTY, 1);
         SetIndexEmptyValue(i, 0);
        }
      //----
      ArraySetAsSeries(MA1Buf, true); ArraySetAsSeries(MA2Buf, true); ArraySetAsSeries(MA3Buf, true); ArraySetAsSeries(MA4Buf, true);
      ArraySetAsSeries(MA5Buf, true); ArraySetAsSeries(MA6Buf, true); ArraySetAsSeries(MA7Buf, true); ArraySetAsSeries(MA8Buf, true);
      for(i=Bars - 1; i>=0; i--)
        {
         MA1Buf[i]=0; MA2Buf[i]=0; MA3Buf[i]=0; MA4Buf[i]=0; MA5Buf[i]=0; MA6Buf[i]=0; MA7Buf[i]=0; MA8Buf[i]=0;
        }
     }
   return(0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   for(int i=0; i < TimeframeInUse; i++)
      for(int j=0; j < 3; j++)
         ObjectDelete(LabelName(i, j));
//----
   if(Tracking)
      ObjectDelete(TRACKING_NAME);
   return(0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int i;
   datetime NewTrackingTime=TrackingTime;
   static datetime time=0;
//----
   if(time==0)
     {
      if(TrackingTime==0)
         TrackingTime=Time[0];
      i=((TimeDay(TrackingTime) * 24 + TimeHour(TrackingTime)) * 60 + TimeMinute(TrackingTime)) * 60 + TimeSeconds(TrackingTime);
      TrackingTime-=i;
      i/=60;
      i-=i%Period();
      TrackingTime+=i * 60;
      if(Tracking)
         ObjectSet(TRACKING_NAME, OBJPROP_TIME1, TrackingTime);
      else
         NewTrackingTime=TrackingTime;
     }
//-----
   if(Tracking)
      NewTrackingTime=ObjectGet(TRACKING_NAME, OBJPROP_TIME1);
  /* Пользователь сдвинул точку слежения или точка слежения - последний бар или появился новый бар */
   if(NewTrackingTime!=TrackingTime || (CurTime() - TrackingTime)/60  < Period() || time!=Time[0])
     {
      if(DisplayFanStatus)
         for(i=0; i < TimeframeInUse; i++)
           {
            bool Up=true, Down=true;
            bool PriceUp=true, PriceDown=true;
            int LocalShift=iBarShift(Symbol(), Timeframe[i], NewTrackingTime + (Period() - 1) * 60);
            double PrevMA=0;
            //----
            for(int j=0; j < MAsInUse; j++)
              {
               double MA=iMA(Symbol(), Timeframe[i], MAs[Xlat[j]], 0, MODE_EMA, PRICE_CLOSE, LocalShift);
               if(j > 0) { if(Up && PrevMA < MA) Up=false; if(Down && PrevMA > MA) Down=false; }
               if(PriceUp && MA > iClose(Symbol(), Timeframe[i], LocalShift)) PriceUp=false;
               if(PriceDown && MA < iClose(Symbol(), Timeframe[i], LocalShift)) PriceDown=false;
               PrevMA=MA;
              }
            //----
            if(Up) UpdateFanStatus(i, is_up); else if(Down) UpdateFanStatus(i, is_down); else UpdateFanStatus(i, is_none);
            if(PriceUp) UpdatePriceStatus(i, is_up); else if(PriceDown) UpdatePriceStatus(i, is_down); else UpdatePriceStatus(i, is_none);
           }
      if(DisplayFan)
         for(i=Bars - IndicatorCounted() - 1; i>=0; i--)
           {
            if(DisplayMA1 && MA1 > 0) MA1Buf[i]=iMA(Symbol(), 0, MA1, 0, MODE_SMMA, PRICE_TYPICAL, i);
            if(DisplayMA2 && MA2 > 0) MA2Buf[i]=iMA(Symbol(), 0, MA2, 0, MODE_SMMA, PRICE_TYPICAL, i);
            if(DisplayMA3 && MA3 > 0) MA3Buf[i]=iMA(Symbol(), 0, MA3, 0, MODE_SMMA, PRICE_TYPICAL, i);
            if(DisplayMA4 && MA4 > 0) MA4Buf[i]=iMA(Symbol(), 0, MA4, 0, MODE_EMA, PRICE_CLOSE, i);
            if(DisplayMA5 && MA5 > 0) MA5Buf[i]=iMA(Symbol(), 0, MA5, 0, MODE_EMA, PRICE_CLOSE, i);
            if(DisplayMA6 && MA6 > 0) MA6Buf[i]=iMA(Symbol(), 0, MA6, 0, MODE_EMA, PRICE_CLOSE, i);
            if(DisplayMA7 && MA7 > 0) MA7Buf[i]=iMA(Symbol(), 0, MA7, 0, MODE_EMA, PRICE_CLOSE, i);
            if(DisplayMA8 && MA8 > 0) MA8Buf[i]=iMA(Symbol(), 0, MA8, 0, MODE_EMA, PRICE_CLOSE, i);
           }
      //----
      if(time!=Time[0])
        {
         if(Sliding && time!=0)
            NewTrackingTime+=Time[0] - time;
         time=Time[0];
        }
      if(Tracking && NewTrackingTime!=TrackingTime)
         ObjectSet(TRACKING_NAME, OBJPROP_TIME1, NewTrackingTime);
      if(StringLen(SlidingSound)!=0 && NewTrackingTime!=TrackingTime)
         PlaySound(SlidingSound);
      TrackingTime=NewTrackingTime;
     }
   return(0);
  }
//+------------------------------------------------------------------+