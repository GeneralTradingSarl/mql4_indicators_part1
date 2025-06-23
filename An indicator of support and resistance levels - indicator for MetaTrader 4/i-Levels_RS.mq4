//+------------------------------------------------------------------+
//|                         i-Levels_RS.mq4 версия 1.1 от 02.08.2005 |
//|                                           Ким Игорь В. aka KimIV |
//|                                              http://www.kimiv.ru |
//+------------------------------------------------------------------+
#property copyright "Ким Игорь В. aka KimIV"
#property link      "http://www.kimiv.ru"

#property indicator_chart_window
#property indicator_buffers 6
#property indicator_color1 DarkBlue
#property indicator_color2 Blue
#property indicator_color3 SkyBlue
#property indicator_color4 Orange
#property indicator_color5 Red
#property indicator_color6 Maroon
//------- input parameters
extern int  NumberOfDay = 10;     // Количество дней
extern bool StrongOnly  = false;  // Показывать только сильные уровни
//------- Глобальные переменные --------------------------------------
datetime Data[];
double   R3[], PR3[];
double   R2[], PR2[];
double   R1[], PR1[];
double   S1[], PS1[];
double   S2[], PS2[];
double   S3[], PS3[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void init()
{
  // Установка размерности массивов
  ArrayResize(Data, NumberOfDay);
  ArrayResize(R3, NumberOfDay); ArrayResize(PR3, NumberOfDay);
  ArrayResize(R2, NumberOfDay); ArrayResize(PR2, NumberOfDay);
  ArrayResize(R1, NumberOfDay); ArrayResize(PR1, NumberOfDay);
  ArrayResize(S1, NumberOfDay); ArrayResize(PS1, NumberOfDay);
  ArrayResize(S2, NumberOfDay); ArrayResize(PS2, NumberOfDay);
  ArrayResize(S3, NumberOfDay); ArrayResize(PS3, NumberOfDay);

  // Загрузка уровней из файла в массивы
  int fh = FileOpen("Levels_RS_"+Symbol()+".csv", FILE_CSV|FILE_READ, ";");
  if (fh > 0)
  {
    for (int i = 0; i < NumberOfDay; i++)
    {
      Data[i] = StrToTime(FileReadString(fh));

      R3 [i] = StrToDouble(FileReadString(fh));
      PR3[i] = StrToInteger(FileReadString(fh));
      
      R2 [i] = StrToDouble(FileReadString(fh));
      PR2[i] = StrToInteger(FileReadString(fh));
      
      R1 [i] = StrToDouble(FileReadString(fh));
      PR1[i] = StrToInteger(FileReadString(fh));
      
      S1 [i] = StrToDouble(FileReadString(fh));
      PS1[i] = StrToInteger(FileReadString(fh));
      
      S2 [i] = StrToDouble(FileReadString(fh));
      PS2[i] = StrToInteger(FileReadString(fh));
      
      S3 [i] = StrToDouble(FileReadString(fh));
      PS3[i] = StrToInteger(FileReadString(fh));
    }
    FileClose(fh);
  }
  Comment("");
}

//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
void deinit()
{
  // Удаление объектов
  for (int i = 0; i < NumberOfDay; i++)
  {
    ObjectDelete("R3"+i);
    ObjectDelete("R2"+i);
    ObjectDelete("R1"+i);
    ObjectDelete("S1"+i);
    ObjectDelete("S2"+i);
    ObjectDelete("S3"+i);
  }
  Comment("");
}

//+------------------------------------------------------------------+
//| Создание объектов ЛИНИЯ и их отрисовка на графике                |
//+------------------------------------------------------------------+
// nv - Наименование уровня
// nd - Номер дня от 0 (текущий) и дальше в глубь истории
// zl - Значение уровня
// sl - Сила уровня (0-слабый, 1-сильный)
// cl - Цвет линии
void DrawLine(string nv, int nd, double zl, bool sl, color cl)
{
  datetime dd1 = Data[nd];
  datetime dd2 = StrToTime(TimeToStr(dd1, TIME_DATE)+" 23:59");

  if (!StrongOnly || sl)
  {
    ObjectCreate(nv+nd, OBJ_TREND, 0, dd1, zl, dd2, zl);

    ObjectSet(nv+nd, OBJPROP_RAY  , False);
    ObjectSet(nv+nd, OBJPROP_COLOR, cl);
    ObjectSet(nv+nd, OBJPROP_STYLE, STYLE_SOLID);      
    ObjectSet(nv+nd, OBJPROP_WIDTH, (sl + 1) * 2);
  }
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
void start()
{
  if (Period() > 240) Comment("Индикатор Levels_RS ТФ больше Н4 не поддерживает!");
  else
  {
    // Отображение уровней на графике
    for (int i = 0; i < NumberOfDay; i++)
    {
      if (R3[i]>0) DrawLine("R3", i, R3[i], PR3[i], indicator_color1);
      if (R2[i]>0) DrawLine("R2", i, R2[i], PR2[i], indicator_color2);
      if (R1[i]>0) DrawLine("R1", i, R1[i], PR1[i], indicator_color3);
      if (S1[i]>0) DrawLine("S1", i, S1[i], PS1[i], indicator_color4);
      if (S2[i]>0) DrawLine("S2", i, S2[i], PS2[i], indicator_color5);
      if (S3[i]>0) DrawLine("S3", i, S3[i], PS3[i], indicator_color6);
    }
  }
}
//+------------------------------------------------------------------+

