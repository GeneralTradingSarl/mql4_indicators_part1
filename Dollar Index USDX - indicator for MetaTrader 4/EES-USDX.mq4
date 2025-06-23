//+------------------------------------------------------------------+
//|                                                     EES-USDX.mq4 |
//|                         Copyright © 2009, Elite E Services, Inc. |
//| Programmed by : Mikhail Veneracion www.forexcoding.com           |
//|                                    http://www.eliteeservices.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, Elite E Services, Inc."
#property link      "http://www.eliteeservices.net"
// Download updates to this indicator at www.eesfx.com 
// Many brokers do not offer USDSEK.  If you want this to look exactly like USDX futures contract you need to find a broker that offers this symbol. 
// Otherwise, adjust the indicator accordingly using the parameters.
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 SlateGray
#property indicator_color2 Red
 
extern double
   USDx_Weight       = 50.14348112; 
extern string
   Symbol_1          = "EURUSD";
extern double   
   Weight_1          =  -0.576;
extern string
   Symbol_2          = "USDJPY";
extern double   
   Weight_2          =  0.136;
extern string
   Symbol_3          = "GBPUSD";
extern double   
   Weight_3          =  -0.119;
extern string
   Symbol_4          = "USDCAD";
extern double   
   Weight_4          =  0.091;
extern string
   Symbol_5          = "USDSEK";
extern double   
   Weight_5          =  0.042;
extern string
   Symbol_6          = "USDCHF";
extern double   
   Weight_6          =  0.036;            
      
double ExtMapBuffer1[];
double ExtMapBuffer2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorBuffers(2);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(0,DRAW_HISTOGRAM,0,1);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(1,DRAW_LINE,0,1);
 
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

  int counted_bars = IndicatorCounted();
   int i,  limit;
   if(counted_bars == 0) 
       limit = Bars - 30;
   if(counted_bars > 0)  
       limit = Bars - counted_bars; 
   for(i = limit; i >= 0; i--)
     {   
      double Open_EURUSD=MathPow(iOpen(Symbol_1,0,i), Weight_1);
      double Open_USDJPY=MathPow(iOpen(Symbol_2,0,i), Weight_2);
      double Open_GBPUSD=MathPow(iOpen(Symbol_3,0,i), Weight_3);
      double Open_USDCAD=MathPow(iOpen(Symbol_4,0,i), Weight_4);
      double Open_USDSEK=MathPow(iOpen(Symbol_5,0,i), Weight_5);
      double Open_USDCHF=MathPow(iOpen(Symbol_6,0,i), Weight_6);
      
      if(Open_EURUSD==0)Open_EURUSD=1;
      if(Open_USDJPY==0)Open_USDJPY=1;
      if(Open_GBPUSD==0)Open_GBPUSD=1;
      if(Open_USDCAD==0)Open_USDCAD=1;
      if(Open_USDSEK==0)Open_USDSEK=1;
      if(Open_USDCHF==0)Open_USDCHF=1;
      
      double USDx=USDx_Weight * Open_EURUSD * Open_USDJPY * Open_GBPUSD * Open_USDCAD * Open_USDSEK * Open_USDCHF;
       ExtMapBuffer1[i] = USDx;
       ExtMapBuffer2[i]= USDx;
   }

   //*
 
//----
   return(0);
  }
//+------------------------------------------------------------------+