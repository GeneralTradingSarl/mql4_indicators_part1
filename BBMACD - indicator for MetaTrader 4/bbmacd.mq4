//+------------------------------------------------------------------+
//|                                                       BBMACD.mq4 |
//|                 Copyright 2014,  Roy Philips Jacobs ~ 31/07/2014 |
//|                                           http://www.gol2you.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014,  Roy Philips Jacobs ~ 31/07/2014"
#property link      "http://www.gol2you.com ~ Forex Videos"
#property description "Forex Indicator Bollinger Bands® and MACD Awesome."
#property description "BBMACD is the Bollinger Bands® and MACD Awesome indicator in the same place at separate window."
#property version   "1.00"
#property strict
//--
#property indicator_separate_window
#property indicator_buffers 7
#property indicator_color1 clrGold
#property indicator_color2 clrGold
#property indicator_color3 clrRed
#property indicator_color4 clrNONE
#property indicator_color5 clrBlue
#property indicator_color6 clrWhite
#property indicator_color7 clrLightSlateGray
//--
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 2
#property indicator_width4 1
#property indicator_width5 3
#property indicator_width6 3
#property indicator_width7 1
//--
input string BBMACD="Copyright © 2014 3RJ ~ Roy Philips-Jacobs";
input int TrendPeriod=66;
//-- indicator_buffers
double bb2lubuf[];
double bb2llbuf[];
double trendbuf[];
double macdbuf[];
double macdupbuf[];
double macddnbuf[];
double cntrbuf[];
//--
int dev=2;
int maf=5;
int mas=34;
int bbper=20;
//--
string symbol;
string CopyR;
//--
void EventSetTimer();
//---
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator property
   symbol=_Symbol;
   CopyR="Copyright © 2014 3RJ ~ Roy Philips-Jacobs";
//---  
//--- indicator buffers mapping
   IndicatorBuffers(7);
   //---
   SetIndexBuffer(0,bb2lubuf);
   SetIndexBuffer(1,bb2llbuf);
   SetIndexBuffer(2,trendbuf);
   SetIndexBuffer(3,macdbuf);
   SetIndexBuffer(4,macdupbuf);
   SetIndexBuffer(5,macddnbuf);
   SetIndexBuffer(6,cntrbuf);
   //--- indicator line drawing
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,EMPTY,clrGold);
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,EMPTY,clrGold);
   SetIndexStyle(2,DRAW_LINE,STYLE_SOLID,EMPTY,clrRed);
   SetIndexStyle(3,DRAW_NONE);
   SetIndexStyle(4,DRAW_HISTOGRAM,STYLE_SOLID,EMPTY,clrBlue);
   SetIndexStyle(5,DRAW_HISTOGRAM,STYLE_SOLID,EMPTY,clrWhite);
   SetIndexStyle(6,DRAW_LINE,STYLE_SOLID,EMPTY,clrLightSlateGray);
   //--- name for DataWindow and indicator subwindow label
   SetIndexLabel(0,"UpperLine");
   SetIndexLabel(1,"LowerLine");
   SetIndexLabel(2,"TrendLine");
   SetIndexLabel(3,NULL);
   SetIndexLabel(4,"SignalUp");
   SetIndexLabel(5,"SignalDn");
   SetIndexLabel(6,NULL);
   //--
   IndicatorShortName("BBMACD");
   IndicatorDigits(Digits);
   //--
//---
   return(INIT_SUCCEEDED);
  }
//---  
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//----
   EventKillTimer();
   GlobalVariablesDeleteAll();
//----
   return;
  }
//---
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   if(BBMACD!=CopyR) return(0); 
//---
   int i,limit;
   double prv=0.00,cur;
   bool up,dn;
//--- check for bars count
   if(rates_total<=TrendPeriod) return(0);
//--- last counted bar will be recounted
   limit=rates_total-prev_calculated;
   if(prev_calculated>0) limit++;
   //--
//--- counting from rates_total to 0 
   ArraySetAsSeries(bb2lubuf,true);
   ArraySetAsSeries(bb2llbuf,true);
   ArraySetAsSeries(trendbuf,true);
   ArraySetAsSeries(macdbuf,true);
   ArraySetAsSeries(macdupbuf,true);
   ArraySetAsSeries(macddnbuf,true);
   ArraySetAsSeries(low,true);
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(close,true);
   ArraySetAsSeries(open,true);
   //--
//--- main cycle
   for(i=limit-1; i>=0; i--)
     {
       //---
       trendbuf[i]=iMA(symbol,0,bbper,0,MODE_SMA,PRICE_MEDIAN,i)-iMA(symbol,0,TrendPeriod,0,MODE_SMA,PRICE_MEDIAN,i);
       bb2lubuf[i]=(iBands(symbol,0,bbper,dev,0,PRICE_MEDIAN,1,i)-iMA(symbol,0,bbper,0,MODE_SMA,PRICE_MEDIAN,i));
       bb2llbuf[i]=(iBands(symbol,0,bbper,dev,0,PRICE_MEDIAN,2,i)-iMA(symbol,0,bbper,0,MODE_SMA,PRICE_MEDIAN,i));
       macdbuf[i]=(iMA(symbol,0,maf,0,MODE_SMA,PRICE_MEDIAN,i)-iMA(symbol,0,mas,0,MODE_SMA,PRICE_MEDIAN,i))+
                  (iMACD(symbol,0,12,26,9,PRICE_CLOSE,MODE_MAIN,i)-iMACD(symbol,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,i));
       cur=macdbuf[i];
       cntrbuf[i]=0.00;
       //--
       if(cur>prv) {up=true; dn=false;}
       if(cur<prv) {dn=true; up=false;}
       //--
       if(up) {macdupbuf[i]=cur; macddnbuf[i]=0.00;}
       if(dn) {macddnbuf[i]=cur; macdupbuf[i]=0.00;}
       //--
       prv=cur;       
       //---
     }
   //---
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+