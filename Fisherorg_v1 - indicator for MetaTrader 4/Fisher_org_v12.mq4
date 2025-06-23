//+------------------------------------------------------------------+
//|                                                Fisher_org_v1.mq4 |
//|                           Copyright © 2006, TrendLaboratory Ltd. |
//|            http://finance.groups.yahoo.com/group/TrendLaboratory |
//|                                       E-mail: igorad2004@list.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, TrendLaboratory Ltd."
#property link      "http://finance.groups.yahoo.com/group/TrendLaboratory"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red
//---- input parameters
extern int Length = 10;
extern int Price = 4;
extern int NumBars = 0; 
//---- buffers
double Buffer[]; 
double Value [];
double Fisher[];   
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(3);
//----
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
//----
   SetIndexBuffer(0,Buffer);
   SetIndexBuffer(1,Fisher);
   SetIndexBuffer(2,Value);
//----
   IndicatorShortName ("FisherTransform(" + IntegerToString(Length) + "," + IntegerToString(Price) + ")");
   SetIndexLabel (0, "Fish");
   SetIndexLabel (1, "Trigger");
//----
   SetIndexDrawBegin(0,Length);
   SetIndexDrawBegin(1,Length);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Fisher_org_v1                                                    |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars = IndicatorCounted();
   int limit=Bars - counted_bars;
   if(counted_bars==0) limit--;
   int shift;
   double smin = 0, smax = 0;                    
//----
   if(NumBars > 0) 
       int NBars = NumBars; 
   else 
       NBars = limit;
//----
   for(shift = NBars; shift >= 0; shift--)
     {	
       Buffer[shift] = 0.0;
       Value [shift] = 0.0;
       Fisher[shift] = 0.0;   
     }
//----
   for(shift = NBars - 2 - Length; shift >= 0; shift--)
     {	
       smax = High[Highest(NULL, 0, MODE_HIGH, Length, shift)];
       smin = Low[Lowest(NULL, 0, MODE_LOW, Length, shift)];
       double price = iMA(NULL, 0, 1, 0, 0, Price, shift);   
       //----
       if(smax == smin) 
           smax = smin + Point; 
       double wpr = (price - smin) / (smax - smin);         
       Value[shift] = (wpr - 0.5) + 0.67*Value[shift+1];     
       //----
       if(Value[shift] > 0.99) 
           Value[shift] = 0.999; 
       //----
       if(Value[shift] < -0.99) 
           Value[shift] = -0.999; 
       Fisher[shift] = 0.5*MathLog((1.0 + Value[shift]) / (1.0 - Value[shift])) + 
                       0.5*Fisher[shift+1];
       Buffer[shift] = Fisher[shift+1];       
 
     }
   return(0);
  }
//+------------------------------------------------------------------+