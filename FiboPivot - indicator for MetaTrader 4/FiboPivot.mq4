//+------------------------------------------------------------------+
//|                                                    FiboPivot.mq4 |
//|                                                        Scriptong |
//|                                                scriptong@mail.ru |
//+------------------------------------------------------------------+
#property copyright "Scriptong"
#property link      "scriptong@mail.ru"

#property indicator_chart_window
#property indicator_buffers 7
#property indicator_color1 Lime
#property indicator_color2 Green
#property indicator_color3 DarkGreen
#property indicator_color4 Maroon
#property indicator_color5 Crimson
#property indicator_color6 Red
#property indicator_color7 Blue
//---- input parameters
extern double    Resistance3=138.2;
extern double    Resistance2=100.0;
extern double    Resistance1=61.8;
extern double    Support1=61.8;
extern double    Support2=100;
extern double    Support3=138.2;
extern bool      ShowDescription=True;
extern color     Resistance3Color=Lime;
extern color     Resistance2Color=Green;
extern color     Resistance1Color=DarkGreen;
extern color     Support1Color=Maroon;
extern color     Support2Color=Crimson;
extern color     Support3Color=Red;
extern color     PivotColor=Blue;

//---- buffers
double Res3[];
double Res2[];
double Res1[];
double Supp1[];
double Supp2[];
double Supp3[];
double Pivot[];

bool Activate;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   Activate=False;
//---- indicators
   SetIndexStyle(0,DRAW_LINE,STYLE_DOT);
   SetIndexBuffer(0,Res3);
   SetIndexStyle(1,DRAW_LINE,STYLE_DOT);
   SetIndexBuffer(1,Res2);
   SetIndexStyle(2,DRAW_LINE,STYLE_DOT);
   SetIndexBuffer(2,Res1);
   SetIndexStyle(3,DRAW_LINE,STYLE_DOT);
   SetIndexBuffer(3,Supp1);
   SetIndexStyle(4,DRAW_LINE,STYLE_DOT);
   SetIndexBuffer(4,Supp2);
   SetIndexStyle(5,DRAW_LINE,STYLE_DOT);
   SetIndexBuffer(5,Supp3);
   SetIndexStyle(6,DRAW_LINE);
   SetIndexBuffer(6,Pivot);

   if(Period()>PERIOD_H4)
     {
      Comment("Индикатор FiboPivot работает на графиках не выше H4.");
      return(0);
     }

   Activate=True;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   for(int i=ObjectsTotal()-1; i>=0; i--)
      if(StringSubstr(ObjectName(i),0,5)=="Pivot" || 
         StringSubstr(ObjectName(i), 0, 3) == "Res" ||
         StringSubstr(ObjectName(i), 0, 4) == "Supp")
         ObjectDelete(ObjectName(i));
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Объект-метка со значением цены                                   |
//+------------------------------------------------------------------+
void ObjectLabel(string name,string Text,datetime Time1,double Price1,color col)
  {
   if(ObjectFind(name)<0)
     {
      ObjectCreate(name,OBJ_TEXT,0,Time1,Price1);
      ObjectSet(name,OBJPROP_COLOR,col);
     }
   else
      ObjectMove(name,0,Time1,Price1);
   ObjectSetText(name,Text,8,"Arial");

  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   if(!Activate) return(0);

   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=2;

//  int    counted_bars=IndicatorCounted();
//----
   datetime NowDay = iTime(Symbol(), PERIOD_D1, 0);
   int FirstDayBar = iBarShift(Symbol(), 0, NowDay);

/*   if (Bars-counted_bars < FirstDayBar)
     int limit = FirstDayBar;
    else
     limit = Bars - counted_bars;
  */

   int LastPrevDay=iBars(Symbol(),PERIOD_D1);

   for(int i=limit; i>=0; i--)
     {
      int PrevDay=iBarShift(Symbol(),PERIOD_D1,Time[i])+1; // номер бара предыдущего дня на графике D1
      if(LastPrevDay!=PrevDay)
        {
         double HighDay = iHigh(Symbol(),PERIOD_D1,PrevDay); // Максимум предыдущего дня
         double LowDay = iLow(Symbol(), PERIOD_D1, PrevDay); // Минимум предыдущего дня
         double CloseDay=iClose(Symbol(),PERIOD_D1,PrevDay); // Закрытие предыдущего дня
         double Width=HighDay-LowDay;
         Pivot[i]=(HighDay+LowDay+CloseDay)/3; //Стандартный Pivot - типичная цена дня
         Res1[i] = Pivot[i] + Width*(Resistance1/100.0);
         Res2[i] = Pivot[i] + Width*(Resistance2/100.0);
         Res3[i] = Pivot[i] + Width*(Resistance3/100.0);
         Supp1[i] = Pivot[i] - Width*(Support1/100.0);
         Supp2[i] = Pivot[i] - Width*(Support2/100.0);
         Supp3[i] = Pivot[i] - Width*(Support3/100.0);
         if(ShowDescription)
           {
            datetime DayTime=iTime(Symbol(),PERIOD_D1,PrevDay-1)+43200;
            ObjectLabel("Pivot"+DoubleToStr(DayTime,0),
                        "Pivot "+DoubleToStr(Pivot[i],Digits),DayTime,Pivot[i],PivotColor);
            ObjectLabel("Res1"+DoubleToStr(DayTime,0),
                        "Resistance1 "+DoubleToStr(Res1[i],Digits),DayTime,Res1[i],Resistance1Color);
            ObjectLabel("Res2"+DoubleToStr(DayTime,0),
                        "Resistance2 "+DoubleToStr(Res2[i],Digits),DayTime,Res2[i],Resistance2Color);
            ObjectLabel("Res3"+DoubleToStr(DayTime,0),
                        "Resistance3 "+DoubleToStr(Res3[i],Digits),DayTime,Res3[i],Resistance3Color);
            ObjectLabel("Supp1"+DoubleToStr(DayTime,0),
                        "Support1 "+DoubleToStr(Supp1[i],Digits),DayTime,Supp1[i],Support1Color);
            ObjectLabel("Supp2"+DoubleToStr(DayTime,0),
                        "Support2 "+DoubleToStr(Supp2[i],Digits),DayTime,Supp2[i],Support2Color);
            ObjectLabel("Supp3"+DoubleToStr(DayTime,0),
                        "Support3 "+DoubleToStr(Supp3[i],Digits),DayTime,Supp3[i],Support3Color);
           }
         LastPrevDay=PrevDay;
        }
      else
        {
         Pivot[i]= Pivot[i+1];
         Res1[i] = Res1[i+1];
         Res2[i] = Res2[i+1];
         Res3[i] = Res3[i+1];
         Supp1[i] = Supp1[i+1];
         Supp2[i] = Supp2[i+1];
         Supp3[i] = Supp3[i+1];
        }
     }

//----
   return(0);
  }
//+------------------------------------------------------------------+
