//+------------------------------------------------------------------+
//|                                             Donchian Channel.mq4 |
//|                                Copyright 2023, Rain Drop Trading |
//|                                       https://raindroptrading.ca |
//+------------------------------------------------------------------+
#property copyright     "Copyright 2023, Rain Drop Trading."
#property link          "https://raindroptrading.ca"
#property version       "1.00"
#property strict
#property description   " "
#property description   "This is the Donchian Channel Indicator."
#property description   "WARNING : Use at your own risk."

//--- Indicator chart parameters
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 clrGreen
#property indicator_color2 clrBlue
#property indicator_color3 clrGreen
#property indicator_color4 clrRed
#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2
#property indicator_width4 2

//--- Indicator parameters
input int                  InpBarsToLookBack =  20;            // Donchian Bars
input int                  InpMaPeriod       =  14;            // Donchian Ma Period
input ENUM_MA_METHOD       InpMaMethod       =  MODE_SMA;      // Donchian Ma Method

//--- Indicator buffers
double   ExtUppBuffer[];
double   ExtMidBuffer[];
double   ExtLowBuffer[];
double   ExtMaBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {

//--- Indicator buffers mapping
   IndicatorShortName("Donchian Channel (" + IntegerToString(InpBarsToLookBack) + IntegerToString(InpMaPeriod) + IntegerToString(InpMaMethod) + ")");
   IndicatorSetInteger(INDICATOR_DIGITS, _Digits);

//--- Upper line
   SetIndexBuffer(0, ExtUppBuffer);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexLabel(0, "Upper Donchian Channel");

//--- Middle line
   SetIndexBuffer(1, ExtMidBuffer);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexLabel(1, "Middle Donchian Channel");

//--- Lower line
   SetIndexBuffer(2, ExtLowBuffer);
   SetIndexStyle(2, DRAW_LINE);
   SetIndexLabel(2, "Lower Donchian Channel");

//--- Ma line
   SetIndexBuffer(3, ExtMaBuffer);
   SetIndexStyle(3, DRAW_LINE);
   SetIndexLabel(3, "MA Donchian Channel");

//--- Check for input parameter
   if(InpBarsToLookBack <= 0 || InpMaPeriod <= 0) {
      Print("Wrong input parameter period = " + IntegerToString(InpBarsToLookBack) + " or " + IntegerToString(InpMaPeriod));
      return(INIT_PARAMETERS_INCORRECT);
   }

//--- Bars to begin drawing
   SetIndexDrawBegin(0, InpBarsToLookBack);
   SetIndexDrawBegin(1, InpBarsToLookBack);
   SetIndexDrawBegin(2, InpBarsToLookBack);
   SetIndexDrawBegin(3, InpBarsToLookBack + InpMaPeriod);

//--- Initialization succeeded
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
                const int &spread[]) {

//--- Set variables
   int limit = 0;
   int i;
   int offset = 1;
   ExtUppBuffer[i] = EMPTY_VALUE;
   ExtMidBuffer[i] = EMPTY_VALUE;
   ExtLowBuffer[i] = EMPTY_VALUE;
   ExtMaBuffer[i] = EMPTY_VALUE;

//--- Check if there are bars to be calculated
   if(prev_calculated > 0) limit ++;
   limit = rates_total - prev_calculated;

//--- First run through
   if(prev_calculated == 0)
      limit = rates_total - prev_calculated - offset ;

//--- Main loop on each tick
   for (i = limit; i >= 0; i--) {
      ExtUppBuffer[i] = iHigh(Symbol(), Period(), iHighest(Symbol(), Period(), MODE_HIGH, InpBarsToLookBack, i));
      ExtLowBuffer[i] = iLow(Symbol(), Period(), iLowest(Symbol(), Period(), MODE_LOW, InpBarsToLookBack, i));
      ExtMidBuffer[i] = (ExtUppBuffer[i] + ExtLowBuffer[i]) / 2;
   }

   for (i = limit; i >= 0; i--) {
      ExtMaBuffer[i] = iMAOnArray(ExtMidBuffer, 0, InpMaPeriod, 0, InpMaMethod, i);
   }

//--- OnCalculate done and return new prev_calculated
   return(rates_total);
}

//+------------------------------------------------------------------+
