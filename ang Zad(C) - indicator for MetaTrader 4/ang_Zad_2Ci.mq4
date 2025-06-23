//+------------------------------------------------------------------+
//|                                                   ang_Zad(C).mq4 |
//|                           Copyright © 2006, ANG3110@latchess.com |
//+------------------------------------------------------------------+

#property  copyright "ANG3110@latchess.com"
//----
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red
//----
extern double ki = 2;
//----
double za[], z, za2[], z2;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexBuffer(0, za);
   SetIndexBuffer(1, za2);
   SetIndexStyle(0, DRAW_LINE, 0, 2);
   SetIndexStyle(1, DRAW_LINE, 0, 2);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator start function                                  |
//+------------------------------------------------------------------+
int start() 
  {
   int i, cbi;
   int n, ai, bi, f, ai2, bi2, f2; 
   cbi = Bars - IndicatorCounted() - 1;
   if(IndicatorCounted()==0) cbi--;
//----
   for(i = cbi; i >= 0; i--) 
     { 
       if(Close[i] > z && Close[i] > Close[i+1]) 
           z = za[i+1] + (Close[i] - za[i+1]) / ki;
       if(Close[i] < z && Close[i] < Close[i+1]) 
           z = za[i+1] + (Close[i] - za[i+1]) / ki;
       if(Close[i] > z2 && Close[i] < Close[i+1]) 
           z2 = za2[i+1] + (Close[i] - za2[i+1]) / ki;
       if(Close[i] < z2 && Close[i] > Close[i+1]) 
           z2 = za2[i+1] + (Close[i] - za2[i+1]) / ki;
       if(i > Bars - 5) 
         {
           z = Close[i]; 
           z2 = z;
         }
       za[i] = z;  
       za2[i] = z2;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+

