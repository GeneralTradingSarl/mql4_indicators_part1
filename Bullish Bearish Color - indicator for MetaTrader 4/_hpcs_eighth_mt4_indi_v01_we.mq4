//+------------------------------------------------------------------+
//|                             _HPCS_SeventhBeg_MT4_Indi_V01_WE.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 4

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

double gd_Arr1_Bullish[],gd_Arr2_Bullish[],gd_Arr1_Bearish[],gd_Arr2_Bearish[];

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

   SetIndexBuffer(0,gd_Arr1_Bullish);
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_DASH,5,clrAqua);

   SetIndexBuffer(1,gd_Arr2_Bullish);
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID,5,clrAqua);

   SetIndexBuffer(2,gd_Arr1_Bearish);
   SetIndexStyle(2,DRAW_HISTOGRAM,STYLE_DASH,5,clrRed);

   SetIndexBuffer(3,gd_Arr2_Bearish);
   SetIndexStyle(3,DRAW_HISTOGRAM,STYLE_SOLID,5,clrRed);


//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
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
//---
   if(prev_calculated == 0)
     {
      for(int i = Bars-2; i > 0; i--)
        {
         if(Close[i] > Open[i])
           {
            gd_Arr1_Bullish[i] = Close[i];
            gd_Arr2_Bullish[i] = Open[i];
           }
         if(Close[i] < Open[i])
           {
            gd_Arr1_Bearish[i] = Close[i];
            gd_Arr2_Bearish[i] = Open[i];
           }
        }
     }

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
