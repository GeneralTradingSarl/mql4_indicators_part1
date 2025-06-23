//------------------------------------------------------------------/
// Индикатор-советник, основаный на теории Демарка с моими дополнениями
// Часть идеи взята из индикатора Ind-TD-DeMark-3-1.mq4 [Kara ©]
//------------------------------------------------------------------/
#property copyright "GreenDog" 
#property link      "krot@inbox.ru" // v2.3.1

#property indicator_chart_window 
#property indicator_buffers 2
#property indicator_color1 Red 
#property indicator_color2 Blue 

extern int showBars=200; // если = 0, то точки демарка отображается для всего графика
extern int LevDP=3; // уровень точек демарка; 2 = центральный бар будет выше(ниже) 2х баров слева и 2х баров справа
extern int qSteps=1; // количество отображаемых шагов, не более 3х
extern int BackStep=0; // количество шагов назад
extern int startBar=0; // если 0, то рекомендации для текущего бара, если 1 - то для предполагаемого следующего бара
extern bool TrendLine=true; // false = линий тренда не будет
extern bool HorizontLine=false; // true = то будут прорисованы уровни пробоя
extern bool ChannelLine=true; // true = строить паралельно линиям тренда каналы 
extern bool TakeLines=true; // true = то рисуем уровни тейка
extern int Trend=0; // 1 = только для UpTrendLines, -1 = только для DownTrendLines, 0 = для всех TrendLines

double Buf1[]; 
double Buf2[]; 

string Col[6]={"Красная","Синяя","Розовая","Голубая","Коричневая","Салатная"};
int ColNum[6]={Red,DarkBlue,Coral,DodgerBlue,SaddleBrown,MediumSeaGreen};

int qBars; double qTime=0; // переменные для ликвидации глюков при загрузке

int init() 
  {
   qBars=Bars;
   qSteps=MathMin(3,qSteps);
   int code=161; string Rem="DemarkLines © GameOver";
   IndicatorShortName(Rem); 
   SetIndexStyle(0,DRAW_ARROW); 
   SetIndexStyle(1,DRAW_ARROW); 
   SetIndexArrow(0,code); 
   SetIndexArrow(1,code); 
   SetIndexBuffer(0,Buf1); 
   SetIndexBuffer(1,Buf2); 
   SetIndexEmptyValue(0,0.0);
   SetIndexEmptyValue(1,0.0);
   SetIndexLabel(0,Rem); 
   SetIndexLabel(1,Rem); 
   return(0);
  } 

int deinit() {
   Comment("");
   ArrayInitialize(Buf1,0.0);
   ArrayInitialize(Buf2,0.0);
   for(int i=1;i<=LevDP;i++){
      ObjectDelete("HA_"+i);ObjectDelete("LA_"+i);
      ObjectDelete("HL_"+i);ObjectDelete("LL_"+i);
      ObjectDelete("HHL_"+i);ObjectDelete("HLL_"+i);
      ObjectDelete("HCL_"+i);ObjectDelete("LCL_"+i);
      for(int j=0;j<4;j++) {ObjectDelete("HTL_"+i+j);ObjectDelete("LTL_"+i+j);}
   }
}
  
int start(){
   
   if (qBars!=Bars){
      deinit(); Comment("Demark, версия © GameOver\nПодождите, идет загрузка баров..."); 
      Sleep(1000); qBars=Bars; qTime=0; return(0);
   }

   if (qTime==Time[0]) return(0); qTime=Time[0]; // запускаеца тока на 1м тике
   if (showBars==0) showBars=Bars-LevDP; // заполнили и отобразили точки демарка
   for (int cnt=showBars;cnt>LevDP;cnt--){
      Buf1[cnt]=DemHigh(cnt,LevDP);
      Buf2[cnt]=DemLow(cnt,LevDP);
   }
   
   string Comm;
   Comm="Линия тренда["+On(TrendLine)+"]; Канал ["+On(ChannelLine)+
   "]; Уровень пробоя ["+On(HorizontLine)+"]; Цели ["+On(TakeLines)+"]\n";
   for(cnt=1;cnt<=qSteps;cnt++) Comm=Comm+(TDMain(cnt));
   Comm=Comm+"———— © GameOver ————";
   Comment(Comm);
   return(0); 
}

string TDMain(int Step){
   int H1,H2,L1,L2,qExt,i,col;
   double tmp,qTL,qLevel,HT[4],LT[4];
   bool isHitch;
   string Comm="»—»—» Шаг "+Step+" из "+qSteps+" (BackStep "+BackStep+")\n",Text,Rem,qp;
   
   // для DownTrendLines
   if (Trend<=0){
      Comm=Comm+"» "+Col[Step*2-2]+" DownTrendLine ";
      col=ColNum[Step*2-2];
      H1=GetTD(Step+BackStep,Buf1);
      H2=GetNextHighTD(H1);
      qTL=(High[H2]-High[H1])/(H2-H1);
      qExt=Lowest(NULL,0,MODE_LOW,H2-H1-1,H1+1); // локальный минимум между точками
      qLevel=High[H2]-qTL*(H2); if (Step+BackStep==1) qLevel=qLevel-qTL*startBar;
      if (H1<0 || H2<0) Comm=Comm+"на графике недостаточно точек для построения\n";
      else {
         Comm=Comm+"["+DoubleToStr(High[H2],Digits)+"»"+DoubleToStr(High[H1],Digits)+"]";
         Comm=Comm+"; Level "+DoubleToStr(qLevel,Digits);
         if (Step+BackStep==1) {
            if (startBar>0) Comm=Comm+"; Future Bar "+UpHitch(-1,qLevel);
            else Comm=Comm+"; Last Bar "+UpHitch(startBar,qLevel);
         }
         Comm=Comm+"\n";
         // Анализ - был ли пробой трендовой линии
         i=H1;isHitch=false;Text="";
         while(i>0 && isHitch==false){
            tmp=High[H2]-qTL*(H2-i);
            Rem="HA_"+Step;
            if (High[i]>tmp){
               qp=UpHitch(i,tmp);
               if (qp!=""){
                  isHitch=true;
                  Text=Text+"Ист. (ур "+DoubleToStr(tmp,Digits)+") "+qp;
                  ObjectCreate(Rem,OBJ_ARROW,0,Time[i],Low[i]-Point);
                  ObjectSet(Rem,OBJPROP_COLOR,col); ObjectSet(Rem,OBJPROP_ARROWCODE,241);
                  while(i>0){ // пробой отменен, если после пробоя был новый лоу или закрытие ниже
                     i--;
                     if (Low[i]<Low[qExt] || Close[i]<(Low[qExt]+(High[H1]-Low[qExt])*0.236)){
                        Text=Text+" (отменен)";
                        ObjectSet(Rem,OBJPROP_PRICE1,Low[i]-Point); ObjectSet(Rem,OBJPROP_TIME1,Time[i]); ObjectSet(Rem,OBJPROP_ARROWCODE,251);
                        break;
                     }
                  }
               }
               else { Text=Text+"Лож. (ур "+DoubleToStr(tmp,Digits)+"); "; ObjectDelete(Rem);}
            }
            i--;
         }
         if (Text=="") Text="Пробоя не было.";
         Comm=Comm+Text+"\n";
         // end analysis
         Rem="HL_"+Step; // собсно линия тренда
         if (TrendLine){
            ObjectCreate(Rem,OBJ_TREND,0,Time[H2],High[H2],Time[H1],High[H1]);
            ObjectSet(Rem,OBJPROP_COLOR,col); ObjectSet(Rem,OBJPROP_WIDTH,3-MathMin(2,Step));
         }    
         Rem="HHL_"+Step; // уровень пробоя линии тренда
         if (HorizontLine && (Step+BackStep)==1){
            ObjectCreate(Rem,OBJ_HLINE,0,0,qLevel);
            ObjectSet(Rem,OBJPROP_COLOR,col);
         }
         Rem="HCL_"+Step; // линия канала
         if (ChannelLine){
            ObjectCreate(Rem,OBJ_TREND,0,Time[qExt],Low[qExt],Time[0],Low[qExt]-qTL*qExt);
            ObjectSet(Rem,OBJPROP_COLOR,col);
         }
         Rem="HTL_"+Step; // линии целей
         if (TakeLines){
            HT[3]=Low[qExt]+(High[H1]-Low[qExt])*1.618-qLevel; //  доп уровень
            HT[0]=High[H2]-qTL*(H2-qExt)-Low[qExt];
            HT[1]=High[H2]-qTL*(H2-qExt)-Close[qExt];
            qExt=Lowest(NULL,0,MODE_CLOSE,H2-H1,H1);
            HT[2]=High[H2]-qTL*(H2-qExt)-Close[qExt];
            Comm=Comm+"Цели: ";
            for(i=0;i<4;i++){
               qTL=NormalizeDouble(qLevel+HT[i],Digits);
               ObjectCreate(Rem+i,OBJ_HLINE,0,0,qTL,0,0); 
               ObjectSet(Rem+i,OBJPROP_STYLE,STYLE_DOT); ObjectSet(Rem+i,OBJPROP_COLOR,col);
               Comm=Comm+DoubleToStr(qTL,Digits)+" ("+DoubleToStr(HT[i]/Point,0)+"п.) ";
             }
             Comm=Comm+"\n";
         }
      }
   }

   // для UpTrendLines
   if (Trend>=0){
      Comm=Comm+"» "+Col[Step*2-1]+" UpTrendLine ";
      col=ColNum[Step*2-1];
      L1=GetTD(Step+BackStep,Buf2);
      L2=GetNextLowTD(L1);
      qTL=(Low[L1]-Low[L2])/(L2-L1);
      qExt=Highest(NULL,0,MODE_HIGH,L2-L1-1,L1+1); // локальный минимум между точками
      qLevel=Low[L2]+qTL*L2; if (Step+BackStep==1) qLevel=qLevel+qTL*startBar;
      if (L1<0 || L2<0) Comm=Comm+"на графике недостаточно точек для построения\n";
      else {
         Comm=Comm+"["+DoubleToStr(Low[L2],Digits)+"»"+DoubleToStr(Low[L1],Digits)+"]";
         Comm=Comm+"; Level "+DoubleToStr(qLevel,Digits);
         if (Step+BackStep==1) {
            if (startBar>0) Comm=Comm+"; Future Bar "+DownHitch(-1,qLevel);
            else Comm=Comm+"; Last Bar "+DownHitch(startBar,qLevel);
         }
         Comm=Comm+"\n";
         // Анализ - был ли пробой трендовой линии
         i=L1;isHitch=false;Text="";
         while(i>0 && isHitch==false){
            tmp=Low[L2]+qTL*(L2-i);
            Rem="LA_"+Step;
            if (Low[i]<tmp){
               qp=DownHitch(i,tmp);
               if (qp!=""){
                  isHitch=true;
                  Text=Text+"Ист. (ур "+DoubleToStr(tmp,Digits)+") "+qp;
                  ObjectCreate(Rem,OBJ_ARROW,0,Time[i],Low[i]-Point);
                  ObjectSet(Rem,OBJPROP_COLOR,col); ObjectSet(Rem,OBJPROP_ARROWCODE,242);
                  while(i>0){ // пробой отменен, если после пробоя был новый хай или закрытие выше
                     i--;
                     if (High[i]>High[qExt] || Close[i]>High[qExt]-(High[qExt]-Low[L1])*0.236){
                        Text=Text+" (отменен)";
                        ObjectSet(Rem,OBJPROP_PRICE1,Low[i]-Point); ObjectSet(Rem,OBJPROP_TIME1,Time[i]); ObjectSet(Rem,OBJPROP_ARROWCODE,251);
                        break;
                     }
                  }
               }
               else { Text=Text+"Лож. (ур "+DoubleToStr(tmp,Digits)+"); "; ObjectDelete(Rem);}
            }
            i--;
         }
         if (Text=="") Text="Пробоя не было.";
         Comm=Comm+Text+"\n";
         // end analysis
         Rem="LL_"+Step; // собсно линия тренда
         if (TrendLine==1) {
            ObjectCreate(Rem,OBJ_TREND,0,Time[L2],Low[L2],Time[L1],Low[L1]);
            ObjectSet(Rem,OBJPROP_COLOR,col); ObjectSet(Rem,OBJPROP_WIDTH,3-MathMin(2,Step));
         }    
         Rem="HLL_"+Step; // уровень пробоя линии тренда
         if (HorizontLine && (Step+BackStep)==1){
            ObjectCreate(Rem,OBJ_HLINE,0,0,qLevel);
            ObjectSet(Rem,OBJPROP_COLOR,col);
         }
         Rem="LCL_"+Step; // линия канала
         if (ChannelLine){
            ObjectCreate(Rem,OBJ_TREND,0,Time[qExt],High[qExt],Time[0],High[qExt]+qTL*qExt);
            ObjectSet(Rem,OBJPROP_COLOR,col);
         }
         Rem="LTL_"+Step;
         if (TakeLines){ // линии целей
            LT[3]=qLevel-High[qExt]+(High[qExt]-Low[L1])*1.618; // доп уровень
            LT[0]=High[qExt]-qTL*(L2-qExt)-Low[L2];
            LT[1]=Close[qExt]-qTL*(L2-qExt)-Low[L2];
            qExt=Highest(NULL,0,MODE_CLOSE,L2-L1,L1);
            LT[2]=Close[qExt]-qTL*(L2-qExt)-Low[L2];
            Comm=Comm+"Цели: ";
            for(i=0;i<4;i++){
               qTL=NormalizeDouble(qLevel-LT[i],Digits);
               ObjectCreate(Rem+i,OBJ_HLINE,0,0,qTL,0,0);
               ObjectSet(Rem+i,OBJPROP_STYLE,STYLE_DOT); ObjectSet(Rem+i,OBJPROP_COLOR,col);
               Comm=Comm+DoubleToStr(qTL,Digits)+" ("+DoubleToStr(LT[i]/Point,0)+"п.) ";
             }
            Comm=Comm+"\n";
         }
      }
   }
   return(Comm);
}

int GetTD(int P, double Arr[]){
   int i=0,j=0;
   while(j<P){ i++; while(Arr[i]==0){i++;if(i>showBars-2)return(-1);} j++;}
   return (i);         
}
int GetNextHighTD(int P){ 
   int i=P+1;
   while(Buf1[i]<=High[P]){i++;if(i>showBars-2)return(-1);}
   return (i);
}
int GetNextLowTD(int P){
   int i=P+1;
   while(Buf2[i]>=Low[P] || Buf2[i]==0){i++;if(i>showBars-2)return(-1);}
   return (i);
}
// рекурсивная проверка на условия Демарка (хай), возвращает значение или 0
double DemHigh(int cnt, int sh){
   if (High[cnt]>=High[cnt+sh] && High[cnt]>High[cnt-sh]) {
      if (sh>1) return(DemHigh(cnt,sh-1));
      else return(High[cnt]);
   }
   else return(0);
}
// рекурсивная проверка на условия Демарка (лоу), возвращает значение или 0
double DemLow(int cnt, int sh){
   if (Low[cnt]<=Low[cnt+sh] && Low[cnt]<Low[cnt-sh]) {
      if (sh>1) return(DemLow(cnt,sh-1));
      else return(Low[cnt]);
   }
   else return(0);
}
string On(bool On){
   if (On) return("Вкл"); else return("Выкл");
}
string UpHitch(int P, double qLevel){ // определение квалификаторов прорыва вверх
   string Comm="";
   if (Close[P+1]<Close[P+2]) Comm=Comm+" 1";
   if (P>=0 && Open[P]>qLevel) Comm=Comm+" 2";
   if (2*Close[P+1]-Low[P+1]<qLevel) Comm=Comm+" 3";
   if (Comm!="") Comm="[ Кв.Пр:"+Comm+" ]";
   return(Comm);
}
string DownHitch(int P, double qLevel){ // определение квалификаторов прорыва вниз
   string Comm="";
   if (Close[P+1]>Close[P+2]) Comm=Comm+" 1";
   if (P>=0 && Open[P]<qLevel) Comm=Comm+" 2";
   if (2*Close[P+1]-High[P+1]>qLevel) Comm=Comm+" 3";
   if (Comm!="") Comm="[ Кв.Пр:"+Comm+" ]";
   return(Comm);
}