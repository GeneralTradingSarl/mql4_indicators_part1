//+------------------------------------------------------------------+
//|                                                        Канал.mq4 |
//|                                                       Langolier. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Langolier."
#property link      "http://www.metaquotes.net"
//----
#property indicator_chart_window
#property indicator_buffers 6
#property indicator_color1 Red
double ExtMapBuffer1[];
double LBuffer[];
double HBuffer[];
double MBuffer[];
double CBuffer[];
double SBuffer[];
int B4,B5;
//---- input parameters 
extern int AllBars=240;
extern int BarsForFract=0;
int CurrentBar=0;
double Step=0;
int B1=-1,B2=-1;
int UpDown=0;
double P1=0,P2=0,PP=0;
int i=0,AB=300,BFF=0;
int ishift=0;
double iprice=0;
datetime T1,T2;
//----
double OldChannelWidth,OldSlopeAngle;
int alertTag;
//----
extern int ChannelAlert=50;
extern int SlopeAlert=25;
extern bool ChannelTalk=true;
//----
int firsttime=0;
//+------------------------------------------------------------------+ 
//| Custom indicator initialization function                         | 
//+------------------------------------------------------------------+ 
int init()
  {
//---- indicators 
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,164);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexEmptyValue(0,0.0);
   //
   SetIndexBuffer(1,LBuffer);
   SetIndexBuffer(2,HBuffer);
   SetIndexBuffer(3,MBuffer);
   SetIndexBuffer(4,CBuffer);
   SetIndexBuffer(5,SBuffer);
//---- 
   return(0);
  }
//+------------------------------------------------------------------+ 
//| Custor indicator deinitialization function                       | 
//+------------------------------------------------------------------+ 
int deinit()
  {
//---- 
//---- 
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DelObj()
  {
   ObjectDelete("TL1");
   ObjectDelete("TL2");
   ObjectDelete("MIDL");
  }
//+------------------------------------------------------------------+ 
//| Custom indicator iteration function                              |  
//+------------------------------------------------------------------+ 
int start()
  {
   int counted_bars=IndicatorCounted();
   int X=(Ask-P1);
   int X2=(Bid-P2);
   string symbolTxt;
   string PeriodTxt;
   string WhatTxt;
   if (Symbol()=="EURUSD") { symbolTxt="Euro Dollar"; }
   if (Symbol()=="EURJPY") { symbolTxt="Euro Yen "; }
   if (Symbol()=="EURAUD") { symbolTxt="Euro Aussie "; }
   if (Symbol()=="EURCAD") { symbolTxt="Euro Canadian"; }
   if (Symbol()=="EURCHF") { symbolTxt="Euro Swiss"; }
   if (Symbol()=="GBPUSD") { symbolTxt="Cable Dollar"; }
   if (Symbol()=="GBPJPY") { symbolTxt="Cable Yen "; }
   if (Symbol()=="GBPCHF") { symbolTxt="Cable Swiss"; }
   if (Symbol()=="AUDUSD") { symbolTxt="Aussie"; }
   if (Symbol()=="USDCHF") { symbolTxt="Swiss Dollar"; }
   if (Symbol()=="USDCAD") { symbolTxt="Canada"; }
   if (Symbol()=="USDJPY") { symbolTxt="Yen Dollar"; }
   if (Symbol()=="CHFJPY") { symbolTxt="Swiss Yen "; }
   if (Symbol()=="GOLD") { symbolTxt="Gold"; }
   if (Period()==1){PeriodTxt= "One minute";}
   if (Period()==5){PeriodTxt= "Five minutes";}
   if (Period()==15){PeriodTxt= "Fifteen minutes"; }
   if (Period()==30){PeriodTxt= "Thirty minutes"; }
   if (Period()==60){PeriodTxt= "One hour"; }
   if (Period()==240){PeriodTxt= "Four hours";}
   if (Period()==1440){PeriodTxt= "Day";}
   if (Period()==10080){PeriodTxt= "Week";}
//---- 
   if ((AllBars==0) || (Bars<AllBars)) AB=Bars; else AB=AllBars; //AB-количество обсчитываемых баров 
   if (BarsForFract>0)
      BFF=BarsForFract;
   else
     {
      switch(Period())
        {
         case 1: BFF=12; break;
         case 5: BFF=48; break;
         case 15: BFF=24; break;
         case 30: BFF=24; break;
         case 60: BFF=12; break;
         case 240: BFF=15; break;
         case 1440: BFF=10; break;
         case 10080: BFF=6; break;
         default: DelObj(); return(-1); break;
            X=P1;
        }
     }
   CurrentBar=2; //считаем с третьего бара, чтобы фрактал "закрепился 
   B1=-1; B2=-1; UpDown=0;
   while(((B1==-1) || (B2==-1)) && (CurrentBar<AB))
     {
      //UpDown=1 значит первый фрактал найден сверху, UpDown=-1 значит первый фрактал 
      //найден снизу, UpDown=0 значит фрактал ещё не найден. 
      //В1 и В2 - номера баров с фракталами, через них строим опорную линию. 
      //Р1 и Р2 - соответственно цены через которые будем линию проводить 
      if((UpDown<1) && (CurrentBar==Lowest(Symbol(),Period(),MODE_LOW,BFF*2+1,CurrentBar-BFF)))
        {
         if(UpDown==0) { UpDown=-1; B1=CurrentBar; P1=Low[B1]; }
         else { B2=CurrentBar; P2=Low[B2];}
        }
      if((UpDown>-1) && (CurrentBar==Highest(Symbol(),Period(),MODE_HIGH,BFF*2+1,CurrentBar-BFF)))
        {
         if(UpDown==0) { UpDown=1; B1=CurrentBar; P1=High[B1]; }
         else { B2=CurrentBar; P2=High[B2]; }
        }
      CurrentBar++;
     }
   if((B1==-1) || (B2==-1))
   {DelObj(); return(-1);} // Значит не нашли фракталов среди 300 баров  
   Step=(P2-P1)/(B2-B1);//Вычислили шаг, если он положительный, то канал нисходящий 
   P1=P1-B1*Step; B1=0;//переставляем цену и первый бар к нулю 
   //А теперь опорную точку противоположной линии канала. 
   ishift=0; iprice=0;
   if(UpDown==1)
     {
      PP=Low[2]-2*Step;
      for(i=3;i<=B2;i++)
        {
         if(Low[i]<PP+Step*i)
         { PP=Low[i]-i*Step; }
        }
      if(Low[0]<PP)
      {ishift=0; iprice=PP;}
      if(Low[1]<PP+Step)
      {ishift=1; iprice=PP+Step;}
      if(High[0]>P1)
      {ishift=0; iprice=P1;}
      if(High[1]>P1+Step)
      {ishift=1; iprice=P1+Step;}
     }
   else
     {
      PP=High[2]-2*Step;
      for(i=3;i<=B2;i++)
        {
         if(High[i]>PP+Step*i)
         { PP=High[i]-i*Step;}
        }
      if(Low[0]<P1)
      {ishift=0; iprice=P1;}
      if(Low[1]<P1+Step)
      {ishift=1; iprice=P1+Step;}
      if(High[0]>PP)
      {ishift=0; iprice=PP;}
      if(High[1]>PP+Step)
      {ishift=1; iprice=PP+Step;}
     }
   //Теперь переставим конечную цену и бар на АВ, чтобы линии канала рисовались подлиннее 
   P2=P1+AB*Step;
   T1=Time[B1];
   T2=Time[AB];
   //Если не было пересечения канала, то 0, иначе ставим псису. 
   if(iprice!=0)
      ExtMapBuffer1[ishift]=iprice;
   DelObj();
   double ChannelWidth=MathAbs(PP - P1)/Point;
   double SlopeAngle=MathFloor((-Step/Point)*100);
     if(Period()==1)
     {
      ObjectCreate("M1-TL1",OBJ_TREND,0,T2,PP+Step*AB,T1,PP);
      if(ChannelWidth>=ChannelAlert) {ObjectSet("M1-TL1",OBJPROP_COLOR,Navy);}
      else 
      {
         ObjectSet("M1-TL1",OBJPROP_COLOR,Red); 
      }
      ObjectSet("M1-TL1",OBJPROP_WIDTH,1);
      ObjectSet("M1-TL1",OBJPROP_STYLE,STYLE_SOLID);
      ObjectCreate("M1-TL2",OBJ_TREND,0,T2,P2,T1,P1);
      if(ChannelWidth>=ChannelAlert) 
      {
         ObjectSet("M1-TL2",OBJPROP_COLOR,Navy); 
      }
      else
      {
         ObjectSet("M1-TL2",OBJPROP_COLOR,Red);
      }
      ObjectSet("M1-TL2",OBJPROP_WIDTH,1);
      ObjectSet("M1-TL2",OBJPROP_STYLE,STYLE_SOLID);
      ObjectCreate("M1-MIDL",OBJ_TREND,0,T2,(P2+PP+Step*AB)/2,T1,(P1+PP)/2);
      if(ChannelWidth>=ChannelAlert && MathAbs(SlopeAngle)>=SlopeAlert) 
      {
         ObjectSet("M1-MIDL",OBJPROP_COLOR,Navy); 
      }
      else
      {
         ObjectSet("M1-MIDL",OBJPROP_COLOR,Red);
      }
         ObjectSet("M1-MIDL",OBJPROP_WIDTH,1);
         ObjectSet("M1-MIDL",OBJPROP_STYLE,STYLE_DOT);
      }
     if(Period()==5)
      {
      ObjectCreate("M5-TL1",OBJ_TREND,0,T2,PP+Step*AB,T1,PP);
      if(ChannelWidth>=ChannelAlert) 
      {
         ObjectSet("M5-TL1",OBJPROP_COLOR,SeaGreen);
      }
      else 
      {
         ObjectSet("M5-TL1",OBJPROP_COLOR,Red); 
      }
      ObjectSet("M5-TL1",OBJPROP_WIDTH,1);
      ObjectSet("M5-TL1",OBJPROP_STYLE,STYLE_SOLID);
      ObjectCreate("M5-TL2",OBJ_TREND,0,T2,P2,T1,P1);
      if(ChannelWidth>=ChannelAlert) 
      {
         ObjectSet("M5-TL2",OBJPROP_COLOR,SeaGreen); 
      }
      else
      {
         ObjectSet("M5-TL2",OBJPROP_COLOR,Red);
      }
      ObjectSet("M5-TL2",OBJPROP_WIDTH,1);
      ObjectSet("M5-TL2",OBJPROP_STYLE,STYLE_SOLID);
      ObjectCreate("M5-MIDL",OBJ_TREND,0,T2,(P2+PP+Step*AB)/2,T1,(P1+PP)/2);
      if(ChannelWidth>=ChannelAlert && MathAbs(SlopeAngle)>=SlopeAlert) 
      {
         ObjectSet("M5-MIDL",OBJPROP_COLOR,SeaGreen); 
      }
      else
      {
         ObjectSet("M5-MIDL",OBJPROP_COLOR,Red);
      } 
      ObjectSet("M5-MIDL",OBJPROP_WIDTH,1);
      ObjectSet("M5-MIDL",OBJPROP_STYLE,STYLE_DOT);
      }
     if(Period()==15)
     {
      ObjectCreate("M15-TL1",OBJ_TREND,0,T2,PP+Step*AB,T1,PP);
      if(ChannelWidth>=ChannelAlert) 
      {
         ObjectSet("M15-TL1",OBJPROP_COLOR,DarkOrange);
      }
      else 
      {
         ObjectSet("M15-TL1",OBJPROP_COLOR,Red); 
      }
      ObjectSet("M15-TL1",OBJPROP_WIDTH,1);
      ObjectSet("M15-TL1",OBJPROP_STYLE,STYLE_SOLID);
      ObjectCreate("M15-TL2",OBJ_TREND,0,T2,P2,T1,P1);
      if(ChannelWidth>=ChannelAlert) 
      {
         ObjectSet("M15-TL2",OBJPROP_COLOR,DarkOrange); 
      }
      else
      {  
         ObjectSet("M15-TL2",OBJPROP_COLOR,Red);
      }
      ObjectSet("M15-TL2",OBJPROP_WIDTH,1);
      ObjectSet("M15-TL2",OBJPROP_STYLE,STYLE_SOLID);
      ObjectCreate("M15-MIDL",OBJ_TREND,0,T2,(P2+PP+Step*AB)/2,T1,(P1+PP)/2);
      if(ChannelWidth>=ChannelAlert && MathAbs(SlopeAngle)>=SlopeAlert) 
      {
         ObjectSet("M15-MIDL",OBJPROP_COLOR,DarkOrange); 
      }
      else
      {
         ObjectSet("M15-MIDL",OBJPROP_COLOR,Red);
      }
      ObjectSet("M15-MIDL",OBJPROP_WIDTH,1);
      ObjectSet("M15-MIDL",OBJPROP_STYLE,STYLE_DOT);
     }
     if(Period()==30)
     {
      ObjectCreate("M30-TL1",OBJ_TREND,0,T2,PP+Step*AB,T1,PP);
      if(ChannelWidth>=ChannelAlert) 
      {  
         ObjectSet("M30-TL1",OBJPROP_COLOR,Bisque);
      }
      else 
      {  
         ObjectSet("M30-TL1",OBJPROP_COLOR,Red); 
      }
      ObjectSet("M30-TL1",OBJPROP_WIDTH,1);
      ObjectSet("M30-TL1",OBJPROP_STYLE,STYLE_SOLID);
      ObjectCreate("M30-TL2",OBJ_TREND,0,T2,P2,T1,P1);
      if(ChannelWidth>=ChannelAlert) 
      {
         ObjectSet("M30-TL2",OBJPROP_COLOR,Bisque); 
      }
      else
      {  
         ObjectSet("M30-TL2",OBJPROP_COLOR,Red);
      }
      ObjectSet("M30-TL2",OBJPROP_WIDTH,1);
      ObjectSet("M30-TL2",OBJPROP_STYLE,STYLE_SOLID);
      ObjectCreate("M30-MIDL",OBJ_TREND,0,T2,(P2+PP+Step*AB)/2,T1,(P1+PP)/2);
      if(ChannelWidth>=ChannelAlert && MathAbs(SlopeAngle)>=SlopeAlert) 
      {
         ObjectSet("M30-MIDL",OBJPROP_COLOR,Bisque); 
      }
      else
      {
        ObjectSet("M30-MIDL",OBJPROP_COLOR,Red);
      }
      ObjectSet("M30-MIDL",OBJPROP_WIDTH,1);
      ObjectSet("M30-MIDL",OBJPROP_STYLE,STYLE_DOT);
     }
     if(Period()==60)
     {
      ObjectCreate("H1-TL1",OBJ_TREND,0,T2,PP+Step*AB,T1,PP);
      if(ChannelWidth>=ChannelAlert) 
      {
         ObjectSet("H1-TL1",OBJPROP_COLOR,Yellow);
      }
      else 
      {  
         ObjectSet("H1-TL1",OBJPROP_COLOR,Red); 
      }
      ObjectSet("H1-TL1",OBJPROP_WIDTH,1);
      ObjectSet("H1-TL1",OBJPROP_STYLE,STYLE_SOLID);
      ObjectCreate("H1-TL2",OBJ_TREND,0,T2,P2,T1,P1);
      if(ChannelWidth>=ChannelAlert) 
      {
         ObjectSet("H1-TL2",OBJPROP_COLOR,Yellow); 
      }
      else
      {
         ObjectSet("H1-TL2",OBJPROP_COLOR,Red);
      }
      ObjectSet("H1-TL2",OBJPROP_WIDTH,1);
      ObjectSet("H1-TL2",OBJPROP_STYLE,STYLE_SOLID);
      ObjectCreate("H1-MIDL",OBJ_TREND,0,T2,(P2+PP+Step*AB)/2,T1,(P1+PP)/2);
      if(ChannelWidth>=ChannelAlert && MathAbs(SlopeAngle)>=SlopeAlert) 
      {
         ObjectSet("H1-MIDL",OBJPROP_COLOR,Yellow); 
      }
      else
      {
         ObjectSet("H1-MIDL",OBJPROP_COLOR,Red);
      }
      ObjectSet("H1-MIDL",OBJPROP_WIDTH,1);
      ObjectSet("H1-MIDL",OBJPROP_STYLE,STYLE_DOT);
     }
     if(Period()==240)
     {
      ObjectCreate("H4-TL1",OBJ_CHANNEL,0,T2,PP+Step*AB,T1,PP);
      if(ChannelWidth>=ChannelAlert) 
      {
         ObjectSet("H4-TL1",OBJPROP_COLOR,LightSkyBlue);
      }
      else 
      {
         ObjectSet("H4-TL1",OBJPROP_COLOR,Red); 
      }
      ObjectSet("H4-TL1",OBJPROP_WIDTH,1);
      ObjectSet("H4-TL1",OBJPROP_STYLE,STYLE_SOLID);
      ObjectCreate("H4-TL2",OBJ_CHANNEL,0,T2,P2,T1,P1);
      if(ChannelWidth>=ChannelAlert) 
      {
         ObjectSet("H4-TL2",OBJPROP_COLOR,LightSkyBlue); 
      }
      else
      {
         ObjectSet("H4-TL2",OBJPROP_COLOR,Red);
      }
      ObjectSet("H4-TL2",OBJPROP_WIDTH,1);
      ObjectSet("H4-TL2",OBJPROP_STYLE,STYLE_SOLID);
      ObjectCreate("H4-MIDL",OBJ_CHANNEL,0,T2,(P2+PP+Step*AB)/2,T1,(P1+PP)/2);
      if(ChannelWidth>=ChannelAlert && MathAbs(SlopeAngle)>=SlopeAlert) 
      {
         ObjectSet("H4-MIDL",OBJPROP_COLOR,LightSkyBlue); 
      }
      else
      {
      ObjectSet("H4-MIDL",OBJPROP_COLOR,Red);
      }
      ObjectSet("H4-MIDL",OBJPROP_WIDTH,1);
      ObjectSet("H4-MIDL",OBJPROP_STYLE,STYLE_DOT);
     }
     if(Period()==1440)
     {
      ObjectCreate("D1-TL1",OBJ_TREND,0,T2,PP+Step*AB,T1,PP);
      if(ChannelWidth>=ChannelAlert) 
      {
         ObjectSet("D1-TL1",OBJPROP_COLOR,Ivory);
      }
      else 
      {
         ObjectSet("D1-TL1",OBJPROP_COLOR,Red); 
      }
      ObjectSet("D1-TL1",OBJPROP_WIDTH,1);
      ObjectSet("D1-TL1",OBJPROP_STYLE,STYLE_SOLID);
      ObjectCreate("D1-TL2",OBJ_TREND,0,T2,P2,T1,P1);
      if(ChannelWidth>=ChannelAlert) 
      {
         ObjectSet("D1-TL2",OBJPROP_COLOR,Ivory); 
      }
      else
      {
         ObjectSet("D1-TL2",OBJPROP_COLOR,Red);
      }
      ObjectSet("D1-TL2",OBJPROP_WIDTH,1);
      ObjectSet("D1-TL2",OBJPROP_STYLE,STYLE_SOLID);
      ObjectCreate("D1-MIDL",OBJ_TREND,0,T2,(P2+PP+Step*AB)/2,T1,(P1+PP)/2);
      if(ChannelWidth>=ChannelAlert && MathAbs(SlopeAngle)>=SlopeAlert) 
      {
         ObjectSet("D1-MIDL",OBJPROP_COLOR,Ivory); 
      }
      else
      {
         ObjectSet("D1-MIDL",OBJPROP_COLOR,Red);
      }
      ObjectSet("D1-MIDL",OBJPROP_WIDTH,1);
      ObjectSet("D1-MIDL",OBJPROP_STYLE,STYLE_DOT);
     }
     if(Period()==10080)
     {
      ObjectCreate("W1-TL1",OBJ_TREND,0,T2,PP+Step*AB,T1,PP);
      if(ChannelWidth>=ChannelAlert) 
      {
         ObjectSet("W1-TL1",OBJPROP_COLOR,Lime);
      }
      else 
      {
         ObjectSet("W1-TL1",OBJPROP_COLOR,Red); 
      }
      ObjectSet("W1-TL1",OBJPROP_WIDTH,1);
      ObjectSet("W1-TL1",OBJPROP_STYLE,STYLE_SOLID);
      ObjectCreate("W1-TL2",OBJ_TREND,0,T2,P2,T1,P1);
      if(ChannelWidth>=ChannelAlert) 
      {
         ObjectSet("W1-TL2",OBJPROP_COLOR,Lime); 
      }
      else
      {
         ObjectSet("W1-TL2",OBJPROP_COLOR,Red);
      }
      ObjectSet("W1-TL2",OBJPROP_WIDTH,1);
      ObjectSet("W1-TL2",OBJPROP_STYLE,STYLE_SOLID);
      ObjectCreate("W1-MIDL",OBJ_TREND,0,T2,(P2+PP+Step*AB)/2,T1,(P1+PP)/2);
      if(ChannelWidth>=ChannelAlert && MathAbs(SlopeAngle)>=SlopeAlert) 
      {
         ObjectSet("W1-MIDL",OBJPROP_COLOR,Lime); 
      }
      else
      {  
         ObjectSet("W1-MIDL",OBJPROP_COLOR,Red);
      }
      ObjectSet("W1-MIDL",OBJPROP_WIDTH,1);
      ObjectSet("W1-MIDL",OBJPROP_STYLE,STYLE_DOT);
     }
   GlobalVariableSet("ST1",T2);//ST1,B4
   GlobalVariableSet("ST2",T1);//ST2,B5
   GlobalVariableSet("Bar1",B4);
   GlobalVariableSet("Bar2",B5);
   ObjectCreate("Dot1",OBJ_ARROW,0,T1,(P1+PP)/2);
   ObjectSet("Dot1",   SYMBOL_CHECKSIGN,Gold);
//---- 
   WhatTxt="Change";
   if (OldChannelWidth<ChannelWidth) WhatTxt="is widening";
   if (OldChannelWidth>ChannelWidth) WhatTxt="is narrowing";
   if (OldSlopeAngle<0 && SlopeAngle>0 )WhatTxt="Changed direction to up";
   if (OldSlopeAngle>0 && SlopeAngle<0 )WhatTxt="Changed direction to down";
   if(firsttime && ChannelTalk && alertTag!=Time[0]&& OldChannelWidth!=ChannelWidth || OldSlopeAngle!=SlopeAngle)
     {
      Alert(Symbol()," ",Period(),"Shi Channel Change");
      //SpeechText("chee channel"+ WhatTxt+" "+symbolTxt+" "+PeriodTxt);
      alertTag=Time[0];
     }
   OldChannelWidth=ChannelWidth;
   OldSlopeAngle=SlopeAngle;
   firsttime=firsttime+1;
     if (SlopeAngle<0)
     {
      Comment("\n"," ",Symbol()," - M",Period()," (Bid = ",Bid," Ask = ",Ask,")","\n"," Верхняя граница = ",PP,"\n"," Середина = ",(P1+PP)/2,"\n"," Нижняя граница = ",P1,"\n",
              " Размер канала = ", DoubleToStr(ChannelWidth,0),"\n"," Наклон = ", DoubleToStr(SlopeAngle,0));
     }
     if (SlopeAngle>0)
     {
      Comment("\n"," ",Symbol()," - M",Period()," (Bid = ",Bid," Ask = ",Ask,")","\n"," Верхняя граница = ",P1,"\n"," Середина = ",(P1+PP)/2,"\n"," Нижняя граница = ",PP,"\n",
              " Размер канала = ", DoubleToStr(ChannelWidth,0),"\n"," Наклон = ", DoubleToStr(SlopeAngle,0));
     }
   LBuffer[B1]=P1;
   HBuffer[B1]=PP;
   MBuffer[B1]=(P1+PP)/2;
   CBuffer[B1]=ChannelWidth;
   SBuffer[B1]=SlopeAngle;
//----
   return(0);
  }
//+------------------------------------------------------------------+