//+------------------------------------------------------------------+
//|                                    Super Relativ Vigor Index.mq4 |
//|                      Copyright © 2005, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2005, MetaQuotes Software Corp."
#property  link      "http://www.metaquotes.net/"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 3
#property  indicator_color1  Green
#property  indicator_color2  Red
#property  indicator_color3  Yellow
//---- indicator parameters
extern int ExtRVIPeriod=10;
//---- indicator buffers
double     ExtRVIBuffer[];
double     ExtRVISignalBuffer[];
double     ExtRVIValue[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicator buffers mapping
   SetIndexBuffer(0,ExtRVIBuffer);
   SetIndexBuffer(1,ExtRVISignalBuffer);
   SetIndexBuffer(2,ExtRVIValue);
//---- indicator line
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);
//---- drawing settings   
   SetIndexDrawBegin(0,ExtRVIPeriod+3);   
   SetIndexDrawBegin(1,ExtRVIPeriod+7);     
   SetIndexDrawBegin(2,ExtRVIPeriod);     
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("RVI("+ExtRVIPeriod+")");
   SetIndexLabel(0,"RVI");
   SetIndexLabel(1,"RVIS");
   SetIndexLabel(2,"Value");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Relativ Vigor Index                                              |
//+------------------------------------------------------------------+
int start()
  {
   int i,j,nLimit,nCountedBars;
   double dValueUp,dValueDown,dNum,dDeNum;
//----
   if(Bars<=ExtRVIPeriod+8) return(0);
//----
   nCountedBars=IndicatorCounted();
//---- check for possible errors
   if(nCountedBars<0) return(-1);
//---- last counted bar will be recounted
   nLimit=Bars-ExtRVIPeriod-4;
   if(nCountedBars>ExtRVIPeriod+4)
      nLimit=Bars-nCountedBars;
//---- RVI counted in the 1-st buffer
   for(i=0; i<=nLimit; i++)
     {
      dNum=0.0; 
      dDeNum=0.0;
      for(j=i; j<i+ExtRVIPeriod; j++)
        {
         dValueUp=((Close[j]-Open[j])+2*(Close[j+1]-Open[j+1])+2*(Close[j+2]-Open[j+2])+(Close[j+3]-Open[j+3]))/6;
         dValueDown=((High[j]-Low[j])+2*(High[j+1]-Low[j+1])+2*(High[j+2]-Low[j+2])+(High[j+3]-Low[j+3]))/6;
         dNum+=dValueUp;
         dDeNum+=dValueDown;
        }
      if(dDeNum!=0.0)
         ExtRVIBuffer[i]=dNum/dDeNum;
         //==----==//
         //ExtRVIValue[i]=ExtRVISignalBuffer[i]-ExtRVIBuffer[i]*2;
      else
         ExtRVIBuffer[i]=dNum;   
      //==----==//
      ExtRVIValue[i]=ExtRVISignalBuffer[i]+ExtRVIBuffer[i]*2;
     }
//---- signal line counted in the 2-nd buffer
   nLimit=Bars-ExtRVIPeriod-7;
   if(nCountedBars>ExtRVIPeriod+8)
      nLimit=Bars-nCountedBars+1;
   for(i=0; i<=nLimit; i++)
      ExtRVISignalBuffer[i]=(ExtRVIBuffer[i]+2*ExtRVIBuffer[i+1]+2*ExtRVIBuffer[i+2]+ExtRVIBuffer[i+3])/6;
      //==----==//
      ExtRVIValue[i]=ExtRVISignalBuffer[i]+ExtRVIBuffer[i]*4;
//----
   return(0);
  }
//+------------------------------------------------------------------+

