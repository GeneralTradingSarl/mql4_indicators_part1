//+------------------------------------------------------------------+
//|                                               DoublecciWoody.mq4 |
//|
//+------------------------------------------------------------------+
#property copyright " DoublecciWoody."
#property link      "DoublecciWoody"
//----
#property indicator_separate_window
#property indicator_buffers 7
//----
#property indicator_color1 MediumSeaGreen //Green
#property indicator_color2 Red            //SaddleBrown
#property indicator_color3 DarkGray
#property indicator_color4 Gold
#property indicator_color5 DarkKhaki      //White
#property indicator_color6 White          //Magenta
#property indicator_color7 DarkKhaki      //Gold  <<<<<<<<<<<<<<<<<<<<<<<<<<
//----
#property indicator_level1 350
#property indicator_level2 250
#property indicator_level3 100
#property indicator_level4 0
#property indicator_level5 -100
#property indicator_level6 -250
#property indicator_level7 -350
//#property indicator_level8 -50
//---- input parameters
extern int TrendCCI_Period=14;//14
extern int EntryCCI_Period=6;//6
extern int Trend_period=2;//6
extern int  CountBars=1000;
extern bool Zero_Cross_Alert;
//----
extern int   LineSize1=2;
extern int   LineSize2=3;
extern int   LineSize3=2;//1
//----
double TrendCCI[];
double EntryCCI[];
double CCITrendUp[];
double CCITrendDown[];
double CCINoTrend[];
double CCITimeBar[];
double ZeroLine[];
int trendUp,trendDown;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(4,DRAW_LINE,STYLE_SOLID,LineSize1);
   SetIndexBuffer(4,TrendCCI);
   SetIndexLabel(4,"TrendCCI");
   SetIndexStyle(0,DRAW_HISTOGRAM,0,LineSize1);//2
   SetIndexBuffer(0,CCITrendUp);
   SetIndexStyle(1,DRAW_HISTOGRAM,0,LineSize1);//2
   SetIndexBuffer(1,CCITrendDown);
   SetIndexStyle(2,DRAW_HISTOGRAM,0,LineSize2);
   SetIndexBuffer(2,CCINoTrend);
   SetIndexStyle(3,DRAW_HISTOGRAM,0,LineSize2);
   SetIndexBuffer(3,CCITimeBar);
   SetIndexStyle(5,DRAW_LINE,STYLE_SOLID,LineSize2);// 1 <<<<<<<<<<<<<<<<<<<<<<<<<<<
   SetIndexBuffer(5,EntryCCI);
   SetIndexLabel(5,"EntryCCI");
   SetIndexStyle(6,DRAW_LINE,STYLE_SOLID,LineSize3);
   SetIndexBuffer(6,ZeroLine);
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
   int limit,i,trendCCI,entryCCI;
   static datetime prevtime=0;
//---- check for possible errors
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+MathMax(1,Trend_period);
//----   
   trendCCI=TrendCCI_Period;
   entryCCI=EntryCCI_Period;
   IndicatorShortName("(TrendCCI: "+trendCCI+", EntryCCI: "+entryCCI+") ");

   for(i=limit; i>=0; i--)
     {
      CCINoTrend[i]=0;
      CCITrendDown[i]=0;
      CCITimeBar[i]=0;
      CCITrendUp[i]=0;
      ZeroLine[i]=0;
      TrendCCI[i]=iCCI(NULL, 0, trendCCI, PRICE_TYPICAL, i);
      EntryCCI[i]=iCCI(NULL, 0, entryCCI, PRICE_TYPICAL, i);
      if(TrendCCI[i]>0 && TrendCCI[i+1]<0)
        {
         if(trendDown>Trend_period) trendUp=0;
        }
      if(TrendCCI[i]>0)
        {
         if(trendUp<Trend_period)
           {
            CCINoTrend[i]=TrendCCI[i];
            trendUp++;
           }
         if(trendUp==Trend_period)
           {
            CCITimeBar[i]=TrendCCI[i];
            trendUp++;
           }
         if(trendUp>Trend_period)
           {
            CCITrendUp[i]=TrendCCI[i];
           }
        }
      if(TrendCCI[i]<0 && TrendCCI[i+1]>0)
        {
         if(trendUp>Trend_period) trendDown=0;
        }
      if(TrendCCI[i]<0)
        {
         if(trendDown<Trend_period)
           {
            CCINoTrend[i]=TrendCCI[i];
            trendDown++;
           }
         if(trendDown==Trend_period)
           {
            CCITimeBar[i]=TrendCCI[i];
            trendDown++;
           }
         if(trendDown>Trend_period)
           {
            CCITrendDown[i]=TrendCCI[i];
           }
        }
     }
   if(Zero_Cross_Alert==true)
     {
      if(prevtime==Time[0])
        {
         return(0);
        }
      else
        {
         if(EntryCCI[0]<0)
           {
            if((TrendCCI[0]<0) && (TrendCCI[1]>=0))
              {
               Alert(Symbol()," M",Period()," Trend & Entry CCI Have both crossed below zero");
              }
           }
         else if(EntryCCI[0]>0)
           {
            if((TrendCCI[0]>0) && (TrendCCI[1]<=0))
              {
               Alert(Symbol()," M",Period()," Trend & Entry CCI Have both crossed above zero");
              }
           }
         prevtime=Time[0];
        }
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
