//+------------------------------------------------------------------+
//|                                                   CandleStrength |
//|                                       Copyright 2016, Il Anokhin |
//|                           http://www.mql5.com/en/users/ilanokhin |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2016, Il Anokhin"
#property link "http://www.mql5.com/en/users/ilanokhin"
#property description ""
#property strict
//-------------------------------------------------------------------------
// Indicator settings
//-------------------------------------------------------------------------
#property  indicator_separate_window
#property  indicator_buffers 1
#property  indicator_color1 Blue
#property  indicator_width1 4
//-------------------------------------------------------------------------
// Variables
//-------------------------------------------------------------------------
double c[],pip;
//-------------------------------------------------------------------------
// 1. Initialization
//-------------------------------------------------------------------------
int OnInit(void)
  {

   IndicatorBuffers(1);

   SetIndexStyle(0,DRAW_HISTOGRAM);

   SetIndexBuffer(0,c);

   Comment("Copyright © 2016, Il Anokhin");

   return(INIT_SUCCEEDED);

  }
//-------------------------------------------------------------------------
// 2. Deinitialization
//-------------------------------------------------------------------------
int deinit() {return(0);}
//-------------------------------------------------------------------------
// 3. Main function
//-------------------------------------------------------------------------
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {

   int i,lim,cb;

   if(Bars<10) return(0);

   cb=IndicatorCounted();

   lim=Bars-cb;

   if(cb==0) lim=lim-11;

   if(cb>0) lim++;

//--- 3.1. Define pip -----------------------------------------------------

   if(Digits==4 || Digits<=2) pip=Point;

   if(Digits==5 || Digits==3) pip=Point*10;

//--- 3.2. Main loop ------------------------------------------------------

   for(i=lim;i>0;i--)
     {

      c[i]=(Close[i]-Open[i])/pip;

     }

//--- 3.3. End of main function -------------------------------------------

   return(rates_total);

  }

//-------------------------------------------------------------------------
