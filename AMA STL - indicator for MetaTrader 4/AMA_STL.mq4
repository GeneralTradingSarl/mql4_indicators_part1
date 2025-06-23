//+------------------------------------------------------------------+
//|                                                      AMA STL.mq4 |
//|                      Copyright © 2006, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red
//----
extern int FastMA = 3;
extern int SlowMA = 100;
extern int Range = 160;
extern int filter = 25;
extern int NBars = 5000;
//----
double fAMA[];
double mAMA[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(2);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, fAMA);
   SetIndexBuffer(1, mAMA);
//----
   IndicatorShortName("AMA_STL(" + FastMA + ", " + SlowMA + ", " + Range + "; " + 
                      filter + ")");   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars = IndicatorCounted();
   int cb, i;
   double  k1, k2, Noise, ER, SSC, AMA, sdAMA, dAMA;
//----
   if(Bars <= NBars) 
       return(0);
   else
     {
       k1 = 2.0 / (SlowMA + 1);
       k2 = 2.0 / (FastMA + 1) - k1;
       AMA = Close[NBars-Range];
       mAMA[NBars-Range] = Close[NBars-Range+1];
       //----
       for(cb = NBars - counted_bars - Range - 1; cb >= 0; cb--)
         {
           Noise = 0;
           //----
           for(i = cb; i <= cb + Range - 1; i++)
             {
               Noise = Noise + MathAbs(Close[i] - Close[i+1]);
             }
           //----
           if(Noise != 0)
             {
               ER = MathAbs(Close[cb] - Close[cb+Range]) / Noise;
             }
           else
             {
               ER = 0;
             }
           SSC = (ER*k2 + k1);
           AMA = AMA + NormalizeDouble(SSC*SSC*(Close[cb] - AMA), 4);
           mAMA[cb] = AMA;
           //----
           if(filter < 1)
             {
               fAMA[cb] = mAMA[cb];
             }
           else
             {
               for(i = cb; i <= cb + SlowMA - 1; i++)
                 {
                   sdAMA = sdAMA + MathAbs(mAMA[i] - mAMA[i+1]);
                 }
               dAMA = mAMA[cb] - mAMA[cb+1];
               //----
               if(dAMA >= 0)
                 {
                   if(dAMA < NormalizeDouble(filter*sdAMA / (100*SlowMA), 4) && 
                      High[cb] <= High[Highest(NULL, 0, MODE_HIGH, 4, cb)] + 10*Point)
                     {
                       fAMA[cb] = fAMA[cb+1];
                     }
                   else
                     {
                       fAMA[cb] = mAMA[cb];
                     }
                 }
               else
                 {
                   if(MathAbs(dAMA) < NormalizeDouble(filter*sdAMA / (100*SlowMA), 4) && 
                      Low[cb] > Low[Lowest(NULL, 0, MODE_LOW, 4, cb)] - 10*Point)
                     {
                       fAMA[cb] = fAMA[cb+1];
                     }
                   else
                     {
                       fAMA[cb] = mAMA[cb];
                     }
                 }
               sdAMA=0.0;
             }
         }
     }
   return(0);
  }
//+------------------------------------------------------------------+