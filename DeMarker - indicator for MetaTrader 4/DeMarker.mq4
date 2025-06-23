//+------------------------------------------------------------------+
//|                                                     DeMarker.mq4 |
//|                      Copyright © 2005, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 1
#property indicator_buffers 1
#property indicator_color1 DodgerBlue
#property indicator_level1 0.3
#property indicator_level2 0.7
//---- input parameters
extern int DeMarkerPeriod=14;
//---- buffers
double DeMarkerBuffer[];
double ExtMaxBuffer[];
double ExtMinBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- 2 additional buffers are used for counting.
   IndicatorBuffers(3);
   SetIndexBuffer(0,DeMarkerBuffer);
   SetIndexBuffer(1,ExtMaxBuffer);
   SetIndexBuffer(2,ExtMinBuffer);
//---- indicator line
   SetIndexStyle(0,DRAW_LINE);
//---- name for DataWindow and indicator subwindow label
   short_name="DeM("+DeMarkerPeriod+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
//---- first values aren't drawn
   SetIndexDrawBegin(0,DeMarkerPeriod);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| DeMarker                                                         |
//+------------------------------------------------------------------+
int start()
  {
   double dNum;
   int    i,nCountedBars;
//---- insufficient data
   if(Bars<=DeMarkerPeriod) return(0);
//---- bars count that does not changed after last indicator launch.
   nCountedBars=IndicatorCounted();
//----
   ExtMaxBuffer[Bars-1]=0.0;
   ExtMinBuffer[Bars-1]=0.0;
   if(nCountedBars>2) i=Bars-nCountedBars-1;
   else               i=Bars-2;
   while(i>=0)
     {
      dNum=High[i]-High[i+1];
      if(dNum<0.0) dNum=0.0;
      ExtMaxBuffer[i]=dNum; 
      
      dNum=Low[i+1]-Low[i];
      if(dNum<0.0) dNum=0.0;
      ExtMinBuffer[i]=dNum; 

      i--;
     }   
//---- initial zero
   if(nCountedBars<1)
      for(i=1; i<=DeMarkerPeriod; i++)
         DeMarkerBuffer[Bars-i]=0.0;   
//----
   i=Bars-DeMarkerPeriod-1;
   if(nCountedBars>=DeMarkerPeriod) i=Bars-nCountedBars-1;
   while(i>=0)
     {
      dNum=iMAOnArray(ExtMaxBuffer,0,DeMarkerPeriod,0,MODE_SMA,i)+
           iMAOnArray(ExtMinBuffer,0,DeMarkerPeriod,0,MODE_SMA,i);
      if(dNum!=0.0)
         DeMarkerBuffer[i]=iMAOnArray(ExtMaxBuffer,0,DeMarkerPeriod,0,MODE_SMA,i)/dNum;
      else
         DeMarkerBuffer[i]=0.0;
      
      i--;
     }
   return(0);
  }
//+------------------------------------------------------------------+

