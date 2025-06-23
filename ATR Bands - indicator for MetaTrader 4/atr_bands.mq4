//https://www.tradingview.com/script/uTetNB3s-ATR-Bands/
#property copyright "Bugscoder Studio"
#property link      "https://www.bugscoder.com/"
#property version   "1.00"
#property strict
#property indicator_chart_window

#property indicator_buffers 2
#property indicator_type1   DRAW_LINE
#property indicator_width1  1
#property indicator_color1  clrDarkSeaGreen
#property indicator_type2   DRAW_LINE
#property indicator_width2  1
#property indicator_color2  clrTomato


enum ENUM_PRICE_SOURCE {
   open,
   high,
   low,
   close,
   hl2,
   hlc3,
   ohlc4
};

input int atrPeriod = 14;
input ENUM_PRICE_SOURCE srcUpper = 3;
input ENUM_PRICE_SOURCE srcLower = 3;
input int atrMultiplierUpper = 3;
input int atrMultiplierLower = 3;

double up[], dn[];
string obj_prefix = "RSIMACDOBOS_";

int OnInit() {
   IndicatorDigits(Digits);
   SetIndexLabel(0, "up");
   SetIndexBuffer(0, up);
   SetIndexLabel(1, "dn");
   SetIndexBuffer(1, dn);

   return(INIT_SUCCEEDED);
}

int OnCalculate(const int rates_total, const int prev_calculated, const datetime &time[], const double &open[], const double &high[],
                const double &low[], const double &close[], const long &tick_volume[], const long &volume[], const int &spread[]) {

   int startPos = rates_total-prev_calculated-2;
   if (startPos <= 1) { startPos = 1; }
   
   for(int pos=startPos; pos>=0; pos--) {
      double _atr = iATR(NULL, 0, atrPeriod, pos);
      
      double _srcUpper = 0, _srcLower = 0;
      if (srcUpper == 0) { _srcUpper = open[pos]; }
      if (srcUpper == 1) { _srcUpper = high[pos]; }
      if (srcUpper == 2) { _srcUpper = low[pos]; }
      if (srcUpper == 3) { _srcUpper = close[pos]; }
      if (srcUpper == 4) { _srcUpper = (high[pos]+low[pos])/2; }
      if (srcUpper == 5) { _srcUpper = (high[pos]+low[pos]+close[pos])/3; }
      if (srcUpper == 6) { _srcUpper = (open[pos]+high[pos]+low[pos]+close[pos])/4; }
      
      if (srcLower == 0) { _srcLower = open[pos]; }
      if (srcLower == 1) { _srcLower = high[pos]; }
      if (srcLower == 2) { _srcLower = low[pos]; }
      if (srcLower == 3) { _srcLower = close[pos]; }
      if (srcLower == 4) { _srcLower = (high[pos]+low[pos])/2; }
      if (srcLower == 5) { _srcLower = (high[pos]+low[pos]+close[pos])/3; }
      if (srcLower == 6) { _srcLower = (open[pos]+high[pos]+low[pos]+close[pos])/4; }
   
      up[pos]  = _srcUpper+_atr*atrMultiplierUpper;
      dn[pos]  = _srcLower-_atr*atrMultiplierUpper;
   }

   return(rates_total);
}

void OnDeinit(const int reason) {
   ObjectsDeleteAll(0, obj_prefix);
}