//+------------------------------------------------------------------+
//|                                                     buy_sell.mq4 |
//|                                                           "pip"  |
//+------------------------------------------------------------------+

#property copyright "pupok"
#property link      "bobik@trah.guchka.eu"

#property indicator_chart_window
#property indicator_color1 Red
#property indicator_color2 Blue
#property indicator_buffers 2

int Range=14;
int ATR=60;
double ExtHistoBuffer[];
double ExtHistoBuffer2[];

//----------------------------------------------------------------+

int init()
{
   SetIndexStyle(0, DRAW_ARROW, STYLE_SOLID);
   SetIndexBuffer(0, ExtHistoBuffer);
   SetIndexStyle(1, DRAW_ARROW, STYLE_SOLID);
   SetIndexBuffer(1, ExtHistoBuffer2);
   SetIndexArrow(1,159);
   SetIndexArrow(0,159);
   return(0);
}

void start()
{
  ExtHistoBuffer[0] = EMPTY_VALUE;
  ExtHistoBuffer2[0] = EMPTY_VALUE;

  int counted = IndicatorCounted();
  if (counted < 0) return (-1);
  
  if (counted > 0) counted--;
  int limit = Bars-counted;
  
  for (int i=limit; i >= 0; i--)
  {
double ma=iMA(NULL,0,Range,0,0,4,i);
double ma1=iMA(NULL,0,Range,0,0,4,i+1);


double dma;
       
     dma=iATR(NULL, 0, ATR, i);
     
    if (ma>ma1) 
      ExtHistoBuffer[i] =ma-dma;

    if (ma<ma1)
      ExtHistoBuffer2[i] =ma+dma ;
  }
}