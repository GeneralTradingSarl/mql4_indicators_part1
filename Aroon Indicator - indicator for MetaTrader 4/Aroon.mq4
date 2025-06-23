//+------------------------------------------------------------------+
//|                                                     Momentum.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Yellow
#property indicator_color2 DodgerBlue

#property indicator_minimum 0
#property indicator_maximum 100
#property indicator_level1 30
#property indicator_level2 70


//---- input parameters
extern int MomPeriod=14;
//---- buffers
double MomBuffer1[],MomBuffer2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- indicator line
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,MomBuffer1);

   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,MomBuffer2);

//---- name for DataWindow and indicator subwindow label
   short_name="Aroon("+MomPeriod+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
//----
   SetIndexDrawBegin(0,MomPeriod);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Momentum                                                         |
//+------------------------------------------------------------------+
int start()
  {
   int i,counted_bars=IndicatorCounted();
//----
   if(Bars<=MomPeriod) return(0);  //bar kurang dari 14 keluar..
//---- initial zero
   if(counted_bars<1)  //..jika bar yang sudah terhitung lebih kecil dari 1 maka nol kan semua
   //mulai dari no buffer yang paling besar ke yang paling kecil=0
      for(i=1;i<=MomPeriod;i++) {
         MomBuffer1[Bars-i]=0.0;
         MomBuffer2[Bars-i]=0.0;
      }
//----
   i=Bars-MomPeriod-1;
   if(counted_bars>=MomPeriod) i=Bars-counted_bars-1;//15-14-1=0
   int nHigh,nLow;
   while(i>=0)
     {
      double Max=-100000;
      double Min=100000;
      for(int k=i;k<i+MomPeriod;k++){
         double Num=Close[k];
         if(Num>Max){
            Max=Num;
            nHigh=k;
         }
         if(Num<Min){
            Min=Num;
            nLow=k;
         }
      }
      
      //Aroon Indicator math..
      MomBuffer1[i]=100.0*(MomPeriod-(nHigh-i))/MomPeriod;
      MomBuffer2[i]=100.0*(MomPeriod-(nLow-i))/MomPeriod;
      i--;
     }
   return(0);
  }
//+------------------------------------------------------------------+