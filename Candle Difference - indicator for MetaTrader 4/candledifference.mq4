//+------------------------------------------------------------------+
//|                                                 CandleDifference |
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
input ENUM_TIMEFRAMES CT = PERIOD_D1;        //Candle Timeframe
input string P1 = "EURUSD";                  //Pair 1
input string P2 = "GBPUSD";                  //Pair 2
input string P3 = "AUDUSD";                  //Pair 3
input string P4 = "GBPJPY";                  //Pair 4
input string P5 = "USDCHF";                  //Pair 5
input string P6 = "USDCAD";                  //Pair 6
input string P7 = "USDJPY";                  //Pair 7
input string P8 = "EURJPY";                  //Pair 8
//-------------------------------------------------------------------------
// Variables
//-------------------------------------------------------------------------
double d[8],sp;
string pair[8],data;
//-------------------------------------------------------------------------
// 1. Initialization
//-------------------------------------------------------------------------
int OnInit(void)
  {
   pair[0]=P1;
   pair[1]=P2;
   pair[2]=P3;
   pair[3]=P4;
   pair[4]=P5;
   pair[5]=P6;
   pair[6]=P7;
   pair[7]=P8;

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

//--- 3.1. Difference Calculation -----------------------------------------
   for(i=0;i<8;i++)
     {
      sp=0;
      if(pair[i]!="") sp=iOpen(pair[i],CT,0);
      if(sp>0) d[i]=100*MarketInfo(pair[i],MODE_BID)/sp-100;
     }

//--- 3.2. Printing Data -------------------------------------------------- 
   data="Copyright © 2016, Il Anokhin\n-------------------------\n";
   for(i=0;i<8;i++)
     {
      if(pair[i]!="") data=data+pair[i]+": "+DoubleToStr(d[i],2)+"%\n";
     }

   Comment(data);

//--- 3.3. End of main function -------------------------------------------
   return(rates_total);
  }
//-------------------------------------------------------------------------
