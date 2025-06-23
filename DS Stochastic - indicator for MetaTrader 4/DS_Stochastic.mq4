//+------------------------------------------------------------------+
//|                                                DS_Stochastic.mq4 |
//|                      Copyright © 2006, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link "http://www.metaquotes.net/"
//----
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red
//---- input parameters
extern int qPeriod = 13;
extern int rPeriod = 32;
extern int EMAfast = 5;
extern int CountBars = 300;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
//----
double krPeriod, kEMAfast;
double mtm, mtmInt, mtmIntPrev, mtm1, mtmInt1, mtmIntPrev1, DS_EMA;
double DS_EMAtopPrev, DS_EMAtop, DS_EMAbottomPrev, DS_EMAbottom, DS;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicator lines
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(1, ExtMapBuffer2);
//----
   IndicatorShortName("DS_Stoch (" + qPeriod + "," + rPeriod + "," + EMAfast + ")");
   SetIndexLabel(0, "DS_Stoch");
   SetIndexLabel(1, "Signal");
//---- 
   krPeriod = 2 / (rPeriod + 1.0);
   kEMAfast = 2 / (EMAfast + 1.0);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| DS                                                               |
//+------------------------------------------------------------------+
int start()
  {
   int shift;
   mtmIntPrev = 0.0; 
   mtmIntPrev1 = 0.0; 
   DS_EMAtopPrev = 0.0; 
   DS_EMAbottomPrev = 0.0;
   if(Bars < CountBars + qPeriod)
       return(0);
   for(shift = CountBars; shift >= 0; shift--)
     {
       mtm = Close[shift] - Low[Lowest(NULL, 0, MODE_LOW, qPeriod, shift)];
       if(mtm == 0) 
           mtm = Point;
       mtm1 = High[Highest(NULL, 0, MODE_HIGH, qPeriod, shift)] - 
              Low[Lowest(NULL, 0, MODE_LOW, qPeriod, shift)];
       if(mtm1 == 0) 
           mtm1 = Point;
       mtmInt = mtmIntPrev + krPeriod*(mtm - mtmIntPrev); 
       mtmInt1 = mtmIntPrev1 + krPeriod*(mtm1 - mtmIntPrev1); 
       DS_EMAtop = DS_EMAtopPrev + kEMAfast*(mtmInt - DS_EMAtopPrev); 
       DS_EMAbottom = DS_EMAbottomPrev + kEMAfast*(mtmInt1 - DS_EMAbottomPrev); 
       if(!CompareDouble(mtmInt1, 0.0))
           DS = 100*mtmInt / mtmInt1;
       if(!CompareDouble(DS_EMAbottom, 0.0))       
           DS_EMA = 100*DS_EMAtop / DS_EMAbottom;
       ExtMapBuffer1[shift] = DS;
       ExtMapBuffer2[shift] = DS_EMA;
       mtmIntPrev = mtmInt; 
       mtmIntPrev1 = mtmInt1; 
       DS_EMAtopPrev = DS_EMAtop; 
       DS_EMAbottomPrev = DS_EMAbottom;
     }
//---- 
   return(0);
  }
//+------------------------------------------------------------------+
//| Функция сранения двух вещественных чисел.                        |
//+------------------------------------------------------------------+
bool CompareDouble (double Number1, double Number2)
  {
    bool Compare = NormalizeDouble(Number1 - Number2, 8) == 0;
    return(Compare);
  }
//+------------------------------------------------------------------+ 

