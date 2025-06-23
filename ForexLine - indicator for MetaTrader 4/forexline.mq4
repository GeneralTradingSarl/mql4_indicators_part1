//+------------------------------------------------------------------+
//|                                                    ForexLine.mq4 |
//|                              Copyright 2015,  3rjfx ~ 22/03/2015 |
//|                              https://www.mql5.com/en/users/3rjfx |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015,  3rjfx ~ 22/03/2015"
#property link      "https://www.mql5.com/en/users/3rjfx"
#property version   "1.00"
#property strict
//--
#include <MovingAverages.mqh>
//-
#property indicator_chart_window
//-
#property indicator_buffers 6
#property indicator_color1 clrNONE
#property indicator_color2 clrNONE
#property indicator_color3 clrNONE
#property indicator_color4 clrNONE
#property indicator_color5 clrBlue
#property indicator_color6 clrWhite
//--
#property indicator_width5 3
#property indicator_width6 3
//--
input color ForexLineColor1 = clrBlue;  // Line Up
input color ForexLineColor2 = clrWhite;  // Line Down
//-- buffers
double lwma05Buffers[];
double lwma10Buffers[];
double lwma20Buffers[];
double line20Buffers[];
double uplineBuffers[];
double dnlineBuffers[];
//-
int mafast=5;
int maslow=10;
int mdma20=20;
int digit;
//-
void EventSetTimer();
//--
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(void)
  {
   //-- Checking the Digits Point
   if(Digits>=3) {digit=Digits;}
   else {digit=Digits+1;}
   IndicatorDigits(digit);
   //--
//--- indicator buffers mapping
   IndicatorBuffers(6);
   //--
   SetIndexBuffer(0,lwma05Buffers);
   SetIndexBuffer(1,lwma10Buffers);
   SetIndexBuffer(2,lwma20Buffers);
   SetIndexBuffer(3,line20Buffers);
   SetIndexBuffer(4,uplineBuffers);
   SetIndexBuffer(5,dnlineBuffers);
//--- indicator lines
   SetIndexStyle(0,DRAW_NONE);
   SetIndexStyle(1,DRAW_NONE);
   SetIndexStyle(2,DRAW_NONE);
   SetIndexStyle(3,DRAW_NONE);
   SetIndexStyle(4,DRAW_LINE,EMPTY,3,ForexLineColor1);
   SetIndexStyle(5,DRAW_LINE,EMPTY,3,ForexLineColor2);
   //--- name for DataWindow and indicator subwindow label
   SetIndexLabel(0,NULL);
   SetIndexLabel(1,NULL);
   SetIndexLabel(2,NULL);
   SetIndexLabel(3,NULL);
   SetIndexLabel(4,"LinesUp");
   SetIndexLabel(5,"LinesDn");
   //--
   SetIndexDrawBegin(3,maslow);
   SetIndexDrawBegin(4,maslow);
   //--
   IndicatorShortName("FXLine");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//----  
   //--
   EventKillTimer();
   GlobalVariablesDeleteAll();   
//----
   return;
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
//---
   int i,limit;
   bool lup,ldn;
//--- check for bars count
   if(rates_total<=maslow) return(0);
//--- last counted bar will be recounted
   limit=rates_total-prev_calculated;
   if(prev_calculated>0) limit++;
   //--
//--- counting from rates_total to 0 
   ArraySetAsSeries(lwma05Buffers,true);
   ArraySetAsSeries(lwma10Buffers,true);
   ArraySetAsSeries(lwma20Buffers,true);
   ArraySetAsSeries(line20Buffers,true);
   ArraySetAsSeries(uplineBuffers,true);
   ArraySetAsSeries(dnlineBuffers,true);
   //--
//--- main cycle
   for(i=limit-1; i>=0; i--) 
     {
       lwma05Buffers[i]=iMA(_Symbol,0,mafast,0,3,4,i);
       line20Buffers[i]=iMA(_Symbol,0,mdma20,0,0,4,i);
     }
   //-
   LinearWeightedMAOnBuffer(rates_total,prev_calculated,0,maslow,lwma05Buffers,lwma10Buffers,i);
   LinearWeightedMAOnBuffer(rates_total,prev_calculated,0,mdma20,lwma10Buffers,lwma20Buffers,i);
   //-
   for(i=limit-1; i>=0; i--)
     {
       //--
       if(lwma05Buffers[i]>lwma20Buffers[i]) {lup=true; ldn=false;}
       if(lwma05Buffers[i]<lwma20Buffers[i]) {ldn=true; lup=false;}
       //-
       if(lup) {uplineBuffers[i]=line20Buffers[i]; dnlineBuffers[i]=EMPTY_VALUE;}
       if(ldn) {dnlineBuffers[i]=line20Buffers[i]; uplineBuffers[i]=EMPTY_VALUE;}
       //--
     }
   //---
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
