//+------------------------------------------------------------------+
//|                                                        Vegas.mq4 |
//|                                                           Mr.Bah |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Mr.Bah"
#property link      ""
//----
#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 clrGreen
#property indicator_color2 clrBlue
#property indicator_color3 clrRed
#property indicator_color4 clrRed
#property indicator_color5 clrRed
#property indicator_color6 clrRed
#property indicator_color7 clrRed
#property indicator_color8 clrRed
//---- input parameters
extern bool      Alerts=true;
extern int       RiskModel=1;
extern int       MA1=144;
extern int       MA2=169;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
double ExtMapBuffer6[];
double ExtMapBuffer7[];
double ExtMapBuffer8[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,ExtMapBuffer4);
   SetIndexStyle(4,DRAW_LINE);
   SetIndexBuffer(4,ExtMapBuffer5);
   SetIndexStyle(5,DRAW_LINE);
   SetIndexBuffer(5,ExtMapBuffer6);
   SetIndexStyle(6,DRAW_LINE);
   SetIndexBuffer(6,ExtMapBuffer7);
   SetIndexStyle(7,DRAW_LINE);
   SetIndexBuffer(7,ExtMapBuffer8);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- 
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int    counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   if(counted_bars==0) limit--;
//---- main loop
   for(int i=0; i<limit; i++)
     {
      //---- ma_shift set to 0 because SetIndexShift called abowe
      ExtMapBuffer1[i]=iMA(NULL,0,144,0,MODE_EMA,PRICE_CLOSE,i);
      ExtMapBuffer2[i]=iMA(NULL,0,169,0,MODE_EMA,PRICE_CLOSE,i);
      //Model #1 34,55,89
      if(RiskModel==1)
        {
         ExtMapBuffer3[i]=ExtMapBuffer2[i]+34*Point;
         ExtMapBuffer4[i]=ExtMapBuffer2[i]+55*Point;
         ExtMapBuffer5[i]=ExtMapBuffer2[i]+89*Point;
         ExtMapBuffer6[i]=ExtMapBuffer2[i]-34*Point;
         ExtMapBuffer7[i]=ExtMapBuffer2[i]-55*Point;
         ExtMapBuffer8[i]=ExtMapBuffer2[i]-89*Point;
        }
      //Model #2 55,89,144
      if(RiskModel==2)
        {
         ExtMapBuffer3[i]=ExtMapBuffer2[i]+55*Point;
         ExtMapBuffer4[i]=ExtMapBuffer2[i]+89*Point;
         ExtMapBuffer5[i]=ExtMapBuffer2[i]+144*Point;
         ExtMapBuffer6[i]=ExtMapBuffer2[i]-55*Point;
         ExtMapBuffer7[i]=ExtMapBuffer2[i]-88*Point;
         ExtMapBuffer8[i]=ExtMapBuffer2[i]-144*Point;
        }
      //Model #3 89,144,233
      if(RiskModel==3)
        {
         ExtMapBuffer3[i]=ExtMapBuffer2[i]+89*Point;
         ExtMapBuffer4[i]=ExtMapBuffer2[i]+144*Point;
         ExtMapBuffer5[i]=ExtMapBuffer2[i]+233*Point;
         ExtMapBuffer6[i]=ExtMapBuffer2[i]-89*Point;
         ExtMapBuffer7[i]=ExtMapBuffer2[i]-144*Point;
         ExtMapBuffer8[i]=ExtMapBuffer2[i]-233*Point;
        }
      //Model #4 144,233,377
      if(RiskModel==4)
        {
         ExtMapBuffer3[i]=ExtMapBuffer2[i]+144*Point;
         ExtMapBuffer4[i]=ExtMapBuffer2[i]+233*Point;
         ExtMapBuffer5[i]=ExtMapBuffer2[i]+377*Point;
         ExtMapBuffer6[i]=ExtMapBuffer2[i]-144*Point;
         ExtMapBuffer7[i]=ExtMapBuffer2[i]-233*Point;
         ExtMapBuffer8[i]=ExtMapBuffer2[i]-377*Point;
        }
      Comment("\nRISK MODEL #",RiskModel," (1-4)\n\nEMA144 - ",ExtMapBuffer1[limit],"\nEMA169 - ",ExtMapBuffer2[limit],
      "\n\nF+1 - ",ExtMapBuffer3[limit],"\nF+2 - ",ExtMapBuffer4[limit],
      "\nF+3 - ",ExtMapBuffer5[limit],"\n\nF-1 - ",ExtMapBuffer6[limit],
      "\nF-2 - ",ExtMapBuffer7[limit],"\nF-3 - ",ExtMapBuffer8[limit]);
     }
   //+--------------------------------------------------------------------------+
   //|                          ALERTS    PlaySound("alert.wav");               |
   //+--------------------------------------------------------------------------+
   if(Alerts)
     {
      if(Close[i]==ExtMapBuffer1[i] || Close[i]==ExtMapBuffer2[i])
        {
         PlaySound("alert.wav");
         Alert("Fib or Channel signal triggered for "+Symbol()+" on the "+Period()+" minute chart.");
        }
      if(Close[i]==ExtMapBuffer3[i] || Close[i]==ExtMapBuffer4[i] || Close[i]==ExtMapBuffer5[i])
        {
         PlaySound("alert.wav");
         Alert("Fib or Channel signal triggered for "+Symbol()+" on the "+Period()+" minute chart.");
        }
      if(Close[i]==ExtMapBuffer6[i] || Close[i]==ExtMapBuffer7[i] || Close[i]==ExtMapBuffer8[i])
        {
         PlaySound("alert.wav");
         Alert("Fib or Channel signal triggered for "+Symbol()+" on the "+Period()+" minute chart.");
        }
     }
//---- done
//---- 
//----
   return(0);
  }
//+------------------------------------------------------------------+