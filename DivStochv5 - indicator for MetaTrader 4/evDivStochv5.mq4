//+------------------------------------------------------------------+
//|                                                 #!DivStochv5.mq4 |
//|                                    Copyright @2011, Rockyhoangdn |
//|                                           rockyhoangdn@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright @2011, Rockyhoangdn"
#property link      "rockyhoangdn@gmail.com"
#property indicator_separate_window
#property indicator_buffers 8
#property indicator_color1  DarkGreen
#property indicator_color2  Red
#property indicator_color3  Blue
#property indicator_color4  DeepPink
#property indicator_color5  Yellow
#property indicator_color6  Blue
#property indicator_color7  Red
#property indicator_color8  Lime

#property indicator_width1 3
#property indicator_width2 3
#property indicator_width3 3
#property indicator_width4 3
#property indicator_width5 2
#property indicator_width6 2
#property indicator_width7 3
#property indicator_width8 3
#property indicator_level4 60
#property indicator_level1 70
#property indicator_level2 80
#property indicator_level3 90
#property indicator_levelcolor Gray
 
#property indicator_minimum 50
#property indicator_maximum 100
extern int StochPeriod=20;
extern int Sensitive=5;
double overbought_value=99.9;
double oversold_value=99.9;
double buf[];
double bufinv[];
double mabuf[];
double mabufinv[];
double buf2[];
double overbought[];
double oversold[];
double shortentry[];
double longentry[];
int init()
  {
   SetIndexBuffer(0,buf);
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexLabel(0,"buf");

   SetIndexBuffer(1,bufinv);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexLabel(1,"bufinv");
   
   SetIndexBuffer(2,overbought);
   SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexLabel(2,"Overbought");
   
   SetIndexBuffer(3,oversold);
   SetIndexStyle(3,DRAW_HISTOGRAM);
   SetIndexLabel(3,"Oversold");

   SetIndexBuffer(4,mabuf);
   SetIndexStyle(4,DRAW_LINE);
   SetIndexLabel(4,"Mabuf");

   SetIndexBuffer(5,mabufinv);
   SetIndexStyle(5,DRAW_LINE);
   SetIndexLabel(5,"Mabufinv");
   
   SetIndexBuffer(6,shortentry);
   SetIndexStyle(6,DRAW_ARROW);
   SetIndexArrow(6,252);
   SetIndexLabel(6,"Shortentry");

   SetIndexBuffer(7,longentry);
   SetIndexStyle(7,DRAW_ARROW);
   SetIndexArrow(7,252);
   SetIndexLabel(7,"Longentry");

   IndicatorShortName("Div-Stochv5 - rockyhoangdn@gmail.com");
   return(0);
  }
 
int start()
  {
//   int limit=Bars;

   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+3;
 
   ArrayResize(buf2,limit); 
   ArraySetAsSeries(buf2,true);
   for(int i=0; i<limit; i++)
    {
       buf2[i]=(iStochastic(NULL,0,StochPeriod,3,3,MODE_EMA,1,MODE_MAIN,i)+
                iStochastic(NULL,0,StochPeriod*2.5,3,3,MODE_EMA,1,MODE_MAIN,i)*2.5+
                iStochastic(NULL,0,StochPeriod*5,3,3,MODE_EMA,1,MODE_MAIN,i)*5+
                iStochastic(NULL,0,StochPeriod*10,3,3,MODE_EMA,1,MODE_MAIN,i)*10
       )/18.5;
    }
   for(i=0; i<limit; i++) 
      {
      buf[i]=iMAOnArray(buf2,limit,1,0,MODE_EMA,i);  
      bufinv[i]=100-buf[i];
      if(buf[i] >= overbought_value) overbought[i]=buf[i];
      if(bufinv[i] >= oversold_value) oversold[i]=bufinv[i];
     }

   for(int ii=0; ii<limit; ii++) 
      {
      mabuf[ii]=iMAOnArray(buf,limit,Sensitive,0,MODE_LWMA,ii);  
      mabufinv[ii]=iMAOnArray(bufinv,limit,Sensitive,0,MODE_LWMA,ii);
      }
   for(int iii=0; iii<limit; iii++) 
      {
      if((buf[iii+1] >= overbought_value && buf[iii] <=  mabuf[iii])
          ||(buf[iii+2] >= overbought_value && buf[iii] <=  mabuf[iii])
          ||(buf[iii+3] >= overbought_value && buf[iii] <=  mabuf[iii])
            )   
         {
         shortentry[iii] = buf[iii];
         }
            else shortentry[iii] =0;
            
      if((bufinv[iii+1] >= overbought_value && bufinv[iii] <=  mabufinv[iii])
         ||(bufinv[iii+2] >= overbought_value && bufinv[iii] <=  mabufinv[iii])
         ||(bufinv[iii+3] >= overbought_value && bufinv[iii] <=  mabufinv[iii])
      
      )   
         {
         longentry[iii] = bufinv[iii];
         }
            else longentry[iii] =0;
      }

   return(0);
  }