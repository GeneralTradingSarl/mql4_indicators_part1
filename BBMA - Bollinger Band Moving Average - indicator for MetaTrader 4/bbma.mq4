#property copyright   "BestForexScript.Com"
#property link        "https://bestforexscript.com"
#property version   "1.01"
#property description "Download Expert Advisors and Indicator for FREE!"
#property description "Want an EA with Indicator, contact me on telegram: @sopheak_khmer_trader"
#property strict


#property indicator_chart_window
#property indicator_buffers 16

#property indicator_color1 clrBlack
#property indicator_width1 1
#property indicator_type1 DRAW_LINE
#property indicator_style1 STYLE_SOLID
#property indicator_label1 "Upper Band"

#property indicator_color2 clrGreen
#property indicator_width2 2
#property indicator_type2 DRAW_LINE
#property indicator_style2 STYLE_SOLID
#property indicator_label2 "Base"

#property indicator_color3 clrBlack
#property indicator_width3 1
#property indicator_type3 DRAW_LINE
#property indicator_style3 STYLE_SOLID
#property indicator_label3 "Lower Band"

#property indicator_color4 clrRed
#property indicator_width4 2
#property indicator_type4 DRAW_LINE
#property indicator_style4 STYLE_SOLID
#property indicator_label4 "MA50"

#property indicator_color5 clrRed
#property indicator_width5 1
#property indicator_type5 DRAW_LINE
#property indicator_style5 STYLE_SOLID
#property indicator_label5 "MH5"

#property indicator_color6 clrRed
#property indicator_width6 1
#property indicator_type6 DRAW_LINE
#property indicator_style6 STYLE_DOT
#property indicator_label6 "MH6"

#property indicator_color7 clrRed
#property indicator_width7 1
#property indicator_type7 DRAW_LINE
#property indicator_style7 STYLE_DOT
#property indicator_label7 "MH7"

#property indicator_color8 clrRed
#property indicator_width8 1
#property indicator_type8 DRAW_LINE
#property indicator_style8 STYLE_DOT
#property indicator_label8 "MH8"

#property indicator_color9 clrRed
#property indicator_width9 1
#property indicator_type9 DRAW_LINE
#property indicator_style9 STYLE_DOT
#property indicator_label9 "MH9"

#property indicator_color10 clrRed
#property indicator_width10 1
#property indicator_type10 DRAW_LINE
#property indicator_style10 STYLE_SOLID
#property indicator_label10 "MH10"

#property indicator_color11 clrBlue
#property indicator_width11 1
#property indicator_type11 DRAW_LINE
#property indicator_style11 STYLE_SOLID
#property indicator_label11 "ML5"

#property indicator_color12 clrBlue
#property indicator_width12 1
#property indicator_type12 DRAW_LINE
#property indicator_style12 STYLE_DOT
#property indicator_label12 "ML6"

#property indicator_color13 clrBlue
#property indicator_width13 1
#property indicator_type13 DRAW_LINE
#property indicator_style13 STYLE_DOT
#property indicator_label13 "ML7"

#property indicator_color14 clrBlue
#property indicator_width14 1
#property indicator_type14 DRAW_LINE
#property indicator_style14 STYLE_DOT
#property indicator_label14 "ML8"

#property indicator_color15 clrBlue
#property indicator_width15 1
#property indicator_type15 DRAW_LINE
#property indicator_style15 STYLE_DOT
#property indicator_label15 "ML9"

#property indicator_color16 clrBlue
#property indicator_width16 1
#property indicator_type16 DRAW_LINE
#property indicator_style16 STYLE_SOLID
#property indicator_label16 "ML10"



double UpperBandBuffer[];
double BaseBuffer[];
double LowerBandBuffer[];
double MA50Buffer[];

double MH5Buffer[];
double MH6Buffer[];
double MH7Buffer[];
double MH8Buffer[];
double MH9Buffer[];
double MH10Buffer[];


double ML5Buffer[];
double ML6Buffer[];
double ML7Buffer[];
double ML8Buffer[];
double ML9Buffer[];
double ML10Buffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   
   IndicatorDigits(_Digits);

   SetIndexBuffer(0,UpperBandBuffer);
   SetIndexBuffer(1,BaseBuffer);
   SetIndexBuffer(2,LowerBandBuffer);
   SetIndexBuffer(3,MA50Buffer);
   SetIndexBuffer(4,MH5Buffer);
   SetIndexBuffer(5,MH6Buffer);
   SetIndexBuffer(6,MH7Buffer);
   SetIndexBuffer(7,MH8Buffer);
   SetIndexBuffer(8,MH9Buffer);
   SetIndexBuffer(9,MH10Buffer);
   
   SetIndexBuffer(10,ML5Buffer);
   SetIndexBuffer(11,ML6Buffer);
   SetIndexBuffer(12,ML7Buffer);
   SetIndexBuffer(13,ML8Buffer);
   SetIndexBuffer(14,ML9Buffer);
   SetIndexBuffer(15,ML10Buffer);
   
   SetIndexDrawBegin(0,50);
   SetIndexDrawBegin(1,50);
   SetIndexDrawBegin(2,50);
   SetIndexDrawBegin(3,50);
   SetIndexDrawBegin(4,50);
   SetIndexDrawBegin(5,50);
   SetIndexDrawBegin(6,50);
   SetIndexDrawBegin(7,50);
   SetIndexDrawBegin(8,50);
   SetIndexDrawBegin(9,50);
   SetIndexDrawBegin(10,50);
   SetIndexDrawBegin(11,50);
   SetIndexDrawBegin(12,50);
   SetIndexDrawBegin(13,50);
   SetIndexDrawBegin(14,50);
   SetIndexDrawBegin(15,50);
   
   SetIndexEmptyValue(0,0.0);
   SetIndexEmptyValue(1,0.0);
   SetIndexEmptyValue(2,0.0);
   SetIndexEmptyValue(3,0.0);
   SetIndexEmptyValue(4,0.0);
   SetIndexEmptyValue(5,0.0);
   SetIndexEmptyValue(6,0.0);
   SetIndexEmptyValue(7,0.0);
   SetIndexEmptyValue(8,0.0);
   SetIndexEmptyValue(9,0.0);
   SetIndexEmptyValue(10,0.0);
   SetIndexEmptyValue(11,0.0);
   SetIndexEmptyValue(12,0.0);
   SetIndexEmptyValue(13,0.0);
   SetIndexEmptyValue(14,0.0);
   SetIndexEmptyValue(15,0.0);
   
   IndicatorShortName("BBMA Indicator");
   
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
         
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
   if(rates_total < 50)return(0);
   
   int limit = fmin(rates_total-1,rates_total - prev_calculated);
   for(int i = limit; i>=0; i--)
   {
      UpperBandBuffer[i] = iBands(_Symbol,_Period,20,2,0,PRICE_CLOSE,MODE_UPPER,i);
      BaseBuffer[i] = iBands(_Symbol,_Period,20,2,0,PRICE_CLOSE,MODE_MAIN,i);
      LowerBandBuffer[i] = iBands(_Symbol,_Period,20,2,0,PRICE_CLOSE,MODE_LOWER,i);
      
      MA50Buffer[i] = iMA(_Symbol,_Period,50,0,MODE_EMA,PRICE_CLOSE,i);
      
      MH5Buffer[i] = iMA(_Symbol,_Period,5,0,MODE_LWMA,PRICE_HIGH,i);
      MH6Buffer[i] = iMA(_Symbol,_Period,6,0,MODE_LWMA,PRICE_HIGH,i);
      MH7Buffer[i] = iMA(_Symbol,_Period,7,0,MODE_LWMA,PRICE_HIGH,i);
      MH8Buffer[i] = iMA(_Symbol,_Period,8,0,MODE_LWMA,PRICE_HIGH,i);
      MH9Buffer[i] = iMA(_Symbol,_Period,9,0,MODE_LWMA,PRICE_HIGH,i);
      MH10Buffer[i] = iMA(_Symbol,_Period,10,0,MODE_LWMA,PRICE_HIGH,i);
      
      ML5Buffer[i] = iMA(_Symbol,_Period,5,0,MODE_LWMA,PRICE_LOW,i);
      ML6Buffer[i] = iMA(_Symbol,_Period,6,0,MODE_LWMA,PRICE_LOW,i);
      ML7Buffer[i] = iMA(_Symbol,_Period,7,0,MODE_LWMA,PRICE_LOW,i);
      ML8Buffer[i] = iMA(_Symbol,_Period,8,0,MODE_LWMA,PRICE_LOW,i);
      ML9Buffer[i] = iMA(_Symbol,_Period,9,0,MODE_LWMA,PRICE_LOW,i);
      ML10Buffer[i] = iMA(_Symbol,_Period,10,0,MODE_LWMA,PRICE_LOW,i);
      
   }
   return(rates_total);
}
