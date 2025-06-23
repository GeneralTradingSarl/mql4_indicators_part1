//+------------------------------------------------------------------+
//|                                          Fractal_Level_Xrust.mq4 |
//|                                 Copyright © 2008, XrustSolution. |
//|                                            http://xrust.ucoz.net |
//+------------------------------------------------------------------+
#property copyright "#Copyright © 2008, XrustSolution.#"
#property link      "#xrust.ucoz.net#"

#property indicator_chart_window
extern int    TimeFrame=0;//Если=0, то текуший
extern int    Distanse=0;//Дистанция линии от фрактала в пунктах
extern string FrApNam="Ap";//Имя линии соотв.Фракталу вверх
extern string FrDnNam="Dn";//Имя линии соотв.Фракталу вниз
extern color  ClAp=Blue;//Цвет линии соотв.Фракталу вверх
extern color  ClDn=Red;//Цвет линии соотв.Фракталу вниз
extern bool   comment=true;//Разрещение на комментарий
//-----------------------------------------------------------------------------+
double FrPrise;
double FrApPrise=0,FrDnPrise=0;
//+----------------------------------------------------------------------------+
void init(){
  if(TimeFrame==0){TimeFrame=Period();}
  IndicatorShortName("Factal_Level_Xrust"+TimeFrame);
  FrApNam=StringConcatenate(FrApNam,TimeFrame);
  FrDnNam=StringConcatenate(FrDnNam,TimeFrame);
  return;}
void deinit(){
  ObjectDelete(FrDnNam);
  ObjectDelete(FrApNam);
  Comment(" ");
  return;}
//+----------------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   int limit;
   double tmp;
   int i, j,k;
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//-----------------------------------------------------------------------------+
   LineAp();
   LineDn();
   string FAP=DoubleToStr((FrApPrise-Distanse*Point),Digits);
   string FDP=DoubleToStr((FrDnPrise+Distanse*Point),Digits);
   int diap=MathRound((FrApPrise-FrDnPrise)/Point);
   if(comment){Comment("TimeFrame="+TimeFrame+
                       "\nApPrise ="+FAP+
                       "\nDnPrise ="+FDP+
                       "\nFractal Channel ="
                       +diap+"Point");}

   return(0);
  }
//-----------------------------------------------------------------------------+
// Ищет горизонтальную линию по имени перерисовывает если изменилась цена      |   
//-----------------------------------------------------------------------------+
   void LineDn(){
   FrPrise=NormalizeDouble(FindNearFractal(0,TimeFrame,MODE_LOWER),MarketInfo(Symbol(),MODE_DIGITS));
   FrPrise=NormalizeDouble(FrPrise-Distanse*Point,MarketInfo(Symbol(),MODE_DIGITS));
   //Comment(FrPrise);
   if(ObjectFind(FrDnNam)==0){
     if(ObjectGet(FrDnNam,OBJPROP_PRICE1)==FrPrise){return;}}
   FrDnPrise=FrPrise;  
   ObjectDelete(FrDnNam);
   SetHLine(ClDn,FrDnNam,FrDnPrise,0,1);
   WindowRedraw();
   return;} 
//-----------------------------------------------------------------------------+
// Ищет горизонтальную линию по имени перерисовывает если изменилась цена      | 
//-----------------------------------------------------------------------------+
   void LineAp(){
   FrPrise=NormalizeDouble(FindNearFractal(0,TimeFrame,MODE_UPPER),MarketInfo(Symbol(),MODE_DIGITS));
   FrPrise=NormalizeDouble(FrPrise+Distanse*Point,MarketInfo(Symbol(),MODE_DIGITS));
   if(ObjectFind(FrApNam)==0){
     if(ObjectGet(FrApNam,OBJPROP_PRICE1)==FrPrise){return;}}
   FrApPrise=FrPrise; 
   ObjectDelete(FrApNam); 
   SetHLine(ClAp,FrApNam,FrApPrise,0,1);
   WindowRedraw();
   return;}
//-----------------------------------------------------------------------------+   
//   Киму Респект и уважуха !!!                                                |       
//+----------------------------------------------------------------------------+
//|  Автор    : Ким Игорь В. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  Версия   : 07.10.2006                                                     |
//|  Описание : Поиск ближайшего фрактала. Возвращает ценовой уровень.         |
//+----------------------------------------------------------------------------+
//|  Параметры:                                                                |
//|    sy   - наименование инструмента      ("" или NULL - текущий символ)     |
//|    tf   - таймфрейм                     (    0       - текущий ТФ)         |
//|    mode - тип фрактала                  (MODE_LOWER|MODE_UPPER)            |
//+----------------------------------------------------------------------------+
double FindNearFractal(string sy="0", int tf=0, int mode=MODE_LOWER) {
  if (sy=="" || sy=="0") sy=Symbol();
  double f=0;
  int    d=MarketInfo(sy, MODE_DIGITS), s;
  if (d==0) if (StringFind(sy, "JPY")<0) d=4; else d=2;

  for (s=2; s<100; s++) {
    f=iFractals(sy, tf, mode, s);
    if (f!=0) return(NormalizeDouble(f, d));
  }
  Print("FindNearFractal(): Фрактал не найден");
  return(0);
}
//+----------------------------------------------------------------------------+
//|  Автор    : Ким Игорь В. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  Версия   : 30.03.2008                                                     |
//|  Описание : Установка объекта OBJ_HLINE горизонтальная линия               |
//+----------------------------------------------------------------------------+
//|  Параметры:                                                                |
//|    cl - цвет линии                                                         |
//|    nm - наименование               ("" - время открытия текущего бара)     |
//|    p1 - ценовой уровень            (0  - Bid)                              |
//|    st - стиль линии                (0  - простая линия)                    |
//|    wd - ширина линии               (0  - по умолчанию)                     |
//+----------------------------------------------------------------------------+
void SetHLine(color cl, string nm="", double p1=0, int st=0, int wd=1) {
  if (nm=="") nm=DoubleToStr(Time[0], 0);
  if (p1<=0) p1=Bid;
  if (ObjectFind(nm)<0) ObjectCreate(nm, OBJ_HLINE, 0, 0,0);
  ObjectSet(nm, OBJPROP_PRICE1, p1);
  ObjectSet(nm, OBJPROP_COLOR , cl);
  ObjectSet(nm, OBJPROP_STYLE , st);
  ObjectSet(nm, OBJPROP_WIDTH , wd);
}