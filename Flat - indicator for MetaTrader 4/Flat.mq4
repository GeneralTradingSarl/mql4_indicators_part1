//+------------------------------------------------------------------+
//|                                                         Flat.mq4 |
//|                                                      Pedro Puado |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Pedro Puado"
#property link      "http://www.metaquotes.net"
//----
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Green
//---- input parameters
extern int       MA=20;
extern int       HLRef=100;
extern int       MaxBars=1000;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorBuffers(3);
   IndicatorShortName("Flat");
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer3);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexBuffer(2,ExtMapBuffer1);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- 
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//---- 
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int i=Bars-counted_bars;
   if(counted_bars==0) i-=1+MathMax(HLRef,MA);

   int p=i;
   double m1,m2,n;
   while(i>=0)
     {
      ExtMapBuffer1[i]=iStdDev(NULL,0,MA,MODE_SMA,0,PRICE_CLOSE,i);
      i--;
     }
   int x=0;
   double s,s1,nL,nH;
   while(p>=0)
     {
      s=0;
      x=0;
      for(x=0; x<MA+0; x++)
        {
         s+=ExtMapBuffer1[p+x];
        }
      s1=s/MA;
      s=0;
      x=0;
      for(x=0; x<MA+0; x++)
        {
         s+=MathAbs((ExtMapBuffer1[p+x]-s1)*2);
        }
      ExtMapBuffer2[p]=MathSqrt(s/MA);
      nH=HVal(ExtMapBuffer2, HLRef, p);
      nL=LVal(ExtMapBuffer2, HLRef, p);
      ExtMapBuffer3[p]=((ExtMapBuffer2[p]-nL)/(nH-nL))*100;
      p--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
double HVal(double aA[],int p,int shift)
  {
   int i;
   double rtn=0,pr=0;
   for(i=0; i<p; i++)
     {
      if(aA[i+shift]>pr)
        {
         pr=aA[i+shift];
        }
     }
   return(pr);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LVal(double aA[],int p,int shift)
  {
   int i;
   double rtn=0,pr=99999;
   for(i=0; i<p; i++)
     {
      if(aA[i+shift]<pr)
        {
         pr=aA[i+shift];
        }
     }
   return(pr);
  }
//+------------------------------------------------------------------+
