//+------------------------------------------------------------------+
//|                 This has been coded by MT-Coder                  |
//|                                                                  |
//|                     Email: mt-coder@hotmail.com                  |
//|                      Website: mt-coder.110mb.com                 |
//|                                                                  |
//|          I can code for you any strategy you have in mind        |
//|           into EA, I can code any indicator you have in mind     |
//|                                                                  |
//|                     For any programming idea                     |
//|          Don't hesitate to contact me at mt-coder@hotmail.com    |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|        This indicator simply reflects the positive difference    |
//|              between the High and Low of the period.             |
//|         Sudden price changes may tell of change of direction     |
//|             for the trend. Enjoy!                                |
//+------------------------------------------------------------------+



#property copyright "Copyright © 2010, MT-Coder."
#property link      "http://mt-coder.110mb.com/"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Silver
//---- input parameters

//---- buffers
double MainBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- 
   IndicatorBuffers(1);
   IndicatorDigits(Digits);
//---- indicator line
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,MainBuffer);
   
//---- name for DataWindow and indicator subwindow label
   short_name="Big Times - by mt-coder@hotmail.com";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Bears Power                                                      |
//+------------------------------------------------------------------+
int start()
  {
   int i,counted_bars=IndicatorCounted();
//----
 
//----

      
//----
   int limit=Bars-counted_bars-1;
   for (i=limit; i>=0;i--)
     {
      MainBuffer[i]=MathAbs(Low[i]-High[i]);
      
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+