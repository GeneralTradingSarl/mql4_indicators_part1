//+------------------------------------------------------------------+
//|                                           ChannelsFIBO_v2_AD.mq4 |
//|                                        Copyright 2016, Scriptong |
//|                                          http://advancetools.net |
//+------------------------------------------------------------------+
#property copyright "Scriptong"
#property link      "http://advancetools.net"
#property description   "English: Dynamic channel, which is calculated based on the maximum distance between the price and MA.\nRussian: Динамический канал, рассчитанный на основании максимального расстояния между ценой и MA."
#property strict

#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 clrRed
#property indicator_color2 clrDarkOrange
#property indicator_color3 clrYellow
#property indicator_color4 clrAquamarine
#property indicator_color5 clrMagenta
#property indicator_color6 clrYellow
#property indicator_color7 clrDarkOrange
#property indicator_color8 clrRed

#property indicator_width4 2
#property indicator_width5 2

#property indicator_style1 STYLE_DOT
#property indicator_style2 STYLE_DOT
#property indicator_style3 STYLE_DOT
#property indicator_style6 STYLE_DOT
#property indicator_style7 STYLE_DOT
#property indicator_style8 STYLE_DOT
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_SHIFT_METHOD
  {
   SHIFT_MAXIMUM,                                                                                  // By maximal shift / По максимальному смещению
   SHIFT_AVERAGE,                                                                                  // By average shift / По среднему смещению
   SHIFT_MEDIAN,                                                                                   // By median shift / По медианному смещению
   SHIFT_STD                                                                                       // By standart deviation / По СКО
  };

input    uint                 i_extremumDepth            = 78;                                     // Depth extremum search / Глубина поиска экстремума
input    uint                 i_maPeriod                 = 100;                                    // MA period / Период MA
input    ENUM_MA_METHOD       i_maMethod                 = MODE_SMA;                               // MA method / Метод расчета МА
input    ENUM_APPLIED_PRICE   i_maPrice                  = PRICE_CLOSE;                            // MA price / Цена расчета МА
input    double               i_fiboLevel1               = 61.8;                                   // Fibo level 1 / Уровень Фибо 1
input    double               i_fiboLevel2               = 100.0;                                  // Fibo level 2 / Уровень Фибо 2
input    double               i_fiboLevel3               = 161.8;                                  // Fibo level 3 / Уровень Фибо 3
input    double               i_fiboLevel4               = 200.0;                                  // Fibo level 4 / Уровень Фибо 4
input    ENUM_SHIFT_METHOD    i_shiftMethod              = SHIFT_STD;                              // Channel calculate method / Метод расчета канала
input    int                  i_indBarsCount             = 10000;                                  // Number of bars to display / Кол-во баров отображения

#define PREFIX                                        "CHAFIB2_"
#define FONT_NAME                                     "Tahoma"
#define FONT_SIZE                                     8

bool g_activate;

double   g_fiboLevel[4],
         g_priceShifts[],
         g_tempPriceShifts[],
         g_point,
         g_delta;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_MESSAGE_CODE
  {
   MESSAGE_CODE_WRONG_DEPTH,
   MESSAGE_CODE_WRONG_MA_PERIOD,
   MESSAGE_CODE_TERMINAL_FATAL_ERROR1,
   MESSAGE_CODE_ENOUGH_MEMORY,
   MESSAGE_CODE_FIBO_EQUALS,
   MESSAGE_CODE_BIND_ERROR
  };

// The indicator's buffers
double g_buffHigh1[];
double g_buffHigh2[];
double g_buffHigh3[];
double g_buffHigh4[];
double g_buffLow1[];
double g_buffLow2[];
double g_buffLow3[];
double g_buffLow4[];
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Custom indicator initialization function                                                                                                                                                          |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
int OnInit()
  {
   g_activate=false;

   if(!TuningParameters())
      return INIT_FAILED;

   if(!BuffersBind())
      return INIT_FAILED;

   g_activate=true;

   return INIT_SUCCEEDED;
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Checking the correctness of values of tuning parameters                                                                                                                                           |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
bool TuningParameters()
  {
   string name=WindowExpertName();

   if(i_extremumDepth<1)
     {
      Alert(name,GetStringByMessageCode(MESSAGE_CODE_WRONG_DEPTH));
      return false;
     }

   if(ArrayResize(g_priceShifts,i_extremumDepth)<0)
     {
      Alert(name,GetStringByMessageCode(MESSAGE_CODE_ENOUGH_MEMORY));
      return false;
     }

   if(ArrayResize(g_tempPriceShifts,i_extremumDepth)<0)
     {
      Alert(name,GetStringByMessageCode(MESSAGE_CODE_ENOUGH_MEMORY));
      return false;
     }

   if(i_maPeriod<1)
     {
      Alert(name,GetStringByMessageCode(MESSAGE_CODE_WRONG_MA_PERIOD));
      return false;
     }

   g_point = Point;
   g_delta = -g_point / 10;
   if(g_point==0)
     {
      Alert(name,GetStringByMessageCode(MESSAGE_CODE_TERMINAL_FATAL_ERROR1));
      return false;
     }

   g_fiboLevel[0] = i_fiboLevel1;
   g_fiboLevel[1] = i_fiboLevel2;
   g_fiboLevel[2] = i_fiboLevel3;
   g_fiboLevel[3] = i_fiboLevel4;
   if(!IsFiboLevelsUnique())
      return false;

   ArraySort(g_fiboLevel);

   return true;
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Are unique the specified fibo levels?                                                                                                                                                             |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
bool IsFiboLevelsUnique()
  {
   for(int i=0; i<3; i++)
      for(int j=i+1; j<4; j++)
         if(MathAbs(g_fiboLevel[i]-g_fiboLevel[j])<=DBL_EPSILON)
           {
            Alert(WindowExpertName(),GetStringByMessageCode(MESSAGE_CODE_FIBO_EQUALS));
            return false;
           }

   return true;
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Custom indicator deinitialization function                                                                                                                                                        |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectsDeleteAll(0,PREFIX);
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Binding of array and the indicator buffers                                                                                                                                                        |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
bool BuffersBind()
  {
   string name=WindowExpertName();

   if(!SetIndexBuffer(0,g_buffHigh1) || 
      !SetIndexBuffer(1,g_buffHigh2) || 
      !SetIndexBuffer(2,g_buffHigh3) || 
      !SetIndexBuffer(3,g_buffHigh4) || 
      !SetIndexBuffer(4,g_buffLow1) || 
      !SetIndexBuffer(5,g_buffLow2) || 
      !SetIndexBuffer(6,g_buffLow3) || 
      !SetIndexBuffer(7,g_buffLow4))
     {
      Alert(name,GetStringByMessageCode(MESSAGE_CODE_BIND_ERROR),GetLastError());
      return false;
     }

   for(int i=0; i<8; i++)
     {
      SetIndexStyle(i,DRAW_LINE);
      if(i<4)
         SetIndexLabel(i,"Upper "+DoubleToString(g_fiboLevel[3-i],2)+"%");
      else
         SetIndexLabel(i,"Lower "+DoubleToString(g_fiboLevel[i-4],2)+"%");
     }

   return true;
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Initialize of all indicator buffers                                                                                                                                                               |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void BuffersInitializeAll()
  {
   ArrayInitialize(g_buffHigh4,EMPTY_VALUE);
   ArrayInitialize(g_buffHigh3,EMPTY_VALUE);
   ArrayInitialize(g_buffHigh2,EMPTY_VALUE);
   ArrayInitialize(g_buffHigh1,EMPTY_VALUE);
   ArrayInitialize(g_buffLow1,EMPTY_VALUE);
   ArrayInitialize(g_buffLow2,EMPTY_VALUE);
   ArrayInitialize(g_buffLow3,EMPTY_VALUE);
   ArrayInitialize(g_buffLow4,EMPTY_VALUE);
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Determination of bar index which needed to recalculate                                                                                                                                            |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
int GetRecalcIndex(int &total,const int ratesTotal,const int prevCalculated)
  {
   total=ratesTotal-int(i_extremumDepth+i_maPeriod);

   if(i_indBarsCount>0 && i_indBarsCount<total)
      total=MathMin(i_indBarsCount,total);

   if(prevCalculated<ratesTotal-1)
     {
      BuffersInitializeAll();
      return total;
     }

   return (MathMin(ratesTotal - prevCalculated, total));
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Calculate of price shift at the specified bar                                                                                                                                                     |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
double GetPriceShift(int barIndex)
  {
   double ma=iMA(NULL,0,i_maPeriod,0,i_maMethod,i_maPrice,barIndex);
   double highShift= MathAbs(ma-iHigh(NULL,0,barIndex));
   double lowShift = MathAbs(ma-iLow(NULL,0,barIndex));

   return MathMax(highShift, lowShift);
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Calculate of expectation value                                                                                                                                                                    |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
double GetExpectation(double &expectationX2)
  {
   double summ=0.0,summX2=0.0;
   for(int i=0; i<int(i_extremumDepth); i++)
     {
      summ+=g_priceShifts[i];
      summX2+=g_priceShifts[i]*g_priceShifts[i];
     }

   expectationX2=summX2/i_extremumDepth;
   return summ / i_extremumDepth;
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Calculation of median value                                                                                                                                                                       |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
double CalculateMedian(void)
  {
   ArrayCopy(g_tempPriceShifts,g_priceShifts);
   if(!ArraySort(g_tempPriceShifts))
      return 0.0;

   int middleElement=(int)i_extremumDepth/2;
   if(i_extremumDepth%2==1)
      return g_tempPriceShifts[middleElement];

   return (g_tempPriceShifts[middleElement] + g_tempPriceShifts[middleElement - 1]) / 2;
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Calculation of channel shift value                                                                                                                                                                |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
double GetChannelShiftValue()
  {
   int i=0;
   double expect=0.0,expectX2=0.0;
   switch(i_shiftMethod)
     {
      case SHIFT_MAXIMUM:     i=ArrayMaximum(g_priceShifts);
      if(i>=0 && i<int(i_extremumDepth))
         return g_priceShifts[i];
      return 0.0;

      case SHIFT_AVERAGE:     return GetExpectation(expectX2);

      case SHIFT_MEDIAN:      return CalculateMedian();

      case SHIFT_STD:         expect=GetExpectation(expectX2);
      return MathSqrt(expectX2 - expect * expect);
     }

   return 0.0;
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Primary filling of array of price shifts                                                                                                                                                          |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void InitializePriceShifts(int limit)
  {
   for(int i=int(limit+i_extremumDepth-1); i>=limit; i--)
      g_priceShifts[i-limit]=GetPriceShift(i);
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Moving up the elements in array g_priceShifts                                                                                                                                                     |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void MovePriceShifts()
  {
   for(int i=int(i_extremumDepth)-1; i>0; i--)
      g_priceShifts[i]=g_priceShifts[i-1];
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Отображение объекта "Текст"                                                                                                                                                                       |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void ShowText(string name,datetime time,double price,string text,color clr)
  {
   if(ObjectFind(0,name)<0)
     {
      ObjectCreate(0,name,OBJ_TEXT,0,time,price);
      ObjectSetString(0,name,OBJPROP_FONT,FONT_NAME);
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FONT_SIZE);
      ObjectSetString(0,name,OBJPROP_TEXT,text);
      ObjectSetString(0,name,OBJPROP_TOOLTIP,"\n");
      ObjectSetInteger(0,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_LEFT);
      ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
      ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
      return;
     }

   ObjectMove(0,name,0,time,price);
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Show the descriptions for each Fibo level                                                                                                                                                         |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void ShowDescriptions()
  {
   datetime time=iTime(NULL,0,0)+PeriodSeconds();
   ShowText(PREFIX+"HIGH1",time,g_buffHigh1[0],DoubleToString(g_fiboLevel[3],2)+"%",indicator_color1);
   ShowText(PREFIX+"HIGH2",time,g_buffHigh2[0],DoubleToString(g_fiboLevel[2],2)+"%",indicator_color2);
   ShowText(PREFIX+"HIGH3",time,g_buffHigh3[0],DoubleToString(g_fiboLevel[1],2)+"%",indicator_color3);
   ShowText(PREFIX+"HIGH4",time,g_buffHigh4[0],DoubleToString(g_fiboLevel[0],2)+"%",indicator_color4);
   ShowText(PREFIX+"LOW1",time,g_buffLow1[0],DoubleToString(g_fiboLevel[0],2)+"%",indicator_color5);
   ShowText(PREFIX+"LOW2",time,g_buffLow2[0],DoubleToString(g_fiboLevel[1],2)+"%",indicator_color6);
   ShowText(PREFIX+"LOW3",time,g_buffLow3[0],DoubleToString(g_fiboLevel[2],2)+"%",indicator_color7);
   ShowText(PREFIX+"LOW4",time,g_buffLow4[0],DoubleToString(g_fiboLevel[3],2)+"%",indicator_color8);
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Show the channels values at the specified bar                                                                                                                                                     |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void ShowChannel(int barIndex)
  {
   double ma=iMA(NULL,0,i_maPeriod,0,i_maMethod,i_maPrice,barIndex);
   double shift=GetChannelShiftValue();
   g_buffHigh1[barIndex] = ma + shift * g_fiboLevel[3] / 100.0;
   g_buffHigh2[barIndex] = ma + shift * g_fiboLevel[2] / 100.0;
   g_buffHigh3[barIndex] = ma + shift * g_fiboLevel[1] / 100.0;
   g_buffHigh4[barIndex] = ma + shift * g_fiboLevel[0] / 100.0;
   g_buffLow1[barIndex] = ma - shift * g_fiboLevel[0] / 100.0;
   g_buffLow2[barIndex] = ma - shift * g_fiboLevel[1] / 100.0;
   g_buffLow3[barIndex] = ma - shift * g_fiboLevel[2] / 100.0;
   g_buffLow4[barIndex] = ma - shift * g_fiboLevel[3] / 100.0;

   if(barIndex==0)
      ShowDescriptions();
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Calculation of indicators values                                                                                                                                                                  |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void CalcIndicatorData(int limit,int total)
  {
   if(limit>1)
      InitializePriceShifts(limit);

   for(int i=limit; i>=0; i--)
     {
      g_priceShifts[0]=GetPriceShift(i);
      ShowChannel(i);

      if(i>0)
         MovePriceShifts();
     }
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Custom indicator iteration function                                                                                                                                                               |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
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
   iTime(NULL,0,0);
   if(GetLastError()!=ERR_NO_ERROR)
      return prev_calculated;

   int total;
   int limit=GetRecalcIndex(total,rates_total,prev_calculated);

   CalcIndicatorData(limit,total);

   return rates_total;
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Getting string by code of message and terminal language                                                                                                                                           |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
string GetStringByMessageCode(ENUM_MESSAGE_CODE messageCode)
  {
   string language=TerminalInfoString(TERMINAL_LANGUAGE);
   if(language=="Russian")
      return GetRussianMessage(messageCode);

   return GetEnglishMessage(messageCode);
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Getting string by code of message for russian language                                                                                                                                            |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
string GetRussianMessage(ENUM_MESSAGE_CODE messageCode)
  {
   switch(messageCode)
     {
      case MESSAGE_CODE_WRONG_DEPTH:                       return ": период поиска экстремума должен быть более 0. Индикатор отключен.";
      case MESSAGE_CODE_WRONG_MA_PERIOD:                   return ": период расчета МА должен быть более 0. Индикатор отключен.";
      case MESSAGE_CODE_TERMINAL_FATAL_ERROR1:             return ": фатальная ошибка терминала - пункт равен нулю. Индикатор отключен.";
      case MESSAGE_CODE_ENOUGH_MEMORY:                     return ": ошибка распределения памяти для массива. Индикатор отключен.";
      case MESSAGE_CODE_FIBO_EQUALS:                       return ": среди указанных Фибо-уровней обнаружены повторения значений. Индикатор отключен.";
      case MESSAGE_CODE_BIND_ERROR:                        return ": ошибка связывания массивов с буферами индикатора. Ошибка №";
     }

   return "";
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Getting string by code of message for english language                                                                                                                                            |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
string GetEnglishMessage(ENUM_MESSAGE_CODE messageCode)
  {
   switch(messageCode)
     {
      case MESSAGE_CODE_WRONG_DEPTH:                       return ": the depth of extremum search must be greater than 0. The indicator is turned off.";
      case MESSAGE_CODE_WRONG_MA_PERIOD:                   return ": MA calculation period must be greater than 0. The indicator is turned off.";
      case MESSAGE_CODE_TERMINAL_FATAL_ERROR1:             return ": terminal fatal error - point equals to zero. The indicator is turned off.";
      case MESSAGE_CODE_ENOUGH_MEMORY:                     return ": not enough of memory for array. The indicator is turned off.";
      case MESSAGE_CODE_FIBO_EQUALS:                       return ": two or more Fibo levels are equals. The indicator is turned off.";
      case MESSAGE_CODE_BIND_ERROR:                        return ": error of binding of the arrays and the indicator buffers. Error N";
     }

   return "";
  }
//+------------------------------------------------------------------+
