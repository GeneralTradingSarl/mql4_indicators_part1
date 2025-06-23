//+------------------------------------------------------------------+
//|                             Elder Impulse System Candlestick.mq4 |
//|                            Copyright 2023, ksspjan67@hotmail.com |
//|                                      email:ksspjan67@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, ksspjan67@hotmail.com"
#property link      "email:ksspjan67@hotmail.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 8
#property indicator_plots   8
//---
string shortname="Elder Impulse System Candlestick";
//--- plot BullWick
#property indicator_label1  "BullWick"
#property indicator_type1   DRAW_HISTOGRAM
#property indicator_color1  clrGreen
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot BearWick
#property indicator_label2  "BearWick"
#property indicator_type2   DRAW_HISTOGRAM
#property indicator_color2  clrOrangeRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot BullBody
#property indicator_label3  "BullBody"
#property indicator_type3   DRAW_HISTOGRAM
#property indicator_color3  clrGreen
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- plot BearBody
#property indicator_label4  "BearBody"
#property indicator_type4   DRAW_HISTOGRAM
#property indicator_color4  clrOrangeRed
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1
//--- plot BlueWick1
#property indicator_label5  "BlueWick1"
#property indicator_type5   DRAW_HISTOGRAM
#property indicator_color5  clrDodgerBlue
#property indicator_style5  STYLE_SOLID
#property indicator_width5  1
//--- plot BlueWick2
#property indicator_label6  "BlueWick2"
#property indicator_type6   DRAW_HISTOGRAM
#property indicator_color6  clrDodgerBlue
#property indicator_style6  STYLE_SOLID
#property indicator_width6  1
//--- plot BlueBody1
#property indicator_label7  "BlueBody1"
#property indicator_type7   DRAW_HISTOGRAM
#property indicator_color7  clrDodgerBlue
#property indicator_style7  STYLE_SOLID
#property indicator_width7  1
//--- plot BlueBody2
#property indicator_label8  "BlueBody2"
#property indicator_type8   DRAW_HISTOGRAM
#property indicator_color8  clrDodgerBlue
#property indicator_style8  STYLE_SOLID
#property indicator_width8  1
//--- input parameters
input int      Fast_EMA=12;// MACD Fast EMA period
input int      Slow_EMA=26;// MACD Slow EMA period
input int      Signal_SMA=9;// MACD Signal SMA period
input int      Trend_EMA=13;// Elder Trend EMA period
//--- indicator buffers
double         BullWickBuffer[];
double         BearWickBuffer[];
double         BullBodyBuffer[];
double         BearBodyBuffer[];
double         BlueWick1Buffer[];
double         BlueWick2Buffer[];
double         BlueBody1Buffer[];
double         BlueBody2Buffer[];
//---
int min_rates_total;
int chartscale;
//---
double cosma,posma,cema,pema,opnp,higp,lowp,clsp;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,BullWickBuffer);
   SetIndexBuffer(1,BearWickBuffer);
   SetIndexBuffer(2,BullBodyBuffer);
   SetIndexBuffer(3,BearBodyBuffer);
   SetIndexBuffer(4,BlueWick1Buffer);
   SetIndexBuffer(5,BlueWick2Buffer);
   SetIndexBuffer(6,BlueBody1Buffer);
   SetIndexBuffer(7,BlueBody2Buffer);
   //---
   IndicatorSetString(INDICATOR_SHORTNAME,shortname);
   IndicatorSetInteger(INDICATOR_DIGITS,Digits+1);
   //---
   min_rates_total=MathMax(Slow_EMA,Trend_EMA+1)+2;//---
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
   chartscale=ChartScaleGet(0);
//--
   static int prevchartscale=-1;
   if(prevchartscale!=chartscale)
     {
      prevchartscale=chartscale;
      //---
      int pixelperbar=0;
      int barwidth=0;
      //---
      pixelperbar=(int)MathPow(2,chartscale);
      barwidth=(int)NormalizeDouble(pixelperbar*0.4,0);
      //---
      SetIndexStyle(2,DRAW_HISTOGRAM,STYLE_SOLID,barwidth);
      SetIndexStyle(3,DRAW_HISTOGRAM,STYLE_SOLID,barwidth);
      SetIndexStyle(6,DRAW_HISTOGRAM,STYLE_SOLID,barwidth);
      SetIndexStyle(7,DRAW_HISTOGRAM,STYLE_SOLID,barwidth);
     }
//---
   int i,limit;
   if(rates_total<min_rates_total)
      return(0);
   if(prev_calculated>rates_total || prev_calculated<=0)
      limit=rates_total-1-min_rates_total;
   else
      limit=rates_total-prev_calculated;
//---
   for(i=limit; i>=0; i--)
     {
      cosma=iOsMA(NULL,0,Fast_EMA,Slow_EMA,Signal_SMA,PRICE_CLOSE,i);
      posma=iOsMA(NULL,0,Fast_EMA,Slow_EMA,Signal_SMA,PRICE_CLOSE,i+1);
      cema=iMA(NULL,0,Trend_EMA,0,MODE_EMA,PRICE_CLOSE,i);
      pema=iMA(NULL,0,Trend_EMA,0,MODE_EMA,PRICE_CLOSE,i+1);
      opnp=iOpen(NULL,0,i);
      higp=iHigh(NULL,0,i);
      lowp=iLow(NULL,0,i);
      clsp=iClose(NULL,0,i);
      //---
      if(cema>pema && cosma>posma)
        {
         BullWickBuffer[i]=higp;
         BearWickBuffer[i]=lowp;
         BullBodyBuffer[i]=MathMax(clsp,opnp);
         BearBodyBuffer[i]=MathMin(clsp,opnp);
         BlueWick1Buffer[i]=EMPTY_VALUE;
         BlueWick2Buffer[i]=EMPTY_VALUE;
         BlueBody1Buffer[i]=EMPTY_VALUE;
         BlueBody2Buffer[i]=EMPTY_VALUE;
        }
      else
      if(cema<pema && cosma<posma)
        {
         BullWickBuffer[i]=lowp;
         BearWickBuffer[i]=higp;
         BullBodyBuffer[i]=MathMin(clsp,opnp);
         BearBodyBuffer[i]=MathMax(clsp,opnp);
         BlueWick1Buffer[i]=EMPTY_VALUE;
         BlueWick2Buffer[i]=EMPTY_VALUE;
         BlueBody1Buffer[i]=EMPTY_VALUE;
         BlueBody2Buffer[i]=EMPTY_VALUE;
        }
      else
        {
         BullWickBuffer[i]=EMPTY_VALUE;
         BearWickBuffer[i]=EMPTY_VALUE;
         BullBodyBuffer[i]=EMPTY_VALUE;
         BearBodyBuffer[i]=EMPTY_VALUE;
         BlueWick1Buffer[i]=higp;
         BlueWick2Buffer[i]=lowp;
         BlueBody1Buffer[i]=MathMax(clsp,opnp);
         BlueBody2Buffer[i]=MathMin(clsp,opnp);
        }
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Get chart scale (from 0 to 5).                                   |
//+------------------------------------------------------------------+
int ChartScaleGet(const long chart_ID=0)
  {
//--- prepare the variable to get the property value
   long result=-1;
//--- reset the error value
   ResetLastError();
//--- receive the property value
   if(!ChartGetInteger(chart_ID,CHART_SCALE,0,result))
     {
      //--- display the error message in Experts journal
      Print(__FUNCTION__+", Error Code = ",GetLastError());
     }
//--- return the value of the chart property
   return((int)result);
  }
