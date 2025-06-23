//+------------------------------------------------------------------+
//|                                                  CCI_Woodies.mq4 |
//|                                                                  |
//+------------------------------------------------------------------+

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 SteelBlue
#property indicator_color2 Red
//---- input parameters
extern int CCIPeriod1 = 14;
extern int CCIPeriod2 = 6;
//---- buffers
double CCIBuffer1[];
double CCIBuffer2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- indicator line
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 1, SteelBlue);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(0, CCIBuffer1);
   SetIndexBuffer(1, CCIBuffer2);
//---- name for DataWindow and indicator subwindow label
   short_name = "CCIW(" + CCIPeriod1 + ", " + CCIPeriod2 + ")";
   IndicatorShortName(short_name);
   SetIndexLabel(0, "CCIW(" + CCIPeriod1 + ")");
   SetIndexLabel(1, "CCIW(" + CCIPeriod2 + ")");   
//----
   SetIndexDrawBegin(0, CCIPeriod1);
   SetIndexDrawBegin(1, CCIPeriod2);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| CCI_Woodies                                                      |
//+------------------------------------------------------------------+
int start()
  {
   int i, counted_bars = IndicatorCounted();
//----
   if(Bars <= CCIPeriod1) 
       return(0);
//---- initial zero
   if(counted_bars < 1)
       for(i = 1; i <= CCIPeriod1; i++) 
           CCIBuffer1[Bars-i] = 0.0;
//----
   i = Bars - CCIPeriod1 - 1;
   if(counted_bars >= CCIPeriod1) 
       i = Bars - counted_bars - 1;
   while(i >= 0)
     {
       CCIBuffer1[i] = iCCI(NULL, 0, CCIPeriod1, PRICE_TYPICAL, i);
       CCIBuffer2[i] = iCCI(NULL, 0, CCIPeriod2, PRICE_TYPICAL, i);
       i--;
     }
   return(0);
  }
//+------------------------------------------------------------------+