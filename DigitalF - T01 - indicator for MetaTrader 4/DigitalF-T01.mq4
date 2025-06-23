//+------------------------------------------------------------------+
//|                                                 DigitalF-T01.mq4 |
//|                      Copyright © 2006, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
//----
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 clrLime
#property indicator_color2 clrRed
//----
extern int CountBars=300;
extern int halfchanel=25;
//----
double buf1[];
double buf2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,buf1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,buf2);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   Comment("Bars = ",Bars);
   int shift,per;
   double digf,draw=0;
   int counted_bars=IndicatorCounted();;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=24;
   if(limit>Bars) limit=Bars;
//----
   per=(int)MathRound((Hour()*60+Minute())/Period())+1;
   for(shift=limit;shift>=0;shift--)
     {
      digf=
           0.2447098565978*Close[shift]
           +0.2313977400697*Close[shift+1]
           +0.2061379694732*Close[shift+2]
           +0.1716623034064*Close[shift+3]
           +0.1314690790360*Close[shift+4]
           +0.0895038754956*Close[shift+5]
           +0.0496009165125*Close[shift+6]
           +0.01502270569607*Close[shift+7]
           -0.01188033734430*Close[shift+8]
           -0.02989873856137*Close[shift+9]
           -0.0389896710490*Close[shift+10]
           -0.0401411362639*Close[shift+11]
           -0.0351196808580*Close[shift+12]
           -0.02611613850342*Close[shift+13]
           -0.01539056955666*Close[shift+14]
           -0.00495353651394*Close[shift+15]
           +0.00368588764825*Close[shift+16]
           +0.00963614049782*Close[shift+17]
           +0.01265138888314*Close[shift+18]
           +0.01307496106868*Close[shift+19]
           +0.01169702291063*Close[shift+20]
           +0.00974841844086*Close[shift+21]
           +0.00898900012545*Close[shift+22]
           -0.00649745721156*Close[shift+23];
      //----
      buf1[shift]=digf;
      if(digf>=Close[per]) draw=Close[per]+halfchanel*Point;
      if(digf<Close[per]) draw=Close[per]-halfchanel*Point;
      buf2[shift]=draw;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
