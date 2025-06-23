//+------------------------------------------------------------------+
//|                                                         AutoFibo |
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
#property  indicator_chart_window
//-------------------------------------------------------------------------
// Inputs
//-------------------------------------------------------------------------
input int ZZDepth = 12;             //ZigZag Depth
input int ZZDeviation = 5;          //ZigZag Deviation
input int ZZBackstep = 3;           //ZigZag Backstep
input color FiboLine = clrMagenta;  //Fibo Line Color
input color FiboLevels = clrBlue;   //Fibo Levels Color
//-------------------------------------------------------------------------
// Variables
//-------------------------------------------------------------------------
double l0,l1,l2,z0,zz;

int g;

datetime t0,t1,t2;
//-------------------------------------------------------------------------
// 1. Initialization
//-------------------------------------------------------------------------
int OnInit(void)
  {

   Comment("Copyright © 2016, Il Anokhin");

   return(INIT_SUCCEEDED);

  }
//-------------------------------------------------------------------------
// 2. Deinitialization
//-------------------------------------------------------------------------
int deinit() {ObjectDelete(ChartID(),"Fibo Levels"); return(0);}
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

//--- 3.1. Main loop ------------------------------------------------------

   g=0;

   for(i=0;g<3;i++)
     {

      zz=iCustom(NULL,0,"ZigZag",ZZDepth,ZZDeviation,ZZBackstep,0,i);

      if(zz>0 && g==2) {t2=Time[i]; l1=zz; g=3;}

      if(zz>0 && g==1) {t1=Time[i]; l2=zz; g=2;}

      if(zz>0 && g==0) {t0=Time[i]; l0=zz; g=1;}

     }

//--- 3.2. Creating Fibo Retracement --------------------------------------            

   if(l0!=z0) ObjectDelete(ChartID(),"Fibo Levels");

   ObjectCreate(ChartID(),"Fibo Levels",OBJ_FIBO,0,t2,l1,t1,l2);

   ObjectSetInteger(ChartID(),"Fibo Levels",OBJPROP_LEVELCOLOR,FiboLevels);

   ObjectSetInteger(ChartID(),"Fibo Levels",OBJPROP_WIDTH,2);

   ObjectSetInteger(ChartID(),"Fibo Levels",OBJPROP_COLOR,FiboLine);

   z0=l0;

//--- 3.3. End of main function -------------------------------------------

   return(rates_total);

  }

//-------------------------------------------------------------------------
