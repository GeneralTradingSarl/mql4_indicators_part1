//+------------------------------------------------------------------+
//|                                                   DT-RSI-Sig.mq4 |
//+------------------------------------------------------------------+
#property copyright "klot"
#property link      "klot@mail.ru"
//----
#property indicator_separate_window
#property indicator_minimum 20
#property indicator_maximum 80
#property indicator_buffers 5
#property indicator_color1 Aqua
#property indicator_color2 Red
#property indicator_color3 Blue
#property indicator_color4 Red
#property indicator_color5 Blue
//---- input parameters
extern int       PeriodRSI=14;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,242);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexEmptyValue(1,0.0);
   SetIndexStyle(2,DRAW_ARROW);
   SetIndexArrow(2,241);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexEmptyValue(2,0.0);
   SetIndexStyle(3,DRAW_ARROW);
   SetIndexArrow(3,159);
   SetIndexBuffer(3,ExtMapBuffer4);
   SetIndexEmptyValue(3,0.0);
   SetIndexStyle(4,DRAW_ARROW);
   SetIndexArrow(4,159);
   SetIndexBuffer(4,ExtMapBuffer5);
   SetIndexEmptyValue(4,0.0);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- 
   ObjectsDeleteAll(1, OBJ_TREND);
   ObjectsRedraw();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    k,limit,pos1,pos2,pos3,pos4;
   int    counted_bars=IndicatorCounted();
   double rsi1,rsi2,rsi3,vol1,vol2,vol3,vol4;
//---- 
   if (counted_bars<0) return(-1);
   if (counted_bars>0) counted_bars--;
//----
   limit=Bars-counted_bars;
//----
   for(int i=0; i<limit; i++)
     {
      ExtMapBuffer1[i]=iRSI(NULL,0,PeriodRSI,PRICE_CLOSE,i);
//----
      rsi1=iRSI(NULL,0,PeriodRSI,PRICE_CLOSE,i+1);
      rsi2=iRSI(NULL,0,PeriodRSI,PRICE_CLOSE,i+2);
      rsi3=iRSI(NULL,0,PeriodRSI,PRICE_CLOSE,i+3);
//----
      if  (rsi1<rsi2 && rsi2>rsi3) ExtMapBuffer5[i+2]=rsi2; //Верхушка. RSI поворачивает вниз
      if  (rsi1>rsi2 && rsi2<rsi3) ExtMapBuffer4[i+2]=rsi2; //Донышко. RSI поворачивает вверх
     }
//------ Поиск верхушек ------
   k=0;
   for(i=0; i<500; i++)
     {
      if (ExtMapBuffer5[i]>40 && k==0) { vol1=ExtMapBuffer5[i]; pos1=i; k++;}
      if (ExtMapBuffer5[i]>60 && ExtMapBuffer5[i]>vol1 && k!=0) { vol2=ExtMapBuffer5[i]; pos2=i; k++;}
      if (k>1) break;
     }
   // Если есть минимум ниже 40, то линию тренда не строим, т.к. считаем что направление тренда изменилось
   for(i=0; i<pos2; i++)
     {
      if(ExtMapBuffer4[i]!=0 && ExtMapBuffer4[i]<40) {vol1=0; vol2=0;}
     }
//----- Поиск донышек ------
   k=0;
   for(i=0; i<500; i++)
     {
      if (ExtMapBuffer4[i]<60 && ExtMapBuffer4[i]!=0 && k==0) { vol3=ExtMapBuffer4[i]; pos3=i; k++;}
      if (ExtMapBuffer4[i]!=0 && ExtMapBuffer4[i]<40 && ExtMapBuffer4[i]<vol3 && k!=0) { vol4=ExtMapBuffer4[i]; pos4=i; k++;}
      if (k>1) break;
     }
   // Если есть максимум больше 60, тогда линию тренда не строим, т.к. считаем что направление тренда изменилось
   for(i=0; i<pos4; i++)
     {
      if(ExtMapBuffer5[i]!=0 && ExtMapBuffer5[i]>60) {vol3=0; vol4=0;}
     }
   // ---- Сигналы для входов Buy и Sell
   rsi1=iRSI(NULL,0,PeriodRSI,PRICE_CLOSE,1);
   rsi2=iRSI(NULL,0,PeriodRSI,PRICE_CLOSE,2);
//------------
   double volDW,volDW1,volDW2,volUP,volUP1,volUP2;
   if (vol3!=0 && vol4!=0)
     {
      volDW=vol3+((pos3)*(vol3-vol4)/(pos4-pos3));
      volDW1=vol3+((pos3-1)*(vol3-vol4)/(pos4-pos3));
      volDW2=vol3+((pos3-2)*(vol3-vol4)/(pos4-pos3));
     }
   if (volDW!=0 && rsi2>50 && rsi1<volDW1 && rsi2>volDW2)ExtMapBuffer2[0]=volDW; // Сигнал Sell
//------------
//------------
   if (vol1!=0 && vol2!=0)
     {
      volUP=vol1+(pos1*(vol1-vol2)/(pos2-pos1));
      volUP1=vol1+((pos1-1)*(vol1-vol2)/(pos2-pos1));
      volUP2=vol1+((pos1-2)*(vol1-vol2)/(pos2-pos1));
     }
   if (volUP!=0 && rsi2<50 && rsi2>40 && rsi1>volUP1 && rsi2<volUP2)ExtMapBuffer3[0]=volUP; // Сигнал Buy
//------------
   ObjectsDeleteAll(1, OBJ_TREND);
   ObjectsRedraw();
   if (vol3!=0 && vol4!=0 )
     {
      ObjectCreate("Sell",OBJ_TREND,1,Time[pos4],vol4,Time[pos3],vol3);
      ObjectSet("Sell",OBJPROP_COLOR,Red);
      ObjectSet("Sell",OBJPROP_WIDTH,2);
      ObjectSet("Sell",OBJPROP_STYLE,STYLE_SOLID);
     }
   if (vol1!=0 && vol2!=0)
     {
      ObjectCreate("Buy",OBJ_TREND,1,Time[pos2],vol2,Time[pos1],vol1);
      ObjectSet("Buy",OBJPROP_COLOR,Blue);
      ObjectSet("Buy",OBJPROP_WIDTH,2);
      ObjectSet("Buy",OBJPROP_STYLE,STYLE_SOLID);
     }

//----
   return(0);
  }
//+------------------------------------------------------------------+