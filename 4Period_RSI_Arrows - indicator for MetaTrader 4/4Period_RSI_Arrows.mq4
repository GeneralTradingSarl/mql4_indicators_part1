
//+-------------------------------------------------------------------------+
//| 4Period_RSI_Arrows.mq4                                                  |
//| transport_david thanks the many friends @                               |
//| http://finance.groups.yahoo.com/group/MetaTrader_Experts_and_Indicators/|
//+-------------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 Honeydew
#property indicator_color2 Honeydew
#property indicator_color3 Pink
#property indicator_color4 Pink
#property indicator_color5 Coral
#property indicator_color6 Coral
#property indicator_color7 Red
#property indicator_color8 Red
//---- input parameters
extern int   atf=5;//Period() in minutes
extern int   btf=15;//Period() in minutes
extern int   ctf=30;//Period() in minutes
extern int   dtf=60;//Period() in minutes
extern int first_RSIperiods=9;
extern int second_RSIperiods=9;
extern int third_RSIperiods=9;
extern int fourth_RSIperiods=9;
extern int rsi_applied_price=5;
/*
Applied price constants. It can be any of the following values:
Constant        Value  Description
PRICE_CLOSE     0      Close price,
PRICE_OPEN      1      Open price,
PRICE_HIGH      2      High price,
PRICE_LOW       3      Low price,
PRICE_MEDIAN    4      Median price, (high+low)/2,
PRICE_TYPICAL   5      Typical price, (high+low+close)/3,
PRICE_WEIGHTED  6      Weighted close price, (high+low+close+close)/4.  
*/
extern int shift=0;
extern int rsiUpperTrigger=62;
extern int rsiLowerTrigger=38;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
double ExtMapBuffer6[];
double ExtMapBuffer7[];
double ExtMapBuffer8[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,234);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexEmptyValue(0,0.0);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,233);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexEmptyValue(1,0.0);
   SetIndexStyle(2,DRAW_ARROW);
   SetIndexArrow(2,234);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexEmptyValue(2,0.0);
   SetIndexStyle(3,DRAW_ARROW);
   SetIndexArrow(3,233);
   SetIndexBuffer(3,ExtMapBuffer4);
   SetIndexEmptyValue(3,0.0);
   SetIndexStyle(4,DRAW_ARROW);
   SetIndexArrow(4,234);
   SetIndexBuffer(4,ExtMapBuffer5);
   SetIndexEmptyValue(4,0.0);
   SetIndexStyle(5,DRAW_ARROW);
   SetIndexArrow(5,233);
   SetIndexBuffer(5,ExtMapBuffer6);
   SetIndexEmptyValue(5,0.0);
   SetIndexStyle(6,DRAW_ARROW);
   SetIndexArrow(6,234);
   SetIndexBuffer(6,ExtMapBuffer7);
   SetIndexEmptyValue(6,0.0);
   SetIndexStyle(7,DRAW_ARROW);
   SetIndexArrow(7,233);
   SetIndexBuffer(7,ExtMapBuffer8);
   SetIndexEmptyValue(7,0.0);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i;  
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit--;
//----   
   for(i=limit;i>=0;i--)
     {
      double one =iRSI(Symbol(),atf,first_RSIperiods,rsi_applied_price,i+shift);
      if (one < rsiLowerTrigger)
         ExtMapBuffer1[i]=High[i]+5*Point;
      if (one > rsiUpperTrigger)
         ExtMapBuffer2[i]=Low[i]-5*Point;
     }
   for(i=limit;i>=0;i--)
     {
      double two =iRSI(Symbol(),btf,second_RSIperiods,rsi_applied_price,i+shift);
      if (two < rsiLowerTrigger)
         ExtMapBuffer3[i]=High[i]+8*Point;
      if (two > rsiUpperTrigger)
         ExtMapBuffer4[i]=Low[i]-8*Point;
     }
   for(i=limit;i>=0;i--)
     {
      double three =iRSI(Symbol(),ctf,third_RSIperiods,rsi_applied_price,i+shift);
      if (three < rsiLowerTrigger)
         ExtMapBuffer5[i]=High[i]+11*Point;
      if (three > rsiUpperTrigger)
         ExtMapBuffer6[i]=Low[i]-11*Point;
     }
   for(i=limit;i>=0;i--)
     {
      double four =iRSI(Symbol(),dtf,fourth_RSIperiods,rsi_applied_price,i+shift);
      if (four < rsiLowerTrigger)
         ExtMapBuffer7[i]=High[i]+14*Point;
      if (four > rsiUpperTrigger)
         ExtMapBuffer8[i]=Low[i]-14*Point;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+