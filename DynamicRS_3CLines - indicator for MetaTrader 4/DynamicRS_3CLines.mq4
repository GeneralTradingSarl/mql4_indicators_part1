//+------------------------------------------------------------------+
//|                                            DynamicRS_3CLines.mq4 |
//|                                 Copyright © 2007, Nick A. Zhilin |
//|                                                  rebus58@mail.ru |
//+------------------------------------------------------------------+

#property copyright "Copyright © 2007, Nick A. Zhilin"
#property link      "rebus58@mail.ru"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Yellow
#property indicator_color2 Aqua
#property indicator_color3 Red

//---- buffers
double ExtMapBuffer1[];
double TopLine[];
double BottomnLine[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorShortName("DynamicRS_3CLines");
//---- indicators
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,2);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,TopLine);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,BottomnLine);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| DynamicRS                                                        |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int i=Bars-counted_bars;
   if(counted_bars==0) i-=1+1;

   while(i>=0)
     {
      if(High[i]<High[i+1] && High[i]<ExtMapBuffer1[i+1])
        {
         ExtMapBuffer1[i]=High[i];
         BottomnLine[i]=High[i];
         TopLine[i]=TopLine[i+1];
        }
      else if(Low[i]>Low[i+1] && Low[i]>ExtMapBuffer1[i+1])
        {
         ExtMapBuffer1[i]=Low[i];
         TopLine[i]=Low[i];
         BottomnLine[i]=BottomnLine[i+1];
        }
      else
        {
         ExtMapBuffer1[i]=ExtMapBuffer1[i+1];
         if(ExtMapBuffer1[i+1]==TopLine[i+1])
           {
            TopLine[i]=ExtMapBuffer1[i+1];
            BottomnLine[i]=BottomnLine[i+1];
           }
         else if(ExtMapBuffer1[i+1]==BottomnLine[i+1])
           {
            BottomnLine[i]=ExtMapBuffer1[i+1];
            TopLine[i]=TopLine[i+1];
           }
        }
      i--;
     }

//----
   return(0);
  }
//+------------------------------------------------------------------+
