//+------------------------------------------------------------------+
//|    AvgRangeM                                        AvgRange.mq4 |
//|                 Copyright © 2005, tageiger aka fxid10t@yahoo.com |
//| /www.forex-tsd.com                     http://www.metatrader.org |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, tageiger aka fxid10t@yahoo.com"
#property link    "http://www.metatrader.org http://www.forex-tsd.com"
//----
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Yellow
#property indicator_color2 SpringGreen
#property indicator_color3 Tomato
#property indicator_style1 2
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double rng,sum_rng,avg_rng;
double rng1,sum_rng1,avg_rng1;
double rng2,sum_rng2,avg_rng2;
double rng3,sum_rng3,avg_rng3;
//+------------------------------------------------------------------+
//|                                                                  |
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
//----
  return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  int deinit()   
  {
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  int start()
  {
   int    counted_bars=IndicatorCounted();
   rng=0;sum_rng=0;avg_rng=0;
   rng1=0;sum_rng1=0;avg_rng1=0;
   rng2=0;sum_rng2=0;avg_rng2=0;
   rng3=0;sum_rng3=0;avg_rng3=0;
//----
   for(int i=0;i<Bars;i++)
     {
      rng=(iHigh(Symbol(),Period(),i)-iLow(Symbol(),Period(),i));
      sum_rng+=rng;
      rng1=(iHigh(Symbol(),60,i)-iLow(Symbol(),60,i));
      sum_rng1+=rng1;
      rng2=(iHigh(Symbol(),240,i)-iLow(Symbol(),240,i));
      sum_rng2+=rng2;
      rng3=(iHigh(Symbol(),1440,i)-iLow(Symbol(),1440,i));
      sum_rng3+=rng3;
     }
   int db=iBars(Symbol(),Period());
   avg_rng=sum_rng/db;
   int db1=iBars(Symbol(),60);
   avg_rng1=sum_rng1/db1;
   int db2=iBars(Symbol(),240);
   avg_rng2=sum_rng2/db2;
   int db3=iBars(Symbol(),1440);
   avg_rng3=sum_rng3/db3;
//----
   for(int s=0;s<Bars;s++)
     {
      ExtMapBuffer1[s]=(iOpen(Symbol(),Period(),s));
      ExtMapBuffer2[s]=(iOpen(Symbol(),Period(),s)+(avg_rng/2));
      ExtMapBuffer3[s]=(iOpen(Symbol(),Period(),s)-(avg_rng/2));
     }
   Comment("Last Tick: ",TimeToStr(CurTime(),TIME_DATE|TIME_SECONDS),"\n",
 // "Sum of Period Ranges:",sum_rng,"\n",
 // "Average Range:",avg_rng,"\n",
           "D1", " Average Range: ",avg_rng3,"\n",
           "H4", " Avgrage Range: ",avg_rng2,"\n",
           "H1", " Average Range: ",avg_rng1," \n",
           "TF", Period()," Average Range: ",avg_rng," ");
 // "Total Bars:",i+1  );
   return(0);
  }
//+------------------------------------------------------------------+