//+------------------------------------------------------------------+
//|                                                FX Multi-Meter II |
//|                                        Copyright © 2009, J.Arent |
//|                                           josharent@yahoo.com.au |
//|                                                                  |
//|                 Inspired by !x-meter (Special thanks to R. Hill) |
//+------------------------------------------------------------------+
#property copyright "©J.Arent 2009"
#property indicator_chart_window

extern string Title1="== History Line =======================";
extern bool DisplayHistoryLine=true;
extern color  LineColor=DimGray;
extern string Title2="== Compact Mode ====================";
extern bool DisplayCompact=false;
extern string Title3="== Display Price/Chart/Currency =========";
extern bool DisplayPriceInfo=false;
extern int PriceFontSize= 32;
extern color PriceColor = White;
extern int ChartFontSize= 16;
extern color ChartColor = DimGray;
extern string DisplayOptions="== Use Monthly Chart for Options ======";
extern bool DisableMonthly=true;
extern string Title4="== Processing Latency (Sleep) ==========";
extern string LatencyDescription1 = "Higher values reduce flickering.";
extern string LatencyDescription2 = "Lower values increase responsiveness.";
extern int Latency=100;
extern string Title5="== Trend-O-Graph ====================";
extern string MA_Types="0=SMA, 1=EMA, 2=SMMA, 4=LWMA";
extern bool DisplayTrendGraph=true;
extern int MA_Type=2;
extern int MA1_Period = 3;
extern int MA2_Period = 5;
extern int MA3_Period = 10;
extern int MA4_Period = 20;
extern int MA5_Period = 50;
extern int MA6_Period = 100;
extern int MA7_Period = 200;
extern string Title6="== Overall Signal =====================";
extern string CurrentIndicators="Current Indicators";
extern bool Include_MAXover=true;
extern bool Include_MACD = true;
extern bool Include_PSAR = true;
extern bool Include_MA=true;
extern bool Include_STOCH=true;
extern bool Include_WPR=true;
extern bool Include_PriceDirection=true;
extern string MultiIndicators="Multi-Timeframe Indicators";
extern bool Include_M1_MA = false;
extern bool Include_M5_MA = false;
extern bool Include_M15_MA = false;
extern bool Include_M30_MA = false;
extern bool Include_H1_MA = false;
extern bool Include_H4_MA = false;
extern bool Include_D1_MA = false;
extern string Title7="== OB/OS Signal Map =================";
extern string OBOSDescription1="Grey = OB/OS, Green = BUY, Red = SELL.";
extern int Stochastic_BUY=20;
extern int Stochastic_SELL=80;
extern int WilliamsPercentRange_BUY=-80;
extern int WilliamsPercentRange_SELL=-20;
extern int MoneyFlowIndex_BUY=20;
extern int MoneyFlowIndex_SELL=80;
extern int CommodityChannelIndex_BUY=-100;
extern int CommodityChannelIndex_SELL= 100;
extern int RelativeStrengthIndex_BUY = 30;
extern int RelativeStrengthIndex_SELL= 70;
extern int BollingerBand_Period=20;
extern int BollingerBand_Deviation=2;
extern string Title8 = "== Indicator Values =====================";
extern string Title9 = "Stochastic Oscillators";
extern int Stoch_K = 14;
extern int Stoch_D = 3;
extern int Stoch_Slowing=3;
extern string Title10="Moving Average Trend-Bar";
extern string TrendBar_MA_Types="0=SMA, 1=EMA, 2=SMMA, 4=LWMA";
extern int TrendBar_MA_Type=1;
extern int MA_Period= 14;
extern int MA_Shift = 0;
extern string Title11="MACD";
extern int MACD_Period1 = 12;
extern int MACD_Period2 = 26;
extern int MACD_Period3 = 9;
extern string Title12="MA-Xover";
extern int FastLWMA= 3;
extern int SlowSMA = 5;
extern string Title13="Parabolic SAR";
extern double PSAR_Step= 0.02;
extern double PSAR_Max = 0.2;

string HistoryLine="History Line";
//+------------------------------------------------------------------+
//     expert initialization function                                |       
//+------------------------------------------------------------------+
int init()
  {
   int   err,lastError;
//----
   if(DisplayHistoryLine)
     {
      if(ObjectFind(HistoryLine)==-1)
        {
         ObjectCreate(HistoryLine,OBJ_VLINE,0,Time[0]+300,Close[0]);
         ObjectSet(HistoryLine,OBJPROP_COLOR,LineColor);
        }
     }
   initGraph();
//while (true)                                                             
     {
      if(IsConnected()) main();
      if(!IsConnected()) objectBlank();
      //if(DisableMonthly) {if(Period()==PERIOD_MN1) break;}
      WindowRedraw();
      Sleep(Latency);
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//     expert deinitialization function                              |       
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectsDeleteAll(0,OBJ_LABEL);
   Print("shutdown error - ",GetLastError());
//----
   return(0);
  }
//+------------------------------------------------------------------+
//     expert start function                                         |       
//+------------------------------------------------------------------+
int start()
  {
//----
   if(Bars<10) return(0);

   if(IsConnected()) main();
   if(!IsConnected()) objectBlank();
   //if(DisableMonthly) {if(Period()==PERIOD_MN1) break;}
   WindowRedraw();
   Sleep(Latency);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//     expert custom function                                        |       
//+------------------------------------------------------------------+    
void main()
  {
   RefreshRates();

//History Line ----------------------------------------------------
   int BarShift,BarShift2,BarShiftM1,BarShiftM5,BarShiftM15,BarShiftM30,BarShiftH1,BarShiftH4,BarShiftD1;
   if(DisplayHistoryLine)
     {
      datetime VLineTime=ObjectGet(HistoryLine,OBJPROP_TIME1);

      if(VLineTime>=Time[0]) {BarShift=0;}
      if(Period()==PERIOD_M1 && VLineTime<Time[0])
        {
         BarShift2=(Time[0]-VLineTime)/60;
         BarShift=((Time[0]-VLineTime)/60)+(BarShift2-((Time[0]-Time[BarShift2])/60));
        }
      if(Period()==PERIOD_M5 && VLineTime<Time[0])
        {
         BarShift2=(Time[0]-VLineTime)/300;
         BarShift=((Time[0]-VLineTime)/300)+(BarShift2-((Time[0]-Time[BarShift2])/300));
        }
      if(Period()==PERIOD_M15 && VLineTime<Time[0])
        {
         BarShift2=(Time[0]-VLineTime)/900;
         BarShift=((Time[0]-VLineTime)/900)+(BarShift2-((Time[0]-Time[BarShift2])/900));
        }
      if(Period()==PERIOD_M30 && VLineTime<Time[0])
        {
         BarShift2=(Time[0]-VLineTime)/1800;
         BarShift=((Time[0]-VLineTime)/1800)+(BarShift2-((Time[0]-Time[BarShift2])/1800));
        }
      if(Period()==PERIOD_H1 && VLineTime<Time[0])
        {
         BarShift2=(Time[0]-VLineTime)/3600;
         BarShift=((Time[0]-VLineTime)/3600)+(BarShift2-((Time[0]-Time[BarShift2])/3600));
        }
      if(Period()==PERIOD_H4 && VLineTime<Time[0])
        {
         BarShift2=(Time[0]-VLineTime)/14400;
         BarShift=((Time[0]-VLineTime)/14400)+(BarShift2-((Time[0]-Time[BarShift2])/14400));
        }
      if(Period()==PERIOD_D1 && VLineTime<Time[0])
        {
         BarShift2=(Time[0]-VLineTime)/86400;
         BarShift=((Time[0]-VLineTime)/86400)+(BarShift2-((Time[0]-Time[BarShift2])/86400));
        }
      if(Period()==PERIOD_W1 && VLineTime<Time[0])
        {
         BarShift2=(Time[0]-VLineTime)/604800;
         BarShift=((Time[0]-VLineTime)/604800)+(BarShift2-((Time[0]-Time[BarShift2])/604800));
        }
      if(Period()==PERIOD_MN1 && VLineTime<Time[0])
        {
         BarShift2=(Time[0]-VLineTime)/(PERIOD_MN1*60);
         BarShift=((Time[0]-VLineTime)/(PERIOD_MN1*60))+(BarShift2-((Time[0]-Time[BarShift2])/(PERIOD_MN1*60)));
        }
      Print("BarShift = ",BarShift);
      //Print ("BarShift2 = ",BarShift2);

      if(VLineTime>=Time[0]) {BarShiftM1=0;}
      if(VLineTime<Time[0])
        {
         BarShiftM1=(Time[0]-VLineTime)/60;
        }

      if(VLineTime>=Time[0]) {BarShiftM5=0;}
      if(VLineTime<Time[0])
        {
         BarShiftM5=(Time[0]-VLineTime)/300;
        }

      if(VLineTime>=Time[0]) {BarShiftM15=0;}
      if(VLineTime<Time[0])
        {
         BarShiftM15=(Time[0]-VLineTime)/900;
        }

      if(VLineTime>=Time[0]) {BarShiftM30=0;}
      if(VLineTime<Time[0])
        {
         BarShiftM30=(Time[0]-VLineTime)/1800;
        }

      if(VLineTime>=Time[0]) {BarShiftH1=0;}
      if(VLineTime<Time[0])
        {
         BarShiftH1=(Time[0]-VLineTime)/3600;
        }

      if(VLineTime>=Time[0]) {BarShiftH4=0;}
      if(VLineTime<Time[0])
        {
         BarShiftH4=(Time[0]-VLineTime)/14400;
        }

      if(VLineTime>=Time[0]) {BarShiftD1=0;}
      if(VLineTime<Time[0])
        {
         BarShiftD1=(Time[0]-VLineTime)/86400;
        }
     }

   else if(!DisplayHistoryLine)
     {BarShift=0; BarShiftM1=0; BarShiftM5=0; BarShiftM15=0; BarShiftM30=0; BarShiftH1=0; BarShiftH4=0; BarShiftD1=0;}
   if(ObjectFind(HistoryLine)==-1) {BarShift=0; BarShiftM1=0; BarShiftM5=0; BarShiftM15=0; BarShiftM30=0; BarShiftH1=0; BarShiftH4=0; BarShiftD1=0;}

// Variables -------------------
   double M1stochK,M1stochD,M5stochK,M5stochD,M15stochK,M15stochD,M30stochK,M30stochD,H1stochK,H1stochD,H4stochK,H4stochD,D1stochK,D1stochD,StochK,StochD,StochKprev,StochDprev;
   double M1stochKprev,M5stochKprev,M15stochKprev,M30stochKprev,H1stochKprev,H4stochKprev,D1stochKprev,M1stochDprev,M5stochDprev,M15stochDprev,M30stochDprev,H1stochDprev,H4stochDprev,D1stochDprev;
   double MAM1,MAM5,MAM15,MAM30,MAH1,MAH4,MAD1,MAM1prev,MAM5prev,MAM15prev,MAM30prev,MAH1prev,MAH4prev,MAD1prev,MACurrent,MAPrevious;
   double Spread,PSARCurrent,PSARPrev,MACDCurrent,MACDPrev,MACDSignal,MACDSignalPrev,MAXover1,MAXover2,VolumePercent,Vol,VolPrev,WPR,Bar1,Bar2,Bar3,Bar4,Bar5,Bar6,Bar7,Bar8,Bar9,Bar10;
   double Bar1percent,Bar2percent,Bar3percent,Bar4percent,Bar5percent,BarsAverage1,BarsAverage2,BarsAverage3,BarsAverage4,BarsAverage5,BarsAllpercent;
   int trendM1,trendM5,trendM15,trendM30,trendH1,trendH4,trendD1,PSAR,MACD,MAXoverSignal,VolValue,WPRValueUp,WPRValueDown,Bar1Col,Bar2Col,Bar3Col,Bar4Col,Bar5Col,BarReading,Signal;
   double TGMA1M1,TGMA1M5,TGMA1M15,TGMA1M30,TGMA1H1,TGMA1H4,TGMA1D1,TGMA2M1,TGMA2M5,TGMA2M15,TGMA2M30,TGMA2H1,TGMA2H4,TGMA2D1;
   double TGMA3M1,TGMA3M5,TGMA3M15,TGMA3M30,TGMA3H1,TGMA3H4,TGMA3D1,TGMA4M1,TGMA4M5,TGMA4M15,TGMA4M30,TGMA4H1,TGMA4H4,TGMA4D1;
   double TGMA5M1,TGMA5M5,TGMA5M15,TGMA5M30,TGMA5H1,TGMA5H4,TGMA5D1,TGMA6M1,TGMA6M5,TGMA6M15,TGMA6M30,TGMA6H1,TGMA6H4,TGMA6D1;
   double TGMA7M1,TGMA7M5,TGMA7M15,TGMA7M30,TGMA7H1,TGMA7H4,TGMA7D1;
   double TGMA1M1prev,TGMA1M5prev,TGMA1M15prev,TGMA1M30prev,TGMA1H1prev,TGMA1H4prev,TGMA1D1prev,TGMA2M1prev,TGMA2M5prev,TGMA2M15prev,TGMA2M30prev,TGMA2H1prev,TGMA2H4prev,TGMA2D1prev;
   double TGMA3M1prev,TGMA3M5prev,TGMA3M15prev,TGMA3M30prev,TGMA3H1prev,TGMA3H4prev,TGMA3D1prev,TGMA4M1prev,TGMA4M5prev,TGMA4M15prev,TGMA4M30prev,TGMA4H1prev,TGMA4H4prev,TGMA4D1prev;
   double TGMA5M1prev,TGMA5M5prev,TGMA5M15prev,TGMA5M30prev,TGMA5H1prev,TGMA5H4prev,TGMA5D1prev,TGMA6M1prev,TGMA6M5prev,TGMA6M15prev,TGMA6M30prev,TGMA6H1prev,TGMA6H4prev,TGMA6D1prev;
   double TGMA7M1prev,TGMA7M5prev,TGMA7M15prev,TGMA7M30prev,TGMA7H1prev,TGMA7H4prev,TGMA7D1prev;
   int TGMA1M1Signal,TGMA1M5Signal,TGMA1M15Signal,TGMA1M30Signal,TGMA1H1Signal,TGMA1H4Signal,TGMA1D1Signal;
   int TGMA2M1Signal,TGMA2M5Signal,TGMA2M15Signal,TGMA2M30Signal,TGMA2H1Signal,TGMA2H4Signal,TGMA2D1Signal;
   int TGMA3M1Signal,TGMA3M5Signal,TGMA3M15Signal,TGMA3M30Signal,TGMA3H1Signal,TGMA3H4Signal,TGMA3D1Signal;
   int TGMA4M1Signal,TGMA4M5Signal,TGMA4M15Signal,TGMA4M30Signal,TGMA4H1Signal,TGMA4H4Signal,TGMA4D1Signal;
   int TGMA5M1Signal,TGMA5M5Signal,TGMA5M15Signal,TGMA5M30Signal,TGMA5H1Signal,TGMA5H4Signal,TGMA5D1Signal;
   int TGMA6M1Signal,TGMA6M5Signal,TGMA6M15Signal,TGMA6M30Signal,TGMA6H1Signal,TGMA6H4Signal,TGMA6D1Signal;
   int TGMA7M1Signal,TGMA7M5Signal,TGMA7M15Signal,TGMA7M30Signal,TGMA7H1Signal,TGMA7H4Signal,TGMA7D1Signal;
   double OBOSRSIM1,OBOSRSIM5,OBOSRSIM15,OBOSRSIM30,OBOSRSIH1,OBOSRSIH4,OBOSRSID1,OBOSRSIM1prev,OBOSRSIM5prev,OBOSRSIM15prev,OBOSRSIM30prev,OBOSRSIH1prev,OBOSRSIH4prev,OBOSRSID1prev;
   double OBOSCCIM1,OBOSCCIM5,OBOSCCIM15,OBOSCCIM30,OBOSCCIH1,OBOSCCIH4,OBOSCCID1,OBOSCCIM1prev,OBOSCCIM5prev,OBOSCCIM15prev,OBOSCCIM30prev,OBOSCCIH1prev,OBOSCCIH4prev,OBOSCCID1prev;
   double OBOSMFIM1,OBOSMFIM5,OBOSMFIM15,OBOSMFIM30,OBOSMFIH1,OBOSMFIH4,OBOSMFID1,OBOSMFIM1prev,OBOSMFIM5prev,OBOSMFIM15prev,OBOSMFIM30prev,OBOSMFIH1prev,OBOSMFIH4prev,OBOSMFID1prev;
   double OBOSWPRM1,OBOSWPRM5,OBOSWPRM15,OBOSWPRM30,OBOSWPRH1,OBOSWPRH4,OBOSWPRD1,OBOSWPRM1prev,OBOSWPRM5prev,OBOSWPRM15prev,OBOSWPRM30prev,OBOSWPRH1prev,OBOSWPRH4prev,OBOSWPRD1prev;
   double OBOSBBHighM1,OBOSBBHighM5,OBOSBBHighM15,OBOSBBHighM30,OBOSBBHighH1,OBOSBBHighH4,OBOSBBHighD1,OBOSBBLowM1,OBOSBBLowM5,OBOSBBLowM15,OBOSBBLowM30,OBOSBBLowH1,OBOSBBLowH4,OBOSBBLowD1;
   double OBOSMACDM1,OBOSMACDM5,OBOSMACDM15,OBOSMACDM30,OBOSMACDH1,OBOSMACDH4,OBOSMACDD1,OBOSMACDM1prev,OBOSMACDM5prev,OBOSMACDM15prev,OBOSMACDM30prev,OBOSMACDH1prev,OBOSMACDH4prev,OBOSMACDD1prev;
   double OBOSMACDM1Signal,OBOSMACDM5Signal,OBOSMACDM15Signal,OBOSMACDM30Signal,OBOSMACDH1Signal,OBOSMACDH4Signal,OBOSMACDD1Signal,OBOSMACDM1Signalprev,OBOSMACDM5Signalprev,OBOSMACDM15Signalprev,OBOSMACDM30Signalprev,OBOSMACDH1Signalprev,OBOSMACDH4Signalprev,OBOSMACDD1Signalprev;
   int OBOSRSIM1Signal,OBOSRSIM5Signal,OBOSRSIM15Signal,OBOSRSIM30Signal,OBOSRSIH1Signal,OBOSRSIH4Signal,OBOSRSID1Signal;
   int OBOSBBM1Signal,OBOSBBM5Signal,OBOSBBM15Signal,OBOSBBM30Signal,OBOSBBH1Signal,OBOSBBH4Signal,OBOSBBD1Signal;
   int OBOSMACM1Signal,OBOSMACM5Signal,OBOSMACM15Signal,OBOSMACM30Signal,OBOSMACH1Signal,OBOSMACH4Signal,OBOSMACD1Signal;
   int OBOSSTOM1Signal,OBOSSTOM5Signal,OBOSSTOM15Signal,OBOSSTOM30Signal,OBOSSTOH1Signal,OBOSSTOH4Signal,OBOSSTOD1Signal;
   int OBOSWPRM1Signal,OBOSWPRM5Signal,OBOSWPRM15Signal,OBOSWPRM30Signal,OBOSWPRH1Signal,OBOSWPRH4Signal,OBOSWPRD1Signal;
   int OBOSMFIM1Signal,OBOSMFIM5Signal,OBOSMFIM15Signal,OBOSMFIM30Signal,OBOSMFIH1Signal,OBOSMFIH4Signal,OBOSMFID1Signal;
   int OBOSCCIM1Signal,OBOSCCIM5Signal,OBOSCCIM15Signal,OBOSCCIM30Signal,OBOSCCIH1Signal,OBOSCCIH4Signal,OBOSCCID1Signal;
   bool SignalBuy_MAXover=0,SignalBuy_MACD=0,SignalBuy_PSAR=0,SignalBuy_MA=0,SignalBuy_STOCH=0,SignalBuy_WPR=0,SignalBuy_Price=0;
   bool SignalSell_MAXover=0,SignalSell_MACD=0,SignalSell_PSAR=0,SignalSell_MA=0,SignalSell_STOCH=0,SignalSell_WPR=0,SignalSell_Price=0;
   bool M1Buy=0,M5Buy=0,M15Buy=0,M30Buy=0,H1Buy=0,H4Buy=0,D1Buy=0,M1Sell=0,M5Sell=0,M15Sell=0,M30Sell=0,H1Sell=0,H4Sell=0,D1Sell=0;
// Stochs ----------------------------------------------------------------------------------------------  
   M1stochK = iStochastic(Symbol(), PERIOD_M1, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_MAIN, BarShiftM1+0);
   M1stochD = iStochastic(Symbol(), PERIOD_M1, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_SIGNAL, BarShiftM1+0);
   M5stochK = iStochastic(Symbol(), PERIOD_M5, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_MAIN, BarShiftM5+0);
   M5stochD = iStochastic(Symbol(), PERIOD_M5, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_SIGNAL, BarShiftM5+0);
   M15stochK = iStochastic(Symbol(), PERIOD_M15, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_MAIN, BarShiftM15+0);
   M15stochD = iStochastic(Symbol(), PERIOD_M15, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_SIGNAL, BarShiftM15+0);
   M30stochK = iStochastic(Symbol(), PERIOD_M30, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_MAIN, BarShiftM30+0);
   M30stochD = iStochastic(Symbol(), PERIOD_M30, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_SIGNAL, BarShiftM30+0);
   H1stochK = iStochastic(Symbol(), PERIOD_H1, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_MAIN, BarShiftH1+0);
   H1stochD = iStochastic(Symbol(), PERIOD_H1, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_SIGNAL, BarShiftH1+0);
   H4stochK = iStochastic(Symbol(), PERIOD_H4, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_MAIN, BarShiftH4+0);
   H4stochD = iStochastic(Symbol(), PERIOD_H4, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_SIGNAL, BarShiftH4+0);
   D1stochK = iStochastic(Symbol(), PERIOD_D1, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_MAIN, BarShiftD1+0);
   D1stochD = iStochastic(Symbol(), PERIOD_D1, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_SIGNAL, BarShiftD1+0);
   M1stochKprev = iStochastic(Symbol(), PERIOD_M1, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_MAIN, BarShiftM1+1);
   M5stochKprev = iStochastic(Symbol(), PERIOD_M5, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_MAIN, BarShiftM5+1);
   M15stochKprev = iStochastic(Symbol(), PERIOD_M15, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_MAIN, BarShiftM15+1);
   M30stochKprev = iStochastic(Symbol(), PERIOD_M30, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_MAIN, BarShiftM30+1);
   H1stochKprev = iStochastic(Symbol(), PERIOD_H1, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_MAIN, BarShiftH1+1);
   H4stochKprev = iStochastic(Symbol(), PERIOD_H4, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_MAIN, BarShiftH4+1);
   D1stochKprev = iStochastic(Symbol(), PERIOD_D1, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_MAIN, BarShiftD1+1);
   M1stochDprev = iStochastic(Symbol(), PERIOD_M1, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_MAIN, BarShiftM1+1);
   M5stochDprev = iStochastic(Symbol(), PERIOD_M5, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_MAIN, BarShiftM5+1);
   M15stochDprev = iStochastic(Symbol(), PERIOD_M15, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_MAIN, BarShiftM15+1);
   M30stochDprev = iStochastic(Symbol(), PERIOD_M30, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_MAIN, BarShiftM30+1);
   H1stochDprev = iStochastic(Symbol(), PERIOD_H1, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_MAIN, BarShiftH1+1);
   H4stochDprev = iStochastic(Symbol(), PERIOD_H4, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_MAIN, BarShiftH4+1);
   D1stochDprev = iStochastic(Symbol(), PERIOD_D1, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_MAIN, BarShiftD1+1);
   StochK = iStochastic(Symbol(), 0, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_MAIN, BarShift+0);
   StochD = iStochastic(Symbol(), 0, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_SIGNAL, BarShift+0);
   StochKprev = iStochastic(Symbol(), 0, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_MAIN, BarShift+1);
   StochDprev = iStochastic(Symbol(), 0, Stoch_K,Stoch_D, Stoch_Slowing, MODE_SMA, 0, MODE_SIGNAL, BarShift+1);
// MA's ---------------------------------------------------------- 
   MAM1=iMA(NULL,PERIOD_M1,MA_Period,MA_Shift,TrendBar_MA_Type,PRICE_CLOSE,BarShiftM1+0);
   MAM5=iMA(NULL,PERIOD_M5,MA_Period,MA_Shift,TrendBar_MA_Type,PRICE_CLOSE,BarShiftM5+0);
   MAM15=iMA(NULL,PERIOD_M15,MA_Period,MA_Shift,TrendBar_MA_Type,PRICE_CLOSE,BarShiftM15+0);
   MAM30=iMA(NULL,PERIOD_M30,MA_Period,MA_Shift,TrendBar_MA_Type,PRICE_CLOSE,BarShiftM30+0);
   MAH1=iMA(NULL,PERIOD_H1,MA_Period,MA_Shift,TrendBar_MA_Type,PRICE_CLOSE,BarShiftH1+0);
   MAH4=iMA(NULL,PERIOD_H4,MA_Period,MA_Shift,TrendBar_MA_Type,PRICE_CLOSE,BarShiftH4+0);
   MAD1=iMA(NULL,PERIOD_D1,MA_Period,MA_Shift,TrendBar_MA_Type,PRICE_CLOSE,BarShiftD1+0);

   MAM1prev=iMA(NULL,PERIOD_M1,MA_Period,MA_Shift,TrendBar_MA_Type,PRICE_CLOSE,BarShiftM1+1);
   MAM5prev=iMA(NULL,PERIOD_M5,MA_Period,MA_Shift,TrendBar_MA_Type,PRICE_CLOSE,BarShiftM5+1);
   MAM15prev=iMA(NULL,PERIOD_M15,MA_Period,MA_Shift,TrendBar_MA_Type,PRICE_CLOSE,BarShiftM15+1);
   MAM30prev=iMA(NULL,PERIOD_M30,MA_Period,MA_Shift,TrendBar_MA_Type,PRICE_CLOSE,BarShiftM30+1);
   MAH1prev=iMA(NULL,PERIOD_H1,MA_Period,MA_Shift,TrendBar_MA_Type,PRICE_CLOSE,BarShiftH1+1);
   MAH4prev=iMA(NULL,PERIOD_H4,MA_Period,MA_Shift,TrendBar_MA_Type,PRICE_CLOSE,BarShiftH4+1);
   MAD1prev=iMA(NULL,PERIOD_D1,MA_Period,MA_Shift,TrendBar_MA_Type,PRICE_CLOSE,BarShiftD1+1);

   MACurrent=iMA(NULL,0,MA_Period,MA_Shift,TrendBar_MA_Type,PRICE_CLOSE,BarShift+0);
   MAPrevious=iMA(NULL,0,MA_Period,MA_Shift,TrendBar_MA_Type,PRICE_CLOSE,BarShift+1);

// ----------------------------------------------------------------
   if(MAM1>MAM1prev)
     {
      trendM1=1;
     }
   if(MAM1<MAM1prev)
     {
      trendM1=0;
     }
   if(MAM5>MAM5prev)
     {
      trendM5=1;
     }
   if(MAM5<MAM5prev)
     {
      trendM5=0;
     }
   if(MAM15>MAM15prev)
     {
      trendM15=1;
     }
   if(MAM15<MAM15prev)
     {
      trendM15=0;
     }
   if(MAM30>MAM30prev)
     {
      trendM30=1;
     }
   if(MAM30<MAM30prev)
     {
      trendM30=0;
     }
   if(MAH1>MAH1prev)
     {
      trendH1=1;
     }
   if(MAH1<MAH1prev)
     {
      trendH1=0;
     }
   if(MAH4>MAH4prev)
     {
      trendH4=1;
     }
   if(MAH4<MAH4prev)
     {
      trendH4=0;
     }
   if(MAD1>MAD1prev)
     {
      trendD1=1;
     }
   if(MAD1<MAD1prev)
     {
      trendD1=0;
     }
// Spread ---------------

   Spread=NormalizeDouble(((Ask-Bid)/Point)/10,1);

// ParabolicSAR -------------------------------

   PSARCurrent=iSAR(NULL,0,PSAR_Step,PSAR_Max,BarShift+0);
   PSARPrev=iSAR(NULL,0,PSAR_Step,PSAR_Max,BarShift+1);

   if(PSARCurrent<Close[BarShift+0])
     {
      PSAR=1;
     }
   if(PSARCurrent>Close[BarShift+0])
     {
      PSAR=0;
     }
// MACD ---------------------------------------

   MACDCurrent=iMACD(NULL,0,MACD_Period1,MACD_Period2,MACD_Period3,PRICE_CLOSE,MODE_MAIN,BarShift+0);
   MACDPrev=iMACD(NULL,0,MACD_Period1,MACD_Period2,MACD_Period3,PRICE_CLOSE,MODE_MAIN,BarShift+1);
   MACDSignal=iMACD(NULL,0,MACD_Period1,MACD_Period2,MACD_Period3,PRICE_CLOSE,MODE_SIGNAL,BarShift+0);
   MACDSignalPrev=iMACD(NULL,0,MACD_Period1,MACD_Period2,MACD_Period3,PRICE_CLOSE,MODE_SIGNAL,BarShift+1);

   if(MACDCurrent>MACDPrev && ((MACDCurrent && MACDPrev)>MACDSignal || (MACDCurrent && MACDPrev)<MACDSignal))
     {
      MACD=3;
     }
   if(MACDCurrent<MACDSignal && MACDPrev>MACDSignalPrev)
     {
      MACD=2;
     }
   if(MACDCurrent<MACDPrev && ((MACDCurrent && MACDPrev)>MACDSignal || (MACDCurrent && MACDPrev)<MACDSignal))
     {
      MACD=1;
     }
   if(MACDCurrent>MACDSignal && MACDPrev<MACDSignalPrev)
     {
      MACD=0;
     }
   if(MACDCurrent>0 && MACDPrev<0)
     {
      MACD=4;
     }
   if(MACDCurrent<0 && MACDPrev>0)
     {
      MACD=5;
     }
// MA XOVER  ---------------------------------------

   MAXover1=iMA(NULL,0,FastLWMA,0,MODE_LWMA,PRICE_CLOSE,BarShift+0);
   MAXover2=iMA(NULL,0,SlowSMA,0,MODE_SMA,PRICE_CLOSE,BarShift+0);

   if(MAXover1>MAXover2)
     {
      MAXoverSignal=1;
     }
   if(MAXover1<MAXover2)
     {
      MAXoverSignal=0;
     }
// Williams%Range ---------------------------------

   WPR=iWPR(NULL,0,14,BarShift+0);

   if(WPR<=0 && WPR>=-5)
     {
      WPRValueUp=1;
     }
   if(WPR>=-20 && WPR<-5)
     {
      WPRValueUp=2;
     }
   if(WPR>=-30 && WPR<-20)
     {
      WPRValueUp=3;
     }
   if(WPR>=-40 && WPR<-30)
     {
      WPRValueUp=4;
     }
   if(WPR>-50 && WPR<-40)
     {
      WPRValueUp=5;
     }
   if(WPR<-50 && WPR>=-60)
     {
      WPRValueDown=6;
     }
   if(WPR<=-60 && WPR>=-70)
     {
      WPRValueDown=7;
     }
   if(WPR<=-70 && WPR>=-80)
     {
      WPRValueDown=8;
     }
   if(WPR<=-80 && WPR>=-95)
     {
      WPRValueDown=9;
     }
   if(WPR<=-95 && WPR>=-100)
     {
      WPRValueDown=10;
     }

// BarMeter ---------------------------------------------------------

   if(Close[BarShift+0]>Close[BarShift+1])
     {
      Bar1=(Close[BarShift+0]-Close[BarShift+1])*100000;
     }
   if(Close[BarShift+0]<Close[BarShift+1])
     {
      Bar1=(Close[BarShift+1]-Close[BarShift+0])*100000;
     }

   if(Close[BarShift+1]>Close[BarShift+2])
     {
      Bar2=(Close[BarShift+1]-Close[BarShift+2])*100000;
     }
   if(Close[BarShift+1]<Close[BarShift+2])
     {
      Bar2=(Close[BarShift+2]-Close[BarShift+1])*100000;
     }

   if(Close[BarShift+2]>Close[BarShift+3])
     {
      Bar3=(Close[BarShift+2]-Close[BarShift+3])*100000;
     }
   if(Close[BarShift+2]<Close[BarShift+3])
     {
      Bar3=(Close[BarShift+3]-Close[BarShift+2])*100000;
     }

   if(Close[BarShift+3]>Close[BarShift+4])
     {
      Bar4=(Close[BarShift+3]-Close[BarShift+4])*100000;
     }
   if(Close[BarShift+3]<Close[BarShift+4])
     {
      Bar4=(Close[BarShift+4]-Close[BarShift+3])*100000;
     }

   if(Close[BarShift+4]>Close[BarShift+5])
     {
      Bar5=(Close[BarShift+4]-Close[BarShift+5])*100000;
     }
   if(Close[BarShift+4]<Close[BarShift+5])
     {
      Bar5=(Close[BarShift+5]-Close[BarShift+4])*100000;
     }

   if(Close[BarShift+5]>Close[BarShift+6])
     {
      Bar6=(Close[BarShift+5]-Close[BarShift+6])*100000;
     }
   if(Close[BarShift+5]<Close[BarShift+6])
     {
      Bar6=(Close[BarShift+6]-Close[BarShift+5])*100000;
     }

   if(Close[BarShift+6]>Close[BarShift+7])
     {
      Bar7=(Close[BarShift+6]-Close[BarShift+7])*100000;
     }
   if(Close[BarShift+6]<Close[BarShift+7])
     {
      Bar7=(Close[BarShift+7]-Close[BarShift+6])*100000;
     }

   if(Close[BarShift+7]>Close[BarShift+8])
     {
      Bar8=(Close[BarShift+7]-Close[BarShift+8])*100000;
     }
   if(Close[BarShift+7]<Close[BarShift+8])
     {
      Bar8=(Close[BarShift+8]-Close[BarShift+7])*100000;
     }

   if(Close[BarShift+8]>Close[BarShift+9])
     {
      Bar9=(Close[BarShift+8]-Close[BarShift+9])*100000;
     }
   if(Close[BarShift+8]<Close[BarShift+9])
     {
      Bar9=(Close[BarShift+9]-Close[BarShift+8])*100000;
     }

   if(Close[BarShift+9]>Close[BarShift+10])
     {
      Bar10=(Close[BarShift+9]-Close[BarShift+10])*100000;
     }
   if(Close[BarShift+9]<Close[BarShift+10])
     {
      Bar10=(Close[BarShift+10]-Close[BarShift+9])*100000;
     }
//----------------------------------------    
   BarsAverage1 = (Bar2 + Bar3 + Bar4 + Bar5)/4;
   BarsAverage2 = (Bar3 + Bar4 + Bar5 + Bar6)/4;
   BarsAverage3 = (Bar4 + Bar5 + Bar6 + Bar7)/4;
   BarsAverage4 = (Bar5 + Bar6 + Bar7 + Bar8)/4;
   BarsAverage5 = (Bar6 + Bar7 + Bar8 + Bar9)/4;

   Bar1percent = NormalizeDouble((Bar1/BarsAverage1)*100,0);
   Bar2percent = NormalizeDouble((Bar2/BarsAverage2)*100,0);
   Bar3percent = NormalizeDouble((Bar3/BarsAverage3)*100,0);
   Bar4percent = NormalizeDouble((Bar4/BarsAverage4)*100,0);
   Bar5percent = NormalizeDouble((Bar5/BarsAverage5)*100,0);
   BarsAllpercent=NormalizeDouble(((Bar2+Bar3+Bar4+Bar5)/4)*100,0);

   if(Bar1percent==0) //Stopped
     {
      BarReading=1;
     }
   if(Bar1percent>Bar2percent && Bar1percent>100 && Bar1percent!=0) //Speeding Up
     {
      BarReading=2;
     }
   if(Bar1percent<=100 && Bar1percent!=0) //Steady
     {
      BarReading=3;
     }
   if(Bar1percent<Bar2percent && Bar2percent>100 && Bar1percent>100 && Bar1percent!=0) //Slowing Down
     {
      BarReading=4;
     }
//----------------------------------------  
   if(Bar1percent==0 || Close[BarShift+0]==Close[BarShift+1])
     {
      Bar1Col=12;
     }
   if(Bar1percent<25 && Bar1percent>0)
     {
      Bar1Col=11;
     }
   if(Bar1percent>=400)
     {
      if(Close[BarShift+0]>Close[BarShift+1])
        {
         Bar1Col=1;
        }
      else if(Close[BarShift+0]<Close[BarShift+1]) Bar1Col=10;
     }
   if(Bar1percent>=200 && Bar1percent<400)
     {
      if(Close[BarShift+0]>Close[BarShift+1])
        {
         Bar1Col=2;
        }
      else if(Close[BarShift+0]<Close[BarShift+1]) Bar1Col=9;
     }
   if(Bar1percent>=100 && Bar1percent<200)
     {
      if(Close[BarShift+0]>Close[BarShift+1])
        {
         Bar1Col=3;
        }
      else if(Close[BarShift+0]<Close[BarShift+1]) Bar1Col=8;
     }
   if(Bar1percent>=50 && Bar1percent<100)
     {
      if(Close[BarShift+0]>Close[BarShift+1])
        {
         Bar1Col=4;
        }
      else if(Close[BarShift+0]<Close[BarShift+1]) Bar1Col=7;
     }
   if(Bar1percent>=25 && Bar1percent<50)
     {
      if(Close[BarShift+0]>Close[BarShift+1])
        {
         Bar1Col=5;
        }
      else if(Close[BarShift+0]<Close[BarShift+1]) Bar1Col=6;
     }
//--------------------------------------
   if(Bar2percent==0 || Close[BarShift+1]==Close[BarShift+2])
     {
      Bar2Col=12;
     }
   if(Bar2percent<25 && Bar2percent>0)
     {
      Bar2Col=11;
     }
   if(Bar2percent>=400)
     {
      if(Close[BarShift+1]>Close[BarShift+2])
        {
         Bar2Col=1;
        }
      else if(Close[BarShift+1]<Close[BarShift+2]) Bar2Col=10;
     }
   if(Bar2percent>=200 && Bar2percent<400)
     {
      if(Close[BarShift+1]>Close[BarShift+2])
        {
         Bar2Col=2;
        }
      else if(Close[BarShift+1]<Close[BarShift+2]) Bar2Col=9;
     }
   if(Bar2percent>=100 && Bar2percent<200)
     {
      if(Close[BarShift+1]>Close[BarShift+2])
        {
         Bar2Col=3;
        }
      else if(Close[BarShift+1]<Close[BarShift+2]) Bar2Col=8;
     }
   if(Bar2percent>=50 && Bar2percent<100)
     {
      if(Close[BarShift+1]>Close[BarShift+2])
        {
         Bar2Col=4;
        }
      else if(Close[BarShift+1]<Close[BarShift+2]) Bar2Col=7;
     }
   if(Bar2percent>=25 && Bar2percent<50)
     {
      if(Close[BarShift+1]>Close[BarShift+2])
        {
         Bar2Col=5;
        }
      else if(Close[BarShift+1]<Close[BarShift+2]) Bar2Col=6;
     }
//--------------------------------------
   if(Bar3percent==0 || Close[BarShift+2]==Close[BarShift+3])
     {
      Bar3Col=12;
     }
   if(Bar3percent<25 && Bar3percent>0)
     {
      Bar3Col=11;
     }
   if(Bar3percent>=400)
     {
      if(Close[BarShift+2]>Close[BarShift+3])
        {
         Bar3Col=1;
        }
      else if(Close[BarShift+2]<Close[BarShift+3]) Bar3Col=10;
     }
   if(Bar3percent>=200 && Bar3percent<400)
     {
      if(Close[BarShift+2]>Close[BarShift+3])
        {
         Bar3Col=2;
        }
      else if(Close[BarShift+2]<Close[BarShift+3]) Bar3Col=9;
     }
   if(Bar3percent>=100 && Bar3percent<200)
     {
      if(Close[BarShift+2]>Close[BarShift+3])
        {
         Bar3Col=3;
        }
      else if(Close[BarShift+2]<Close[BarShift+3]) Bar3Col=8;
     }
   if(Bar3percent>=50 && Bar3percent<100)
     {
      if(Close[BarShift+2]>Close[BarShift+3])
        {
         Bar3Col=4;
        }
      else if(Close[BarShift+2]<Close[BarShift+3]) Bar3Col=7;
     }
   if(Bar3percent>=25 && Bar3percent<50)
     {
      if(Close[BarShift+2]>Close[BarShift+3])
        {
         Bar3Col=5;
        }
      else if(Close[BarShift+2]<Close[BarShift+3]) Bar3Col=6;
     }
//--------------------------------------
   if(Bar4percent==0 || Close[BarShift+3]==Close[BarShift+4])
     {
      Bar4Col=12;
     }
   if(Bar4percent<25 && Bar4percent>0)
     {
      Bar4Col=11;
     }
   if(Bar4percent>=400)
     {
      if(Close[BarShift+3]>Close[BarShift+4])
        {
         Bar4Col=1;
        }
      else if(Close[BarShift+3]<Close[BarShift+4]) Bar4Col=10;
     }
   if(Bar4percent>=200 && Bar4percent<400)
     {
      if(Close[BarShift+3]>Close[BarShift+4])
        {
         Bar4Col=2;
        }
      else if(Close[BarShift+3]<Close[BarShift+4]) Bar4Col=9;
     }
   if(Bar4percent>=100 && Bar4percent<200)
     {
      if(Close[BarShift+3]>Close[BarShift+4])
        {
         Bar4Col=3;
        }
      else if(Close[BarShift+3]<Close[BarShift+4]) Bar4Col=8;
     }
   if(Bar4percent>=50 && Bar4percent<100)
     {
      if(Close[BarShift+3]>Close[BarShift+4])
        {
         Bar4Col=4;
        }
      else if(Close[BarShift+3]<Close[BarShift+4]) Bar4Col=7;
     }
   if(Bar4percent>=25 && Bar4percent<50)
     {
      if(Close[BarShift+3]>Close[BarShift+4])
        {
         Bar4Col=5;
        }
      else if(Close[BarShift+3]<Close[BarShift+4]) Bar4Col=6;
     }
//--------------------------------------
   if(Bar5percent==0 || Close[BarShift+4]==Close[BarShift+5])
     {
      Bar5Col=12;
     }
   if(Bar5percent<25 && Bar5percent>0)
     {
      Bar5Col=11;
     }
   if(Bar5percent>=400)
     {
      if(Close[BarShift+4]>Close[BarShift+5])
        {
         Bar5Col=1;
        }
      else if(Close[BarShift+4]<Close[BarShift+5]) Bar5Col=10;
     }
   if(Bar5percent>=200 && Bar5percent<400)
     {
      if(Close[BarShift+4]>Close[BarShift+5])
        {
         Bar5Col=2;
        }
      else if(Close[BarShift+4]<Close[BarShift+5]) Bar5Col=9;
     }
   if(Bar5percent>=100 && Bar5percent<200)
     {
      if(Close[BarShift+4]>Close[BarShift+5])
        {
         Bar5Col=3;
        }
      else if(Close[BarShift+4]<Close[BarShift+5]) Bar5Col=8;
     }
   if(Bar5percent>=50 && Bar5percent<100)
     {
      if(Close[BarShift+4]>Close[BarShift+5])
        {
         Bar5Col=4;
        }
      else if(Close[BarShift+4]<Close[BarShift+5]) Bar5Col=7;
     }
   if(Bar5percent>=25 && Bar5percent<50)
     {
      if(Close[BarShift+4]>Close[BarShift+5])
        {
         Bar5Col=5;
        }
      else if(Close[BarShift+4]<Close[BarShift+5]) Bar5Col=6;
     }

// Trend-O-Graph -------------

   TGMA1M1=iMA(NULL,PERIOD_M1,MA1_Period,0,MA_Type,PRICE_CLOSE,BarShiftM1+0);
   TGMA1M5=iMA(NULL,PERIOD_M5,MA1_Period,0,MA_Type,PRICE_CLOSE,BarShiftM5+0);
   TGMA1M15=iMA(NULL,PERIOD_M15,MA1_Period,0,MA_Type,PRICE_CLOSE,BarShiftM15+0);
   TGMA1M30=iMA(NULL,PERIOD_M30,MA1_Period,0,MA_Type,PRICE_CLOSE,BarShiftM30+0);
   TGMA1H1=iMA(NULL,PERIOD_H1,MA1_Period,0,MA_Type,PRICE_CLOSE,BarShiftH1+0);
   TGMA1H4=iMA(NULL,PERIOD_H4,MA1_Period,0,MA_Type,PRICE_CLOSE,BarShiftH4+0);
   TGMA1D1=iMA(NULL,PERIOD_D1,MA1_Period,0,MA_Type,PRICE_CLOSE,BarShiftD1+0);

   TGMA2M1=iMA(NULL,PERIOD_M1,MA2_Period,0,MA_Type,PRICE_CLOSE,BarShiftM1+0);
   TGMA2M5=iMA(NULL,PERIOD_M5,MA2_Period,0,MA_Type,PRICE_CLOSE,BarShiftM5+0);
   TGMA2M15=iMA(NULL,PERIOD_M15,MA2_Period,0,MA_Type,PRICE_CLOSE,BarShiftM15+0);
   TGMA2M30=iMA(NULL,PERIOD_M30,MA2_Period,0,MA_Type,PRICE_CLOSE,BarShiftM30+0);
   TGMA2H1=iMA(NULL,PERIOD_H1,MA2_Period,0,MA_Type,PRICE_CLOSE,BarShiftH1+0);
   TGMA2H4=iMA(NULL,PERIOD_H4,MA2_Period,0,MA_Type,PRICE_CLOSE,BarShiftH4+0);
   TGMA2D1=iMA(NULL,PERIOD_D1,MA2_Period,0,MA_Type,PRICE_CLOSE,BarShiftD1+0);

   TGMA3M1=iMA(NULL,PERIOD_M1,MA3_Period,0,MA_Type,PRICE_CLOSE,BarShiftM1+0);
   TGMA3M5=iMA(NULL,PERIOD_M5,MA3_Period,0,MA_Type,PRICE_CLOSE,BarShiftM5+0);
   TGMA3M15=iMA(NULL,PERIOD_M15,MA3_Period,0,MA_Type,PRICE_CLOSE,BarShiftM15+0);
   TGMA3M30=iMA(NULL,PERIOD_M30,MA3_Period,0,MA_Type,PRICE_CLOSE,BarShiftM30+0);
   TGMA3H1=iMA(NULL,PERIOD_H1,MA3_Period,0,MA_Type,PRICE_CLOSE,BarShiftH1+0);
   TGMA3H4=iMA(NULL,PERIOD_H4,MA3_Period,0,MA_Type,PRICE_CLOSE,BarShiftH4+0);
   TGMA3D1=iMA(NULL,PERIOD_D1,MA3_Period,0,MA_Type,PRICE_CLOSE,BarShiftD1+0);

   TGMA4M1=iMA(NULL,PERIOD_M1,MA4_Period,0,MA_Type,PRICE_CLOSE,BarShiftM1+0);
   TGMA4M5=iMA(NULL,PERIOD_M5,MA4_Period,0,MA_Type,PRICE_CLOSE,BarShiftM5+0);
   TGMA4M15=iMA(NULL,PERIOD_M15,MA4_Period,0,MA_Type,PRICE_CLOSE,BarShiftM15+0);
   TGMA4M30=iMA(NULL,PERIOD_M30,MA4_Period,0,MA_Type,PRICE_CLOSE,BarShiftM30+0);
   TGMA4H1=iMA(NULL,PERIOD_H1,MA4_Period,0,MA_Type,PRICE_CLOSE,BarShiftH1+0);
   TGMA4H4=iMA(NULL,PERIOD_H4,MA4_Period,0,MA_Type,PRICE_CLOSE,BarShiftH4+0);
   TGMA4D1=iMA(NULL,PERIOD_D1,MA4_Period,0,MA_Type,PRICE_CLOSE,BarShiftD1+0);

   TGMA5M1=iMA(NULL,PERIOD_M1,MA5_Period,0,MA_Type,PRICE_CLOSE,BarShiftM1+0);
   TGMA5M5=iMA(NULL,PERIOD_M5,MA5_Period,0,MA_Type,PRICE_CLOSE,BarShiftM5+0);
   TGMA5M15=iMA(NULL,PERIOD_M15,MA5_Period,0,MA_Type,PRICE_CLOSE,BarShiftM15+0);
   TGMA5M30=iMA(NULL,PERIOD_M30,MA5_Period,0,MA_Type,PRICE_CLOSE,BarShiftM30+0);
   TGMA5H1=iMA(NULL,PERIOD_H1,MA5_Period,0,MA_Type,PRICE_CLOSE,BarShiftH1+0);
   TGMA5H4=iMA(NULL,PERIOD_H4,MA5_Period,0,MA_Type,PRICE_CLOSE,BarShiftH4+0);
   TGMA5D1=iMA(NULL,PERIOD_D1,MA5_Period,0,MA_Type,PRICE_CLOSE,BarShiftD1+0);

   TGMA6M1=iMA(NULL,PERIOD_M1,MA6_Period,0,MA_Type,PRICE_CLOSE,BarShiftM1+0);
   TGMA6M5=iMA(NULL,PERIOD_M5,MA6_Period,0,MA_Type,PRICE_CLOSE,BarShiftM5+0);
   TGMA6M15=iMA(NULL,PERIOD_M15,MA6_Period,0,MA_Type,PRICE_CLOSE,BarShiftM15+0);
   TGMA6M30=iMA(NULL,PERIOD_M30,MA6_Period,0,MA_Type,PRICE_CLOSE,BarShiftM30+0);
   TGMA6H1=iMA(NULL,PERIOD_H1,MA6_Period,0,MA_Type,PRICE_CLOSE,BarShiftH1+0);
   TGMA6H4=iMA(NULL,PERIOD_H4,MA6_Period,0,MA_Type,PRICE_CLOSE,BarShiftH4+0);
   TGMA6D1=iMA(NULL,PERIOD_D1,MA6_Period,0,MA_Type,PRICE_CLOSE,BarShiftD1+0);

   TGMA7M1=iMA(NULL,PERIOD_M1,MA7_Period,0,MA_Type,PRICE_CLOSE,BarShiftM1+0);
   TGMA7M5=iMA(NULL,PERIOD_M5,MA7_Period,0,MA_Type,PRICE_CLOSE,BarShiftM5+0);
   TGMA7M15=iMA(NULL,PERIOD_M15,MA7_Period,0,MA_Type,PRICE_CLOSE,BarShiftM15+0);
   TGMA7M30=iMA(NULL,PERIOD_M30,MA7_Period,0,MA_Type,PRICE_CLOSE,BarShiftM30+0);
   TGMA7H1=iMA(NULL,PERIOD_H1,MA7_Period,0,MA_Type,PRICE_CLOSE,BarShiftH1+0);
   TGMA7H4=iMA(NULL,PERIOD_H4,MA7_Period,0,MA_Type,PRICE_CLOSE,BarShiftH4+0);
   TGMA7D1=iMA(NULL,PERIOD_D1,MA7_Period,0,MA_Type,PRICE_CLOSE,BarShiftD1+0);

   TGMA7M1prev=iMA(NULL,PERIOD_M1,MA7_Period,0,MA_Type,PRICE_CLOSE,BarShiftM1+1);
   TGMA7M5prev=iMA(NULL,PERIOD_M5,MA7_Period,0,MA_Type,PRICE_CLOSE,BarShiftM5+1);
   TGMA7M15prev=iMA(NULL,PERIOD_M15,MA7_Period,0,MA_Type,PRICE_CLOSE,BarShiftM15+1);
   TGMA7M30prev=iMA(NULL,PERIOD_M30,MA7_Period,0,MA_Type,PRICE_CLOSE,BarShiftM30+1);
   TGMA7H1prev=iMA(NULL,PERIOD_H1,MA7_Period,0,MA_Type,PRICE_CLOSE,BarShiftH1+1);
   TGMA7H4prev=iMA(NULL,PERIOD_H4,MA7_Period,0,MA_Type,PRICE_CLOSE,BarShiftH4+1);
   TGMA7D1prev=iMA(NULL,PERIOD_D1,MA7_Period,0,MA_Type,PRICE_CLOSE,BarShiftD1+1);

   TGMA1M1prev=iMA(NULL,PERIOD_M1,MA1_Period,0,MA_Type,PRICE_CLOSE,BarShiftM1+1);
   TGMA1M5prev=iMA(NULL,PERIOD_M5,MA1_Period,0,MA_Type,PRICE_CLOSE,BarShiftM5+1);
   TGMA1M15prev=iMA(NULL,PERIOD_M15,MA1_Period,0,MA_Type,PRICE_CLOSE,BarShiftM15+1);
   TGMA1M30prev=iMA(NULL,PERIOD_M30,MA1_Period,0,MA_Type,PRICE_CLOSE,BarShiftM30+1);
   TGMA1H1prev=iMA(NULL,PERIOD_H1,MA1_Period,0,MA_Type,PRICE_CLOSE,BarShiftH1+1);
   TGMA1H4prev=iMA(NULL,PERIOD_H4,MA1_Period,0,MA_Type,PRICE_CLOSE,BarShiftH4+1);
   TGMA1D1prev=iMA(NULL,PERIOD_D1,MA1_Period,0,MA_Type,PRICE_CLOSE,BarShiftD1+1);

   TGMA2M1prev=iMA(NULL,PERIOD_M1,MA2_Period,0,MA_Type,PRICE_CLOSE,BarShiftM1+1);
   TGMA2M5prev=iMA(NULL,PERIOD_M5,MA2_Period,0,MA_Type,PRICE_CLOSE,BarShiftM5+1);
   TGMA2M15prev=iMA(NULL,PERIOD_M15,MA2_Period,0,MA_Type,PRICE_CLOSE,BarShiftM15+1);
   TGMA2M30prev=iMA(NULL,PERIOD_M30,MA2_Period,0,MA_Type,PRICE_CLOSE,BarShiftM30+1);
   TGMA2H1prev=iMA(NULL,PERIOD_H1,MA2_Period,0,MA_Type,PRICE_CLOSE,BarShiftH1+1);
   TGMA2H4prev=iMA(NULL,PERIOD_H4,MA2_Period,0,MA_Type,PRICE_CLOSE,BarShiftH4+1);
   TGMA2D1prev=iMA(NULL,PERIOD_D1,MA2_Period,0,MA_Type,PRICE_CLOSE,BarShiftD1+1);

   TGMA3M1prev=iMA(NULL,PERIOD_M1,MA3_Period,0,MA_Type,PRICE_CLOSE,BarShiftM1+1);
   TGMA3M5prev=iMA(NULL,PERIOD_M5,MA3_Period,0,MA_Type,PRICE_CLOSE,BarShiftM5+1);
   TGMA3M15prev=iMA(NULL,PERIOD_M15,MA3_Period,0,MA_Type,PRICE_CLOSE,BarShiftM15+1);
   TGMA3M30prev=iMA(NULL,PERIOD_M30,MA3_Period,0,MA_Type,PRICE_CLOSE,BarShiftM30+1);
   TGMA3H1prev=iMA(NULL,PERIOD_H1,MA3_Period,0,MA_Type,PRICE_CLOSE,BarShiftH1+1);
   TGMA3H4prev=iMA(NULL,PERIOD_H4,MA3_Period,0,MA_Type,PRICE_CLOSE,BarShiftH4+1);
   TGMA3D1prev=iMA(NULL,PERIOD_D1,MA3_Period,0,MA_Type,PRICE_CLOSE,BarShiftD1+1);

   TGMA4M1prev=iMA(NULL,PERIOD_M1,MA4_Period,0,MA_Type,PRICE_CLOSE,BarShiftM1+1);
   TGMA4M5prev=iMA(NULL,PERIOD_M5,MA4_Period,0,MA_Type,PRICE_CLOSE,BarShiftM5+1);
   TGMA4M15prev=iMA(NULL,PERIOD_M15,MA4_Period,0,MA_Type,PRICE_CLOSE,BarShiftM15+1);
   TGMA4M30prev=iMA(NULL,PERIOD_M30,MA4_Period,0,MA_Type,PRICE_CLOSE,BarShiftM30+1);
   TGMA4H1prev=iMA(NULL,PERIOD_H1,MA4_Period,0,MA_Type,PRICE_CLOSE,BarShiftH1+1);
   TGMA4H4prev=iMA(NULL,PERIOD_H4,MA4_Period,0,MA_Type,PRICE_CLOSE,BarShiftH4+1);
   TGMA4D1prev=iMA(NULL,PERIOD_D1,MA4_Period,0,MA_Type,PRICE_CLOSE,BarShiftD1+1);

   TGMA5M1prev=iMA(NULL,PERIOD_M1,MA5_Period,0,MA_Type,PRICE_CLOSE,BarShiftM1+1);
   TGMA5M5prev=iMA(NULL,PERIOD_M5,MA5_Period,0,MA_Type,PRICE_CLOSE,BarShiftM5+1);
   TGMA5M15prev=iMA(NULL,PERIOD_M15,MA5_Period,0,MA_Type,PRICE_CLOSE,BarShiftM15+1);
   TGMA5M30prev=iMA(NULL,PERIOD_M30,MA5_Period,0,MA_Type,PRICE_CLOSE,BarShiftM30+1);
   TGMA5H1prev=iMA(NULL,PERIOD_H1,MA5_Period,0,MA_Type,PRICE_CLOSE,BarShiftH1+1);
   TGMA5H4prev=iMA(NULL,PERIOD_H4,MA5_Period,0,MA_Type,PRICE_CLOSE,BarShiftH4+1);
   TGMA5D1prev=iMA(NULL,PERIOD_D1,MA5_Period,0,MA_Type,PRICE_CLOSE,BarShiftD1+1);

   TGMA6M1prev=iMA(NULL,PERIOD_M1,MA6_Period,0,MA_Type,PRICE_CLOSE,BarShiftM1+1);
   TGMA6M5prev=iMA(NULL,PERIOD_M5,MA6_Period,0,MA_Type,PRICE_CLOSE,BarShiftM5+1);
   TGMA6M15prev=iMA(NULL,PERIOD_M15,MA6_Period,0,MA_Type,PRICE_CLOSE,BarShiftM15+1);
   TGMA6M30prev=iMA(NULL,PERIOD_M30,MA6_Period,0,MA_Type,PRICE_CLOSE,BarShiftM30+1);
   TGMA6H1prev=iMA(NULL,PERIOD_H1,MA6_Period,0,MA_Type,PRICE_CLOSE,BarShiftH1+1);
   TGMA6H4prev=iMA(NULL,PERIOD_H4,MA6_Period,0,MA_Type,PRICE_CLOSE,BarShiftH4+1);
   TGMA6D1prev=iMA(NULL,PERIOD_D1,MA6_Period,0,MA_Type,PRICE_CLOSE,BarShiftD1+1);

   TGMA7M1prev=iMA(NULL,PERIOD_M1,MA7_Period,0,MA_Type,PRICE_CLOSE,BarShiftM1+1);
   TGMA7M5prev=iMA(NULL,PERIOD_M5,MA7_Period,0,MA_Type,PRICE_CLOSE,BarShiftM5+1);
   TGMA7M15prev=iMA(NULL,PERIOD_M15,MA7_Period,0,MA_Type,PRICE_CLOSE,BarShiftM15+1);
   TGMA7M30prev=iMA(NULL,PERIOD_M30,MA7_Period,0,MA_Type,PRICE_CLOSE,BarShiftM30+1);
   TGMA7H1prev=iMA(NULL,PERIOD_H1,MA7_Period,0,MA_Type,PRICE_CLOSE,BarShiftH1+1);
   TGMA7H4prev=iMA(NULL,PERIOD_H4,MA7_Period,0,MA_Type,PRICE_CLOSE,BarShiftH4+1);
   TGMA7D1prev=iMA(NULL,PERIOD_D1,MA7_Period,0,MA_Type,PRICE_CLOSE,BarShiftD1+1);

   if(TGMA1M1>TGMA1M1prev) {TGMA1M1Signal=1;} else TGMA1M1Signal=0;
   if(TGMA1M5>TGMA1M5prev) {TGMA1M5Signal=1;} else TGMA1M5Signal=0;
   if(TGMA1M15>TGMA1M15prev) {TGMA1M15Signal=1;} else TGMA1M15Signal=0;
   if(TGMA1M30>TGMA1M30prev) {TGMA1M30Signal=1;} else TGMA1M30Signal=0;
   if(TGMA1H1>TGMA1H1prev) {TGMA1H1Signal=1;} else TGMA1H1Signal=0;
   if(TGMA1H4>TGMA1H4prev) {TGMA1H4Signal=1;} else TGMA1H4Signal=0;
   if(TGMA1D1>TGMA1D1prev) {TGMA1D1Signal=1;} else TGMA1D1Signal=0;

   if(TGMA2M1>TGMA2M1prev) {TGMA2M1Signal=1;} else TGMA2M1Signal=0;
   if(TGMA2M5>TGMA2M5prev) {TGMA2M5Signal=1;} else TGMA2M5Signal=0;
   if(TGMA2M15>TGMA2M15prev) {TGMA2M15Signal=1;} else TGMA2M15Signal=0;
   if(TGMA2M30>TGMA2M30prev) {TGMA2M30Signal=1;} else TGMA2M30Signal=0;
   if(TGMA2H1>TGMA2H1prev) {TGMA2H1Signal=1;} else TGMA2H1Signal=0;
   if(TGMA2H4>TGMA2H4prev) {TGMA2H4Signal=1;} else TGMA2H4Signal=0;
   if(TGMA2D1>TGMA2D1prev) {TGMA2D1Signal=1;} else TGMA2D1Signal=0;

   if(TGMA3M1>TGMA3M1prev) {TGMA3M1Signal=1;} else TGMA3M1Signal=0;
   if(TGMA3M5>TGMA3M5prev) {TGMA3M5Signal=1;} else TGMA3M5Signal=0;
   if(TGMA3M15>TGMA3M15prev) {TGMA3M15Signal=1;} else TGMA3M15Signal=0;
   if(TGMA3M30>TGMA3M30prev) {TGMA3M30Signal=1;} else TGMA3M30Signal=0;
   if(TGMA3H1>TGMA3H1prev) {TGMA3H1Signal=1;} else TGMA3H1Signal=0;
   if(TGMA3H4>TGMA3H4prev) {TGMA3H4Signal=1;} else TGMA3H4Signal=0;
   if(TGMA3D1>TGMA3D1prev) {TGMA3D1Signal=1;} else TGMA3D1Signal=0;

   if(TGMA4M1>TGMA4M1prev) {TGMA4M1Signal=1;} else TGMA4M1Signal=0;
   if(TGMA4M5>TGMA4M5prev) {TGMA4M5Signal=1;} else TGMA4M5Signal=0;
   if(TGMA4M15>TGMA4M15prev) {TGMA4M15Signal=1;} else TGMA4M15Signal=0;
   if(TGMA4M30>TGMA4M30prev) {TGMA4M30Signal=1;} else TGMA4M30Signal=0;
   if(TGMA4H1>TGMA4H1prev) {TGMA4H1Signal=1;} else TGMA4H1Signal=0;
   if(TGMA4H4>TGMA4H4prev) {TGMA4H4Signal=1;} else TGMA4H4Signal=0;
   if(TGMA4D1>TGMA4D1prev) {TGMA4D1Signal=1;} else TGMA4D1Signal=0;

   if(TGMA5M1>TGMA5M1prev) {TGMA5M1Signal=1;} else TGMA5M1Signal=0;
   if(TGMA5M5>TGMA5M5prev) {TGMA5M5Signal=1;} else TGMA5M5Signal=0;
   if(TGMA5M15>TGMA5M15prev) {TGMA5M15Signal=1;} else TGMA5M15Signal=0;
   if(TGMA5M30>TGMA5M30prev) {TGMA5M30Signal=1;} else TGMA5M30Signal=0;
   if(TGMA5H1>TGMA5H1prev) {TGMA5H1Signal=1;} else TGMA5H1Signal=0;
   if(TGMA5H4>TGMA5H4prev) {TGMA5H4Signal=1;} else TGMA5H4Signal=0;
   if(TGMA5D1>TGMA5D1prev) {TGMA5D1Signal=1;} else TGMA5D1Signal=0;

   if(TGMA6M1>TGMA6M1prev) {TGMA6M1Signal=1;} else TGMA6M1Signal=0;
   if(TGMA6M5>TGMA6M5prev) {TGMA6M5Signal=1;} else TGMA6M5Signal=0;
   if(TGMA6M15>TGMA6M15prev) {TGMA6M15Signal=1;} else TGMA6M15Signal=0;
   if(TGMA6M30>TGMA6M30prev) {TGMA6M30Signal=1;} else TGMA6M30Signal=0;
   if(TGMA6H1>TGMA6H1prev) {TGMA6H1Signal=1;} else TGMA6H1Signal=0;
   if(TGMA6H4>TGMA6H4prev) {TGMA6H4Signal=1;} else TGMA6H4Signal=0;
   if(TGMA6D1>TGMA6D1prev) {TGMA6D1Signal=1;} else TGMA6D1Signal=0;

   if(TGMA7M1>TGMA7M1prev) {TGMA7M1Signal=1;} else TGMA7M1Signal=0;
   if(TGMA7M5>TGMA7M5prev) {TGMA7M5Signal=1;} else TGMA7M5Signal=0;
   if(TGMA7M15>TGMA7M15prev) {TGMA7M15Signal=1;} else TGMA7M15Signal=0;
   if(TGMA7M30>TGMA7M30prev) {TGMA7M30Signal=1;} else TGMA7M30Signal=0;
   if(TGMA7H1>TGMA7H1prev) {TGMA7H1Signal=1;} else TGMA7H1Signal=0;
   if(TGMA7H4>TGMA7H4prev) {TGMA7H4Signal=1;} else TGMA7H4Signal=0;
   if(TGMA7D1>TGMA7D1prev) {TGMA7D1Signal=1;} else TGMA7D1Signal=0;

// Overbought/Oversold Map -------------------------------

   OBOSRSIM1=iRSI(NULL,PERIOD_M1,14,PRICE_CLOSE,BarShiftM1+0);
   OBOSRSIM5=iRSI(NULL,PERIOD_M5,14,PRICE_CLOSE,BarShiftM5+0);
   OBOSRSIM15=iRSI(NULL,PERIOD_M15,14,PRICE_CLOSE,BarShiftM15+0);
   OBOSRSIM30=iRSI(NULL,PERIOD_M30,14,PRICE_CLOSE,BarShiftM30+0);
   OBOSRSIH1=iRSI(NULL,PERIOD_H1,14,PRICE_CLOSE,BarShiftH1+0);
   OBOSRSIH4=iRSI(NULL,PERIOD_H4,14,PRICE_CLOSE,BarShiftH4+0);
   OBOSRSID1=iRSI(NULL,PERIOD_D1,14,PRICE_CLOSE,BarShiftD1+0);
   OBOSRSIM1prev=iRSI(NULL,PERIOD_M1,14,PRICE_CLOSE,BarShiftM1+1);
   OBOSRSIM5prev=iRSI(NULL,PERIOD_M5,14,PRICE_CLOSE,BarShiftM5+1);
   OBOSRSIM15prev=iRSI(NULL,PERIOD_M15,14,PRICE_CLOSE,BarShiftM15+1);
   OBOSRSIM30prev=iRSI(NULL,PERIOD_M30,14,PRICE_CLOSE,BarShiftM30+1);
   OBOSRSIH1prev=iRSI(NULL,PERIOD_H1,14,PRICE_CLOSE,BarShiftH1+1);
   OBOSRSIH4prev=iRSI(NULL,PERIOD_H4,14,PRICE_CLOSE,BarShiftH4+1);
   OBOSRSID1prev=iRSI(NULL,PERIOD_D1,14,PRICE_CLOSE,BarShiftD1+1);

   OBOSCCIM1=iCCI(NULL,PERIOD_M1,12,PRICE_CLOSE,BarShiftM1+0);
   OBOSCCIM5=iCCI(NULL,PERIOD_M5,12,PRICE_CLOSE,BarShiftM5+0);
   OBOSCCIM15=iCCI(NULL,PERIOD_M15,12,PRICE_CLOSE,BarShiftM15+0);
   OBOSCCIM30=iCCI(NULL,PERIOD_M30,12,PRICE_CLOSE,BarShiftM30+0);
   OBOSCCIH1=iCCI(NULL,PERIOD_H1,12,PRICE_CLOSE,BarShiftH1+0);
   OBOSCCIH4=iCCI(NULL,PERIOD_H4,12,PRICE_CLOSE,BarShiftH4+0);
   OBOSCCID1=iCCI(NULL,PERIOD_D1,12,PRICE_CLOSE,BarShiftD1+0);
   OBOSCCIM1prev=iCCI(NULL,PERIOD_M1,12,PRICE_CLOSE,BarShiftM1+1);
   OBOSCCIM5prev=iCCI(NULL,PERIOD_M5,12,PRICE_CLOSE,BarShiftM5+1);
   OBOSCCIM15prev=iCCI(NULL,PERIOD_M15,12,PRICE_CLOSE,BarShiftM15+1);
   OBOSCCIM30prev=iCCI(NULL,PERIOD_M30,12,PRICE_CLOSE,BarShiftM30+1);
   OBOSCCIH1prev=iCCI(NULL,PERIOD_H1,12,PRICE_CLOSE,BarShiftH1+1);
   OBOSCCIH4prev=iCCI(NULL,PERIOD_H4,12,PRICE_CLOSE,BarShiftH4+1);
   OBOSCCID1prev=iCCI(NULL,PERIOD_D1,12,PRICE_CLOSE,BarShiftD1+1);

   OBOSMFIM1=iMFI(NULL,PERIOD_M1,14,BarShiftM1+0);
   OBOSMFIM5=iMFI(NULL,PERIOD_M5,14,BarShiftM5+0);
   OBOSMFIM15=iMFI(NULL,PERIOD_M15,14,BarShiftM15+0);
   OBOSMFIM30=iMFI(NULL,PERIOD_M30,14,BarShiftM30+0);
   OBOSMFIH1=iMFI(NULL,PERIOD_H1,14,BarShiftH1+0);
   OBOSMFIH4=iMFI(NULL,PERIOD_H4,14,BarShiftH4+0);
   OBOSMFID1=iMFI(NULL,PERIOD_D1,14,BarShiftD1+0);
   OBOSMFIM1prev=iMFI(NULL,PERIOD_M1,14,BarShiftM1+1);
   OBOSMFIM5prev=iMFI(NULL,PERIOD_M5,14,BarShiftM5+1);
   OBOSMFIM15prev=iMFI(NULL,PERIOD_M15,14,BarShiftM15+1);
   OBOSMFIM30prev=iMFI(NULL,PERIOD_M30,14,BarShiftM30+1);
   OBOSMFIH1prev=iMFI(NULL,PERIOD_H1,14,BarShiftH1+1);
   OBOSMFIH4prev=iMFI(NULL,PERIOD_H4,14,BarShiftH4+1);
   OBOSMFID1prev=iMFI(NULL,PERIOD_D1,14,BarShiftD1+1);

   OBOSWPRM1=iWPR(NULL,PERIOD_M1,14,BarShiftM1+0);
   OBOSWPRM5=iWPR(NULL,PERIOD_M5,14,BarShiftM5+0);
   OBOSWPRM15=iWPR(NULL,PERIOD_M15,14,BarShiftM15+0);
   OBOSWPRM30=iWPR(NULL,PERIOD_M30,14,BarShiftM30+0);
   OBOSWPRH1=iWPR(NULL,PERIOD_H1,14,BarShiftH1+0);
   OBOSWPRH4=iWPR(NULL,PERIOD_H4,14,BarShiftH4+0);
   OBOSWPRD1=iWPR(NULL,PERIOD_D1,14,BarShiftD1+0);
   OBOSWPRM1prev=iWPR(NULL,PERIOD_M1,14,BarShiftM1+1);
   OBOSWPRM5prev=iWPR(NULL,PERIOD_M5,14,BarShiftM5+1);
   OBOSWPRM15prev=iWPR(NULL,PERIOD_M15,14,BarShiftM15+1);
   OBOSWPRM30prev=iWPR(NULL,PERIOD_M30,14,BarShiftM30+1);
   OBOSWPRH1prev=iWPR(NULL,PERIOD_H1,14,BarShiftH1+1);
   OBOSWPRH4prev=iWPR(NULL,PERIOD_H4,14,BarShiftH4+1);
   OBOSWPRD1prev=iWPR(NULL,PERIOD_D1,14,BarShiftD1+1);

   OBOSBBHighM1=iBands(NULL,PERIOD_M1,BollingerBand_Period,BollingerBand_Deviation,0,PRICE_CLOSE,MODE_UPPER,BarShiftM1+0);
   OBOSBBHighM5=iBands(NULL,PERIOD_M5,BollingerBand_Period,BollingerBand_Deviation,0,PRICE_CLOSE,MODE_UPPER,BarShiftM5+0);
   OBOSBBHighM15=iBands(NULL,PERIOD_M15,BollingerBand_Period,BollingerBand_Deviation,0,PRICE_CLOSE,MODE_UPPER,BarShiftM15+0);
   OBOSBBHighM30=iBands(NULL,PERIOD_M30,BollingerBand_Period,BollingerBand_Deviation,0,PRICE_CLOSE,MODE_UPPER,BarShiftM30+0);
   OBOSBBHighH1=iBands(NULL,PERIOD_H1,BollingerBand_Period,BollingerBand_Deviation,0,PRICE_CLOSE,MODE_UPPER,BarShiftH1+0);
   OBOSBBHighH4=iBands(NULL,PERIOD_H4,BollingerBand_Period,BollingerBand_Deviation,0,PRICE_CLOSE,MODE_UPPER,BarShiftH4+0);
   OBOSBBHighD1=iBands(NULL,PERIOD_D1,BollingerBand_Period,BollingerBand_Deviation,0,PRICE_CLOSE,MODE_UPPER,BarShiftD1+0);
   OBOSBBLowM1=iBands(NULL,PERIOD_M1,BollingerBand_Period,BollingerBand_Deviation,0,PRICE_CLOSE,MODE_LOWER,BarShiftM1+0);
   OBOSBBLowM5=iBands(NULL,PERIOD_M5,BollingerBand_Period,BollingerBand_Deviation,0,PRICE_CLOSE,MODE_LOWER,BarShiftM5+0);
   OBOSBBLowM15=iBands(NULL,PERIOD_M15,BollingerBand_Period,BollingerBand_Deviation,0,PRICE_CLOSE,MODE_LOWER,BarShiftM15+0);
   OBOSBBLowM30=iBands(NULL,PERIOD_M30,BollingerBand_Period,BollingerBand_Deviation,0,PRICE_CLOSE,MODE_LOWER,BarShiftM30+0);
   OBOSBBLowH1=iBands(NULL,PERIOD_H1,BollingerBand_Period,BollingerBand_Deviation,0,PRICE_CLOSE,MODE_LOWER,BarShiftH1+0);
   OBOSBBLowH4=iBands(NULL,PERIOD_H4,BollingerBand_Period,BollingerBand_Deviation,0,PRICE_CLOSE,MODE_LOWER,BarShiftH4+0);
   OBOSBBLowD1=iBands(NULL,PERIOD_D1,BollingerBand_Period,BollingerBand_Deviation,0,PRICE_CLOSE,MODE_LOWER,BarShiftD1+0);

   OBOSMACDM1=iMACD(NULL,PERIOD_M1,12,26,9,PRICE_CLOSE,MODE_MAIN,BarShiftM1+0);
   OBOSMACDM5=iMACD(NULL,PERIOD_M5,12,26,9,PRICE_CLOSE,MODE_MAIN,BarShiftM5+0);
   OBOSMACDM15=iMACD(NULL,PERIOD_M15,12,26,9,PRICE_CLOSE,MODE_MAIN,BarShiftM15+0);
   OBOSMACDM30=iMACD(NULL,PERIOD_M30,12,26,9,PRICE_CLOSE,MODE_MAIN,BarShiftM30+0);
   OBOSMACDH1=iMACD(NULL,PERIOD_H1,12,26,9,PRICE_CLOSE,MODE_MAIN,BarShiftH1+0);
   OBOSMACDH4=iMACD(NULL,PERIOD_H4,12,26,9,PRICE_CLOSE,MODE_MAIN,BarShiftH4+0);
   OBOSMACDD1=iMACD(NULL,PERIOD_D1,12,26,9,PRICE_CLOSE,MODE_MAIN,BarShiftD1+0);
   OBOSMACDM1prev=iMACD(NULL,PERIOD_M1,12,26,9,PRICE_CLOSE,MODE_MAIN,BarShiftM1+1);
   OBOSMACDM5prev=iMACD(NULL,PERIOD_M5,12,26,9,PRICE_CLOSE,MODE_MAIN,BarShiftM5+1);
   OBOSMACDM15prev=iMACD(NULL,PERIOD_M15,12,26,9,PRICE_CLOSE,MODE_MAIN,BarShiftM15+1);
   OBOSMACDM30prev=iMACD(NULL,PERIOD_M30,12,26,9,PRICE_CLOSE,MODE_MAIN,BarShiftM30+1);
   OBOSMACDH1prev=iMACD(NULL,PERIOD_H1,12,26,9,PRICE_CLOSE,MODE_MAIN,BarShiftH1+1);
   OBOSMACDH4prev=iMACD(NULL,PERIOD_H4,12,26,9,PRICE_CLOSE,MODE_MAIN,BarShiftH4+1);
   OBOSMACDD1prev=iMACD(NULL,PERIOD_D1,12,26,9,PRICE_CLOSE,MODE_MAIN,BarShiftD1+1);
   OBOSMACDM1Signal=iMACD(NULL,PERIOD_M1,12,26,9,PRICE_CLOSE,MODE_SIGNAL,BarShiftM1+0);
   OBOSMACDM5Signal=iMACD(NULL,PERIOD_M5,12,26,9,PRICE_CLOSE,MODE_SIGNAL,BarShiftM5+0);
   OBOSMACDM15Signal=iMACD(NULL,PERIOD_M15,12,26,9,PRICE_CLOSE,MODE_SIGNAL,BarShiftM15+0);
   OBOSMACDM30Signal=iMACD(NULL,PERIOD_M30,12,26,9,PRICE_CLOSE,MODE_SIGNAL,BarShiftM30+0);
   OBOSMACDH1Signal=iMACD(NULL,PERIOD_H1,12,26,9,PRICE_CLOSE,MODE_SIGNAL,BarShiftH1+0);
   OBOSMACDH4Signal=iMACD(NULL,PERIOD_H4,12,26,9,PRICE_CLOSE,MODE_SIGNAL,BarShiftH4+0);
   OBOSMACDD1Signal=iMACD(NULL,PERIOD_D1,12,26,9,PRICE_CLOSE,MODE_SIGNAL,BarShiftD1+0);
   OBOSMACDM1Signalprev=iMACD(NULL,PERIOD_M1,12,26,9,PRICE_CLOSE,MODE_SIGNAL,BarShiftM1+1);
   OBOSMACDM5Signalprev=iMACD(NULL,PERIOD_M5,12,26,9,PRICE_CLOSE,MODE_SIGNAL,BarShiftM5+1);
   OBOSMACDM15Signalprev=iMACD(NULL,PERIOD_M15,12,26,9,PRICE_CLOSE,MODE_SIGNAL,BarShiftM15+1);
   OBOSMACDM30Signalprev=iMACD(NULL,PERIOD_M30,12,26,9,PRICE_CLOSE,MODE_SIGNAL,BarShiftM30+1);
   OBOSMACDH1Signalprev=iMACD(NULL,PERIOD_H1,12,26,9,PRICE_CLOSE,MODE_SIGNAL,BarShiftH1+1);
   OBOSMACDH4Signalprev=iMACD(NULL,PERIOD_H4,12,26,9,PRICE_CLOSE,MODE_SIGNAL,BarShiftH4+1);
   OBOSMACDD1Signalprev=iMACD(NULL,PERIOD_D1,12,26,9,PRICE_CLOSE,MODE_SIGNAL,BarShiftD1+1);

// + OBOS Stochs from StochGraph

   if((Close[BarShiftM1+0]>OBOSBBHighM1 && Close[BarShiftM1+0]>Close[BarShiftM1+1]) || (Close[BarShiftM1+0]<OBOSBBLowM1 && Close[BarShiftM1+0]<Close[BarShiftM1+1])) {OBOSBBM1Signal=1;}
   if((Close[BarShiftM5+0]>OBOSBBHighM5 && Close[BarShiftM5+0]>Close[BarShiftM5+1]) || (Close[BarShiftM5+0]<OBOSBBLowM5 && Close[BarShiftM5+0]<Close[BarShiftM5+1])) {OBOSBBM5Signal=1;}
   if((Close[BarShiftM15+0]>OBOSBBHighM15 && Close[BarShiftM15+0]>Close[BarShiftM15+1]) || (Close[BarShiftM15+0]<OBOSBBLowM15 && Close[BarShiftM15+0]<Close[BarShiftM15+1])) {OBOSBBM15Signal=1;}
   if((Close[BarShiftM30+0]>OBOSBBHighM30 && Close[BarShiftM30+0]>Close[BarShiftM30+1]) || (Close[BarShiftM30+0]<OBOSBBLowM30 && Close[BarShiftM30+0]<Close[BarShiftM30+1])) {OBOSBBM30Signal=1;}
   if((Close[BarShiftH1+0]>OBOSBBHighH1 && Close[BarShiftH1+0]>Close[BarShiftH1+1]) || (Close[BarShiftH1+0]<OBOSBBLowH1 && Close[BarShiftH1+0]<Close[BarShiftH1+1])) {OBOSBBH1Signal=1;}
   if((Close[BarShiftH4+0]>OBOSBBHighH4 && Close[BarShiftH4+0]>Close[BarShiftH4+1]) || (Close[BarShiftH4+0]<OBOSBBLowH4 && Close[BarShiftH4+0]<Close[BarShiftH4+1])) {OBOSBBH4Signal=1;}
   if((Close[BarShiftD1+0]>OBOSBBHighD1 && Close[BarShiftD1+0]>Close[BarShiftD1+1]) || (Close[BarShiftD1+0]<OBOSBBLowD1 && Close[BarShiftD1+0]<Close[BarShiftD1+1])) {OBOSBBD1Signal=1;}

   if(Close[BarShiftM1+0]>OBOSBBHighM1 && Close[BarShiftM1+0]<Close[BarShiftM1+1]) {OBOSBBM1Signal=3;}
   if(Close[BarShiftM5+0]>OBOSBBHighM5 && Close[BarShiftM5+0]<Close[BarShiftM5+1]) {OBOSBBM5Signal=3;}
   if(Close[BarShiftM15+0]>OBOSBBHighM15 && Close[BarShiftM15+0]<Close[BarShiftM15+1]) {OBOSBBM15Signal=3;}
   if(Close[BarShiftM30+0]>OBOSBBHighM30 && Close[BarShiftM30+0]<Close[BarShiftM30+1]) {OBOSBBM30Signal=3;}
   if(Close[BarShiftH1+0]>OBOSBBHighH1 && Close[BarShiftH1+0]<Close[BarShiftH1+1]) {OBOSBBH1Signal=3;}
   if(Close[BarShiftH4+0]>OBOSBBHighH4 && Close[BarShiftH4+0]<Close[BarShiftH4+1]) {OBOSBBH4Signal=3;}
   if(Close[BarShiftD1+0]>OBOSBBHighD1 && Close[BarShiftD1+0]<Close[BarShiftD1+1]) {OBOSBBD1Signal=3;}

   if(Close[BarShiftM1+0]<OBOSBBLowM1 && Close[BarShiftM1+0]>Close[BarShiftM1+1]) {OBOSBBM1Signal=2;}
   if(Close[BarShiftM5+0]<OBOSBBLowM5 && Close[BarShiftM5+0]>Close[BarShiftM5+1]) {OBOSBBM5Signal=2;}
   if(Close[BarShiftM15+0]<OBOSBBLowM15 && Close[BarShiftM15+0]>Close[BarShiftM15+1]) {OBOSBBM15Signal=2;}
   if(Close[BarShiftM30+0]<OBOSBBLowM30 && Close[BarShiftM30+0]>Close[BarShiftM30+1]) {OBOSBBM30Signal=2;}
   if(Close[BarShiftH1+0]<OBOSBBLowH1 && Close[BarShiftH1+0]>Close[BarShiftH1+1]) {OBOSBBH1Signal=2;}
   if(Close[BarShiftH4+0]<OBOSBBLowH4 && Close[BarShiftH4+0]>Close[BarShiftH4+1]) {OBOSBBH4Signal=2;}
   if(Close[BarShiftD1+0]<OBOSBBLowD1 && Close[BarShiftD1+0]>Close[BarShiftD1+1]) {OBOSBBD1Signal=2;}
// --------------------------------------------------------------------------------------      
   if((OBOSRSIM1>=RelativeStrengthIndex_SELL && OBOSRSIM1>OBOSRSIM1prev) || (OBOSRSIM1<=RelativeStrengthIndex_BUY && OBOSRSIM1<OBOSRSIM1prev)) {OBOSRSIM1Signal=1;}
   if((OBOSRSIM5>=RelativeStrengthIndex_SELL && OBOSRSIM5>OBOSRSIM5prev) || (OBOSRSIM5<=RelativeStrengthIndex_BUY && OBOSRSIM5<OBOSRSIM5prev)) {OBOSRSIM5Signal=1;}
   if((OBOSRSIM15>=RelativeStrengthIndex_SELL && OBOSRSIM15>OBOSRSIM15prev) || (OBOSRSIM15<=RelativeStrengthIndex_BUY && OBOSRSIM15<OBOSRSIM15prev)) {OBOSRSIM15Signal=1;}
   if((OBOSRSIM30>=RelativeStrengthIndex_SELL && OBOSRSIM30>OBOSRSIM30prev) || (OBOSRSIM30<=RelativeStrengthIndex_BUY && OBOSRSIM30<OBOSRSIM30prev)) {OBOSRSIM30Signal=1;}
   if((OBOSRSIH1>=RelativeStrengthIndex_SELL && OBOSRSIH1>OBOSRSIH1prev) || (OBOSRSIH1<=RelativeStrengthIndex_BUY && OBOSRSIH1<OBOSRSIH1prev)) {OBOSRSIH1Signal=1;}
   if((OBOSRSIH4>=RelativeStrengthIndex_SELL && OBOSRSIH4>OBOSRSIH4prev) || (OBOSRSIH4<=RelativeStrengthIndex_BUY && OBOSRSIH4<OBOSRSIH4prev)) {OBOSRSIH4Signal=1;}
   if((OBOSRSID1>=RelativeStrengthIndex_SELL && OBOSRSID1>OBOSRSID1prev) || (OBOSRSID1<=RelativeStrengthIndex_BUY && OBOSRSID1<OBOSRSID1prev)) {OBOSRSID1Signal=1;}

   if(OBOSRSIM1>=RelativeStrengthIndex_SELL && OBOSRSIM1<OBOSRSIM1prev) {OBOSRSIM1Signal=3;}
   if(OBOSRSIM5>=RelativeStrengthIndex_SELL && OBOSRSIM5<OBOSRSIM5prev) {OBOSRSIM5Signal=3;}
   if(OBOSRSIM15>=RelativeStrengthIndex_SELL && OBOSRSIM15<OBOSRSIM15prev) {OBOSRSIM15Signal=3;}
   if(OBOSRSIM30>=RelativeStrengthIndex_SELL && OBOSRSIM30<OBOSRSIM30prev) {OBOSRSIM30Signal=3;}
   if(OBOSRSIH1>=RelativeStrengthIndex_SELL && OBOSRSIH1<OBOSRSIH1prev) {OBOSRSIH1Signal=3;}
   if(OBOSRSIH4>=RelativeStrengthIndex_SELL && OBOSRSIH4<OBOSRSIH4prev) {OBOSRSIH4Signal=3;}
   if(OBOSRSID1>=RelativeStrengthIndex_SELL && OBOSRSID1<OBOSRSID1prev) {OBOSRSID1Signal=3;}

   if(OBOSRSIM1<=RelativeStrengthIndex_BUY && OBOSRSIM1>OBOSRSIM1prev) {OBOSRSIM1Signal=2;}
   if(OBOSRSIM5<=RelativeStrengthIndex_BUY && OBOSRSIM5>OBOSRSIM5prev) {OBOSRSIM5Signal=2;}
   if(OBOSRSIM15<=RelativeStrengthIndex_BUY && OBOSRSIM15>OBOSRSIM15prev) {OBOSRSIM15Signal=2;}
   if(OBOSRSIM30<=RelativeStrengthIndex_BUY && OBOSRSIM30>OBOSRSIM30prev) {OBOSRSIM30Signal=2;}
   if(OBOSRSIH1<=RelativeStrengthIndex_BUY && OBOSRSIH1>OBOSRSIH1prev) {OBOSRSIH1Signal=2;}
   if(OBOSRSIH4<=RelativeStrengthIndex_BUY && OBOSRSIH4>OBOSRSIH4prev) {OBOSRSIH4Signal=2;}
   if(OBOSRSID1<=RelativeStrengthIndex_BUY && OBOSRSID1>OBOSRSID1prev) {OBOSRSID1Signal=2;}

// --------------------------------------------------------------------------------------      
   if((OBOSCCIM1>=CommodityChannelIndex_SELL && OBOSCCIM1>OBOSCCIM1prev) || (OBOSCCIM1<=CommodityChannelIndex_BUY && OBOSCCIM1<OBOSCCIM1prev)) {OBOSCCIM1Signal=1;}
   if((OBOSCCIM5>=CommodityChannelIndex_SELL && OBOSCCIM5>OBOSCCIM5prev) || (OBOSCCIM5<=CommodityChannelIndex_BUY && OBOSCCIM5<OBOSCCIM5prev)) {OBOSCCIM5Signal=1;}
   if((OBOSCCIM15>=CommodityChannelIndex_SELL && OBOSCCIM15>OBOSCCIM15prev) || (OBOSCCIM15<=CommodityChannelIndex_BUY && OBOSCCIM15<OBOSCCIM15prev)) {OBOSCCIM15Signal=1;}
   if((OBOSCCIM30>=CommodityChannelIndex_SELL && OBOSCCIM30>OBOSCCIM30prev) || (OBOSCCIM30<=CommodityChannelIndex_BUY && OBOSCCIM30<OBOSCCIM30prev)) {OBOSCCIM30Signal=1;}
   if((OBOSCCIH1>=CommodityChannelIndex_SELL && OBOSCCIH1>OBOSCCIH1prev) || (OBOSCCIH1<=CommodityChannelIndex_BUY && OBOSCCIH1<OBOSCCIH1prev)) {OBOSCCIH1Signal=1;}
   if((OBOSCCIH4>=CommodityChannelIndex_SELL && OBOSCCIH4>OBOSCCIH4prev) || (OBOSCCIH4<=CommodityChannelIndex_BUY && OBOSCCIH4<OBOSCCIH4prev)) {OBOSCCIH4Signal=1;}
   if((OBOSCCID1>=CommodityChannelIndex_SELL && OBOSCCID1>OBOSCCID1prev) || (OBOSCCID1<=CommodityChannelIndex_BUY && OBOSCCID1<OBOSCCID1prev)) {OBOSCCID1Signal=1;}

   if(OBOSCCIM1>=CommodityChannelIndex_SELL && OBOSCCIM1<OBOSCCIM1prev) {OBOSCCIM1Signal=3;}
   if(OBOSCCIM5>=CommodityChannelIndex_SELL && OBOSCCIM5<OBOSCCIM5prev) {OBOSCCIM5Signal=3;}
   if(OBOSCCIM15>=CommodityChannelIndex_SELL && OBOSCCIM15<OBOSCCIM15prev) {OBOSCCIM15Signal=3;}
   if(OBOSCCIM30>=CommodityChannelIndex_SELL && OBOSCCIM30<OBOSCCIM30prev) {OBOSCCIM30Signal=3;}
   if(OBOSCCIH1>=CommodityChannelIndex_SELL && OBOSCCIH1<OBOSCCIH1prev) {OBOSCCIH1Signal=3;}
   if(OBOSCCIH4>=CommodityChannelIndex_SELL && OBOSCCIH4<OBOSCCIH4prev) {OBOSCCIH4Signal=3;}
   if(OBOSCCID1>=CommodityChannelIndex_SELL && OBOSCCID1<OBOSCCID1prev) {OBOSCCID1Signal=3;}

   if(OBOSCCIM1<=CommodityChannelIndex_BUY && OBOSCCIM1>OBOSCCIM1prev) {OBOSCCIM1Signal=2;}
   if(OBOSCCIM5<=CommodityChannelIndex_BUY && OBOSCCIM5>OBOSCCIM5prev) {OBOSCCIM5Signal=2;}
   if(OBOSCCIM15<=CommodityChannelIndex_BUY && OBOSCCIM15>OBOSCCIM15prev) {OBOSCCIM15Signal=2;}
   if(OBOSCCIM30<=CommodityChannelIndex_BUY && OBOSCCIM30>OBOSCCIM30prev) {OBOSCCIM30Signal=2;}
   if(OBOSCCIH1<=CommodityChannelIndex_BUY && OBOSCCIH1>OBOSCCIH1prev) {OBOSCCIH1Signal=2;}
   if(OBOSCCIH4<=CommodityChannelIndex_BUY && OBOSCCIH4>OBOSCCIH4prev) {OBOSCCIH4Signal=2;}
   if(OBOSCCID1<=CommodityChannelIndex_BUY && OBOSCCID1>OBOSCCID1prev) {OBOSCCID1Signal=2;}

// --------------------------------------------------------------------------------------      
   if((OBOSMFIM1>=MoneyFlowIndex_SELL && OBOSMFIM1>OBOSMFIM1prev) || (OBOSMFIM1<=MoneyFlowIndex_BUY && OBOSMFIM1<OBOSMFIM1prev)) {OBOSMFIM1Signal=1;}
   if((OBOSMFIM5>=MoneyFlowIndex_SELL && OBOSMFIM5>OBOSMFIM5prev) || (OBOSMFIM5<=MoneyFlowIndex_BUY && OBOSMFIM5<OBOSMFIM5prev)) {OBOSMFIM5Signal=1;}
   if((OBOSMFIM15>=MoneyFlowIndex_SELL && OBOSMFIM15>OBOSMFIM15prev) || (OBOSMFIM15<=MoneyFlowIndex_BUY && OBOSMFIM15<OBOSMFIM15prev)) {OBOSMFIM15Signal=1;}
   if((OBOSMFIM30>=MoneyFlowIndex_SELL && OBOSMFIM30>OBOSMFIM30prev) || (OBOSMFIM30<=MoneyFlowIndex_BUY && OBOSMFIM30<OBOSMFIM30prev)) {OBOSMFIM30Signal=1;}
   if((OBOSMFIH1>=MoneyFlowIndex_SELL && OBOSMFIH1>OBOSMFIH1prev) || (OBOSMFIH1<=MoneyFlowIndex_BUY && OBOSMFIH1<OBOSMFIH1prev)) {OBOSMFIH1Signal=1;}
   if((OBOSMFIH4>=MoneyFlowIndex_SELL && OBOSMFIH4>OBOSMFIH4prev) || (OBOSMFIH4<=MoneyFlowIndex_BUY && OBOSMFIH4<OBOSMFIH4prev)) {OBOSMFIH4Signal=1;}
   if((OBOSMFID1>=MoneyFlowIndex_SELL && OBOSMFID1>OBOSMFID1prev) || (OBOSMFID1<=MoneyFlowIndex_BUY && OBOSMFID1<OBOSMFID1prev)) {OBOSMFID1Signal=1;}

   if(OBOSMFIM1>=MoneyFlowIndex_SELL && OBOSMFIM1<OBOSMFIM1prev) {OBOSMFIM1Signal=3;}
   if(OBOSMFIM5>=MoneyFlowIndex_SELL && OBOSMFIM5<OBOSMFIM5prev) {OBOSMFIM5Signal=3;}
   if(OBOSMFIM15>=MoneyFlowIndex_SELL && OBOSMFIM15<OBOSMFIM15prev) {OBOSMFIM15Signal=3;}
   if(OBOSMFIM30>=MoneyFlowIndex_SELL && OBOSMFIM30<OBOSMFIM30prev) {OBOSMFIM30Signal=3;}
   if(OBOSMFIH1>=MoneyFlowIndex_SELL && OBOSMFIH1<OBOSMFIH1prev) {OBOSMFIH1Signal=3;}
   if(OBOSMFIH4>=MoneyFlowIndex_SELL && OBOSMFIH4<OBOSMFIH4prev) {OBOSMFIH4Signal=3;}
   if(OBOSMFID1>=MoneyFlowIndex_SELL && OBOSMFID1<OBOSMFID1prev) {OBOSMFID1Signal=3;}

   if(OBOSMFIM1<=MoneyFlowIndex_BUY && OBOSMFIM1>OBOSMFIM1prev) {OBOSMFIM1Signal=2;}
   if(OBOSMFIM5<=MoneyFlowIndex_BUY && OBOSMFIM5>OBOSMFIM5prev) {OBOSMFIM5Signal=2;}
   if(OBOSMFIM15<=MoneyFlowIndex_BUY && OBOSMFIM15>OBOSMFIM15prev) {OBOSMFIM15Signal=2;}
   if(OBOSMFIM30<=MoneyFlowIndex_BUY && OBOSMFIM30>OBOSMFIM30prev) {OBOSMFIM30Signal=2;}
   if(OBOSMFIH1<=MoneyFlowIndex_BUY && OBOSMFIH1>OBOSMFIH1prev) {OBOSMFIH1Signal=2;}
   if(OBOSMFIH4<=MoneyFlowIndex_BUY && OBOSMFIH4>OBOSMFIH4prev) {OBOSMFIH4Signal=2;}
   if(OBOSMFID1<=MoneyFlowIndex_BUY && OBOSMFID1>OBOSMFID1prev) {OBOSMFID1Signal=2;}

// --------------------------------------------------------------------------------------      
   if((OBOSWPRM1>=WilliamsPercentRange_SELL && OBOSWPRM1>OBOSWPRM1prev) || (OBOSWPRM1<=WilliamsPercentRange_BUY && OBOSWPRM1<OBOSWPRM1prev)) {OBOSWPRM1Signal=1;}
   if((OBOSWPRM5>=WilliamsPercentRange_SELL && OBOSWPRM5>OBOSWPRM5prev) || (OBOSWPRM5<=WilliamsPercentRange_BUY && OBOSWPRM5<OBOSWPRM5prev)) {OBOSWPRM5Signal=1;}
   if((OBOSWPRM15>=WilliamsPercentRange_SELL && OBOSWPRM15>OBOSWPRM15prev) || (OBOSWPRM15<=WilliamsPercentRange_BUY && OBOSWPRM15<OBOSWPRM15prev)) {OBOSWPRM15Signal=1;}
   if((OBOSWPRM30>=WilliamsPercentRange_SELL && OBOSWPRM30>OBOSWPRM30prev) || (OBOSWPRM30<=WilliamsPercentRange_BUY && OBOSWPRM30<OBOSWPRM30prev)) {OBOSWPRM30Signal=1;}
   if((OBOSWPRH1>=WilliamsPercentRange_SELL && OBOSWPRH1>OBOSWPRH1prev) || (OBOSWPRH1<=WilliamsPercentRange_BUY && OBOSWPRH1<OBOSWPRH1prev)) {OBOSWPRH1Signal=1;}
   if((OBOSWPRH4>=WilliamsPercentRange_SELL && OBOSWPRH4>OBOSWPRH4prev) || (OBOSWPRH4<=WilliamsPercentRange_BUY && OBOSWPRH4<OBOSWPRH4prev)) {OBOSWPRH4Signal=1;}
   if((OBOSWPRD1>=WilliamsPercentRange_SELL && OBOSWPRD1>OBOSWPRD1prev) || (OBOSWPRD1<=WilliamsPercentRange_BUY && OBOSWPRD1<OBOSWPRD1prev)) {OBOSWPRD1Signal=1;}

   if(OBOSWPRM1>=WilliamsPercentRange_SELL && OBOSWPRM1<OBOSWPRM1prev) {OBOSWPRM1Signal=3;}
   if(OBOSWPRM5>=WilliamsPercentRange_SELL && OBOSWPRM5<OBOSWPRM5prev) {OBOSWPRM5Signal=3;}
   if(OBOSWPRM15>=WilliamsPercentRange_SELL && OBOSWPRM15<OBOSWPRM15prev) {OBOSWPRM15Signal=3;}
   if(OBOSWPRM30>=WilliamsPercentRange_SELL && OBOSWPRM30<OBOSWPRM30prev) {OBOSWPRM30Signal=3;}
   if(OBOSWPRH1>=WilliamsPercentRange_SELL && OBOSWPRH1<OBOSWPRH1prev) {OBOSWPRH1Signal=3;}
   if(OBOSWPRH4>=WilliamsPercentRange_SELL && OBOSWPRH4<OBOSWPRH4prev) {OBOSWPRH4Signal=3;}
   if(OBOSWPRD1>=WilliamsPercentRange_SELL && OBOSWPRD1<OBOSWPRD1prev) {OBOSWPRD1Signal=3;}

   if(OBOSWPRM1<=WilliamsPercentRange_BUY && OBOSWPRM1>OBOSWPRM1prev) {OBOSWPRM1Signal=2;}
   if(OBOSWPRM5<=WilliamsPercentRange_BUY && OBOSWPRM5>OBOSWPRM5prev) {OBOSWPRM5Signal=2;}
   if(OBOSWPRM15<=WilliamsPercentRange_BUY && OBOSWPRM15>OBOSWPRM15prev) {OBOSWPRM15Signal=2;}
   if(OBOSWPRM30<=WilliamsPercentRange_BUY && OBOSWPRM30>OBOSWPRM30prev) {OBOSWPRM30Signal=2;}
   if(OBOSWPRH1<=WilliamsPercentRange_BUY && OBOSWPRH1>OBOSWPRH1prev) {OBOSWPRH1Signal=2;}
   if(OBOSWPRH4<=WilliamsPercentRange_BUY && OBOSWPRH4>OBOSWPRH4prev) {OBOSWPRH4Signal=2;}
   if(OBOSWPRD1<=WilliamsPercentRange_BUY && OBOSWPRD1>OBOSWPRD1prev) {OBOSWPRD1Signal=2;}

// --------------------------------------------------------------------------------------      
   if((M1stochK>=Stochastic_SELL &&  M1stochK>M1stochD) ||(M1stochK<=Stochastic_BUY && M1stochK<M1stochD)) {OBOSSTOM1Signal=1;}
   if((M5stochK>=Stochastic_SELL && M5stochK>M5stochD) || (M5stochK<=Stochastic_BUY && M5stochK<M5stochD)) {OBOSSTOM5Signal=1;}
   if((M15stochK>=Stochastic_SELL && M15stochK>M15stochD) || (M15stochK<=Stochastic_BUY && M15stochK<M15stochD)) {OBOSSTOM15Signal=1;}
   if((M30stochK>=Stochastic_SELL && M30stochK>M30stochD) || (M30stochK<=Stochastic_BUY && M30stochK<M30stochD)) {OBOSSTOM30Signal=1;}
   if((H1stochK>=Stochastic_SELL &&  H1stochK>H1stochD) || (H1stochK<=Stochastic_BUY && H1stochK<H1stochD)) {OBOSSTOH1Signal=1;}
   if((H4stochK>=Stochastic_SELL &&  H4stochK>H4stochD) || (H4stochK<=Stochastic_BUY && H4stochK<H4stochD)) {OBOSSTOH4Signal=1;}
   if((D1stochK>=Stochastic_SELL && D1stochK>D1stochD) || (D1stochK<=Stochastic_BUY && D1stochK<D1stochD)) {OBOSSTOD1Signal=1;}

   if(M1stochK>=Stochastic_SELL && M1stochK<M1stochKprev && M1stochK<=M1stochD) {OBOSSTOM1Signal=3;}
   if(M5stochK>=Stochastic_SELL && M5stochK<M5stochKprev && M5stochK<=M5stochD) {OBOSSTOM5Signal=3;}
   if(M15stochK>=Stochastic_SELL && M15stochK<M15stochKprev && M15stochK<=M15stochD) {OBOSSTOM15Signal=3;}
   if(M30stochK>=Stochastic_SELL && M30stochK<M30stochKprev && M30stochK<=M30stochD) {OBOSSTOM30Signal=3;}
   if(H1stochK>=Stochastic_SELL && H1stochK<H1stochKprev && H1stochK<=H1stochD) {OBOSSTOH1Signal=3;}
   if(H4stochK>=Stochastic_SELL && H4stochK<H4stochKprev && H4stochK<=H4stochD) {OBOSSTOH4Signal=3;}
   if(D1stochK>=Stochastic_SELL && D1stochK<D1stochKprev && D1stochK<=D1stochD) {OBOSSTOD1Signal=3;}

   if(M1stochK<=Stochastic_BUY && M1stochK>M1stochKprev && M1stochK>=M1stochD) {OBOSSTOM1Signal=2;}
   if(M5stochK<=Stochastic_BUY && M5stochK>M5stochKprev && M5stochK>=M5stochD) {OBOSSTOM5Signal=2;}
   if(M15stochK<=Stochastic_BUY && M15stochK>M15stochKprev && M15stochK>=M15stochD) {OBOSSTOM15Signal=2;}
   if(M30stochK<=Stochastic_BUY && M30stochK>M30stochKprev && M30stochK>=M30stochD) {OBOSSTOM30Signal=2;}
   if(H1stochK<=Stochastic_BUY && H1stochK>H1stochKprev && H1stochK>=H1stochD) {OBOSSTOH1Signal=2;}
   if(H4stochK<=Stochastic_BUY && H4stochK>H4stochKprev && H4stochK>=H4stochD) {OBOSSTOH4Signal=2;}
   if(D1stochK<=Stochastic_BUY && D1stochK>D1stochKprev && D1stochK>=D1stochD) {OBOSSTOD1Signal=2;}

// --------------------------------------------------------------------------------------      
   if((OBOSMACDM1>0 && OBOSMACDM1<OBOSMACDM1prev && OBOSMACDM1>OBOSMACDM1Signal) || (OBOSMACDM1<0 && OBOSMACDM1>OBOSMACDM1prev && OBOSMACDM1<OBOSMACDM1Signal)) {OBOSMACM1Signal=1;}
   if((OBOSMACDM5>0 && OBOSMACDM5<OBOSMACDM5prev && OBOSMACDM5>OBOSMACDM5Signal) || (OBOSMACDM5<0 && OBOSMACDM5>OBOSMACDM5prev && OBOSMACDM5<OBOSMACDM5Signal)) {OBOSMACM5Signal=1;}
   if((OBOSMACDM15>0 && OBOSMACDM15<OBOSMACDM15prev && OBOSMACDM15>OBOSMACDM15Signal) || (OBOSMACDM15<0 && OBOSMACDM15>OBOSMACDM15prev && OBOSMACDM15<OBOSMACDM15Signal)) {OBOSMACM15Signal=1;}
   if((OBOSMACDM30>0 && OBOSMACDM30<OBOSMACDM30prev && OBOSMACDM30>OBOSMACDM30Signal) || (OBOSMACDM30<0 && OBOSMACDM30>OBOSMACDM30prev && OBOSMACDM30<OBOSMACDM30Signal)) {OBOSMACM30Signal=1;}
   if((OBOSMACDH1>0 && OBOSMACDH1<OBOSMACDH1prev && OBOSMACDH1>OBOSMACDH1Signal) || (OBOSMACDH1<0 && OBOSMACDH1>OBOSMACDH1prev && OBOSMACDH1<OBOSMACDH1Signal)) {OBOSMACH1Signal=1;}
   if((OBOSMACDH4>0 && OBOSMACDH4<OBOSMACDH4prev && OBOSMACDH4>OBOSMACDH4Signal) || (OBOSMACDH4<0 && OBOSMACDH4>OBOSMACDH4prev && OBOSMACDH4<OBOSMACDH4Signal)) {OBOSMACH4Signal=1;}
   if((OBOSMACDD1>0 && OBOSMACDD1<OBOSMACDD1prev && OBOSMACDD1>OBOSMACDD1Signal) || (OBOSMACDD1<0 && OBOSMACDD1>OBOSMACDD1prev && OBOSMACDD1<OBOSMACDD1Signal)) {OBOSMACD1Signal=1;}

   if(OBOSMACDM1>0 && OBOSMACDM1<OBOSMACDM1Signal && OBOSMACDM1prev>OBOSMACDM1Signalprev) {OBOSMACM1Signal=3;}
   if(OBOSMACDM5>0 && OBOSMACDM5<OBOSMACDM5Signal && OBOSMACDM5prev>OBOSMACDM5Signalprev) {OBOSMACM5Signal=3;}
   if(OBOSMACDM15>0 && OBOSMACDM15<OBOSMACDM15Signal && OBOSMACDM15prev>OBOSMACDM15Signalprev) {OBOSMACM15Signal=3;}
   if(OBOSMACDM30>0 && OBOSMACDM30<OBOSMACDM30Signal && OBOSMACDM30prev>OBOSMACDM30Signalprev) {OBOSMACM30Signal=3;}
   if(OBOSMACDH1>0 && OBOSMACDH1<OBOSMACDH1Signal && OBOSMACDH1prev>OBOSMACDH1Signalprev) {OBOSMACH1Signal=3;}
   if(OBOSMACDH4>0 && OBOSMACDH4<OBOSMACDH4Signal && OBOSMACDH4prev>OBOSMACDH4Signalprev) {OBOSMACH4Signal=3;}
   if(OBOSMACDD1>0 && OBOSMACDD1<OBOSMACDD1Signal && OBOSMACDD1prev>OBOSMACDD1Signalprev) {OBOSMACD1Signal=3;}

   if(OBOSMACDM1<0 && OBOSMACDM1>OBOSMACDM1Signal && OBOSMACDM1prev<OBOSMACDM1Signalprev) {OBOSMACM1Signal=2;}
   if(OBOSMACDM5<0 && OBOSMACDM5>OBOSMACDM5Signal && OBOSMACDM5prev<OBOSMACDM5Signalprev) {OBOSMACM5Signal=2;}
   if(OBOSMACDM15<0 && OBOSMACDM15>OBOSMACDM15Signal && OBOSMACDM15prev<OBOSMACDM15Signalprev) {OBOSMACM15Signal=2;}
   if(OBOSMACDM30<0 && OBOSMACDM30>OBOSMACDM30Signal && OBOSMACDM30prev<OBOSMACDM30Signalprev) {OBOSMACM30Signal=2;}
   if(OBOSMACDH1<0 && OBOSMACDH1>OBOSMACDH1Signal && OBOSMACDH1prev<OBOSMACDH1Signalprev) {OBOSMACH1Signal=2;}
   if(OBOSMACDH4<0 && OBOSMACDH4>OBOSMACDH4Signal && OBOSMACDH4prev<OBOSMACDH4Signalprev) {OBOSMACH4Signal=2;}
   if(OBOSMACDD1<0 && OBOSMACDD1>OBOSMACDD1Signal && OBOSMACDD1prev<OBOSMACDD1Signalprev) {OBOSMACD1Signal=2;}

// Current Signals --------------------------------------------------------------------------------
   if(Include_MAXover) {SignalBuy_MAXover=MAXoverSignal==1; SignalSell_MAXover=MAXoverSignal==0;}
   if(Include_MACD) {SignalBuy_MACD = (MACD==3 || MACD==0); SignalSell_MACD = (MACD==1 || MACD==2);}
   if(Include_PSAR) {SignalBuy_PSAR = PSARCurrent<Close[BarShift+0]; SignalSell_PSAR = PSARCurrent>Close[BarShift+0];}
   if(Include_MA) {SignalBuy_MA=MACurrent>MAPrevious; SignalSell_MA=MACurrent<MAPrevious;}
   if(Include_STOCH) {SignalBuy_STOCH=StochK>StochKprev; SignalSell_STOCH=StochK<StochKprev;}
   if(Include_WPR) {SignalBuy_WPR=WPR>-50; SignalSell_WPR=WPR<-50;}
   if(Include_PriceDirection) {SignalBuy_Price=Close[BarShift+0]>Close[BarShift+1]; SignalSell_Price=Close[BarShift+0]<Close[BarShift+1];}
// Multi Signals -------------
   if(Include_M1_MA) {M1Buy = MAM1>MAM1prev; M1Sell = MAM1<MAM1prev;}
   if(Include_M5_MA) {M5Buy = MAM5>MAM5prev; M5Sell = MAM5<MAM5prev;}
   if(Include_M15_MA) {M15Buy = MAM15>MAM15prev; M15Sell = MAM15<MAM15prev;}
   if(Include_M30_MA) {M30Buy = MAM30>MAM30prev; M30Sell = MAM30<MAM30prev;}
   if(Include_H1_MA) {H1Buy = MAH1>MAH1prev; H1Sell = MAH1<MAH1prev;}
   if(Include_H4_MA) {H4Buy = MAH4>MAH4prev; H4Sell = MAH4<MAH4prev;}
   if(Include_D1_MA) {D1Buy = MAD1>MAD1prev; D1Sell = MAD1<MAD1prev;}

   if(!Include_MAXover) {SignalBuy_MAXover=true; SignalSell_MAXover=true;}
   if(!Include_MACD) {SignalBuy_MACD = true; SignalSell_MACD = true;}
   if(!Include_PSAR) {SignalBuy_PSAR = true; SignalSell_PSAR = true;}
   if(!Include_MA) {SignalBuy_MA=true; SignalSell_MA=true;}
   if(!Include_STOCH) {SignalBuy_STOCH=true; SignalSell_STOCH=true;}
   if(!Include_WPR) {SignalBuy_WPR=true; SignalSell_WPR=true;}
   if(!Include_PriceDirection) {SignalBuy_Price=true; SignalSell_Price=true;}

   if(!Include_M1_MA) {M1Buy = true; M1Sell = true;}
   if(!Include_M5_MA) {M5Buy = true; M5Sell = true;}
   if(!Include_M15_MA) {M15Buy = true; M15Sell = true;}
   if(!Include_M30_MA) {M30Buy = true; M30Sell = true;}
   if(!Include_H1_MA) {H1Buy = true; H1Sell = true;}
   if(!Include_H4_MA) {H4Buy = true; H4Sell = true;}
   if(!Include_D1_MA) {D1Buy = true; D1Sell = true;}

//Signal Sell  ------------------------ 
   if(SignalSell_MACD && SignalSell_MAXover && SignalSell_WPR && SignalSell_MA && SignalSell_STOCH && SignalSell_Price && SignalSell_PSAR && M1Sell && M5Sell && M15Sell && M30Sell && H1Sell && H4Sell && D1Sell)
     {
      Signal=1;
     }

//Signal Buy  ------------------------  
   if(SignalBuy_MACD && SignalBuy_MAXover && SignalBuy_WPR && SignalBuy_MA && SignalBuy_STOCH && SignalBuy_Price && SignalBuy_PSAR && M1Buy && M5Buy && M15Buy && M30Buy && H1Buy && H4Buy && D1Buy)
     {
      Signal=2;
     }

//--------------------------------------       
   objectBlank();
   paintM1(M1stochK);
   paintM5(M5stochK);
   paintM15(M15stochK);
   paintM30(M30stochK);
   paintH1(H1stochK);
   paintH4(H4stochK);
   paintD1(D1stochK);
   paintLine();
   paintMA_M1(trendM1);
   paintMA_M5(trendM5);
   paintMA_M15(trendM15);
   paintMA_M30(trendM30);
   paintMA_H1(trendH1);
   paintMA_H4(trendH4);
   paintMA_D1(trendD1);
   paint2Line();
   paintWPRUp(WPRValueUp);
   paintWPRDown(WPRValueDown);
   paintWPRValue(WPR);
   paintSpread(Spread);
   paintSpreadLines();
   paintPSAR(PSAR);
   paintMAXover(MAXoverSignal);
   paintMACD(MACD);
   paintBars();
   paintBarValue1(Bar1percent);
   paintBarValue2(Bar2percent);
   paintBarValue3(Bar3percent);
   paintBarValue4(Bar4percent);
   paintBarValue5(Bar5percent);
   paintBar1(Bar1Col);
   paintBar2(Bar2Col);
   paintBar3(Bar3Col);
   paintBar4(Bar4Col);
   paintBar5(Bar5Col);
   paintBarReading(BarReading);
   paintSignal(Signal);
   if(DisplayTrendGraph && !DisplayCompact)
     {
      paintTrendGraph();
      paintTGMA1M1(TGMA1M1Signal);
      paintTGMA1M5(TGMA1M5Signal);
      paintTGMA1M15(TGMA1M15Signal);
      paintTGMA1M30(TGMA1M30Signal);
      paintTGMA1H1(TGMA1H1Signal);
      paintTGMA1H4(TGMA1H4Signal);
      paintTGMA1D1(TGMA1D1Signal);
      paintTGMA2M1(TGMA2M1Signal);
      paintTGMA2M5(TGMA2M5Signal);
      paintTGMA2M15(TGMA2M15Signal);
      paintTGMA2M30(TGMA2M30Signal);
      paintTGMA2H1(TGMA2H1Signal);
      paintTGMA2H4(TGMA2H4Signal);
      paintTGMA2D1(TGMA2D1Signal);
      paintTGMA3M1(TGMA3M1Signal);
      paintTGMA3M5(TGMA3M5Signal);
      paintTGMA3M15(TGMA3M15Signal);
      paintTGMA3M30(TGMA3M30Signal);
      paintTGMA3H1(TGMA3H1Signal);
      paintTGMA3H4(TGMA3H4Signal);
      paintTGMA3D1(TGMA3D1Signal);
      paintTGMA4M1(TGMA4M1Signal);
      paintTGMA4M5(TGMA4M5Signal);
      paintTGMA4M15(TGMA4M15Signal);
      paintTGMA4M30(TGMA4M30Signal);
      paintTGMA4H1(TGMA4H1Signal);
      paintTGMA4H4(TGMA4H4Signal);
      paintTGMA4D1(TGMA4D1Signal);
      paintTGMA5M1(TGMA5M1Signal);
      paintTGMA5M5(TGMA5M5Signal);
      paintTGMA5M15(TGMA5M15Signal);
      paintTGMA5M30(TGMA5M30Signal);
      paintTGMA5H1(TGMA5H1Signal);
      paintTGMA5H4(TGMA5H4Signal);
      paintTGMA5D1(TGMA5D1Signal);
      paintTGMA6M1(TGMA6M1Signal);
      paintTGMA6M5(TGMA6M5Signal);
      paintTGMA6M15(TGMA6M15Signal);
      paintTGMA6M30(TGMA6M30Signal);
      paintTGMA6H1(TGMA6H1Signal);
      paintTGMA6H4(TGMA6H4Signal);
      paintTGMA6D1(TGMA6D1Signal);
      paintTGMA7M1(TGMA7M1Signal);
      paintTGMA7M5(TGMA7M5Signal);
      paintTGMA7M15(TGMA7M15Signal);
      paintTGMA7M30(TGMA7M30Signal);
      paintTGMA7H1(TGMA7H1Signal);
      paintTGMA7H4(TGMA7H4Signal);
      paintTGMA7D1(TGMA7D1Signal);
     }
   if(!DisplayTrendGraph && !DisplayCompact)
     {
      paintOBOSMap();
      paintOBOSMACM1(OBOSMACM1Signal);
      paintOBOSMACM5(OBOSMACM5Signal);
      paintOBOSMACM15(OBOSMACM15Signal);
      paintOBOSMACM30(OBOSMACM30Signal);
      paintOBOSMACH1(OBOSMACH1Signal);
      paintOBOSMACH4(OBOSMACH4Signal);
      paintOBOSMACD1(OBOSMACD1Signal);
      paintOBOSSTOM1(OBOSSTOM1Signal);
      paintOBOSSTOM5(OBOSSTOM5Signal);
      paintOBOSSTOM15(OBOSSTOM15Signal);
      paintOBOSSTOM30(OBOSSTOM30Signal);
      paintOBOSSTOH1(OBOSSTOH1Signal);
      paintOBOSSTOH4(OBOSSTOH4Signal);
      paintOBOSSTOD1(OBOSSTOD1Signal);
      paintOBOSWPRM1(OBOSWPRM1Signal);
      paintOBOSWPRM5(OBOSWPRM5Signal);
      paintOBOSWPRM15(OBOSWPRM15Signal);
      paintOBOSWPRM30(OBOSWPRM30Signal);
      paintOBOSWPRH1(OBOSWPRH1Signal);
      paintOBOSWPRH4(OBOSWPRH4Signal);
      paintOBOSWPRD1(OBOSWPRD1Signal);
      paintOBOSMFIM1(OBOSMFIM1Signal);
      paintOBOSMFIM5(OBOSMFIM5Signal);
      paintOBOSMFIM15(OBOSMFIM15Signal);
      paintOBOSMFIM30(OBOSMFIM30Signal);
      paintOBOSMFIH1(OBOSMFIH1Signal);
      paintOBOSMFIH4(OBOSMFIH4Signal);
      paintOBOSMFID1(OBOSMFID1Signal);
      paintOBOSCCIM1(OBOSCCIM1Signal);
      paintOBOSCCIM5(OBOSCCIM5Signal);
      paintOBOSCCIM15(OBOSCCIM15Signal);
      paintOBOSCCIM30(OBOSCCIM30Signal);
      paintOBOSCCIH1(OBOSCCIH1Signal);
      paintOBOSCCIH4(OBOSCCIH4Signal);
      paintOBOSCCID1(OBOSCCID1Signal);
      paintOBOSRSIM1(OBOSRSIM1Signal);
      paintOBOSRSIM5(OBOSRSIM5Signal);
      paintOBOSRSIM15(OBOSRSIM15Signal);
      paintOBOSRSIM30(OBOSRSIM30Signal);
      paintOBOSRSIH1(OBOSRSIH1Signal);
      paintOBOSRSIH4(OBOSRSIH4Signal);
      paintOBOSRSID1(OBOSRSID1Signal);
      paintOBOSBBM1(OBOSBBM1Signal);
      paintOBOSBBM5(OBOSBBM5Signal);
      paintOBOSBBM15(OBOSBBM15Signal);
      paintOBOSBBM30(OBOSBBM30Signal);
      paintOBOSBBH1(OBOSBBH1Signal);
      paintOBOSBBH4(OBOSBBH4Signal);
      paintOBOSBBD1(OBOSBBD1Signal);
     }
   paintCurrentPrice(BarShift);
  }
//----------------------------------------   
void initGraph()
  {
   ObjectsDeleteAll(0,OBJ_LABEL);

   int GraphShift;
   if(DisplayCompact){GraphShift=-156;} else GraphShift=0;

// Stochastic Graphs -------------------
   objectCreate("M_1_90",130,91);
   objectCreate("M_1_80",130,83);
   objectCreate("M_1_70",130,75);
   objectCreate("M_1_60",130,67);
   objectCreate("M_1_50",130,59);
   objectCreate("M_1_40",130,51);
   objectCreate("M_1_30",130,43);
   objectCreate("M_1_20",130,35);
   objectCreate("M_1_10",130,27);
   objectCreate("M_1_0",130,19);
   objectCreate("M_1",135,20,"M1",7,"Arial Narrow",SkyBlue);
   objectCreate("M_1p",134,29,DoubleToStr(9,1),8,"Arial Narrow",Silver);

   objectCreate("M_5_90",110,91);
   objectCreate("M_5_80",110,83);
   objectCreate("M_5_70",110,75);
   objectCreate("M_5_60",110,67);
   objectCreate("M_5_50",110,59);
   objectCreate("M_5_40",110,51);
   objectCreate("M_5_30",110,43);
   objectCreate("M_5_20",110,35);
   objectCreate("M_5_10",110,27);
   objectCreate("M_5_0",110,19);
   objectCreate("M_5",115,20,"M5",7,"Arial Narrow",SkyBlue);
   objectCreate("M_5p",114,29,DoubleToStr(9,1),8,"Arial Narrow",Silver);

   objectCreate("M_15_90",90,91);
   objectCreate("M_15_80",90,83);
   objectCreate("M_15_70",90,75);
   objectCreate("M_15_60",90,67);
   objectCreate("M_15_50",90,59);
   objectCreate("M_15_40",90,51);
   objectCreate("M_15_30",90,43);
   objectCreate("M_15_20",90,35);
   objectCreate("M_15_10",90,27);
   objectCreate("M_15_0",90,19);
   objectCreate("M_15",93,20,"M15",7,"Arial Narrow",SkyBlue);
   objectCreate("M_15p",94,29,DoubleToStr(9,1),8,"Arial Narrow",Silver);

   objectCreate("M_30_90",70,91);
   objectCreate("M_30_80",70,83);
   objectCreate("M_30_70",70,75);
   objectCreate("M_30_60",70,67);
   objectCreate("M_30_50",70,59);
   objectCreate("M_30_40",70,51);
   objectCreate("M_30_30",70,43);
   objectCreate("M_30_20",70,35);
   objectCreate("M_30_10",70,27);
   objectCreate("M_30_0",70,19);
   objectCreate("M_30",73,20,"M30",7,"Arial Narrow",SkyBlue);
   objectCreate("M_30p",74,29,DoubleToStr(9,1),8,"Arial Narrow",Silver);

   objectCreate("H_1_90",50,91);
   objectCreate("H_1_80",50,83);
   objectCreate("H_1_70",50,75);
   objectCreate("H_1_60",50,67);
   objectCreate("H_1_50",50,59);
   objectCreate("H_1_40",50,51);
   objectCreate("H_1_30",50,43);
   objectCreate("H_1_20",50,35);
   objectCreate("H_1_10",50,27);
   objectCreate("H_1_0",50,19);
   objectCreate("H_1",54,20,"H1",7,"Arial Narrow",SkyBlue);
   objectCreate("H_1p",54,29,DoubleToStr(9,1),8,"Arial Narrow",Silver);

   objectCreate("H_4_90",30,91);
   objectCreate("H_4_80",30,83);
   objectCreate("H_4_70",30,75);
   objectCreate("H_4_60",30,67);
   objectCreate("H_4_50",30,59);
   objectCreate("H_4_40",30,51);
   objectCreate("H_4_30",30,43);
   objectCreate("H_4_20",30,35);
   objectCreate("H_4_10",30,27);
   objectCreate("H_4_0",30,19);
   objectCreate("H_4",34,20,"H4",7,"Arial Narrow",SkyBlue);
   objectCreate("H_4p",34,29,DoubleToStr(9,1),8,"Arial Narrow",Silver);

   objectCreate("D_1_90",10,91);
   objectCreate("D_1_80",10,83);
   objectCreate("D_1_70",10,75);
   objectCreate("D_1_60",10,67);
   objectCreate("D_1_50",10,59);
   objectCreate("D_1_40",10,51);
   objectCreate("D_1_30",10,43);
   objectCreate("D_1_20",10,35);
   objectCreate("D_1_10",10,27);
   objectCreate("D_1_0",10,19);
   objectCreate("D_1",15,20,"D1",7,"Arial Narrow",SkyBlue);
   objectCreate("D_1p",14,29,DoubleToStr(9,1),8,"Arial Narrow",Silver);

   objectCreate("line",10,14,"-----------------------------------",10,"Arial",DimGray);
   objectCreate("line1",10,35,"-----------------------------------",10,"Arial",DimGray);
   objectCreate("line2",10,118,"-----------------------------------",10,"Arial",DimGray);
   objectCreate("sign",11,6,"STOCHASTIC OSCILLATORS",9,"Arial Narrow",DimGray);

// MA Graphs -------------------------------------------------------------------------------
   objectCreate("2M_1_MA",130,137);
   objectCreate("2M_5_MA",110,137);
   objectCreate("2M_15_MA",90,137);
   objectCreate("2M_30_MA",70,137);
   objectCreate("2H_1_MA",50,137);
   objectCreate("2H_4_MA",30,137);
   objectCreate("2D_1_MA",10,137);

   objectCreate("2M_1",135,147,"M1",7,"Arial Narrow",SkyBlue);
   objectCreate("2M_5",115,147,"M5",7,"Arial Narrow",SkyBlue);
   objectCreate("2M_15",93,147,"M15",7,"Arial Narrow",SkyBlue);
   objectCreate("2M_30",73,147,"M30",7,"Arial Narrow",SkyBlue);
   objectCreate("2H_1",54,147,"H1",7,"Arial Narrow",SkyBlue);
   objectCreate("2H_4",34,147,"H4",7,"Arial Narrow",SkyBlue);
   objectCreate("2D_1",15,147,"D1",7,"Arial Narrow",SkyBlue);

   objectCreate("2line",10,141,"-----------------------------------",10,"Arial",DimGray);
   objectCreate("2line1",10,152,"-----------------------------------",10,"Arial",DimGray);
   objectCreate("2line2",10,164,"-----------------------------------",10,"Arial",DimGray);
   objectCreate("2sign",12,132,"MOVING AVERAGE TREND",9,"Arial Narrow",DimGray);

// MACD Graphs ----------------------------------------------------------------------------- 
   objectCreate("MACD_Value1",118,GraphShift+427,"p",20,"Wingdings 3",Lime);
   objectCreate("MACD_Value2",122,GraphShift+427,"X",20,"Arial",Red);
   objectCreate("MACD_Value3",118,GraphShift+427,"q",20,"Wingdings 3",Red);
   objectCreate("MACD_Value4",122,GraphShift+427,"X",20,"Arial",Lime);
   objectCreate("MACD_Value5",122,GraphShift+427,"0",20,"Arial",Lime);
   objectCreate("MACD_Value6",122,GraphShift+427,"0",20,"Arial",Red);
   objectCreate("MACD_Chart",112,GraphShift+415,"CURRENT",7,"Arial Narrow",SkyBlue);
   objectCreate("MACD_Line1",113,GraphShift+408,"---------",10,"Arial",DimGray);
   objectCreate("MACD_Line2",113,GraphShift+421,"---------",10,"Arial",DimGray);
   objectCreate("MACD_Title",115,GraphShift+399,"MACD",9,"Arial Narrow",DimGray);

// PSAR Graph ----------------------------------------------------------------------------- 
   objectCreate("PSAR_Value1",118,GraphShift+363,"p",20,"Wingdings 3",Lime);
   objectCreate("PSAR_Value2",118,GraphShift+363,"q",20,"Wingdings 3",Red);
   objectCreate("PSAR_Chart",112,GraphShift+350,"CURRENT",7,"Arial Narrow",SkyBlue);
   objectCreate("PSAR_Line1",113,GraphShift+343,"---------",10,"Arial",DimGray);
   objectCreate("PSAR_Line2",113,GraphShift+356,"---------",10,"Arial",DimGray);
   objectCreate("PSAR_Line3",113,GraphShift+386,"---------",10,"Arial",DimGray);
   objectCreate("PSAR_Title",115,GraphShift+334,"P-SAR",9,"Arial Narrow",DimGray);

// WPR Graph -----------------------------------------------------------------------------  
   objectCreate("WPRpercent",12,GraphShift+456,"%",8,"Arial",Silver);
   objectCreate("WPRValue",22,GraphShift+456,DoubleToStr(9,1),9,"Arial",Silver);

   object2Create("V+5",12,GraphShift+444);
   object2Create("V+4",12,GraphShift+436);
   object2Create("V+3",12,GraphShift+428);
   object2Create("V+2",12,GraphShift+420);
   object2Create("V+1",12,GraphShift+412);
   object2Create("V=0",12,GraphShift+404);
   object2Create("V-1",12,GraphShift+396);
   object2Create("V-2",12,GraphShift+388);
   object2Create("V-3",12,GraphShift+380);
   object2Create("V-4",12,GraphShift+372);
   object2Create("V-5",12,GraphShift+364);

   objectCreate("VolumeChart",10,GraphShift+350,"CURRENT",7,"Arial Narrow",SkyBlue);
   objectCreate("WPRLine1",10,GraphShift+343,"---------",10,"Arial",DimGray);
   objectCreate("WPRLine2",10,GraphShift+356,"---------",10,"Arial",DimGray);
   objectCreate("WPRLine3",10,GraphShift+448,"---------",10,"Arial",DimGray);
   objectCreate("WPRTitle",10,GraphShift+334,"WPR%",9,"Arial Narrow",DimGray);

// Spread Graph ----------------------------------------------------------------------------- 
   objectCreate("SpreadLine3",58,GraphShift+386,"-----------",10,"Arial",DimGray);
   objectCreate("SpreadLine2",58,GraphShift+356,"-----------",10,"Arial",DimGray);
   objectCreate("SpreadLine1",58,GraphShift+343,"-----------",10,"Arial",DimGray);
   objectCreate("SpreadPips",70,GraphShift+350,"PIPS",7,"Arial Narrow",SkyBlue);
   objectCreate("SpreadTitle",59,GraphShift+334,"SPREAD",9,"Arial Narrow",DimGray);
   objectCreate("SpreadValue",66,GraphShift+362,DoubleToStr(9,1),18,"Arial",White);

// MAXover Graph ------------------------------------------------------------------------ 
   objectCreate("MAXoverValue1",67,GraphShift+427,"p",20,"Wingdings 3",Lime);
   objectCreate("MAXoverValue2",67,GraphShift+427,"q",20,"Wingdings 3",Red);
   objectCreate("MAXoverChart",62,GraphShift+415,"CURRENT",7,"Arial Narrow",SkyBlue);
   objectCreate("MAXoverLine1",58,GraphShift+408,"-----------",10,"Arial",DimGray);
   objectCreate("MAXoverLine2",58,GraphShift+421,"-----------",10,"Arial",DimGray);
   objectCreate("MAXoverTitle",68,GraphShift+399,"MA-X",9,"Arial Narrow",DimGray);

// BarMeter Graph ------------------------------------------------------------------------
   objectCreate("BarsLine1",60,GraphShift+470,"----------------------",10,"Arial",DimGray);
   objectCreate("BarsLine2",60,GraphShift+492,"----------------------",10,"Arial",DimGray);
   objectCreate("BarsLine3",60,GraphShift+533,"----------------------",10,"Arial",DimGray);
   objectCreate("BarsTitle",67,GraphShift+462,"BAR % METER",9,"Arial Narrow",DimGray);

   object3Create("Bar_5",132,GraphShift+491);
   object3Create("Bar_4",114,GraphShift+491);
   object3Create("Bar_3",96,GraphShift+491);
   object3Create("Bar_2",78,GraphShift+491);
   object3Create("Bar_1",60,GraphShift+491);

   objectCreate("B_5",134,GraphShift+476,"B5",7,"Arial Narrow",SkyBlue);
   objectCreate("B_4",116,GraphShift+476,"B4",7,"Arial Narrow",SkyBlue);
   objectCreate("B_3",98,GraphShift+476,"B3",7,"Arial Narrow",SkyBlue);
   objectCreate("B_2",80,GraphShift+476,"B2",7,"Arial Narrow",SkyBlue);
   objectCreate("B_1",62,GraphShift+476,"B1",7,"Arial Narrow",SkyBlue);
   objectCreate("BarsPercent",52,GraphShift+486,"%",7,"Arial Narrow",Silver);
   objectCreate("Bar_Value1",62,GraphShift+486,DoubleToStr(9,1),8,"Arial",White);
   objectCreate("Bar_Value2",80,GraphShift+486,DoubleToStr(9,1),8,"Arial",White);
   objectCreate("Bar_Value3",98,GraphShift+486,DoubleToStr(9,1),8,"Arial",White);
   objectCreate("Bar_Value4",116,GraphShift+486,DoubleToStr(9,1),8,"Arial",White);
   objectCreate("Bar_Value5",134,GraphShift+486,DoubleToStr(9,1),8,"Arial",White);
   objectCreate("BarsSlowing",70,GraphShift+541,"Slowing Down",8,"Arial",Silver);
   objectCreate("BarsSpeeding",70,GraphShift+541,"Speeding Up",8,"Arial",Silver);
   objectCreate("BarsStopped",83,GraphShift+541,"Stopped",8,"Arial",Silver);
   objectCreate("BarsSteady",85,GraphShift+541,"Steady",8,"Arial",Silver);

// Signal Graph ------------------------------------------------------------------------
   objectCreate("SignalLine1",10,GraphShift+492,"---------",10,"Arial",DimGray);
   objectCreate("SignalLine2",10,GraphShift+533,"---------",10,"Arial",DimGray);
   objectCreate("SignalTitle",9,GraphShift+484,"SIGNAL",9,"Arial Narrow",DimGray);
   objectCreate("SignalUp",10,GraphShift+498,"p",28,"Wingdings 3",Lime);
   objectCreate("SignalDown",10,GraphShift+498,"q",28,"Wingdings 3",Red);
   objectCreate("SignalWait",10,GraphShift+498,"6",28,"Wingdings",Silver);
//objectCreate("SignalLine3",10,616,"----------------------------------",10,"Arial",DimGray);

// Trend-O-Graph ------------------------------------------------------------------------
   if(DisplayTrendGraph && !DisplayCompact)
     {
      objectCreate("TGraphLine1",26,186,"------------------------------",10,"Arial",DimGray);
      objectCreate("TGraphLine2",26,199,"------------------------------",10,"Arial",DimGray);
      objectCreate("TGraphLine3",26,320,"------------------------------",10,"Arial",DimGray);
      objectCreate("TGraphTitle",40,178,"TREND-O-GRAPH",9,"Arial Narrow",DimGray);
      objectCreate("TGM_1",133,193,"M1",7,"Arial Narrow",SkyBlue);
      objectCreate("TGM_5",118,193,"M5",7,"Arial Narrow",SkyBlue);
      objectCreate("TGM_15",98,193,"M15",7,"Arial Narrow",SkyBlue);
      objectCreate("TGM_30",77,193,"M30",7,"Arial Narrow",SkyBlue);
      objectCreate("TGH_1",61,193,"H1",7,"Arial Narrow",SkyBlue);
      objectCreate("TGH_4",45,193,"H4",7,"Arial Narrow",SkyBlue);
      objectCreate("TGD_1",28,193,"D1",7,"Arial Narrow",SkyBlue);
      objectCreate("TGMA_1",10,311,"MA7",7,"Arial Narrow",SkyBlue);
      objectCreate("TGMA_2",10,294,"MA6",7,"Arial Narrow",SkyBlue);
      objectCreate("TGMA_3",10,277,"MA5",7,"Arial Narrow",SkyBlue);
      objectCreate("TGMA_4",10,260,"MA4",7,"Arial Narrow",SkyBlue);
      objectCreate("TGMA_5",10,242,"MA3",7,"Arial Narrow",SkyBlue);
      objectCreate("TGMA_6",10,225,"MA2",7,"Arial Narrow",SkyBlue);
      objectCreate("TGMA_7",10,208,"MA1",7,"Arial Narrow",SkyBlue);
      object4Create("TGM_1_MA1",124,186);
      object4Create("TGM_5_MA1",107,186);
      object4Create("TGM_15_MA1",90,186);
      object4Create("TGM_30_MA1",73,186);
      object4Create("TGH_1_MA1",56,186);
      object4Create("TGH_4_MA1",39,186);
      object4Create("TGD_1_MA1",22,186);
      object4Create("TGM_1_MA2",124,203);
      object4Create("TGM_5_MA2",107,203);
      object4Create("TGM_15_MA2",90,203);
      object4Create("TGM_30_MA2",73,203);
      object4Create("TGH_1_MA2",56,203);
      object4Create("TGH_4_MA2",39,203);
      object4Create("TGD_1_MA2",22,203);
      object4Create("TGM_1_MA3",124,220);
      object4Create("TGM_5_MA3",107,220);
      object4Create("TGM_15_MA3",90,220);
      object4Create("TGM_30_MA3",73,220);
      object4Create("TGH_1_MA3",56,220);
      object4Create("TGH_4_MA3",39,220);
      object4Create("TGD_1_MA3",22,220);
      object4Create("TGM_1_MA4",124,237);
      object4Create("TGM_5_MA4",107,237);
      object4Create("TGM_15_MA4",90,237);
      object4Create("TGM_30_MA4",73,237);
      object4Create("TGH_1_MA4",56,237);
      object4Create("TGH_4_MA4",39,237);
      object4Create("TGD_1_MA4",22,237);
      object4Create("TGM_1_MA5",124,254);
      object4Create("TGM_5_MA5",107,254);
      object4Create("TGM_15_MA5",90,254);
      object4Create("TGM_30_MA5",73,254);
      object4Create("TGH_1_MA5",56,254);
      object4Create("TGH_4_MA5",39,254);
      object4Create("TGD_1_MA5",22,254);
      object4Create("TGM_1_MA6",124,271);
      object4Create("TGM_5_MA6",107,271);
      object4Create("TGM_15_MA6",90,271);
      object4Create("TGM_30_MA6",73,271);
      object4Create("TGH_1_MA6",56,271);
      object4Create("TGH_4_MA6",39,271);
      object4Create("TGD_1_MA6",22,271);
      object4Create("TGM_1_MA7",124,288);
      object4Create("TGM_5_MA7",107,288);
      object4Create("TGM_15_MA7",90,288);
      object4Create("TGM_30_MA7",73,288);
      object4Create("TGH_1_MA7",56,288);
      object4Create("TGH_4_MA7",39,288);
      object4Create("TGD_1_MA7",22,288);
     }

// OB/OS Map ------------------------------------------------------------------------
   if(!DisplayTrendGraph && !DisplayCompact)
     {
      objectCreate("OBOSLine1",30,186,"------------------------------",10,"Arial",DimGray);
      objectCreate("OBOSLine2",30,199,"------------------------------",10,"Arial",DimGray);
      objectCreate("OBOSLine3",30,320,"------------------------------",10,"Arial",DimGray);
      objectCreate("OBOSTitle",40,178,"OB/OS SIGNAL MAP",9,"Arial Narrow",DimGray);
      objectCreate("OBOSM_1",137,193,"M1",7,"Arial Narrow",SkyBlue);
      objectCreate("OBOSM_5",122,193,"M5",7,"Arial Narrow",SkyBlue);
      objectCreate("OBOSM_15",104,193,"M15",7,"Arial Narrow",SkyBlue);
      objectCreate("OBOSM_30",81,193,"M30",7,"Arial Narrow",SkyBlue);
      objectCreate("OBOSH_1",65,193,"H1",7,"Arial Narrow",SkyBlue);
      objectCreate("OBOSH_4",49,193,"H4",7,"Arial Narrow",SkyBlue);
      objectCreate("OBOSD_1",32,193,"D1",7,"Arial Narrow",SkyBlue);
      objectCreate("OBOSBB",10,311,"BB",7,"Arial Narrow",SkyBlue);
      objectCreate("OBOSRSI",10,294,"RSI",7,"Arial Narrow",SkyBlue);
      objectCreate("OBOSCCI",10,277,"CCI",7,"Arial Narrow",SkyBlue);
      objectCreate("OBOSMFI",10,260,"MFI",7,"Arial Narrow",SkyBlue);
      objectCreate("OBOSWPR",10,242,"WPR",7,"Arial Narrow",SkyBlue);
      objectCreate("OBOSSTO",10,225,"STO",7,"Arial Narrow",SkyBlue);
      objectCreate("OBOSMAC",10,208,"MAC",7,"Arial Narrow",SkyBlue);

      object5Create("OBOSMACM1",136,204);
      object5Create("OBOSMACM5",119,204);
      object5Create("OBOSMACM15",102,204);
      object5Create("OBOSMACM30",85,204);
      object5Create("OBOSMACH1",68,204);
      object5Create("OBOSMACH4",51,204);
      object5Create("OBOSMACD1",34,204);
      object5Create("OBOSSTOM1",136,221);
      object5Create("OBOSSTOM5",119,221);
      object5Create("OBOSSTOM15",102,221);
      object5Create("OBOSSTOM30",85,221);
      object5Create("OBOSSTOH1",68,221);
      object5Create("OBOSSTOH4",51,221);
      object5Create("OBOSSTOD1",34,221);
      object5Create("OBOSWPRM1",136,238);
      object5Create("OBOSWPRM5",119,238);
      object5Create("OBOSWPRM15",102,238);
      object5Create("OBOSWPRM30",85,238);
      object5Create("OBOSWPRH1",68,238);
      object5Create("OBOSWPRH4",51,238);
      object5Create("OBOSWPRD1",34,238);
      object5Create("OBOSMFIM1",136,255);
      object5Create("OBOSMFIM5",119,255);
      object5Create("OBOSMFIM15",102,255);
      object5Create("OBOSMFIM30",85,255);
      object5Create("OBOSMFIH1",68,255);
      object5Create("OBOSMFIH4",51,255);
      object5Create("OBOSMFID1",34,255);
      object5Create("OBOSCCIM1",136,272);
      object5Create("OBOSCCIM5",119,272);
      object5Create("OBOSCCIM15",102,272);
      object5Create("OBOSCCIM30",85,272);
      object5Create("OBOSCCIH1",68,272);
      object5Create("OBOSCCIH4",51,272);
      object5Create("OBOSCCID1",34,272);
      object5Create("OBOSRSIM1",136,289);
      object5Create("OBOSRSIM5",119,289);
      object5Create("OBOSRSIM15",102,289);
      object5Create("OBOSRSIM30",85,289);
      object5Create("OBOSRSIH1",68,289);
      object5Create("OBOSRSIH4",51,289);
      object5Create("OBOSRSID1",34,289);
      object5Create("OBOSBBM1",136,306);
      object5Create("OBOSBBM5",119,306);
      object5Create("OBOSBBM15",102,306);
      object5Create("OBOSBBM30",85,306);
      object5Create("OBOSBBH1",68,306);
      object5Create("OBOSBBH4",51,306);
      object5Create("OBOSBBD1",34,306);

      object4Create("OBOSMACM1none",128,186);
      object4Create("OBOSMACM5none",111,186);
      object4Create("OBOSMACM15none",94,186);
      object4Create("OBOSMACM30none",77,186);
      object4Create("OBOSMACH1none",60,186);
      object4Create("OBOSMACH4none",43,186);
      object4Create("OBOSMACD1none",26,186);
      object4Create("OBOSSTOM1none",128,203);
      object4Create("OBOSSTOM5none",111,203);
      object4Create("OBOSSTOM15none",94,203);
      object4Create("OBOSSTOM30none",77,203);
      object4Create("OBOSSTOH1none",60,203);
      object4Create("OBOSSTOH4none",43,203);
      object4Create("OBOSSTOD1none",26,203);
      object4Create("OBOSWPRM1none",128,220);
      object4Create("OBOSWPRM5none",111,220);
      object4Create("OBOSWPRM15none",94,220);
      object4Create("OBOSWPRM30none",77,220);
      object4Create("OBOSWPRH1none",60,220);
      object4Create("OBOSWPRH4none",43,220);
      object4Create("OBOSWPRD1none",26,220);
      object4Create("OBOSMFIM1none",128,237);
      object4Create("OBOSMFIM5none",111,237);
      object4Create("OBOSMFIM15none",94,237);
      object4Create("OBOSMFIM30none",77,237);
      object4Create("OBOSMFIH1none",60,237);
      object4Create("OBOSMFIH4none",43,237);
      object4Create("OBOSMFID1none",26,237);
      object4Create("OBOSCCIM1none",128,254);
      object4Create("OBOSCCIM5none",111,254);
      object4Create("OBOSCCIM15none",94,254);
      object4Create("OBOSCCIM30none",77,254);
      object4Create("OBOSCCIH1none",60,254);
      object4Create("OBOSCCIH4none",43,254);
      object4Create("OBOSCCID1none",26,254);
      object4Create("OBOSRSIM1none",128,271);
      object4Create("OBOSRSIM5none",111,271);
      object4Create("OBOSRSIM15none",94,271);
      object4Create("OBOSRSIM30none",77,271);
      object4Create("OBOSRSIH1none",60,271);
      object4Create("OBOSRSIH4none",43,271);
      object4Create("OBOSRSID1none",26,271);
      object4Create("OBOSBBM1none",128,288);
      object4Create("OBOSBBM5none",111,288);
      object4Create("OBOSBBM15none",94,288);
      object4Create("OBOSBBM30none",77,288);
      object4Create("OBOSBBH1none",60,288);
      object4Create("OBOSBBH4none",43,288);
      object4Create("OBOSBBD1none",26,288);
     }

   WindowRedraw();
  }
//+------------------------------------------------------------------+
void objectCreate(string name,int x,int y,string text="-",int size=42,
                  string font="Arial",color colour=CLR_NONE)
  {
   ObjectCreate(name,OBJ_LABEL,0,0,0);
   ObjectSet(name,OBJPROP_CORNER,3);
   ObjectSet(name,OBJPROP_COLOR,colour);
   ObjectSet(name,OBJPROP_XDISTANCE,x);
   ObjectSet(name,OBJPROP_YDISTANCE,y);
   ObjectSetText(name,text,size,font,colour);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void object2Create(string name,int x,int y,string text="_",int size=42,
                   string font="Arial",color colour=CLR_NONE)
  {
   ObjectCreate(name,OBJ_LABEL,0,0,0);
   ObjectSet(name,OBJPROP_CORNER,3);
   ObjectSet(name,OBJPROP_COLOR,colour);
   ObjectSet(name,OBJPROP_XDISTANCE,x);
   ObjectSet(name,OBJPROP_YDISTANCE,y);
   ObjectSetText(name,text,size,font,colour);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void object3Create(string name,int x,int y,string text="I",int size=36,
                   string font="Arial Bold",color colour=CLR_NONE)
  {
   ObjectCreate(name,OBJ_LABEL,0,0,0);
   ObjectSet(name,OBJPROP_CORNER,3);
   ObjectSet(name,OBJPROP_COLOR,colour);
   ObjectSet(name,OBJPROP_XDISTANCE,x);
   ObjectSet(name,OBJPROP_YDISTANCE,y);
   ObjectSetText(name,text,size,font,colour);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void object4Create(string name,int x,int y,string text=".",int size=74,
                   string font="Arial Bold",color colour=CLR_NONE)
  {
   ObjectCreate(name,OBJ_LABEL,0,0,0);
   ObjectSet(name,OBJPROP_CORNER,3);
   ObjectSet(name,OBJPROP_COLOR,colour);
   ObjectSet(name,OBJPROP_XDISTANCE,x);
   ObjectSet(name,OBJPROP_YDISTANCE,y);
   ObjectSetText(name,text,size,font,colour);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void object5Create(string name,int x,int y,string text="X",int size=14,
                   string font="Arial",color colour=CLR_NONE)
  {
   ObjectCreate(name,OBJ_LABEL,0,0,0);
   ObjectSet(name,OBJPROP_CORNER,3);
   ObjectSet(name,OBJPROP_COLOR,colour);
   ObjectSet(name,OBJPROP_XDISTANCE,x);
   ObjectSet(name,OBJPROP_YDISTANCE,y);
   ObjectSetText(name,text,size,font,colour);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void objectBlank()
  {
// Stochastic Graphs -------------------
   ObjectSet("M_1_90",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_1_80",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_1_70",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_1_60",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_1_50",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_1_40",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_1_30",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_1_20",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_1_10",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_1_0",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_1p",OBJPROP_COLOR,CLR_NONE);

   ObjectSet("M_5_90",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_5_80",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_5_70",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_5_60",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_5_50",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_5_40",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_5_30",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_5_20",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_5_10",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_5_0",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_5p",OBJPROP_COLOR,CLR_NONE);

   ObjectSet("M_15_90",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_15_80",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_15_70",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_15_60",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_15_50",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_15_40",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_15_30",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_15_20",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_15_10",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_15_0",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_15",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_15p",OBJPROP_COLOR,CLR_NONE);

   ObjectSet("M_30_90",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_30_80",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_30_70",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_30_60",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_30_50",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_30_40",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_30_30",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_30_20",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_30_10",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_30_0",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_30",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("M_30p",OBJPROP_COLOR,CLR_NONE);

   ObjectSet("H_1_90",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("H_1_80",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("H_1_70",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("H_1_60",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("H_1_50",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("H_1_40",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("H_1_30",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("H_1_20",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("H_1_10",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("H_1_0",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("H_1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("H_1p",OBJPROP_COLOR,CLR_NONE);

   ObjectSet("H_4_90",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("H_4_80",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("H_4_70",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("H_4_60",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("H_4_50",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("H_4_40",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("H_4_30",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("H_4_20",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("H_4_10",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("H_4_0",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("H_4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("H_4p",OBJPROP_COLOR,CLR_NONE);

   ObjectSet("D_1_90",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("D_1_80",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("D_1_70",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("D_1_60",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("D_1_50",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("D_1_40",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("D_1_30",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("D_1_20",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("D_1_10",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("D_1_0",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("D_1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("D_1p",OBJPROP_COLOR,CLR_NONE);

   ObjectSet("line",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("line1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("line2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("sign",OBJPROP_COLOR,CLR_NONE);

// MA Graphs -------------------
   ObjectSet("2M_1_MA",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("2M_5_MA",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("2M_15_MA",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("2M_30_MA",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("2H_1_MA",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("2H_4_MA",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("2D_1_MA",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("2D_1_MA",OBJPROP_COLOR,CLR_NONE);

   ObjectSet("2M_1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("2M_5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("2M_15",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("2M_30",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("2H_1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("2H_4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("2D_1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("2D_1",OBJPROP_COLOR,CLR_NONE);

   ObjectSet("2line1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("2line2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("2line",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("2sign",OBJPROP_COLOR,CLR_NONE);

// WPR Graph ------------------- 
   ObjectSet("V+5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("V+4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("V+3",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("V+2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("V+1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("V=0",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("V-1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("V-2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("V-3",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("V-4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("V-5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("VolumeChart",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("WPRTitle",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("WPRpercent",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("WPRValue",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("WPRLine1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("WPRLine2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("WPRLine3",OBJPROP_COLOR,CLR_NONE);

// Spread Graph ------------------- 
   ObjectSet("SpreadValue",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("SpreadTitle",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("SpreadPips",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("SpreadLine1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("SpreadLine2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("SpreadLine3",OBJPROP_COLOR,CLR_NONE);

// PSAR Graph -------------------
   ObjectSet("PSAR_Value1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("PSAR_Value2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("PSAR_Chart",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("PSAR_Line1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("PSAR_Line2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("PSAR_Line3",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("PSAR_Title",OBJPROP_COLOR,CLR_NONE);

// MACD Graph -------------------
   ObjectSet("MACD_Value1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("MACD_Value2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("MACD_Value3",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("MACD_Value4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("MACD_Value5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("MACD_Value6",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("MACD_Chart",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("MACD_Line1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("MACD_Line2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("MACD_Title",OBJPROP_COLOR,CLR_NONE);

// MA Xover Graph -------------------
   ObjectSet("MAXoverValue1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("MAXoverValue2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("MAXoverChart",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("MAXoverLine1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("MAXoverLine2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("MAXoverTitle",OBJPROP_COLOR,CLR_NONE);

// BarMeter Graph -------------------
   ObjectSet("BarsLine1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("BarsLine2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("BarsLine3",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("BarsTitle",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("BarsDescription",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("Bar_Value1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("Bar_Value2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("Bar_Value3",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("Bar_Value4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("Bar_Value5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("Bar_1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("Bar_2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("Bar_3",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("Bar_4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("Bar_5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("B_1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("B_2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("B_3",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("B_4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("B_5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("BarsSpeeding",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("BarsSlowing",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("BarsSteady",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("BarsStopped",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("BarsPercent",OBJPROP_COLOR,CLR_NONE);

// OB/OS Signal Map -------------------
   ObjectSet("OBOSLine1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSLine2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSLine3",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSTitle",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSM_1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSM_5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSM_15",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSM_30",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSH_1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSH_4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSD_1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSBB",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSRSI",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSCCI",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMFI",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSWPR",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSSTO",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMAC",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMACM1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMACM5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMACM15",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMACM30",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMACH1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMACH4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMACD1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMACM1none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMACM5none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMACM15none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMACM30none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMACH1none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMACH4none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMACD1none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSSTOM1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSSTOM5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSSTOM15",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSSTOM30",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSSTOH1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSSTOH4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSSTOD1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSSTOM1none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSSTOM5none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSSTOM15none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSSTOM30none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSSTOH1none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSSTOH4none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSSTOD1none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSWPRM1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSWPRM5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSWPRM15",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSWPRM30",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSWPRH1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSWPRH4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSWPRD1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSWPRM1none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSWPRM5none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSWPRM15none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSWPRM30none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSWPRH1none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSWPRH4none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSWPRD1none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMFIM1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMFIM5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMFIM15",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMFIM30",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMFIH1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMFIH4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMFID1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMFIM1none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMFIM5none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMFIM15none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMFIM30none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMFIH1none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMFIH4none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSMFID1none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSCCIM1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSCCIM5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSCCIM15",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSCCIM30",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSCCIH1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSCCIH4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSCCID1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSCCIM1none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSCCIM5none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSCCIM15none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSCCIM30none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSCCIH1none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSCCIH4none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSCCID1none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSRSIM1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSRSIM5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSRSIM15",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSRSIM30",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSRSIH1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSRSIH4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSRSID1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSRSIM1none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSRSIM5none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSRSIM15none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSRSIM30none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSRSIH1none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSRSIH4none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSRSID1none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSBBM1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSBBM5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSBBM15",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSBBM30",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSBBH1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSBBH4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSBBD1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSBBM1none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSBBM5none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSBBM15none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSBBM30none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSBBH1none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSBBH4none",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("OBOSBBD1none",OBJPROP_COLOR,CLR_NONE);

// Trend-O-Graph ------------------------------
   ObjectSet("TGraphLine1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGraphLine2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGraphLine3",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGraphTitle",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_15",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_30",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGH_1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGH_4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGD_1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGMA_1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGMA_2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGMA_3",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGMA_4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGMA_5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGMA_6",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGMA_7",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_1_MA1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_5_MA1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_15_MA1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_30_MA1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGH_1_MA1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGH_4_MA1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGD_1_MA1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_1_MA2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_5_MA2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_15_MA2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_30_MA2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGH_1_MA2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGH_4_MA2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGD_1_MA2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_1_MA3",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_5_MA3",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_15_MA3",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_30_MA3",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGH_1_MA3",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGH_4_MA3",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGD_1_MA3",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_1_MA4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_5_MA4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_15_MA4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_30_MA4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGH_1_MA4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGH_4_MA4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGD_1_MA4",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_1_MA5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_5_MA5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_15_MA5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_30_MA5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGH_1_MA5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGH_4_MA5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGD_1_MA5",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_1_MA6",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_5_MA6",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_15_MA6",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_30_MA6",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGH_1_MA6",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGH_4_MA6",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGD_1_MA6",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_1_MA7",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_5_MA7",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_15_MA7",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGM_30_MA7",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGH_1_MA7",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGH_4_MA7",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("TGD_1_MA7",OBJPROP_COLOR,CLR_NONE);

// Signal Graph -------------------
   ObjectSet("SignalLine1",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("SignalLine2",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("SignalTitle",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("SignalUp",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("SignalDown",OBJPROP_COLOR,CLR_NONE);
   ObjectSet("SignalWait",OBJPROP_COLOR,CLR_NONE);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintM1(double value)
  {
   if(value >= 90) ObjectSet("M_1_90",OBJPROP_COLOR,Lime);
   if(value >= 80) ObjectSet("M_1_80",OBJPROP_COLOR,Lime);
   if(value >= 70) ObjectSet("M_1_70",OBJPROP_COLOR,LawnGreen);
   if(value >= 60) ObjectSet("M_1_60",OBJPROP_COLOR,GreenYellow);
   if(value >= 50) ObjectSet("M_1_50",OBJPROP_COLOR,Yellow);
   if(value >= 40) ObjectSet("M_1_40",OBJPROP_COLOR,Gold);
   if(value >= 30) ObjectSet("M_1_30",OBJPROP_COLOR,Orange);
   if(value >= 20) ObjectSet("M_1_20",OBJPROP_COLOR,DarkOrange);
   if(value >= 10) ObjectSet("M_1_10",OBJPROP_COLOR,OrangeRed);
   if(value >= 0) ObjectSet("M_1_0",OBJPROP_COLOR,Red);
   ObjectSet("M_1",OBJPROP_COLOR,SkyBlue);
   ObjectSetText("M_1p",DoubleToStr(value,0),8,"Arial Narrow",Silver);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintM5(double value)
  {
   if(value>90) ObjectSet("M_5_90",OBJPROP_COLOR,Lime);
   if(value>80) ObjectSet("M_5_80",OBJPROP_COLOR,Lime);
   if(value>70) ObjectSet("M_5_70",OBJPROP_COLOR,LawnGreen);
   if(value>60) ObjectSet("M_5_60",OBJPROP_COLOR,GreenYellow);
   if(value>50) ObjectSet("M_5_50",OBJPROP_COLOR,Yellow);
   if(value>40) ObjectSet("M_5_40",OBJPROP_COLOR,Gold);
   if(value>30) ObjectSet("M_5_30",OBJPROP_COLOR,Orange);
   if(value>20) ObjectSet("M_5_20",OBJPROP_COLOR,DarkOrange);
   if(value>10) ObjectSet("M_5_10",OBJPROP_COLOR,OrangeRed);
   if(value>0) ObjectSet("M_5_0",OBJPROP_COLOR,Red);
   ObjectSet("M_5",OBJPROP_COLOR,SkyBlue);
   ObjectSetText("M_5p",DoubleToStr(value,0),8,"Arial Narrow",Silver);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintM15(double value)
  {
   if(value>90) ObjectSet("M_15_90",OBJPROP_COLOR,Lime);
   if(value>80) ObjectSet("M_15_80",OBJPROP_COLOR,Lime);
   if(value>70) ObjectSet("M_15_70",OBJPROP_COLOR,LawnGreen);
   if(value>60) ObjectSet("M_15_60",OBJPROP_COLOR,GreenYellow);
   if(value>50) ObjectSet("M_15_50",OBJPROP_COLOR,Yellow);
   if(value>40) ObjectSet("M_15_40",OBJPROP_COLOR,Gold);
   if(value>30) ObjectSet("M_15_30",OBJPROP_COLOR,Orange);
   if(value>20) ObjectSet("M_15_20",OBJPROP_COLOR,DarkOrange);
   if(value>10) ObjectSet("M_15_10",OBJPROP_COLOR,OrangeRed);
   if(value>0) ObjectSet("M_15_0",OBJPROP_COLOR,Red);
   ObjectSet("M_15",OBJPROP_COLOR,SkyBlue);
   ObjectSetText("M_15p",DoubleToStr(value,0),8,"Arial Narrow",Silver);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintM30(double value)
  {
   if(value>90) ObjectSet("M_30_90",OBJPROP_COLOR,Lime);
   if(value>80) ObjectSet("M_30_80",OBJPROP_COLOR,Lime);
   if(value>70) ObjectSet("M_30_70",OBJPROP_COLOR,LawnGreen);
   if(value>60) ObjectSet("M_30_60",OBJPROP_COLOR,GreenYellow);
   if(value>50) ObjectSet("M_30_50",OBJPROP_COLOR,Yellow);
   if(value>40) ObjectSet("M_30_40",OBJPROP_COLOR,Gold);
   if(value>30) ObjectSet("M_30_30",OBJPROP_COLOR,Orange);
   if(value>20) ObjectSet("M_30_20",OBJPROP_COLOR,DarkOrange);
   if(value>10) ObjectSet("M_30_10",OBJPROP_COLOR,OrangeRed);
   if(value>0) ObjectSet("M_30_0",OBJPROP_COLOR,Red);
   ObjectSet("M_30",OBJPROP_COLOR,SkyBlue);
   ObjectSetText("M_30p",DoubleToStr(value,0),8,"Arial Narrow",Silver);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintH1(double value)
  {
   if(value>90) ObjectSet("H_1_90",OBJPROP_COLOR,Lime);
   if(value>80) ObjectSet("H_1_80",OBJPROP_COLOR,Lime);
   if(value>70) ObjectSet("H_1_70",OBJPROP_COLOR,LawnGreen);
   if(value>60) ObjectSet("H_1_60",OBJPROP_COLOR,GreenYellow);
   if(value>50) ObjectSet("H_1_50",OBJPROP_COLOR,Yellow);
   if(value>40) ObjectSet("H_1_40",OBJPROP_COLOR,Gold);
   if(value>30) ObjectSet("H_1_30",OBJPROP_COLOR,Orange);
   if(value>20) ObjectSet("H_1_20",OBJPROP_COLOR,DarkOrange);
   if(value>10) ObjectSet("H_1_10",OBJPROP_COLOR,OrangeRed);
   if(value>0) ObjectSet("H_1_0",OBJPROP_COLOR,Red);
   ObjectSet("H_1",OBJPROP_COLOR,SkyBlue);
   ObjectSetText("H_1p",DoubleToStr(value,0),8,"Arial Narrow",Silver);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintH4(double value)
  {
   if(value>90) ObjectSet("H_4_90",OBJPROP_COLOR,Lime);
   if(value>80) ObjectSet("H_4_80",OBJPROP_COLOR,Lime);
   if(value>70) ObjectSet("H_4_70",OBJPROP_COLOR,LawnGreen);
   if(value>60) ObjectSet("H_4_60",OBJPROP_COLOR,GreenYellow);
   if(value>50) ObjectSet("H_4_50",OBJPROP_COLOR,Yellow);
   if(value>40) ObjectSet("H_4_40",OBJPROP_COLOR,Gold);
   if(value>30) ObjectSet("H_4_30",OBJPROP_COLOR,Orange);
   if(value>20) ObjectSet("H_4_20",OBJPROP_COLOR,DarkOrange);
   if(value>10) ObjectSet("H_4_10",OBJPROP_COLOR,OrangeRed);
   if(value>0) ObjectSet("H_4_0",OBJPROP_COLOR,Red);
   ObjectSet("H_4",OBJPROP_COLOR,SkyBlue);
   ObjectSetText("H_4p",DoubleToStr(value,0),8,"Arial Narrow",Silver);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintD1(double value)
  {
   if(value>90) ObjectSet("D_1_90",OBJPROP_COLOR,Lime);
   if(value>80) ObjectSet("D_1_80",OBJPROP_COLOR,Lime);
   if(value>70) ObjectSet("D_1_70",OBJPROP_COLOR,LawnGreen);
   if(value>60) ObjectSet("D_1_60",OBJPROP_COLOR,GreenYellow);
   if(value>50) ObjectSet("D_1_50",OBJPROP_COLOR,Yellow);
   if(value>40) ObjectSet("D_1_40",OBJPROP_COLOR,Gold);
   if(value>30) ObjectSet("D_1_30",OBJPROP_COLOR,Orange);
   if(value>20) ObjectSet("D_1_20",OBJPROP_COLOR,DarkOrange);
   if(value>10) ObjectSet("D_1_10",OBJPROP_COLOR,OrangeRed);
   if(value>0) ObjectSet("D_1_0",OBJPROP_COLOR,Red);
   ObjectSet("D_1",OBJPROP_COLOR,SkyBlue);
   ObjectSetText("D_1p",DoubleToStr(value,0),8,"Arial Narrow",Silver);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintLine()
  {
   ObjectSet("line",OBJPROP_COLOR,DimGray);
   ObjectSet("line1",OBJPROP_COLOR,DimGray);
   ObjectSet("line2",OBJPROP_COLOR,DimGray);
   ObjectSet("sign",OBJPROP_COLOR,DimGray);
  }
// MA Graphs -------------------

void paintMA_M1(int value)
  {
   if(value==1) ObjectSet("2M_1_MA",OBJPROP_COLOR,Lime);
   if(value==0) ObjectSet("2M_1_MA",OBJPROP_COLOR,Red);
   ObjectSet("2M_1",OBJPROP_COLOR,SkyBlue);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintMA_M5(int value)
  {
   if(value==1) ObjectSet("2M_5_MA",OBJPROP_COLOR,Lime);
   if(value==0) ObjectSet("2M_5_MA",OBJPROP_COLOR,Red);
   ObjectSet("2M_5",OBJPROP_COLOR,SkyBlue);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintMA_M15(int value)
  {
   if(value==1) ObjectSet("2M_15_MA",OBJPROP_COLOR,Lime);
   if(value==0) ObjectSet("2M_15_MA",OBJPROP_COLOR,Red);
   ObjectSet("2M_15",OBJPROP_COLOR,SkyBlue);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintMA_M30(int value)
  {
   if(value==1) ObjectSet("2M_30_MA",OBJPROP_COLOR,Lime);
   if(value==0) ObjectSet("2M_30_MA",OBJPROP_COLOR,Red);
   ObjectSet("2M_30",OBJPROP_COLOR,SkyBlue);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintMA_H1(int value)
  {
   if(value==1) ObjectSet("2H_1_MA",OBJPROP_COLOR,Lime);
   if(value==0) ObjectSet("2H_1_MA",OBJPROP_COLOR,Red);
   ObjectSet("2H_1",OBJPROP_COLOR,SkyBlue);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintMA_H4(int value)
  {
   if(value==1) ObjectSet("2H_4_MA",OBJPROP_COLOR,Lime);
   if(value==0) ObjectSet("2H_4_MA",OBJPROP_COLOR,Red);
   ObjectSet("2H_4",OBJPROP_COLOR,SkyBlue);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintMA_D1(int value)
  {
   if(value==1) ObjectSet("2D_1_MA",OBJPROP_COLOR,Lime);
   if(value==0) ObjectSet("2D_1_MA",OBJPROP_COLOR,Red);
   ObjectSet("2D_1",OBJPROP_COLOR,SkyBlue);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paint2Line()
  {
   ObjectSet("2line",OBJPROP_COLOR,DimGray);
   ObjectSet("2line1",OBJPROP_COLOR,DimGray);
   ObjectSet("2line2",OBJPROP_COLOR,DimGray);
   ObjectSet("2sign",OBJPROP_COLOR,DimGray);
  }
// WPR% Graphs -------------------

void paintWPRUp(int value)
  {
   if(value==1 && value>0) ObjectSet("V+5",OBJPROP_COLOR,Lime);
   if(value<=2 && value>0) ObjectSet("V+4",OBJPROP_COLOR,Lime);
   if(value<=3 && value>0) ObjectSet("V+3",OBJPROP_COLOR,LawnGreen);
   if(value<=4 && value>0) ObjectSet("V+2",OBJPROP_COLOR,LawnGreen);
   if(value<=5 && value>0) ObjectSet("V+1",OBJPROP_COLOR,GreenYellow);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintWPRDown(int value)
  {
   ObjectSet("V=0",OBJPROP_COLOR,Yellow);
   if(value>=6) ObjectSet("V-1",OBJPROP_COLOR,Gold);
   if(value>=7) ObjectSet("V-2",OBJPROP_COLOR,Orange);
   if(value>=8) ObjectSet("V-3",OBJPROP_COLOR,DarkOrange);
   if(value>=9) ObjectSet("V-4",OBJPROP_COLOR,OrangeRed);
   if(value==10) ObjectSet("V-5",OBJPROP_COLOR,Red);
   ObjectSet("WPRLine1",OBJPROP_COLOR,DimGray);
   ObjectSet("WPRLine2",OBJPROP_COLOR,DimGray);
   ObjectSet("WPRLine3",OBJPROP_COLOR,DimGray);
   ObjectSet("WPRTitle",OBJPROP_COLOR,DimGray);
   ObjectSet("VolumeChart",OBJPROP_COLOR,SkyBlue);
   ObjectSet("WPRpercent",OBJPROP_COLOR,Silver);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintWPRValue(int value)
  {
   ObjectSetText("WPRValue",DoubleToStr(value,0),9,"Arial",White);
  }
// Spread Graphs -------------------    
void paintSpread(double value)
  {
   ObjectSet("SpreadPips",OBJPROP_COLOR,SkyBlue);
   ObjectSetText("SpreadValue",DoubleToStr(value,1),19,"Arial Narrow",White);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintSpreadLines()
  {
   ObjectSet("SpreadLine1",OBJPROP_COLOR,DimGray);
   ObjectSet("SpreadLine2",OBJPROP_COLOR,DimGray);
   ObjectSet("SpreadLine3",OBJPROP_COLOR,DimGray);
   ObjectSet("SpreadTitle",OBJPROP_COLOR,DimGray);
  }
// PSAR Graphs -------------------
void paintPSAR(int value)
  {
   int GraphShift; if(DisplayCompact){GraphShift=-156;} else GraphShift=0;
   if(value==1)
     {
      objectCreate("PSAR_Value1",118,GraphShift+363,"p",20,"Wingdings 3",Lime);
      ObjectDelete("PSAR_Value2");
      ObjectSet("PSAR_Value1",OBJPROP_COLOR,Lime);
     }
   if(value==0)
     {
      objectCreate("PSAR_Value2",118,GraphShift+363,"q",20,"Wingdings 3",Red);
      ObjectDelete("PSAR_Value1");
      ObjectSet("PSAR_Value2",OBJPROP_COLOR,Red);
     }
   ObjectSet("PSAR_Title",OBJPROP_COLOR,DimGray);
   ObjectSet("PSAR_Chart",OBJPROP_COLOR,SkyBlue);
   ObjectSet("PSAR_Line1",OBJPROP_COLOR,DimGray);
   ObjectSet("PSAR_Line2",OBJPROP_COLOR,DimGray);
   ObjectSet("PSAR_Line3",OBJPROP_COLOR,DimGray);
  }
// MACD Graphs -------------------
void paintMACD(int value)
  {
   int GraphShift; if(DisplayCompact){GraphShift=-156;} else GraphShift=0;
   if(value==3)
     {
      objectCreate("MACD_Value1",118,GraphShift+427,"p",20,"Wingdings 3",Lime);
      ObjectDelete("MACD_Value2");
      ObjectDelete("MACD_Value3");
      ObjectDelete("MACD_Value4");
      ObjectDelete("MACD_Value5");
      ObjectDelete("MACD_Value6");
      ObjectSet("MACD_Value1",OBJPROP_COLOR,Lime);
     }
   if(value==2)
     {
      objectCreate("MACD_Value2",122,GraphShift+427,"X",20,"Arial",Red);
      ObjectDelete("MACD_Value4");
      ObjectDelete("MACD_Value3");
      ObjectDelete("MACD_Value1");
      ObjectDelete("MACD_Value5");
      ObjectDelete("MACD_Value6");
      ObjectSet("MACD_Value2",OBJPROP_COLOR,Red);
     }
   if(value==1)
     {
      objectCreate("MACD_Value3",118,GraphShift+427,"q",20,"Wingdings 3",Red);
      ObjectDelete("MACD_Value2");
      ObjectDelete("MACD_Value4");
      ObjectDelete("MACD_Value1");
      ObjectDelete("MACD_Value5");
      ObjectDelete("MACD_Value6");
      ObjectSet("MACD_Value3",OBJPROP_COLOR,Red);
     }
   if(value==0)
     {
      objectCreate("MACD_Value4",122,GraphShift+427,"X",20,"Arial",Lime);
      ObjectDelete("MACD_Value2");
      ObjectDelete("MACD_Value3");
      ObjectDelete("MACD_Value1");
      ObjectDelete("MACD_Value5");
      ObjectDelete("MACD_Value6");
      ObjectSet("MACD_Value4",OBJPROP_COLOR,Lime);
     }
   if(value==4)
     {
      objectCreate("MACD_Value5",122,GraphShift+427,"0",20,"Arial",Lime);
      ObjectDelete("MACD_Value2");
      ObjectDelete("MACD_Value3");
      ObjectDelete("MACD_Value1");
      ObjectDelete("MACD_Value4");
      ObjectDelete("MACD_Value6");
      ObjectSet("MACD_Value5",OBJPROP_COLOR,Lime);
     }
   if(value==5)
     {
      objectCreate("MACD_Value6",122,GraphShift+427,"0",20,"Arial",Red);
      ObjectDelete("MACD_Value2");
      ObjectDelete("MACD_Value3");
      ObjectDelete("MACD_Value1");
      ObjectDelete("MACD_Value4");
      ObjectDelete("MACD_Value5");
      ObjectSet("MACD_Value6",OBJPROP_COLOR,Red);
     }
   ObjectSet("MACD_Title",OBJPROP_COLOR,DimGray);
   ObjectSet("MACD_Chart",OBJPROP_COLOR,SkyBlue);
   ObjectSet("MACD_Line1",OBJPROP_COLOR,DimGray);
   ObjectSet("MACD_Line2",OBJPROP_COLOR,DimGray);
  }
// MAXover Graphs -------------------
void paintMAXover(int value)
  {
   int GraphShift; if(DisplayCompact){GraphShift=-156;} else GraphShift=0;
   if(value==1)
     {
      objectCreate("MAXoverValue1",67,GraphShift+427,"p",20,"Wingdings 3",Lime);
      ObjectDelete("MAXoverValue2");
      ObjectSet("MAXoverValue1",OBJPROP_COLOR,Lime);
     }
   if(value==0)
     {
      objectCreate("MAXoverValue2",67,GraphShift+427,"q",20,"Wingdings 3",Red);
      ObjectDelete("MAXoverValue1");
      ObjectSet("MAXoverValue2",OBJPROP_COLOR,Red);
     }
   ObjectSet("MAXoverTitle",OBJPROP_COLOR,DimGray);
   ObjectSet("MAXoverChart",OBJPROP_COLOR,SkyBlue);
   ObjectSet("MAXoverLine1",OBJPROP_COLOR,DimGray);
   ObjectSet("MAXoverLine2",OBJPROP_COLOR,DimGray);
  }
// BarMeter Graphs -------------------------------

void paintBar1(double value)
  {
   if(value == 11) ObjectSet("Bar_1",OBJPROP_COLOR,C'035,035,035');
   if(value == 12) ObjectSet("Bar_1",OBJPROP_COLOR,C'000,000,000');
   if(value == 1) ObjectSet("Bar_1",OBJPROP_COLOR,C'000,255,000');
   if(value == 2) ObjectSet("Bar_1",OBJPROP_COLOR,C'000,200,000');
   if(value == 3) ObjectSet("Bar_1",OBJPROP_COLOR,C'000,150,000');
   if(value == 4) ObjectSet("Bar_1",OBJPROP_COLOR,C'000,100,000');
   if(value == 5) ObjectSet("Bar_1",OBJPROP_COLOR,C'000,070,000');
   if(value == 6) ObjectSet("Bar_1",OBJPROP_COLOR,C'070,000,000');
   if(value == 7) ObjectSet("Bar_1",OBJPROP_COLOR,C'100,000,000');
   if(value == 8) ObjectSet("Bar_1",OBJPROP_COLOR,C'150,000,000');
   if(value == 9) ObjectSet("Bar_1",OBJPROP_COLOR,C'200,000,000');
   if(value == 10) ObjectSet("Bar_1",OBJPROP_COLOR,C'255,000,000');
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintBar2(double value)
  {
   if(value == 11) ObjectSet("Bar_2",OBJPROP_COLOR,C'035,035,035');
   if(value == 12) ObjectSet("Bar_2",OBJPROP_COLOR,C'000,000,000');
   if(value == 1) ObjectSet("Bar_2",OBJPROP_COLOR,C'000,255,000');
   if(value == 2) ObjectSet("Bar_2",OBJPROP_COLOR,C'000,200,000');
   if(value == 3) ObjectSet("Bar_2",OBJPROP_COLOR,C'000,150,000');
   if(value == 4) ObjectSet("Bar_2",OBJPROP_COLOR,C'000,100,000');
   if(value == 5) ObjectSet("Bar_2",OBJPROP_COLOR,C'000,070,000');
   if(value == 6) ObjectSet("Bar_2",OBJPROP_COLOR,C'070,000,000');
   if(value == 7) ObjectSet("Bar_2",OBJPROP_COLOR,C'100,000,000');
   if(value == 8) ObjectSet("Bar_2",OBJPROP_COLOR,C'150,000,000');
   if(value == 9) ObjectSet("Bar_2",OBJPROP_COLOR,C'200,000,000');
   if(value == 10) ObjectSet("Bar_2",OBJPROP_COLOR,C'255,000,000');
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintBar3(double value)
  {
   if(value == 11) ObjectSet("Bar_3",OBJPROP_COLOR,C'035,035,035');
   if(value == 12) ObjectSet("Bar_3",OBJPROP_COLOR,C'000,000,000');
   if(value == 1) ObjectSet("Bar_3",OBJPROP_COLOR,C'000,255,000');
   if(value == 2) ObjectSet("Bar_3",OBJPROP_COLOR,C'000,200,000');
   if(value == 3) ObjectSet("Bar_3",OBJPROP_COLOR,C'000,150,000');
   if(value == 4) ObjectSet("Bar_3",OBJPROP_COLOR,C'000,100,000');
   if(value == 5) ObjectSet("Bar_3",OBJPROP_COLOR,C'000,070,000');
   if(value == 6) ObjectSet("Bar_3",OBJPROP_COLOR,C'070,000,000');
   if(value == 7) ObjectSet("Bar_3",OBJPROP_COLOR,C'100,000,000');
   if(value == 8) ObjectSet("Bar_3",OBJPROP_COLOR,C'150,000,000');
   if(value == 9) ObjectSet("Bar_3",OBJPROP_COLOR,C'200,000,000');
   if(value == 10) ObjectSet("Bar_3",OBJPROP_COLOR,C'255,000,000');
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintBar4(double value)
  {
   if(value == 11) ObjectSet("Bar_4",OBJPROP_COLOR,C'035,035,035');
   if(value == 12) ObjectSet("Bar_4",OBJPROP_COLOR,C'000,000,000');
   if(value == 1) ObjectSet("Bar_4",OBJPROP_COLOR,C'000,255,000');
   if(value == 2) ObjectSet("Bar_4",OBJPROP_COLOR,C'000,200,000');
   if(value == 3) ObjectSet("Bar_4",OBJPROP_COLOR,C'000,150,000');
   if(value == 4) ObjectSet("Bar_4",OBJPROP_COLOR,C'000,100,000');
   if(value == 5) ObjectSet("Bar_4",OBJPROP_COLOR,C'000,070,000');
   if(value == 6) ObjectSet("Bar_4",OBJPROP_COLOR,C'070,000,000');
   if(value == 7) ObjectSet("Bar_4",OBJPROP_COLOR,C'100,000,000');
   if(value == 8) ObjectSet("Bar_4",OBJPROP_COLOR,C'150,000,000');
   if(value == 9) ObjectSet("Bar_4",OBJPROP_COLOR,C'200,000,000');
   if(value == 10) ObjectSet("Bar_4",OBJPROP_COLOR,C'255,000,000');
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintBar5(double value)
  {
   if(value == 11) ObjectSet("Bar_5",OBJPROP_COLOR,C'035,035,035');
   if(value == 12) ObjectSet("Bar_5",OBJPROP_COLOR,C'000,000,000');
   if(value == 1) ObjectSet("Bar_5",OBJPROP_COLOR,C'000,255,000');
   if(value == 2) ObjectSet("Bar_5",OBJPROP_COLOR,C'000,200,000');
   if(value == 3) ObjectSet("Bar_5",OBJPROP_COLOR,C'000,150,000');
   if(value == 4) ObjectSet("Bar_5",OBJPROP_COLOR,C'000,100,000');
   if(value == 5) ObjectSet("Bar_5",OBJPROP_COLOR,C'000,070,000');
   if(value == 6) ObjectSet("Bar_5",OBJPROP_COLOR,C'070,000,000');
   if(value == 7) ObjectSet("Bar_5",OBJPROP_COLOR,C'100,000,000');
   if(value == 8) ObjectSet("Bar_5",OBJPROP_COLOR,C'150,000,000');
   if(value == 9) ObjectSet("Bar_5",OBJPROP_COLOR,C'200,000,000');
   if(value == 10) ObjectSet("Bar_5",OBJPROP_COLOR,C'255,000,000');
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintBars()
  {
   ObjectSet("BarsLine1",OBJPROP_COLOR,DimGray);
   ObjectSet("BarsLine2",OBJPROP_COLOR,DimGray);
   ObjectSet("BarsLine3",OBJPROP_COLOR,DimGray);
   ObjectSet("BarsTitle",OBJPROP_COLOR,DimGray);
   ObjectSet("BarsPercent",OBJPROP_COLOR,Silver);
   ObjectSet("BarsDescription",OBJPROP_COLOR,DimGray);
   ObjectSet("B_1",OBJPROP_COLOR,SkyBlue);
   ObjectSet("B_2",OBJPROP_COLOR,SkyBlue);
   ObjectSet("B_3",OBJPROP_COLOR,SkyBlue);
   ObjectSet("B_4",OBJPROP_COLOR,SkyBlue);
   ObjectSet("B_5",OBJPROP_COLOR,SkyBlue);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintBarValue1(double value)
  {
   ObjectSetText("Bar_Value1",DoubleToStr(value,0),8,"Arial Narrow",White);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintBarValue2(double value)
  {
   ObjectSetText("Bar_Value2",DoubleToStr(value,0),8,"Arial Narrow",DimGray);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintBarValue3(double value)
  {
   ObjectSetText("Bar_Value3",DoubleToStr(value,0),8,"Arial Narrow",DimGray);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintBarValue4(double value)
  {
   ObjectSetText("Bar_Value4",DoubleToStr(value,0),8,"Arial Narrow",DimGray);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintBarValue5(double value)
  {
   ObjectSetText("Bar_Value5",DoubleToStr(value,0),8,"Arial Narrow",DimGray);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintBarReading(int value)
  {
   int GraphShift; if(DisplayCompact){GraphShift=-156;} else GraphShift=0;
   if(value==1)
     {
      objectCreate("BarsStopped",83,GraphShift+541,"Stopped",8,"Arial",Silver);
      ObjectDelete("BarsSpeeding");
      ObjectDelete("BarsSteady");
      ObjectDelete("BarsSlowing");
      ObjectSet("BarsStopped",OBJPROP_COLOR,Silver);
     }
   if(value==2)
     {
      objectCreate("BarsSpeeding",70,GraphShift+541,"Speeding Up",8,"Arial",Silver);
      ObjectDelete("BarsStopped");
      ObjectDelete("BarsSteady");
      ObjectDelete("BarsSlowing");
      ObjectSet("BarsSpeeding",OBJPROP_COLOR,Silver);
     }
   if(value==3)
     {
      objectCreate("BarsSteady",85,GraphShift+541,"Steady",8,"Arial",Silver);
      ObjectDelete("BarsSpeeding");
      ObjectDelete("BarsStopped");
      ObjectDelete("BarsSlowing");
      ObjectSet("BarsSteady",OBJPROP_COLOR,Silver);
     }
   if(value==4)
     {
      objectCreate("BarsSlowing",70,GraphShift+541,"Slowing Down",8,"Arial",Silver);
      ObjectDelete("BarsSpeeding");
      ObjectDelete("BarsSteady");
      ObjectDelete("BarsStopped");
      ObjectSet("BarsSlowing",OBJPROP_COLOR,Silver);
     }
  }
// Signal Graphs -------------------
void paintSignal(int value)
  {
   int GraphShift; if(DisplayCompact){GraphShift=-156;} else GraphShift=0;
   if(value==1)
     {
      objectCreate("SignalDown",10,GraphShift+498,"q",28,"Wingdings 3",Red);
      ObjectDelete("SignalUp");
      ObjectDelete("SignalWait");
      ObjectSet("SignalDown",OBJPROP_COLOR,Red);
     }
   if(value==2)
     {
      objectCreate("SignalUp",10,GraphShift+498,"p",28,"Wingdings 3",Lime);
      ObjectDelete("SignalDown");
      ObjectDelete("SignalWait");
      ObjectSet("SignalUp",OBJPROP_COLOR,Lime);
     }
   if(value==0)
     {
      objectCreate("SignalWait",17,GraphShift+498,"6",28,"Wingdings",Silver);
      ObjectDelete("SignalDown");
      ObjectDelete("SignalUp");
      ObjectSet("SignalWait",OBJPROP_COLOR,DimGray);
     }
   ObjectSet("SignalLine1",OBJPROP_COLOR,DimGray);
   ObjectSet("SignalLine2",OBJPROP_COLOR,DimGray);
   ObjectSet("SignalTitle",OBJPROP_COLOR,DimGray);
  }
// Trend-O-Graph -------------------

void paintTrendGraph()
  {
   ObjectSet("TGraphLine1",OBJPROP_COLOR,DimGray);
   ObjectSet("TGraphLine2",OBJPROP_COLOR,DimGray);
   ObjectSet("TGraphLine3",OBJPROP_COLOR,DimGray);
   ObjectSet("TGraphTitle",OBJPROP_COLOR,DimGray);
   ObjectSet("TGM_1",OBJPROP_COLOR,SkyBlue);
   ObjectSet("TGM_5",OBJPROP_COLOR,SkyBlue);
   ObjectSet("TGM_15",OBJPROP_COLOR,SkyBlue);
   ObjectSet("TGM_30",OBJPROP_COLOR,SkyBlue);
   ObjectSet("TGH_1",OBJPROP_COLOR,SkyBlue);
   ObjectSet("TGH_4",OBJPROP_COLOR,SkyBlue);
   ObjectSet("TGD_1",OBJPROP_COLOR,SkyBlue);
   ObjectSet("TGMA_1",OBJPROP_COLOR,SkyBlue);
   ObjectSet("TGMA_2",OBJPROP_COLOR,SkyBlue);
   ObjectSet("TGMA_3",OBJPROP_COLOR,SkyBlue);
   ObjectSet("TGMA_4",OBJPROP_COLOR,SkyBlue);
   ObjectSet("TGMA_5",OBJPROP_COLOR,SkyBlue);
   ObjectSet("TGMA_6",OBJPROP_COLOR,SkyBlue);
   ObjectSet("TGMA_7",OBJPROP_COLOR,SkyBlue);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA1M1(int value)
  {
   if(value==1) {ObjectSet("TGM_1_MA1",OBJPROP_COLOR,C'000,200,000');}
   if(value==0) {ObjectSet("TGM_1_MA1",OBJPROP_COLOR,C'200,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA1M5(int value)
  {
   if(value==1) {ObjectSet("TGM_5_MA1",OBJPROP_COLOR,C'000,190,000');}
   if(value==0) {ObjectSet("TGM_5_MA1",OBJPROP_COLOR,C'190,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA1M15(int value)
  {
   if(value==1) {ObjectSet("TGM_15_MA1",OBJPROP_COLOR,C'000,180,000');}
   if(value==0) {ObjectSet("TGM_15_MA1",OBJPROP_COLOR,C'180,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA1M30(int value)
  {
   if(value==1) {ObjectSet("TGM_30_MA1",OBJPROP_COLOR,C'000,170,000');}
   if(value==0) {ObjectSet("TGM_30_MA1",OBJPROP_COLOR,C'170,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA1H1(int value)
  {
   if(value==1){ObjectSet("TGH_1_MA1",OBJPROP_COLOR,C'000,160,000');}
   if(value==0){ObjectSet("TGH_1_MA1",OBJPROP_COLOR,C'160,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA1H4(int value)
  {
   if(value==1) {ObjectSet("TGH_4_MA1",OBJPROP_COLOR,C'000,150,000');}
   if(value==0) {ObjectSet("TGH_4_MA1",OBJPROP_COLOR,C'150,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA1D1(int value)
  {
   if(value==1) {ObjectSet("TGD_1_MA1",OBJPROP_COLOR,C'000,140,000');}
   if(value==0) {ObjectSet("TGD_1_MA1",OBJPROP_COLOR,C'140,000,000');}
  }
// -------------------------------------------------------------- 
void paintTGMA2M1(int value)
  {
   if(value==1) {ObjectSet("TGM_1_MA2",OBJPROP_COLOR,C'000,190,000');}
   if(value==0) {ObjectSet("TGM_1_MA2",OBJPROP_COLOR,C'190,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA2M5(int value)
  {
   if(value==1) {ObjectSet("TGM_5_MA2",OBJPROP_COLOR,C'000,180,000');}
   if(value==0) {ObjectSet("TGM_5_MA2",OBJPROP_COLOR,C'180,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA2M15(int value)
  {
   if(value==1) {ObjectSet("TGM_15_MA2",OBJPROP_COLOR,C'000,170,000');}
   if(value==0) {ObjectSet("TGM_15_MA2",OBJPROP_COLOR,C'170,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA2M30(int value)
  {
   if(value==1) {ObjectSet("TGM_30_MA2",OBJPROP_COLOR,C'000,160,000');}
   if(value==0) {ObjectSet("TGM_30_MA2",OBJPROP_COLOR,C'160,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA2H1(int value)
  {
   if(value==1) {ObjectSet("TGH_1_MA2",OBJPROP_COLOR,C'000,150,000');}
   if(value==0) {ObjectSet("TGH_1_MA2",OBJPROP_COLOR,C'150,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA2H4(int value)
  {
   if(value==1) {ObjectSet("TGH_4_MA2",OBJPROP_COLOR,C'000,140,000');}
   if(value==0) {ObjectSet("TGH_4_MA2",OBJPROP_COLOR,C'140,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA2D1(int value)
  {
   if(value==1) {ObjectSet("TGD_1_MA2",OBJPROP_COLOR,C'000,130,000');}
   if(value==0) {ObjectSet("TGD_1_MA2",OBJPROP_COLOR,C'130,000,000');}
  }
// -------------------------------------------------------------- 
void paintTGMA3M1(int value)
  {
   if(value==1) {ObjectSet("TGM_1_MA3",OBJPROP_COLOR,C'000,180,000');}
   if(value==0) {ObjectSet("TGM_1_MA3",OBJPROP_COLOR,C'180,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA3M5(int value)
  {
   if(value==1) {ObjectSet("TGM_5_MA3",OBJPROP_COLOR,C'000,170,000');}
   if(value==0) {ObjectSet("TGM_5_MA3",OBJPROP_COLOR,C'170,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA3M15(int value)
  {
   if(value==1) {ObjectSet("TGM_15_MA3",OBJPROP_COLOR,C'000,160,000');}
   if(value==0) {ObjectSet("TGM_15_MA3",OBJPROP_COLOR,C'160,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA3M30(int value)
  {
   if(value==1) {ObjectSet("TGM_30_MA3",OBJPROP_COLOR,C'000,150,000');}
   if(value==0) {ObjectSet("TGM_30_MA3",OBJPROP_COLOR,C'150,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA3H1(int value)
  {
   if(value==1) {ObjectSet("TGH_1_MA3",OBJPROP_COLOR,C'000,140,000');}
   if(value==0) {ObjectSet("TGH_1_MA3",OBJPROP_COLOR,C'140,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA3H4(int value)
  {
   if(value==1) {ObjectSet("TGH_4_MA3",OBJPROP_COLOR,C'000,130,000');}
   if(value==0) {ObjectSet("TGH_4_MA3",OBJPROP_COLOR,C'130,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA3D1(int value)
  {
   if(value==1) {ObjectSet("TGD_1_MA3",OBJPROP_COLOR,C'000,120,000');}
   if(value==0) {ObjectSet("TGD_1_MA3",OBJPROP_COLOR,C'120,000,000');}
  }
// -------------------------------------------------------------- 
void paintTGMA4M1(int value)
  {
   if(value==1) {ObjectSet("TGM_1_MA4",OBJPROP_COLOR,C'000,170,000');}
   if(value==0) {ObjectSet("TGM_1_MA4",OBJPROP_COLOR,C'170,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA4M5(int value)
  {
   if(value==1) {ObjectSet("TGM_5_MA4",OBJPROP_COLOR,C'000,160,000');}
   if(value==0) {ObjectSet("TGM_5_MA4",OBJPROP_COLOR,C'160,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA4M15(int value)
  {
   if(value==1) {ObjectSet("TGM_15_MA4",OBJPROP_COLOR,C'000,150,000');}
   if(value==0) {ObjectSet("TGM_15_MA4",OBJPROP_COLOR,C'150,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA4M30(int value)
  {
   if(value==1) {ObjectSet("TGM_30_MA4",OBJPROP_COLOR,C'000,140,000');}
   if(value==0) {ObjectSet("TGM_30_MA4",OBJPROP_COLOR,C'140,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA4H1(int value)
  {
   if(value==1) {ObjectSet("TGH_1_MA4",OBJPROP_COLOR,C'000,130,000');}
   if(value==0) {ObjectSet("TGH_1_MA4",OBJPROP_COLOR,C'130,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA4H4(int value)
  {
   if(value==1) {ObjectSet("TGH_4_MA4",OBJPROP_COLOR,C'000,120,000');}
   if(value==0) {ObjectSet("TGH_4_MA4",OBJPROP_COLOR,C'120,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA4D1(int value)
  {
   if(value==1) {ObjectSet("TGD_1_MA4",OBJPROP_COLOR,C'000,110,000');}
   if(value==0) {ObjectSet("TGD_1_MA4",OBJPROP_COLOR,C'110,000,000');}
  }
// -------------------------------------------------------------- 
void paintTGMA5M1(int value)
  {
   if(value==1) {ObjectSet("TGM_1_MA5",OBJPROP_COLOR,C'000,160,000');}
   if(value==0) {ObjectSet("TGM_1_MA5",OBJPROP_COLOR,C'160,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA5M5(int value)
  {
   if(value==1) {ObjectSet("TGM_5_MA5",OBJPROP_COLOR,C'000,150,000');}
   if(value==0) {ObjectSet("TGM_5_MA5",OBJPROP_COLOR,C'150,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA5M15(int value)
  {
   if(value==1) {ObjectSet("TGM_15_MA5",OBJPROP_COLOR,C'000,140,000');}
   if(value==0) {ObjectSet("TGM_15_MA5",OBJPROP_COLOR,C'140,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA5M30(int value)
  {
   if(value==1) {ObjectSet("TGM_30_MA5",OBJPROP_COLOR,C'000,130,000');}
   if(value==0) {ObjectSet("TGM_30_MA5",OBJPROP_COLOR,C'130,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA5H1(int value)
  {
   if(value==1) {ObjectSet("TGH_1_MA5",OBJPROP_COLOR,C'000,120,000');}
   if(value==0) {ObjectSet("TGH_1_MA5",OBJPROP_COLOR,C'120,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA5H4(int value)
  {
   if(value==1) {ObjectSet("TGH_4_MA5",OBJPROP_COLOR,C'000,110,000');}
   if(value==0) {ObjectSet("TGH_4_MA5",OBJPROP_COLOR,C'110,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA5D1(int value)
  {
   if(value==1) {ObjectSet("TGD_1_MA5",OBJPROP_COLOR,C'000,100,000');}
   if(value==0) {ObjectSet("TGD_1_MA5",OBJPROP_COLOR,C'100,000,000');}
  }
// -------------------------------------------------------------- 
void paintTGMA6M1(int value)
  {
   if(value==1) {ObjectSet("TGM_1_MA6",OBJPROP_COLOR,C'000,150,000');}
   if(value==0) {ObjectSet("TGM_1_MA6",OBJPROP_COLOR,C'150,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA6M5(int value)
  {
   if(value==1) {ObjectSet("TGM_5_MA6",OBJPROP_COLOR,C'000,140,000');}
   if(value==0){ObjectSet("TGM_5_MA6",OBJPROP_COLOR,C'140,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA6M15(int value)
  {
   if(value==1) {ObjectSet("TGM_15_MA6",OBJPROP_COLOR,C'000,130,000');}
   if(value==0) {ObjectSet("TGM_15_MA6",OBJPROP_COLOR,C'130,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA6M30(int value)
  {
   if(value==1) {ObjectSet("TGM_30_MA6",OBJPROP_COLOR,C'000,120,000');}
   if(value==0) {ObjectSet("TGM_30_MA6",OBJPROP_COLOR,C'120,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA6H1(int value)
  {
   if(value==1) {ObjectSet("TGH_1_MA6",OBJPROP_COLOR,C'000,110,000');}
   if(value==0) {ObjectSet("TGH_1_MA6",OBJPROP_COLOR,C'110,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA6H4(int value)
  {
   if(value==1) {ObjectSet("TGH_4_MA6",OBJPROP_COLOR,C'000,100,000');}
   if(value==0) {ObjectSet("TGH_4_MA6",OBJPROP_COLOR,C'100,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA6D1(int value)
  {
   if(value==1) {ObjectSet("TGD_1_MA6",OBJPROP_COLOR,C'000,090,000');}
   if(value==0) {ObjectSet("TGD_1_MA6",OBJPROP_COLOR,C'090,000,000');}
  }
// -------------------------------------------------------------- 
void paintTGMA7M1(int value)
  {
   if(value==1) {ObjectSet("TGM_1_MA7",OBJPROP_COLOR,C'000,140,000');}
   if(value==0) {ObjectSet("TGM_1_MA7",OBJPROP_COLOR,C'140,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA7M5(int value)
  {
   if(value==1) {ObjectSet("TGM_5_MA7",OBJPROP_COLOR,C'000,130,000');}
   if(value==0) {ObjectSet("TGM_5_MA7",OBJPROP_COLOR,C'130,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA7M15(int value)
  {
   if(value==1) {ObjectSet("TGM_15_MA7",OBJPROP_COLOR,C'000,120,000');}
   if(value==0) {ObjectSet("TGM_15_MA7",OBJPROP_COLOR,C'120,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA7M30(int value)
  {
   if(value==1) {ObjectSet("TGM_30_MA7",OBJPROP_COLOR,C'000,110,000');}
   if(value==0) {ObjectSet("TGM_30_MA7",OBJPROP_COLOR,C'110,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA7H1(int value)
  {
   if(value==1) {ObjectSet("TGH_1_MA7",OBJPROP_COLOR,C'000,100,000');}
   if(value==0) {ObjectSet("TGH_1_MA7",OBJPROP_COLOR,C'100,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA7H4(int value)
  {
   if(value==1) {ObjectSet("TGH_4_MA7",OBJPROP_COLOR,C'000,090,000');}
   if(value==0) {ObjectSet("TGH_4_MA7",OBJPROP_COLOR,C'090,000,000');}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintTGMA7D1(int value)
  {
   if(value==1) {ObjectSet("TGD_1_MA7",OBJPROP_COLOR,C'000,080,000');}
   if(value==0) {ObjectSet("TGD_1_MA7",OBJPROP_COLOR,C'080,000,000');}
  }
// Overbought/Oversold Map --------------------------------------
void paintOBOSMap()
  {
   ObjectSet("OBOSLine1",OBJPROP_COLOR,DimGray);
   ObjectSet("OBOSLine2",OBJPROP_COLOR,DimGray);
   ObjectSet("OBOSLine3",OBJPROP_COLOR,DimGray);
   ObjectSet("OBOSTitle",OBJPROP_COLOR,DimGray);
   ObjectSet("OBOSM_1",OBJPROP_COLOR,SkyBlue);
   ObjectSet("OBOSM_5",OBJPROP_COLOR,SkyBlue);
   ObjectSet("OBOSM_15",OBJPROP_COLOR,SkyBlue);
   ObjectSet("OBOSM_30",OBJPROP_COLOR,SkyBlue);
   ObjectSet("OBOSH_1",OBJPROP_COLOR,SkyBlue);
   ObjectSet("OBOSH_4",OBJPROP_COLOR,SkyBlue);
   ObjectSet("OBOSD_1",OBJPROP_COLOR,SkyBlue);
   ObjectSet("OBOSBB",OBJPROP_COLOR,SkyBlue);
   ObjectSet("OBOSRSI",OBJPROP_COLOR,SkyBlue);
   ObjectSet("OBOSCCI",OBJPROP_COLOR,SkyBlue);
   ObjectSet("OBOSMFI",OBJPROP_COLOR,SkyBlue);
   ObjectSet("OBOSWPR",OBJPROP_COLOR,SkyBlue);
   ObjectSet("OBOSSTO",OBJPROP_COLOR,SkyBlue);
   ObjectSet("OBOSMAC",OBJPROP_COLOR,SkyBlue);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSMACM1(int value)
  {
   if(value==1) {object5Create("OBOSMACM1",136,204); ObjectSet("OBOSMACM1",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSMACM1none");}
   if(value==0) {object4Create("OBOSMACM1none",128,186);ObjectSet("OBOSMACM1none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSMACM1");}
   if(value==2) {object5Create("OBOSMACM1",136,204);ObjectSet("OBOSMACM1",OBJPROP_COLOR,Lime); ObjectDelete("OBOSMACM1none");}
   if(value==3) {object5Create("OBOSMACM1",136,204);ObjectSet("OBOSMACM1",OBJPROP_COLOR,Red); ObjectDelete("OBOSMACM1none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSMACM5(int value)
  {
   if(value==1) {object5Create("OBOSMACM5",119,204); ObjectSet("OBOSMACM5",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSMACM5none");}
   if(value==0) {object4Create("OBOSMACM5none",111,186);ObjectSet("OBOSMACM5none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSMACM5");}
   if(value==2) {object5Create("OBOSMACM5",119,204);ObjectSet("OBOSMACM5",OBJPROP_COLOR,Lime); ObjectDelete("OBOSMACM5none");}
   if(value==3) {object5Create("OBOSMACM5",119,204);ObjectSet("OBOSMACM5",OBJPROP_COLOR,Red); ObjectDelete("OBOSMACM5none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSMACM15(int value)
  {
   if(value==1) {object5Create("OBOSMACM15",102,204); ObjectSet("OBOSMACM15",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSMACM15none");}
   if(value==0) {object4Create("OBOSMACM15none",94,186);ObjectSet("OBOSMACM15none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSMACM15");}
   if(value==2) {object5Create("OBOSMACM15",102,204);ObjectSet("OBOSMACM15",OBJPROP_COLOR,Lime); ObjectDelete("OBOSMACM15none");}
   if(value==3) {object5Create("OBOSMACM15",102,204);ObjectSet("OBOSMACM15",OBJPROP_COLOR,Red); ObjectDelete("OBOSMACM15none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSMACM30(int value)
  {
   if(value==1) {object5Create("OBOSMACM30",85,204); ObjectSet("OBOSMACM30",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSMACM30none");}
   if(value==0) {object4Create("OBOSMACM30none",77,186);ObjectSet("OBOSMACM30none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSMACM30");}
   if(value==2) {object5Create("OBOSMACM30",85,204);ObjectSet("OBOSMACM30",OBJPROP_COLOR,Lime); ObjectDelete("OBOSMACM30none");}
   if(value==3) {object5Create("OBOSMACM30",85,204);ObjectSet("OBOSMACM30",OBJPROP_COLOR,Red); ObjectDelete("OBOSMACM30none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSMACH1(int value)
  {
   if(value==1) {object5Create("OBOSMACH1",68,204); ObjectSet("OBOSMACH1",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSMACH1none");}
   if(value==0) {object4Create("OBOSMACH1none",60,186);ObjectSet("OBOSMACH1none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSMACH1");}
   if(value==2) {object5Create("OBOSMACH1",68,204);ObjectSet("OBOSMACH1",OBJPROP_COLOR,Lime); ObjectDelete("OBOSMACH1none");}
   if(value==3) {object5Create("OBOSMACH1",68,204);ObjectSet("OBOSMACH1",OBJPROP_COLOR,Red); ObjectDelete("OBOSMACH1none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSMACH4(int value)
  {
   if(value==1) {object5Create("OBOSMACH4",51,204); ObjectSet("OBOSMACH4",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSMACH4none");}
   if(value==0) {object4Create("OBOSMACH4none",43,186);ObjectSet("OBOSMACH4none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSMACH4");}
   if(value==2) {object5Create("OBOSMACH4",51,204);ObjectSet("OBOSMACH4",OBJPROP_COLOR,Lime); ObjectDelete("OBOSMACH4none");}
   if(value==3) {object5Create("OBOSMACH4",51,204);ObjectSet("OBOSMACH4",OBJPROP_COLOR,Red); ObjectDelete("OBOSMACH4none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSMACD1(int value)
  {
   if(value==1) {object5Create("OBOSMACD1",34,204); ObjectSet("OBOSMACD1",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSMACD1none");}
   if(value==0) {object4Create("OBOSMACD1none",26,186);ObjectSet("OBOSMACD1none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSMACD1");}
   if(value==2) {object5Create("OBOSMACD1",34,204);ObjectSet("OBOSMACD1",OBJPROP_COLOR,Lime); ObjectDelete("OBOSMACD1none");}
   if(value==3) {object5Create("OBOSMACD1",34,204);ObjectSet("OBOSMACD1",OBJPROP_COLOR,Red); ObjectDelete("OBOSMACD1none");}
  }
// -------------------------------------------------------------- 
void paintOBOSSTOM1(int value)
  {
   if(value==1) {object5Create("OBOSSTOM1",136,221); ObjectSet("OBOSSTOM1",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSSTOM1none");}
   if(value==0) {object4Create("OBOSSTOM1none",128,203);ObjectSet("OBOSSTOM1none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSSTOM1");}
   if(value==2) {object5Create("OBOSSTOM1",136,221);ObjectSet("OBOSSTOM1",OBJPROP_COLOR,Lime); ObjectDelete("OBOSSTOM1none");}
   if(value==3) {object5Create("OBOSSTOM1",136,221);ObjectSet("OBOSSTOM1",OBJPROP_COLOR,Red); ObjectDelete("OBOSSTOM1none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSSTOM5(int value)
  {
   if(value==1) {object5Create("OBOSSTOM5",119,221); ObjectSet("OBOSSTOM5",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSSTOM5none");}
   if(value==0) {object4Create("OBOSSTOM5none",111,203);ObjectSet("OBOSSTOM5none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSSTOM5");}
   if(value==2) {object5Create("OBOSSTOM5",119,221);ObjectSet("OBOSSTOM5",OBJPROP_COLOR,Lime); ObjectDelete("OBOSSTOM5none");}
   if(value==3) {object5Create("OBOSSTOM5",119,221);ObjectSet("OBOSSTOM5",OBJPROP_COLOR,Red); ObjectDelete("OBOSSTOM5none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSSTOM15(int value)
  {
   if(value==1) {object5Create("OBOSSTOM15",102,221); ObjectSet("OBOSSTOM15",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSSTOM15none");}
   if(value==0) {object4Create("OBOSSTOM15none",94,203);ObjectSet("OBOSSTOM15none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSSTOM15");}
   if(value==2) {object5Create("OBOSSTOM15",102,221);ObjectSet("OBOSSTOM15",OBJPROP_COLOR,Lime); ObjectDelete("OBOSSTOM15none");}
   if(value==3) {object5Create("OBOSSTOM15",102,221);ObjectSet("OBOSSTOM15",OBJPROP_COLOR,Red); ObjectDelete("OBOSSTOM15none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSSTOM30(int value)
  {
   if(value==1) {object5Create("OBOSSTOM30",85,221); ObjectSet("OBOSSTOM30",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSSTOM30none");}
   if(value==0) {object4Create("OBOSSTOM30none",77,203);ObjectSet("OBOSSTOM30none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSSTOM30");}
   if(value==2) {object5Create("OBOSSTOM30",85,221);ObjectSet("OBOSSTOM30",OBJPROP_COLOR,Lime); ObjectDelete("OBOSSTOM30none");}
   if(value==3) {object5Create("OBOSSTOM30",85,221);ObjectSet("OBOSSTOM30",OBJPROP_COLOR,Red); ObjectDelete("OBOSSTOM30none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSSTOH1(int value)
  {
   if(value==1) {object5Create("OBOSSTOH1",68,221); ObjectSet("OBOSSTOH1",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSSTOH1none");}
   if(value==0) {object4Create("OBOSSTOH1none",60,203);ObjectSet("OBOSSTOH1none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSSTOH1");}
   if(value==2) {object5Create("OBOSSTOH1",68,221);ObjectSet("OBOSSTOH1",OBJPROP_COLOR,Lime); ObjectDelete("OBOSSTOH1none");}
   if(value==3) {object5Create("OBOSSTOH1",68,221);ObjectSet("OBOSSTOH1",OBJPROP_COLOR,Red); ObjectDelete("OBOSSTOH1none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSSTOH4(int value)
  {
   if(value==1) {object5Create("OBOSSTOH4",51,221); ObjectSet("OBOSSTOH4",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSSTOH4none");}
   if(value==0) {object4Create("OBOSSTOH4none",43,203);ObjectSet("OBOSSTOH4none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSSTOH4");}
   if(value==2) {object5Create("OBOSSTOH4",51,221);ObjectSet("OBOSSTOH4",OBJPROP_COLOR,Lime); ObjectDelete("OBOSSTOH4none");}
   if(value==3) {object5Create("OBOSSTOH4",51,221);ObjectSet("OBOSSTOH4",OBJPROP_COLOR,Red); ObjectDelete("OBOSSTOH4none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSSTOD1(int value)
  {
   if(value==1) {object5Create("OBOSSTOD1",34,221); ObjectSet("OBOSSTOD1",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSSTOD1none");}
   if(value==0) {object4Create("OBOSSTOD1none",26,203);ObjectSet("OBOSSTOD1none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSSTOD1");}
   if(value==2) {object5Create("OBOSSTOD1",34,221);ObjectSet("OBOSSTOD1",OBJPROP_COLOR,Lime); ObjectDelete("OBOSSTOD1none");}
   if(value==3) {object5Create("OBOSSTOD1",34,221);ObjectSet("OBOSSTOD1",OBJPROP_COLOR,Red); ObjectDelete("OBOSSTOD1none");}
  }
// -------------------------------------------------------------- 
void paintOBOSWPRM1(int value)
  {
   if(value==1) {object5Create("OBOSWPRM1",136,238); ObjectSet("OBOSWPRM1",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSWPRM1none");}
   if(value==0) {object4Create("OBOSWPRM1none",128,220);ObjectSet("OBOSWPRM1none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSWPRM1");}
   if(value==2) {object5Create("OBOSWPRM1",136,238);ObjectSet("OBOSWPRM1",OBJPROP_COLOR,Lime); ObjectDelete("OBOSWPRM1none");}
   if(value==3) {object5Create("OBOSWPRM1",136,238);ObjectSet("OBOSWPRM1",OBJPROP_COLOR,Red); ObjectDelete("OBOSWPRM1none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSWPRM5(int value)
  {
   if(value==1) {object5Create("OBOSWPRM5",119,238); ObjectSet("OBOSWPRM5",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSWPRM5none");}
   if(value==0) {object4Create("OBOSWPRM5none",111,220);ObjectSet("OBOSWPRM5none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSWPRM5");}
   if(value==2) {object5Create("OBOSWPRM5",119,238);ObjectSet("OBOSWPRM5",OBJPROP_COLOR,Lime); ObjectDelete("OBOSWPRM5none");}
   if(value==3) {object5Create("OBOSWPRM5",119,238);ObjectSet("OBOSWPRM5",OBJPROP_COLOR,Red); ObjectDelete("OBOSWPRM5none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSWPRM15(int value)
  {
   if(value==1) {object5Create("OBOSWPRM15",102,238); ObjectSet("OBOSWPRM15",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSWPRM15none");}
   if(value==0) {object4Create("OBOSWPRM15none",94,220);ObjectSet("OBOSWPRM15none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSWPRM15");}
   if(value==2) {object5Create("OBOSWPRM15",102,238);ObjectSet("OBOSWPRM15",OBJPROP_COLOR,Lime); ObjectDelete("OBOSWPRM15none");}
   if(value==3) {object5Create("OBOSWPRM15",102,238);ObjectSet("OBOSWPRM15",OBJPROP_COLOR,Red); ObjectDelete("OBOSWPRM15none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSWPRM30(int value)
  {
   if(value==1) {object5Create("OBOSWPRM30",85,238); ObjectSet("OBOSWPRM30",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSWPRM30none");}
   if(value==0) {object4Create("OBOSWPRM30none",77,220);ObjectSet("OBOSWPRM30none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSWPRM30");}
   if(value==2) {object5Create("OBOSWPRM30",85,238);ObjectSet("OBOSWPRM30",OBJPROP_COLOR,Lime); ObjectDelete("OBOSWPRM30none");}
   if(value==3) {object5Create("OBOSWPRM30",85,238);ObjectSet("OBOSWPRM30",OBJPROP_COLOR,Red); ObjectDelete("OBOSWPRM30none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSWPRH1(int value)
  {
   if(value==1) {object5Create("OBOSWPRH1",68,238); ObjectSet("OBOSWPRH1",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSWPRH1none");}
   if(value==0) {object4Create("OBOSWPRH1none",60,220);ObjectSet("OBOSWPRH1none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSWPRH1");}
   if(value==2) {object5Create("OBOSWPRH1",68,238);ObjectSet("OBOSWPRH1",OBJPROP_COLOR,Lime); ObjectDelete("OBOSWPRH1none");}
   if(value==3) {object5Create("OBOSWPRH1",68,238);ObjectSet("OBOSWPRH1",OBJPROP_COLOR,Red); ObjectDelete("OBOSWPRH1none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSWPRH4(int value)
  {
   if(value==1) {object5Create("OBOSWPRH4",51,238); ObjectSet("OBOSWPRH4",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSWPRH4none");}
   if(value==0) {object4Create("OBOSWPRH4none",43,220);ObjectSet("OBOSWPRH4none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSWPRH4");}
   if(value==2) {object5Create("OBOSWPRH4",51,238);ObjectSet("OBOSWPRH4",OBJPROP_COLOR,Lime); ObjectDelete("OBOSWPRH4none");}
   if(value==3) {object5Create("OBOSWPRH4",51,238);ObjectSet("OBOSWPRH4",OBJPROP_COLOR,Red); ObjectDelete("OBOSWPRH4none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSWPRD1(int value)
  {
   if(value==1) {object5Create("OBOSWPRD1",34,238); ObjectSet("OBOSWPRD1",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSWPRD1none");}
   if(value==0) {object4Create("OBOSWPRD1none",26,220);ObjectSet("OBOSWPRD1none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSWPRD1");}
   if(value==2) {object5Create("OBOSWPRD1",34,238);ObjectSet("OBOSWPRD1",OBJPROP_COLOR,Lime); ObjectDelete("OBOSWPRD1none");}
   if(value==3) {object5Create("OBOSWPRD1",34,238);ObjectSet("OBOSWPRD1",OBJPROP_COLOR,Red); ObjectDelete("OBOSWPRD1none");}
  }
// -------------------------------------------------------------- 
void paintOBOSMFIM1(int value)
  {
   if(value==1) {object5Create("OBOSMFIM1",136,255); ObjectSet("OBOSMFIM1",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSMFIM1none");}
   if(value==0) {object4Create("OBOSMFIM1none",128,237);ObjectSet("OBOSMFIM1none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSMFIM1");}
   if(value==2) {object5Create("OBOSMFIM1",136,255);ObjectSet("OBOSMFIM1",OBJPROP_COLOR,Lime); ObjectDelete("OBOSMFIM1none");}
   if(value==3) {object5Create("OBOSMFIM1",136,255);ObjectSet("OBOSMFIM1",OBJPROP_COLOR,Red); ObjectDelete("OBOSMFIM1none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSMFIM5(int value)
  {
   if(value==1) {object5Create("OBOSMFIM5",119,255); ObjectSet("OBOSMFIM5",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSMFIM5none");}
   if(value==0) {object4Create("OBOSMFIM5none",111,237);ObjectSet("OBOSMFIM5none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSMFIM5");}
   if(value==2) {object5Create("OBOSMFIM5",119,255);ObjectSet("OBOSMFIM5",OBJPROP_COLOR,Lime); ObjectDelete("OBOSMFIM5none");}
   if(value==3) {object5Create("OBOSMFIM5",119,255);ObjectSet("OBOSMFIM5",OBJPROP_COLOR,Red); ObjectDelete("OBOSMFIM5none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSMFIM15(int value)
  {
   if(value==1) {object5Create("OBOSMFIM15",102,255); ObjectSet("OBOSMFIM15",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSMFIM15none");}
   if(value==0) {object4Create("OBOSMFIM15none",94,237);ObjectSet("OBOSMFIM15none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSMFIM15");}
   if(value==2) {object5Create("OBOSMFIM15",102,255);ObjectSet("OBOSMFIM15",OBJPROP_COLOR,Lime); ObjectDelete("OBOSMFIM15none");}
   if(value==3) {object5Create("OBOSMFIM15",102,255);ObjectSet("OBOSMFIM15",OBJPROP_COLOR,Red); ObjectDelete("OBOSMFIM15none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSMFIM30(int value)
  {
   if(value==1) {object5Create("OBOSMFIM30",85,255); ObjectSet("OBOSMFIM30",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSMFIM30none");}
   if(value==0) {object4Create("OBOSMFIM30none",77,237);ObjectSet("OBOSMFIM30none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSMFIM30");}
   if(value==2) {object5Create("OBOSMFIM30",85,255);ObjectSet("OBOSMFIM30",OBJPROP_COLOR,Lime); ObjectDelete("OBOSMFIM30none");}
   if(value==3) {object5Create("OBOSMFIM30",85,255);ObjectSet("OBOSMFIM30",OBJPROP_COLOR,Red); ObjectDelete("OBOSMFIM30none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSMFIH1(int value)
  {
   if(value==1) {object5Create("OBOSMFIH1",68,255); ObjectSet("OBOSMFIH1",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSMFIH1none");}
   if(value==0) {object4Create("OBOSMFIH1none",60,237);ObjectSet("OBOSMFIH1none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSMFIH1");}
   if(value==2) {object5Create("OBOSMFIH1",68,255);ObjectSet("OBOSMFIH1",OBJPROP_COLOR,Lime); ObjectDelete("OBOSMFIH1none");}
   if(value==3) {object5Create("OBOSMFIH1",68,255);ObjectSet("OBOSMFIH1",OBJPROP_COLOR,Red); ObjectDelete("OBOSMFIH1none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSMFIH4(int value)
  {
   if(value==1) {object5Create("OBOSMFIH4",51,255); ObjectSet("OBOSMFIH4",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSMFIH4none");}
   if(value==0) {object4Create("OBOSMFIH4none",43,237);ObjectSet("OBOSMFIH4none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSMFIH4");}
   if(value==2) {object5Create("OBOSMFIH4",51,255);ObjectSet("OBOSMFIH4",OBJPROP_COLOR,Lime); ObjectDelete("OBOSMFIH4none");}
   if(value==3) {object5Create("OBOSMFIH4",51,255);ObjectSet("OBOSMFIH4",OBJPROP_COLOR,Red); ObjectDelete("OBOSMFIH4none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSMFID1(int value)
  {
   if(value==1) {object5Create("OBOSMFID1",34,255); ObjectSet("OBOSMFID1",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSMFID1none");}
   if(value==0) {object4Create("OBOSMFID1none",26,237);ObjectSet("OBOSMFID1none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSMFID1");}
   if(value==2) {object5Create("OBOSMFID1",34,255);ObjectSet("OBOSMFID1",OBJPROP_COLOR,Lime); ObjectDelete("OBOSMFID1none");}
   if(value==3) {object5Create("OBOSMFID1",34,255);ObjectSet("OBOSMFID1",OBJPROP_COLOR,Red); ObjectDelete("OBOSMFID1none");}
  }
// -------------------------------------------------------------- 
void paintOBOSCCIM1(int value)
  {
   if(value==1) {object5Create("OBOSCCIM1",136,272); ObjectSet("OBOSCCIM1",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSCCIM1none");}
   if(value==0) {object4Create("OBOSCCIM1none",128,254);ObjectSet("OBOSCCIM1none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSCCIM1");}
   if(value==2) {object5Create("OBOSCCIM1",136,272);ObjectSet("OBOSCCIM1",OBJPROP_COLOR,Lime); ObjectDelete("OBOSCCIM1none");}
   if(value==3) {object5Create("OBOSCCIM1",136,272);ObjectSet("OBOSCCIM1",OBJPROP_COLOR,Red); ObjectDelete("OBOSCCIM1none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSCCIM5(int value)
  {
   if(value==1) {object5Create("OBOSCCIM5",119,272); ObjectSet("OBOSCCIM5",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSCCIM5none");}
   if(value==0) {object4Create("OBOSCCIM5none",111,254);ObjectSet("OBOSCCIM5none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSCCIM5");}
   if(value==2) {object5Create("OBOSCCIM5",119,272);ObjectSet("OBOSCCIM5",OBJPROP_COLOR,Lime); ObjectDelete("OBOSCCIM5none");}
   if(value==3) {object5Create("OBOSCCIM5",119,272);ObjectSet("OBOSCCIM5",OBJPROP_COLOR,Red); ObjectDelete("OBOSCCIM5none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSCCIM15(int value)
  {
   if(value==1) {object5Create("OBOSCCIM15",102,272); ObjectSet("OBOSCCIM15",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSCCIM15none");}
   if(value==0) {object4Create("OBOSCCIM15none",94,254);ObjectSet("OBOSCCIM15none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSCCIM15");}
   if(value==2) {object5Create("OBOSCCIM15",102,272);ObjectSet("OBOSCCIM15",OBJPROP_COLOR,Lime); ObjectDelete("OBOSCCIM15none");}
   if(value==3) {object5Create("OBOSCCIM15",102,272);ObjectSet("OBOSCCIM15",OBJPROP_COLOR,Red); ObjectDelete("OBOSCCIM15none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSCCIM30(int value)
  {
   if(value==1) {object5Create("OBOSCCIM30",85,272); ObjectSet("OBOSCCIM30",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSCCIM30none");}
   if(value==0) {object4Create("OBOSCCIM30none",77,254);ObjectSet("OBOSCCIM30none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSCCIM30");}
   if(value==2) {object5Create("OBOSCCIM30",85,272);ObjectSet("OBOSCCIM30",OBJPROP_COLOR,Lime); ObjectDelete("OBOSCCIM30none");}
   if(value==3) {object5Create("OBOSCCIM30",85,272);ObjectSet("OBOSCCIM30",OBJPROP_COLOR,Red); ObjectDelete("OBOSCCIM30none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSCCIH1(int value)
  {
   if(value==1) {object5Create("OBOSCCIH1",68,272); ObjectSet("OBOSCCIH1",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSCCIH1none");}
   if(value==0) {object4Create("OBOSCCIH1none",60,254);ObjectSet("OBOSCCIH1none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSCCIH1");}
   if(value==2) {object5Create("OBOSCCIH1",68,272);ObjectSet("OBOSCCIH1",OBJPROP_COLOR,Lime); ObjectDelete("OBOSCCIH1none");}
   if(value==3) {object5Create("OBOSCCIH1",68,272);ObjectSet("OBOSCCIH1",OBJPROP_COLOR,Red); ObjectDelete("OBOSCCIH1none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSCCIH4(int value)
  {
   if(value==1) {object5Create("OBOSCCIH4",51,272); ObjectSet("OBOSCCIH4",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSCCIH4none");}
   if(value==0) {object4Create("OBOSCCIH4none",43,254);ObjectSet("OBOSCCIH4none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSCCIH4");}
   if(value==2) {object5Create("OBOSCCIH4",51,272);ObjectSet("OBOSCCIH4",OBJPROP_COLOR,Lime); ObjectDelete("OBOSCCIH4none");}
   if(value==3) {object5Create("OBOSCCIH4",51,272);ObjectSet("OBOSCCIH4",OBJPROP_COLOR,Red); ObjectDelete("OBOSCCIH4none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSCCID1(int value)
  {
   if(value==1) {object5Create("OBOSCCID1",34,272); ObjectSet("OBOSCCID1",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSCCID1none");}
   if(value==0) {object4Create("OBOSCCID1none",26,254);ObjectSet("OBOSCCID1none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSCCID1");}
   if(value==2) {object5Create("OBOSCCID1",34,272);ObjectSet("OBOSCCID1",OBJPROP_COLOR,Lime); ObjectDelete("OBOSCCID1none");}
   if(value==3) {object5Create("OBOSCCID1",34,272);ObjectSet("OBOSCCID1",OBJPROP_COLOR,Red); ObjectDelete("OBOSCCID1none");}
  }
// -------------------------------------------------------------- 
void paintOBOSRSIM1(int value)
  {
   if(value==1) {object5Create("OBOSRSIM1",136,289); ObjectSet("OBOSRSIM1",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSRSIM1none");}
   if(value==0) {object4Create("OBOSRSIM1none",128,271);ObjectSet("OBOSRSIM1none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSRSIM1");}
   if(value==2) {object5Create("OBOSRSIM1",136,289);ObjectSet("OBOSRSIM1",OBJPROP_COLOR,Lime); ObjectDelete("OBOSRSIM1none");}
   if(value==3) {object5Create("OBOSRSIM1",136,289);ObjectSet("OBOSRSIM1",OBJPROP_COLOR,Red); ObjectDelete("OBOSRSIM1none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSRSIM5(int value)
  {
   if(value==1) {object5Create("OBOSRSIM5",119,289); ObjectSet("OBOSRSIM5",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSRSIM5none");}
   if(value==0) {object4Create("OBOSRSIM5none",111,271);ObjectSet("OBOSRSIM5none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSRSIM5");}
   if(value==2) {object5Create("OBOSRSIM5",119,289);ObjectSet("OBOSRSIM5",OBJPROP_COLOR,Lime); ObjectDelete("OBOSRSIM5none");}
   if(value==3) {object5Create("OBOSRSIM5",119,289);ObjectSet("OBOSRSIM5",OBJPROP_COLOR,Red); ObjectDelete("OBOSRSIM5none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSRSIM15(int value)
  {
   if(value==1) {object5Create("OBOSRSIM15",102,289); ObjectSet("OBOSRSIM15",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSRSIM15none");}
   if(value==0) {object4Create("OBOSRSIM15none",94,271);ObjectSet("OBOSRSIM15none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSRSIM15");}
   if(value==2) {object5Create("OBOSRSIM15",102,289);ObjectSet("OBOSRSIM15",OBJPROP_COLOR,Lime); ObjectDelete("OBOSRSIM15none");}
   if(value==3) {object5Create("OBOSRSIM15",102,289);ObjectSet("OBOSRSIM15",OBJPROP_COLOR,Red); ObjectDelete("OBOSRSIM15none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSRSIM30(int value)
  {
   if(value==1) {object5Create("OBOSRSIM30",85,289); ObjectSet("OBOSRSIM30",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSRSIM30none");}
   if(value==0) {object4Create("OBOSRSIM30none",77,271);ObjectSet("OBOSRSIM30none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSRSIM30");}
   if(value==2) {object5Create("OBOSRSIM30",85,289);ObjectSet("OBOSRSIM30",OBJPROP_COLOR,Lime); ObjectDelete("OBOSRSIM30none");}
   if(value==3) {object5Create("OBOSRSIM30",85,289);ObjectSet("OBOSRSIM30",OBJPROP_COLOR,Red); ObjectDelete("OBOSRSIM30none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSRSIH1(int value)
  {
   if(value==1) {object5Create("OBOSRSIH1",68,289); ObjectSet("OBOSRSIH1",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSRSIH1none");}
   if(value==0) {object4Create("OBOSRSIH1none",60,271);ObjectSet("OBOSRSIH1none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSRSIH1");}
   if(value==2) {object5Create("OBOSRSIH1",68,289);ObjectSet("OBOSRSIH1",OBJPROP_COLOR,Lime); ObjectDelete("OBOSRSIH1none");}
   if(value==3) {object5Create("OBOSRSIH1",68,289);ObjectSet("OBOSRSIH1",OBJPROP_COLOR,Red); ObjectDelete("OBOSRSIH1none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSRSIH4(int value)
  {
   if(value==1) {object5Create("OBOSRSIH4",51,289); ObjectSet("OBOSRSIH4",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSRSIH4none");}
   if(value==0) {object4Create("OBOSRSIH4none",43,271);ObjectSet("OBOSRSIH4none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSRSIH4");}
   if(value==2) {object5Create("OBOSRSIH4",51,289);ObjectSet("OBOSRSIH4",OBJPROP_COLOR,Lime); ObjectDelete("OBOSRSIH4none");}
   if(value==3) {object5Create("OBOSRSIH4",51,289);ObjectSet("OBOSRSIH4",OBJPROP_COLOR,Red); ObjectDelete("OBOSRSIH4none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSRSID1(int value)
  {
   if(value==1) {object5Create("OBOSRSID1",34,289); ObjectSet("OBOSRSID1",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSRSID1none");}
   if(value==0) {object4Create("OBOSRSID1none",26,271);ObjectSet("OBOSRSID1none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSRSID1");}
   if(value==2) {object5Create("OBOSRSID1",34,289);ObjectSet("OBOSRSID1",OBJPROP_COLOR,Lime); ObjectDelete("OBOSRSID1none");}
   if(value==3) {object5Create("OBOSRSID1",34,289);ObjectSet("OBOSRSID1",OBJPROP_COLOR,Red); ObjectDelete("OBOSRSID1none");}
  }
// -------------------------------------------------------------- 
void paintOBOSBBM1(int value)
  {
   if(value==1) {object5Create("OBOSBBM1",136,306); ObjectSet("OBOSBBM1",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSBBM1none");}
   if(value==0) {object4Create("OBOSBBM1none",128,288);ObjectSet("OBOSBBM1none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSBBM1");}
   if(value==2) {object5Create("OBOSBBM1",136,306);ObjectSet("OBOSBBM1",OBJPROP_COLOR,Lime); ObjectDelete("OBOSBBM1none");}
   if(value==3) {object5Create("OBOSBBM1",136,306);ObjectSet("OBOSBBM1",OBJPROP_COLOR,Red); ObjectDelete("OBOSBBM1none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSBBM5(int value)
  {
   if(value==1) {object5Create("OBOSBBM5",119,306); ObjectSet("OBOSBBM5",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSBBM5none");}
   if(value==0) {object4Create("OBOSBBM5none",111,288);ObjectSet("OBOSBBM5none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSBBM5");}
   if(value==2) {object5Create("OBOSBBM5",119,306);ObjectSet("OBOSBBM5",OBJPROP_COLOR,Lime); ObjectDelete("OBOSBBM5none");}
   if(value==3) {object5Create("OBOSBBM5",119,306);ObjectSet("OBOSBBM5",OBJPROP_COLOR,Red); ObjectDelete("OBOSBBM5none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSBBM15(int value)
  {
   if(value==1) {object5Create("OBOSBBM15",102,306); ObjectSet("OBOSBBM15",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSBBM15none");}
   if(value==0) {object4Create("OBOSBBM15none",94,288);ObjectSet("OBOSBBM15none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSBBM15");}
   if(value==2) {object5Create("OBOSBBM15",102,306);ObjectSet("OBOSBBM15",OBJPROP_COLOR,Lime); ObjectDelete("OBOSBBM15none");}
   if(value==3) {object5Create("OBOSBBM15",102,306);ObjectSet("OBOSBBM15",OBJPROP_COLOR,Red); ObjectDelete("OBOSBBM15none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSBBM30(int value)
  {
   if(value==1) {object5Create("OBOSBBM30",85,306); ObjectSet("OBOSBBM30",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSBBM30none");}
   if(value==0) {object4Create("OBOSBBM30none",77,288);ObjectSet("OBOSBBM30none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSBBM30");}
   if(value==2) {object5Create("OBOSBBM30",85,306);ObjectSet("OBOSBBM30",OBJPROP_COLOR,Lime); ObjectDelete("OBOSBBM30none");}
   if(value==3) {object5Create("OBOSBBM30",85,306);ObjectSet("OBOSBBM30",OBJPROP_COLOR,Red); ObjectDelete("OBOSBBM30none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSBBH1(int value)
  {
   if(value==1) {object5Create("OBOSBBH1",68,306); ObjectSet("OBOSBBH1",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSBBH1none");}
   if(value==0) {object4Create("OBOSBBH1none",60,288);ObjectSet("OBOSBBH1none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSBBH1");}
   if(value==2) {object5Create("OBOSBBH1",68,306);ObjectSet("OBOSBBH1",OBJPROP_COLOR,Lime); ObjectDelete("OBOSBBH1none");}
   if(value==3) {object5Create("OBOSBBH1",68,306);ObjectSet("OBOSBBH1",OBJPROP_COLOR,Red); ObjectDelete("OBOSBBH1none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSBBH4(int value)
  {
   if(value==1) {object5Create("OBOSBBH4",51,306); ObjectSet("OBOSBBH4",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSBBH4none");}
   if(value==0) {object4Create("OBOSBBH4none",43,288);ObjectSet("OBOSBBH4none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSBBH4");}
   if(value==2) {object5Create("OBOSBBH4",51,306);ObjectSet("OBOSBBH4",OBJPROP_COLOR,Lime); ObjectDelete("OBOSBBH4none");}
   if(value==3) {object5Create("OBOSBBH4",51,306);ObjectSet("OBOSBBH4",OBJPROP_COLOR,Red); ObjectDelete("OBOSBBH4none");}
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void paintOBOSBBD1(int value)
  {
   if(value==1) {object5Create("OBOSBBD1",34,306); ObjectSet("OBOSBBD1",OBJPROP_COLOR,DimGray); ObjectDelete("OBOSBBD1none");}
   if(value==0) {object4Create("OBOSBBD1none",26,288);ObjectSet("OBOSBBD1none",OBJPROP_COLOR,C'030,030,030'); ObjectDelete("OBOSBBD1");}
   if(value==2) {object5Create("OBOSBBD1",34,306);ObjectSet("OBOSBBD1",OBJPROP_COLOR,Lime); ObjectDelete("OBOSBBD1none");}
   if(value==3) {object5Create("OBOSBBD1",34,306);ObjectSet("OBOSBBD1",OBJPROP_COLOR,Red); ObjectDelete("OBOSBBD1none");}
  }
//Display Price/Currency/Chart -----------------------
void paintCurrentPrice(int value)
  {
   int GraphShift; if(DisplayCompact){GraphShift=-156;} else GraphShift=0;
   double Price=Close[value+0];
   if(DisplayPriceInfo)
     {
      objectCreate("CurrentPrice",10,GraphShift+574,DoubleToStr(9,5),PriceFontSize,"Times",PriceColor);
      ObjectSetText("CurrentPrice",DoubleToStr(Price,5),PriceFontSize,"Times",PriceColor);
      objectCreate("CurrentPair",60,GraphShift+555,Symbol(),ChartFontSize,"Times",ChartColor);
      ObjectSet("CurrentPair",OBJPROP_COLOR,ChartColor);
      objectCreate("CurrentChart",10,GraphShift+555,"",ChartFontSize,"Times",ChartColor);
      if(Period() == PERIOD_M1) ObjectSetText("CurrentChart","M1");
      if(Period() == PERIOD_M5) ObjectSetText("CurrentChart","M5");
      if(Period() == PERIOD_M15) ObjectSetText("CurrentChart","M15");
      if(Period() == PERIOD_M30) ObjectSetText("CurrentChart","M30");
      if(Period() == PERIOD_H1) ObjectSetText("CurrentChart","H1");
      if(Period() == PERIOD_H4) ObjectSetText("CurrentChart","H4");
      if(Period() == PERIOD_D1) ObjectSetText("CurrentChart","D1");
      if(Period() == PERIOD_W1) ObjectSetText("CurrentChart","W1");
      if(Period() == PERIOD_MN1) ObjectSetText("CurrentChart","MN");
      ObjectSet("CurrentChart",OBJPROP_COLOR,DimGray);
     }
   return(0);

  }

//+------------------------------------------------------------------+
