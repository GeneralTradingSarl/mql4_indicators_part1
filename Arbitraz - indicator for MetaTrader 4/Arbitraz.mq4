//+------------------------------------------------------------------+
//|                                                                  |
//|                 Copyright © 2000-2007, MetaQuotes Software Corp. |
//|                                         http://www.metaquotes.ru |
//+------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_buffers  1
#property indicator_color1 Red
//#property indicator_levelstyle DR
double ExtMapBuffer1[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   if(Symbol()!="EURUSD")
     {
      Alert("Indicator must be attached at EURUSD chart!");
     }
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   if(Bars==0)return(0);
   int GBPUSD_bars=iBars("GBPUSD",0);
   int EURGBP_bars=iBars("EURGBP",0);
   if(MathMax(GBPUSD_bars,EURGBP_bars)<Bars)
     {
      Print("Not enough bars on GBPUSD or on EURGBP");
      return(0);
     }
   int cnt=IndicatorCounted();
   int limit=Bars-cnt;
   //if(cnt==0) limit--;
   for(cnt=0;cnt<limit; cnt++)
     {
      ExtMapBuffer1[cnt]=iClose("GBPUSD",0,cnt)*iClose("EURGBP",0,cnt);
     }//for 
   ExtMapBuffer1[0]=MarketInfo("GBPUSD",MODE_BID)*MarketInfo("EURGBP",MODE_BID);
   return(0);
  }
//+------------------------------------------------------------------+
