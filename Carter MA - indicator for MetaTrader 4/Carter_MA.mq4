//+------------------------------------------------------------------+
//|                                                    Carter MA.mq4 |
//|                      Copyright © 2006, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
//| This was my first indicator that I programmed for MetaTrader.   
//| It's quite simple and plots 5 moving averages on your chart.  
//| These 5 EMA's (8, 21, 50, 100, 200) are those that John Carter 
//| uses personally on all of his charts. 
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 5
#property indicator_color1 Sienna
#property indicator_color2 Green
#property indicator_color3 Blue
#property indicator_color4 Red
#property indicator_color5 Red
//----
extern int ma1 = 8;
extern int ma2 = 21;
extern int ma3 = 50;
extern int ma4 = 100;
extern int ma5 = 200;
//----
double ma1_buffer [];
double ma2_buffer [];
double ma3_buffer [];
double ma4_buffer [];
double ma5_buffer [];  
int a_begin;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//----
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, ma1_buffer);
   SetIndexLabel(0, "8 EMA");
//---- 
   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(1, ma2_buffer);
   SetIndexLabel(1, "21 EMA");   
//----
   SetIndexStyle(2, DRAW_LINE,EMPTY,2);
   SetIndexBuffer(2, ma3_buffer);
   SetIndexLabel(2, "50 EMA");
//----   
   SetIndexStyle(3, DRAW_LINE,STYLE_DOT);
   SetIndexBuffer(3, ma4_buffer);
   SetIndexLabel(3, "100 EMA");
//----   
   SetIndexStyle(4, DRAW_LINE,EMPTY, 3);
   SetIndexBuffer(4, ma5_buffer);
   SetIndexLabel(4, "200 EMA");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
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
   int counted_bars = IndicatorCounted();
//----
   if(counted_bars < 0) 
       return(-1);
//----
   if(counted_bars > 0) 
       counted_bars --;
   int pos = Bars - counted_bars;  
//----
   while(pos >= 0) 
     {
       ma1_buffer[pos] = iMA(NULL, 0, ma1, NULL, MODE_EMA, PRICE_CLOSE, pos);
       ma2_buffer[pos] = iMA(NULL, 0, ma2, NULL, MODE_EMA, PRICE_CLOSE, pos);
       ma3_buffer[pos] = iMA(NULL, 0, ma3, NULL, MODE_EMA, PRICE_CLOSE, pos);
       ma4_buffer[pos] = iMA(NULL, 0, ma4, NULL, MODE_EMA, PRICE_CLOSE, pos);
       ma5_buffer[pos] = iMA(NULL, 0, ma5, NULL, MODE_EMA, PRICE_CLOSE, pos);
       pos--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+-------------------------------+