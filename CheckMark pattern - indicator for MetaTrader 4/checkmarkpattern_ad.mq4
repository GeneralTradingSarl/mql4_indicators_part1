#property copyright "Scriptong"
#property link      "http://advancetools.net"
#property description "English: Finding the \"Check mark\" pattern.\nRussian: Поиск паттерна \"Галочка\"."
#property version "1.10"
#property strict

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1  clrDodgerBlue

#property indicator_level1 0.0

enum ENUM_YESNO
{
   NO,                                                                                             // No / Нет
   YES                                                                                             // Yes / Да
};

enum ENUM_INDICATOR_TYPE
{
   RSI,                                                                                            // RSI
   MACD,                                                                                           // MACD   
   MOMENTUM,                                                                                       // Momentum
   RVI,                                                                                            // RVI
   STOCHASTIC,                                                                                     // Stochastic
   CCI,                                                                                            // CCI
   StdDev,                                                                                         // Standart deviation
   DERIVATIVE,                                                                                     // Derivative / производная
   WILLIAM_BLAU,                                                                                   // William Blau
   CUSTOM                                                                                          // Custom / Пользовательский
};

enum ENUM_EXTREMUM_TYPE
{
   EXTREMUM_TYPE_NONE,   
   EXTREMUM_TYPE_MIN,
   EXTREMUM_TYPE_MAX
};

enum ENUM_CUSTOM_PARAM_CNT
{
   PARAM_CNT_0,                                                                                    // 0   
   PARAM_CNT_1,                                                                                    // 1   
   PARAM_CNT_2,                                                                                    // 2   
   PARAM_CNT_3,                                                                                    // 3   
   PARAM_CNT_4,                                                                                    // 4   
   PARAM_CNT_5,                                                                                    // 5   
   PARAM_CNT_6,                                                                                    // 6   
   PARAM_CNT_7,                                                                                    // 7   
   PARAM_CNT_8,                                                                                    // 8   
   PARAM_CNT_9,                                                                                    // 9   
   PARAM_CNT_10,                                                                                   // 10   
   PARAM_CNT_11,                                                                                   // 11   
   PARAM_CNT_12,                                                                                   // 12   
   PARAM_CNT_13,                                                                                   // 13   
   PARAM_CNT_14,                                                                                   // 14   
   PARAM_CNT_15,                                                                                   // 15   
   PARAM_CNT_16,                                                                                   // 16   
   PARAM_CNT_17,                                                                                   // 17   
   PARAM_CNT_18,                                                                                   // 18   
   PARAM_CNT_19,                                                                                   // 19   
   PARAM_CNT_20                                                                                    // 20   
};


// Input parameters of indicator
input string                   i_string1             = "The base indicator parameters / Параметры базового индикатора";            // ============================
input ENUM_INDICATOR_TYPE      i_indicatorType       = STOCHASTIC;                                 // Base indicator / Базовый индикатор
input int                      i_barsPeriod1         = 20;                                          // First calculate period / Первый период расчета
input int                      i_barsPeriod2         = 3;                                          // Second calculate period / Второй период расчета
input int                      i_barsPeriod3         = 3;                                          // Third calculate period / Третий период расчета
input ENUM_APPLIED_PRICE       i_indAppliedPrice     = PRICE_CLOSE;                                // Applied price of indicator / Цена расчета индикатора
input ENUM_MA_METHOD           i_indMAMethod         = MODE_EMA;                                   // MA calculate method / Метод расчета среднего

input string                   i_string3             = "Custom indicator / Пользовательский индикатор";            // ============================
input string                   i_customName          = "Sentiment_Line";                           // The name of indicator / Имя индикатора
input int                      i_customBuffer        = 0;                                          // Index of data buffer / Индекс буфера для съема данных
input ENUM_CUSTOM_PARAM_CNT    i_customParamCnt      = PARAM_CNT_3;                                // Amount of ind. parameters / Кол-во параметров индикатора
input double                   i_customParam1        = 13.0;                                       // Value of the 1st parameter / Значение 1-ого параметра
input double                   i_customParam2        = 1.0;                                        // Value of the 2nd parameter / Значение 2-ого параметра
input double                   i_customParam3        = 0.0;                                        // Value of the 3rd parameter / Значение 3-ого параметра
input double                   i_customParam4        = 0.0;                                        // Value of the 4th parameter / Значение 4-ого параметра
input double                   i_customParam5        = 0.0;                                        // Value of the 5th parameter / Значение 5-ого параметра
input double                   i_customParam6        = 0.0;                                        // Value of the 6th parameter / Значение 6-ого параметра
input double                   i_customParam7        = 0.0;                                        // Value of the 7th parameter / Значение 7-ого параметра
input double                   i_customParam8        = 0.0;                                        // Value of the 8th parameter / Значение 8-ого параметра
input double                   i_customParam9        = 0.0;                                        // Value of the 9th parameter / Значение 9-ого параметра
input double                   i_customParam10       = 0.0;                                        // Value of the 10th parameter / Значение 10-ого параметра
input double                   i_customParam11       = 0.0;                                        // Value of the 11th parameter / Значение 11-ого параметра
input double                   i_customParam12       = 0.0;                                        // Value of the 12th parameter / Значение 12-ого параметра
input double                   i_customParam13       = 0.0;                                        // Value of the 13th parameter / Значение 13-ого параметра
input double                   i_customParam14       = 0.0;                                        // Value of the 14th parameter / Значение 14-ого параметра
input double                   i_customParam15       = 0.0;                                        // Value of the 15th parameter / Значение 15-ого параметра
input double                   i_customParam16       = 0.0;                                        // Value of the 16th parameter / Значение 16-ого параметра
input double                   i_customParam17       = 0.0;                                        // Value of the 17th parameter / Значение 17-ого параметра
input double                   i_customParam18       = 0.0;                                        // Value of the 18th parameter / Значение 18-ого параметра
input double                   i_customParam19       = 0.0;                                        // Value of the 19th parameter / Значение 19-ого параметра
input double                   i_customParam20       = 0.0;                                        // Value of the 20th parameter / Значение 20-ого параметра

input string                   i_string4             = "Parameters of displaying / Параметры отображения";                    // ============================
input ENUM_YESNO               i_isAlert             = YES;                                        // Alert on pattern found? / Сигнал при паттерне?
input ENUM_YESNO               i_isPush              = YES;                                        // Notification on pattern found? / Уведомлять о паттерне?
input string                   i_string4_1           = "Color of patterns / Цвета паттерна";       // ============================
input color                    i_bullsPatternColor   = clrBlue;                                    // Color of bulls pattern / Цвет линий бычьего паттерна
input color                    i_bearsPatternColor   = clrRed;                                     // Color of bears divergence line / Цвет линий медв. паттерна
input int                      i_indBarsCount        = 10000;                                      // The number of bars to display / Количество баров отображения

// The indicator's buffers
double            g_indValues[];
double            g_tempBuffer[];

// Other global variables of indicator
bool              g_activate;                                                                      // Sign of successful initialization of indicator
     
int               g_indSubWindow;                                                                  // Subwindow index of indicator

string            g_indName,                                                                       // The unique name of the indicator for easy location indicator subwindow
                  g_tfName;                                                                        // Name of current TF
       
#define PREFIX                                  "CHEMAPAT_"                                        // Prefix the name of the graphic objects which displayed by indicator

//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Custom indicator initialization function                                                                                                                                                          |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
int OnInit()
{
   g_activate = false;                                                                             
   
   if (!IsTuningParametersCorrect())                                                               
      return INIT_FAILED;                                 
      
   if (!BuffersBind())                             
      return (INIT_FAILED);                                 
         
   g_tfName = GetCurrentTFName();
   g_indSubWindow = -1; 
   g_activate = true;                                                                              
   return INIT_SUCCEEDED;
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Checking the correctness of input parameters                                                                                                                                                      |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
bool IsTuningParametersCorrect()
{
   string name = WindowExpertName();
   
   bool isRussianLang = (TerminalInfoString(TERMINAL_LANGUAGE) == "Russian");

   if (i_barsPeriod1 < 1)
   {
      Alert(name, (isRussianLang)? ": первое количество баров для расчета показаний индикатора менее 1. Индикатор отключен." : 
                                   ": the first amount of bars for calculate the indicator values is less then 1. The indicator is turned off.");
      return false;
   }

   if (i_barsPeriod2 < 1)
   {
      Alert(name, (isRussianLang)? ": второе количество баров для расчета показаний индикатора менее 1. Индикатор отключен." :
                                   ": the second amount of bars for calculate the indicator values is less then 1. The indicator is turned off.");
      return false;
   }

   if (i_barsPeriod3 < 1)
   {
      Alert(name, (isRussianLang)? ": третье количество баров для расчета показаний индикатора менее 1. Индикатор отключен." :
                                   ": the third amount of bars for calculate the indicator values is less then 1. The indicator is turned off.");
      return false;
   }

   return (true);
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Defining the current TF name                                                                                                                                                                      |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
string GetCurrentTFName()
{
   switch(_Period)
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
   }
   
   return "U/D";
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Binding the indicator buffers with arrays                                                                                                                                                         |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
bool BuffersBind()
{
   if (i_indicatorType == WILLIAM_BLAU)
      IndicatorBuffers(2);
   string name = WindowExpertName();
   bool isRussianLang = (TerminalInfoString(TERMINAL_LANGUAGE) == "Russian");

   if (!SetIndexBuffer(0, g_indValues))
   {
      Alert(name, (isRussianLang)? ": ошибка связывания массивов с буферами индикатора. Ошибка №" + IntegerToString(GetLastError()) :
                                   ": error of binding of the arrays and the indicator buffers. Error N" + IntegerToString(GetLastError()));
      return false;
   }
   
   if (i_indicatorType == WILLIAM_BLAU)
      if (!SetIndexBuffer(1, g_tempBuffer))
      {
         Alert(name, (isRussianLang)? ": ошибка связывания массивов с буферами индикатора. Ошибка №" + IntegerToString(GetLastError()) :
                                      ": error of binding of the arrays and the indicator buffers. Error N" + IntegerToString(GetLastError()));
         return false;
      }

   SetIndexStyle(0, DRAW_LINE);
   if (i_indicatorType == WILLIAM_BLAU)
      SetIndexStyle(1, DRAW_NONE);
      
   g_indName = "CheckMarkPattern at " + GetBaseIndicatorName() + IntegerToString(GetTickCount());
   IndicatorShortName(g_indName); 
   
   return true;
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Defining the name of the base indicator                                                                                                                                                           |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
string GetBaseIndicatorName()
{
   if (i_indicatorType == CUSTOM)
      return i_customName + " (" + DoubleToString(i_customParam1, 1) + ", " + DoubleToString(i_customParam2, 1) + ", " + DoubleToString(i_customParam3, 1) + ") ";
      
   return EnumToString(i_indicatorType) + " (" + IntegerToString(i_barsPeriod1) + ", " + IntegerToString(i_barsPeriod2) + ", " + IntegerToString(i_barsPeriod3) + ") ";
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Custom indicator deinitialization function                                                                                                                                                        |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   ObjectsDeleteAll(0, PREFIX + IntegerToString(g_indSubWindow));
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Displaying the trend line                                                                                                                                                                         |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void ShowTrendLine(int subWindow, datetime time1, double price1, datetime time2, double price2, string toolTip, color clr)
{
   string name = PREFIX +  IntegerToString(g_indSubWindow) + IntegerToString(subWindow) + IntegerToString(time1) + IntegerToString(time2);
   
   if (ObjectFind(0, name) < 0)
   {
      ObjectCreate(0, name, OBJ_TREND, subWindow, time1, price1, time2, price2);
      ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
      ObjectSetInteger(0, name, OBJPROP_BACK, false);
      ObjectSetInteger(0, name, OBJPROP_WIDTH, 2);
      ObjectSetInteger(0, name, OBJPROP_RAY, false);
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
      ObjectSetString(0, name, OBJPROP_TOOLTIP, toolTip);
      return;
   }
   
   ObjectMove(0, name, 0, time1, price1);
   ObjectMove(0, name, 1, time2, price2);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
   ObjectSetString(0, name, OBJPROP_TOOLTIP, toolTip);
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Determination of bar index which needed to recalculate                                                                                                                                            |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
int GetRecalcIndex(int& total, const int ratesTotal, const int prevCalculated)
{
   total = ratesTotal - 1;                                                                         
                                                   
   if (i_indBarsCount > 0 && i_indBarsCount < total)
      total = MathMin(i_indBarsCount, total);                      
                                                   
   if (prevCalculated < ratesTotal - 1)                     
   {       
      InitializeBuffers();
      return (total);
   }
   
   return (MathMin(ratesTotal - prevCalculated, total));                            
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Initialize of all indicator buffers                                                                                                                                                               |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void InitializeBuffers()
{
   ArrayInitialize(g_indValues, EMPTY_VALUE);
   ArrayInitialize(g_tempBuffer, EMPTY_VALUE);
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Calculate the price value at the specified bar                                                                                                                                                    |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
double GetPrice(int barIndex)
{
   barIndex = (int) MathMin(Bars - 1, barIndex);

   switch (i_indAppliedPrice)
   {
      case PRICE_CLOSE:    return(Close[barIndex]);                  
      case PRICE_OPEN:     return(Open[barIndex]);                   
      case PRICE_HIGH:     return(High[barIndex]);                   
      case PRICE_LOW:      return(Low[barIndex]);                    
      case PRICE_MEDIAN:   return((High[barIndex] + Low[barIndex]) / 2);
      case PRICE_TYPICAL:  return((High[barIndex] + Low[barIndex] + Close[barIndex]) / 3);
      case PRICE_WEIGHTED: return((High[barIndex] + Low[barIndex] + 2 * Close[barIndex]) / 4);            
   }
   
   return 0.0;
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Calculate the value of the custom indicator at the specified bar                                                                                                                                  |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
double GetCustomIndicatorValue(int barIndex)
{
   switch(i_customParamCnt)
   {
      case PARAM_CNT_0:    return iCustom(NULL, 0, i_customName, i_customBuffer, barIndex);
      case PARAM_CNT_1:    return iCustom(NULL, 0, i_customName, i_customParam1, i_customBuffer, barIndex);
      case PARAM_CNT_2:    return iCustom(NULL, 0, i_customName, i_customParam1, i_customParam2, i_customBuffer, barIndex);
      case PARAM_CNT_3:    return iCustom(NULL, 0, i_customName, i_customParam1, i_customParam2, i_customParam3, i_customBuffer, barIndex);
      case PARAM_CNT_4:    return iCustom(NULL, 0, i_customName, i_customParam1, i_customParam2, i_customParam3, i_customParam4, i_customBuffer, barIndex);
      case PARAM_CNT_5:    return iCustom(NULL, 0, i_customName, i_customParam1, i_customParam2, i_customParam3, i_customParam4, i_customParam5, i_customBuffer, barIndex);
      case PARAM_CNT_6:    return iCustom(NULL, 0, i_customName, i_customParam1, i_customParam2, i_customParam3, i_customParam4, i_customParam5, i_customParam6, i_customBuffer, barIndex);
      case PARAM_CNT_7:    return iCustom(NULL, 0, i_customName, i_customParam1, i_customParam2, i_customParam3, i_customParam4, i_customParam5, i_customParam6, i_customParam7,
                                          i_customBuffer, barIndex);
      case PARAM_CNT_8:    return iCustom(NULL, 0, i_customName, i_customParam1, i_customParam2, i_customParam3, i_customParam4, i_customParam5, i_customParam6, i_customParam7, i_customParam8,
                                          i_customBuffer, barIndex);
      case PARAM_CNT_9:    return iCustom(NULL, 0, i_customName, i_customParam1, i_customParam2, i_customParam3, i_customParam4, i_customParam5, i_customParam6, i_customParam7, i_customParam8,
                                          i_customParam9, i_customBuffer, barIndex);
      case PARAM_CNT_10:   return iCustom(NULL, 0, i_customName, i_customParam1, i_customParam2, i_customParam3, i_customParam4, i_customParam5, i_customParam6, i_customParam7, i_customParam8,
                                          i_customParam9, i_customParam10, i_customBuffer, barIndex);
      case PARAM_CNT_11:   return iCustom(NULL, 0, i_customName, i_customParam1, i_customParam2, i_customParam3, i_customParam4, i_customParam5, i_customParam6, i_customParam7, i_customParam8,
                                          i_customParam9, i_customParam10, i_customParam11, i_customBuffer, barIndex);
      case PARAM_CNT_12:   return iCustom(NULL, 0, i_customName, i_customParam1, i_customParam2, i_customParam3, i_customParam4, i_customParam5, i_customParam6, i_customParam7, i_customParam8,
                                          i_customParam9, i_customParam10, i_customParam11, i_customParam12, i_customBuffer, barIndex);
      case PARAM_CNT_13:   return iCustom(NULL, 0, i_customName, i_customParam1, i_customParam2, i_customParam3, i_customParam4, i_customParam5, i_customParam6, i_customParam7, i_customParam8,
                                          i_customParam9, i_customParam10, i_customParam11, i_customParam12, i_customParam13, i_customBuffer, barIndex);
      case PARAM_CNT_14:   return iCustom(NULL, 0, i_customName, i_customParam1, i_customParam2, i_customParam3, i_customParam4, i_customParam5, i_customParam6, i_customParam7, i_customParam8,
                                          i_customParam9, i_customParam10, i_customParam11, i_customParam12, i_customParam13, i_customParam14, i_customBuffer, barIndex);
      case PARAM_CNT_15:   return iCustom(NULL, 0, i_customName, i_customParam1, i_customParam2, i_customParam3, i_customParam4, i_customParam5, i_customParam6, i_customParam7, i_customParam8,
                                          i_customParam9, i_customParam10, i_customParam11, i_customParam12, i_customParam13, i_customParam14, i_customParam15, i_customBuffer, barIndex);
      case PARAM_CNT_16:   return iCustom(NULL, 0, i_customName, i_customParam1, i_customParam2, i_customParam3, i_customParam4, i_customParam5, i_customParam6, i_customParam7, i_customParam8,
                                          i_customParam9, i_customParam10, i_customParam11, i_customParam12, i_customParam13, i_customParam14, i_customParam15, i_customParam16, 
                                          i_customBuffer, barIndex);
      case PARAM_CNT_17:   return iCustom(NULL, 0, i_customName, i_customParam1, i_customParam2, i_customParam3, i_customParam4, i_customParam5, i_customParam6, i_customParam7, i_customParam8,
                                          i_customParam9, i_customParam10, i_customParam11, i_customParam12, i_customParam13, i_customParam14, i_customParam15, i_customParam16, i_customParam17, 
                                          i_customBuffer, barIndex);
      case PARAM_CNT_18:   return iCustom(NULL, 0, i_customName, i_customParam1, i_customParam2, i_customParam3, i_customParam4, i_customParam5, i_customParam6, i_customParam7, i_customParam8,
                                          i_customParam9, i_customParam10, i_customParam11, i_customParam12, i_customParam13, i_customParam14, i_customParam15, i_customParam16, i_customParam17, 
                                          i_customParam18, i_customBuffer, barIndex);
      case PARAM_CNT_19:   return iCustom(NULL, 0, i_customName, i_customParam1, i_customParam2, i_customParam3, i_customParam4, i_customParam5, i_customParam6, i_customParam7, i_customParam8,
                                          i_customParam9, i_customParam10, i_customParam11, i_customParam12, i_customParam13, i_customParam14, i_customParam15, i_customParam16, i_customParam17, 
                                          i_customParam18, i_customParam19, i_customBuffer, barIndex);
      case PARAM_CNT_20:   return iCustom(NULL, 0, i_customName, i_customParam1, i_customParam2, i_customParam3, i_customParam4, i_customParam5, i_customParam6, i_customParam7, i_customParam8,
                                          i_customParam9, i_customParam10, i_customParam11, i_customParam12, i_customParam13, i_customParam14, i_customParam15, i_customParam16, i_customParam17, 
                                          i_customParam18, i_customParam19, i_customParam20, i_customBuffer, barIndex);
   }
   
   return 0.0;
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Calculate the value of base indicator at the specified bar                                                                                                                                        |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
double GetBaseIndicatorValue(int barIndex)
{
   switch (i_indicatorType)
   {
      case RSI:         return iRSI(NULL, 0, i_barsPeriod1, i_indAppliedPrice, barIndex);
      case MACD:        return iMACD(NULL, 0, i_barsPeriod1, i_barsPeriod2, 1, i_indAppliedPrice, MODE_MAIN, barIndex);
      case MOMENTUM:    return iMomentum(NULL, 0, i_barsPeriod1, i_indAppliedPrice, barIndex);
      case RVI:         return iRVI(NULL, 0, i_barsPeriod1, MODE_MAIN, barIndex);
      case STOCHASTIC:  return iStochastic(NULL, 0, i_barsPeriod1, i_barsPeriod2, i_barsPeriod3, i_indMAMethod, 1, MODE_MAIN, barIndex);
      case CCI:         return iCCI(NULL, 0, i_barsPeriod1, i_indAppliedPrice, barIndex);
      case StdDev:      return iStdDev(NULL, 0, i_barsPeriod1, 0, i_indMAMethod, i_indAppliedPrice, barIndex);
      case DERIVATIVE:  return 100.0 * (GetPrice(barIndex) - GetPrice(barIndex + i_barsPeriod1)) / i_barsPeriod1;
      case CUSTOM:      return GetCustomIndicatorValue(barIndex);
   }
   
   return 0.0;
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Sound and Push-notifications of divergence                                                                                                                                                        |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void SignalOnPattern(string text)
{
   static datetime lastSignal = 0;
   if (lastSignal >= iTime(NULL, 0, 0))
      return;
      
   lastSignal = iTime(NULL, 0, 0);
   
   if (i_isAlert)
      Alert(Symbol(), ", ", g_tfName, ": ", text);
      
   if (i_isPush)
      SendNotification(Symbol() + ", " + g_tfName + ": " + text);
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Get type of base indicator extremum                                                                                                                                                               |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
ENUM_EXTREMUM_TYPE GetIndicatorExtremum(int barIndex, int total)
{
   if (barIndex > total - 3 || barIndex < 0)
      return EXTREMUM_TYPE_NONE;
   
   if (g_indValues[barIndex] > g_indValues[barIndex + 1] && g_indValues[barIndex + 1] < g_indValues[barIndex + 2])
      return EXTREMUM_TYPE_MIN;
      
   if (g_indValues[barIndex] < g_indValues[barIndex + 1] && g_indValues[barIndex + 1] > g_indValues[barIndex + 2])
      return EXTREMUM_TYPE_MAX;
      
   return EXTREMUM_TYPE_NONE;   
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Get type of market extremum                                                                                                                                                                       |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
ENUM_EXTREMUM_TYPE GetMarketExtremum(int barIndex, int total)
{
   if (barIndex > total - 3 || barIndex < 0)
      return EXTREMUM_TYPE_NONE;
   
   double closeRight = iClose(NULL, 0, barIndex);
   double closeCenter = iClose(NULL, 0, barIndex + 1);
   double closeLeft = iClose(NULL, 0, barIndex + 2);
   
   if (closeRight > closeCenter && closeCenter < closeLeft)
      return EXTREMUM_TYPE_MIN;
      
   if (closeRight < closeCenter && closeCenter > closeLeft)
      return EXTREMUM_TYPE_MAX;
      
   return EXTREMUM_TYPE_NONE;   
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Show the pattern                                                                                                                                                                                  |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void ShowPattern(int barIndex, color patternColor, string text)
{
   datetime timeRight = iTime(NULL, 0, barIndex);
   datetime timeCenter = iTime(NULL, 0, barIndex + 1);
   datetime timeLeft = iTime(NULL, 0, barIndex + 2);
   double closeCenter = iClose(NULL, 0, barIndex + 1);
  
   ShowTrendLine(0, timeRight, iClose(NULL, 0, barIndex), timeCenter, closeCenter, text, patternColor);
   ShowTrendLine(0, timeCenter, closeCenter, timeLeft, iClose(NULL, 0, barIndex + 2), text, patternColor);
   ShowTrendLine(g_indSubWindow, timeRight, g_indValues[barIndex], timeCenter, g_indValues[barIndex + 1], text, patternColor);
   ShowTrendLine(g_indSubWindow, timeCenter, g_indValues[barIndex + 1], timeLeft, g_indValues[barIndex + 2], text, patternColor);
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Process the specified bar                                                                                                                                                                         |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void ProcessBar(int barIndex, int total)
{
   bool result = false;
   
   // Is the indicator extremum?
   ENUM_EXTREMUM_TYPE indExtremum = GetIndicatorExtremum(barIndex, total);
   if (indExtremum == EXTREMUM_TYPE_NONE)
      return;

   // Is the market extremum?
   ENUM_EXTREMUM_TYPE marketExtremum = GetMarketExtremum(barIndex, total);
   if (marketExtremum == EXTREMUM_TYPE_NONE || marketExtremum == indExtremum)
      return;
   
   // Pattern was found. Show it.
   string text = (indExtremum == EXTREMUM_TYPE_MIN)? "Bull pattern" : "Bear pattern";
   ShowPattern(barIndex, (indExtremum == EXTREMUM_TYPE_MIN)? i_bullsPatternColor : i_bearsPatternColor, text);
   if (barIndex == 1)
      SignalOnPattern(text);
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Recalculate the values of William Blau                                                                                                                                                            |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void CalculateDataByWilliamBlau(int limit, int total)
{
   for (int i = limit; i > 0; i--)
      g_tempBuffer[i] = iMA(NULL, 0, i_barsPeriod2, 0, MODE_EMA, i_indAppliedPrice, i) - iMA(NULL, 0, i_barsPeriod1, 0, MODE_EMA, i_indAppliedPrice, i);
      
   for (int i = limit; i > 0; i--)
   {
      g_indValues[i] = iMAOnArray(g_tempBuffer, 0, i_barsPeriod3, 0, MODE_EMA, i);
      ProcessBar(i, total);
   }
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Displaying of indicators values                                                                                                                                                                   |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void ShowIndicatorData(int limit, int total)
{
   if (i_indicatorType == WILLIAM_BLAU)
   {
      CalculateDataByWilliamBlau(limit, total);
      return;
   }

   for (int i = limit; i > 0; i--)
   {
      g_indValues[i] = GetBaseIndicatorValue(i);
      ProcessBar(i, total);
   }
}
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Custom indicator iteration function                                                                                                                                                               |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
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
   if (!g_activate)                                                                                
      return rates_total;                                 
    
   g_indSubWindow = WindowFind(g_indName);
   if (g_indSubWindow < 0)
      return 0;
      
   int total;   
   int limit = GetRecalcIndex(total, rates_total, prev_calculated);                                

   ShowIndicatorData(limit, total);                                                                
   WindowRedraw();
   
   return rates_total;
}
