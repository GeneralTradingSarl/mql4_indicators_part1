//+------------------------------------------------------------------+
//|                                                   Aroon Horn.mq4 |
//|                                                tonyc2a@yahoo.com |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "tonyc2a@yahoo.com"
#property link      "mailto:tonyc2a@yahoo.com"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red
//----
extern int Aroon_Period=10;
//----
double Buffer1[];
double Buffer2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 1);
   SetIndexBuffer(0, Buffer1);
   SetIndexStyle(1, DRAW_LINE,STYLE_SOLID, 1);
   SetIndexBuffer(1, Buffer2);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("Aroon Horn" + "(" + Aroon_Period + ")");
   SetIndexLabel(0, "Aroon Up");
   SetIndexLabel(1, "Aroon Down");
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
   double HighestBar, LowestBar, aroonUp, aroonDn;
   for(int shift = Bars - Aroon_Period; shift >= 0; shift--)
     {
       HighestBar = Highest(NULL, 0, MODE_HIGH, Aroon_Period - 1, shift);
       LowestBar = Lowest(NULL, 0, MODE_LOW, Aroon_Period - 1, shift);
       //----
       aroonUp = 100 - ((HighestBar - shift) / Aroon_Period) * 100;
       aroonDn = 100 - ((LowestBar - shift) / Aroon_Period) * 100;  
       //----
       if(aroonUp == 0) 
         { 
           aroonUp = 0.0000001; 
         }
       //----
       if(aroonDn == 0) 
         { 
           aroonDn = 0.0000001; 
         }
       Buffer1[shift]=aroonUp;
       Buffer2[shift]=aroonDn;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+