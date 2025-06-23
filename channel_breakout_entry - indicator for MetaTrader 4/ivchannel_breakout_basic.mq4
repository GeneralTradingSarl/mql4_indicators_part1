//+------------------------------------------------------------------+
//|                                       channel_breakout_entry.mq4 | 
//|                                   with ATR Stop Loss calculation |
//|                                 use this one for drawing channel |
//|                             and the place for placing initial SL |
//|                            as described the turtle trading rules |
//+------------------------------------------------------------------+
#property copyright "darmasdt"
#property link      "http://indotraders.org"
//----
#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 DarkGray
#property indicator_color2 DarkGray
#property indicator_color3 DodgerBlue
#property indicator_color4 DodgerBlue
#property indicator_color5 Tomato
#property indicator_color6 Tomato
#property indicator_color7 LightSkyBlue
#property indicator_color8 Plum
//---- input parameters 
extern int Range1=10;
extern int Range2=20;
extern int Range3=55;
extern double atr_factor=2;
extern int atr_range=14;
//---- buffers
double UpBuffer1[];
double DnBuffer1[];
double UpBuffer2[];
double DnBuffer2[];
double UpBuffer3[];
double DnBuffer3[];
double atr_b2[];
double atr_b3[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- indicator line
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,1);
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,1);
   SetIndexStyle(2,DRAW_LINE,STYLE_SOLID,1);
   SetIndexStyle(3,DRAW_LINE,STYLE_SOLID,1);
   SetIndexStyle(4,DRAW_LINE,STYLE_SOLID,1);
   SetIndexStyle(5,DRAW_LINE,STYLE_SOLID,1);
//SetIndexStyle(6,DRAW_ARROW,STYLE_DOT,1);
   SetIndexStyle(6,DRAW_ARROW);
   SetIndexArrow(6,249);
//SetIndexStyle(7,DRAW_ARROW,STYLE_DOT,1);
   SetIndexStyle(7,DRAW_ARROW);
   SetIndexArrow(7,249);
   SetIndexBuffer(0,UpBuffer1);
   SetIndexBuffer(1,DnBuffer1);
   SetIndexLabel(0,"trailing_Up");
   SetIndexLabel(1,"trailing_Dn");
   SetIndexBuffer(2,UpBuffer2);
   SetIndexBuffer(3,DnBuffer2);
   SetIndexLabel(2,"sys1_Up");
   SetIndexLabel(3,"sys1_Dn");
   SetIndexBuffer(4,UpBuffer3);
   SetIndexBuffer(5,DnBuffer3);
   SetIndexLabel(4,"failsafe_Up");
   SetIndexLabel(5,"failsafe_Dn");
   SetIndexBuffer(6,atr_b2);
   SetIndexBuffer(7,atr_b3);
   SetIndexLabel(6,"Sys 1 Stp");
   SetIndexLabel(7,"Sys 2 Stp");
//---- name for DataWindow and indicator subwindow label
   short_name="CBO_entry("+Range1+","+Range2+","+Range3+")";
   IndicatorShortName(short_name);
//----
   SetIndexDrawBegin(0,0);
   SetIndexDrawBegin(1,0);
   SetIndexDrawBegin(2,0);
   SetIndexDrawBegin(3,0);
   SetIndexDrawBegin(4,0);
   SetIndexDrawBegin(5,0);
   SetIndexDrawBegin(6,0);
   SetIndexDrawBegin(7,0);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Channel Trend System                                             |
//+------------------------------------------------------------------+
int start()
  {
   int i;
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+Range1+1;
//----
   for(i=limit;i>=0;i--)
     {
      //Calculating Channel
      UpBuffer1[i]=High[Highest(NULL,0,MODE_HIGH,Range1,i+1)];
      DnBuffer1[i]=Low[Lowest(NULL,0,MODE_LOW,Range1,i+1)];
      //
      UpBuffer2[i]=High[Highest(NULL,0,MODE_HIGH,Range2,i+1)];
      DnBuffer2[i]=Low[Lowest(NULL,0,MODE_LOW,Range2,i+1)];
      //
      UpBuffer3[i]=High[Highest(NULL,0,MODE_HIGH,Range3,i+1)];
      DnBuffer3[i]=Low[Lowest(NULL,0,MODE_LOW,Range3,i+1)];
      //Calculating ATR Stops 
      if(High[i+1]<=UpBuffer2[i+1] && High[i]>UpBuffer2[i])
        {
         atr_b2[i]=UpBuffer2[i]-(iATR(NULL,0,atr_range,i+1)*atr_factor);
        }
      if(High[i+1]<=UpBuffer3[i+1] && High[i]>UpBuffer3[i])
        {
         atr_b3[i]=UpBuffer3[i]-(iATR(NULL,0,atr_range,i+1)*atr_factor);
        }
      if(Low[i+1]>=DnBuffer2[i+1] && Low[i]<DnBuffer2[i])
        {
         atr_b2[i]=DnBuffer2[i]+(iATR(NULL,0,atr_range,i+1)*atr_factor);
        }
      if(Low[i+1]>=DnBuffer3[i+1] && Low[i]<DnBuffer3[i])
        {
         atr_b3[i]=DnBuffer3[i]+(iATR(NULL,0,atr_range,i+1)*atr_factor);
        }
     }
   return(0);
  }
//+------------------------------------------------------------------+
