//+------------------------------------------------------------------+
//|                                                   AudioPrice.mq4 |
//|                                          Copyright © 2008, sxTed |
//|                                               sxted@talktalk.net |
//|                                                       2008.02.13 |
//| Purpose...: Have audio output of latest Price in stereo!.        |
//| Thank you.: Big thank you CodersGuru at http://www.forex-tsd.com |
//|             for coding the gSpeak() function so as to have audio |
//|             signals.                                             |
//| Revision 1: 2008.11.28 Caters for fractional pips as now offered |
//|             by some brokers to MT4.                              |
//|             Non FX instruments removed from sSymbols array.      |
//| Notes.....: Place files ino the following subdirectories:        |
//|                AudioPrice.mq4 into "\experts\indicators",        |
//|                gSpeak.mqh     into "\experts\include",           |
//|                speak.dll      into "\experts\libraries".         |
//|             In indicator AudioPrice, enable "Allow DLL imports". |
//|             PC is slowed down in the middle of speech pricing    |
//|             and trade execution could take second place.         |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, sxTed"
#property link      "sxted@talktalk.net"

#property indicator_chart_window

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
#define SYM_ROWS   31                                               // number of symbols in array sSymbols

//+------------------------------------------------------------------+
//| input parameters:                                                |
//+-----------0---+----1----+----2----+----3]------------------------+
extern bool   SaySymbol = false;
extern bool   SayBidPrice = true;

//+------------------------------------------------------------------+
//| EX4 imports                                                      |
//+------------------------------------------------------------------+
#include <gSpeak.mqh>

//+------------------------------------------------------------------+
//| global variables to program:                                     |
//+------------------------------------------------------------------+
int    giDigits;
string gsPrevious100, gsSaySymbol, gsPreviousPrice, gsSymbol;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void init() {
  string sSymbols[SYM_ROWS][2]={"AUDUSD" ,"Aussie",
                                "GBPUSD" ,"Cable",
                                "EURUSD" ,"Euro",
                                "NZDUSD" ,"Kiwi",
                                "USDCAD" ,"Loonie",
                                "USDCHF" ,"Swissy",
                                "USDJPY" ,"Yen",
                                "AUDCAD" ,"Aussie-Canada",
                                "AUDCHF" ,"Aussie-Swiss",
                                "AUDJPY" ,"Aussie-Yen",
                                "AUDNZD" ,"Aussie-Kiwi",
                                "CADCHF" ,"Canada-Swiss",
                                "CADJPY" ,"Canada-Yen",
                                "CHFJPY" ,"Swiss-Yen",
                                "EURAUD" ,"Euro-Aussie",
                                "EURCAD" ,"Euro-Canada",
                                "EURCHF" ,"Euro-Swiss",
                                "EURGBP" ,"Chunnel",
                                "EURJPY" ,"Euro-Yen",
                                "EURNZD" ,"Euro-Kiwi",
                                "GBPAUD" ,"Sterling-Aussie",
                                "GBPCAD" ,"Sterling-Canada",
                                "GBPCHF" ,"Sterling-Swiss",
                                "GBPJPY" ,"Sterling-Yen",
                                "GOLD"   ,"Gold",
                                "NZDCHF" ,"Kiwi-Swiss",
                                "NZDJPY" ,"Kiwi-Yen",
                                "USDHKD" ,"US Dollar vs Hong Kong Dollar",
                                "USDSGD" ,"US Dollar vs Singapore Dollar",
                                "XAUUSD" ,"Gold",
                                "XAGUSD" ,"Silver"
                               };
  
  gsSymbol=Symbol();
  gsPreviousPrice="";
  gsPrevious100=" ";
  gsSaySymbol="";
  if(SaySymbol) {
    gsSaySymbol=gsSymbol+" ";
    for(int i=0; i<SYM_ROWS; i++) {
      if(sSymbols[i][0]==gsSymbol) break;
    }
    if(i<SYM_ROWS) gsSaySymbol=sSymbols[i][1]+" ";
  }
  if(IsDllsAllowed()==false) Alert("Check \"Allow DLL imports\" to enable program");
  // cater for new fractional pips
  if(Digits<4) giDigits=2;
  else         giDigits=4;
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void deinit() {
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
void start() {
  string sPrice=DoubleToStr(MarketInfo(gsSymbol,MODE_ASK-SayBidPrice),giDigits), sPrice2=sPrice, sChar;
  
  if(sPrice!=gsPreviousPrice) {
    int iPos=StringFind(sPrice2,"."), iLen;
    if(iPos>0) sPrice2=StringConcatenate(StringSubstr(sPrice2,0,iPos),StringSubstr(sPrice2,iPos+1));
    iLen=StringLen(sPrice2);
    sChar=StringSubstr(sPrice2,iLen-3,1);
    if(sChar==gsPrevious100) {
      sPrice2=StringSubstr(sPrice2,iLen-2);
      if(StringSubstr(sPrice2,0,1)=="0") sPrice2=StringSubstr(sPrice2,1);
      gSpeak(StringConcatenate(gsSaySymbol,sPrice2));
    }
    else gSpeak(StringConcatenate(gsSaySymbol,sPrice));
    gsPrevious100=sChar;
    gsPreviousPrice=sPrice;
  }
}
//+------------------------------------------------------------------+

