//+------------------------------------------------------------------+
//|                                             Expected Volumes.mq4 |
//|                                     Copyright © 2007, Amir Aliev |
//|                                       http://finmat.blogspot.com |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2007, Amir Aliev"
#property  link      "http://finmat.blogspot.com"
//----
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 clrBlue
//---- input parameters
extern int hist_steps=100;      // Number of observations
extern int span=1;              // Days to step back each time 
//---- buffers
double ExtMapBuffer1[];
int sum;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- indicators
   SetIndexStyle(0, DRAW_HISTOGRAM);
   SetIndexBuffer(0,ExtMapBuffer1);
//----
   short_name="Expected volumes(" + hist_steps + ")";
   IndicatorShortName(short_name);
   SetIndexLabel(0, short_name);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   int rest=Bars - counted_bars;
   if(counted_bars==0) rest--;
   int j, k, u;
//----   
   while(rest>=0)
     {
      if(Bars - rest < span * 23 * hist_steps)
        {
         ExtMapBuffer1[rest]=0;
         rest--;
         continue;
        }
      sum=0;
      j=0;
      k=0;
      u=0;
      while(j < hist_steps && k < Bars)
        {
        if((rest+k)>=Bars) break;
         if(TimeHour(Time[rest+k])==TimeHour(Time[rest]))
           {
            u++;
            if(u==span)
              {
               u=0;
               j++;
               sum+=Volume[rest + k];
              }
            k+=23;
           }
         k++;
        }
      ExtMapBuffer1[rest]=sum/hist_steps;
      rest--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+