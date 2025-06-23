//https://www.tradingview.com/script/admGhVz7-3-Line-Strike-TTF/
#property copyright "Bugscoder Studio"
#property link      "https://www.bugscoder.com/"
#property version   "1.00"
#property strict
#property indicator_chart_window

#property indicator_buffers 2
#property indicator_type1   DRAW_ARROW
#property indicator_width1  1
#property indicator_color1  clrDarkSeaGreen
#property indicator_type2   DRAW_ARROW
#property indicator_width2  1
#property indicator_color2  clrTomato

input bool showBear3LS = true; //Show Bearish 3 Line Strike
input bool showBull3LS = true; //Show Bullish 3 Line Strike

double up[], dn[];
string obj_prefix = "3LS_";

int OnInit() {
   IndicatorDigits(Digits);
   SetIndexLabel(0, "up");
   SetIndexBuffer(0, up);
   SetIndexArrow(0, 233);
   SetIndexLabel(1, "dn");
   SetIndexBuffer(1, dn);
   SetIndexArrow(1, 234);

   return(INIT_SUCCEEDED);
}

int OnCalculate(const int rates_total, const int prev_calculated, const datetime &time[], const double &open[], const double &high[],
                const double &low[], const double &close[], const long &tick_volume[], const long &volume[], const int &spread[]) {

   int startPos = rates_total-prev_calculated-4;
   if (startPos <= 1) { startPos = 1; }
   
   for(int pos=startPos; pos>=0; pos--) {
      up[pos]  = is3LSBull(pos) ?  Low[pos] : EMPTY_VALUE;
      dn[pos]  = is3LSBear(pos) ? High[pos] : EMPTY_VALUE;
   }

   return(rates_total);
}

void OnDeinit(const int reason) {
   ObjectsDeleteAll(0, obj_prefix);
}

int price_diff(double price1, double price2, string _pair = "", bool abs = true) {
   if (_pair == "") { _pair = Symbol(); }
   double _point = MarketInfo(_pair, MODE_POINT);
   
   double p = price1-price2;
   if (abs == true) { p = MathAbs(p); }
   p = NormalizeDouble(p/_point, 0);
   string s = DoubleToStr(p, 0);
   int diff = (int) StringToInteger(s);
   
   return diff;
}

int getCandleColorIndex(int pos) {
   return (Close[pos] > Open[pos]) ? 1 : (Close[pos] < Open[pos]) ? -1 : 0;
}

bool isEngulfing(int pos, bool checkBearish) {
   bool ret = false;
   int sizePrevCandle = price_diff(Close[pos+1], Open[pos+1]);
   int sizeCurrentCandle = price_diff(Close[pos], Open[pos]);
   bool isCurrentLagerThanPrevious = sizeCurrentCandle > sizePrevCandle ? true : false;
   
   if (checkBearish == true) {
      bool isGreenToRed = getCandleColorIndex(pos) < 0 && getCandleColorIndex(pos+1) > 0 ? true : false;
      ret = isCurrentLagerThanPrevious == true && isGreenToRed == true ? true : false;
   }
   else {
      bool isRedToGreen = getCandleColorIndex(pos) > 0 && getCandleColorIndex(pos+1) < 0 ? true : false;
      ret = isCurrentLagerThanPrevious == true && isRedToGreen == true ? true : false;
   }
   
   return ret;
}

bool isBearishEngulfuing(int pos) {
   return isEngulfing(pos, true);
}

bool isBullishEngulfuing(int pos) {
   return isEngulfing(pos, false);
}

bool is3LSBear(int pos) {
   bool ret = false;
   
   bool is3LineSetup = ((getCandleColorIndex(pos+1) > 0) && (getCandleColorIndex(pos+2) > 0) && (getCandleColorIndex(pos+3) > 0)) ? true : false;
   ret = (is3LineSetup == true && isBearishEngulfuing(pos)) ? true : false;
   
   return ret;
}

bool is3LSBull(int pos) {
   bool ret = false;
   
   bool is3LineSetup = ((getCandleColorIndex(pos+1) < 0) && (getCandleColorIndex(pos+2) < 0) && (getCandleColorIndex(pos+3) < 0)) ? true : false;
   ret = (is3LineSetup == true && isBullishEngulfuing(pos)) ? true : false;
   
   return ret;
}