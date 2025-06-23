//+------------------------------------------------------------------+
//|                                                   B&WImp-T01.mq4 |
//|       30.08.2006  Translated on MT4 by Oleg Golozubov aka Maloma |
//+------------------------------------------------------------------+

#property copyright " Copyright © 2006, HomeSoft-Tartan Corp."
#property link      " spiky@transkeino.ru - http:\\www.fxexpert.ru"

#property indicator_separate_window
#property indicator_color1 Lime
#property indicator_buffers 1
#include <stdlib.mqh>

extern double mBar=300;
extern int per=96;
extern double tr=3;
extern double t3_period=8;
extern double b=0.7;

double Buffer[];

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID);
   SetIndexBuffer(0, Buffer);
   return(0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   double impr[300];
   double impb[300];
   double e1=0;
   double e2=0;
   double e3=0;
   double e4=0;
   double e5=0;
   double e6=0;
   double c1=0;
   double c2=0;
   double c3=0;
   double c4=0;
   double n=0;
   double w1=0;
   double w2=0;
   double b2=0;
   double b3=0;
   int shift=0;
   double imppr=0;
   double imppb=0;
   int i=0;
   double sipr=0;
   double sipb=0;
   double null=0;
   double sum=0;
   double t3=0;

   b2=b*b;
   b3=b2*b;
   c1=-b3;
   c2=(3*(b2+b3));
   c3=-3*(2*b2+b+b3);
   c4=(1+3*b+b3+3*b2);
   n=t3_period;

   if(n<1) n=1;
   n=1+0.5*(n-1);
   w1=2/(n+1);
   w2=1-w1;

   for(shift=Bars-1;shift>=0 ;shift--) Buffer[shift]=0;

   null=0.00001;

   for(shift=mBar;shift>=per;shift--)
     {
      imppr=0;
      imppb=0;
      for(i=shift;i>=shift-per;i--)
        {
         if(Close[i]>Open[i]) imppr=imppr+(Close[i]-Open[i]);
         if(Close[i]<Open[i]) imppb=imppb+(Close[i]-Open[i]);
        }
      imppr=MathRound(imppr/Point);
      imppb=MathRound(imppb/Point);
      if(imppr==0) imppr=0.0001;
      if(imppb==0) imppb=0.0001;
      impr[shift-per]=imppr;
      impb[shift-per]=imppb;
     }
   for(shift=mBar-per;shift>=0;shift--)
     {
      sipr=0;
      sipb=0;
      for(i=shift;i>=shift-tr ;i--)
        {
         sipr=sipr+impr[shift];
         sipb=sipb+impb[shift];
        }
      sipr=MathRound((sipr/tr));
      sipb=MathRound((sipb/tr));
      sum=sipr+sipb;

      e1=w1*sum+w2*e1;
      e2=w1*e1+w2*e2;
      e3=w1*e2+w2*e3;
      e4=w1*e3+w2*e4;
      e5=w1*e4+w2*e5;
      e6=w1*e5+w2*e6;

      t3=c1*e6+c2*e5+c3*e4+c4*e3;

      if(t3==0) t3=0.0001;

      if(t3!=0) Buffer[shift]=t3;
     }

   return(0);
  }
//+------------------------------------------------------------------+
