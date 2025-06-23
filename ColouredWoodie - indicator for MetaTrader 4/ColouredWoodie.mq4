//+------------------------------------------------------------------+
//|                                                   WoodiesCCI.mq4 |
//|                                                            thorr |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "histogram colour update by thor@gmx.co.uk Moneytec chat: thorr; created by Luis Damiani; converted by Rosh"
#property indicator_separate_window
#property indicator_buffers 5
#property indicator_color1 Yellow
#property indicator_color2 White
#property indicator_color3 DimGray
#property indicator_color4 Red
#property indicator_color5 RoyalBlue
//---- input parameters
extern int       A_period=50;
extern int       B_period=12;
extern int       neutral=6;
extern int       num_bars=5000;
// parameters
int i=0;
bool initDone=true;
int bar=0;
int prevbars=0;
int startpar=0;
int cs=0;
int prevcs=0;
string commodt="nonono";
int frame=0;
int bars=0;
int count=0,thisbar=0;
double now,prev;
bool flag;
//---- buffers
double FastWoodieCCI[];
double SlowWoodieCCI[];
double HistoWoodieCCI[];
double HistoRed[];
double HistoBlue[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,1);
   SetIndexBuffer(0,FastWoodieCCI);
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,3);
   SetIndexBuffer(1,SlowWoodieCCI);
   SetIndexStyle(2,DRAW_HISTOGRAM,STYLE_SOLID,1);
   SetIndexBuffer(2,HistoWoodieCCI);
   SetIndexStyle(3,DRAW_HISTOGRAM,STYLE_SOLID,1);
   SetIndexBuffer(3,HistoRed);
   SetIndexStyle(4,DRAW_HISTOGRAM,STYLE_SOLID,1);
   SetIndexBuffer(4,HistoBlue);
   IndicatorShortName("ColouredWoodiesCCI("+A_period+","+B_period+")");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   if(Bars<A_period+B_period)
     {
      Print("Not enough bars for calculation"); 
      return(0);
     }
   int counted_bars=IndicatorCounted();
   cs=A_period+B_period+num_bars; //checksum used to see if parameters have been changed
   int startpar=Bars-counted_bars;
   if(counted_bars==0); startpar-=A_period;
   commodt=Symbol();
   frame=Time[4]-Time[5];
   for(i=startpar; i>=0; i--)
     {
      FastWoodieCCI[i]=iCCI(NULL,0,B_period,PRICE_TYPICAL,i);
      SlowWoodieCCI[i]=iCCI(NULL,0,A_period,PRICE_TYPICAL,i);
      now=iCCI(NULL,0,A_period,PRICE_TYPICAL,i);
      if((prev>=0 && now<0) || (prev<0 && now>=0))
        { // change of sign detected
         flag=true;
         count=0;
        }
      if(flag)
        { // neutral territory
         if(thisbar!=i)
            count++;
         prev=now;
         HistoWoodieCCI[i]=now;
         if(count>=neutral)
            flag=false;
         thisbar=i;
         continue;
        }
      // Colour it!
      if(now>0)
         HistoBlue[i]=now;
      if(now<0)
         HistoRed[i]=now;
      prev=now;
     }
   return(0);
  }
//+------------------------------------------------------------------+
