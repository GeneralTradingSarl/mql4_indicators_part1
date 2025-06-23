//+------------------------------------------------------------------+
//|                                        Fine Fractal Channel.mq4  |
//|                                 Copyright © 2005  Chris Battles  |
//|                                             cbattles@neo.rr.com  |
//|                                                                  |
//|- Requires FineFractals © Denis Orlov                             |
//|- http://denis-or-love.narod.ru                                   |
//+------------------------------------------------------------------+

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Blue
//---- buffers
double v1[];
double v2[];
//----
double val1;
double val2;
int i;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+  
int init()
  {
//---- drawing settings
   SetIndexArrow(0, 119);
   SetIndexArrow(1, 119);
//----  
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 2);
   SetIndexDrawBegin(0, i-1);
   SetIndexBuffer(0, v1);
   SetIndexLabel(0, "Resistance");  
//----
   SetIndexStyle(1, DRAW_LINE, STYLE_SOLID, 2);
   SetIndexDrawBegin(1, i-1);
   SetIndexBuffer(1, v2);
   SetIndexLabel(1, "Support");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   //i = Bars;
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+1;
   i=limit;
   while(i >= 0)
     {   
       val1 = iCustom(NULL, 0, "Fine_Fractals",0,i);
       //----
       if(val1 > 0) 
           v1[i] = High[i];
       else
           v1[i] = v1[i+1]; 
       val2 = iCustom(NULL, 0, "Fine_Fractals",1,i);
       //----
       if(val2 > 0) 
           v2[i] = Low[i];
       else
           v2[i] = v2[i+1];
       i--;
     }   
   return(0);
}
 
//+------------------------------------------------------------------+