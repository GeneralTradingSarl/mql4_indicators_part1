//+------------------------------------------------------------------+
//|                                                 CandlesticksBW.mq4 |
//|                                                         Vladimir |
//|                                         finance@allmotion.com.ua |
//+------------------------------------------------------------------+
// Раскраска свечей по Вильямсу
#property copyright "Vladimir"
#property link      "finance@allmotion.com.ua"
//----
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 LimeGreen
#property indicator_color2 OrangeRed
#property indicator_color3 LimeGreen
#property indicator_color4 OrangeRed
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
//----
int ExtCountedBars=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM,0,1,LimeGreen);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_HISTOGRAM,0,1,OrangeRed);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_HISTOGRAM,0,2,LimeGreen);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexStyle(3,DRAW_HISTOGRAM,0,2,OrangeRed);
   SetIndexBuffer(3,ExtMapBuffer4);
//----
   //   SetIndexDrawBegin(0,10);
   //   SetIndexDrawBegin(1,10);
   //   SetIndexDrawBegin(2,10);
   //   SetIndexDrawBegin(3,10);
//---- indicator buffers mapping
   //   SetIndexBuffer(0,ExtMapBuffer1);
   //   SetIndexBuffer(1,ExtMapBuffer2);
   //   SetIndexBuffer(2,ExtMapBuffer3);
   //   SetIndexBuffer(3,ExtMapBuffer4);
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- TODO: add your code here

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   if(Bars<=10) return(0);
   ExtCountedBars=IndicatorCounted();
//---- check for possible errors
   if (ExtCountedBars<0) return(-1);
//---- last counted bar will be recounted
   if (ExtCountedBars>0) ExtCountedBars--;
   int pos=Bars-ExtCountedBars-1;
//----   
   while(pos>=0)
     {
      if (iAO(NULL,0,pos)>=iAO(NULL,0,pos+1) && iAC(NULL,0,pos)>=iAC(NULL,0,pos+1))
        {
         ExtMapBuffer1[pos]=High[pos];
         ExtMapBuffer2[pos]=Low[pos];
         if (Open[pos]>=Close[pos])
         { ExtMapBuffer3[pos]=Open[pos]; ExtMapBuffer4[pos]=Close[pos]; }
         else // if (Open[pos]<=Close[pos]) 
         { ExtMapBuffer3[pos]=Close[pos]; ExtMapBuffer4[pos]=Open[pos]; }
        }
      else
        {
         if (iAO(NULL,0,pos)<=iAO(NULL,0,pos+1) && iAC(NULL,0,pos)<=iAC(NULL,0,pos+1))
           {
            ExtMapBuffer1[pos]=Low[pos];
            ExtMapBuffer2[pos]=High[pos];
            if (Open[pos]<=Close[pos])
            { ExtMapBuffer3[pos]=Open[pos]; ExtMapBuffer4[pos]=Close[pos]; }
            else // if (Open[pos]>=Close[pos]) 
            { ExtMapBuffer3[pos]=Close[pos]; ExtMapBuffer4[pos]=Open[pos]; }
           }
         else
           {
            ExtMapBuffer1[pos]=EMPTY_VALUE;
            ExtMapBuffer2[pos]=EMPTY_VALUE;
            ExtMapBuffer3[pos]=EMPTY_VALUE;
            ExtMapBuffer4[pos]=EMPTY_VALUE;
           }
        }
      //         if (Open[pos]>=Close[pos]) 
      //            { ExtMapBuffer3[pos]=Open[pos]; ExtMapBuffer4[pos]=Close[pos]; }
      //         else // if (Open[pos]<=Close[pos]) 
      //            { ExtMapBuffer3[pos]=Close[pos]; ExtMapBuffer4[pos]=Open[pos]; };         
      pos--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+