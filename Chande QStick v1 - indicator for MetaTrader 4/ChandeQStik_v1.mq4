//+------------------------------------------------------------------+
//|                                              ChandeQStick_v1.mq4 |
//|                           Copyright © 2006, TrendLaboratory Ltd. |
//|            http://finance.groups.yahoo.com/group/TrendLaboratory |
//|                                       E-mail: igorad2004@list.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, TrendLaboratory Ltd."
#property link      "http://finance.groups.yahoo.com/group/TrendLaboratory"
//----
#property indicator_separate_window
#property indicator_buffers   2
#property indicator_color1    LightBlue
#property indicator_color2    Orange
#property indicator_width1    3
#property indicator_width2    3
#property indicator_level1    0
//---- input parameters
extern int       Length =8; // Period of evaluation
extern int       MA_Mode=0; // MA mode : 0-SMA,1-EMA,2-SMMA,3-LWMA
//---- buffers
double CQS_Up[];
double CQS_Dn[];
double Diff[];
double CQS[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorBuffers(4);
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,CQS_Up);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexBuffer(1,CQS_Dn);
   SetIndexBuffer(2,Diff);
   SetIndexBuffer(3,CQS);
//---- name for DataWindow and indicator subwindow label
   string short_name="ChandeQStick("+Length+","+MA_Mode+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,"CQS Up");
   SetIndexLabel(0,"CQS Down");
//----
   SetIndexDrawBegin(0,Length);
   SetIndexDrawBegin(1,Length);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int      shift;
//---- 
/*
   for(int i=1;i<Length;i++) 
   {
   CQS_Up[Bars-i]=0;    
   CQS_Dn[Bars-i]=0;  
   CQS[Bars-i]=0;
   Diff[Bars-i]=0;
   }   
   */
//---- last counted bar will be recounted
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+1;

//----
   for(shift=limit; shift>=0; shift--)
      Diff[shift]=Close[shift]-Open[shift];
//----
   for(shift=limit; shift>=0; shift--)
     {
      CQS[shift]=iMAOnArray(Diff,0,Length,0,MA_Mode,shift);
      if(CQS[shift]>=CQS[shift+1]) {CQS_Up[shift]=CQS[shift];CQS_Dn[shift]=0;}
      else
      if(CQS[shift]<CQS[shift+1]) {CQS_Dn[shift]=CQS[shift];CQS_Up[shift]=0;}
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
