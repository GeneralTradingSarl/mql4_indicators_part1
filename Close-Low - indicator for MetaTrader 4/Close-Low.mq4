//+------------------------------------------------------------------+
//|                 This has been coded by MT-Coder                  |
//|                                                                  |
//|                     Email: mt-coder@hotmail.com                  |
//|                      Website: mt-coder.110mb.com                 |
//|                                                                  |
//| For a price I can code for you any strategy you have in mind     |
//|            into EA, I can code any indicator you have in mind    |
//|                                                                  |
//|          Don't hesitate to contact me at mt-coder@hotmail.com    |
//+------------------------------------------------------------------+


#property copyright "Copyright © 2009, MT-Coder."
#property link      "http://mt-coder.110mb.com/"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 White

//---- input parameters
extern int CLPeriod=15;
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
   short_name="Close-Low by mt-coder@hotmail.com ("+CLPeriod+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,"Close-Low");
  
//----
   SetIndexDrawBegin(0,CLPeriod);

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
   if(Bars<=CLPeriod) return(0);
//---- initial zero
   if(counted_bars<1)
     // for(i=1;i<=CLPeriod;i++) MomBuffer[Bars-i]=0.0;
//----
//----
   int limit=Bars-counted_bars;
   if(counted_bars>0) limit++;
   for(i=0; i<limit; i++)
      TempBuffer[i]=iMA(NULL,0,CLPeriod,0,MODE_SMA,PRICE_CLOSE,i);
//----
   i=Bars-CLPeriod-1;
   if(counted_bars>=CLPeriod) i=Bars-counted_bars-1;
   while(i>=0)
     {

      
      MainBuffer[i]=MathPow(High[i],1)/MathPow(Low[i+CLPeriod],1);
      
      i--;
     }
   return(0);
  }
//+------------------------------------------------------------------+