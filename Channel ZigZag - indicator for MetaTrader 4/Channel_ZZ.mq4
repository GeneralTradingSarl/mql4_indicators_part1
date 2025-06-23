//+------------------------------------------------------------------+
//|                                                   Channel ZZ.mq4 |
//|                                       Copyright © 2008, Tinytjan |
//|                                                 tinytjan@mail.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, Tinytjan"
#property link      "tinytjan@mail.ru"

extern string _1 = "Период сглаживания экстремумов, для фильтрования всплесков";
extern int SmoothPeriod = 1;
extern string _2 = "Ширина канала, в пунктах";
extern int ChannelWidth = 150;
extern string _3 = "Размер шрифта текста";
extern int FontSize = 10;
extern string _4 = "Название шрифта";
extern string FontName = "Arial Black";
extern string _5 = "Если false конкретно ускоряет работу индикатора";
extern bool DrawChannel = true;

#property indicator_chart_window
#property indicator_buffers 3

#property indicator_color1 LightGray
#property indicator_width1 3

#property indicator_color2 Orange
#property indicator_color3 Orange

//---- buffers
double ZZ[];
double UpChannel[];
double DownChannel[];

double SmoothedMaxValues[];
double SmoothedMinValues[];

string symbol;

#define UP 1
#define DN -1
#define NONE 0

int Direction;

datetime StartMax;
datetime EndMax;
datetime StartMin;
datetime EndMin;

// ZZ variables
datetime StartDraw;
datetime EndDraw;
double StartDrawValue;
double EndDrawValue;

// Channel Variables
datetime StartChannel;
datetime EndChannel;
double StartChannelValue;
double EndChannelValue;

// ObjectVariables
int Counter;
int Length;
int LastLength;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   IndicatorShortName("-=<Channel ZZ>=-");

   IndicatorBuffers(5);
   
   SetIndexBuffer(0, ZZ);
   SetIndexBuffer(1, UpChannel);
   SetIndexBuffer(2, DownChannel);
   SetIndexBuffer(3, SmoothedMaxValues);
   SetIndexBuffer(4, SmoothedMinValues);
   
   SetIndexStyle(0, DRAW_LINE);
   SetIndexStyle(1, DRAW_LINE, STYLE_DASH);
   SetIndexStyle(2, DRAW_LINE, STYLE_DASH);
   
   symbol = Symbol();
   
   Direction = NONE;
   Counter = 0;

   StartMax = 0;
   EndMax = 0;
   StartMin = 0;
   EndMin = 0;
   
   Length = 0;
   LastLength = EMPTY_VALUE;

   return(0);
}

int deinit()
{
   for (int i = 0; i <= Counter; i++)
   {
      ObjectDelete("Stats" + i);
   }
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   int ToCount = Bars - IndicatorCounted();
   
   for (int i = ToCount - 1; i >= 0; i--)
   {
      SmoothedMaxValues[i] = iMA(symbol, 0, SmoothPeriod, 0, MODE_EMA, PRICE_HIGH, i);
      SmoothedMinValues[i] = iMA(symbol, 0, SmoothPeriod, 0, MODE_EMA, PRICE_LOW, i);
      
      RePaintChannels(i);
      
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
   }
   return(0);
}
//+------------------------------------------------------------------+

void CheckInit(int offset)
{
   if (StartMax == 0 || StartMin == 0)
   {
      if (StartMax == 0) StartMax = Time[offset];
      if (StartMin == 0) StartMin = Time[offset];
      
      return;
   }
   
   if (Direction == NONE)
   {
      double maxValue = SmoothedMaxValues[iBarShift(symbol, 0, StartMax)];
      double minValue = SmoothedMinValues[iBarShift(symbol, 0, StartMin)];
      
      double nowMax = SmoothedMaxValues[offset];
      double nowMin = SmoothedMaxValues[offset];
      
      if (nowMax > maxValue && Time[offset] > StartMax)
      {
         // Logic
         EndMax = Time[offset];
         StartMin = Time[offset];
         Direction = UP;
         
         // Drawing
         StartDraw = StartMax;
         EndDraw = EndMax;
         StartDrawValue = maxValue;
         EndDrawValue = nowMax;
         
         StartChannel = StartMax;
         EndChannel = EndMax;
         StartChannelValue = maxValue;
         EndChannelValue = nowMax;
         
         Length = NormalizeDouble((nowMax - maxValue)/Point, 0);
         
         RePaint();
      }
      else if (nowMin > minValue && Time[offset] > StartMin)
      {
         // Logic
         EndMin = Time[offset];
         StartMax = Time[offset];
         Direction = DN;

         // Drawing
         StartDraw = StartMin;
         EndDraw = EndMin;
         StartDrawValue = minValue;
         EndDrawValue = nowMin;

         StartChannel = StartMin;
         EndChannel = EndMin;
         StartChannelValue = minValue;
         EndChannelValue = nowMin;

         Length = NormalizeDouble((minValue - nowMin)/Point, 0);

         RePaint();
      }
   }
}

void CheckUp(int offset)
{
   int startIndex = iBarShift(symbol, 0, StartMax);
   int endIndex = iBarShift(symbol, 0, EndMax);

   double endMaxValue = SmoothedMaxValues[endIndex];
      
   if (endMaxValue < SmoothedMaxValues[offset])
   {
      // Logic
      endMaxValue = SmoothedMaxValues[offset];
      EndMax = Time[offset];

      // Drawing
      EndDraw = EndMax;
      EndDrawValue = endMaxValue;

      EndChannel = EndMax;
      EndChannelValue = endMaxValue;
      
      double endMinValue = SmoothedMinValues[iBarShift(symbol, 0, EndMin)];
      Length = NormalizeDouble((endMaxValue - endMinValue)/Point, 0);

      RePaint();
   }
   else 
   {  
      double startMaxValue = SmoothedMaxValues[startIndex];
      double startMinValue = SmoothedMinValues[iBarShift(symbol, 0, StartMin)];
      
      double nowMaxValue = endMaxValue;
      if (startIndex - endIndex != 0)
      {
         nowMaxValue += (endMaxValue - startMaxValue)/(startIndex - endIndex)*(endIndex - offset);
      }

      double nowMinValue = SmoothedMinValues[offset];
      
      if (nowMaxValue - nowMinValue > ChannelWidth*Point)
      {
         if (EndMax != offset)
         {
            StartMin = Time[offset];
            EndMin = Time[offset];
            Direction = DN;

            // Drawing
            StartDraw = EndMax;
            EndDraw = EndMin;
            StartDrawValue = endMaxValue;
            EndDrawValue = nowMinValue;

            StartChannel = EndMin;
            EndChannel = EndMin;
            StartChannelValue = nowMinValue;
            EndChannelValue = nowMinValue;

            Counter++;

            LastLength = Length;
            Length = NormalizeDouble((endMaxValue - nowMinValue)/Point, 0);

            RePaint();
         }
      }
   }
}

void CheckDown(int offset)
{
   int startIndex = iBarShift(symbol, 0, StartMin);
   int endIndex = iBarShift(symbol, 0, EndMin);

   double endMinValue = SmoothedMinValues[endIndex];
      
   if (endMinValue > SmoothedMinValues[offset])
   {
      endMinValue = SmoothedMinValues[offset];
      EndMin = Time[offset];

      // Drawing
      EndDraw = EndMin;
      EndDrawValue = endMinValue;

      EndChannel = EndMin;
      EndChannelValue = endMinValue;

      double endMaxValue = SmoothedMaxValues[iBarShift(symbol, 0, EndMax)];
      Length = NormalizeDouble((endMaxValue - endMinValue)/Point, 0);

      RePaint();
   }
   else 
   {  
      double startMinValue = SmoothedMinValues[startIndex];
      double startMaxValue = SmoothedMaxValues[iBarShift(symbol, 0, StartMax)];
      
      double nowMinValue = endMinValue;
      if (startIndex - endIndex != 0)
      {
         nowMinValue += (endMinValue - startMinValue)/(startIndex - endIndex)*(endIndex - offset);
      }

      double nowMaxValue = SmoothedMaxValues[offset];
      
      if (nowMaxValue - nowMinValue > ChannelWidth*Point)
      {
         if (EndMin != offset)
         {
            EndMax = Time[offset];
            StartMax = Time[offset];
            Direction = UP;

            // Drawing
            StartDraw = EndMin;
            EndDraw = EndMax;
            StartDrawValue = endMinValue;
            EndDrawValue = nowMaxValue;

            StartChannel = EndMax;
            EndChannel = EndMax;
            StartChannelValue = nowMaxValue;
            EndChannelValue = nowMaxValue;

            Counter++;

            LastLength = Length;
            Length = NormalizeDouble((nowMaxValue - endMinValue)/Point, 0);

            RePaint();
         }
      }
   }
}

void RePaint()
{
   double pos = EndDrawValue;
   if (Direction == UP) pos += 15*Point;
   
   string id = "Stats" + Counter;
   
   string text;
   if (LastLength != 0)
      text = text + DoubleToStr((0.0001 + Length)/(0.0001 + LastLength), 2);
   text = text + "(" + Length + ")";
   
   if (ObjectFind(id) == -1)
   {
      ObjectCreate(id, OBJ_TEXT, 0, EndDraw, pos);
      ObjectSet(id, OBJPROP_COLOR, Yellow);
   }

   ObjectMove(id, 0, EndDraw, pos);
   ObjectSetText(id, text, FontSize, FontName);

   int start = iBarShift(symbol, 0, StartDraw);
   int end = iBarShift(symbol, 0, EndDraw);
   
   if (start == end)
   {
      ZZ[end] = EndDrawValue;
      return;
   }
   
   double preValue = (EndDrawValue - StartDrawValue)/(end - start);
   
   for (int i = start; i >= end; i--)
   {
      ZZ[i] = StartDrawValue + preValue*(i - start);
   }
}

void RePaintChannels(int offset)
{
   if (Direction == NONE) return;
   if (!DrawChannel) return;
   
   int start = iBarShift(symbol, 0, StartChannel);
   int end = iBarShift(symbol, 0, EndChannel);
   
   if (start == end)
   {
      if (Direction == UP)
      {
         UpChannel[start] = StartChannelValue;
         DownChannel[start] = StartChannelValue - ChannelWidth*Point;
      }
      else
      {
         DownChannel[start] = StartChannelValue;
         UpChannel[start] = StartChannelValue + ChannelWidth*Point;
      }
      
      for(int i = start - 1; i >= offset; i--)
      {
         DownChannel[i] = DownChannel[i + 1];
         UpChannel[i] = UpChannel[i + 1];
      }
      return;
   }
   
   double preValue = (EndChannelValue - StartChannelValue)/(end - start);

   if (Direction == UP)
   {
      for (i = start - 1; i >= offset; i--)
      {
         UpChannel[i] = StartChannelValue + preValue*(i - start);
         DownChannel[i] = UpChannel[i] - ChannelWidth*Point;
      }
   }
   else if (Direction == DN)
   {
      for (i = start; i >= offset; i--)
      {
         DownChannel[i] = StartChannelValue + preValue*(i - start);
         UpChannel[i] = DownChannel[i] + ChannelWidth*Point;
      }
   }
}