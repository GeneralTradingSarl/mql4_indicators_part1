//+------------------------------------------------------------------+
//|                                                  Force Index.mq4 |
//|                      Copyright © 2005, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 DodgerBlue
//---- input parameters
extern int ExtForcePeriod=13;
extern int ExtForceMAMethod=0;
extern int ExtForceAppliedPrice=0;
//---- buffers
double ExtForceBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string sShortName;
   SetIndexBuffer(0,ExtForceBuffer);
//---- indicator line
   SetIndexStyle(0,DRAW_LINE);
//---- name for DataWindow and indicator subwindow label
   sShortName="Force("+ExtForcePeriod+")";
   IndicatorShortName(sShortName);
   SetIndexLabel(0,sShortName);
//---- first values aren't drawn
   SetIndexDrawBegin(0,ExtForcePeriod);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Force Index indicator                                            |
//+------------------------------------------------------------------+
int start()
  {
   int nLimit;
   int nCountedBars=IndicatorCounted();
//---- insufficient data
   if(Bars<=ExtForcePeriod) return(0);
//---- last counted bar will be recounted
   if(nCountedBars>ExtForcePeriod) nCountedBars--;
   nLimit=Bars-nCountedBars;
//---- Force Index counted
   for(int i=0; i<nLimit; i++)
      ExtForceBuffer[i]=Volume[i]*
                        (iMA(NULL,0,ExtForcePeriod,0,ExtForceMAMethod,ExtForceAppliedPrice,i)-
                         iMA(NULL,0,ExtForcePeriod,0,ExtForceMAMethod,ExtForceAppliedPrice,i+1));
//---- done
   return(0);
  }
//+------------------------------------------------------------------+