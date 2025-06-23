//+------------------------------------------------------------------+
//|                                                                  |
//|                 Copyright © 2000-2007, MetaQuotes Software Corp. |
//|                                         http://www.metaquotes.ru |
//+------------------------------------------------------------------+
// Диапазон.mq4
// Индикатор
#property copyright "mandorr@gmail.com"
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 SkyBlue
#property indicator_color2 SkyBlue
#property indicator_color3 SkyBlue
//----
extern int period=24;        // Период (количество баров диапазона)
extern int CountBars=1000;   // Количество отображаемых баров
//----
double buffer0[];
double buffer1[];
double buffer2[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void init()
  {
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,2);
   SetIndexBuffer(0,buffer0);
   SetIndexLabel(0,"Верхняя граница");
   SetIndexDrawBegin(0,0);
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,2);
   SetIndexBuffer(1,buffer1);
   SetIndexLabel(1,"Нижняя граница");
   SetIndexDrawBegin(1,0);
   SetIndexStyle(2,DRAW_LINE,STYLE_DOT,1);
   SetIndexBuffer(2,buffer2);
   SetIndexLabel(2,"Медиана");
   SetIndexDrawBegin(2,0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void deinit()
  {
   Comment("");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void start()
  {
   for(int i=0;i<=CountBars-1;i++)
     {
      buffer0[i]=High[Highest(NULL,0,MODE_HIGH,period,i)];
      buffer1[i]=Low [Lowest (NULL,0,MODE_LOW ,period,i)];
      buffer2[i]=(buffer0[i]+buffer1[i])/2;
     }
   double range=(buffer0[0]-buffer1[0])/Point;
   Comment("Диапазон: "+DoubleToStr(range,0)+" п.");
  }
//+------------------------------------------------------------------+