//+------------------------------------------------------------------+
//|                                                EquityOnChart.mq4 |
//|                      Copyright © 2007, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.ru/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.ru/"

//#property indicator_separate_window
#property indicator_chart_window

#property indicator_buffers 5
#property indicator_color5 Red
#property indicator_color4 DarkOrange
#property indicator_color3 Blue
#property indicator_color2 Black
#property indicator_color1 ForestGreen

#property indicator_level1 13000 
#property indicator_level2 12000 
#property indicator_level3 11000 
#property indicator_level4 10000 
#property indicator_level5 9000 
#property indicator_level6 8000 
#property indicator_level7 7000 
#property indicator_level8 6000 
#property indicator_levelcolor Red

//---- input parameters
extern string    fileName="equity.csv";
extern double    MaxEquity=13000;
extern double    MinEquity=6000;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];

bool Calculated=false;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE,0,3);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_LINE,0,3);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_LINE,0,3);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexStyle(3,DRAW_LINE,0,3);
   SetIndexBuffer(3,ExtMapBuffer4);
   SetIndexStyle(4,DRAW_LINE,0,5);
   SetIndexBuffer(4,ExtMapBuffer5);
   IndicatorShortName("");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
//----
   return(0);
  }

//+------------------------------------------------------------------+
//|   Проверить Максимальную и минимальную цены на графике           |
//+------------------------------------------------------------------+
void CheckLevels(double & MaxPrice, double & MinPrice)
   {
//----
   int period=WindowBarsPerChart();
   MaxPrice=High[iHighest(Symbol(),0,MODE_HIGH,period,0)];
   MinPrice=Low[iLowest(Symbol(),0,MODE_LOW,period,0)];
   Comment("");
   //Comment("MaxPrice=",MaxPrice,"   MinPrice=",MinPrice);
//----
   return;   
   }
//+------------------------------------------------------------------+
//| запись содержимого файла в массив строк array[]                  |
//| в случае неудачи вернем false                                    |
//+------------------------------------------------------------------+
bool ReadFileToArray(string &array[],string FileName,string WorkFolderName,int devider='\x90')
  {
   bool res=false;
   int FileHandle;
   string tempArray[64000],currString;
   int stringCounter;
   string FullFileName;
 
   if (StringLen(WorkFolderName)>0) FullFileName=StringConcatenate(WorkFolderName,"\\",FileName);
   else FullFileName=FileName;
//----
   //Print("Попытка прочитать файл ",FileName);
   FileHandle=FileOpen(FullFileName,FILE_READ|FILE_CSV,devider);
   if (FileHandle!=-1)
      {
      while(!FileIsEnding(FileHandle)) 
         {
         currString=FileReadString(FileHandle);
         tempArray[stringCounter]=currString;
         //Print(stringCounter,":  ",currString);
         stringCounter++;
         }
      stringCounter--;
      if (stringCounter>0) 
         {
         ArrayResize(array,stringCounter);
         for (int i=0;i<stringCounter;i++) array[i]=tempArray[i];
         res=true;
         }
      FileClose(FileHandle);   
      }
   else
      {
      Print("Не удалось прочитать файл ",FileName,"|  ошибка ",GetLastError());
      }      
//----
   return(res);
  }

//+------------------------------------------------------------------+
//|  fill array of strings                                           |
//+------------------------------------------------------------------+
void SplitString(string &ArrayRes[],string InputString,string splitter)
  {
   string temp,tempArray[100];
   int pos,splitLength=StringLen(splitter),InputStrLength=StringLen(InputString),counter;
 
   pos=StringFind(InputString,splitter);
   if (pos!=-1)
      {
      if (pos==0) InputString=StringSubstr(InputString,splitLength,InputStrLength-splitLength);
      while (StringFind(InputString,splitter)!=-1)
         {
         pos=StringFind(InputString,splitter);
         InputStrLength=StringLen(InputString);
         tempArray[counter]=StringSubstr(InputString,0,pos);
         InputString=StringSubstr(InputString,pos+splitLength,InputStrLength-splitLength-pos);
         counter++;
         }
      if (StringLen(InputString)!=0)
         {
         tempArray[counter]=InputString;
         counter++;
         }  
      }
   ArrayResize(ArrayRes,counter);
   for (int i=0;i<counter;i++) 
      {
      ArrayRes[i]=tempArray[i];
      //Print("i=",i,"   string=",ArrayRes[i]);
      }
   return;  
  }

//+------------------------------------------------------------------+
//| возвращает первый индекс, с которого отображается индикатор      |
//+------------------------------------------------------------------+
int GetFirstBarIndex()
   {
   int res;
//----
   int window=ObjectFind("start");
   if (window==0)
      {
      if (ObjectType("start")==OBJ_VLINE)
         {
         datetime Time1=ObjectGet("start",OBJPROP_TIME1);
         //Print("Time1=",TimeToStr(Time1));
         }
      res=iBarShift(NULL,0,Time1);
      }
//----
   return(res);   
   }
   
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int  i,counted_bars=IndicatorCounted();
   double max,min;
   int firstBar=GetFirstBarIndex();
   if (firstBar==0 && !Calculated)  
      {
      Alert("Не найдена вертикальная линия с описанием \" start\" ");
      Calculated=true;
      return;
      }
   //firstBar;      
   //Print("firstBar=",firstBar);
//----

   if (!Calculated)
      {
      CheckLevels(max,min); //  не требуется в данном случае
      double equityArray[][5];
      string EquityStrings[];
      string ArrayFromString[];
      double scale=(MaxEquity-MinEquity)/(max-min);
      
      if (!ReadFileToArray(EquityStrings,fileName,"")) Print("Не удалось прочитать данные из файла, ошибка ",GetLastError());

      SplitString(ArrayFromString,EquityStrings[0],";");
      int days=ArraySize(ArrayFromString);
      ArrayResize(equityArray,days);      
      
      ExtMapBuffer1[firstBar]=10000;
      for (i=1;i<days;i++) 
         {
         ExtMapBuffer1[firstBar-i]=StrToDouble(ArrayFromString[i]);
      //   Print("i=",i, "    ExtMapBuffer1=",ExtMapBuffer1[firstBar-i],"   ArrayFromString=",ArrayFromString[i]);
         }
      
      SplitString(ArrayFromString,EquityStrings[1],";");
      ExtMapBuffer2[firstBar]=10000;
      for (i=1;i<days;i++) 
         {
         ExtMapBuffer2[firstBar-i]=StrToDouble(ArrayFromString[i]);
      //   Print("i=",i, "    ExtMapBuffer1=",ExtMapBuffer1[firstBar-i],"   ArrayFromString=",ArrayFromString[i]);
         }
      
      SplitString(ArrayFromString,EquityStrings[2],";");
      ExtMapBuffer3[firstBar]=10000;
      for (i=1;i<days;i++) 
         {
         ExtMapBuffer3[firstBar-i]=StrToDouble(ArrayFromString[i]);
      //   Print("i=",i, "    ExtMapBuffer1=",ExtMapBuffer1[firstBar-i],"   ArrayFromString=",ArrayFromString[i]);
         }
      
      
      SplitString(ArrayFromString,EquityStrings[3],";");
      ExtMapBuffer4[firstBar]=10000;
      for (i=1;i<days;i++) 
         {
         ExtMapBuffer4[firstBar-i]=StrToDouble(ArrayFromString[i]);
      //   Print("i=",i, "    ExtMapBuffer1=",ExtMapBuffer1[firstBar-i],"   ArrayFromString=",ArrayFromString[i]);
         }


      SplitString(ArrayFromString,EquityStrings[4],";");
      ExtMapBuffer5[firstBar]=10000;
      for (i=1;i<days;i++) 
         {
         ExtMapBuffer5[firstBar-i]=StrToDouble(ArrayFromString[i]);
      //   Print("i=",i, "    ExtMapBuffer1=",ExtMapBuffer1[firstBar-i],"   ArrayFromString=",ArrayFromString[i]);
         }

      
      Calculated=true;
      }   
   
//----
   return(0);
  }
//+------------------------------------------------------------------+