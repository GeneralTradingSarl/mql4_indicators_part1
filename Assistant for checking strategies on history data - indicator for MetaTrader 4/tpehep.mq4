//+------------------------------------------------------------------+
//|                                                       TPEHEP.mq4 |
//|                                                   Copyright 2016.|
//+------------------------------------------------------------------+
#property link      "Fedor10_10@mail.ru"
#property version   "1.01"
#property strict
#property indicator_chart_window
#property description "Индикатор TPEHEP предназначен для тестирования стратегии"
#property description "на истории в пошаговом режиме с автоматическим контролем"
#property description "исполнения приказов, ошибок, и созанием отчета для Excel."
#property description "  Горячие клавиши:  'B'- BUY,  'S'- SELL,  'C'- CLOSE"
#property description "                                   F12 или Step- сдвиг графика на 1 шаг"
#property description "                                   '<'- Область влево, '>'- Область вправо"
#property description "                                   'P'- сохранение файла отчета"
extern string K="+:+:+:+";//Параметры исполнения приказов
input bool Traid=true;//Торговля/Разметка
input double Lots   =1.0;//Величина лота
input int StopLoss  =100;//StopLoss (в 5-значном)
input int TakeProfit=40;//TakeProfit (в 5-значном)
input double Spread=0.0;   //Спред (в 5-значном) 0 - из истории
input double Freeze=0.0;   //Уровень заморозки (в 5-значном)
extern string L="+:+:+:+";//Разрешение на прорисовку
input bool Vertical =true;//рисование/нет вертикальных линий
input color OpBUY=clrLightSkyBlue;//цвет линии BUY
input color OpSELL=clrLightPink;//цвет линии SELL
input color ClsAll=clrWhite;    //цвет линии закрытия ручного
input color TakePr=clrPaleGreen;//цвет линии закрытия по TakeProfit
input color StopLs=clrYellow;   //цвет линии закрытия по StopLoss
extern string M="+:+:+:+";//разное
input color Zone=clrDarkViolet;    //цвет выделения рассматриваемого бара
input bool Metka=false;//рисование/нет ценовых меток
input bool Alerts=false;//запрет предупреждений
input int Step=110;//Клавиша сдвига графика на 1 шаг
int    n,bar0,Ordr,Tr,SH,file;
double Ask0,Ask1,Bid0,Bid1,SL,TP,SP,Zm,Lev,LevOrd,LevUp,LevDn,Sum;
string FileName,FileNamo,Namo,Uplev,Oplev,Dnlev;
long   result,resold;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   FileName=Symbol()+"."+IntegerToString(Period())+" ";//временный файл для записи сделок
   if(Traid)//пропуск при отказе от расчета
     {
      if(Spread==0.0) SP=MarketInfo(Symbol(),MODE_SPREAD);//Спред
      else SP=Spread;
      if(Freeze==0.0) Zm=MarketInfo(Symbol(),MODE_FREEZELEVEL);//уровень заморозки
      else Zm=Freeze;
      Lev=MarketInfo(Symbol(),MODE_STOPLEVEL);//минимальный стоп
      Lev=NormalizeDouble((Lev*Point),Digits);//минимальный стоп
      SL=NormalizeDouble((StopLoss*Point),Digits);//StopLoss
      if(SL<Lev) {SL=Lev; Alert("StopLoss=",SL/Point);}
      TP=NormalizeDouble((TakeProfit*Point),Digits);//TakeProfit
      if(TP<Lev) {TP=Lev; Alert("TakeProfit=",TP/Point);}
      SP=NormalizeDouble((SP*Point),Digits);//спред
      Zm=NormalizeDouble((Zm*Point),Digits);//уровень заморозки
      if(Digits==3 || Digits==5)//пересчет под инструмент
        {
         if(SL>1000) Alert("StopLoss для 5-знака не больше 1000");
         if(TP>1000) Alert("TakeProfit для 5-знака не больше 1000");
        }
      else
        {
         if(SL>100) Alert("StopLoss для 4-знака не больше 100");
         if(TP>100) Alert("TakeProfit для 4-знака не больше 100");
        }
      ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0,result);//количество пикселей по Х
      ObjectCreate("Show1",OBJ_LABEL,0,0,0); //место отрисовки на экране
      ObjectSet("Show1",OBJPROP_XDISTANCE,result/2-50);
      ObjectSet("Show1",OBJPROP_YDISTANCE,0);
      ObjectSet("Show1",OBJPROP_CORNER,0);
      ObjectSetText("Show1","БАЛАНС:",14,"Arial",clrDarkGray);//надпись БАЛАНС
      ObjectCreate("Show2",OBJ_LABEL,0,0,0); //место отрисовки на экране
      ObjectSet("Show2",OBJPROP_XDISTANCE,result/2+40);
      ObjectSet("Show2",OBJPROP_YDISTANCE,0);
      ObjectSet("Show2",OBJPROP_CORNER,0);
      ObjectSetText("Show2",DoubleToString(0.0,1),14,"Arial",clrBlueViolet);//результат трейдера
      resold=result;
      file=FileOpen(FileName,FILE_WRITE|FILE_SHARE_READ|FILE_TXT);
      FileWrite(file,"  Номер\t  Время\t    Цена\t  Приказ\t  Время\t    Цена\t  Профит\t     Итог");
     }
   ObjectCreate("Zona",OBJ_VLINE,0,Time[0],Close[0]);//выделяем область рассматриваемого бара
   ObjectSet("Zona",OBJPROP_STYLE,DRAW_LINE);
   ObjectSet("Zona",OBJPROP_WIDTH,8);
   ObjectSet("Zona",OBJPROP_COLOR,Zone);
   ObjectSet("Zona",OBJPROP_BACK,true);
   ObjectSet("Zona",OBJPROP_TIME1,Time[0]);//уточним рассматриваемый бар
   ChartRedraw(); //перерисуем
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(Traid) FileClose(file);//сохранение после расчета
   ObjectDelete("Zona");
   ObjectDelete("Show1");
   ObjectDelete("Show2");
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   return(rates_total);//пустышка
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,         // идентификатор события
                  const long& lparam,   // параметр события типа long
                  const double& dparam, // параметр события типа double
                  const string& sparam) // параметр события типа string
  {
//+------------------------------------------------------------------+
//| проверка нажатия клавиши или мышки                               |
//+------------------------------------------------------------------+
   if(CHARTEVENT_CHART_CHANGE)
     {
      ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0,result);//контроль за размером экрана
      if(result!=resold) Show(result);
     }
   if(Traid && Ordr!=0 && id==CHARTEVENT_OBJECT_DRAG)
     {
      if(sparam==Uplev)//проверка верхнего уровня
         if(LevUp!=ObjectGet(Uplev,OBJPROP_PRICE1))
            LevUp=MouseUp();//при изменении уровня
      if(sparam==Dnlev)//проверка нижнего уровня
         if(LevDn!=ObjectGet(Dnlev,OBJPROP_PRICE1))
            LevDn=MouseDn();//при изменении уровня
     }
   if(id==CHARTEVENT_KEYDOWN)
     {
      switch(int(lparam))
        {
         case 37: Alert("Попытка повторить историю"); break;//KEY_LEFT_ARROW
         case 39: Alert("Пошаговая прокрутка по F12"); break;//KEY_RIGHT_ARROW по F12
         case 66: if(Traid)
           {
            if(Ordr==0)//KEY_BUY
              {
               Ordr=bar0;
               Levl("BUY");//рисуем линии открытия и стопы
               if(Vertical) Vert("BUY",OpBUY);//рисуем вертикальную линию BUY
               if(Metka) Metca("BUY",0,OpBUY);//рисуем ценовую метку
              }
            else Alert("Сделка уже открыта");
           }
         else if(Tr!=1){Tr=1; Vert("BUY",OpBUY);}//рисуем вертикальную линию BUY
         else Alert("Тренд вверх уже отмечен");
         n++; if(n==1) Namo=TimeToString(Time[Bar()],TIME_DATE);
         break;
         case 67: if(Traid)
           {
            if(Ordr!=0)//KEY_CLOSE
              {
               if(Freez()) break;//проверка на заморозку
               Trend("CL",Ordr,ClsAll);//рисуем линию
               if(Vertical) Vert("CL",ClsAll);//рисуем вертикальную линию Clоsе
               if(Metka) Metca("CL",Ordr,ClsAll);//рисуем ценовую метку
               Prof("CL",Ordr);//подсчитаем итог
               Ordr=0; if(Traid) Delet();//удаление уровней
              }
            else Alert("Нет сделки");
           }
         else if(Tr!=0) {Tr=0; Vert("CL",ClsAll);}//рисуем вертикальную линию Clоsе
         else Alert("Тренд не отмечен");
         break;
         case 80:
            if(n<1)//чистый шаблон
              {
               if(ChartSaveTemplate(0,FileName+"."))
                  Alert("шаблон ",FileName," сохранен"); break;
              }
            else
              {
               if(Traid)//сохранение файла отчета
                 {
                  FileFlush(file); FileClose(file);
                  FileNamo=FileName+Namo+"-"+TimeToString(Time[Bar()],TIME_DATE)+".xls";
                  if(FileMove(FileName,0,FileNamo,FILE_REWRITE))
                     Alert("отчет ",FileNamo," сохранен"); break;
                 }
               else//шаблон с разметкой
                 {
                  FileNamo=FileName+Namo+"-"+TimeToString(Time[Bar()],TIME_DATE)+".";
                  if(ChartSaveTemplate(0,FileNamo))
                     Alert("разметка ",FileNamo," сохранена"); break;
                 }
              }
         case 83: if(Traid)
           {
            if(Ordr==0)//KEY_SELL
              {
               Ordr=-bar0;
               Levl("SEL");//рисуем линии открытия и стопы
               if(Vertical) Vert("SEL",OpSELL);//рисуем вертикальную линию SELL
               if(Metka) Metca("SEL",0,OpSELL);//рисуем ценовую метку
              }
            else Alert("Сделка уже открыта");
           }
         else if(Tr!=-1) {Tr=-1; Vert("SEL",OpSELL);}//рисуем вертикальную линию SELL
         else Alert("Тренд вниз уже отмечен");
         n++; if(n==1) Namo=TimeToString(Time[Bar()],TIME_DATE);
         break;
         case 188: SH++;//KEY_LEFT
         if(SH>WindowBarsPerChart()){Alert("Область на границе слева"); SH=WindowBarsPerChart();}
         break;//увеличим номер рассматриваемого бара
         case 190: SH--;//KEY_RIGHT
         if(SH<0){Alert("Область на границе справа"); SH=0;}
         break;//уменьшим номер рассматриваемого бара 
         default: if(lparam==Step) {ChartNavigate(0,CHART_CURRENT_POS,1); break;}//KEY_Shift
         else Alert("Нажата не та клавиша",(lparam));
        }
     }
   if(Bar()<=0) {if(n>0) Alert("Прорисован последний бар"); return;}//контроль окончания истории
   bar0=Bar()+SH;//номер нужного бара на графике
   if(Time[bar0]!=ObjectGet("Zona",OBJPROP_TIME1))//проверим рассматриваемый бар
     {
      Bid0=Close[bar0]; Ask0=Close[bar0]+SP;//цена закрытия рассматриваемого бара
      Bid1=Open[bar0-1]; Ask1=Open[bar0-1]+SP;//цена открытия будущего бара
      LevStop();//автоматическая проверка срабатывания уровней
      ObjectSet("Zona",OBJPROP_TIME1,Time[bar0]);//уточним рассматриваемый бар
      ChartRedraw();//перерисуем
     }
  }
//+------------------------------------------------------------------+
//| приложения                                                       |
//+------------------------------------------------------------------+
void Vert(string cmd,color clr)//рисуем вертикальную линию
  {
   cmd+=IntegerToString(n);
   ObjectCreate(cmd,OBJ_VLINE,0,Time[bar0],0);
   ObjectSet(cmd,OBJPROP_STYLE,STYLE_DASH);
   ObjectSet(cmd,OBJPROP_COLOR,clr);
   ObjectSet(cmd,OBJPROP_BACK,true);
   ChartRedraw();//перерисуем
  }
//+------------------------------------------------------------------+
void Levl(string cmd)//рисуем горизонтальные линии приказов
  {
   Oplev=cmd;
   if(cmd=="BUY")
     {
      LevOrd=Ask1;//уровень Ask открытия
      Uplev="TakeProfit"; LevUp=LevOrd+TP;//уровень Bid StopLoss от открытия
      Dnlev="StopLoss"; LevDn=LevOrd-SL;//уровень Bid TakeProfit от открытия
     }
   if(cmd=="SEL")
     {
      LevOrd=Bid1;//уровень Bid открытия
      Uplev="StopLoss"; LevUp=LevOrd+SL;//уровень Ask TakeProfit от открытия
      Dnlev="TakeProfit"; LevDn=LevOrd-TP;//уровень Ask StopLoss от открытия
     }
   ObjectCreate(Uplev,OBJ_HLINE,0,0,LevUp);
   ObjectSet(Uplev,OBJPROP_STYLE,STYLE_DASHDOT);
   ObjectSet(Uplev,OBJPROP_COLOR,clrOrangeRed);
   ObjectSetInteger(0,Uplev,OBJPROP_BACK,true);
   ObjectSetInteger(0,Uplev,OBJPROP_SELECTED,true);
   ObjectCreate(Oplev,OBJ_HLINE,0,0,LevOrd);
   ObjectSet(Oplev,OBJPROP_STYLE,STYLE_DASHDOT);
   ObjectSet(Oplev,OBJPROP_COLOR,clrLimeGreen);
   ObjectSetInteger(0,Oplev,OBJPROP_BACK,true);
   ObjectCreate(Dnlev,OBJ_HLINE,0,0,LevDn);
   ObjectSet(Dnlev,OBJPROP_STYLE,STYLE_DASHDOT);
   ObjectSet(Dnlev,OBJPROP_COLOR,clrOrangeRed);
   ObjectSetInteger(0,Dnlev,OBJPROP_BACK,true);
   ObjectSetInteger(0,Dnlev,OBJPROP_SELECTED,true);
   ChartRedraw();//перерисуем
  }
//+------------------------------------------------------------------+
void Metca(string cmd,int ord,color clr)//рисуем ценовую метку
  {
   if(ord==0)//открытие ордера
     {
      if(cmd=="BUY") Met("Ask"+IntegerToString(n),Time[bar0-1],LevOrd,clr);//Open BUY
      if(cmd=="SEL") Met("Bid"+IntegerToString(n),Time[bar0-1],LevOrd,clr);//Open SELL
     }
   if(ord>0)//открыт ордер BUY
     {
      if(cmd=="CL") Met("Bid"+IntegerToString(n),Time[bar0-1],Bid1,clr);//ZERO
      if(cmd=="SL") Met("Bid"+IntegerToString(n),Time[bar0],LevDn,clr);//SL
      if(cmd=="TP") Met("Bid"+IntegerToString(n),Time[bar0],LevUp,clr);//TP
     }
   if(ord<0)
     {
      if(cmd=="CL") Met("Ask"+IntegerToString(n),Time[bar0-1],Ask1,clr);//ZERO
      if(cmd=="SL") Met("Ask"+IntegerToString(n),Time[bar0],LevUp,clr);//SL
      if(cmd=="TP") Met("Ask"+IntegerToString(n),Time[bar0],LevDn,clr);//TP
     }
  }
//+------------------------------------------------------------------+
void Met(string nm,datetime tm,double pr,color clr)//рисуем ценовую метку
  {
   ObjectCreate(nm,OBJ_ARROW_LEFT_PRICE,0,tm,pr);
   ObjectSet(nm,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSet(nm,OBJPROP_COLOR,clr);
   ObjectSetInteger(0,nm,OBJPROP_SELECTED,false);
   ObjectSetInteger(0,nm,OBJPROP_SELECTABLE,false);
   ChartRedraw();//перерисуем
  }
//+------------------------------------------------------------------+
void Trend(string cmd,int ord,color clr)//рисуем линию от открытия до закрытия
  {
   string name="Tr"+IntegerToString(n);
   if(ord>0)//Ask-Bid
     {
      if(cmd=="CL") Tr(name,ord,Bid1,Time[bar0-1],clr);//Man
      if(cmd=="SL") Tr(name,ord,LevDn,Time[bar0],clr);//SL
      if(cmd=="TP") Tr(name,ord,LevUp,Time[bar0],clr);//TP
     }
   if(ord<0)//Bid-Ask
     {
      if(cmd=="CL") Tr(name,-ord,Ask1,Time[bar0-1],clr);//Man
      if(cmd=="SL") Tr(name,-ord,LevUp,Time[bar0],clr);//SL
      if(cmd=="TP") Tr(name,-ord,LevDn,Time[bar0],clr);//TP
     }
  }
//+------------------------------------------------------------------+
void Tr(string name,int ord,double pr,datetime tm,color clr)//рисуем линию от открытия до закрытия
  {
   ObjectCreate(name,OBJ_TREND,0,Time[ord-1],LevOrd,tm,pr);
   ObjectSetInteger(0,name,OBJPROP_RAY_RIGHT,false);//отключим (false) отображение линии вправо
   ObjectSet(name,OBJPROP_STYLE,STYLE_DOT);
   ObjectSet(name,OBJPROP_COLOR,clr);
   ChartRedraw();//перерисуем
  }
//+------------------------------------------------------------------+
bool Freez()
  {
   if(Ordr>0)
     {
      if(LevUp<=Bid0+Zm)
        {
         Alert("TakeProfit в зоне заморозки");
         return(true);
        }
      if(LevDn>=Bid0-Zm)
        {
         Alert("StopLoss в зоне заморозки");
         return(true);
        }
     }
   if(Ordr<0)
     {
      if(LevUp<=Ask0+Zm)
        {
         Alert("StopLoss в зоне заморозки");
         return(true);
        }
      if(LevDn>=Ask0-Zm)
        {
         Alert("TakeProfit в зоне заморозки");
         return(true);
        }
     }
   return(false);
  }
//+------------------------------------------------------------------+
void LevStop()
  {
   if(Ordr>0)//контроль BUY
     {
      if(Low[bar0]<=LevDn)//при пробитии нижнего уровня
        {
         if(Vertical) Vert("SL",StopLs);
         if(Metka) Metca("SL",Ordr,StopLs);
         if(Traid) {Trend("SL",Ordr,StopLs); Prof("SL",Ordr); Delet();}
         if(Alerts) Alert("Сработал StopLoss");
         Ordr=0;
        }
      if(High[bar0]>=LevUp)//при пробитии верхнего уровня
        {
         if(Vertical) Vert("TP",TakePr);
         if(Metka) Metca("TP",Ordr,TakePr);
         if(Traid) {Trend("TP",Ordr,TakePr); Prof("TP",Ordr); Delet();}
         if(Alerts) Alert("сработал TakeProfit");
         Ordr=0;
        }
     }
   if(Ordr<0)//контроль SELL
     {
      if(High[bar0]+SP>=LevUp)//при пробитии верхнего уровня
        {
         if(Vertical) Vert("SL",StopLs);
         if(Metka) Metca("SL",Ordr,StopLs);
         if(Traid) {Trend("SL",Ordr,StopLs); Prof("SL",Ordr); Delet();}
         if(Alerts) Alert("Сработал StopLoss");
         Ordr=0;
        }
      if(Low[bar0]+SP<=LevDn)//при пробитии нижнего уровня
        {
         if(Vertical) Vert("TP",TakePr);
         if(Metka) Metca("TP",Ordr,TakePr);
         if(Traid) {Trend("TP",Ordr,TakePr); Prof("TP",Ordr); Delet();}
         if(Alerts) Alert("сработал TakeProfit");
         Ordr=0;
        }
     }
  }
//+------------------------------------------------------------------+
void Prof(string cmd,int ord)//бухгалтерия
  {
   if(ord>0)//был BUY   Bid-Ask
     {
      if(cmd=="CL") Write(ord,"CL_BUY",Time[bar0-1],Bid1,NormalizeDouble(Bid1-LevOrd,Digits));//Man
      if(cmd=="SL") Write(ord,"SL_BUY",Time[bar0],LevDn,NormalizeDouble(LevDn-LevOrd,Digits));//SL
      if(cmd=="TP") Write(ord,"TP_BUY",Time[bar0],LevUp,NormalizeDouble(LevUp-LevOrd,Digits));//TP
     }
   if(ord<0)//был SELL Ask-Bid
     {
      if(cmd=="CL") Write(ord,"CL_SEL",Time[bar0-1],Ask1,NormalizeDouble(LevOrd-Ask1,Digits));//Man
      if(cmd=="SL") Write(ord,"SL_SEL",Time[bar0],LevUp,NormalizeDouble(LevOrd-LevUp,Digits));//SL
      if(cmd=="TP") Write(ord,"TP_SEL",Time[bar0],LevDn,NormalizeDouble(LevOrd-LevDn,Digits));//TP
     }
  }
//+------------------------------------------------------------------+
void Write(int ord,string nm,datetime tm,double clr,double pr)//запись в файл
  {
   Sum+=NormalizeDouble(pr*Lots/(10*Point),2);//общий итог
   color Cl=clrBlueViolet; if(Sum<0.0) Cl=clrCrimson;//цвет БАЛАНСА
   datetime T0=Time[fabs(ord)-1];//время открытия ордера
   FileWrite(file,n,"\t",TimeToStr(T0,TIME_MINUTES),"\t",Rus(DoubleToString(LevOrd,Digits)),"\t",nm,"\t",
             TimeToStr(tm,TIME_MINUTES),"\t",Rus(DoubleToString(clr,Digits)),"\t",
             IntegerToString(int(pr/Point)),"\t",Rus(DoubleToString(Sum,2)));
   ObjectSetText("Show2",DoubleToString(Sum,2),14,"Arial",Cl);//изменение результата трейдера
   ChartRedraw();//перерисуем
  }
//+------------------------------------------------------------------+
string Rus(string ru)//Функция заменяет(.)на(,)для русской Excel
  {
   StringReplace(ru,".",",");
   return ru;
  }
//+------------------------------------------------------------------+
int Bar()//номер первого видимого бара на графике.
  {
   long res=0;// подготовим переменную
   res+=ChartGetInteger(0,CHART_FIRST_VISIBLE_BAR,0,res);//запросим номер левого бара 
   res-=WindowBarsPerChart()+1;//найдем номер правого бара
   return(int(res));//--- вернем номер нужного бара
  }
//+------------------------------------------------------------------+
void Show(long res)//контроль за размером экрана
  {
   ObjectSet("Show1",OBJPROP_XDISTANCE,res/2-50);
   ObjectSet("Show2",OBJPROP_XDISTANCE,res/2+40);
   ChartRedraw();//перерисуем
   resold=result;
  }
//+------------------------------------------------------------------+
void Delet()//проверка уровней
  {
   ObjectDelete(Uplev);//удаление верхнего уровня
   ObjectDelete(Oplev);//удаление уровня открытия
   ObjectDelete(Dnlev);//удаление нижнего уровня
   ChartRedraw();//перерисуем
  }
//+------------------------------------------------------------------+
double MouseUp()
  {
   if(Freez()) ObjectSet(Uplev,OBJPROP_PRICE1,LevUp);//возвращаем линию на старое место
   else
     {
      if(Ordr>0 && ObjectGet(Uplev,OBJPROP_PRICE1)<=Ask0+Lev)//если линия в зоне минимума
        {
         Alert("TakeProfit= ",Lev,"+1");
         ObjectSet(Uplev,OBJPROP_PRICE1,(Ask0+Lev+Point));//отводим TakeProfit за минимум
        }
      if(Ordr<0 && ObjectGet(Uplev,OBJPROP_PRICE1)<=Bid0+Lev)//если линия в зоне минимума
        {
         Alert("StopLoss= ",Lev,"+1");
         ObjectSet(Uplev,OBJPROP_PRICE1,(Bid0+Lev+Point));//отводим StopLoss за минимум
        }
     }
   ChartRedraw();//перерисуем
   return(ObjectGet(Uplev,OBJPROP_PRICE1));//возвращаем верхний выставленный уровень
  }
//+------------------------------------------------------------------+
double MouseDn()
  {
   if(Freez()) ObjectSet(Dnlev,OBJPROP_PRICE1,LevDn);//возвращаем линию на старое место
   else
     {
      if(Ordr>0 && ObjectGet(Dnlev,OBJPROP_PRICE1)>=Ask0-Lev)//если линия в зоне минимума
        {
         Alert("StopLoss= ",Lev,"+1");
         ObjectSet(Dnlev,OBJPROP_PRICE1,(Ask0-Lev-Point));//отводим StopLoss за минимум
        }
      if(Ordr<0 && ObjectGet(Dnlev,OBJPROP_PRICE1)>=Bid0-Lev)//если линия в зоне минимума
        {
         Alert("StopLoss= ",Lev,"+1");
         ObjectSet(Dnlev,OBJPROP_PRICE1,(Bid0-Lev-Point));//отводим TakeProfit за минимум
        }
     }
   ChartRedraw();//перерисуем
   return(ObjectGet(Dnlev,OBJPROP_PRICE1));//возвращаем нижний выставленный уровень
  }
//+------------------------------------------------------------------+
