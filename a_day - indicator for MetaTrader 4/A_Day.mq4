//+------------------------------------------------------------------+
//|                                                        A_Day.mq4 |
//|                                         Copyright © 2010, Elmare |
//|                                        http://elmare.webnode.ru  |
//+------------------------------------------------------------------+
#property copyright "Elmare © 2010"
#property link      "http://elmare.webnode.ru/"

#property indicator_chart_window


extern color up=Lime;
extern color dn=Red;
extern color fn=Blue;
extern int CandleShade=2;
color daycol=C'108,108,0';
string days[]={"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"};
double top=0;
double bot=1;
int tmp;
datetime st;
datetime yst;
datetime mst;
datetime dst;
int sh;
int per;
color cColor;
extern int shift=800;
extern int gsh=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   per=Period();

   ObjectCreate("LL1",OBJ_TREND,0,0,0);

   ObjectCreate("LL2",OBJ_TREND,0,0,0);

   ObjectCreate("aFinDay",OBJ_TREND,0,0,0);

   ObjectCreate("LL3",OBJ_TREND,0,0,0);
   ObjectCreate("LL4",OBJ_TREND,0,0,0);
   ObjectCreate("LL333",OBJ_TREND,0,0,0);
   ObjectCreate("LL444",OBJ_TREND,0,0,0);
   ObjectCreate("LL33",OBJ_TREND,0,0,0);
   ObjectCreate("LL44",OBJ_TREND,0,0,0);

   ObjectCreate("T1",OBJ_TEXT,0,0,0);
   ObjectCreate("T2",OBJ_TEXT,0,0,0);

   ObjectCreate("LL5",OBJ_TREND,0,0,0);
//-------------------------------
   ObjectCreate("aR",OBJ_RECTANGLE,0,0,0);
   ObjectCreate("aR1",OBJ_TREND,0,0,0);
   ObjectCreate("aR2",OBJ_TREND,0,0,0);
//-------------------------------

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectDelete("aFinDay");
   ObjectDelete("LL1");
   ObjectDelete("LL2");
   ObjectDelete("TL1");
   ObjectDelete("TL2");
   ObjectDelete("LL3");
   ObjectDelete("LL4");
   ObjectDelete("LL5");
   ObjectDelete("LL33");
   ObjectDelete("LL333");
   ObjectDelete("LL444");
   ObjectDelete("LL44");
   ObjectDelete("aR");
   ObjectDelete("aR1");
   ObjectDelete("aR2");
   ObjectDelete("T1");
   ObjectDelete("T2");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   sh=1;

   top=WindowPriceMax();
   bot=WindowPriceMin();
//----
   if(DayOfWeek()==1) {sh=1;}
   else{sh=1;}

//----------------------------   
   ObjectSet("aFinDay",OBJPROP_TIME1,iTime(Symbol(),PERIOD_D1,0)+86600);
   ObjectSet("aFinDay",OBJPROP_PRICE1,0);
   ObjectSet("aFinDay",OBJPROP_TIME2,iTime(Symbol(),PERIOD_D1,0)+86600);
   ObjectSet("aFinDay",OBJPROP_PRICE2,1);
   ObjectSet("aFinDay",OBJPROP_COLOR,C'30,30,30');
   ObjectSet("aFinDay",OBJPROP_RAY,1);

   ObjectSet("LL1",OBJPROP_TIME1,iTime(Symbol(),PERIOD_D1,0)+gsh);
   ObjectSet("LL1",OBJPROP_PRICE1,0);
   ObjectSet("LL1",OBJPROP_TIME2,iTime(Symbol(),PERIOD_D1,0)+gsh);
   ObjectSet("LL1",OBJPROP_PRICE2,1);
   ObjectSet("LL1",OBJPROP_COLOR,daycol);
   ObjectSet("LL1",OBJPROP_RAY,1);

   ObjectSet("LL2",OBJPROP_TIME1,iTime(Symbol(),PERIOD_D1,sh)+gsh);
   ObjectSet("LL2",OBJPROP_PRICE1,0);
   ObjectSet("LL2",OBJPROP_TIME2,iTime(Symbol(),PERIOD_D1,sh)+gsh);
   ObjectSet("LL2",OBJPROP_PRICE2,1);
   ObjectSet("LL2",OBJPROP_COLOR,daycol);
   ObjectSet("LL1",OBJPROP_RAY,1);

   ObjectSet("LL3",OBJPROP_TIME1,iTime(Symbol(),PERIOD_D1,sh));
   ObjectSet("LL3",OBJPROP_PRICE1,iHigh(Symbol(),PERIOD_D1,sh));
   ObjectSet("LL3",OBJPROP_TIME2,iTime(Symbol(),PERIOD_M1,sh));
   ObjectSet("LL3",OBJPROP_PRICE2,iHigh(Symbol(),PERIOD_D1,sh));
   ObjectSet("LL3",OBJPROP_COLOR,DodgerBlue);
   ObjectSet("LL3",OBJPROP_RAY,0);

   ObjectSet("LL33",OBJPROP_TIME1,iTime(Symbol(),PERIOD_D1,0));
   ObjectSet("LL33",OBJPROP_PRICE1,iHigh(Symbol(),PERIOD_D1,sh));
   ObjectSet("LL33",OBJPROP_TIME2,iTime(Symbol(),PERIOD_M1,0));
   ObjectSet("LL33",OBJPROP_PRICE2,iHigh(Symbol(),PERIOD_D1,sh));
   ObjectSet("LL33",OBJPROP_COLOR,fn);
   ObjectSet("LL33",OBJPROP_RAY,0);
   ObjectSet("LL33",OBJPROP_STYLE,0);

   ObjectSet("LL333",OBJPROP_TIME1,iTime(Symbol(),PERIOD_D1,0));
   ObjectSet("LL333",OBJPROP_PRICE1,iHigh(Symbol(),PERIOD_D1,sh));
   ObjectSet("LL333",OBJPROP_TIME2,iTime(Symbol(),PERIOD_M1,0)+per*300);
   ObjectSet("LL333",OBJPROP_PRICE2,iHigh(Symbol(),PERIOD_D1,sh));
   ObjectSet("LL333",OBJPROP_COLOR,DodgerBlue);
   ObjectSet("LL333",OBJPROP_RAY,0);
   ObjectSet("LL333",OBJPROP_STYLE,2);

   ObjectSet("LL4",OBJPROP_TIME1,iTime(Symbol(),PERIOD_D1,sh));
   ObjectSet("LL4",OBJPROP_PRICE1,iLow(Symbol(),PERIOD_D1,sh));
   ObjectSet("LL4",OBJPROP_TIME2,iTime(Symbol(),PERIOD_M1,sh));
   ObjectSet("LL4",OBJPROP_PRICE2,iLow(Symbol(),PERIOD_D1,sh));
   ObjectSet("LL4",OBJPROP_COLOR,DodgerBlue);
   ObjectSet("LL4",OBJPROP_RAY,0);

   ObjectSet("LL44",OBJPROP_TIME1,iTime(Symbol(),PERIOD_D1,0));
   ObjectSet("LL44",OBJPROP_PRICE1,iLow(Symbol(),PERIOD_D1,sh));
   ObjectSet("LL44",OBJPROP_TIME2,iTime(Symbol(),PERIOD_M1,0));
   ObjectSet("LL44",OBJPROP_PRICE2,iLow(Symbol(),PERIOD_D1,sh));
   ObjectSet("LL44",OBJPROP_COLOR,fn);
   ObjectSet("LL44",OBJPROP_RAY,0);
   ObjectSet("LL44",OBJPROP_STYLE,0);

   ObjectSet("LL444",OBJPROP_TIME1,iTime(Symbol(),PERIOD_D1,0));
   ObjectSet("LL444",OBJPROP_PRICE1,iLow(Symbol(),PERIOD_D1,sh));
   ObjectSet("LL444",OBJPROP_TIME2,iTime(Symbol(),PERIOD_M1,0)+per*300);
   ObjectSet("LL444",OBJPROP_PRICE2,iLow(Symbol(),PERIOD_D1,sh));
   ObjectSet("LL444",OBJPROP_COLOR,DodgerBlue);
   ObjectSet("LL444",OBJPROP_RAY,0);
   ObjectSet("LL444",OBJPROP_STYLE,2);

   ObjectSet("LL5",OBJPROP_TIME1,iTime(Symbol(),PERIOD_D1,0));
   ObjectSet("LL5",OBJPROP_PRICE1,iOpen(Symbol(),PERIOD_D1,0));
   ObjectSet("LL5",OBJPROP_TIME2,iTime(Symbol(),PERIOD_M1,0)+per*300);
   ObjectSet("LL5",OBJPROP_PRICE2,iOpen(Symbol(),PERIOD_D1,0));
   ObjectSet("LL5",OBJPROP_COLOR,Red);
   ObjectSet("LL5",OBJPROP_STYLE,2);
   ObjectSet("LL5",OBJPROP_RAY,0);

//-------------------------------
   ObjectSetText("T1",days[DayOfWeek()],10,"Microsoft Sans Serif",Gray);
   ObjectSet("T1",OBJPROP_TIME1,iTime(Symbol(),PERIOD_D1,0)+600*per);
   ObjectSet("T1",OBJPROP_PRICE1,top);

   tmp=DayOfWeek()-1;
   if(DayOfWeek()==1) {tmp=5;}

   ObjectSetText("T2",days[tmp],10,"Microsoft Sans Serif",Gray);

   ObjectSet("T2",OBJPROP_TIME1,iTime(Symbol(),PERIOD_D1,sh)+600*per);
   ObjectSet("T2",OBJPROP_PRICE1,top);
//----

   if(Bid>iOpen(0,PERIOD_D1,0)){cColor=up;}
   else {cColor=dn;}

   ObjectSet("aR",OBJPROP_TIME1,iTime(Symbol(),per,0)+per*shift);
   ObjectSet("aR",OBJPROP_PRICE1,iOpen(Symbol(),PERIOD_D1,0));
   ObjectSet("aR",OBJPROP_TIME2,iTime(Symbol(),per,2)+per*shift);
   ObjectSet("aR",OBJPROP_PRICE2,Bid);
   ObjectSet("aR",OBJPROP_COLOR,cColor);

   ObjectSet("aR1",OBJPROP_TIME1,iTime(Symbol(),per,1)+per*shift);
   ObjectSet("aR1",OBJPROP_PRICE1,iHigh(Symbol(),PERIOD_D1,0));
   ObjectSet("aR1",OBJPROP_TIME2,iTime(Symbol(),per,1)+per*shift);
   ObjectSet("aR1",OBJPROP_PRICE2,iLow(Symbol(),PERIOD_D1,0));
   ObjectSet("aR1",OBJPROP_WIDTH,CandleShade);
   ObjectSet("aR1",OBJPROP_COLOR,cColor);

   ObjectSet("aR2",OBJPROP_TIME1,iTime(Symbol(),per,1)+per*shift);
   ObjectSet("aR2",OBJPROP_PRICE1,iLow(Symbol(),PERIOD_D1,0));
   ObjectSet("aR2",OBJPROP_TIME2,iTime(Symbol(),per,1)+per*shift);
   ObjectSet("aR2",OBJPROP_PRICE2,iLow(Symbol(),PERIOD_D1,0)-0.01);
   ObjectSet("aR2",OBJPROP_WIDTH,CandleShade);
   ObjectSet("aR2",OBJPROP_COLOR,Black);

   return(0);
  }
//+------------------------------------------------------------------+
