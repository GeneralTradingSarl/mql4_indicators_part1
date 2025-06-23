//+------------------------------------------------------------------+
//|                   Double_Moving_Averages_With Fibonacci.mq4      |
//|                       Copyright 2025, Mir Mostofa Kamal          |
//|                               https://www.mql5.com/en/users/bokul|
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Mir Mostofa Kamal"
#property link      "https://www.mql5.com/en/users/bokul"
#property version   "1.01"
#property description   "Double Moving Averages with Fibonacci Levels and Alerts"
#property description  "This indicator combines two moving averages to generate buy/sell signals based on crossovers."
#property strict
/*
Short Description: 
This indicator combines two moving averages to generate buy/sell signals based on crossovers.
It also plots Fibonacci retracement levels using recent swing highs and lows for support/resistance.
Visual arrows mark trade signals, and optional alerts notify users in real-time.
Works on all timeframes for flexible technical analysis.
*/
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 White
#property indicator_color2 Red
#property indicator_color3 Lime
#property indicator_color4 OrangeRed
#property indicator_width3 2
#property indicator_width4 2

// Inputs
input string MA1_Settings        = "=== MA1 Settings ===";
input int MA1_Period = 7;                 //MA1 Period :
input int MA1_Method = MODE_EMA;          //MA1 Method :
input int MA1_Applied_Price = PRICE_CLOSE;//MA1 Price :

input string MA2_Settings        = "=== MA2 Settings ===";
input int MA2_Period = 21;                //MA2 Period :
input int MA2_Method = MODE_SMA;          //MA2 Method :
input int MA2_Applied_Price = PRICE_CLOSE;//MA2 Price :

input string Alerts_Settings        = "=== Alerts Settings ===";
input bool EnableAlerts = true;           //Popup Alerts On/Off:
input bool EnableEmail = false;           //Email Alerts On/Off:
input bool EnableSound = true;            //Sound Alerts On/Off:

input string Fibo_Settings        = "=== Fibo Settings ===";
input int FibLookback = 100;              //Fibo Look Back:
input color FibColor = White;             //Fibo Line Color:
input ENUM_LINE_STYLE FibLineStyle = STYLE_DOT;//Febo Line style:
input int FibLineWidth = 1;               //Fibo Line Width:
input color FibLabelColor = clrWhite;     //Fibo Label Color:
input int FibLabelFontSize = 10;          //Fibo Font Size:

// Buffers
double MA1_Buffer[];
double MA2_Buffer[];
double BuyArrow[];
double SellArrow[];

// Fibonacci variables
double FibPriceLevels[7];
double fibRatios[7] = {0.0, 0.236, 0.382, 0.5, 0.618, 0.786, 1.0};

int lastAlertBarMA = -1;

//+------------------------------------------------------------------+
int OnInit()
{
   SetIndexBuffer(0, MA1_Buffer); SetIndexStyle(0, DRAW_LINE); SetIndexLabel(0, "MA1");
   SetIndexBuffer(1, MA2_Buffer); SetIndexStyle(1, DRAW_LINE); SetIndexLabel(1, "MA2");
   SetIndexBuffer(2, BuyArrow); SetIndexStyle(2, DRAW_ARROW); SetIndexArrow(2, 233); SetIndexLabel(2, "Buy Signal");
   SetIndexBuffer(3, SellArrow); SetIndexStyle(3, DRAW_ARROW); SetIndexArrow(3, 234); SetIndexLabel(3, "Sell Signal");

   for(int i=0; i<7; i++)
   {
      string levelName = "FibLevel" + IntegerToString(i);
      string labelName = "FibLabel" + IntegerToString(i);
      ObjectCreate(0, levelName, OBJ_HLINE, 0, 0, 0);
      ObjectSetInteger(0, levelName, OBJPROP_COLOR, FibColor);
      ObjectSetInteger(0, levelName, OBJPROP_STYLE, FibLineStyle);
      ObjectSetInteger(0, levelName, OBJPROP_WIDTH, FibLineWidth);
      ObjectSetInteger(0, levelName, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, levelName, OBJPROP_SELECTED, false);
      ObjectSetInteger(0, levelName, OBJPROP_BACK, true);

      ObjectCreate(0, labelName, OBJ_TEXT, 0, 0, 0);
      ObjectSetInteger(0, labelName, OBJPROP_COLOR, FibLabelColor);
      ObjectSetInteger(0, labelName, OBJPROP_FONTSIZE, FibLabelFontSize);
      ObjectSetInteger(0, labelName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, labelName, OBJPROP_BACK, true);
   }
   return(INIT_SUCCEEDED);
}

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
   int limit = rates_total - 2;
   for (int i = limit; i >= 1; i--)
   {
      MA1_Buffer[i] = iMA(NULL, 0, MA1_Period, 0, MA1_Method, MA1_Applied_Price, i);
      MA2_Buffer[i] = iMA(NULL, 0, MA2_Period, 0, MA2_Method, MA2_Applied_Price, i);
      BuyArrow[i] = EMPTY_VALUE;
      SellArrow[i] = EMPTY_VALUE;

      if (MA1_Buffer[i] > MA2_Buffer[i] && MA1_Buffer[i+1] <= MA2_Buffer[i+1])
      {
         BuyArrow[i] = low[i] - 5 * Point;
         if (i == 1 && i != lastAlertBarMA)
         {
            TriggerAlert("BUY", time[i]);
            lastAlertBarMA = i;
         }
      }
      else if (MA1_Buffer[i] < MA2_Buffer[i] && MA1_Buffer[i+1] >= MA2_Buffer[i+1])
      {
         SellArrow[i] = high[i] + 5 * Point;
         if (i == 1 && i != lastAlertBarMA)
         {
            TriggerAlert("SELL", time[i]);
            lastAlertBarMA = i;
         }
      }
   }

   UpdateFibonacciLevels(high, low);
   return(rates_total);
}

//+------------------------------------------------------------------+
//| Alert triggering function                                        |
//+------------------------------------------------------------------+
/*
void TriggerAlert(string signalType, datetime barTime)
{
   string msg = StringFormat( "DMA_Fbi: %s detected!\nSymbol: %s\nTimeframe: %s\nTime: %s", signalType, Symbol(), TimeframeToString(Period()), TimeToString(barTime, TIME_DATE | TIME_MINUTES));
   string msg = StringFormat("DMA: %s signal on %s %s at %s", type, Symbol(), PeriodToStr(), TimeToString(alertTime, TIME_DATE | TIME_MINUTES));
   if (EnableAlerts) Alert(msg);
   if (EnableSound)  PlaySound("alert.wav");
   if (EnableEmail)  SendMail("DoubleMA/Fib Signal", msg);
}
*/

//+------------------------------------------------------------------+
//| Alert triggering function                                        |
//+------------------------------------------------------------------+
string PeriodToStr()
{
   switch(Period())
   {
      case PERIOD_M1: return "M1";
      case PERIOD_M5: return "M5";
      case PERIOD_M15: return "M15";
      case PERIOD_M30: return "M30";
      case PERIOD_H1: return "H1";
      case PERIOD_H4: return "H4";
      case PERIOD_D1: return "D1";
      case PERIOD_W1: return "W1";
      case PERIOD_MN1: return "MN1";
      default: return IntegerToString(Period());
   }
}

void TriggerAlert(string type, datetime alertTime)
{
   if (!EnableAlerts) return;

   string msg = StringFormat("DMA: %s signal on %s %s at %s", type, Symbol(), PeriodToStr(), TimeToString(alertTime, TIME_DATE | TIME_MINUTES));

   if (EnableEmail && !SendMail("DMA", msg))
      Print("Failed to send email alert: ", msg);

   if (EnableSound) PlaySound("alert.wav");

   Alert(msg);
}
//+------------------------------------------------------------------+
string TimeframeToString(int tf)
{
   switch(tf)
   {
      case PERIOD_M1: return "M1";
      case PERIOD_M5: return "M5";
      case PERIOD_M15: return "M15";
      case PERIOD_M30: return "M30";
      case PERIOD_H1: return "H1";
      case PERIOD_H4: return "H4";
      case PERIOD_D1: return "D1";
      case PERIOD_W1: return "W1";
      case PERIOD_MN1: return "MN1";
      default: return "Unknown";
   }
}

//+------------------------------------------------------------------+
void FindSwingLevels(const double &high[], const double &low[], int barsBack, double &swingHigh, double &swingLow)
{
   swingHigh = high[0];
   swingLow = low[0];
   for(int i=1; i < barsBack && i < ArraySize(high); i++)
   {
      if(high[i] > swingHigh) swingHigh = high[i];
      if(low[i] < swingLow) swingLow = low[i];
   }
}

//+------------------------------------------------------------------+
void UpdateFibonacciLevels(const double &high[], const double &low[])
{
   double swingHigh, swingLow;
   FindSwingLevels(high, low, FibLookback, swingHigh, swingLow);
   double diff = swingHigh - swingLow;
   for(int i=0; i<7; i++)
   {
      FibPriceLevels[i] = swingHigh - diff * fibRatios[i];
      string levelName = "FibLevel" + IntegerToString(i);
      string labelName = "FibLabel" + IntegerToString(i);
      ObjectSetDouble(0, levelName, OBJPROP_PRICE, FibPriceLevels[i]);

      ObjectSetInteger(0, labelName, OBJPROP_XDISTANCE, 10);
      ObjectSetInteger(0, labelName, OBJPROP_YDISTANCE, 20 + i * 15);
      ObjectSetString(0, labelName, OBJPROP_TEXT, DoubleToString(FibPriceLevels[i], Digits) + " (" + DoubleToString(fibRatios[i]*100, 1) + "%)");
      ObjectMove(0, labelName, 0, Time[0], FibPriceLevels[i]);
   }
}