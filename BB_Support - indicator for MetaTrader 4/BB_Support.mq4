/*------------------------------------------------------------------+
 |                                               BB_Support.mq4.mq4 |
 |                                                 Copyright © 2010 |
 |                                             basisforex@gmail.com |
 +------------------------------------------------------------------*/
#property copyright "Copyright © 2010, basisforex@gmail.com"
#property link      "basisforex@gmail.com"
//-----
#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 White
#property indicator_color2 Yellow
#property indicator_color3 Blue
#property indicator_color4 Black
#property indicator_color5 White
#property indicator_color6 Yellow
#property indicator_color7 Blue
#property indicator_color8 Black
//-----
extern int        M1Period    = 20;
extern int        M1Deviation = 2;
extern int        M5Period    = 20;
extern int        M5Deviation = 2;
extern int        H1Period    = 20;
extern int        H1Deviation = 2;
extern int        D1Period    = 20;
extern int        D1Deviation = 2;
//-----
extern int        MaShift     = 0;
extern int        PRICE_Ma    = 6;
//-----
double M1up[];
double M5up[];
double H1up[];
double D1up[];
double M1dn[];
double M5dn[];
double H1dn[];
double D1dn[];
//+------------------------------------------------------------------+
int init()
 {
   SetIndexShift(0, MaShift);
   SetIndexShift(1, MaShift);
   SetIndexShift(2, MaShift);
   SetIndexShift(3, MaShift);
   SetIndexShift(4, MaShift);
   SetIndexShift(5, MaShift);
   SetIndexShift(6, MaShift);
   SetIndexShift(7, MaShift);
   //-----
   SetIndexBuffer(0, M1up);
   SetIndexBuffer(1, M5up);
   SetIndexBuffer(2, H1up);
   SetIndexBuffer(3, D1up);
   SetIndexBuffer(4, M1dn);
   SetIndexBuffer(5, M5dn);
   SetIndexBuffer(6, H1dn);
   SetIndexBuffer(7, D1dn);
   //-----
   SetIndexStyle(0, DRAW_LINE);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexStyle(2, DRAW_LINE);
   SetIndexStyle(3, DRAW_LINE);
   SetIndexStyle(4, DRAW_LINE);
   SetIndexStyle(5, DRAW_LINE);
   SetIndexStyle(6, DRAW_LINE);
   SetIndexStyle(7, DRAW_LINE);
   //-----
   SetIndexLabel(0, "M1up");
   SetIndexLabel(1, "M5up");
   SetIndexLabel(2, "H1up");
   SetIndexLabel(3, "D1up");
   SetIndexLabel(4, "M1dn");
   SetIndexLabel(5, "M5dn");
   SetIndexLabel(6, "H1dn");
   SetIndexLabel(7, "D1dn");
   //-----
   return(0);
 }
//+------------------------------------------------------------------+
int start()
 {
   if (Period() != 1)
    {
		Comment("Not a right Period!!!   It should be M1");
		return(0);	
	 }
   int limit;
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0) return(-1);
   if(counted_bars > 0) counted_bars--;
   limit = Bars - counted_bars;
   for(int i = 0; i < limit; i++)
    {
      M1up[i]   = iBands(NULL, PERIOD_M1, M1Period, M1Deviation, 0, PRICE_Ma, MODE_UPPER, i);
      M5up[i]   = iBands(NULL, PERIOD_M5, M5Period, M5Deviation, 0, PRICE_Ma, MODE_UPPER, i / PERIOD_M5);
      H1up[i]   = iBands(NULL, PERIOD_H1, H1Period, H1Deviation, 0, PRICE_Ma, MODE_UPPER, i / PERIOD_H1);
      D1up[i]   = iBands(NULL, PERIOD_D1, D1Period, D1Deviation, 0, PRICE_Ma, MODE_UPPER, i / PERIOD_D1);
      //-----
      M1dn[i]  = iBands(NULL, PERIOD_M1, M1Period, M1Deviation, 0, PRICE_Ma, MODE_LOWER, i);
      M5dn[i]  = iBands(NULL, PERIOD_M5, M5Period, M5Deviation, 0, PRICE_Ma, MODE_LOWER, i / PERIOD_M5);
      H1dn[i]  = iBands(NULL, PERIOD_H1, H1Period, H1Deviation, 0, PRICE_Ma, MODE_LOWER, i / PERIOD_H1);
      D1dn[i]  = iBands(NULL, PERIOD_D1, D1Period, D1Deviation, 0, PRICE_Ma, MODE_LOWER, i / PERIOD_D1);
    }  
   //-----
   return(0);
 }
//+------------------------------------------------------------------+

