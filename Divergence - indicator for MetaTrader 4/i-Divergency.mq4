//+------------------------------------------------------------------+
//|                                                   Divergency.mq4 |
//|                                       Copyright © Trofimov, 2008 |
//+------------------------------------------------------------------+
#property copyright "Copyright © Trofimov, 2008"
#property link      ""
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 DarkSlateBlue
#property indicator_width1 2
#property indicator_color2 Red
#property indicator_width2 2
#property indicator_color3 FireBrick
#property indicator_width3 1
#property indicator_color4 DarkGreen
#property indicator_width4 1

#property indicator_maximum  100
#property indicator_minimum -100

extern double Delta=10; // - минимальное расстояние между минимумом и максимумом
int    ExtremumPoint=3; // - количество точек по которым определяются экстремумы. Может быть любым нечётным значением больше единицы (Например: 3,5,7,9....)
int    Buffer=500;      // - размер буфера массива Stochastic[]
int    CurBuffer;       // - текущий (последний заполненный) буферный индекс массива Stochastic[]
double Stochastic[];
int    UpStochIdx[3];   // - массив, содержащий буферные индексы трёх последних максимумов
int    DnStochIdx[3];   // - массив, содержащий буферные индексы трёх последних минимумов
int    CurrentCandle;
datetime LastTime;

//---- Массив данных индикатора
double StochBuffer[];
double EndLimit[];
double StochUp[],StochDn[];
//+------------------------------------------------------------------+
int init() {
   //if(Buffer==0) Buffer=Bars;
   ArrayResize(Stochastic, Buffer);
   IndicatorBuffers(4);
//---- параметры рисования (установка начального бара)
   SetIndexDrawBegin(0,Buffer);
//---- 2 распределенных буфера индикатора
   SetIndexBuffer(0,StochBuffer);
   SetIndexBuffer(1,EndLimit);
   SetIndexBuffer(2,StochUp);
   SetIndexBuffer(3,StochDn);
//---- имя индикатора и подсказки для линий
   IndicatorShortName("Divergency("+DoubleToStr(Delta,1)+")");
   SetIndexLabel(0,"Divergency");
   SetIndexLabel(1,"Limit");
   SetIndexLabel(2,"Top");
   SetIndexLabel(3,"Low");
//--- стиль отрисовки
   SetIndexStyle(0, DRAW_HISTOGRAM);
   SetIndexStyle(1, DRAW_HISTOGRAM);
   SetIndexStyle(2, DRAW_ARROW);
   SetIndexStyle(3, DRAW_ARROW);
   SetIndexArrow(2, 108);
   SetIndexArrow(3, 108);
}
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
   static int OldUpStochIdx,OldDnStochIdx;
   int limit;
   // Пропущенные бары
   int counted_bars=IndicatorCounted();
//---- обходим возможные ошибки
   if(counted_bars<0) return(-1);
//---- новые бары не появились и поэтому ничего рисовать не нужно
   limit=Bars-counted_bars-1;
//---- основной цикл
   for(int i=limit; i>=0; i--) {
      CurrentCandle=i+1;//-это полностью сформировавшаяся свеча
      if(LastTime!=iTime(NULL,0,CurrentCandle)) {
         AddStochastic();
         LastTime=iTime(NULL,0,CurrentCandle);
         //Индикатор пересечения границ 20/80
         //EndLimit[i]=0;
         if(OldUpStochIdx!=UpStochIdx[0]) {
            if(Stochastic[UpStochIdx[0]]>80) {
               EndLimit[i]=-50;
               OldUpStochIdx=UpStochIdx[0];
            }
         }
         if(OldDnStochIdx!=DnStochIdx[0]) {
            if(Stochastic[DnStochIdx[0]]<20) {
               EndLimit[i]=50;
               OldDnStochIdx=DnStochIdx[0];
            }
         }
         //Индикатор дивергенции
         //StochBuffer[i]=0;
         if(VectorStochastic(true)<0 && VectorPrice(true)>0) {
            if(GetIndexNormal(UpStochIdx[0])<GetIndexNormal(DnStochIdx[0])) {//если последний минимум старее последнего максимума
               StochBuffer[i]=-100;
            }
         }
         if(VectorStochastic(false)>0 && VectorPrice(false)<0) {
            if(GetIndexNormal(UpStochIdx[0])>GetIndexNormal(DnStochIdx[0])) {//если последний максимум старее последнего минимума
               StochBuffer[i]=100;
            }
         }
         //Print("===== ",TimeToStr(LastTime)," =====");
      }
   }
   return(0);
  }
//+------------------------------------------------------------------+
int AddStochastic() {
   //Добавляет новое значение стохастика в массив
   if(CurBuffer==0) 
      CurBuffer=Buffer-1;
   else
      CurBuffer--;
   Stochastic[CurBuffer]=iStochastic(NULL,0,5,3,3,MODE_EMA,0,MODE_MAIN,CurrentCandle);

   //Проверка на возникновение экстремума
   int countUp, countDn;
   int idxTop=(ExtremumPoint-1)/2; // - нормальный индекс вершины
   for (int i = idxTop-1; i >= 0 ; i--) { //Цыкл нормального индекса
      if(Stochastic[GetIndexBuffer(i)]<Stochastic[GetIndexBuffer(i+1)] &&
      Stochastic[GetIndexBuffer(idxTop+(idxTop-i))]<Stochastic[GetIndexBuffer(idxTop+(idxTop-i)-1)]) {
         countUp++;
      }
      if(Stochastic[GetIndexBuffer(i)]>Stochastic[GetIndexBuffer(i+1)] &&
      Stochastic[GetIndexBuffer(idxTop+(idxTop-i))]>Stochastic[GetIndexBuffer(idxTop+(idxTop-i)-1)]) {
         countDn++;
      }
   } //Next i
   if(countUp==idxTop) { //вершина оказалась максимумом
      if(GetIndexNormal(DnStochIdx[0])<GetIndexNormal(UpStochIdx[0])) { //Если предыдущим стоит минимум
         if(Stochastic[GetIndexBuffer(idxTop)]-Stochastic[DnStochIdx[0]]>Delta){ 
         //Если между предыдущим минимумом и предположительным максимумом растояние по вертикали больше Delta
            UpStochIdx[2]=UpStochIdx[1];
            UpStochIdx[1]=UpStochIdx[0];
            UpStochIdx[0]=GetIndexBuffer(idxTop);
            StochUp[CurrentCandle-1]=Stochastic[UpStochIdx[0]];
         }
      } else { //Если предыдущим стоит максимум
         if(Stochastic[UpStochIdx[0]]<Stochastic[GetIndexBuffer(idxTop)]) { //если предыдущий максимум был меньше настоящего
            StochUp[CurrentCandle-2+GetIndexNormal(UpStochIdx[0])]=EMPTY_VALUE;
            //StochUp[CurrentCandle-1+idxTop]=Stochastic[GetIndexBuffer(idxTop)];
            StochUp[CurrentCandle-1]=Stochastic[GetIndexBuffer(idxTop)];
            UpStochIdx[0]=GetIndexBuffer(idxTop);
         }
      }
   } else if(countDn==idxTop) { //вершина оказалась минимумом
      if(GetIndexNormal(UpStochIdx[0])<GetIndexNormal(DnStochIdx[0])) { //Если предыдущим стоит максимум
         if(Stochastic[UpStochIdx[0]]-Stochastic[GetIndexBuffer(idxTop)]>Delta){ 
         //Если между предыдущим максисумом и предположительным минимумом растояние по вертикали больше Delta
            DnStochIdx[2]=DnStochIdx[1];
            DnStochIdx[1]=DnStochIdx[0];
            DnStochIdx[0]=GetIndexBuffer(idxTop);
            StochDn[CurrentCandle-1]=Stochastic[DnStochIdx[0]];
         }
      } else { //Если предыдущим стоит минимум
         if(Stochastic[DnStochIdx[0]]>Stochastic[GetIndexBuffer(idxTop)]) { //если предыдущий минимум был больше настоящего
            StochDn[CurrentCandle-2+GetIndexNormal(DnStochIdx[0])]=EMPTY_VALUE;
            //StochDn[CurrentCandle-1+idxTop]=Stochastic[GetIndexBuffer(idxTop)];
            StochDn[CurrentCandle-1]=Stochastic[GetIndexBuffer(idxTop)];
            DnStochIdx[0]=GetIndexBuffer(idxTop);
         }
      }
   }
   return(0);
}
//+------------------------------------------------------------------+
int GetIndexBuffer(int Idx) {
   //возвращает буферный индекс массива, где Idx - нормальный индекс
   if(Idx>Buffer-1) {
      Print("Недопустимое значение индекса для массива");
      return(-1);
   }
   int retIndex=CurBuffer+Idx;
   if(retIndex>Buffer-1) retIndex=retIndex-Buffer;
   return(retIndex);
}
//+------------------------------------------------------------------+
int GetIndexNormal(int IdxBuf) {
   //возвращает нормальный индекс, где IdxBuf - буферный индекс массива
   if(IdxBuf>Buffer-1) {
      Print("Недопустимое значение индекса для массива");
      return(-1);
   }
   int retIndex=IdxBuf-CurBuffer;
   if(retIndex<0) retIndex=retIndex+Buffer;
   return(retIndex);
}
//+------------------------------------------------------------------+
int VectorStochastic(bool MaxMin) {
   //возвращает направление трендовой линии, проведённой через вершины стохастика:
   //1 - вверх, -1 - вниз, 0 - горизонтально
   //MaxMin - типы анализируемых вершин: true - максимумы, false - минимумы 
   if(MaxMin) {
      //Print("Stochastic[UpStochIdx[0]]="+Stochastic[UpStochIdx[0]],", Stochastic[UpStochIdx[1]]="+Stochastic[UpStochIdx[1]]);
      if(Stochastic[UpStochIdx[0]]>Stochastic[UpStochIdx[1]]) {
         //Print("Stochastic[0]="+Stochastic[UpStochIdx[0]],", Stochastic[1]="+Stochastic[UpStochIdx[1]],", return 1");
         return(1);
      } else if(Stochastic[UpStochIdx[0]]<Stochastic[UpStochIdx[1]]) {
         //Print("Stochastic[0]="+Stochastic[UpStochIdx[0]],", Stochastic[1]="+Stochastic[UpStochIdx[1]],", return -1");
         return(-1);
      }
   } else {
      //Print("Stochastic[DnStochIdx[0]]="+Stochastic[DnStochIdx[0]],", Stochastic[DnStochIdx[1]]="+Stochastic[DnStochIdx[1]]);
      if(Stochastic[DnStochIdx[0]]>Stochastic[DnStochIdx[1]]) {
         //Print("Stochastic[0]="+Stochastic[DnStochIdx[0]],", Stochastic[1]="+Stochastic[DnStochIdx[1]],", return 1");
         return(1);
      } else if(Stochastic[DnStochIdx[0]]<Stochastic[DnStochIdx[1]]) {
         //Print("Stochastic[0]="+Stochastic[DnStochIdx[0]],", Stochastic[1]="+Stochastic[DnStochIdx[1]],", return -1");
         return(-1);
      }
   }
   return(0);
}
//+------------------------------------------------------------------+
int VectorPrice(bool MaxMin) {
   //возвращает направление трендовой линии, проведённой через пики свечей текущего графика:
   //1 - вверх, -1 - вниз, 0 - горизонтально
   //MaxMin - типы анализируемых пиков: true - High, false - Low 
   int Extremum0,Extremum1;
   if(MaxMin) {
      Extremum0=iHighest(NULL,0,MODE_HIGH,GetIndexNormal(DnStochIdx[0]),CurrentCandle);
      Extremum1=iHighest(NULL,0,MODE_HIGH,GetIndexNormal(DnStochIdx[1])-GetIndexNormal(DnStochIdx[0]),GetIndexNormal(DnStochIdx[0])+CurrentCandle);
      //Print("High[Extremum0]=",High[Extremum0],", High[Extremum1]=",High[Extremum1]);
      if(High[Extremum0]>High[Extremum1]) {
         //Print("High[0]=",High[Extremum0],", High[1]=",High[Extremum1],", return 1");
         return(1);
      } else {
         //Print("High[0]=",High[Extremum0],", High[1]=",High[Extremum1],", return -1");
         return(-1);
      }
   } else {
      Extremum0=iLowest(NULL,0,MODE_LOW,GetIndexNormal(UpStochIdx[0]),CurrentCandle);
      Extremum1=iLowest(NULL,0,MODE_LOW,GetIndexNormal(UpStochIdx[1])-GetIndexNormal(UpStochIdx[0]),GetIndexNormal(UpStochIdx[0])+CurrentCandle);
      //Print("Low[Extremum0]=",Low[Extremum0],", Low[Extremum1]=",Low[Extremum1]);
      if(Low[Extremum0]>Low[Extremum1]) {
         //Print("Low[0]=",Low[Extremum0],", Low[1]=",Low[Extremum1],", return 1");
         return(1);
      } else {
         //Print("Low[0]=",Low[Extremum0],", Low[1]=",Low[Extremum1],", return -1");
         return(-1);
      }
   }
   return(0);
}
//+------------------------------------------------------------------+

