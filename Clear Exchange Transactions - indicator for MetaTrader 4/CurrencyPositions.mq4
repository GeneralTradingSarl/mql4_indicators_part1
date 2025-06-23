//+------------------------------------------------------------------+
//|                                            CurrencyPositions.mq4 |
//|                                                      Forex only! |
//|                                                          By: ZOR |
//+------------------------------------------------------------------+

#property indicator_chart_window
#property indicator_buffers 1
//---- indicator parameters
double ExtMapBuffer[];
//----
int ExtCountedBars=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int total = OrdersTotal();
   
   double USD=0,EUR=0,GBP=0,JPY=0,CHF=0,CAD=0,AUD=0,NZD=0,SGD=0,HKD=0,RUR=0,DKK=0,NOK=0,SEK=0,ZAR=0,MXN=0; // Add if more needed
   
   for(int i = total - 1; i >= 0; i--) 
      {
         OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
         string instrument = OrderSymbol();
         int side = OrderType();
         double lot = OrderLots();
         double position;
         string X1, X2;

         if (side == OP_BUY || side == OP_BUYLIMIT || side == OP_BUYSTOP) position = 1;
         if (side == OP_SELL || side == OP_SELLLIMIT || side == OP_SELLSTOP) position = -1;
         position = position * lot;
         
         X1 = StringSubstr(instrument,0,3);
         X2 = StringSubstr(instrument,3,6);
         
         if(StringLen(instrument)==6) // Pre-check forex symbols
            {
            if(X1=="USD") {USD = USD + position;}
            if(X1=="EUR") {EUR = EUR + position;}
            if(X1=="GBP") {GBP = GBP + position;}
            if(X1=="JPY") {JPY = JPY + position;}
            if(X1=="CHF") {CHF = CHF + position;}
            if(X1=="CAD") {CAD = CAD + position;}
            if(X1=="AUD") {AUD = AUD + position;}
            if(X1=="NZD") {NZD = NZD + position;}
            if(X1=="SGD") {SGD = SGD + position;}
            if(X1=="HKD") {HKD = HKD + position;}
            if(X1=="RUR") {RUR = RUR + position;}
            if(X1=="DKK") {DKK = DKK + position;}
            if(X1=="NOK") {NOK = NOK + position;}
            if(X1=="SEK") {SEK = SEK + position;}
            if(X1=="ZAR") {ZAR = ZAR + position;}
            if(X1=="MXN") {MXN = MXN + position;} // Add if more needed

            if(X2=="USD") {USD = USD - position;}
            if(X2=="EUR") {EUR = EUR - position;}
            if(X2=="GBP") {GBP = GBP - position;}
            if(X2=="JPY") {JPY = JPY - position;}
            if(X2=="CHF") {CHF = CHF - position;}
            if(X2=="CAD") {CAD = CAD - position;}
            if(X2=="AUD") {AUD = AUD - position;}
            if(X2=="NZD") {NZD = NZD - position;}
            if(X2=="SGD") {SGD = SGD - position;}
            if(X2=="HKD") {HKD = HKD - position;}
            if(X2=="RUR") {RUR = RUR - position;}
            if(X2=="DKK") {DKK = DKK - position;}
            if(X2=="NOK") {NOK = NOK - position;}
            if(X2=="SEK") {SEK = SEK - position;}
            if(X2=="ZAR") {ZAR = ZAR - position;}
            if(X2=="MXN") {MXN = MXN - position;} // Add if more needed
           }
      }
      
   string data = "\n" + "Net currency positions:" + "\n" +
            "USD = " + DoubleToStr(USD,2) + " \n" +
            "EUR = " + DoubleToStr(EUR,2) + " \n" +
            "GBP = " + DoubleToStr(GBP,2) + " \n" +
            "JPY = " + DoubleToStr(JPY,2) + " \n" +
            "CHF = " + DoubleToStr(CHF,2) + " \n" +
            "CAD = " + DoubleToStr(CAD,2) + " \n" +
            "AUD = " + DoubleToStr(AUD,2) + " \n" +
            "NZD = " + DoubleToStr(NZD,2) + " \n" +
            "SGD = " + DoubleToStr(SGD,2) + " \n" +
            "HKD = " + DoubleToStr(HKD,2) + " \n" +
            "RUR = " + DoubleToStr(RUR,2) + " \n" +
            "DKK = " + DoubleToStr(DKK,2) + " \n" +
            "NOK = " + DoubleToStr(NOK,2) + " \n" +
            "SEK = " + DoubleToStr(SEK,2) + " \n" +
            "ZAR = " + DoubleToStr(ZAR,2) + " \n" +
            "MXN = " + DoubleToStr(MXN,2) + " \n"; // Add if more needed
            
   Comment(data);
   
   return(0);
  }

