//+------------------------------------------------------------------+
//|                                                       _Fast2.mq4 |
//|                      Copyright © 2008, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_separate_window
#property indicator_buffers 7
#property indicator_color1 LightSeaGreen
#property indicator_color2 Green
#property indicator_color3 Red
#property indicator_color4 White
#property indicator_color5 Red
#property indicator_color6 Blue
extern int    ma1=3;
extern int    ma2=9;
extern bool   sound=true;
extern bool   alert=false;
extern bool   comment=true;

//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
double ExtMapBuffer6[];
double Outbuf[];
static int prevtime=0;        // Время последнего бара
double spr,stop;
string simv;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_LINE,0,2);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_LINE,0,2);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexStyle(3,DRAW_NONE);
//SetIndexBuffer(3,Outbuf);
   SetIndexStyle(4,DRAW_ARROW);
   SetIndexArrow(4,236);
   SetIndexBuffer(4,ExtMapBuffer5);
   SetIndexEmptyValue(4,0.0);
   SetIndexStyle(5,DRAW_ARROW);
   SetIndexArrow(5,238);
   SetIndexBuffer(5,ExtMapBuffer6);
   SetIndexEmptyValue(5,0.0);
//----
   ArrayResize(Outbuf,3);
   Outbuf[1]=0;
   simv=(Symbol());
   if(simv=="EURUSD")
     {
      spr=MarketInfo("EURUSD",MODE_SPREAD);
      stop=MarketInfo("EURUSD",MODE_STOPLEVEL);
     }
   if(simv=="GBPUSD")
     {
      spr=MarketInfo("GBPUSD",MODE_SPREAD);
      stop=MarketInfo("GBPUSD",MODE_STOPLEVEL);
     }
   if(simv=="EURJPY")
     {
      spr=MarketInfo("EURJPY",MODE_SPREAD);
      stop=MarketInfo("EURJPY",MODE_STOPLEVEL);
     }
   if(simv=="GBPJPY")
     {
      spr=MarketInfo("GBPJPY",MODE_SPREAD);
      stop=MarketInfo("GBPJPY",MODE_STOPLEVEL);
     }
   if(simv=="USDJPY")
     {
      spr=MarketInfo("USDJPY",MODE_SPREAD);
      stop=MarketInfo("USDJPY",MODE_STOPLEVEL);
     }
   if(simv=="EURCHF")
     {
      spr=MarketInfo("EURCHF",MODE_SPREAD);
      stop=MarketInfo("EURCHF",MODE_STOPLEVEL);
     }
   if(simv=="GBPCHF")
     {
      spr=MarketInfo("GBPCHF",MODE_SPREAD);
      stop=MarketInfo("GBPCHF",MODE_STOPLEVEL);
     }
   if(simv=="USDCHF")
     {
      spr=MarketInfo("USDCHF",MODE_SPREAD);
      stop=MarketInfo("USDCHF",MODE_STOPLEVEL);
     }
   if(simv=="USDCAD")
     {
      spr=MarketInfo("USDCAD",MODE_SPREAD);
      stop=MarketInfo("USDCAD",MODE_STOPLEVEL);
     }
   if(simv=="AUDUSD")
     {
      spr=MarketInfo("AUDUSD",MODE_SPREAD);
      stop=MarketInfo("AUDUSD",MODE_STOPLEVEL);
     }
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   Comment("  ");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//----
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+2;

   for(int i=0;i<limit; i++)
     {
      ExtMapBuffer1[i]=((Close[i]-Open[i])+((Close[i+1]-Open[i+1])/MathSqrt(2))+((Close[i+2]-Open[i+2])/MathSqrt(3)))/Point;
      // ExtMapBuffer1[i]=((Close[i]-Open[i])+((Close[i+1]-Open[i+1])/MathSqrt(2))+((Close[i+2]-Open[i+2])/MathSqrt(3))+((Close[i+3]-Open[i+3])/MathSqrt(5))+((Close[i+4]-Open[i+4])/MathSqrt(8)))/Point;
     }
   for(i=0;i<limit;i++)
     {
      ExtMapBuffer2[i]=iMAOnArray(ExtMapBuffer1,0,ma1,0,MODE_LWMA,i);
      ExtMapBuffer3[i]=iMAOnArray(ExtMapBuffer1,0,ma2,0,MODE_LWMA,i);
     }
// Ждем, когда сформируется новый бар
   if(Time[0]==prevtime) return(0);
   prevtime = Time[0];
   Outbuf[1]=0;
//--------------------   
   if(((ExtMapBuffer2[2]>ExtMapBuffer3[2]) && (ExtMapBuffer2[1]<ExtMapBuffer3[1]) && (ExtMapBuffer2[0]<ExtMapBuffer3[0]))
      && ((ExtMapBuffer2[2]>0) && (ExtMapBuffer3[2]>0)) && ((ExtMapBuffer1[1]<=0) && (ExtMapBuffer1[0]<0)))
     {
      ExtMapBuffer6[1]=(ExtMapBuffer1[1]+ExtMapBuffer2[1]);
      if(sound==true)PlaySound("alert.wav");
      if(alert==true) Alert (Symbol());
      if(comment==true)Comment(Symbol(),TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS),"\n","SELL    SL= ",MathAbs(ExtMapBuffer1[1]-Close[1]));
      Outbuf[1]=1;
      Outbuf[2]=(MathAbs(ExtMapBuffer1[1]-Close[1]));
      if(Outbuf[2]<stop) Outbuf[2]=(MathAbs(ExtMapBuffer1[1]-Close[1]))+stop;
        } else { ExtMapBuffer6[1]=0.0;
     }
   if(((ExtMapBuffer2[2]<ExtMapBuffer3[2]) && (ExtMapBuffer2[1]>ExtMapBuffer3[1]) && (ExtMapBuffer2[0]>ExtMapBuffer3[0]))
      && ((ExtMapBuffer2[2]<0) && (ExtMapBuffer3[2]<0)) && ((ExtMapBuffer1[1]>=0) && (ExtMapBuffer1[0]>0)))
     {
      ExtMapBuffer5[1]=(ExtMapBuffer1[1]+ExtMapBuffer2[1]);
      if(sound==true)PlaySound("alert.wav");
      if(alert==true) Alert (Symbol());
      if(comment==true)Comment(Symbol(),TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS),"\n","BUY     SL= ",MathAbs(ExtMapBuffer1[1]-Close[1]));
      Outbuf[1]=2;
      Outbuf[2]=(MathAbs(ExtMapBuffer1[1]-Close[1]));
      if(Outbuf[2]<stop) Outbuf[2]=(MathAbs(ExtMapBuffer1[1]-Close[1]))+stop;
        } else {  ExtMapBuffer5[1]=0.0;
     }

   if((ExtMapBuffer2[2]-ExtMapBuffer3[2])>(ExtMapBuffer2[1]-ExtMapBuffer3[1]))
     {
      if(sound==true)PlaySound("alert2.wav");
      if(comment==true)Comment(TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS),"\n","Close !!!",(Close[1]));
      Outbuf[1]=3;
     }


//----
   return(0);
  }
//+------------------------------------------------------------------+
