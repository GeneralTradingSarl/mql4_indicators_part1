//+------------------------------------------------------------------+
//|                                            Center of Gravity.mq4 |
//|                      Copyright © 2007, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
//----
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 OrangeRed
//---- input parameters
extern int       Per = 10;
extern int       PriceType = 0; // Close
// Constant          Value Description 
// PRICE_CLOSE       0     Close price. 
// PRICE_OPEN        1     Open price. 
// PRICE_HIGH        2     High price. 
// PRICE_LOW         3     Low price. 
// PRICE_MEDIAN      4     Median price, (high+low)/2. 
// PRICE_TYPICAL     5     Typical price, (high+low+close)/3. 
// PRICE_WEIGHTED    6     Weighted close price, (high+low+close+close)/4. 
extern int       SmoothPer = 3;
extern int       SmoothType = 0; // MODE_SMA
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
//+------------------------------------------------------------------+
//| возвращает цену                                                  |
//+------------------------------------------------------------------+
double Price(int shift)
  {
//----
   double res;
//----
   switch (PriceType)
     {
       case PRICE_OPEN:     res = Open[shift]; break;
       case PRICE_HIGH:     res = High[shift]; break;
       case PRICE_LOW:      res = Low[shift]; break;
       case PRICE_MEDIAN:   res = (High[shift] + Low[shift]) / 2.0; break;
       case PRICE_TYPICAL:  res = (High[shift] + Low[shift] + 
                                  Close[shift])/3.0; break;
       case PRICE_WEIGHTED: res = (High[shift] + Low[shift] + 
                                  2*Close[shift]) / 4.0; break;
       default:             res = Close[shift]; break;
     }
   return(res);
  }
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexLabel(0, "CG Main");
   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(1, ExtMapBuffer2);
   SetIndexLabel(1, "CG Signal");
   IndicatorShortName("CG(" + Per + ", " + SmoothPer + ")");
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
   int i, k, limit, limit1;
//----
   if(counted_bars == 0) 
     {
       limit = Bars - Per - 1;
       limit1 = limit - SmoothPer;
     }
   if(counted_bars>0)  
     {
       limit = Bars - counted_bars;
       limit1 = limit;
     }
   double P;
   for(i = limit; i >= 0; i--)
     {
       P = 0;
       for(k = 0; k < Per; k++)
           P += (k + 1)*Price(i + k);
       ExtMapBuffer1[i] = -P / (iMA(NULL, 0, Per, 0, MODE_SMA, PriceType, i)*Per);   
     }   
   for(i = limit1; i >= 0; i--)
       ExtMapBuffer2[i] = iMAOnArray(ExtMapBuffer1, 0, SmoothPer, 0, SmoothType, i);   
//----
   return(0);
  }
//+------------------------------------------------------------------+