//+------------------------------------------------------------------+
//|                                               EMA_Prediction.mq4 |
//|                                                       Codersguru |
//|                                         http://www.forex-tsd.com |
//+------------------------------------------------------------------+
#property copyright "Codersguru"
#property link      "http://www.forex-tsd.com"
//----
extern int ShortEma=1;
extern int LongEma=2;
extern bool Draw_Lines=false;
//----
#property indicator_buffers 4
#property indicator_chart_window
#property indicator_color1 Blue
#property indicator_color2 Red
#property indicator_color3 Blue
#property indicator_color4 Red
//----
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double Signal1=0,Signal2=0;
int Previous_Bar=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(4);
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(0,234);
   SetIndexArrow(1,233);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_LINE,STYLE_SOLID,2);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexStyle(3,DRAW_LINE,STYLE_SOLID,2);
   SetIndexBuffer(3,ExtMapBuffer4);
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int pos=Bars-counted_bars;
   if(counted_bars==0) pos-=1+MathMax(LongEma,ShortEma);
//----   
   while(pos>0)
     {
      Signal1=0;
      Signal2=0;
      Previous_Bar=0;
      //----
      double EmaLongPrevious=iMA(NULL,0,LongEma,0,MODE_EMA,PRICE_CLOSE,pos-1);
      double EmaLongCurrent=iMA(NULL,0,LongEma,0,MODE_EMA,PRICE_CLOSE,pos);
      double EmaShortPrevious=iMA(NULL,0,ShortEma,0,MODE_EMA,PRICE_CLOSE,pos-1);
      double EmaShortCurrent=iMA(NULL,0,ShortEma,0,MODE_EMA,PRICE_CLOSE,pos);
      //----
      if(Open[pos] > Close[pos]) Previous_Bar=1;
      if(Open[pos] < Close[pos]) Previous_Bar=2;
      if(EmaShortPrevious<EmaLongPrevious && EmaShortCurrent>EmaLongCurrent && Previous_Bar==1)Signal1=High[pos];
      if(EmaShortPrevious>EmaLongPrevious && EmaShortCurrent<EmaLongCurrent && Previous_Bar==2)Signal2=Low[pos];
      //----
      ExtMapBuffer1[pos-1]= Signal1+5*Point;
      ExtMapBuffer2[pos-1]=Signal2-5*Point;
      if(Draw_Lines)
        {
         ExtMapBuffer3[pos]= EmaLongCurrent;
         ExtMapBuffer4[pos]= EmaShortCurrent;
        }
      pos--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
