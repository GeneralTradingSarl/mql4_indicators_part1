//+------------------------------------------------------------------+
//|                                                         DUCT.mq4 |
//|                                               Yuriy Tokman (YTG) |
//|                                               http://ytg.com.ua/ |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman (YTG)"
#property link      "http://ytg.com.ua/"
#property version   "1.00"
#property strict
#property indicator_chart_window

#property indicator_buffers 1 
#property indicator_color1 Red 

//---- input parameters
input ENUM_TIMEFRAMES TimeFrame    = 60;
input int             Needed_Bars   = 0;
input int             Clamping_Bars = 0;
input double          Koeff_Flat    = 0.25;
input color           collir        = Lime;

double ExtMapBuffer1[];
int Current_Bar=0,shift_b=0,trend,flat,i=0,Count_Bars=300,clamping_bars=0,Bars_1=-1,Bars_2=-1,Up_vs_Down=0, Time_Frame;
double Price_1=0,Price_2=0,Price_3=0,Steps=0,price_b=0;
datetime Time_1,Time_2;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,164);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexEmptyValue(0,0.0);
//---
   return(INIT_SUCCEEDED);
  }
//----
void OnDeinit(const int reason){ DelObject();}
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
//---
   int limit,y=0;
   int counted_bars=prev_calculated;
   limit=Bars-counted_bars;

   if((Needed_Bars==0) || (Bars<Needed_Bars)) Count_Bars=Bars; else Count_Bars=Needed_Bars; //Count_Bars-количество обсчитываемых баров 

   Time_Frame = (int)TimeFrame;
   if(Period()<Time_Frame)Time_Frame=Period();

   if(Clamping_Bars>0) clamping_bars=Clamping_Bars;
   else
     {
      switch(Time_Frame)
        {
         case 1: clamping_bars=12;  break;
         case 5: clamping_bars=48; break;
         case 15: clamping_bars=24; break;
         case 30: clamping_bars=24; break;
         case 60: clamping_bars=12; break;
         case 240: clamping_bars=15; break;
         case 1440: clamping_bars=10; break;
         case 10080: clamping_bars=6; break;
         default: DelObject(); return(-1); break;
        }
     }

   Current_Bar=2;
   Bars_1=y-1; Bars_2=y-1; Up_vs_Down=0;
   while(((Bars_1==-1) || (Bars_2==-1)) && (Current_Bar<Count_Bars))
     {
      if((Up_vs_Down<1) && (Current_Bar==iLowest(Symbol(),Time_Frame,MODE_LOW,clamping_bars*2+1,Current_Bar-clamping_bars)))
        {
         if(Up_vs_Down==0) {Up_vs_Down=-1; Bars_1=Current_Bar; Price_1=iLow(Symbol(),Time_Frame,Bars_1);}
         else  Bars_2=Current_Bar; Price_2=iLow(Symbol(),Time_Frame,Bars_2);
        }
      if((Up_vs_Down>-1) && (Current_Bar==iHighest(Symbol(),Time_Frame,MODE_HIGH,clamping_bars*2+1,Current_Bar-clamping_bars)))
        {
         if(Up_vs_Down==0) {Up_vs_Down=1; Bars_1=Current_Bar; Price_1=iHigh(Symbol(),Time_Frame,Bars_1);}
         else  Bars_2=Current_Bar; Price_2=iHigh(Symbol(),Time_Frame,Bars_2);
        }
      Current_Bar++;
     }
   if((Bars_1==-1) || (Bars_2==-1)) { DelObject(); return(-1); }
   Steps=(Price_2-Price_1)/(Bars_2-Bars_1);
   Price_1=Price_1-Bars_1*Steps; Bars_1=0;

   shift_b=0; price_b=0;
   if(Up_vs_Down==1)
     {
      Price_3=iLow(Symbol(),Time_Frame,2)-2*Steps;
      for(i=3;i<=Bars_2;i++)
        {
         if(iLow(Symbol(),Time_Frame,i)<Price_3+Steps*i) Price_3=iLow(Symbol(),Time_Frame,i)-i*Steps;
        }
      if(iLow(Symbol(),Time_Frame,0)<Price_3)
        {
         shift_b=0;
         price_b=Price_3;
        }
      if(iLow(Symbol(),Time_Frame,1)<Price_3+Steps)
        {
         shift_b=1;
         price_b=Price_3+Steps;
        }
      if(iHigh(Symbol(),Time_Frame,0)>Price_1)
        {
         shift_b=0;
         price_b=Price_1;
        }
      if(iHigh(Symbol(),Time_Frame,1)>Price_1+Steps)
        {
         shift_b=1;
         price_b=Price_1+Steps;
        }
     }
   else
     {
      Price_3=iHigh(Symbol(),Time_Frame,2)-2*Steps;
      for(i=3;i<=Bars_2;i++)
        {
         if(iHigh(Symbol(),Time_Frame,i)>Price_3+Steps*i) Price_3=iHigh(Symbol(),Time_Frame,i)-i*Steps;
        }
      if(iLow(Symbol(),Time_Frame,0)<Price_1)
        {
         shift_b=0;
         price_b=Price_1;
        }
      if(iLow(Symbol(),Time_Frame,1)<Price_1+Steps)
        {
         shift_b=1;
         price_b=Price_1+Steps;
        }
      if(iHigh(Symbol(),Time_Frame,0)>Price_3)
        {
         shift_b=0;
         price_b=Price_3;
        }
      if(iHigh(Symbol(),Time_Frame,1)>Price_3+Steps)
        {
         shift_b=1;
         price_b=Price_3+Steps;
        }
     }

   Price_2=Price_1+Count_Bars*Steps;
   Time_1=Time[iBarShift(Symbol(),0,iTime(Symbol(),Time_Frame,Bars_1))];
   Time_2=Time[iBarShift(Symbol(),0,iTime(Symbol(),Time_Frame,Count_Bars))];

   if(price_b!=0) ExtMapBuffer1[shift_b]=price_b;
   if(Steps>0) trend=-1; else trend=1;

   if(MathAbs(Steps*20)>=2*iATR(Symbol(),Time_Frame,40,0)*Koeff_Flat) flat=0; else flat=1;

   if(ObjectFind("TrendLine1_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0))==-1)
     {
      ObjectCreate("TrendLine1_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJ_TREND,0,Time_2,Price_3+Steps*Count_Bars,Time_1,Price_3);
      ObjectSet("TrendLine1_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJPROP_COLOR,collir);
      ObjectSet("TrendLine1_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJPROP_WIDTH,2);
     }
   else
     {
      ObjectSet("TrendLine1_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJPROP_TIME1,Time_2);
      ObjectSet("TrendLine1_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJPROP_PRICE1,Price_3+Steps*Count_Bars);
      ObjectSet("TrendLine1_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJPROP_TIME2,Time_1);
      ObjectSet("TrendLine1_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJPROP_PRICE2,Price_3);
      ObjectSet("TrendLine1_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJPROP_COLOR,collir);
      ObjectSet("TrendLine1_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJPROP_WIDTH,2);
     }

   if(ObjectFind("TrendLine2_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0))==-1)
     {
      ObjectCreate("TrendLine2_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJ_TREND,0,Time_2,Price_2,Time_1,Price_1);
      ObjectSet("TrendLine2_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJPROP_COLOR,collir);
      ObjectSet("TrendLine2_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJPROP_WIDTH,2);
     }
   else
     {
      ObjectSet("TrendLine2_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJPROP_TIME1,Time_2);
      ObjectSet("TrendLine2_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJPROP_PRICE1,Price_2);
      ObjectSet("TrendLine2_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJPROP_TIME2,Time_1);
      ObjectSet("TrendLine2_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJPROP_PRICE2,Price_1);
      ObjectSet("TrendLine2_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJPROP_COLOR,collir);
      ObjectSet("TrendLine2_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJPROP_WIDTH,2);
     }

   if(ObjectFind("CenterLine_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0))==-1)
     {
      ObjectCreate("CenterLine_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJ_TREND,0,Time_2,(Price_2+Price_3+Steps*Count_Bars)/2,Time_1,(Price_1+Price_3)/2);
      ObjectSet("CenterLine_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJPROP_COLOR,collir);
      ObjectSet("CenterLine_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJPROP_WIDTH,1);
      ObjectSet("CenterLine_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJPROP_STYLE,STYLE_DOT);
     }
   else
     {
      ObjectSet("CenterLine_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJPROP_TIME1,Time_2);
      ObjectSet("CenterLine_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJPROP_PRICE1,(Price_2+Price_3+Steps*Count_Bars)/2);
      ObjectSet("CenterLine_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJPROP_TIME2,Time_1);
      ObjectSet("CenterLine_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJPROP_PRICE2,(Price_1+Price_3)/2);
      ObjectSet("CenterLine_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJPROP_WIDTH,1);
      ObjectSet("CenterLine_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJPROP_STYLE,STYLE_DOT);
      ObjectSet("CenterLine_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),OBJPROP_COLOR,collir);
     }

   if(flat==1)
     {
      if(Price_3+Steps*Count_Bars>Price_2)
        {
         ObjectSetText("TrendLine1_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),"Sell");
         ObjectSetText("TrendLine2_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),"Buy");
        }
      else
        {
         ObjectSetText("TrendLine2_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),"Sell");
         ObjectSetText("TrendLine1_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),"Buy");
        }
     }
   else
     {
      if((Price_3+Steps*Count_Bars>Price_2) && (trend==-1))
        {
         ObjectSetText("TrendLine1_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),"Sell");
         ObjectSetText("TrendLine2_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),"Take");
        }
      if((Price_3+Steps*Count_Bars>Price_2) && (trend==1))
        {
         ObjectSetText("TrendLine1_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),"Take");
         ObjectSetText("TrendLine2_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),"Buy");
        }
      if((Price_3+Steps*Count_Bars<Price_2) && (trend==-1))
        {
         ObjectSetText("TrendLine2_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),"Sell");
         ObjectSetText("TrendLine1_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),"Take");
        }
      if((Price_3+Steps*Count_Bars<Price_2) && (trend==1))
        {
         ObjectSetText("TrendLine2_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),"Take");
         ObjectSetText("TrendLine1_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0),"Buy");
        }
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
void DelObject()
  {

   ObjectDelete("TrendLine1_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0));
   ObjectDelete("TrendLine2_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0));
   ObjectDelete("CenterLine_"+DoubleToStr(Time_Frame,0)+DoubleToStr(Clamping_Bars,0));
  }
//+------------------------------------------------------------------+
