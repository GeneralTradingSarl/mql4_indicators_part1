//+------------------------------------------------------------------+
//|                                        ZCOMFX daily trend v2.mq4 |
//|                                                                  |
/*

It shows a direction of 6 pairs (EUR/USD, GBP/USD, AUD/USD, USD/CHF, USD/CAD, USD/JPY) by indicators EMA and Stochastic.
You can change pairs whatever You would like to show daily trend.

*/
//+------------------------------------------------------------------+
#property copyright "ZCOMFX"

#property indicator_chart_window
#define Pref "ZCOMFX"
#property indicator_buffers 3
#property indicator_color1 Lime
#property indicator_color2 Red
#property indicator_color3 DodgerBlue
#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2

double CrossUp[];
double CrossDown[];
double CrossFlat[];
double prevtime;
double Range,AvgRange;
double ema1,ema2;
double ema1pr,ema2pr;
double sto,stopr;
//----
int SoundAlert=0; // 0 = disabled

extern string note="Write 6 pairs to show trend:";
extern   string symbol1="EURUSD";
extern   string symbol2="GBPUSD";
extern   string symbol3="AUDUSD";
extern   string symbol4="USDCHF";
extern   string symbol5="USDCAD";
extern   string symbol6="USDJPY";
extern bool ShowArrows = True;

string note1="Parameters of MACD:";
int FastEMA=12;
int SlowEMA=26;
int SignalSMA=9;
extern string note2="Coordinates:";
extern int X=40;
extern int Y=20;
int RowStep=12;
int ColStep=17;
extern int Corner=1;
int FSize=10;
//extern int H=0;
string note3="Colors, two themes:";
color RectClr=Gray;
color TxtClr=White;
color UpClr=Lime;
color DnClr=Red;
bool White_Chart_Theme=True;
color RectClr1=Gray;
color TxtClr1=Gray;
color UpClr1=Lime;
color DnClr1=Red;
color FlatClr=DodgerBlue;

int TimeX;
double PriceY;

int codeAO,
codeAO2,
codeAO3,
codeAO4,
codeAO5,
codeAO6,codeAC,codeMACD;
color ClrAO,
ClrAO2,
ClrAO3,
ClrAO4,
ClrAO5,
ClrAO6,ClrAC,ClrMACD;
//bool Alert_=False;
//color Alert_Clr=Red;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators

   SetIndexStyle(0,DRAW_ARROW,EMPTY);
   SetIndexArrow(0,233);
   SetIndexBuffer(0,CrossUp);
   SetIndexStyle(1,DRAW_ARROW,EMPTY);
   SetIndexArrow(1,234);
   SetIndexBuffer(1,CrossDown);
   SetIndexStyle(2,DRAW_ARROW,EMPTY);
   SetIndexArrow(2,220);
   SetIndexBuffer(2,CrossFlat);

   if(White_Chart_Theme)
     {
      RectClr=RectClr1;
      TxtClr=TxtClr1;
      UpClr=UpClr1;
      DnClr=DnClr1;
     }

   DrawPanel();

//----

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   Delete_My_Obj(Pref);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {

//   {
   int i,counter;
   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+9;
//----   
   for(i=0; i<=limit; i++)
     {
      counter=i;
      Range=0;
      AvgRange=0;
      for(counter=i;counter<=i+9;counter++)
        {
         AvgRange=AvgRange+MathAbs(High[counter]-Low[counter]);
        }
      Range=AvgRange/10;
      //----       
      //----      
      ema1=iMA(NULL,PERIOD_H1,100,0,MODE_SMMA,PRICE_CLOSE,i+1);
      ema2=iMA(NULL,PERIOD_H1,50,0,MODE_SMMA,PRICE_CLOSE,i+1);
      ema1pr=iMA(NULL,PERIOD_H1,100,0,MODE_SMMA,PRICE_CLOSE,i+2);
      ema2pr=iMA(NULL,PERIOD_H1,50,0,MODE_SMMA,PRICE_CLOSE,i+2);
      sto=iStochastic(NULL,PERIOD_H1,120,1,8,MODE_SMA,0,MODE_MAIN,i+1);
      stopr=iStochastic(NULL,PERIOD_H1,120,1,8,MODE_SMA,0,MODE_MAIN,i+2);

      if((ema2>ema1 && sto<50 && stopr>50) || (ema2<ema1 && sto>50 && stopr<50))
        {
         CrossFlat[i]=Low[i]-Range*0.5;
        }

      if((ema2>ema1 && ema2pr<ema1pr && sto>50)
         || (sto>50 && stopr<50 && ema2>ema1)
         )
        {
         CrossUp[i]=Low[i]-Range*0.5;
        }
      if((ema2<ema1 && ema2pr>ema1pr && sto<50)
         || (sto<50 && stopr>50 && ema2<ema1)
         )
        {
         CrossDown[i]=High[i]+Range*0.5;
        }
     }
   if((CrossUp[0]>2000) && (CrossDown[0]>2000)) { prevtime=0; }
   if((CrossUp[0]==Low[0]-Range*0.5) && (prevtime!=Time[0]) && (SoundAlert!=0))
     {
      prevtime=Time[0];
      Alert(Symbol()," 3 MA Cross Up @  Hour ",Hour(),"  Minute ",Minute());
     }
   if((CrossDown[0]==High[0]+Range*0.5) && (prevtime!=Time[0]) && (SoundAlert!=0))
     {
      prevtime=Time[0];
      Alert(Symbol()," 3 MA Cross Down @  Hour ",Hour(),"  Minute ",Minute());
     }
//Comment("  CrossUp[0]  ",CrossUp[0]," ,  CrossDown[0]  ",CrossDown[0]," ,  prevtime  ",prevtime);
//Comment("");   

//   }

//  int    counted_bars=IndicatorCounted();
//----
//double ema1,ema2,sto;
   ema1=iMA(symbol1,PERIOD_H1,100,0,MODE_SMMA,PRICE_CLOSE,0);
   ema2=iMA(symbol1,PERIOD_H1,50,0,MODE_SMMA,PRICE_CLOSE,0);
   sto=iStochastic(symbol1,PERIOD_H4,30,3,3,MODE_SMA,0,MODE_MAIN,0);

   if(ema2>ema1 && sto>50)
     {codeAO=241; ClrAO=UpClr;}
   if(ema2<ema1 && sto<50)
     {codeAO=242; ClrAO=DnClr;}
   if((ema2>ema1 && sto<50) || (ema2<ema1 && sto>50))
     {codeAO=240; ClrAO=FlatClr;}

   double ema12,ema22,sto2;
   ema12=iMA(symbol2,PERIOD_H1,100,0,MODE_SMMA,PRICE_CLOSE,0);
   ema22=iMA(symbol2,PERIOD_H1,50,0,MODE_SMMA,PRICE_CLOSE,0);
   sto2=iStochastic(symbol2,PERIOD_H4,30,3,3,MODE_SMA,0,MODE_MAIN,0);

   if(ema22>ema12 && sto2>50)
     {codeAO2=241; ClrAO2=UpClr;}
   if(ema22<ema12 && sto2<50)
     {codeAO2=242; ClrAO2=DnClr;}
   if((ema22>ema12 && sto2<50) || (ema22<ema12 && sto2>50))
     {codeAO2=240; ClrAO2=FlatClr;}

   double ema13,ema23,sto3;
   ema13=iMA(symbol3,PERIOD_H1,100,0,MODE_SMMA,PRICE_CLOSE,0);
   ema23=iMA(symbol3,PERIOD_H1,50,0,MODE_SMMA,PRICE_CLOSE,0);
   sto3=iStochastic(symbol3,PERIOD_H4,30,3,3,MODE_SMA,0,MODE_MAIN,0);

   if(ema23>ema13 && sto3>50)
     {codeAO3=241; ClrAO3=UpClr;}
   if(ema23<ema13 && sto3<50)
     {codeAO3=242; ClrAO3=DnClr;}
   if((ema23>ema13 && sto3<50) || (ema23<ema13 && sto3>50))
     {codeAO3=240; ClrAO3=FlatClr;}

   double ema14,ema24,sto4;
   ema14=iMA(symbol4,PERIOD_H1,100,0,MODE_SMMA,PRICE_CLOSE,0);
   ema24=iMA(symbol4,PERIOD_H1,50,0,MODE_SMMA,PRICE_CLOSE,0);
   sto4=iStochastic(symbol4,PERIOD_H4,30,3,3,MODE_SMA,0,MODE_MAIN,0);

   if(ema24>ema14 && sto4>50)
     {codeAO4=241; ClrAO4=UpClr;}
   if(ema24<ema14 && sto4<50)
     {codeAO4=242; ClrAO4=DnClr;}
   if((ema24>ema14 && sto4<50) || (ema24<ema14 && sto4>50))
     {codeAO4=240; ClrAO4=FlatClr;}

   double ema15,ema25,sto5;
   ema15=iMA(symbol5,PERIOD_H1,100,0,MODE_SMMA,PRICE_CLOSE,0);
   ema25=iMA(symbol5,PERIOD_H1,50,0,MODE_SMMA,PRICE_CLOSE,0);
   sto5=iStochastic(symbol5,PERIOD_H4,30,3,3,MODE_SMA,0,MODE_MAIN,0);

   if(ema25>ema15 && sto5>50)
     {codeAO5=241; ClrAO5=UpClr;}
   if(ema25<ema15 && sto5<50)
     {codeAO5=242; ClrAO5=DnClr;}
   if((ema25>ema15 && sto5<50) || (ema25<ema15 && sto5>50))
     {codeAO5=240; ClrAO5=FlatClr;}

   double ema16,ema26,sto6;
   ema16=iMA(symbol6,PERIOD_H1,100,0,MODE_SMMA,PRICE_CLOSE,0);
   ema26=iMA(symbol6,PERIOD_H1,50,0,MODE_SMMA,PRICE_CLOSE,0);
   sto6=iStochastic(symbol6,PERIOD_H4,30,3,3,MODE_SMA,0,MODE_MAIN,0);

   if(ema26>ema16 && sto6>50)
     {codeAO6=241; ClrAO6=UpClr;}
   if(ema25<ema15 && sto5<50)
     {codeAO6=242; ClrAO6=DnClr;}
   if((ema26>ema16 && sto6<50) || (ema26<ema16 && sto6>50))
     {codeAO6=240; ClrAO6=FlatClr;}

//     if (iAC( NULL , Period(), 1)<iAC( NULL , Period(), 0)) 
//       {codeAC=217; ClrAC=UpClr;} else
//       {codeAC=218; ClrAC=DnClr;} /* */

//    if( iMACD( NULL , Period(),  
//          FastEMA, SlowEMA, SignalSMA, PRICE_CLOSE, MODE_MAIN, 1)< iMACD( NULL , Period(),  
//           FastEMA, SlowEMA, SignalSMA, PRICE_CLOSE, MODE_MAIN, 0) ) 
//        {codeMACD=217; ClrMACD=UpClr;} else
//       {codeMACD=218; ClrMACD=DnClr;} 


/* if(Alert_)
            {
               
               if(codeAO==217 && codeAC==217 && codeMACD==217)
                  {Alert(Symbol()+" "+PeriodToStr(Period())
                  +" : AO, AC and MACD are UP at "+TimeToStr(TimeCurrent(),TIME_MINUTES)); 
                  ObjectDelete(Pref+"Unidirection Alert"); }
               
               if(codeAO==218 && codeAC==218 && codeMACD==218)
                  {Alert(Symbol()+" "+PeriodToStr(Period())
                  +" : AO, AC and MACD are DOWN at "+TimeToStr(TimeCurrent(),TIME_MINUTES) ); 
                  ObjectDelete(Pref+"Unidirection Alert"); }
               
            }
          
      if(ObjectFind(Pref+"Unidirection Alert")<0)
            Alert_=!Alert_;
      if(Alert_)Alert_Clr=UpClr; else Alert_Clr=DnClr;*/

   DrawPanel();
//----
   return(0);
  }
//+------------------------------------------------------------------+
int DrawText(string name,datetime T,double P,string Text,int code=0,color Clr=Green,int Fsize=10,int Win=0)
  {
   if(name=="") name="Text_"+T;

   int Error=ObjectFind(name);// Запрос 
   if(Error!=Win)// Если объекта в ук. окне нет :(
     {
      ObjectCreate(name,OBJ_TEXT,Win,T,P);
     }

   ObjectSet(name,OBJPROP_TIME1,T);
   ObjectSet(name,OBJPROP_PRICE1,P);

   if(code==0)
      ObjectSetText(name,Text,Fsize,"Arial",Clr);
   else
      ObjectSetText(name,CharToStr(code),Fsize,"Wingdings",Clr);
   return(0);
  }
//--------------------------------------
void DrawPanel()
  {
   if(Y<0) Y=0;
//if(Y>(WindowPriceMax()-WindowPriceMin())/Point-H)
// Y=(WindowPriceMax()-WindowPriceMin())/Point-H;

// TimeX=Time[WindowFirstVisibleBar()]+X*Period()*60; 
// PriceY=WindowPriceMax()-Y*Point;

// DrawRect( Pref+"Rect", TimeX, PriceY, TimeX+TimeW ,PriceY-PriceH, RectClr, 1, "");

// DrawText( Pref+"Allow Hand Moving", TimeX+1*Period()*60, PriceY-1*Point, "", 73, HandClr );
//DrawText( Pref+"Unidirection Alert", TimeX+1*Period()*60, PriceY-(1+StepS)*Point, "", 37, Alert_Clr );

// DrawText( Pref+"AO", TimeX+4*Period()*60, PriceY-1*Point, "AO", 0,TxtClr );//0, 10, 0
//  DrawText( Pref+"AC", TimeX+4*Period()*60, PriceY-(1+StepS)*Point, "AC", 0,TxtClr );
// DrawText( Pref+"MACD", TimeX+3*Period()*60, PriceY-(1+2*StepS)*Point, "MACD", 0,TxtClr );

// DrawText( Pref+"AO direction", TimeX+8*Period()*60, PriceY-1*Point, "", codeAO, ClrAO );
// DrawText( Pref+"AC direction", TimeX+8*Period()*60, PriceY-(1+StepS)*Point, "", codeAC, ClrAC );
// DrawText( Pref+"MACD direction", TimeX+8*Period()*60, PriceY-(1+2*StepS)*Point, "", codeMACD, ClrMACD );

   DrawLabels(Pref+"AO",Corner,X+20,Y+10,symbol1,0,TxtClr,0,10);
   DrawLabels(Pref+"AO2",Corner,X+20,Y+60,symbol2,0,TxtClr,0,10);
   DrawLabels(Pref+"AO3",Corner,X+20,Y+110,symbol3,0,TxtClr,0,10);
   DrawLabels(Pref+"AO4",Corner,X+20,Y+160,symbol4,0,TxtClr,0,10);
   DrawLabels(Pref+"AO5",Corner,X+20,Y+210,symbol5,0,TxtClr,0,10);
   DrawLabels(Pref+"AO6",Corner,X+20,Y+260,symbol6,0,TxtClr,0,10);

//     DrawLabels(Pref+" ",  Corner, X, Y+RowStep, " ",0, TxtClr, 0, FSize);
//     DrawLabels(Pref+"MACD",  Corner, X, Y+RowStep*2, " ", 0,TxtClr, 0, FSize);

   DrawLabels(Pref+"AO direction",Corner,X-ColStep,Y,"bv",codeAO,ClrAO,0,30);
   DrawLabels(Pref+"AO2 direction",Corner,X-ColStep,Y+50,"",codeAO2,ClrAO2,0,30);
   DrawLabels(Pref+"AO3 direction",Corner,X-ColStep,Y+100,"",codeAO3,ClrAO3,0,30);
   DrawLabels(Pref+"AO4 direction",Corner,X-ColStep,Y+150,"",codeAO4,ClrAO4,0,30);
   DrawLabels(Pref+"AO5 direction",Corner,X-ColStep,Y+200,"",codeAO5,ClrAO5,0,30);
   DrawLabels(Pref+"AO6 direction",Corner,X-ColStep,Y+250,"",codeAO6,ClrAO6,0,30);

//     DrawLabels(Pref+"AC direction",  Corner, X-ColStep, Y+RowStep, "", codeAC, ClrAC, 0, FSize);
//     DrawLabels(Pref+"MACD direction",  Corner, X-ColStep, Y+RowStep*2, "", codeMACD, ClrMACD, 0, FSize);
  }
//---------------------------------
int DrawRect(string name,datetime T1,double P1,datetime T2,double P2,
             color Clr=Green,int Width=1,string Text="",int Win=0)
  {
   if(name=="") name="Text_"+T1;

   int Error=ObjectFind(name);// Запрос 
   if(Error!=Win)// Если объекта в ук. окне нет :(
     {
      ObjectCreate(name,OBJ_RECTANGLE,Win,T1,P1,T2,P2);//создание трендовой линии
     }

   ObjectSet(name,OBJPROP_TIME1,T1);
   ObjectSet(name,OBJPROP_PRICE1,P1);
   ObjectSet(name,OBJPROP_TIME2,T2);
   ObjectSet(name,OBJPROP_PRICE2,P2);
   ObjectSet(name,OBJPROP_BACK,false);
   ObjectSet(name,OBJPROP_STYLE,0);
   ObjectSet(name,OBJPROP_COLOR,Clr);
   ObjectSet(name,OBJPROP_WIDTH,Width);
   ObjectSetText(name,Text);
   return(0);
  }
///-----------------------
void Delete_My_Obj(string Prefix)
  {//Alert(ObjectsTotal());
   for(int k=ObjectsTotal()-1; k>=0; k--) // По количеству всех объектов 
     {
      string Obj_Name=ObjectName(k);   // Запрашиваем имя объекта
      string Head=StringSubstr(Obj_Name,0,StringLen(Prefix));// Извлекаем первые сим

      if(Head==Prefix)// Найден объект, ..
        {
         ObjectDelete(Obj_Name);
         //Alert(Head+";"+Prefix);
        }

     }
  }
///=====================
string PeriodToStr(int Per)
  {
   switch(Per) // Расчёт  для..     
     {                              // .. различных ТФ     
      case     1: return("M1"); break;// Таймфрейм М1      
      case     5: return("M5"); break;// Таймфрейм М5      
      case    15: return("M15"); break;// Таймфрейм М15      
      case    30: return("M30"); break;// Таймфрейм М30      
      case    60: return("H1"); break;// Таймфрейм H1      
      case   240: return("H4"); break;// Таймфрейм H4      
      case  1440: return("D1"); break;// Таймфрейм D1      
      case 10080: return("W1"); break;// Таймфрейм W1      
      case 43200: return("МN"); break;// Таймфрейм МN     
     }
   return("M1");
  }
//==================================
/*int CalculeH()
   {
      switch(Period())                 // Расчёт  для..     
      {                              // .. различных ТФ     
      case     1: return(15); break;// Таймфрейм М1      
      case     5: return(15); break;// Таймфрейм М5      
      case    15: return(30); break;// Таймфрейм М15      
      case    30: return(45); break;// Таймфрейм М30      
      case    60: return(60); break;// Таймфрейм H1      
      case   240: return(180); break;// Таймфрейм H4      
      case  1440: return(270); break;// Таймфрейм D1      
      case 10080: return(450); break;// Таймфрейм W1      
      case 43200: return(900); break;// Таймфрейм МN     
      }   
    }*/

int DrawLabels(string name,int corn,int X0,int Y0,string Text,int code=0,color Clr=Green,int Win=0,int FSize0=10)
  {
   int Error=ObjectFind(name);// Запрос 
   if(Error!=Win)// Если объекта в ук. окне нет :(
     {
      ObjectCreate(name,OBJ_LABEL,Win,0,0); // Создание объекта
     }

   ObjectSet(name,OBJPROP_CORNER,corn);     // Привязка к углу   
   ObjectSet(name,OBJPROP_XDISTANCE,X0);  // Координата Х   
   ObjectSet(name,OBJPROP_YDISTANCE,Y0);// Координата Y   
   ObjectSetText(name,Text,FSize0,"Arial",Clr);
   if(code==0)
      ObjectSetText(name,Text,FSize0,"Arial",Clr);
   else
      ObjectSetText(name,CharToStr(code),FSize0,"Wingdings",Clr);
   return(0);
  }
//+------------------------------------------------------------------+
