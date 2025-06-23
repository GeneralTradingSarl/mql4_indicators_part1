//+------------------------------------------------------------------+
//|                                                  EntropyMath.mq4 |
//|                                         Aleksandr Pak            |
//+------------------------------------------------------------------+

#property  copyright "Copyright © 2008, MetaQuotes Software Corp."
#property  link      "http://forum.mql4.com/ru/13708"
#property indicator_separate_window

#property indicator_buffers 1
#property indicator_color1 Lime
#property indicator_level1 0.0001
#property indicator_level2 -0.0001

double entropy[];

extern int numbars=14;
//+------------------------------------------------------------------+
int init()
  {
   SetIndexBuffer(0,entropy); SetIndexStyle(0,DRAW_LINE); IndicatorShortName("Entropy("+numbars+")");
   IndicatorDigits(3*Digits);
   return(0);
  }
//+------------------------------------------------------------------+
int deinit() { return(0); }
//+------------------------------------------------------------------+
int start()
  {
   double  P,G;
   int in,out;
   int i,j;
   double sumx=0.0;
   double sumx2= 0.0;
   double avgx = 0.0;
   double rmsx = 0.0;

   in=0;  //price;
   out=0; //entropy;

   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+numbars+1;

   for(i=0; i<limit; i++)
     {
      if(i>limit-numbars+1) entropy[out]=0;
      else
        {
         sumx = 0; sumx2=0; avgx =0; rmsx = 0.0;
         for(j=0;j<numbars+1;j++)
           {
            double r=MathLog(Close[in+j]/Close[in+j+1]);
            sumx+=r;
            sumx2+=r*r;
           }
         if(numbars==0) { avgx=Close[in]; rmsx=0.0; }
         else  { avgx=sumx/numbars; rmsx=MathSqrt(sumx2/numbars); }
         P = ((avgx/rmsx)+1)/2.0;
         G = P * MathLog(1+rmsx) + (1-P) * MathLog(1-rmsx);
         entropy[out]=G;
        }
      in++; out++;
     }
  }
//+------------------------------------------------------------------+
