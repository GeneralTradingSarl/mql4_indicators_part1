//+------------------------------------------------------------------+
//|                                  clusterbox_dayhistogramm_ad.mq4 |
//|                                        Copyright 2015, Scriptong |
//|                                          http://advancetools.net |
//+------------------------------------------------------------------+
#property copyright "Scriptong"
#property link      "http://advancetools.net"
#property description "English: Displays the ticks volume by days in the form histogram of clusters.\nRussian: Отображение тиковых объемов по дням в виде гистограммы кластеров."
#property strict

#property indicator_chart_window
#property indicator_buffers 1

#define MAX_VOLUMES_SHOW      5                                                                    // Количество уровней максимального объема, которые следует отображать
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct LevelVolumeColor                                                                            // Структура соответствия уровней объема, достижение которых на ценовом уровне отображается.. 
  {                                                                                                // ..соответствующим цветом
   color             levelColor;
   int               levelMinVolume;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct TickStruct                                                                                  // Структура для записи данных об одном тике
  {
   datetime          time;
   double            bid;
   double            ask;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct ViewRange                                                                                   // Структура для записи границ интервала отображения гистограммы
  {
   datetime          leftTime;
   datetime          rightTime;
   int               rightIndex;
   int               rangeDuration;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct LevelsData                                                                                  // Структура для записи ценового уровня, количества его повторений, роста и падения цены на интервале отображения гистограммы
  {
   double            price;
   int               repeatCnt;
   int               bullsCnt;
   int               bearsCnt;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_YESNO
  {
   YES,                                                                                           // Yes / Да
   NO                                                                                             // No / Нет
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_LINEWIDTH                                                                                // Толщина линий гистограммы
  {
   LINEWIDTH_NULL,                                                                                 // Most thin / Наиболее тонкая
   LINEWIDTH_ONE,                                                                                  // Thin / Тонкая
   LINEWIDTH_TWO,                                                                                  // Median / Средняя
   LINEWIDTH_THREE,                                                                                // Thick / Толстая
   LINEWIDTH_FOUR                                                                                  // Most thick / Наиболее толстая
  };

// Настроечные параметры индикатора
input int      i_pointsInBox           = 50;                                                       // Points in one cluster / Количество пунктов в одном кластере
input string   i_string1               = "Min volumes and colors / Мин. объемы и цвета";           // ==============================================
input int      i_minVolumeLevel1       = 1;                                                        // Minimal volume. Level 1 / Минимальный объем. Уровень 1
input color    i_colorLevel1           = clrSkyBlue;                                               // Color of level 1 / Цвет уровня 1
input int      i_minVolumeLevel2       = 50;                                                       // Minimal volume. Level 2 / Минимальный объем. Уровень 2
input color    i_colorLevel2           = clrTurquoise;                                             // Color of level 2 / Цвет уровня 2
input int      i_minVolumeLevel3       = 75;                                                       // Minimal volume. Level 3 / Минимальный объем. Уровень 3
input color    i_colorLevel3           = clrRoyalBlue;                                             // Color of level 3 / Цвет уровня 3
input int      i_minVolumeLevel4       = 100;                                                      // Minimal volume. Level 4 / Минимальный объем. Уровень 4
input color    i_colorLevel4           = clrBlue;                                                  // Color of level 4 / Цвет уровня 4
input int      i_minVolumeLevel5       = 150;                                                      // Minimal volume. Level 5 / Минимальный объем. Уровень 5
input color    i_colorLevel5           = clrMagenta;                                               // Color of level 5 / Цвет уровня 5
input string   i_string2               = "Delta of volumes / Дельты объемов";                      // ==============================================
input ENUM_YESNO i_isShowDelta         = YES;                                                      // Show the delta of volumes? / Отображать дельту объемов?
input color    i_bullDeltaColor        = clrLime;                                                  // Color of line price growth / Цвет линии роста цены
input color    i_bearDeltaColor        = clrRed;                                                   // Color of line fall in prices / Цвет линии падения цены
input string   i_string3               = "Параметры графика";                                      // ==============================================
input ENUM_LINEWIDTH i_lineWidth       = LINEWIDTH_THREE;                                          // Histogram thickness / Толщина линии гистограммы
input ENUM_YESNO i_point5Digits        = YES;                                                      // Use 5-digits in prices? / Использовать 5-значное представление котировок?
input int      i_indBarsCount=10000;                                                               // Number of bars to display / Кол-во баров отображения

// Прочие глобальные переменные индикатора
bool              g_activate;                                                                      // Признак успешной инициализации индикатора

int               g_curDayNumber,                                                                  // Номер в году для текущего обрабатываемого дня
                  g_pointMultiply;                                                                 // Множитель величины пункта, использующийся при работе на 5-значных котировках

double            g_point;

datetime          g_curDayStart;                                                                   // Время открытия дня, для которого собираются тиковые данные

TickStruct        g_ticks[];                                                                       // Массив для хранения тиков, поступивших после начала работы индикатора                    
LevelVolumeColor  g_volumeLevelsColor[MAX_VOLUMES_SHOW];                                           // Массив объемов и, соответствующих им, цветов уровней
LevelsData        g_levelsData[];                                                                  // Рабочий массив уровней, в который записывается количество тиков, попавших на соответствующую цену

#define PREFIX "CLSTRBXDH_"                                                                        // Префикс имени графических объектов, отображаемых индикатором 
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Custom indicator initialization function                                                                                                                                                          |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
int OnInit()
  {
   g_activate=false;                                                                             // Индикатор не инициализирован

   if(!IsTuningParametersCorrect()) // Неверно указанные значения настроечных параметров - причина неудачной инициализации
      return INIT_FAILED;

   if(!IsLoadTempTicks()) // Загрузка данных о тиках, сохраненных за предыдущий период работы индикатора   
      return INIT_FAILED;

   CreateVolumeColorsArray();                                                                      // Копирование данных о цвете и величине уровней в массив

   if(Period()>=PERIOD_D1)
      Print(WindowExpertName(),": индикатор не отображает данные на таймфреймах D1 и старше.");
   else
      g_activate=true;                                                                           // Индикатор успешно инициализирован

   return INIT_SUCCEEDED;
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Проверка корректности настроечных параметров                                                                                                                                                      |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
bool IsTuningParametersCorrect()
  {
   string name=WindowExpertName();

   int period= Period();
   if(period == 0)
     {
      Alert(name,": фатальная ошибка терминала - период 0 минут. Индикатор отключен.");
      return (false);
     }

   g_point=Point;
   if(g_point==0)
     {
      Alert(name,": фатальная ошибка терминала - величина пункта равна нулю. Индикатор отключен.");
      return (false);
     }

   g_pointMultiply=1;
   if(i_point5Digits==YES)
      g_pointMultiply=10;

   if(i_pointsInBox<3*g_pointMultiply && i_isShowDelta==YES)
     {
      Alert(name,": количество пунктов в кластере должно быть не менее ",3*g_pointMultiply,". Индикатор отключен.");
      return (false);
     }

   if(i_pointsInBox<1)
     {
      Alert(name,": количество пунктов в кластере должно быть не менее 1. Индикатор отключен.");
      return (false);
     }

   g_curDayStart=0;

   return (true);
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Чтение данных о тиках, накопленных в течение предыдущей рабочей сессии программы                                                                                                                  |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
bool IsLoadTempTicks()
  {
// Открытие файла тиковой истории
   int hTicksFile=FileOpen(Symbol()+"temp.tks",FILE_BIN|FILE_READ|FILE_SHARE_READ|FILE_SHARE_WRITE);
   if(hTicksFile<1)
      return true;

// Распределение памяти для массива g_ticks
   int recSize=(int)(FileSize(hTicksFile)/sizeof(TickStruct));
   if(ArrayResize(g_ticks,recSize,1000)<0)
     {
      Alert(WindowExpertName(),": не удалось распределить память для подкачки данных из временного файла тиков. Индикатор отключен.");
      FileClose(hTicksFile);
      return false;
     }

// Чтение файла
   int i=0;
   while(i<recSize)
     {
      if(FileReadStruct(hTicksFile,g_ticks[i])==0)
        {
         Alert(WindowExpertName(),": ошибка чтения данных из временного файла. Индикатор отключен.");
         return false;
        }
      i++;
     }

   FileClose(hTicksFile);
   return true;
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Формирование массива значений объемов и соответствующих им цветам уровней                                                                                                                         |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void CreateVolumeColorsArray()
  {
   g_volumeLevelsColor[0].levelMinVolume = i_minVolumeLevel1;
   g_volumeLevelsColor[1].levelMinVolume = i_minVolumeLevel2;
   g_volumeLevelsColor[2].levelMinVolume = i_minVolumeLevel3;
   g_volumeLevelsColor[3].levelMinVolume = i_minVolumeLevel4;
   g_volumeLevelsColor[4].levelMinVolume = i_minVolumeLevel5;

   g_volumeLevelsColor[0].levelColor = i_colorLevel1;
   g_volumeLevelsColor[1].levelColor = i_colorLevel2;
   g_volumeLevelsColor[2].levelColor = i_colorLevel3;
   g_volumeLevelsColor[3].levelColor = i_colorLevel4;
   g_volumeLevelsColor[4].levelColor = i_colorLevel5;
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Custom indicator deinitialization function                                                                                                                                                        |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(!IsSavedFile()) // Если ни один из подключенных индикаторов не сохранил данные, то их сохранит текущий индикатор
      SaveTempTicks();                                                                             // Сохранение данных о тиках, накопленных за текущий период работы индикатора   
   DeleteAllObjects();
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Проверка наличия записанных данных другим индикатором                                                                                                                                             |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
bool IsSavedFile()
  {
// Получение времени поступления последнего записанного тика
   int lastTickIndex=ArraySize(g_ticks)-1;
   if(lastTickIndex<0) // Ни один тик не был получен. Запись данных не требуется
      return true;

// Открытие файла тиковой истории
   int hTicksFile=FileOpen(Symbol()+"temp.tks",FILE_BIN|FILE_READ|FILE_SHARE_READ|FILE_SHARE_WRITE);
   if(hTicksFile<1)
      return false;

// Перемещение к последней записи в файле
   if(!FileSeek(hTicksFile,-sizeof(TickStruct),SEEK_END))
     {
      FileClose(hTicksFile);
      return false;
     }

// Чтение последней записи и закрытие файла
   TickStruct tick;
   uint readBytes=FileReadStruct(hTicksFile,tick);
   FileClose(hTicksFile);
   if(readBytes==0)
      return false;

// Сравнение даты тика, записанного в файле, и даты последнего поступившего тика
   return tick.time >= g_ticks[lastTickIndex].time;                                                // Дата/время последнего записанного в файле тика больше или равна дате/времени..
                                                                                                   // ..зарегистрированного тика. Значит, файл уже записан, и повторная запись не требуется
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Сохранение данных о тиках, накопленных за текущую рабочую сессию программы                                                                                                                        |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void SaveTempTicks()
  {
// Создание файла тиковой истории
   int hTicksFile=FileOpen(Symbol()+"temp.tks",FILE_BIN|FILE_READ|FILE_WRITE|FILE_SHARE_READ|FILE_SHARE_WRITE);
   if(hTicksFile<1)
      return;

// Запись файла
   int total=ArraySize(g_ticks),i=0;
   while(i<total)
     {
      if(FileWriteStruct(hTicksFile,g_ticks[i])==0)
        {
         Print("Ошибка сохранения данных во временный файл...");
         return;
        }
      i++;
     }

   FileClose(hTicksFile);
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Удаление всех объектов, созданных программой                                                                                                                                                      |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void DeleteAllObjects()
  {
   for(int i=ObjectsTotal()-1; i>=0; i--)
      if(StringSubstr(ObjectName(i),0,StringLen(PREFIX))==PREFIX)
         ObjectDelete(ObjectName(i));
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Отображение трендовой линии                                                                                                                                                                       |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void ShowTrendLine(datetime time1,double price1,datetime time2,double price2,string toolTip,color clr)
  {
   string name=PREFIX+"LINE_"+IntegerToString((int)MathRound(price1/g_point))+IntegerToString(time1);

   if(ObjectFind(0,name)<0)
     {
      ObjectCreate(0,name,OBJ_TREND,0,time1,price1,time2,price2);
      ObjectSetInteger(0,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(0,name,OBJPROP_BACK,true);
      ObjectSetInteger(0,name,OBJPROP_WIDTH,(int)i_lineWidth);
      ObjectSetInteger(0,name,OBJPROP_RAY,false);
      ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
      ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
      ObjectSetString(0,name,OBJPROP_TOOLTIP,toolTip);
      return;
     }

   ObjectMove(0,name,0,time1,price1);
   ObjectMove(0,name,1,time2,price2);
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr);
   ObjectSetString(0,name,OBJPROP_TOOLTIP,toolTip);
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Определение индекса бара, с которого необходимо производить перерасчет                                                                                                                            |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
int GetRecalcIndex(int &total,const int ratesTotal,const int prevCalculated)
  {
// Определение первого бара истории, на котором будут доступны адекватные значения индикатора
   total=ratesTotal-1;

// А может значения индикатора не нужно отображать на всей истории?
   if(i_indBarsCount>0 && i_indBarsCount<total)
      total=MathMin(i_indBarsCount,total);

// Первое отображение индикатора или произошла подкачка данных, т. е. на предыдущем тике баров было не на один бар меньше, как при нормальном развитии истории, а на два или более баров меньше
   if(prevCalculated<ratesTotal-1)
     {
      DeleteAllObjects();
      return (total);
     }

// Нормальное развитие истории. Количество баров текущего тика отличается от количества баров предыдущего тика не больше, чем на один бар
   return (MathMin(ratesTotal - prevCalculated, total));
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Равны ли числа?                                                                                                                                                                                   |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
bool IsValuesEquals(double first,double second)
  {
   return (MathAbs(first - second) < Point / 10);
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Запись данных о тике в массив g_ticks                                                                                                                                                             |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
bool IsUpdateTicksArray(TickStruct &tick)
  {
   int total=ArraySize(g_ticks);
   if(ArrayResize(g_ticks,total+1,100)<0)
     {
      Alert(WindowExpertName(),": индикатору не хватает памяти для сохранения данных об очередном тике.");
      return false;
     }

   g_ticks[total]=tick;
   return true;
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Проверка необходимости открытия нового дня                                                                                                                                                        |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void CheckForNewDayOpen(TickStruct &curTick)
  {
   int curTickDayNumber=TimeDayOfYear(curTick.time);
   if(g_curDayNumber==curTickDayNumber) // Новый тик принадлежит текущему дню
      return;

// Новый тик принадлежит другому дню
   ShowHistogramm();
   string dayOpen= TimeToString(curTick.time,TIME_DATE);
   g_curDayStart = StringToTime(dayOpen);
   g_curDayNumber= TimeDayOfYear(g_curDayStart);

// Обнуление текущей истории
   ArrayResize(g_levelsData,0,1000);
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Запись данных о тике в массив g_levelsData                                                                                                                                                        |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
bool IsSaveTickData(TickStruct &curTick,TickStruct &prevTick)
  {
// Проверка необходимости открытия нового дня
   CheckForNewDayOpen(curTick);

// Преобразование цены к ближайшему кластеру
   double clusterPrice=CastPriceToCluster(curTick.bid);

// Поиск такой же цены в массиве g_levelsData
   int i=0;
   int total=ArraySize(g_levelsData);
   for(; i<total; i++)
      if(IsValuesEquals(g_levelsData[i].price,clusterPrice))
         break;

// Похожая цена найдена
   if(i<total)
     {
      g_levelsData[i].repeatCnt++;
      SaveDeltaData(i,curTick.bid,prevTick.bid);
      return true;
     }

// Указанная цена является новой - расширение массива
   if(ArrayResize(g_levelsData,total+1,1000)!=total+1)
     {
      Alert(WindowExpertName(),": индикатору не хватает памяти для корректной работы.");
      return false;
     }

   g_levelsData[total].price=clusterPrice;
   g_levelsData[total].repeatCnt=1;
   g_levelsData[i].bullsCnt = 0;
   g_levelsData[i].bearsCnt = 0;
   SaveDeltaData(i,curTick.bid,prevTick.bid);
   return true;
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Приведение рыночной цены к цене кластера с учетом его высоты                                                                                                                                      |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
double CastPriceToCluster(double price)
  {
   int priceInPoints=(int)MathRound(price/Point);
   int clusterPrice =(int)MathRound(priceInPoints/1.0/i_pointsInBox);
   return NormalizeDouble(clusterPrice * Point * i_pointsInBox, Digits);
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Запись данных о росте или падении цены в пределах кластера                                                                                                                                        |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void SaveDeltaData(int index,double curBid,double prevBid)
  {
   if(curBid>prevBid)
      g_levelsData[index].bullsCnt++;
   if(curBid<prevBid)
      g_levelsData[index].bearsCnt++;
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Чтение одного тика из файла                                                                                                                                                                       |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
bool IsReadTimeAndBidAskOfTick(int hTicksFile,TickStruct &tick)
  {
   if(FileIsEnding(hTicksFile))
      return false;

   uint bytesCnt=FileReadStruct(hTicksFile,tick);
   return bytesCnt == sizeof(TickStruct);
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Считывание тиков, принадлежащих действующему интервалу отображения гистограммы                                                                                                                    |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
bool IsReadTicksFromFile(datetime &lastTime,int total)
  {
// Обнуление текущей истории
   ArrayResize(g_levelsData,0);

// Открытие файла тиковой истории
   int hTicksFile=FileOpen(Symbol()+".tks",FILE_BIN|FILE_READ|FILE_SHARE_READ|FILE_SHARE_WRITE);
   if(hTicksFile<1)
      return true;

// Чтение файла
   TickStruct tick={0,0,0};
   TickStruct prevTick;
   bool result=true;
   datetime viewStartTime=Time[total];
   while(!IsStopped())
     {
      prevTick=tick;
      bool fileClose=!IsReadTimeAndBidAskOfTick(hTicksFile,tick);
      if(fileClose || tick.time==0)
         break;

      if(tick.time<viewStartTime)
         continue;

      if(!IsSaveTickData(tick,prevTick))
        {
         result=false;
         break;
        }
     }

   FileClose(hTicksFile);
   lastTime = tick.time;                                                                           // Указываем последнюю прочитанную дату, чтобы дополнить полученные данные из локального буфера..
                                                                                                   // ..при необходимости
   return result;
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Чтение данных о тиках из локального буфера, чтобы не потерять тики, пришедшие после начала работы индикатора, но не попавшие в файл                                                               |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
bool ReadTicksFromBuffer(datetime lastTime,int total)
  {
// Возможно, данные из главного тикового файла заканчиваются до момента начала интервала отображения данных индикатора
   lastTime=(datetime)MathMax(lastTime,Time[total]);

// Поиск индекса для g_ticks, с которого необходимо продолжить чтение данных
   int totalTicks=ArraySize(g_ticks);
   int i=0;
   while(i<totalTicks && lastTime>=g_ticks[i].time)
      i++;

// Осуществление дополнения
   datetime timeTotal=Time[0]+PeriodSeconds();
   TickStruct prevTick={0,0,0};
   if(i>0)
      prevTick=g_ticks[i-1];
   while(i<totalTicks && g_ticks[i].time<timeTotal)
     {
      if(!IsSaveTickData(g_ticks[i],prevTick))
         return false;

      prevTick=g_ticks[i];
      i++;
     }

   return true;
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Определение максимального значения тикового объема в среди найденных кластеров                                                                                                                    |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
int GetMaxTickVolume()
  {
   int max=0;
   int total = ArraySize(g_levelsData);
   for(int i = 0; i < total; i++)
      if(g_levelsData[i].repeatCnt>max)
         max=g_levelsData[i].repeatCnt;

   return max;
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Отображение гистограммы                                                                                                                                                                           |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void ShowHistogramm()
  {
   int maxVolume= GetMaxTickVolume();
   if(maxVolume == 0)
      return;

   int total=ArraySize(g_levelsData);
   int curDayStartBarIndex=0,dayDuration=0;
   datetime curDayLastBarTime=GetCurDayLastBarTime(curDayStartBarIndex,dayDuration);
   for(int i=0; i<total; i++)
     {
      int volumeLevel=GetVolumeLevel(g_levelsData[i].repeatCnt);
      if(volumeLevel<0)
         continue;

      // Отображение гистограммы объема
      string price="Кластер: "+DoubleToString(g_levelsData[i].price,Digits);
      datetime histRightTime=GetHistRightTime(curDayLastBarTime,curDayStartBarIndex,dayDuration,g_levelsData[i].repeatCnt,maxVolume);
      ShowTrendLine(g_curDayStart,g_levelsData[i].price,histRightTime,g_levelsData[i].price,price+". Объем: "+IntegerToString(g_levelsData[i].repeatCnt),
                    g_volumeLevelsColor[volumeLevel].levelColor);

      // Отображение гистограмм роста и падения цены
      if(i_isShowDelta==NO)
         continue;
      histRightTime=GetHistRightTime(curDayLastBarTime,curDayStartBarIndex,dayDuration,g_levelsData[i].bearsCnt,maxVolume);
      ShowTrendLine(g_curDayStart,g_levelsData[i].price+g_pointMultiply*Point,histRightTime,g_levelsData[i].price+g_pointMultiply*Point,
                    price+". Объем падения: "+IntegerToString(g_levelsData[i].bearsCnt),i_bearDeltaColor);
      histRightTime=GetHistRightTime(curDayLastBarTime,curDayStartBarIndex,dayDuration,g_levelsData[i].bullsCnt,maxVolume);
      ShowTrendLine(g_curDayStart,g_levelsData[i].price+2*g_pointMultiply*Point,histRightTime,g_levelsData[i].price+2*g_pointMultiply*Point,
                    price+". Объем роста: "+IntegerToString(g_levelsData[i].bullsCnt),i_bullDeltaColor);
     }
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Определение времени открытия последнего бара текущего дня (исходя из значения g_curDayOpen), а также индексов начального и конечного баров дня                                                    |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
datetime GetCurDayLastBarTime(int &curDayStartBarIndex,int &dayDuration)
  {
// Индекс начального бара дня
   curDayStartBarIndex=iBarShift(NULL,0,g_curDayStart);
   while(Time[curDayStartBarIndex]<g_curDayStart && curDayStartBarIndex>0)
      curDayStartBarIndex--;

// Индекс конечного бара дня
   datetime absoluteDayEnd=g_curDayStart+PERIOD_D1*60-1;
   int curDayEndBarIndex=iBarShift(NULL,0,absoluteDayEnd);
   while(Time[curDayEndBarIndex]>absoluteDayEnd && curDayEndBarIndex<Bars)
      curDayEndBarIndex++;

// Время окончания дня в соответствии с индексом конечного бара
   dayDuration=curDayStartBarIndex-curDayEndBarIndex;
   return Time[curDayEndBarIndex] + PeriodSeconds() - 1;
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Определение, какому из указанных объемов соответствует рассматриваемая величина объема                                                                                                            |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
int GetVolumeLevel(int ticksVolume)
  {
   for(int i=0; i<MAX_VOLUMES_SHOW; i++)
      if(g_volumeLevelsColor[i].levelMinVolume>ticksVolume)
         return i - 1;

   return MAX_VOLUMES_SHOW - 1;
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Вычисление времени бара, на котором должна заканчиваться линия гистограммы с указанным тиковым объемом                                                                                            |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
datetime GetHistRightTime(datetime curDayLastBarTime,int curDayStartBarIndex,int dayDuration,int tickVolume,int maxVolume)
  {
   int barsIndex=curDayStartBarIndex -(int)(dayDuration*tickVolume/1.0/maxVolume);
   if(barsIndex<0 || barsIndex>=Bars)
      return curDayLastBarTime;

   return Time[barsIndex];
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Осуществление чтения данных из файла и полное отображение гистограммы                                                                                                                             |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void ShowNewData(int total)
  {
// Чтение данных из файла
   datetime lastTime=0;
   if(!IsReadTicksFromFile(lastTime,total))
     {
      g_activate=false;
      return;
     }

// Дополнение данных из локального буфера
   if(!ReadTicksFromBuffer(lastTime,total))
     {
      g_activate=false;
      return;
     }

   ShowHistogramm();
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Обновление данных по кластерам                                                                                                                                                                    |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void UpdateData()
  {
   TickStruct tick;
   tick.time= TimeCurrent();
   tick.ask = Ask;
   tick.bid = Bid;

// Добавление одного тика в массив хранения тиков   
   if(!IsUpdateTicksArray(tick))
     {
      g_activate=false;
      return;
     }

// Добавление тика в массив кластеров
   TickStruct prevTick={0,0,0};
   int lastTickIndex=ArraySize(g_ticks)-1;
   if(lastTickIndex>0)
      prevTick=g_ticks[lastTickIndex-1];
   if(!IsSaveTickData(tick,prevTick))
     {
      g_activate=false;
      return;
     }

   ShowHistogramm();
  }
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
//| Отображение данных индикатора                                                                                                                                                                     |
//+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
void ShowIndicatorData(int limit,int total)
  {
   if(limit>0)
     {
      ShowNewData(total);
      return;
     }

   UpdateData();
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
   if(!g_activate) // Если в процессе работы индикатора возникла ошибка, то работать программа не должна
      return rates_total;

   int total;
   int limit=GetRecalcIndex(total,rates_total,prev_calculated);                                // С какого бара начинать обновление?

   ShowIndicatorData(limit,total);                                                                // Отображение данных индикатора
   WindowRedraw();

   return rates_total;
  }
//+------------------------------------------------------------------+
