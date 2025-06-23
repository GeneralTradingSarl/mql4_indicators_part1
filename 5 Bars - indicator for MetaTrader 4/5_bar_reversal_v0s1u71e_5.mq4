//+------------------------------------------------------------------+
//|                                                       5 Bars.mq4 |
//|                      Copyright © 2006, EvgeniX                   |
//|                                        
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, EvgeniX"
#property link      "EvgeniX"
//----
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_width1 3
#property indicator_color2 Yellow
#property indicator_width2 3
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double fhigh;
double flow;
double fclose;
double shigh;
double slow;
double sclose;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_ARROW,4);
   SetIndexArrow(0,218);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexEmptyValue(0,0.0);
   SetIndexStyle(1,DRAW_ARROW,4);
   SetIndexArrow(1,217);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexEmptyValue(1,0.0);
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
   int    counted_bars=IndicatorCounted();
//---- 
   for(int i=1  ;i<=500;i++)
     {
      Comment (i);
      shigh=High[Highest(NULL, 0,2,5,i)];
      slow=Low[Lowest(NULL,0,1,5,i)];
      sclose=Close[i];
      fhigh=High[Highest(NULL, 0, 2, 5, (i+5))];
      flow=Low[Lowest(NULL,0,1,5,(i+5))];
      fclose=Close[i+9];
      //ExtMapBuffer2[i+5]=High[i]+0.0005;
      //ExtMapBuffer1[i]=High[i]+0.0005;
      if ((shigh>fhigh) && (sclose<flow))
        {
         ExtMapBuffer1[i+5]=High[i+5]+0.0005;
         // if (i==500)Alert ("5Bar Reverse  S E L L ", Symbol()," M",Period());
        }
      if ((slow<flow) && (sclose>fhigh))
        {
         ExtMapBuffer2[i+5]=Low[i+5]-0.0005;
         //  if (i==500) Alert ("5Bar Reverse  B U Y ", Symbol()," M",Period());
        }
      //     Comment(Close[i+4]+" "+" "+DoubleToStr(i,1)+"  "+TimeToStr(Time[i],TIME_MINUTES)+
      //     "\n"+" "+shigh+" "+slow+" "+sclose+
      //     "\n"+" "+fhigh+" "+flow+" "+fclose);
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+