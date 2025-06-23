//+------------------------------------------------------------------+
//|                                                       Bezier.mq4 |
//|                      Copyright © 2007, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, MetaQuotes Software Corp."
#property link      "Lizhniyk E"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Aqua

//---- input parameters
extern int period=8;
extern double t=0.5;
extern int shift=0;
extern int  Price=0;
double Ext[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,Ext);
   SetIndexLabel(0,"Bezier("+period+","+t+")");
   SetIndexShift(0,shift);
   SetIndexDrawBegin(0,period);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
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
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+period;
//----

   for(int j=0;j<limit;j++)
     {
      double r=0;
      for(int i=period;i>=0;i--)
        {
         r+=pr(Price,j+i) *
            (fact(period)/(fact(i)*fact(period-i))) *
            MathPow(t,i) *
            MathPow(1-t,period-i);
        }
      Ext[j]=r;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
double fact(int value)
  {
   double res=1;
   for(double j=2;j<value+1;j++)
     {
      res*=j;
     }
   return(res);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double pr(int Price,int n)
  {
   switch(Price)
     {
      case 0: {return(Close[n]);break;}
      case 1: {return(Open[n]);break;}
      case 2: {return(High[n]);break;}
      case 3: {return(Low[n]);break;}
      case 4: {return((High[n]+Low[n])/2);break;}
      case 5: {return((High[n]+Low[n]+Close[n])/3);break;}
      case 6: {return((High[n]+Low[n]+Close[n]+Close[n])/4);break;}
      case 7: {return(iMA(Symbol(),0,4,0,0,0,n));break;}
     }
  }
//+------------------------------------------------------------------+
