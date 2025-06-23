//+------------------------------------------------------------------+
//|                                 BW Market Facilitation Index.mq4 |
//|                                           объединенный с Volumes |
//|                      Copyright © 2005, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//|                             Доработка AlexSilver http://viac.ru/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"
//---- indicator settings
#property  indicator_separate_window
#property indicator_minimum 0
#property indicator_buffers 5
#property indicator_color1 Black
#property indicator_color2 Green // Зеленая свеча
#property indicator_color3 Blue // Угасающая
#property indicator_color4 Gold // Фальшивая
#property indicator_color5 Red // приседающая 
//---- indicator buffers
double dMFIBuffer[];
double dMFIUpVUpBuffer[]; // Зеленая 
double dMFIDownVDownBuffer[]; // Угасающая
double dMFIUpVDownBuffer[]; // Фальшивая
double dMFIDownVUpBuffer[]; // приседающая 
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {

//---- indicator buffers mapping
   SetIndexBuffer(0,dMFIBuffer);
   SetIndexBuffer(1,dMFIUpVUpBuffer);
   SetIndexBuffer(2,dMFIDownVDownBuffer);
   SetIndexBuffer(3,dMFIUpVDownBuffer);
   SetIndexBuffer(4,dMFIDownVUpBuffer);
//---- drawing settings
   SetIndexStyle(0,DRAW_NONE);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexStyle(3,DRAW_HISTOGRAM);
   SetIndexStyle(4,DRAW_HISTOGRAM);

//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("BW MFI + Volumes");
   SetIndexLabel(0,"BW MFI");
   SetIndexLabel(1,"Зелёный");
   SetIndexLabel(2,"Угасающий");
   SetIndexLabel(3,"Фальшивый");
   SetIndexLabel(4,"Приседающий");

//---- sets drawing line empty value
   SetIndexEmptyValue(1, 0.0);
   SetIndexEmptyValue(2, 0.0);
   SetIndexEmptyValue(3, 0.0);
   SetIndexEmptyValue(4, 0.0);

   IndicatorDigits(0);
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| BW Market Facilitation Index                                     |
//+------------------------------------------------------------------+
int start()
  {
   int    i,nLimit,nCountedBars;
//---- bars count that does not changed after last indicator launch.
   nCountedBars=IndicatorCounted();
//---- last counted bar will be recounted
   if(nCountedBars>0) nCountedBars--;
   nLimit=Bars-nCountedBars;
//---- Market Facilitation Index calculation
   for(i=0; i<nLimit; i++)
      if(i==0 && Volume[i]<Period()*1.5)
         dMFIBuffer[i]=0.0;
   else
      dMFIBuffer[i]=(High[i]-Low[i])/(Volume[i]*Point);
//---- dispatch values between 4 buffers  
   for(i=nLimit-2; i>=0; i--)
     {
      if((i!=nLimit-1&&bCompareDouble(dMFIBuffer[i],dMFIBuffer[i+1])&&dMFIBuffer[i]>dMFIBuffer[i+2]&&Volume[i]>Volume[i+1])||
         (i!=nLimit-1&&dMFIBuffer[i]>dMFIBuffer[i+1]&&Volume[i]==Volume[i+1]&&Volume[i]>Volume[i+2])||
         (i<nLimit-2 && dMFIBuffer[i]>dMFIBuffer[i+1] && Volume[i]==Volume[i+1] && Volume[i]==Volume[i+2] && Volume[i]>Volume[i+3]) || 
         (i!=nLimit-1 && bCompareDouble(dMFIBuffer[i],dMFIBuffer[i+1]) && dMFIBuffer[i]>dMFIBuffer[i+2] && Volume[i]==Volume[i+1] && Volume[i]>Volume[i+2]) || 
         (dMFIBuffer[i]>dMFIBuffer[i+1] && Volume[i]>Volume[i+1]))
        {
         dMFIUpVUpBuffer[i]=Volume[i];
         dMFIDownVDownBuffer[i]=0.0;
         dMFIUpVDownBuffer[i]=0.0;
         dMFIDownVUpBuffer[i]=0.0;
         continue;
        }
      if((i!=nLimit-1&&bCompareDouble(dMFIBuffer[i],dMFIBuffer[i+1])&&dMFIBuffer[i]<dMFIBuffer[i+2]&&Volume[i]<Volume[i+1])||
         (i!=nLimit-1&&dMFIBuffer[i]<dMFIBuffer[i+1]&&Volume[i]==Volume[i+1]&&Volume[i]<Volume[i+2])||
         (i<nLimit-2 && dMFIBuffer[i]<dMFIBuffer[i+1] && Volume[i]==Volume[i+1] && Volume[i]==Volume[i+2] && Volume[i]<Volume[i+3]) || 
         (i!=nLimit-1 && bCompareDouble(dMFIBuffer[i],dMFIBuffer[i+1]) && dMFIBuffer[i]<dMFIBuffer[i+2] && Volume[i]==Volume[i+1] && Volume[i]<Volume[i+2]) || 
         (dMFIBuffer[i]<dMFIBuffer[i+1] && Volume[i]<Volume[i+1]))
        {
         dMFIUpVUpBuffer[i]=0.0;
         dMFIDownVDownBuffer[i]=Volume[i];
         dMFIUpVDownBuffer[i]=0.0;
         dMFIDownVUpBuffer[i]=0.0;
         continue;
        }
      if((i!=nLimit-1&&bCompareDouble(dMFIBuffer[i],dMFIBuffer[i+1])&&dMFIBuffer[i]>dMFIBuffer[i+2]&&Volume[i]<Volume[i+1])||
         (i!=nLimit-1&&dMFIBuffer[i]>dMFIBuffer[i+1]&&Volume[i]==Volume[i+1]&&Volume[i]<Volume[i+2])||
         (i<nLimit-2 && dMFIBuffer[i]>dMFIBuffer[i+1] && Volume[i]==Volume[i+1] && Volume[i]==Volume[i+2] && Volume[i]<Volume[i+3]) || 
         (i!=nLimit-1 && bCompareDouble(dMFIBuffer[i],dMFIBuffer[i+1]) && dMFIBuffer[i]>dMFIBuffer[i+2] && Volume[i]==Volume[i+1] && Volume[i]<Volume[i+2]) || 
         (dMFIBuffer[i]>dMFIBuffer[i+1] && Volume[i]<Volume[i+1]))
        {
         dMFIUpVUpBuffer[i]=0.0;
         dMFIDownVDownBuffer[i]=0.0;
         dMFIUpVDownBuffer[i]=Volume[i];
         dMFIDownVUpBuffer[i]=0.0;
         continue;
        }
      if((i!=nLimit-1&&bCompareDouble(dMFIBuffer[i],dMFIBuffer[i+1])&&dMFIBuffer[i]<dMFIBuffer[i+2]&&Volume[i]>Volume[i+1])||
         (i!=nLimit-1&&dMFIBuffer[i]<dMFIBuffer[i+1]&&Volume[i]==Volume[i+1]&&Volume[i]>Volume[i+2])||
         (i<nLimit-2 && dMFIBuffer[i]<dMFIBuffer[i+1] && Volume[i]==Volume[i+1] && Volume[i]==Volume[i+2] && Volume[i]>Volume[i+3]) || 
         (i!=nLimit-1 && bCompareDouble(dMFIBuffer[i],dMFIBuffer[i+1]) && dMFIBuffer[i]<dMFIBuffer[i+2] && Volume[i]==Volume[i+1] && Volume[i]>Volume[i+2]) || 
         (dMFIBuffer[i]<dMFIBuffer[i+1] && Volume[i]>Volume[i+1]))
        {
         dMFIUpVUpBuffer[i]=0.0;
         dMFIDownVDownBuffer[i]=0.0;
         dMFIUpVDownBuffer[i]=0.0;
         dMFIDownVUpBuffer[i]=Volume[i];
         continue;
        }
     }
//---- done
   return(0);
  }
//+------------------------------------------------------------------+
bool bCompareDouble(double dNumber1,double dNumber2)
  {
   bool bCompare=NormalizeDouble(dNumber1-dNumber2,8)==0;
   return(bCompare);
  }
//+------------------------------------------------------------------+
