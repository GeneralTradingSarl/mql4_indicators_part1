//+----------------------------------------------------------------------------------------+
//| Change Chart Symbol Menu | Author: file45 | http://codebase.mql4.com/en/author/file45  |
//| April 2014                                                                             |
//+----------------------------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

#include <mt4gui2.mqh>

extern color Menu_Back_Color = Lavender;
extern color Menu_Text_Color = Black;

extern string Suffix = "";

extern string Symbol_1 = "EURUSD";
extern string Symbol_2 = "GBPUSD";
extern string Symbol_3 = "USDCHF";
extern string Symbol_4 = "USDJPY";
extern string Symbol_5 = "GOLD";
extern string Symbol_6 = "XAUUSD";
extern string Symbol_7 = "AUDCAD";
extern string Symbol_8 = "AUDCHF";
extern string Symbol_9 = "AUDJPY";
extern string Symbol_10 = "AUDNZD";
extern string Symbol_11 = "AUDUSD";
extern string Symbol_12 = "CADCHF";
extern string Symbol_13 = "CADJPY";
extern string Symbol_14 = "CHFJPY";
extern string Symbol_15 = "EURAUD";

extern string Symbol_16 = "EURCAD";
extern string Symbol_17 = "EURCHF";
extern string Symbol_18 = "EURGBP";
extern string Symbol_19 = "EURJPY";
extern string Symbol_20 = "EURNZD";
extern string Symbol_21 = "GBPAUD";
extern string Symbol_22 = "GBPCAD";
extern string Symbol_23 = "GBPCHF";
extern string Symbol_24 = "GBPJPY";
extern string Symbol_25 = "GBPNZD";
extern string Symbol_26 = "USDCAD";
extern string Symbol_27 = "SPARE";
extern string Symbol_28 = "SPARE";
extern string Symbol_29 = "SPARE";
extern string Symbol_30 = "SPARE";

int hwnd = 0;

int menuPARENT1, 
    menuSUB1, menuSUB2, menuSUB3, menuSUB4, menuSUB5, menuSUB6, menuSUB7, menuSUB8, menuSUB9, menuSUB10, 
    menuSUB11, menuSUB12, menuSUB13, menuSUB14, menuSUB15, menuSUB16, menuSUB17, menuSUB18, menuSUB19, menuSUB20, 
    menuSUB21, menuSUB22, menuSUB23, menuSUB24, menuSUB25, menuSUB26, menuSUB27, menuSUB28, menuSUB29, menuSUB30;
string TM;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   switch(Period())
   {    
     case 1:     TM = "M1";  break;
     case 5:     TM = "M5";  break;
     case 15:    TM = "M15"; break;
     case 30:    TM = "M30"; break;
     case 60:    TM = "H1";  break;
     case 240:   TM = "H4";  break;
     case 1440:  TM = "D1";  break;
     case 10080: TM = "W1";  break;
     case 43200: TM = "M4";  break;
   }     
   
   hwnd = WindowHandle(Symbol(),Period());    
   guiRemoveAll(hwnd);   
 
   {    
     menuPARENT1 = guiAddMenu(hwnd, ChartSymbol() + " " + TM, 0, 0);
     menuSUB1 = guiAddMenu(hwnd, Symbol_1+Suffix, menuPARENT1,0);
     menuSUB2 = guiAddMenu(hwnd, Symbol_2+Suffix, menuPARENT1,0);
     menuSUB3 = guiAddMenu(hwnd, Symbol_3+Suffix, menuPARENT1,0);
     menuSUB4 = guiAddMenu(hwnd, Symbol_4+Suffix, menuPARENT1,0);
     menuSUB5 = guiAddMenu(hwnd, Symbol_5+Suffix, menuPARENT1,0);
     menuSUB6 = guiAddMenu(hwnd, Symbol_6+Suffix, menuPARENT1,0);
     menuSUB7 = guiAddMenu(hwnd, Symbol_7+Suffix, menuPARENT1,0);
     menuSUB8 = guiAddMenu(hwnd, Symbol_8+Suffix, menuPARENT1,0);
     menuSUB9 = guiAddMenu(hwnd, Symbol_9+Suffix, menuPARENT1,0);
     menuSUB10 = guiAddMenu(hwnd, Symbol_10+Suffix, menuPARENT1,0);
     menuSUB11 = guiAddMenu(hwnd, Symbol_11+Suffix, menuPARENT1,0);
     menuSUB12 = guiAddMenu(hwnd, Symbol_12+Suffix, menuPARENT1,0);
     menuSUB13 = guiAddMenu(hwnd, Symbol_13+Suffix, menuPARENT1,0);
     menuSUB14 = guiAddMenu(hwnd, Symbol_14+Suffix, menuPARENT1,0);
     menuSUB15 = guiAddMenu(hwnd, Symbol_15+Suffix, menuPARENT1,0);
     
     menuSUB16 = guiAddMenu(hwnd, Symbol_16+Suffix, menuPARENT1,0);
     menuSUB17 = guiAddMenu(hwnd, Symbol_17+Suffix, menuPARENT1,0);
     menuSUB18 = guiAddMenu(hwnd, Symbol_18+Suffix, menuPARENT1,0);
     menuSUB19 = guiAddMenu(hwnd, Symbol_19+Suffix, menuPARENT1,0);
     menuSUB20 = guiAddMenu(hwnd, Symbol_20+Suffix, menuPARENT1,0);
     menuSUB21 = guiAddMenu(hwnd, Symbol_21+Suffix, menuPARENT1,0);
     menuSUB22 = guiAddMenu(hwnd, Symbol_22+Suffix, menuPARENT1,0);
     menuSUB23 = guiAddMenu(hwnd, Symbol_23+Suffix, menuPARENT1,0);
     menuSUB24 = guiAddMenu(hwnd, Symbol_24+Suffix, menuPARENT1,0);
     menuSUB25 = guiAddMenu(hwnd, Symbol_25+Suffix, menuPARENT1,0);
     menuSUB26 = guiAddMenu(hwnd, Symbol_26+Suffix, menuPARENT1,0);
     menuSUB27 = guiAddMenu(hwnd, Symbol_27+Suffix, menuPARENT1,0);
     menuSUB28 = guiAddMenu(hwnd, Symbol_28+Suffix, menuPARENT1,0);
     menuSUB29 = guiAddMenu(hwnd, Symbol_29+Suffix, menuPARENT1,0);
     menuSUB30 = guiAddMenu(hwnd, Symbol_30+Suffix, menuPARENT1,0);
     
     guiSetMenuTextColor(hwnd,menuPARENT1,Menu_Text_Color); guiSetMenuBgColor(hwnd,menuPARENT1,Menu_Back_Color);
   }

   return(INIT_SUCCEEDED);
}
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
   if(guiIsMenuClicked(hwnd,menuSUB1)) guiChangeSymbol(hwnd,Symbol_1+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB2)) guiChangeSymbol(hwnd,Symbol_2+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB3)) guiChangeSymbol(hwnd,Symbol_3+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB4)) guiChangeSymbol(hwnd,Symbol_4+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB5)) guiChangeSymbol(hwnd,Symbol_5+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB6)) guiChangeSymbol(hwnd,Symbol_6+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB7)) guiChangeSymbol(hwnd,Symbol_7+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB8)) guiChangeSymbol(hwnd,Symbol_8+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB9)) guiChangeSymbol(hwnd,Symbol_9+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB10)) guiChangeSymbol(hwnd,Symbol_10+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB11)) guiChangeSymbol(hwnd,Symbol_11+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB12)) guiChangeSymbol(hwnd,Symbol_12+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB13)) guiChangeSymbol(hwnd,Symbol_13+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB14)) guiChangeSymbol(hwnd,Symbol_14+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB15)) guiChangeSymbol(hwnd,Symbol_15+Suffix);
   
   if(guiIsMenuClicked(hwnd,menuSUB16)) guiChangeSymbol(hwnd,Symbol_16+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB17)) guiChangeSymbol(hwnd,Symbol_17+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB18)) guiChangeSymbol(hwnd,Symbol_18+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB19)) guiChangeSymbol(hwnd,Symbol_19+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB20)) guiChangeSymbol(hwnd,Symbol_20+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB21)) guiChangeSymbol(hwnd,Symbol_21+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB22)) guiChangeSymbol(hwnd,Symbol_22+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB23)) guiChangeSymbol(hwnd,Symbol_23+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB24)) guiChangeSymbol(hwnd,Symbol_24+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB25)) guiChangeSymbol(hwnd,Symbol_25+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB26)) guiChangeSymbol(hwnd,Symbol_26+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB27)) guiChangeSymbol(hwnd,Symbol_27+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB28)) guiChangeSymbol(hwnd,Symbol_28+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB29)) guiChangeSymbol(hwnd,Symbol_29+Suffix);
   if(guiIsMenuClicked(hwnd,menuSUB30)) guiChangeSymbol(hwnd,Symbol_30+Suffix);
   
   return(rates_total);
}

int deinit()
{
   if (hwnd>0) 
   { 
      guiRemoveAll(hwnd);     
      guiCleanup(hwnd ); 
   }
   return(0);
}