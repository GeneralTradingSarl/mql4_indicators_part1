//+------------------------------------------------------------------+
#property copyright "Binary Dot"
#property link      "https://www.mql5.com/en/users/denisadha_"
#property version   "1.0"
#property description ""
#property strict    ""
#property indicator_chart_window
#property indicator_buffers 2
//--- Buy Arrow
#property indicator_type1 DRAW_ARROW
#property indicator_width1 2
#property indicator_color1 clrLimeGreen
#property indicator_label1 "Buy Now !!"
//--- Sell Arrow
#property indicator_type2 DRAW_ARROW
#property indicator_width2 2
#property indicator_color2 clrRed
#property indicator_label2 "Sell Now !!"
#include <stdlib.mqh>
#include <stderror.mqh>
//--- extern value
extern int     MovingAverage  = 8;
input double   SARStep        = 0.02;
input double   SARMaximum     = 0.2;
//--- indicator buffers
double Buffer1[];
double Buffer2[];

datetime time_alert; //used when sending alert
extern bool Alerts = true;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void myAlert(string type, string message)
  {
   if(type == "print")
      Print(message);
   else
      if(type == "error")
        {
         Print(type+" | Binary Dot @ "+Symbol()+","+IntegerToString(Period())+" | "+message);
        }
      else
         if(type == "Order")
           {
           }
         else
            if(type == "Modify")
              {
              }
            else
               if(type == "Indicator")
                 {
                  if(Alerts)
                     Alert(type+" | Binary Dot @ "+Symbol()+","+IntegerToString(Period())+" | "+message);
                 }
  }

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   IndicatorBuffers(2);
   SetIndexBuffer(0, Buffer1);
   SetIndexEmptyValue(0, EMPTY_VALUE);
   SetIndexArrow(0, 108);
   SetIndexBuffer(1, Buffer2);
   SetIndexEmptyValue(1, EMPTY_VALUE);
   SetIndexArrow(1, 108);
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime& time[],
                const double& open[],
                const double& high[],
                const double& low[],
                const double& close[],
                const long& tick_volume[],
                const long& volume[],
                const int& spread[])
  {
   int limit = rates_total - prev_calculated;
//--- counting from 0 to rates_total
   ArraySetAsSeries(Buffer1, true);
   ArraySetAsSeries(Buffer2, true);
//--- initial zero
   if(prev_calculated < 1)
     {
      ArrayInitialize(Buffer1, EMPTY_VALUE);
      ArrayInitialize(Buffer2, EMPTY_VALUE);
     }
   else
      limit++;

//--- main loop
   for(int i = limit-1; i >= 0; i--)
     {
      if(i >= MathMin(5000-1, rates_total-1-50))
         continue; //omit some old rates to prevent "Array out of range" or slow calculation

      //Indicator Buffer 1
      if(iSAR(NULL, PERIOD_CURRENT, SARStep, SARMaximum, i) > iMA(NULL, PERIOD_CURRENT, MovingAverage, 0, MODE_SMA, PRICE_CLOSE, i)
         && iSAR(NULL, PERIOD_CURRENT, SARStep, SARMaximum, i+1) < iMA(NULL, PERIOD_CURRENT, MovingAverage, 0, MODE_SMA, PRICE_CLOSE, i+1) //Parabolic SAR crosses above Moving Average
        )
        {
         Buffer1[i] = Low[i]; //Set indicator value at Candlestick Low
         if(i == 1 && Time[1] != time_alert)
            myAlert("indicator", "Buy Now !!"); //Alert on next bar open
         time_alert = Time[1];
        }
      else
        {
         Buffer1[i] = EMPTY_VALUE;
        }
      //Indicator Buffer 2
      if(iSAR(NULL, PERIOD_CURRENT, SARStep, SARMaximum, i) < iMA(NULL, PERIOD_CURRENT, MovingAverage, 0, MODE_SMA, PRICE_CLOSE, i)
         && iSAR(NULL, PERIOD_CURRENT, SARStep, SARMaximum, i+1) > iMA(NULL, PERIOD_CURRENT, MovingAverage, 0, MODE_SMA, PRICE_CLOSE, i+1) //Parabolic SAR crosses below Moving Average
        )
        {
         Buffer2[i] = High[i]; //Set indicator value at Candlestick High
         if(i == 1 && Time[1] != time_alert)
            myAlert("indicator", "Sell Now !!"); //Alert on next bar open
         time_alert = Time[1];
        }
      else
        {
         Buffer2[i] = EMPTY_VALUE;
        }
     }
   return(rates_total);
  }
//+------------------------------------------------------------------+
