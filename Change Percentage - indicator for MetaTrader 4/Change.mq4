//+------------------------------------------------------------------+
//|                 This has been coded by MT-Coder                  |
//|                                                                  |
//|                     Email: mt-coder@hotmail.com                  |
//|                      Website: mt-coder.110mb.com                 |
//|                                                                  |
//|       For any strategy that you have in mind, any idea,          |
//|        to make it an Expert Advisor or a Custom Indicator        |
//|                                                                  |
//|          Don't hesitate to contact me at mt-coder@hotmail.com    |
//|            Or on the Website: mt-coder.110mb.com                 |
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|   This indicator simply shows the change in percentage between   |
//|    the Close of the current period and the previous one.         |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, MT-Coder."
#property link      "http://mt-coder.110mb.com/"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Green
#property indicator_color2 Red

//---- buffers
double UpBuffer[];
double DnBuffer[];
//----
int Clen=1;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//----                                        
   IndicatorBuffers(2);
   IndicatorDigits(Digits);
//---- indicator line
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,UpBuffer);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexBuffer(1,DnBuffer);
//---- name for DataWindow and indicator subwindow label
   short_name="MT-Coder.110mb.com | Change %";
   IndicatorShortName(short_name);
   SetIndexLabel(0,"Up");
   SetIndexLabel(1,"Down");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
//----
   if(Bars<=Clen) return(0);

   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+1;

   int i=limit;
   while(i>=0)
     {
      if(((Close[i]-Close[i+1])/Close[i+1])>=0)
         UpBuffer[i]=((Close[i]-Close[i+1])/Close[i+1])*100;
      else
         DnBuffer[i]=((Close[i]-Close[i+1])/Close[i+1])*100;
      i--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
