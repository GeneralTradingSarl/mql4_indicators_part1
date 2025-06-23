//+------------------------------------------------------------------+
//|                                                    AMA SLOPE.mq4 |
//|                                                          Kalenzo |
//|                                     bartlomiej.gorski@gmail.com  |
//|                I used the idea of P.Kauffman and code from KAMA  |
//|                                 made by © 2004, by konKop,wellx  |
//+------------------------------------------------------------------+
#property copyright "Kalenzo"
#property link      "bartlomiej.gorski@gmail.com"
//----
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 SaddleBrown
//---- input parameters
extern int       periodAMA=9;
extern int       nfast=2;
extern int       nslow=30;
extern double    G=2.0;
//---- buffers
double kAMAbuffer[];
//+------------------------------------------------------------------+
int    cbars=0, prevbars=0, prevtime=0;
double slowSC,fastSC;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE,0,1);
   SetIndexBuffer(0,kAMAbuffer);
   IndicatorDigits(4);
   IndicatorShortName("AMA SLOPE");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    i,pos=0;
   double noise=0.000000001,AMA,AMA0,signal,ER;
   double dSC,ERSC,SSC,ddK;
//----
   if (prevbars==Bars) return(0);
   slowSC=(2.0 /(nslow+1));
   fastSC=(2.0 /(nfast+1));
   cbars=IndicatorCounted();
//----
   if (Bars<=(periodAMA+2)) return(0);
   if (cbars<0) return(-1);
   if (cbars>0) cbars--;
   pos=Bars-periodAMA-2;
   AMA0=Close[pos+1];
   while(pos>=0)
     {
      if(pos==Bars-periodAMA-2) AMA0=Close[pos+1];
      signal=MathAbs(Close[pos]-Close[pos+periodAMA]);
      noise=0.000000001;
      for(i=0;i<periodAMA;i++)
        {
         noise=noise+MathAbs(Close[pos+i]-Close[pos+i+1]);
        }
      ER =signal/noise;
      dSC=(fastSC-slowSC);
      ERSC=ER*dSC;
      SSC=ERSC+slowSC;
      AMA=AMA0+(MathPow(SSC,G)*(Close[pos]-AMA0));
      ddK=(AMA-AMA0);
      kAMAbuffer[pos]=ddK;
      AMA0=AMA;
      pos--;
     }
//----
   prevbars=Bars;
   return(0);
  }
//+------------------------------------------------------------------+