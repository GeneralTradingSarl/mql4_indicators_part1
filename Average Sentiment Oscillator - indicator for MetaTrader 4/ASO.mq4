//+------------------------------------------------------------------+
//|                                                          ASO.mq4 |
//|     Copyright © 2005, MetaQuotes Software Corp. © 2010, J.Arent. |
//|              http://www.metaquotes.net/, http://www.fxtools.info |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, FXTools"
#property link      "http://www.fxtools.info"

#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 100
#property indicator_buffers 2
#property indicator_color1 RoyalBlue
#property indicator_color2 Red
#property indicator_levelcolor DimGray
#property indicator_width1 1
#property indicator_width2 1
//---- input parameters
extern int AsoPeriod=10;
extern int Mode=0;
extern bool Bulls=true;
extern bool Bears=true;
//---- buffers
double AsoBufferBulls[];
double AsoBufferBears[];
double TempBufferBulls[];
double TempBufferBears[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- 2 additional buffers used for counting.
   IndicatorBuffers(4);
   SetIndexBuffer(2,TempBufferBulls);
   SetIndexBuffer(3,TempBufferBears);   
//---- indicator line
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,AsoBufferBulls);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,AsoBufferBears);
//---- level
   SetLevelValue( 0, 50 );   
//---- name for DataWindow and indicator subwindow label
   short_name="ASO("+AsoPeriod+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,"ASO Bulls");
   SetIndexLabel(1,"ASO Bears");
//----
   SetIndexDrawBegin(0,AsoPeriod);
   SetIndexDrawBegin(1,AsoPeriod);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Average Sentiment Oscillator                                     |
//+------------------------------------------------------------------+
int start()
  {
   int i,counted_bars=IndicatorCounted();
//----
   if(Bars<=AsoPeriod) return(0);
//---- initial zero
   if(counted_bars<1)
     {
      for(i=1;i<=AsoPeriod;i++) AsoBufferBulls[Bars-i]=0.0;
      for(i=1;i<=AsoPeriod;i++) AsoBufferBears[Bars-i]=0.0;
     }
//---- 
   i=Bars-counted_bars-1;
   while(i>=0)
     {
      double intrahigh=High[i];
      double intralow =Low[i];
      double intraopen=Open[i];
      double close =Close[i];
      double intrarange = intrahigh-intralow;
      double grouplow = Low[iLowest(NULL,0,MODE_LOW,AsoPeriod,i)];
      double grouphigh = High[iHighest(NULL,0,MODE_HIGH,AsoPeriod,i)];
      double groupopen = iOpen(NULL,0,i+AsoPeriod-1);
      double grouprange = grouphigh-grouplow;
      if (intrarange==0) {intrarange=1;}
      if (grouprange==0) {grouprange=1;}
      double intrabarbulls = ((((close-intralow)+(intrahigh-intraopen))/2)*100)/intrarange;
      double groupbulls = ((((close-grouplow)+(grouphigh-groupopen))/2)*100)/grouprange;
      double intrabarbears = ((((intrahigh-close)+(intraopen-intralow))/2)*100)/intrarange;      
      double groupbears = ((((grouphigh-close)+(groupopen-grouplow))/2)*100)/grouprange;      
      if(i==Bars-1) {TempBufferBulls[i]=intrabarbulls; TempBufferBears[i]=intrabarbears;}
      else
        {
         if (Mode==0) TempBufferBulls[i]=(intrabarbulls+groupbulls)/2; 
         if (Mode==0) TempBufferBears[i]=(intrabarbears+groupbears)/2;
         if (Mode==1) TempBufferBulls[i]=intrabarbulls;
         if (Mode==1) TempBufferBears[i]=intrabarbears;
         if (Mode==2) TempBufferBulls[i]=groupbulls;
         if (Mode==2) TempBufferBears[i]=groupbears;
        }
      i--;
     }
//----
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if (Bulls) 
     {
      for(i=0; i<limit; i++)
      AsoBufferBulls[i]=iMAOnArray(TempBufferBulls,Bars,AsoPeriod,0,0,i);
     }
   if (Bears) 
     {
      for(i=0; i<limit; i++)
      AsoBufferBears[i]=iMAOnArray(TempBufferBears,Bars,AsoPeriod,0,0,i);
     } 
//----
   return(0);
  }
//+------------------------------------------------------------------+