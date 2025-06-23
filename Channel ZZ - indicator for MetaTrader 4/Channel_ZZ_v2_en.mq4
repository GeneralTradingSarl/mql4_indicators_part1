//+------------------------------------------------------------------+
//|                                                   Channel ZZ.mq4 |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, TheXpert"
#property link      "theforexpert@gmail.com"

extern string     _1                      = "Channel width in points";
extern int        ChannelPoints           = 150;
extern string     _2                      = "Channel width in percent";
extern double     ChannelPercent          = 1.5;
extern string     _3                      = "If 0, channel is counted using ChannelPoints , if 1 -- using ChannelPercent";
extern int        ChannelType             = 1;
extern string     _4                      = "Font size";
extern int        FontSize                = 10;
extern string     _5                      = "Font name";
extern string     FontName                = "Arial Black";
extern string     _6                      = "Font color";
extern color      FontColor               = Yellow;
extern string     _7                      = "Draw or not objects containing ZZ statistics";
extern bool       DrawStatistics          = true;
extern string     _8                      = "Offset for stats objects in points";
extern int        StatisticsOffsetPoints  = 20;
extern string     _9                      = "Alert or not when the direction has been changed";
extern bool       AlertBreakout           = true;

#property indicator_chart_window
#property indicator_buffers 3

#property indicator_color1 LightGray
#property indicator_width1 3

#property indicator_color2 LightGreen
#property indicator_color3 Orange

#property indicator_style2 STYLE_DASH
#property indicator_style3 STYLE_DASH

#define ID "Channel ZZ Stats "

//---- buffers
double ZZ[];
double UpChannel[];
double DnChannel[];

string symbol;

#define UP 1
#define DN -1
#define NONE 0

int Direction;
int LastDirection;

datetime StartMax;
datetime EndMax;
datetime StartMin;
datetime EndMin;

// Channel Variables
datetime StartChannel;
datetime EndChannel;

// Object Variables
int Counter;
int Length;
int LastLength;

double   LastExtrValue;
double   ExtrValue;
int      ExtrDirection;
datetime ExtrTime;

int ChannelWidth;

void DrawInfo(datetime endDraw)
{
   if (!DrawStatistics) return;
   
   Length = MathAbs(MathRound((ExtrValue - LastExtrValue)/Point));

   double pos = ExtrValue;
   if (Direction == UP) pos += StatisticsOffsetPoints*Point;
   
   string id = ID + Counter;
   
   string text;
   if (LastExtrValue != 0)
   {
      text = "(" + Length + ")";
      
      if (LastLength != 0)
      {
         text = DoubleToStr(Length/(1.0*LastLength), 2) + text;
      }
   }

   if (ObjectFind(id) == -1)
   {
      ObjectCreate(id, OBJ_TEXT, 0, endDraw, pos);
      ObjectSet(id, OBJPROP_COLOR, FontColor);
   }

   ObjectMove(id, 0, endDraw, pos);
   ObjectSetText(id, text, FontSize, FontName);
}

void NotifyDirectionChange()
{
   if (!AlertBreakout) return;
   
   if (ExtrTime < Time[1]) return;
   
   string direction = "UP";
   if (Direction != UP) direction = "DOWN";
   
   Alert("Channel ZZ ", Symbol(), " changed direction to ", direction);
}

void SetExtremum(double value, int direction, datetime time)
{
   if (direction == ExtrDirection && ExtrTime != 0)
   {
      if (time == ExtrTime)
      {
         ExtrValue = value;
         DrawInfo(time);
      }
      else
      {
         ZZ[iBarShift(NULL, 0, ExtrTime)] = EMPTY_VALUE;
         
         ExtrValue = value;
         ExtrTime = time;
         DrawInfo(time);
      }
   }
   else
   {
      LastExtrValue = ExtrValue;
      ExtrValue = value;
      ExtrDirection = direction;
      ExtrTime = time;
      
      if (ChannelType == 1)
      {
         ChannelWidth = ChannelPercent*value/Point/100;
      }
      
      LastLength = Length;
      Counter++;
      DrawInfo(time);
      NotifyDirectionChange();
   }
   ZZ[iBarShift(NULL, 0, ExtrTime)] = ExtrValue;
}

int init()
{
   IndicatorShortName("-=<Channel ZZ>=-");

   IndicatorBuffers(3);
   
   SetIndexBuffer(0, ZZ);
   SetIndexBuffer(1, UpChannel);
   SetIndexBuffer(2, DnChannel);
   
   SetIndexStyle(0, DRAW_SECTION);
   SetIndexStyle(1, DRAW_SECTION, STYLE_DASH);
   SetIndexStyle(2, DRAW_SECTION, STYLE_DASH);
   
   symbol = Symbol();
   
   Direction = NONE;
   Counter = 0;

   StartMax = 0;
   EndMax = 0;
   StartMin = 0;
   EndMin = 0;
   
   Length = 0;
   LastLength = EMPTY_VALUE;
   
   LastExtrValue = 0;

   if (ChannelType == 0)
   {
      ChannelWidth = ChannelPoints;
   }
   
   return(0);
}

int deinit()
{
   for (int i = 0; i <= Counter; i++)
   {
      ObjectDelete(ID + i);
   }
}

int start()
{
   int ToCount = Bars - IndicatorCounted();
   
   if (ToCount > 2)
   {
      ToCount = Bars;
      ArrayInitialize(ZZ, EMPTY_VALUE);
      ArrayInitialize(UpChannel, EMPTY_VALUE);
      ArrayInitialize(DnChannel, EMPTY_VALUE);
   }
   
   for (int i = ToCount - 1; i >= 1; i--)
   {
      if (Direction == NONE)
      {
         CheckInit(i);
         continue;
      }
      
      if (Direction == UP)      
      {
         CheckUp(i);
      }
      else
      {
         CheckDown(i);
      }
      
      DrawChannel(i);
   }
   return(0);
}

void CheckInit(int i)
{
   if (StartMax == 0 || StartMin == 0)
   {
      if (StartMax == 0) StartMax = Time[i];
      if (StartMin == 0) StartMin = Time[i];
      
      ExtrTime = 0;
      
      return;
   }
   
   if (Direction == NONE)
   {
      double maxValue = High[iBarShift(symbol, 0, StartMax)];
      double minValue = Low[iBarShift(symbol, 0, StartMin)];
      
      double nowMax = High[i];
      double nowMin = Low[i];
      
      if (nowMax > maxValue && Time[i] > StartMax)
      {
         EndMax = Time[i];
         StartMin = Time[i];
         Direction = UP;

         SetExtremum(nowMax, UP, EndMax);
      }
      else if (nowMin > minValue && Time[i] > StartMin)
      {
         EndMin = Time[i];
         StartMax = Time[i];
         Direction = DN;

         SetExtremum(nowMin, DN, EndMin);
      }
   }
}

void CheckUp(int i)
{
   int startIndex = iBarShift(symbol, 0, StartMax);
   int endIndex = iBarShift(symbol, 0, EndMax);

   double endMaxValue = High[endIndex];
      
   if (endMaxValue < High[i])
   {
      endMaxValue = High[i];
      EndMax = Time[i];
      
      SetExtremum(High[i], UP, EndMax);
   }
   else 
   {  
      double startMaxValue = High[startIndex];
      double startMinValue = Low[iBarShift(symbol, 0, StartMin)];
      
      double nowMaxValue = endMaxValue;
      if (startIndex - endIndex != 0)
      {
         nowMaxValue += (endMaxValue - startMaxValue)/(startIndex - endIndex)*(endIndex - i);
      }

      double nowMinValue = Low[i];
      
      if (nowMaxValue - nowMinValue > ChannelWidth*Point)
      {
         if (EndMax != i)
         {
            StartMin = Time[i];
            EndMin = Time[i];
            Direction = DN;

            SetExtremum(Low[i], DN, EndMin);
         }
      }
   }
}

void CheckDown(int i)
{
   int startIndex = iBarShift(symbol, 0, StartMin);
   int endIndex = iBarShift(symbol, 0, EndMin);

   double endMinValue = Low[endIndex];
      
   if (endMinValue > Low[i])
   {
      endMinValue = Low[i];
      EndMin = Time[i];

      SetExtremum(Low[i], DN, EndMin);
   }
   else 
   {  
      double startMinValue = Low[startIndex];
      double startMaxValue = High[iBarShift(symbol, 0, StartMax)];
      
      double nowMinValue = endMinValue;
      if (startIndex - endIndex != 0)
      {
         nowMinValue += (endMinValue - startMinValue)/(startIndex - endIndex)*(endIndex - i);
      }

      double nowMaxValue = High[i];
      
      if (nowMaxValue - nowMinValue > ChannelWidth*Point)
      {
         if (EndMin != i)
         {
            EndMax = Time[i];
            StartMax = Time[i];
            Direction = UP;

            SetExtremum(High[i], UP, EndMax);
         }
      }
   }
}

void DrawChannel(int i)
{
   switch (Direction)
   {
      case UP: 
         DrawUp(i);
         break;
      case DN: 
         DrawDn(i);
         break;
   }
}

void DrawUp(int i)
{
   int startIdx = iBarShift(symbol, 0, StartMax);
   int endIdx = iBarShift(symbol, 0, EndMax);
   
   if (startIdx == i) 
   {
      UpChannel[i] = High[i];
      DnChannel[i] = UpChannel[i] - ChannelWidth*Point;
      return;
   }
   
   if (startIdx - i > 1)
   {
      UpChannel[i + 1] = EMPTY_VALUE;
      DnChannel[i + 1] = EMPTY_VALUE;
   }
   
   if (startIdx == endIdx)
   {
      UpChannel[i] = UpChannel[startIdx];
      DnChannel[i] = DnChannel[startIdx];
      
      return;
   }
   
   double upValue = 
      High[startIdx] + (High[endIdx] - High[startIdx])/(endIdx - startIdx)*(i - startIdx);

   UpChannel[i] = upValue;
   DnChannel[i] = UpChannel[i] - ChannelWidth*Point;
}

void DrawDn(int i)
{
   int startIdx = iBarShift(symbol, 0, StartMin);
   int endIdx = iBarShift(symbol, 0, EndMin);
   
   if (startIdx == i)
   {
      UpChannel[i] = Low[i];
      DnChannel[i] = UpChannel[i] + ChannelWidth*Point;
      return;
   }
   
   if (startIdx - i > 1)
   {
      UpChannel[i + 1] = EMPTY_VALUE;
      DnChannel[i + 1] = EMPTY_VALUE;
   }
   
   if (startIdx == endIdx)
   {
      UpChannel[i] = UpChannel[startIdx];
      DnChannel[i] = DnChannel[startIdx];
      
      return;
   }
   
   double dnValue = 
      Low[startIdx] + (Low[endIdx] - Low[startIdx])/(endIdx - startIdx)*(i - startIdx);

   UpChannel[i] = dnValue;
   DnChannel[i] = UpChannel[i] + ChannelWidth*Point;
}