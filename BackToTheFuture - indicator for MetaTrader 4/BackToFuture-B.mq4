/*------------------------------------------------------------------+
 |                                               BackToFuture-B.mq4 |
 |                                                 Copyright © 2010 |
 |                                             basisforex@gmail.com |
 +------------------------------------------------------------------*/
#property copyright "Copyright © 2010, basisforex@gmail.com"
#property link      "basisforex@gmail.com"
//-----
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 Yellow
#property indicator_color2 Red
#property indicator_color3 Green
#property indicator_minimum 0
#property indicator_maximum 100
#property indicator_level1 76
#property indicator_level2 62
#property indicator_level3 50
#property indicator_level4 38
#property indicator_level5 24
//----- 
extern int      indPeriod  = 4;
extern double   UpLevel    = 76.4;
extern double   DnLevel    = 23.6;
//----- 
double MainBuffer[];
double bufRed[];
double bufGreen[];
double buf[];
double sumH[];
//+------------------------------------------------------------------+
int init()
 {
   IndicatorBuffers(5);
   
   string short_name;
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 1);
   SetIndexBuffer(0, MainBuffer);
   //------
   SetIndexStyle(1, DRAW_LINE, STYLE_SOLID, 2);
   SetIndexBuffer(1, bufRed);
   //------
   SetIndexStyle(2, DRAW_LINE, STYLE_SOLID, 2);
   SetIndexBuffer(2, bufGreen);
   //------
   SetIndexBuffer(3, buf);  
   SetIndexBuffer(4, sumH); 
   //-----
   short_name="BackToFuture("+indPeriod+")";
   IndicatorShortName(short_name);  
   return(0);
 }
//+------------------------------------------------------------------+
int start()
 {
   double sumC = 0;
   int counted_bars = IndicatorCounted();
   int i, j, k;
   j = Bars - indPeriod;
   if(counted_bars >= indPeriod) j = Bars - counted_bars - 1;
   //-----
   for(i = j; i >= 0; i--)
    {      
      buf[i] = 100 * ((Close[i] - Low[i]) / ((High[i] - Low[i]) + Point));
      for(k = i; k < i + indPeriod; k++)
       {
         sumC += buf[k];
       }
      sumH[i] = sumC / indPeriod;
      //---------------------
      MainBuffer[i] = sumH[i];
      if(sumH[i] >= UpLevel)
       {
         bufRed[i] = sumH[i];
       }
      if(sumH[i] <= DnLevel)
       {
         bufGreen[i] = sumH[i];
       }  
      //-----
      sumC = 0; 
    }  
   //-----
   return(0);
 }