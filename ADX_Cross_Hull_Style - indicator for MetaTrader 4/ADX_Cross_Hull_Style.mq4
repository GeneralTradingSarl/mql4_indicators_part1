//+------------------------------------------------------------------+
//|                                         ADX_Cross_Hull_Style.mq4 |
//+------------------------------------------------------------------+
//----
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Green
//----
extern int PlusDiMinusDi_Period=14;
extern int Applied_Price      =0; // 0 Close , 1 Open , 2 High , 3 Low , 4 Median , 5 Typical , 6 Weighted
extern int LineWidth          =0;
extern int ShowBars           =1000;
//----
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double b4plusdi, b4minusdi, nowplusdi, nowminusdi;
int    nShift;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexEmptyValue(0,0.00000000);
   SetIndexStyle(0, DRAW_ARROW, STYLE_SOLID, LineWidth);
   SetIndexArrow(0, 225);
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexLabel(0, "ADX Up mode 0");
   //
   SetIndexEmptyValue(1,0.00000000);
   SetIndexStyle(1, DRAW_ARROW, STYLE_SOLID, LineWidth);
   SetIndexArrow(1, 226);
   SetIndexBuffer(1, ExtMapBuffer2);
   SetIndexLabel(1, "ADX Dn mode 1");
   //
   IndicatorShortName("ADX_Cross_Hull_Style(" + PlusDiMinusDi_Period + ")");
   switch(Period())
     {
      case     1: nShift=1;   break;
      case     5: nShift=3;   break;
      case    15: nShift=5;   break;
      case    30: nShift=10;  break;
      case    60: nShift=15;  break;
      case   240: nShift=20;  break;
      case  1440: nShift=80;  break;
      case 10080: nShift=100; break;
      case 43200: nShift=200; break;
     }
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int limit,i;
   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)
      return(-1);
   if(counted_bars > 0)
      counted_bars--;
//----      
   limit=ShowBars;
//----   
   if (limit>=Bars) limit=Bars - PlusDiMinusDi_Period;
   for(i=0; i<limit; i++)
     {
      b4plusdi=(iADX(Symbol(),0,MathFloor(PlusDiMinusDi_Period/2),Applied_Price,MODE_PLUSDI,i+1)*2)
      - iADX(Symbol(),0,PlusDiMinusDi_Period,Applied_Price,MODE_PLUSDI,i+1);
      nowplusdi=(iADX(Symbol(),0,MathFloor(PlusDiMinusDi_Period/2),Applied_Price,MODE_PLUSDI,i)*2)
      - iADX(Symbol(),0,PlusDiMinusDi_Period,Applied_Price,MODE_PLUSDI,i);
      b4minusdi=(iADX(Symbol(),0,MathFloor(PlusDiMinusDi_Period/2),Applied_Price,MODE_MINUSDI,i+1)*2)
      - iADX(Symbol(),0,PlusDiMinusDi_Period,Applied_Price,MODE_MINUSDI,i+1);
      nowminusdi=(iADX(Symbol(),0,MathFloor(PlusDiMinusDi_Period/2),Applied_Price,MODE_MINUSDI,i)*2)
      - iADX(Symbol(),0,PlusDiMinusDi_Period,Applied_Price,MODE_MINUSDI,i);
      if (b4plusdi < b4minusdi && nowplusdi > nowminusdi) { ExtMapBuffer1[i]=Low[i]  - nShift*Point; } else { ExtMapBuffer1[i]=0.00000000; }
      if (b4plusdi > b4minusdi && nowplusdi < nowminusdi) { ExtMapBuffer2[i]=High[i] + nShift*Point; } else { ExtMapBuffer2[i]=0.00000000; }
     }
   return(0);
  }
//+------------------------------------------------------------------+