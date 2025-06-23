//+--------------------------------------------------------------------------------+
//|                                                                     ang_Amp_ZZ |
//|                                                                StreamAmpZZ.mq4 |
//|                                                      Copyright © 2005, ANG3110 |
//|                                                           ANG3110@latchess.com |
//|                                                      маленька€ доработка Titan |
//+--------------------------------------------------------------------------------+
#property copyright "Copyright © 2005, ANG3110"
#property link      "ANG3110@latchess.com"
//----
#property indicator_chart_window
#property indicator_buffers 7
#property indicator_color1  CornflowerBlue
#property indicator_color2  Orange
#property indicator_color3  Orange
#property indicator_color4  SteelBlue
#property indicator_color5  SteelBlue
#property indicator_color6  MediumSeaGreen
#property indicator_color7  Red
//---- input parameters
extern double Depth    =12.5;
extern int    Smooth   =6;
extern int    сntBars  =600;
//---- ¬кл/выкл
extern bool   Sound    =false;
//---- buffers
double zz[], ha[], la[], hs[], ls[], hx[], lx[];
double tmp_ha[], tmp_la[];
//---- parameters
double hi, li, hm, lm;
int    f=0, f1, f0, ai, bi, aibar, bibar;
int    wait=0; //шоб не трезвонила на текущей свече
//+--------------------------------------------------------------------------------+
//| Custom indicator initialization function                                       |
//+--------------------------------------------------------------------------------+
int init()
  {
   Depth*=Point;
//---- ”станавливаем новый размер массивов
   ArrayResize(tmp_ha, сntBars);
   ArrayResize(tmp_la, сntBars);
//---- ”становка формата точности дл€ визуализации индикатора
   IndicatorDigits(4);
//---- 7 additional buffers are used for counting.
   IndicatorBuffers(7);
//---- indicator buffers
   SetIndexBuffer(0, zz);
   SetIndexBuffer(1, ha);
   SetIndexBuffer(2, la);
   SetIndexBuffer(3, hs);
   SetIndexBuffer(4, ls);
   SetIndexBuffer(5, hx);
   SetIndexBuffer(6, lx);
//---- indicator lines
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 2);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexStyle(2, DRAW_LINE);
   SetIndexStyle(3, DRAW_LINE, STYLE_DOT);
   SetIndexStyle(4, DRAW_LINE, STYLE_DOT);
   SetIndexStyle(5, DRAW_ARROW, 0, 2);
   SetIndexStyle(6, DRAW_ARROW, 0, 2);
//----
   SetIndexEmptyValue(5, EMPTY_VALUE);
   SetIndexEmptyValue(6, EMPTY_VALUE);
//----
   SetIndexArrow(5, 251);
   SetIndexArrow(6, 251);
   // Wingdings symbols:
   // ------------------
   // 4   - черточка
   // 119 - ромбик
   // 158 - точка
   // 159 - жирна€ точка
   // 167 - квадратик
   // 169 - звезда триугольна€
   // 170 - плюс
   // 251 - крестик
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("StreamAmpZZ");
   SetIndexLabel(0, "ZZ");
   SetIndexLabel(1, "HA");
   SetIndexLabel(2, "LA");
   SetIndexLabel(3, "ZZHA");
   SetIndexLabel(4, "ZZLA");
   SetIndexLabel(5, "Upper");
   SetIndexLabel(6, "Lower");
//----
   int draw=Bars - сntBars;
   SetIndexDrawBegin(0, draw);
   SetIndexDrawBegin(1, draw + Smooth);
   SetIndexDrawBegin(2, draw + Smooth);
   SetIndexDrawBegin(3, draw);
   SetIndexDrawBegin(4, draw);
   SetIndexDrawBegin(5, draw);
   SetIndexDrawBegin(6, draw);
//----
   return(0);
  }
//+--------------------------------------------------------------------------------+
//| StreamAmpZZ                                                                    |
//+--------------------------------------------------------------------------------+
int start()
  {
   double cum, sum;
   int bars =Bars - IndicatorCounted(), i, j;
   if (bars > 1) bars=сntBars; //перерисовка по всем сntBars при каждом новом баре
//----
   for(i=bars-1; i>=0; i--)
     {
      if (i>=сntBars) {hi=High[i]; li=Low[i];}
      if (Low [i] > hi) {hi=Low [i]; if (hi>=li+Depth) li=hi - Depth;}
      if (High[i] < li) {li=High[i]; if (li<=hi-Depth) hi=li + Depth;}
      //----
      if (High[i] > hi && Low[i] < li) if (High[i]-hi > li-Low[i]) f1=1; else f1=2; else f1=0;
      //----
      if (f==0)
        {
         if (High[i] > hi) {hm=High[i]; ai=i; f=1;}
         if (Low [i] < li) {lm=Low [i]; bi=i; f=2;}
        }
      //----
      if (f1!=2)
        {
         if (f==2 && High[i] > hi)
           {
            hm=High[i]; f=1; f0=0;
            if (ai!=bi) for(j=ai; j>=bi; j--) zz[j]=High[ai]*(j - bi)/(ai - bi) + Low[bi]*(j - ai)/(bi - ai);
            ai=i;
           }
         if (f==1 && High[i] > hm) {hm=High[i]; ai=i; f0=0;}
        }
      //----
      if (f1!=1)
        {
         if (f==1 && Low[i] < li)
           {
            lm=Low[i]; f=2; f0=0;
            if (ai!=bi) for(j=bi; j>=ai; j--) zz[j]=High[ai]*(j - bi)/(ai - bi) + Low[bi]*(j - ai)/(bi - ai);
            bi=i;
           }
         if (f==2 && Low[i] < lm) {lm=Low[i]; bi=i; f0=0;}
        }
      //----
      if (f0==0 && i==0) {aibar=Bars - ai; bibar=Bars - bi; f0=1;}
      if (f0==1) {ai=Bars - aibar; bi=Bars - bibar;}
      //----
      if (i==0)
        {
         if (ai > bi) for(j=ai; j>=bi; j--) zz[j]=High[ai]*(j - bi)/(ai - bi) + Low[bi]*(j - ai)/(bi - ai);
         if (ai < bi) for(j=bi; j>=ai; j--) zz[j]=High[ai]*(j - bi)/(ai - bi) + Low[bi]*(j - ai)/(bi - ai);
         //----
         if (f ==1 && ai!=0) for(j=ai; j>=0; j--) zz[j]=Close[0]*(j - ai)/(0 - ai) + High[ai]*(j - 0)/(ai - 0);
         if (f ==2 && bi!=0) for(j=bi; j>=0; j--) zz[j]=Close[0]*(j - bi)/(0 - bi) + Low [bi]*(j - 0)/(bi - 0);
         if (bi==0 && ai!=0) for(j=ai; j>=0; j--) zz[j]=Low  [0]*(j - ai)/(0 - ai) + High[ai]*(j - 0)/(ai - 0);
         if (ai==0 && bi!=0) for(j=bi; j>=0; j--) zz[j]=High [0]*(j - bi)/(0 - bi) + Low [bi]*(j - 0)/(bi - 0);
        }
      //----
      tmp_ha[i]=hi;
      tmp_la[i]=li;
      //—глаживание (замедление)
      if (i<=сntBars-Smooth && Smooth > 1)
        {
         for(j=i, cum=0, sum=0; j<i+Smooth; j++) {cum+=tmp_ha[j]; sum+=tmp_la[j];}
         ha[i]=cum/Smooth;
         la[i]=sum/Smooth;
        }
      else {ha[i]=tmp_ha[i]; la[i]=tmp_la[i];}
     }
//---- —редн€€ между zz и ha/la
   for(i=bars-1; i>=0; i--)
     {
      hs[i]=(zz[i] + ha[i])/2;
      ls[i]=(zz[i] + la[i])/2;
     }
//---- Ёкстремумы
   if (bars>=Bars) bars=сntBars - 1;
   for(i=bars; i>0; i--)
     {
      hx[i]=EMPTY_VALUE;
      lx[i]=EMPTY_VALUE;
//----
      if (zz[i-1] < zz[i] && zz[i] > zz[i+1]) {hx[i]=zz[i]; if (wait!=Time[0] && i==1 && Sound) {PlaySound("alert.wav");  wait=Time[0];}}
      if (zz[i-1] > zz[i] && zz[i] < zz[i+1]) {lx[i]=zz[i]; if (wait!=Time[0] && i==1 && Sound) {PlaySound("alert2.wav"); wait=Time[0];}}
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+