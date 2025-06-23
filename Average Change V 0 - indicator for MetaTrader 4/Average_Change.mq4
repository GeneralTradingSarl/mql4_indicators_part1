//+------------------------------------------------------------------+
//|                 This has been coded by MT-Coder                  |
//|                                                                  |
//|                     Email: mt-coder@hotmail.com                  |
//|                      Website: mt-coder.110mb.com                 |
//|                                                                  |
//| For a price I can code for you any strategy you have in mind     |
//|           into EA, I can code any indicator you have in mind     |
//|                                                                  |
//|          Don't hesitate to contact me at mt-coder@hotmail.com    |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|        This is the basic version of the Average Change indicator |
//|          This indicator reflects the effect of the latest        |
//|               price changes.                                     |
//|           Try to get some trading signals out of that! Enjoy!    |
//+------------------------------------------------------------------+



#property copyright "Copyright © 2009, MT-Coder."
#property link      "http://mt-coder.110mb.com/"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 White

//---- input parameters
extern int ACPeriod=15;
//---- buffers
double MainBuffer[];
double TempBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
   //---- 1 additional buffer used for counting.
   IndicatorBuffers(2);
   IndicatorDigits(Digits);
//---- indicator line
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,MainBuffer);
   SetIndexBuffer(1,TempBuffer);
  
   
//---- name for DataWindow and indicator subwindow label
   short_name="Average Change("+ACPeriod+") - by mt-coder@hotmail.com";
   IndicatorShortName(short_name);
   SetIndexLabel(0,"Average Change");
  
//----
   SetIndexDrawBegin(0,ACPeriod);

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Four legs                                                        |
//+------------------------------------------------------------------+
int start()
  {
   int i,counted_bars=IndicatorCounted();
//----
   if(Bars<=ACPeriod) return(0);

//----
   int limit=Bars-counted_bars;
   if(counted_bars>0) limit++;
   for(i=0; i<limit; i++)
      TempBuffer[i]=iMA(NULL,0,ACPeriod,0,MODE_LWMA,PRICE_MEDIAN,i);
//----
   i=Bars-ACPeriod-1;
   if(counted_bars>=ACPeriod) i=Bars-counted_bars-1;
   while(i>=0)
     {

      
      MainBuffer[i]=MathPow(Open[i],5)/MathPow(TempBuffer[i],5);
      
      i--;
     }
   return(0);
  }
//+------------------------------------------------------------------+