//+------------------------------------------------------------------+
//|                                                   AudioPrice.mq4 |
//|                                          Copyright © 2008, sxTed |
//|                                               sxted@talktalk.net |
//|                                                       2008.02.13 |
//| Purpose...: Have audio output of latest Price.                   |
//| Thank you.: Big thank you CodersGuru at http://www.forex-tsd.com |
//|             for coding the gSpeak() function so as to have audio |
//|             signals.                                             | 
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, sxTed"
#property link      "sxted@talktalk.net"

#property indicator_chart_window
#property indicator_buffers 1

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
#define SYM_ROWS   40                                               // number of symbols in array sSymbols

//+------------------------------------------------------------------+
//| input parameters:                                                |
//+-----------0---+----1----+----2----+----3]------------------------+
extern bool   SaySymbol=true;
extern bool   SayBidPrice=true;

//+------------------------------------------------------------------+
//| EX4 imports                                                      |
//+------------------------------------------------------------------+
#include <gSpeak.mqh>

//+------------------------------------------------------------------+
//| global variables to program:                                     |
//+------------------------------------------------------------------+
string gsPrevious100,gsSaySymbol;
uchar  array[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void init()
  {
   string sSymbol=Symbol();
   string sSymbols[SYM_ROWS][2]=
     {
      "#HPQ","CFD HEWLETT PACKARD",
      "#IBM","CFD IBM",
      "#INTC","CFD INTEL CORPORATION",
      "#MSFT","CFD MICROSOFT CORPORATION",
      "#QQQ","CFD Nasdaq 100 Index Tracking Stock",
      "#SPY","CFD Standard & Poors Depositary Receipts",
      "#T","CFD AT&T CORPORATION",
      "#XOM","CFD EXXON MOBIL CORPORATION",
      "AUDCAD","Aussie-Canada",
      "AUDCHF","Aussie-Swiss",
      "AUDJPY","Aussie-Yen",
      "AUDNZD","Aussie-Kiwi",
      "AUDUSD","Aussie",
      "CADCHF","Canada-Swiss",
      "CADJPY","Canada-Yen",
      "CHFJPY","Swiss-Yen",
      "EURAUD","Euro-Aussie",
      "EURCAD","Euro-Canada",
      "EURCHF","Euro-Swiss",
      "EURGBP","Chunnel",
      "EURJPY","Euro-Yen",
      "EURUSD","Euro",
      "GBPAUD","Sterling-Aussie",
      "GBPCAD","Sterling-Canada",
      "GBPCHF","Sterling-Swiss",
      "GBPJPY","Sterling-Yen",
      "GBPUSD","Cable",
      "GOLD","Gold",
      "NZDCHF","Kiwi-Swiss",
      "NZDJPY","Kiwi-Yen",
      "NZDUSD","Kiwi",
      "USDCAD","Loonie",
      "USDCHF","Swissy",
      "USDJPY","Yen",
      "XAUUSD","Gold",
      "XAGUSD","Silver",
      "_DJI","Dow Jones Industrial Index",
      "_NQ100","Nasdaq 100 Index",
      "_NQCOMP","Nasdaq Composite Index",
      "_SP500","Standard & Poors 500 Index"
     };

   gsPrevious100=" ";
   gsSaySymbol="";
   if(SaySymbol)
     {
      gsSaySymbol=sSymbol+" ";
      for(int i=0; i<SYM_ROWS; i++)
        {
         if(sSymbols[i][0]==sSymbol) break;
        }
      if(i<SYM_ROWS) gsSaySymbol=sSymbols[i][1]+" ";
     }
   ArrayResize(array,200);

   if(!IsDllsAllowed()) Alert("Check \"Allow DLL imports\" to enable program");
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void deinit()
  {
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
void start()
  {
   double dPrice=Ask;
   if(SayBidPrice) dPrice=Bid;
   string sPrice=DoubleToStr(dPrice,Digits),sChar;
   int    iPos=StringFind(sPrice,"."),iLen;

   if(iPos>0) sPrice=StringConcatenate(StringSubstr(sPrice,0,iPos),StringSubstr(sPrice,iPos+1));
   iLen=StringLen(sPrice);
   sChar=StringSubstr(sPrice,iLen-3,1);
   if(sChar==gsPrevious100)
     {
      sPrice=StringSubstr(sPrice,iLen-2);
      if(StringSubstr(sPrice,0,1)=="0")
         sPrice=StringSubstr(sPrice,1);
      StringToCharArray(StringConcatenate(gsSaySymbol,sPrice),array);
      gSpeak(array);
     }
   else 
     {
      StringToCharArray(StringConcatenate(gsSaySymbol,sPrice),array);
      gSpeak(array);
     };
   gsPrevious100=sChar;
  }
//+------------------------------------------------------------------+
