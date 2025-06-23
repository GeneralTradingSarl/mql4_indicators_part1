//+------------------------------------------------------------------+
//|  Андрей Опейда                                 Комментатор       |
//+------------------------------------------------------------------+
#property copyright "Опейда Андрей"
#property link      "itrytobenotlinked"
//----
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorShortName("Comentator");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i=0;
   //   Demarker
   double valDem=iDeMarker(NULL, 0, 13, 0);
   string commentDem="DeMarker:    ";
   string commentDemAdd="   Нет данных";
//----
   if (valDem < 0.30)
      commentDemAdd= "   Ожидается разворот цен Вверх";
   if (valDem > 0.70)
      commentDemAdd=  "   Ожидается разворот цен Вниз";
   commentDem=commentDem + commentDemAdd;
   //ATR
   double valATR=iATR(NULL, 0, 12, 0);
   string commentATR="ATR:           ";
   commentATR=commentATR + "   Вероятность смены тренда " + valATR;
   //AС
   string commentAC="AC:            ";
   string commentACAdd="Нет данных ";
   string commentACAdd0="Нет данных ";
   string commentACAdd1="Нет данных ";
   string commentACAdd2="Нет данных ";
   double valAC0=iAC(NULL, 0, 0);
   double valAC1=iAC(NULL, 0, 1);
//----   
   if (valAC1 < valAC0)
      commentACAdd="Не желательно продавать";
   if (valAC1 > valAC0)
      commentACAdd="Не желательно покупать";
   bool theeRedUpper=true;
   for(i=2; i>=0; i--)
     {
      if(iAC(NULL, 0, i) < iAC(NULL, 0, i+1))
        {
         if(iAC(NULL, 0, i)<=0)
            theeRedUpper=false;
        }
      else
         theeRedUpper=false;
     }
   if (theeRedUpper==true)
      commentACAdd0="Короткая позиция";
//----
   bool theeGreenDown=true;
   for(i=2; i>=0; i--)
     {
      if(iAC(NULL, 0, i) > iAC(NULL, 0, i+1))
        {
         if(iAC(NULL, 0, i)>=0)
            theeGreenDown=false;
        }
      else
         theeGreenDown=false;
     }
   if (theeGreenDown==true)
      commentACAdd0="Длинная позиция";
//----
   bool twoRedUpper=true;
   for(i=1; i>=0; i--)
     {
      if(iAC(NULL, 0, i) > iAC(NULL, 0, i+1))
         twoRedUpper=false;
     }
   if (twoRedUpper==true)
      commentACAdd2="Короткая позиция";
//----
   bool twoGreenDown=true;
   for(i=2; i>=0; i--)
     {
      if(iAC(NULL, 0, i) < iAC(NULL, 0, i+1))
         twoGreenDown=false;
     }
   if (twoGreenDown==true)
      commentACAdd2="Длинная позиция";
   if (iAC(NULL, 0, 0) < 0)
     {
      if (theeRedUpper==true)
         commentACAdd1="Возможна покупка, ";
      if (theeGreenDown==true)
         commentACAdd1="Возможна покупка, ";
      if (twoRedUpper==true)
         commentACAdd2="Возможна продажа, ";
     }
   if (iAC(NULL, 0, 0) > 0)
     {
      if (theeRedUpper==true)
         commentACAdd1="Возможна продажа, ";
      if (theeGreenDown==true)
         commentACAdd1="Возможна продажа, ";
      if (twoGreenDown==true)
         commentACAdd2="Возможна покупка, ";
     }
   commentAC=commentAC
   + "\n" + "   " +commentACAdd
   + "\n" + "   " + commentACAdd1+ commentACAdd0
   + "\n" + "   " + commentACAdd2
   ;
   //CCI
   double valCCI=iCCI(NULL,0,12,PRICE_MEDIAN,0);
   string commentCCI="CCI:            ";
   string commentCCIAdd="   Нет данных ";
//----   
   if (valCCI > 100)
      commentCCIAdd= "   Cостояние перекупленности (вероятность корректирующего спада) ";
   if (valCCI < -100)
      commentCCIAdd= "   Cостояние перепроданности (вероятность корректирующего подъема) ";
   commentCCI= commentCCI + commentCCIAdd + valCCI;
   //MFI
   double valMFI=iMFI(NULL,0,14,0);
   string commentMFI="MFI:            ";
   string commentMFIAdd="   Нет данных ";
//----   
   if (valMFI > 80)
      commentMFIAdd= "    потенциальноая вершина рынка ";
   if (valMFI < 20)
      commentMFIAdd= "    потенциальноае основание рынка ";
   commentMFI= commentMFI + commentMFIAdd + valMFI;
   //WPR
   double valWPR=iWPR(NULL,0,14,0);
   string commentWPR="R%:             ";
   string commentWPRAdd="   Нет данных ";
//----   
   if (valWPR < -80)
      commentWPRAdd= "    состояние перепроданности (разумно дождаться поворота цен вверх) ";
   if (valWPR > -20)
      commentWPRAdd= "    состояние перекупленности (разумно дождаться поворота цен вниз) ";
   commentWPR= commentWPR + commentWPRAdd + valWPR;
   //STOCH
   double valSTOCH=0;
   string commentSTOCH="Stoch:         ";
   string commentSTOCHAdd="   Нет данных ";
//----   
   if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0)>iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,0))
      commentSTOCHAdd= "    Возможна покупка";
   if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0)<iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,0))
      commentSTOCHAdd= "    Возможна продажа";
   commentSTOCH= commentSTOCH + commentSTOCHAdd;
   //Momentum
   double valMom=0;
   string commentMom="Momentum:  ";
   string commentMomAdd="   Нет данных ";
//----   
   if((iMomentum(NULL,0,14,PRICE_CLOSE,1) < 100) && (iMomentum(NULL,0,14,PRICE_CLOSE,0) > 100))
      commentMomAdd= "    Сигнал к покупке";
   if((iMomentum(NULL,0,14,PRICE_CLOSE,1) > 100) && (iMomentum(NULL,0,14,PRICE_CLOSE,0) < 100))
      commentMomAdd= "    Сигнал к продаже";
   commentMom= commentMom + commentMomAdd;
//----   
   Comment("Индикаторы\n"
   +commentSTOCH + "\n"
   +commentWPR + "\n"
   +commentMFI + "\n"
   +commentDem + "\n"
   +commentCCI + "\n"
   +commentATR + "\n"
   +commentMom + "\n"
   +commentAC + "\n"
   );
   return(0);
  }
//+------------------------------------------------------------------+