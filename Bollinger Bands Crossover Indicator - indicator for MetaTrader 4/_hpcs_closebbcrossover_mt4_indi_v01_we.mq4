//+------------------------------------------------------------------+
//|                       _HPCS_CloseBBCrossOver_MT4_Indi_V01_WE.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property script_show_inputs
#property indicator_buffers 2
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
input int ii_Period = 20;
input double id_Deviation = 2;
input int ii_BandsShift = 0;

double gd_Arr_BuySignal[],gd_Arr_SellSignal[];
datetime gdt_CurrentTime = Time[1];

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,gd_Arr_BuySignal);
   SetIndexStyle(0,DRAW_ARROW,STYLE_SOLID,3,clrGreen);
   SetIndexArrow(0,233);
   SetIndexLabel(0,"Buy Signal");

   SetIndexBuffer(1,gd_Arr_SellSignal);
   SetIndexStyle(1,DRAW_ARROW,STYLE_SOLID,3,clrRed);
   SetIndexArrow(1,234);
   SetIndexLabel(1,"Sell Signal");

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
      for(int i = Bars-2 ; i>0 ; i-- )
        {

         if(Close[i] > iBands(_Symbol,PERIOD_CURRENT,ii_Period,id_Deviation,ii_BandsShift,PRICE_CLOSE,MODE_UPPER,i) && Close[i+1] <= iBands(_Symbol,PERIOD_CURRENT,ii_Period,id_Deviation,ii_BandsShift,PRICE_CLOSE,MODE_UPPER,i+1))
           {
            gd_Arr_SellSignal[i] = High[i] + 2*Point();
           }
         if(Close[i] < iBands(_Symbol,PERIOD_CURRENT,ii_Period,id_Deviation,ii_BandsShift,PRICE_CLOSE,MODE_UPPER,i) && Close[i+1] >= iBands(_Symbol,PERIOD_CURRENT,ii_Period,id_Deviation,ii_BandsShift,PRICE_CLOSE,MODE_UPPER,i+1))
           {
            gd_Arr_BuySignal[i] = Low[i] - 2*Point();
           }
        }
     }
   if(Close[0] > iBands(_Symbol,PERIOD_CURRENT,ii_Period,id_Deviation,ii_BandsShift,PRICE_CLOSE,MODE_UPPER,0) && Close[1] <= iBands(_Symbol,PERIOD_CURRENT,ii_Period,id_Deviation,ii_BandsShift,PRICE_CLOSE,MODE_UPPER,1))
     {
      gd_Arr_SellSignal[0] = High[0] + 2*Point();
     }
   if(Close[0] < iBands(_Symbol,PERIOD_CURRENT,ii_Period,id_Deviation,ii_BandsShift,PRICE_CLOSE,MODE_UPPER,0) && Close[1] >= iBands(_Symbol,PERIOD_CURRENT,ii_Period,id_Deviation,ii_BandsShift,PRICE_CLOSE,MODE_UPPER,1))
     {
      gd_Arr_BuySignal[0] = Low[0] - 2*Point();
     }


//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
