//+------------------------------------------------------------------+
//|                                               FloatingSpread.mq4 |
//|                                               Yuriy Tokman (YTG) |
//|                                            yuriytokman@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman (YTG)"
#property link      "yuriytokman@gmail.com"
#property version   "1.00"
#property strict
#property indicator_separate_window

#property indicator_buffers 4
#property indicator_color1 clrBlue
#property indicator_color2 clrRed
#property indicator_color3 clrGreen
#property indicator_color4 clrTeal

input string Symbol_1 = "EURUSD";
input string Symbol_2 = "GBPUSD";
input string Symbol_3 = "USDCHF";
input string Symbol_4 = "USDJPY";

input int    DrawBars=130;

double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];

string name="FloatingSpread";
int Draw_Bars;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   IndicatorShortName(name);
   IndicatorDigits(1);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexLabel(0,Symbol_1);

   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexLabel(1,Symbol_2);

   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexLabel(2,Symbol_3);

   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,ExtMapBuffer4);
   SetIndexLabel(3,Symbol_4);
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
   double pa=MarketInfo(Symbol_1,MODE_ASK); double pb=MarketInfo(Symbol_1,MODE_BID);
   if(pa==0 && pb==0){Alert(" ERROR: Check up in the review of the market presence of a symbol: "+Symbol_1);return(0);}
   pa=MarketInfo(Symbol_2,MODE_ASK); pb=MarketInfo(Symbol_2,MODE_BID);
   if(pa==0 && pb==0){Alert(" ERROR: Check up in the review of the market presence of a symbol: "+Symbol_2);return(0);}
   pa=MarketInfo(Symbol_3,MODE_ASK); pb=MarketInfo(Symbol_3,MODE_BID);
   if(pa==0 && pb==0){Alert(" ERROR: Check up in the review of the market presence of a symbol: "+Symbol_3);return(0);}
   pa=MarketInfo(Symbol_4,MODE_ASK); pb=MarketInfo(Symbol_4,MODE_BID);
   if(pa==0 && pb==0){Alert(" ERROR: Check up in the review of the market presence of a symbol: "+Symbol_4);return(0);}
//---
   if(Bars<=2)
     {
      Print(" no bars, you need to download quotes !"+" Bars="+DoubleToStr(Bars,0)+" DrawBars="+DoubleToStr(Draw_Bars,0));
      return(0);
     }
   Draw_Bars=Bars-2;
   if(Draw_Bars>0 && Draw_Bars<Bars-2)Draw_Bars=DrawBars;
   for(int i=Draw_Bars; i>=0; i --)
     {
      ExtMapBuffer1[i+1] = ExtMapBuffer1[i];
      ExtMapBuffer2[i+1] = ExtMapBuffer2[i];
      ExtMapBuffer3[i+1] = ExtMapBuffer3[i];
      ExtMapBuffer4[i+1]=ExtMapBuffer4[i];
     }
//---
   ExtMapBuffer1[0]=(MarketInfo(Symbol_1,MODE_ASK)-MarketInfo(Symbol_1,MODE_BID))/MarketInfo(Symbol_1,MODE_POINT);
   ExtMapBuffer2[0]=(MarketInfo(Symbol_2,MODE_ASK)-MarketInfo(Symbol_2,MODE_BID))/MarketInfo(Symbol_2,MODE_POINT);
   ExtMapBuffer3[0]=(MarketInfo(Symbol_3,MODE_ASK)-MarketInfo(Symbol_3,MODE_BID))/MarketInfo(Symbol_3,MODE_POINT);
   ExtMapBuffer4[0]=(MarketInfo(Symbol_4,MODE_ASK)-MarketInfo(Symbol_4,MODE_BID))/MarketInfo(Symbol_4,MODE_POINT);
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
