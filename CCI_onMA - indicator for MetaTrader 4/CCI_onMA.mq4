//+------------------------------------------------------------------+
//|                                                     CCI_onMA.mq4 |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
//2008forextsd   ki
#property copyright "http://www.forex-tsd.com/"
#property link    ""
#property indicator_chart_window
//----
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 DodgerBlue
#property indicator_width1 2
#property indicator_width2 1
//---- 
extern int CCI_Period  =14;
extern int CCI_Price   =5;
extern double CCI_multiplier=0.3;
//----
extern int MaPeriod    =14;
extern int MaMetod     =0;
extern int MaPrice     =5;
//----
extern string   note_Price="0C 1O 2H 3L4Md 5Tp 6WghC: Md(HL/2)4,Tp(HLC/3)5,Wgh(HLCC/4)6";
extern string   MA_Method_="SMA0 EMA1 SMMA2 LWMA3";
//---- 
double CCIonMABuffer[];
double MA_Buffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//|------------------------------------------------------------------|
int init()
  {
//---- 
   IndicatorBuffers(2);
   SetIndexBuffer(0,CCIonMABuffer);
   SetIndexBuffer(1,MA_Buffer);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
//----    
   SetIndexLabel(0,"CCIonMA CCI:("+CCI_Period+"|"+CCI_Price+")("+MaPeriod+")");
   SetIndexLabel(1,"MA ("+MaPeriod+")"+MaMetod+","+MaPrice+"");
   IndicatorShortName("CCIonMA "+CCI_Period+";"+MaPeriod+"");
//----
   for(int i=0;i<2;i++)
      SetIndexDrawBegin(i,MathMax(MaPeriod,CCI_Period));
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
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
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+MathMax(CCI_Period,MaPeriod);
//----
   for(int i=limit;i>=0;i--)
     {
      double     CCI_val =iCCI(NULL,0,CCI_Period,CCI_Price,i);
      MA_Buffer      [i] =iMA(NULL,0,MaPeriod,0,MaMetod,MaPrice,i);
      CCIonMABuffer  [i] =CCI_val*CCI_multiplier*Point+ MA_Buffer[i];
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
