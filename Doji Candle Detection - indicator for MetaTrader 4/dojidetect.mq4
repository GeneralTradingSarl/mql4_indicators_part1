//+------------------------------------------------------------------+
//| Doji Signal Indicator
//|
//|    Generated at Sun Mar 29 00:00:00 GMT+01:00 2015
//+------------------------------------------------------------------+
#property copyright "CIT-Investing.com - Mr KHALID"
#property link      "http://www.cit-investing.com"
#define PATTERN_DOJI 1
#define PATTERN_HAMMER 2
#define PATTERN_SHOOTING_STAR 3
#define PATTERN_DARK_CLOUD 4
#define PATTERN_PIERCING_LINE 5
#define PATTERN_BEARISH_ENGULFING 6
#define PATTERN_BULLISH_ENGULFING 7
#define PATTERN_BEARISH_HARAMI 8
#define PATTERN_BULLISH_HARAMI 9
#define PATTERN_BEARISH_HARAMI_CROSS 10
#define PATTERN_BULLISH_HARAMI_CROSS 11


#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Lime
#property indicator_width1  2

//+------------------------------------------------------------------+

extern color   Signal1Color=Lime;
extern string  Signal1Pos="Low";
extern string  Signal1Text="(Candle Pattern[] is Doji)";
extern int  Signal1Character=167; // what character to display? by default it is 167 (a small square)

//+------------------------------------------------------------------+
// -- Variables
//+------------------------------------------------------------------+
int MaxSlippage = 3;
int VerboseMode = 1;

extern bool    MT4Alert=true;
extern bool    EmailAlert=true;
extern string  EmailSubject="Doji Alert : ";
extern int     LookBackForAlerts=5;

extern int     LabelCorner=0;

//+------------------------------------------------------------------+

color    LabelColor=White;
int      lastBars=0;
int      OffsetHorizontal=5;
int      OffsetVertical=20;
bool     writeInfoMessagesToLog=false;

double   Signal1Buffer[];

bool started=false;
double atrOffset;
bool sqIsBarOpen = true;
double gPointPow = 0;
double gPointCoef= 0;
datetime lastSignalDisplayed= 0;
int lastOrderErrorCloseTime = 0;
bool SupportECNBrokers=true;
int tmpRet;
int signalShift=0;
datetime lastOpenBarTime=0;
//+------------------------------------------------------------------+

int init() 
  {
   double realDigits=Digits;
   if(realDigits>0 && realDigits!=2 && realDigits!=4) 
     {
      realDigits-=1;
     }

   gPointPow=MathPow(10,realDigits);
   gPointCoef=1/gPointPow;

   TextObject("copytext",0,0,"CIT: Doji Detector",8,"Tahoma",LabelColor);
   TextObject("copyline",0,12,"----------------------",8,"Tahoma",LabelColor);

   TextObject("signal_1_c",5,10+1*18,CharToStr(167),14,"Wingdings",Signal1Color);
   TextObject("signal_1_t",25,12+1*18,"Detection: "+Signal1Text,8,"Tahoma",LabelColor);
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexArrow(0,Signal1Character);
   SetIndexBuffer(0,Signal1Buffer);
   SetIndexLabel(0,Signal1Text);

   return(0);
  }
//+------------------------------------------------------------------+

int deinit() 
  {
   ObjectDelete("copytext");
   ObjectDelete("copyline");

   ObjectDelete("signal_1_c");
   ObjectDelete("signal_1_t");

   return(0);
  }
//+------------------------------------------------------------------+

int start() 
  {
   if(Bars==lastBars || lastBars==0) 
     {
      //return(0);
     }

   if(!started && Bars>20) 
     {
      atrOffset=0.5*iATR(NULL,0,10,1);
      started=true;
     }

   int i,counted_bars=IndicatorCounted();
   i=Bars-counted_bars-1;
   while(i>=0) 
     {
      processSignal(1,i);

      i--;
     }

   lastBars=Bars;

   return(0);
  }
//+------------------------------------------------------------------+

void processSignal(int signalIndex,int i) 
  {
   if(getSignal(signalIndex,i)) 
     {
      drawSignal(signalIndex,i,getDrawOffset(signalIndex,i));

      bool previousSignal=getSignal(signalIndex,i+1);
      if(previousSignal==false && i<=LookBackForAlerts && (lastSignalDisplayed==0 || lastSignalDisplayed<Time[i])) 
        {
         // send alerts
         lastSignalDisplayed=Time[i];

         string alertText=getAlertText(signalIndex,i);

         if(MT4Alert) 
           {
            Alert(alertText);
           }
         if(EmailAlert) 
           {
            SendMail(StringConcatenate(EmailSubject,"Doji"),alertText);
           }
        }
        } else {
      drawSignal(signalIndex,i,0);
     }
  }
//+------------------------------------------------------------------+

string getAlertText(int signalIndex,int i) 
  {
   string text=Symbol()+"/"+getPeriodAsString()+" - "+TimeToStr(Time[i]);
   text=StringConcatenate(text," Signal Alert :");

   if(signalIndex==1) 
     {
      text = StringConcatenate(text, "Detection : ");
      text = StringConcatenate(text, Signal1Text);
     }

   return(text);
  }
//+------------------------------------------------------------------+

string getPeriodAsString() 
  {
   switch(Period()) 
     {
      case PERIOD_M1: return("M1");
      case PERIOD_M5: return("M5");
      case PERIOD_M15: return("M15");
      case PERIOD_M30: return("M30");
      case PERIOD_H1: return("H1");
      case PERIOD_H4: return("H4");
      case PERIOD_D1: return("D1");
      case PERIOD_W1: return("W1");
      case PERIOD_MN1: return("MN1");
     }
   return("Unknown");
  }
//+------------------------------------------------------------------+

bool getSignal(int signalIndex,int signalShift) 
  {

   if(signalIndex==1) 
     {
      return((sqIsCandlePattern((signalShift+0), PATTERN_DOJI) == true));
     }

   return(false);
  }
//+------------------------------------------------------------------+

double getDrawOffset(int signalIndex,int i) 
  {
   if(signalIndex==1) 
     {
      if(Signal1Pos=="High") 
        {
         return(High[i]+atrOffset + (sigCountOffsets(signalIndex, "High"))*(atrOffset*2));
           } else {
         return(Low[i]-atrOffset - (sigCountOffsets(signalIndex, "Low"))*(atrOffset*2));
        }
     }

   return(false);
  }
//+------------------------------------------------------------------+

int sigCountOffsets(int signalIndex,string hl) 
  {
   int count=0;

   if(signalIndex==1) 
     {
      if(Signal1Pos==hl) 
        {
         count++;
        }
     }

   return(count);
  }
//+------------------------------------------------------------------+

void drawSignal(int signalIndex,int i,double value) 
  {
   if(signalIndex==1) 
     {
      Signal1Buffer[i]=value;
     }
  }
//+------------------------------------------------------------------+

void TextObject(string id,int x,int y,string text,int size,string font,int fcolor) 
  {
   ObjectCreate(id,OBJ_LABEL,0,0,10);
   ObjectSet(id,OBJPROP_CORNER,LabelCorner);
   ObjectSet(id,OBJPROP_YDISTANCE,OffsetVertical+y);
   ObjectSet(id,OBJPROP_XDISTANCE,OffsetHorizontal+x);
   ObjectSetText(id,text,size,font,fcolor);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TextSet(string signalIndex,int barIndex,int signal,string text) 
  {
// draw time
   ObjectSetText("signal_t"+signalIndex,"AA",8,"Tahoma",LabelColor);

// draw arrow
   string signalTxt;
   int signalColor;
   int signalChar;
   if(signal==1) 
     {
      signalTxt="LONG";
      signalColor= Green;
      signalChar = 233;
        } else {
      signalTxt="SHORT";
      signalColor= Red;
      signalChar = 234;
     }
   ObjectSetText("signal_a"+signalIndex,CharToStr(signalChar),10,"Wingdings",signalColor);

// draw text
   ObjectSetText("signal_s"+signalIndex,text,8,"Tahoma",LabelColor);
  }
//----------------------------------------------------------------------------

bool getReplaceStopLimitOrder(int orderMagicNumber) 
  {
// unused function
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getOrderStopLoss(int orderMagicNumber,int orderType,double price) 
  {
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getOrderProfitTarget(int orderMagicNumber,int orderType,double price) 
  {
   return(0);
  }
//----------------------------------------------------------------------------

double getStopDifferencePrice(int orderMagicNumber) 
  {
   return(0);
  }
//----------------------------------------------------------------------------

double sqGetAverage(int avgIndiNumber,int period,int maMethod,int signalShift) 
  {

   double indicatorValue[1000];

   for(int i=0; i<period; i++) 
     {
     }

   double maValue=iMAOnArray(indicatorValue,period,period,0,maMethod,0);

   return(maValue);
  }
//----------------------------------------------------------------------------

double sqGetHighest(int avgIndiNumber,int period,int nthValue,int signalShift) 
  {

   double indicatorValues[200];

   for(int i=0; i<200; i++) 
     {
      indicatorValues[i]=-2147483647;
     }

   for(i=0; i<period; i++) 
     {
     }

   ArraySort(indicatorValues,WHOLE_ARRAY,0,MODE_DESCEND);

   if(nthValue<0 || nthValue>=period) 
     {
      return(-1);
     }

   return(indicatorValues[nthValue]);
  }
//----------------------------------------------------------------------------

double sqGetLowest(int avgIndiNumber,int period,int nthValue,int signalShift) 
  {

   double indicatorValues[200];

   for(int i=0; i<200; i++) 
     {
      indicatorValues[i]=2147483647;
     }

   for(i=0; i<period; i++) 
     {
     }

   ArraySort(indicatorValues,WHOLE_ARRAY,0,MODE_ASCEND);

   if(nthValue<0 || nthValue>=period) 
     {
      return(-1);
     }

   return(indicatorValues[nthValue]);
  }
//----------------------------------------------------------------------------

double sqGetRecent(int avgIndiNumber,int period,int signalShift) 
  {

   double indicatorValue;

   for(int i=0; i<period; i++) 
     {
     }

   return(0);
  }
//+------------------------------------------------------------------+
//+ Global functions
//+------------------------------------------------------------------+

double sqConvertToRealPips(int value) 
  {
   return(gPointCoef * value);
  }
//----------------------------------------------------------------------------

double sqConvertToPips(double value) 
  {
   return(gPointPow * value);
  }
//----------------------------------------------------------------------------

double sqSafeDivide(double var1,double var2) 
  {
   if(var2 == 0) return(10000000);
   return(var1/var2);
  }
//----------------------------------------------------------------------------

datetime sqGetTime(int hour,int minute,int second) 
  {
// StrToTime works only on a current date, for previous dates it should be used like this:
   string str=TimeToStr(TimeCurrent(),TIME_DATE)+" "+hour+":"+minute;
   datetime time2=StrToTime(str)+second;
   return(time2);
  }
//----------------------------------------------------------------------------

double sqHeikenAshi(string symbol,int timeframe,string mode,int shift) 
  {
   if(symbol=="NULL") 
     {
      if(mode=="Open") 
        {
         return(iCustom(NULL, timeframe, "Heiken Ashi", 0,0,0,0, 2, shift));
        }
      if(mode=="Close") 
        {
         return(iCustom(NULL, timeframe, "Heiken Ashi", 0,0,0,0, 3, shift));
        }
      if(mode=="High") 
        {
         return(MathMax(iCustom( NULL, timeframe, "Heiken Ashi", 0,0,0,0, 0, shift), iCustom( NULL, timeframe, "Heiken Ashi", 0,0,0,0, 1, shift)));
        }
      if(mode=="Low") 
        {
         return(MathMin(iCustom( NULL, timeframe, "Heiken Ashi", 0,0,0,0, 0, shift), iCustom( NULL, timeframe, "Heiken Ashi", 0,0,0,0, 1, shift)));
        }

        } else {
      if(mode=="Open") 
        {
         return(iCustom( symbol, timeframe, "Heiken Ashi", 0,0,0,0, 2, shift));
        }
      if(mode=="Close") 
        {
         return(iCustom( symbol, timeframe, "Heiken Ashi", 0,0,0,0, 3, shift));
        }
      if(mode=="High") 
        {
         return(MathMax(iCustom( symbol, timeframe, "Heiken Ashi", 0,0,0,0, 0, shift), iCustom( symbol, timeframe, "Heiken Ashi", 0,0,0,0, 1, shift)));
        }
      if(mode=="Low") 
        {
         return(MathMin(iCustom( symbol, timeframe, "Heiken Ashi", 0,0,0,0, 0, shift), iCustom( symbol, timeframe, "Heiken Ashi", 0,0,0,0, 1, shift)));
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+

double sqHighest(string symbol,int timeframe,int period,int shift) 
  {
   double maxnum=-1000000;
   double val;

   for(int i=shift; i<shift+period; i++) 
     {
      if(symbol=="NULL") 
        {
         val=iHigh(NULL,timeframe,i);
           } else {
         val=iHigh(symbol,timeframe,i);
        }

      if(val>maxnum) 
        {
         maxnum=val;
        }
     }

   return(maxnum);
  }
//+------------------------------------------------------------------+

double sqLowest(string symbol,int timeframe,int period,int shift) 
  {
   double minnum=1000000;
   double val;

   for(int i=shift; i<shift+period; i++) 
     {
      if(symbol=="NULL") 
        {
         val=iLow(NULL,timeframe,i);
           } else {
         val=iLow(symbol,timeframe,i);
        }

      if(val<minnum) 
        {
         minnum=val;
        }
     }

   return(minnum);
  }
//+------------------------------------------------------------------+

double sqBiggestRange(string symbol,int timeframe,int period,int shift) 
  {
   double maxnum=-1000;
   double range;

   for(int i=shift; i<shift+period; i++) 
     {
      if(symbol=="NULL") 
        {
         range = iHigh(NULL,timeframe,i)-iLow(NULL,timeframe,i);
           } else {
         range=iHigh(symbol,timeframe,i)-iLow(symbol,timeframe,i);
        }

      if(range>maxnum) 
        {
         maxnum=range;
        }
     }

   return(maxnum);
  }
//+------------------------------------------------------------------+

double sqSmallestRange(string symbol,int timeframe,int period,int shift) 
  {
   double minnum=1000;
   double range;

   for(int i=shift; i<shift+period; i++) 
     {
      if(symbol=="NULL") 
        {
         range = iHigh(NULL,timeframe,i)-iLow(NULL,timeframe,i);
           } else {
         range=iHigh(symbol,timeframe,i)-iLow(symbol,timeframe,i);
        }

      if(range<minnum) 
        {
         minnum=range;
        }
     }

   return(minnum);
  }
//+------------------------------------------------------------------+

double sqBarRange(string symbol,int timeframe,int shift) 
  {
   if(symbol=="NULL") 
     {
      return(iHigh(NULL, timeframe, shift) - iLow(NULL, timeframe, shift));
        } else {
      return(iHigh(symbol, timeframe, shift) - iLow(symbol, timeframe, shift));
     }
  }
//+------------------------------------------------------------------+

double sqMinimum(double value1,double value2) 
  {
   return(MathMin(value1, value2));
  }
//+------------------------------------------------------------------+

double sqMaximum(double value1,double value2) 
  {
   return(MathMax(value1, value2));
  }
//+------------------------------------------------------------------+

void Log(string s1,string s2="",string s3="",string s4="",string s5="",string s6="",string s7="",string s8="",string s9="",string s10="",string s11="",string s12="") 
  {
   Print(TimeToStr(TimeCurrent())," ",s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12);
  }
//+------------------------------------------------------------------+

void LogToFile(string fileName,string s1,string s2="",string s3="",string s4="",string s5="",string s6="",string s7="",string s8="",string s9="",string s10="",string s11="",string s12="") 
  {
   int handle=FileOpen(fileName,FILE_READ|FILE_WRITE,";");
   if(handle>0) 
     {
      FileSeek(handle,0,SEEK_END);
      FileWrite(handle,TimeToStr(TimeCurrent())," ",s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12);
      FileClose(handle);
     }
  }
//+------------------------------------------------------------------+

string sqGetPeriodAsStr() 
  {
   string str = TimeToStr(Time[0], TIME_DATE);
   int period = Period();

   if(period==PERIOD_H4 || period==PERIOD_H1) 
     {
      str=str+TimeHour(Time[0]);
     }
   if(period==PERIOD_M30 || period==PERIOD_M15 || period==PERIOD_M5 || period==PERIOD_M1) 
     {
      str=str+" "+TimeToStr(Time[0],TIME_MINUTES);
     }

   return(str);
  }
//+------------------------------------------------------------------+

bool sqDoublesAreEqual(double n1,double n2) 
  {
   string s1 = DoubleToStr(n1, Digits);
   string s2 = DoubleToStr(n2, Digits);

   return (s1 == s2);
  }
//+------------------------------------------------------------------+

int sqGetBarsFromOrderOpen(int expBarsPeriod) 
  {
   datetime opTime=OrderOpenTime();

   int numberOfBars=0;
   for(int i=0; i<expBarsPeriod+10; i++) 
     {
      if(opTime<Time[i]) 
        {
         numberOfBars++;
        }
     }

   return(numberOfBars);
  }
//+------------------------------------------------------------------+

int sqGetBarsFromOrderClose(int expBarsPeriod) 
  {
   datetime clTime=OrderCloseTime();

   int numberOfBars=0;
   for(int i=0; i<expBarsPeriod+10; i++) 
     {
      if(clTime<Time[i]) 
        {
         numberOfBars++;
        }
     }

   return(numberOfBars);
  }
//----------------------------------------------------------------------------

void sqCloseOrder(int orderMagicNumber) 
  {
   bool found=false;

   Verbose("Closing order with Magic Number: ",orderMagicNumber," ----------------");

   for(int i=0; i<OrdersTotal(); i++) 
     {
      if(OrderSelect(i,SELECT_BY_POS)==true && OrderMagicNumber()==orderMagicNumber) 
        {
         found=true;

         if(OrderType()==OP_BUY || OrderType()==OP_SELL) 
           {
            sqClosePositionAtMarket(-1);
              } else {
            Verbose("Deleting pending order with ticket: ",OrderTicket());
            tmpRet=OrderDelete(OrderTicket());
           }
        }
     }

   if(!found) 
     {
      Verbose("Order cannot be found");
     }
   Verbose("Closing order finished ----------------");
  }
//----------------------------------------------------------------------------

void sqCloseAllOrders() 
  {
   bool found=false;

   Verbose("Closing all orders ----------------");

   for(int i=OrdersTotal()-1; i>=0; i--) 
     {
      found = true;

      if(OrderSelect(i,SELECT_BY_POS)==true) 
        {
         if(OrderType()==OP_BUY || OrderType()==OP_SELL) 
           {
            sqClosePositionAtMarket(-1);
              } else {
            Verbose("Deleting pending order");
            tmpRet=OrderDelete(OrderTicket());
           }
        }
     }

   if(!found) 
     {
      Verbose("No orders found");
     }
   Verbose("Closing all orders finished ----------------");
  }
//----------------------------------------------------------------------------

void sqCloseOrderPartialPct(int orderMagicNumber,double percentage) 
  {
   double lotMM = sqGetCurrentPositionSize(orderMagicNumber) * (percentage / 100.0);
   int rounding = 2;

   double lotStep=MarketInfo(Symbol(),MODE_LOTSTEP);
   if(lotStep==0.01) 
     {
      rounding=2;
        } else if(lotStep==0.1) {
      rounding=1;
        } else if(lotStep>=0) {
      rounding=0;
     }

   lotMM=NormalizeDouble(lotMM,rounding);

   if(MarketInfo(Symbol(),MODE_LOTSIZE)==10000.0) lotMM=lotMM*10.0;
   lotMM=NormalizeDouble(lotMM,rounding);

   double Smallest_Lot= MarketInfo(Symbol(),MODE_MINLOT);
   double Largest_Lot = MarketInfo(Symbol(),MODE_MAXLOT);

   if(lotMM<Smallest_Lot) lotMM= Smallest_Lot;
   if(lotMM>Largest_Lot) lotMM = Largest_Lot;

   sqCloseOrderPartial(orderMagicNumber,lotMM);
  }
//----------------------------------------------------------------------------

void sqCloseOrderPartial(int orderMagicNumber,double size) 
  {
   for(int i=0; i<OrdersTotal(); i++) 
     {
      if(OrderSelect(i,SELECT_BY_POS)==true && OrderMagicNumber()==orderMagicNumber && OrderSymbol()==Symbol()) 
        {

         if(OrderType()==OP_BUY || OrderType()==OP_SELL) 
           {
            if(sqClosePositionAtMarket(size)) return;
              } else {
            if(OrderDelete(OrderTicket())) return;
           }
        }
     }
  }
//+------------------------------------------------------------------+

bool sqClosePositionAtMarket(double size) 
  {
   Verbose("Closing order with Magic Number: ",OrderMagicNumber(),", ticket: ",OrderTicket()," at market price");

   int error;

   int retries=3;
   while(true) 
     {
      retries--;
      if(retries < 0) return(false);

      if(sqIsTradeAllowed()==1) 
        {
         Verbose("Closing retry #",3-retries);
         if(sqClosePositionWithHandling(size)) 
           {
            // trade successfuly closed
            Verbose("Order with Magic Number: ",OrderMagicNumber(),", ticket: ",OrderTicket()," successfuly closed");
            return(true);
              } else {
            error=GetLastError();
            Verbose("Closing order failed, error: ",error," - ",ErrorDescription(error));
           }
        }

      Sleep(500);
     }

   return(false);
  }
//+------------------------------------------------------------------+

bool sqClosePositionWithHandling(double size) 
  {
   RefreshRates();
   double priceCP;

   if(OrderType()!=OP_BUY && OrderType()!=OP_SELL) 
     {
      return(true);
     }

   if(OrderType()==OP_BUY) 
     {
      priceCP=sqGetBid(OrderSymbol());
        } else {
      priceCP=sqGetAsk(OrderSymbol());
     }

   if(size<=0) 
     {
      Verbose("Closing Market price: ",priceCP,", closing size: ",OrderLots());
      return(OrderClose(OrderTicket(), OrderLots(), priceCP, MaxSlippage));
        } else {
      Verbose("Closing Market price: ",priceCP,", closing size: ",size);
      return(OrderClose(OrderTicket(), size, priceCP, MaxSlippage));
     }
  }
//+------------------------------------------------------------------+

bool sqOpenOrder(string symbol,int orderType,double orderLots,double price,string comment,int orderMagicNumber,string ruleName) 
  {
   int ticket;

   Verbose("Opening order with MagicNumber: ",orderMagicNumber,", type: ",sqGetOrderTypeAsString(orderType),", price: ",price,", lots: ",orderLots,", comment: ",comment," ----------------");
   Verbose("Current Ask: ",Ask,", Bid: ",Bid);

   if(TimeCurrent()-lastOrderErrorCloseTime<600) 
     {
      return(false);
      Verbose("There was error placing order less that a minute ago, waiting with another order!");
     }

   if(sqLiveOrderExists(orderMagicNumber)) 
     {
      Verbose("Order with magic number: ",orderMagicNumber," already exists, cannot open another one!");
      Verbose("----------------------------------");
      return(false);
     }

   if(sqPendingOrderExists(orderMagicNumber)) 
     {
      if(!getReplaceStopLimitOrder(orderMagicNumber)) 
        {
         Verbose("Pending Order with magic number: ",orderMagicNumber," already exists, and replace is not allowed!"," ----------------");
         return(false);
        }

      // close pending order
      Verbose("Deleting previous pending order");
      sqDeletePendingOrder(orderMagicNumber);
     }

   RefreshRates();
   if(orderType==OP_BUYSTOP || orderType==OP_SELLSTOP) 
     {
      double AskOrBid;
      if(orderType==OP_BUYSTOP) { AskOrBid=sqGetAsk(symbol); } else { AskOrBid=sqGetBid(symbol); }

      // check if stop/limit price isn't too close
      if(NormalizeDouble(MathAbs(price-AskOrBid),Digits)<=NormalizeDouble(getStopDifferencePrice(orderMagicNumber)/gPointPow,Digits)) 
        {
         Verbose("Stop/limit order is too close to actual price"," ----------------");
         return(false);
        }
     }

   double realSL = getOrderStopLoss(orderMagicNumber, orderType, price);
   double realPT = getOrderProfitTarget(orderMagicNumber, orderType, price);

   int retries=3;
   while(true) 
     {
      retries--;
      if(retries < 0) return(0);
      if(sqGetOrderPosition(orderMagicNumber)!=0) 
        {
         Verbose("Order already opened"," ----------------");
         return(0);
        }

      if(sqIsTradeAllowed()==1) 
        {
         Verbose("Opening, try #",3-retries);
         ticket=sqOpenOrderWithErrorHandling(symbol,orderType,orderLots,price,realSL,realPT,comment,orderMagicNumber);
         if(ticket>0) 
           {
            // trade successfuly opened
            Verbose("Trade successfuly opened"," ----------------");
            ObjectSetText("lines","Last Signal: "+ruleName,8,"Tahoma",LabelColor);

            return(true);
           }
        }

      if(ticket==-130) 
        {
         Verbose("Invalid stops, cannot open the trade"," ----------------");
         return(false);
        }

      if(ticket==-131) 
        {
         // invalid volume, we cannot open the trade
         Verbose("Invalid volume, cannot open the trade"," ----------------");
         return(false);
        }

      if(ticket==-11111) 
        {
         Verbose("Trade opened, but cannot set SL/PT, closing trade"," ----------------");
         return(false);
        }

      Sleep(1000);
     }

   Verbose("Retries of opening order finished"," ----------------");
   return(false);
  }
//+------------------------------------------------------------------+

int sqIsTradeAllowed(int MaxWaiting_sec=30) 
  {
// check whether the trade context is free
   if(!IsTradeAllowed()) 
     {
      int StartWaitingTime=GetTickCount();
      Print("Trade context is busy! Wait until it is free...");
      // infinite loop
      while(true) 
        {
         // if the expert was terminated by the user, stop operation
         if(IsStopped()) 
           {
            Print("The expert was terminated by the user!");
            return(-1);
           }
         // if the waiting time exceeds the time specified in the
         // MaxWaiting_sec variable, stop operation, as well
         int diff=GetTickCount()-StartWaitingTime;
         if(diff>MaxWaiting_sec*1000) 
           {
            Print("The waiting limit exceeded ("+MaxWaiting_sec+" ???.)!");
            return(-2);
           }
         // if the trade context has become free,
         if(IsTradeAllowed()) 
           {
            Print("Trade context has become free!");
            RefreshRates();
            return(1);
           }
         // if no loop breaking condition has been met, "wait" for 0.1
         // second and then restart checking
         Sleep(100);
        }
        } else {
      //Print("Trade context is free!");
      return(1);
     }

   return(1);
  }
//+------------------------------------------------------------------+

int sqOpenOrderWithErrorHandling(string symbol,int orderType,double orderLots,double price,double realSL,double realPT,string comment,int orderMagicNumber) 
  {
   int ticket,error;

   Verbose("Sending order...");
   double sl = realSL;
   double pt = realPT;
   if(SupportECNBrokers) 
     {
      sl = 0;
      pt = 0;
     }

   if(symbol=="NULL") 
     {
      ticket= OrderSend(Symbol(), orderType, orderLots, price, MaxSlippage, sl, pt, comment, orderMagicNumber);
        } else {
      ticket=OrderSend(symbol,orderType,orderLots,price,MaxSlippage,sl,pt,comment,orderMagicNumber);
     }
   if(ticket<0) 
     {
      // order failed, write error to log
      error=GetLastError();
      Verbose("Order failed, error: ",error);
      return(-1*error);
     }

   tmpRet=OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES);

   Log("Order opened with ticket: ",OrderTicket()," at price:",OrderOpenPrice());
   VerboseLog("Order with Magic Number: ",orderMagicNumber," opened with ticket: ",OrderTicket()," at price:",OrderOpenPrice());

   if(SupportECNBrokers) 
     {
      // set up stop loss and profit target
      // it has to be done separately to support ECN brokers

      int retries=3;
      while(true) 
        {
         retries--;
         if(retries < 0) return(0);

         if((realSL==0 && realPT==0) || (OrderStopLoss()==realSL && OrderTakeProfit()==realPT)) 
           {
            return(ticket);
           }

         if(sqIsTradeAllowed()==1) 
           {
            Verbose("Setting SL/PT, try #",3-retries);
            if(sqSetSLPTForOrder(ticket,realSL,realPT,orderMagicNumber,orderType,price,symbol,retries)) 
              {
               return(ticket);
              }
            if(retries==0) 
              {
               // there was eror setting SL/PT and order was deleted
               return(-11111);
              }
           }

         Sleep(1000);
        }

      Verbose("Retries of setting SL/PT order finished unsuccessfuly"," ----------------");
      return(-1);
     }

   return(ticket);
  }
//+------------------------------------------------------------------+

bool sqSetSLPTForOrder(int ticket,double realSL,double realPT,int orderMagicNumber,int orderType,double price,string symbol,int retries) 
  {
   Verbose("Setting SL: ",realSL," and PT: ",realPT," for order");

   if(OrderModify(ticket,OrderOpenPrice(),realSL,realPT,0,0)) 
     {
      VerboseLog("Order updates, StopLoss: ",realSL,", Profit Target: ",realPT);
      return(true);
        } else {
      int error=GetLastError();
      VerboseLog("Error modifying order: ",error," : ",ErrorDescription(error));

      if(retries==0) 
        {
         // when it is last unsuccessful retry, it tries to close the order
         RefreshRates();
         sqClosePositionAtMarket(-1);
         lastOrderErrorCloseTime=TimeCurrent();
        }
      return(false);
     }

   return(true);
  }
//+------------------------------------------------------------------+

int sqGetMarketPosition() 
  {
   for(int cc=OrdersTotal()-1; cc>=0; cc--) 
     {
      if(OrderSelect(cc,SELECT_BY_POS) && OrderSymbol()==Symbol()) 
        {

         if(OrderType()==OP_BUY) 
           {
            return(1);
           }
         if(OrderType()==OP_SELL) 
           {
            return(-1);
           }
        }
     }

   return(0);
  }
//+------------------------------------------------------------------+

double sqGetOrderPosition(int orderMagicNumber) 
  {
   for(int cc=OrdersTotal()-1; cc>=0; cc--) 
     {
      if(!OrderSelect(cc,SELECT_BY_POS)) continue;
      if((orderMagicNumber==0 && OrderSymbol()==Symbol()) || OrderMagicNumber()==orderMagicNumber) 
        {
         if(OrderType()==OP_BUY) 
           {
            return(1);
           }
         if(OrderType()==OP_SELL) 
           {
            return(-1);
           }
        }
     }

   return(0);
  }
//+------------------------------------------------------------------+

double sqGetOpenPrice(int orderMagicNumber) 
  {
   for(int cc=OrdersTotal()-1; cc>=0; cc--) 
     {
      if(!OrderSelect(cc,SELECT_BY_POS)) continue;
      if((orderMagicNumber==0 && OrderSymbol()==Symbol()) || OrderMagicNumber()==orderMagicNumber) 
        {
         return(OrderOpenPrice());
        }
     }

   return(0);
  }
//+------------------------------------------------------------------+

double sqGetOrderStopLoss(int orderMagicNumber) 
  {
   for(int cc=OrdersTotal()-1; cc>=0; cc--) 
     {
      if(!OrderSelect(cc,SELECT_BY_POS)) continue;
      if(OrderMagicNumber()==orderMagicNumber && OrderSymbol()==Symbol()) 
        {
         return(OrderStopLoss());
        }
     }

   return(0);
  }
//+------------------------------------------------------------------+

double sqGetOrderProfitTarget(int orderMagicNumber) 
  {
   for(int cc=OrdersTotal()-1; cc>=0; cc--) 
     {
      if(!OrderSelect(cc,SELECT_BY_POS)) continue;
      if(OrderMagicNumber()==orderMagicNumber && OrderSymbol()==Symbol()) 
        {
         return(OrderTakeProfit());
        }
     }

   return(0);
  }
//+------------------------------------------------------------------+

void sqDeletePendingOrder(int orderMagicNumber) 
  {
   for(int i=0; i<OrdersTotal(); i++) 
     {
      if(OrderSelect(i,SELECT_BY_POS)==true) 
        {
         if(OrderMagicNumber()==orderMagicNumber && OrderSymbol()==Symbol()) 
           {
            tmpRet=OrderDelete(OrderTicket());
            return;
           }
        }
     }
  }
//+------------------------------------------------------------------+

bool sqLiveOrderExists(int orderMagicNumber) 
  {
   for(int cc=OrdersTotal()-1; cc>= 0; cc--) 
     {
      if(!OrderSelect(cc,SELECT_BY_POS)) continue;
      if(OrderMagicNumber()!=orderMagicNumber || OrderSymbol()!=Symbol()) continue;
      if(OrderType()!=OP_BUY && OrderType()!=OP_SELL) continue;

      return(true);
     }

   return(false);
  }
//+------------------------------------------------------------------+

bool sqPendingOrderExists(int orderMagicNumber) 
  {
   for(int cc=OrdersTotal()-1; cc>=0; cc--) 
     {
      if(!OrderSelect(cc,SELECT_BY_POS)) continue;
      if(OrderMagicNumber()!=orderMagicNumber || OrderSymbol()!=Symbol()) continue;
      if(OrderType()==OP_BUY || OrderType()==OP_SELL) continue;

      return(true);
     }

   return(false);
  }
//+------------------------------------------------------------------+

bool sqIsCandlePattern(int shift,int pattern) 
  {
   if(pattern == PATTERN_DOJI) return(sqCandlePatternDoji(shift));
   if(pattern == PATTERN_HAMMER) return(sqCandlePatternHammer(shift));
   if(pattern == PATTERN_SHOOTING_STAR) return(sqCandlePatternShootingStar(shift));
   if(pattern == PATTERN_DARK_CLOUD) return(sqCandlePatternDarkCloudCover(shift));
   if(pattern == PATTERN_PIERCING_LINE) return(sqCandlePatternPiercingLine(shift));
   if(pattern == PATTERN_BEARISH_ENGULFING) return(sqCandlePatternBearishEngulfing(shift));
   if(pattern == PATTERN_BULLISH_ENGULFING) return(sqCandlePatternBullishEngulfing(shift));

   if(pattern == PATTERN_BEARISH_HARAMI) return(sqCandlePatternBearishHarami(shift));
   if(pattern == PATTERN_BULLISH_HARAMI) return(sqCandlePatternBullishHarami(shift));
   if(pattern == PATTERN_BEARISH_HARAMI_CROSS) return(sqCandlePatternBearishHC(shift));
   if(pattern == PATTERN_BULLISH_HARAMI_CROSS) return(sqCandlePatternBullishHC(shift));

   return(false);
  }
//+------------------------------------------------------------------+

bool sqCandlePatternDoji(int shift) 
  {
   if(MathAbs(Open[shift]-Close[shift])*gPointPow<0.6) 
     {
      return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+

bool sqCandlePatternHammer(int shift) 
  {
   double H = High[shift];
   double L = Low[shift];
   double L1 = Low[shift+1];
   double L2 = Low[shift+2];
   double L3 = Low[shift+3];

   double O = Open[shift];
   double C = Close[shift];
   double CL= H-L;

   double BodyLow,BodyHigh;
   double Candle_WickBody_Percent=0.9;
   double CandleLength=12;

   if(O>C) 
     {
      BodyHigh= O;
      BodyLow = C;
        } else {
      BodyHigh= C;
      BodyLow = O;
     }

   double LW = BodyLow-L;
   double UW = H-BodyHigh;
   double BLa= MathAbs(O-C);
   double BL90=BLa*Candle_WickBody_Percent;

   double pipValue=gPointCoef;

   if((L<=L1) && (L<L2) && (L<L3)) 
     {
      if(((LW/2)>UW) && (LW>BL90) && (CL>=(CandleLength*pipValue)) && (O!=C) && ((LW/3)<=UW) && ((LW/4)<=UW)/*&&(H<H1)&&(H<H2)*/) 
        {
         return(true);
        }
      if(((LW/3)>UW) && (LW>BL90) && (CL>=(CandleLength*pipValue)) && (O!=C) && ((LW/4)<=UW)/*&&(H<H1)&&(H<H2)*/) 
        {
         return(true);
        }
      if(((LW/4)>UW) && (LW>BL90) && (CL>=(CandleLength*pipValue)) && (O!=C)/*&&(H<H1)&&(H<H2)*/) 
        {
         return(true);
        }
     }

   return(false);
  }
//+------------------------------------------------------------------+

bool sqCandlePatternPiercingLine(int shift) 
  {
   double L = Low[shift];
   double H = High[shift];

   double O=Open[shift];
   double O1= Open[shift+1];
   double C = Close[shift];
   double C1 = Close[shift+1];
   double CL = H-L;

   double CO_HL;
   if((H-L)!=0) 
     {
      CO_HL=(C-O)/(H-L);
        } else {
      CO_HL=0;
     }

   double Piercing_Line_Ratio=0.5;
   double Piercing_Candle_Length=10;

   if((C1<O1) && (((O1+C1)/2)<C) && (O<C) && (CO_HL>Piercing_Line_Ratio) && (CL>=(Piercing_Candle_Length*gPointCoef))) 
     {
      return(true);
     }

   return(false);
  }
//+------------------------------------------------------------------+

bool sqCandlePatternShootingStar(int shift) 
  {
   double L = Low[shift];
   double H = High[shift];
   double H1 = High[shift+1];
   double H2 = High[shift+2];
   double H3 = High[shift+3];

   double O = Open[shift];
   double C = Close[shift];
   double CL= H-L;

   double BodyLow,BodyHigh;
   double Candle_WickBody_Percent=0.9;
   double CandleLength=12;

   if(O>C) 
     {
      BodyHigh= O;
      BodyLow = C;
        } else {
      BodyHigh= C;
      BodyLow = O;
     }

   double LW = BodyLow-L;
   double UW = H-BodyHigh;
   double BLa= MathAbs(O-C);
   double BL90=BLa*Candle_WickBody_Percent;

   double pipValue=gPointCoef;

   if((H>=H1) && (H>H2) && (H>H3)) 
     {
      if(((UW/2)>LW) && (UW>(2*BL90)) && (CL>=(CandleLength*pipValue)) && (O!=C) && ((UW/3)<=LW) && ((UW/4)<=LW)/*&&(L>L1)&&(L>L2)*/) 
        {
         return(true);
        }
      if(((UW/3)>LW) && (UW>(2*BL90)) && (CL>=(CandleLength*pipValue)) && (O!=C) && ((UW/4)<=LW)/*&&(L>L1)&&(L>L2)*/) 
        {
         return(true);
        }
      if(((UW/4)>LW) && (UW>(2*BL90)) && (CL>=(CandleLength*pipValue)) && (O!=C)/*&&(L>L1)&&(L>L2)*/) 
        {
         return(true);
        }
     }

   return(false);
  }
//+------------------------------------------------------------------+

bool sqCandlePatternBearishEngulfing(int shift) 
  {
   double O=Open[shift];
   double O1= Open[shift+1];
   double C = Close[shift];
   double C1= Close[shift+1];

   if((C1>O1) && (O>C) && (O>=C1) && (O1>=C) && ((O-C)>(C1-O1))) 
     {

      return(true);
     }

   return(false);
  }
//+------------------------------------------------------------------+

bool sqCandlePatternBullishEngulfing(int shift) 
  {
   double O=Open[shift];
   double O1= Open[shift+1];
   double C = Close[shift];
   double C1= Close[shift+1];

   if((O1>C1) && (C>O) && (C>=O1) && (C1>=O) && ((C-O)>(O1-C1))) 
     {
      return(true);
     }

   return(false);
  }
//+------------------------------------------------------------------+

bool sqCandlePatternDarkCloudCover(int shift) 
  {
   double L = Low[shift];
   double H = High[shift];

   double O=Open[shift];
   double O1= Open[shift+1];
   double C = Close[shift];
   double C1 = Close[shift+1];
   double CL = H-L;

   double OC_HL;
   if((H-L)!=0) 
     {
      OC_HL=(O-C)/(H-L);
        } else {
      OC_HL=0;
     }

   double Piercing_Line_Ratio=0.5;
   double Piercing_Candle_Length=10;

   if((C1>O1) && (((C1+O1)/2)>C) && (O>C) && (C>O1) && (OC_HL>Piercing_Line_Ratio) && ((CL>=Piercing_Candle_Length*gPointCoef))) 
     {
      return(true);
     }

   return(false);
  }
//+------------------------------------------------------------------+

bool sqCandlePatternBearishHarami(int shift) 
  {
   double O=Open[shift];
   double O1= Open[shift+1];
   double C = Close[shift];
   double C1= Close[shift+1];

   if((C1>O1) && (O>C) && (O<=C1) && (O1<=C) && ((O-C)<(C1-O1))) 
     {
      return(true);
     }

   return(false);
  }
//+------------------------------------------------------------------+

bool sqCandlePatternBullishHarami(int shift) 
  {
   double O=Open[shift];
   double O1= Open[shift+1];
   double C = Close[shift];
   double C1= Close[shift+1];

   if((O1>C1) && (C>O) && (C<=O1) && (C1<=O) && ((C-O)<(O1-C1))) 
     {
      return(true);
     }

   return(false);
  }
//+------------------------------------------------------------------+

bool sqCandlePatternBearishHC(int shift) 
  {
   return (sqCandlePatternBearishHarami(shift) && sqCandlePatternDoji(shift));
  }
//+------------------------------------------------------------------+

bool sqCandlePatternBullishHC(int shift) 
  {
   return (sqCandlePatternBullishHarami(shift) && sqCandlePatternDoji(shift));
  }
//+------------------------------------------------------------------+

double sqGetOpenPLInPips(int orderMagicNumber) 
  {
   double pl=0;

   for(int cc=OrdersTotal()-1; cc>=0; cc--) 
     {
      if(!OrderSelect(cc,SELECT_BY_POS)) continue;
      if(OrderType()!=OP_BUY && OrderType()!=OP_SELL) continue;
      if(OrderSymbol()!=Symbol() || (orderMagicNumber!=0 && OrderMagicNumber()!=orderMagicNumber)) continue;

      if(OrderType()==OP_BUY) 
        {
         pl+=sqGetBid(OrderSymbol())-OrderOpenPrice();
           } else {
         pl+=OrderOpenPrice()-sqGetAsk(OrderSymbol());
        }
     }

   return(pl*gPointPow);
  }
//+------------------------------------------------------------------+

int sqGetClosedPLInPips(int orderMagicNumber,int shift) 
  {
   double pl = 0;
   int index = 0;

   for(int i=OrdersHistoryTotal(); i>=0; i--) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true && OrderSymbol()==Symbol()) 
        {

         if(orderMagicNumber==0 || OrderMagicNumber()==orderMagicNumber) 
           {
            if(index!=shift) 
              {
               index++;
               continue;
              }

            // return the P/L of last order
            // or return the P/L of last order with given Magic Number
            if(OrderType()==OP_BUY) 
              {
               pl=OrderClosePrice()-OrderOpenPrice();
                 } else {
               pl=OrderOpenPrice()-OrderClosePrice();
              }
            return(pl*gPointPow);
           }
        }
     }

   return(0);
  }
//+------------------------------------------------------------------+

int sqGetTotalClosedPLInPips(int orderMagicNumber,int numberOfLastOrders) 
  {
   double pl = 0;
   int count = 0;

   for(int i=OrdersHistoryTotal(); i>=0; i--) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true && OrderSymbol()==Symbol()) 
        {

         if(orderMagicNumber==0 || OrderMagicNumber()==orderMagicNumber) 
           {
            // return the P/L of last order
            // or return the P/L of last order with given Magic Number
            count++;
            if(OrderType()==OP_BUY) 
              {
               pl=pl+(OrderClosePrice()-OrderOpenPrice());
                 } else {
               pl=pl+(OrderOpenPrice()-OrderClosePrice());
              }

            if(count>=numberOfLastOrders) break;
           }
        }
     }

   return(pl*gPointPow);
  }
//+------------------------------------------------------------------+

int sqGetTotalProfits(int orderMagicNumber,int numberOfLastOrders) 
  {
   double pl = 0;
   int count = 0;
   int profits=0;

   for(int i=OrdersHistoryTotal(); i>=0; i--) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true && OrderSymbol()==Symbol()) 
        {

         if(orderMagicNumber==0 || OrderMagicNumber()==orderMagicNumber) 
           {
            // return the P/L of last order
            // or return the P/L of last order with given Magic Number
            count++;

            if(OrderType()==OP_BUY) 
              {
               pl=(OrderClosePrice()-OrderOpenPrice());
                 } else {
               pl=(OrderOpenPrice()-OrderClosePrice());
              }

            if(pl>0) 
              {
               profits++;
              }

            if(count>=numberOfLastOrders) break;
           }
        }
     }

   return(profits);
  }
//+------------------------------------------------------------------+

int sqGetTotalLosses(int orderMagicNumber,int numberOfLastOrders) 
  {
   double pl = 0;
   int count = 0;
   int losses= 0;

   for(int i=OrdersHistoryTotal(); i>=0; i--) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true && OrderSymbol()==Symbol()) 
        {

         if(orderMagicNumber==0 || OrderMagicNumber()==orderMagicNumber) 
           {
            // return the P/L of last order
            // or return the P/L of last order with given Magic Number
            count++;

            if(OrderType()==OP_BUY) 
              {
               pl=(OrderClosePrice()-OrderOpenPrice());
                 } else {
               pl=(OrderOpenPrice()-OrderClosePrice());
              }

            if(pl<0) 
              {
               losses++;
              }

            if(count>=numberOfLastOrders) break;
           }
        }
     }

   return(losses);
  }
//+------------------------------------------------------------------+

double sqGetOpenPLInMoney(int orderMagicNumber) 
  {
   double pl=0;

   for(int cc=OrdersTotal()-1; cc>=0; cc--) 
     {
      if(!OrderSelect(cc,SELECT_BY_POS)) continue;
      if(OrderType()!=OP_BUY && OrderType()!=OP_SELL) continue;
      if(OrderSymbol()!=Symbol()) continue;
      if(orderMagicNumber!=0 && OrderMagicNumber()!=orderMagicNumber) continue;

      pl+=OrderProfit();
     }

   return(pl);
  }
//+------------------------------------------------------------------+

int sqGetClosedPLInMoney(int orderMagicNumber,int shift) 
  {
   double pl = 0;
   int index = 0;

   for(int i=OrdersHistoryTotal(); i>=0; i--) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true && OrderSymbol()==Symbol()) 
        {
         if(index!=shift) 
           {
            index++;
            continue;
           }

         if(orderMagicNumber==0 || OrderMagicNumber()==orderMagicNumber) 
           {
            // return the P/L of last order or the P/L of last order with given Magic Number
            return(OrderProfit());
           }
        }
     }

   return(0);
  }
//+------------------------------------------------------------------+

int sqGetTotalClosedPLInMoney(int orderMagicNumber,int numberOfLastOrders) 
  {
   double pl = 0;
   int count = 0;

   for(int i=OrdersHistoryTotal(); i>=0; i--) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true && OrderSymbol()==Symbol()) 
        {
         if(orderMagicNumber==0 || OrderMagicNumber()==orderMagicNumber) 
           {
            // return the P/L of last order or the P/L of last order with given Magic Number

            count++;
            pl=pl+OrderProfit();

            if(count>=numberOfLastOrders) break;
           }
        }
     }

   return(pl);
  }
//+------------------------------------------------------------------+

double sqGetCurrentPositionSize(int orderMagicNumber) 
  {
   double lots=0;

   for(int cc=OrdersTotal()-1; cc>=0; cc--) 
     {
      if(!OrderSelect(cc,SELECT_BY_POS)) continue;
      if(OrderType()!=OP_BUY && OrderType()!=OP_SELL) continue;
      if(OrderSymbol()!=Symbol()) continue;
      if(orderMagicNumber!=0 && OrderMagicNumber()!=orderMagicNumber) continue;

      lots+=OrderLots();
     }

   return(lots);
  }
//+------------------------------------------------------------------+

double sqGetLastPositionSize(int orderMagicNumber) 
  {
   for(int i=OrdersHistoryTotal(); i>=0; i--) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true && OrderSymbol()==Symbol()) 
        {
         if(orderMagicNumber==0 || OrderMagicNumber()==orderMagicNumber) 
           {
            return(OrderLots());
           }
        }
     }

   return(0);
  }
//+------------------------------------------------------------------+

void sqMoveSLTo(int orderMagicNumber,double newSL) 
  {
   bool found=false;

   for(int cc=OrdersTotal()-1; cc>=0; cc--) 
     {
      if(!OrderSelect(cc,SELECT_BY_POS)) continue;

      if(OrderMagicNumber()==orderMagicNumber && OrderSymbol()==Symbol()) 
        {
         found=true;

         Verbose("Moving SL for order with Magic Number: ",orderMagicNumber,", ticket: ",OrderTicket(),", new SL: ",newSL);
         tmpRet=OrderModify(OrderTicket(),OrderOpenPrice(),newSL,OrderTakeProfit(),0);
        }
     }

   if(!found) 
     {
      Verbose("Moving SL - order with Magic Number: ",orderMagicNumber," wasn't found");
     }
  }
//+------------------------------------------------------------------+

void sqMovePTTo(int orderMagicNumber,double newPT) 
  {
   bool found=false;

   for(int cc=OrdersTotal()-1; cc>=0; cc--) 
     {
      if(!OrderSelect(cc,SELECT_BY_POS)) continue;

      if(OrderMagicNumber()==orderMagicNumber && OrderSymbol()==Symbol()) 
        {
         found=true;

         Verbose("Moving PT for order with Magic Number: ",orderMagicNumber,", ticket: ",OrderTicket(),", new PT: ",newPT);
         tmpRet=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),newPT,0);
        }
     }

   if(!found) 
     {
      Verbose("Moving PT - order with Magic Number: ",orderMagicNumber," wasn't found");
     }
  }
//+------------------------------------------------------------------+

int sqGetBarsSinceEntry(int orderMagicNumber) 
  {
   for(int cc= OrdersTotal()-1; cc>= 0; cc--) 
     {
      if(OrderSelect(cc,SELECT_BY_POS)) 
        {

         if((orderMagicNumber==0 || OrderMagicNumber()==orderMagicNumber) && OrderSymbol()==Symbol()) 
           {
            return (sqGetBarsFromOrderOpen(orderMagicNumber));
           }
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+

int sqGetBarsSinceExit(int orderMagicNumber) 
  {

   for(int i=OrdersHistoryTotal(); i>=0; i--) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true) 
        {

         if(OrderMagicNumber()==orderMagicNumber && OrderSymbol()==Symbol()) 
           {
            return (sqGetBarsFromOrderClose(orderMagicNumber));
           }
        }
     }

   return(-1);
  }
//+------------------------------------------------------------------+

int sqGetOpenBarsForOrder(int expBarsPeriod) 
  {
   datetime opTime=OrderOpenTime();

   int numberOfBars=0;
   for(int i=0; i<expBarsPeriod+10; i++) 
     {
      if(opTime<Time[i]) 
        {
         numberOfBars++;
        }
     }

   return(numberOfBars);
  }
//+------------------------------------------------------------------+

int sqGetOrdersOpenedToday(int direction,string includePending) 
  {
   string todayTime=TimeToStr(TimeCurrent(),TIME_DATE);
   int tradesOpenedToday=0;

   for(int i=0;i<OrdersHistoryTotal();i++) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true && OrderSymbol()==Symbol()) 
        {

         if(direction==1) 
           {
            if(OrderType()==OP_SELL || OrderType()==OP_SELLLIMIT || OrderType()==OP_SELLSTOP) 
              {
               // skip short orders
               continue;
              }
              } else if(direction==-1) {
            if(OrderType()==OP_BUY || OrderType()==OP_BUYLIMIT || OrderType()==OP_BUYSTOP) 
              {
               // skip long orders
               continue;
              }
           }

         if(includePending=="false") 
           {
            if(OrderType()==OP_BUYLIMIT || OrderType()==OP_BUYSTOP || OrderType()==OP_SELLLIMIT || OrderType()==OP_SELLSTOP) 
              {
               // skip pending orders
               continue;
              }
           }

         if(TimeToStr(OrderOpenTime(),TIME_DATE)==todayTime) 
           {
            tradesOpenedToday++;
           }
        }
     }

   for(int cc=OrdersTotal()-1; cc>=0; cc--) 
     {
      if(OrderSelect(cc,SELECT_BY_POS) && OrderSymbol()==Symbol()) 
        {

         if(direction==1) 
           {
            if(OrderType()==OP_SELL || OrderType()==OP_SELLLIMIT || OrderType()==OP_SELLSTOP) 
              {
               // skip short orders
               continue;
              }
              } else if(direction==-1) {
            if(OrderType()==OP_BUY || OrderType()==OP_BUYLIMIT || OrderType()==OP_BUYSTOP) 
              {
               // skip long orders
               continue;
              }
           }

         if(includePending=="false") 
           {
            if(OrderType()==OP_BUYLIMIT || OrderType()==OP_BUYSTOP || OrderType()==OP_SELLLIMIT || OrderType()==OP_SELLSTOP) 
              {
               // skip pending orders
               continue;
              }
           }

         if(TimeToStr(OrderOpenTime(),TIME_DATE)==todayTime) 
           {
            tradesOpenedToday++;
           }
        }
     }

   return(tradesOpenedToday);
  }
//+------------------------------------------------------------------+

int sqGetLastOrderType() 
  {
   for(int i=OrdersHistoryTotal(); i>=0; i--) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true && OrderSymbol()==Symbol()) 
        {
         if(OrderType()==OP_BUY) 
           {
            return(1);
           }
         if(OrderType()==OP_SELL) 
           {
            return(-1);
           }
        }
     }

   return(0);
  }
//+------------------------------------------------------------------+

int sqGetLastOrderTodayType() 
  {
   string todayTime=TimeToStr(TimeCurrent(),TIME_DATE);

   for(int i=OrdersHistoryTotal(); i>=0; i--) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true && OrderSymbol()==Symbol()) 
        {
         if(TimeToStr(OrderOpenTime(),TIME_DATE)!=todayTime) 
           {
            continue;
           }

         if(OrderType()==OP_BUY) 
           {
            return(1);
           }
         if(OrderType()==OP_SELL) 
           {
            return(-1);
           }
        }
     }

   return(0);
  }
//+------------------------------------------------------------------+

bool sqOrderOpenedThisBar(int orderMagicNumber) 
  {
   double pl=0;

   for(int i=0; i<OrdersTotal(); i++) 
     {
      if(OrderSelect(i,SELECT_BY_POS)==true && OrderSymbol()==Symbol()) 
        {
         if(orderMagicNumber==0|| OrderMagicNumber()==orderMagicNumber) 
           {
            if(OrderOpenTime()>Time[1]) 
              {
               return(true);
              }
           }
        }
     }

   for(i=OrdersHistoryTotal(); i>=0; i--) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true && OrderSymbol()==Symbol()) 
        {
         if(orderMagicNumber==0 || OrderMagicNumber()==orderMagicNumber) 
           {
            if(OrderOpenTime()>Time[1]) 
              {
               return(true);
              }
           }
        }
     }

   return(false);
  }
//+------------------------------------------------------------------+

bool sqOrderClosedThisBar(int orderMagicNumber) 
  {
   double pl=0;

   for(int i=OrdersHistoryTotal(); i>=0; i--) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true && OrderSymbol()==Symbol()) 
        {
         if(orderMagicNumber==0 || OrderMagicNumber()==orderMagicNumber) 
           {
            if(OrderCloseTime()>Time[1]) 
              {
               return(true);
              }
           }
        }
     }

   return(false);
  }
//+------------------------------------------------------------------+

bool sqOrderOpenedThisMinute(int orderMagicNumber) 
  {
   datetime timeCandle=TimeCurrent()-60; //iTime(NULL, PERIOD_M1, 1);

   for(int i=0; i<OrdersTotal(); i++) 
     {
      if(OrderSelect(i,SELECT_BY_POS)==true && OrderSymbol()==Symbol()) 
        {
         if(orderMagicNumber==0|| OrderMagicNumber()==orderMagicNumber) 
           {
            if(OrderOpenTime()>=timeCandle) 
              {
               return(true);
              }
           }
        }
     }

   for(i=OrdersHistoryTotal(); i>=0; i--) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true && OrderSymbol()==Symbol()) 
        {
         if(orderMagicNumber==0 || OrderMagicNumber()==orderMagicNumber) 
           {
            if(OrderOpenTime()>=timeCandle) 
              {
               return(true);
              }
           }
        }
     }

   return(false);
  }
//+------------------------------------------------------------------+

bool sqOrderClosedThisMinute(int orderMagicNumber) 
  {
   datetime timeCandle=TimeCurrent()-60; //iTime(NULL, PERIOD_M1, 1);

   for(int i=OrdersHistoryTotal(); i>=0; i--) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true && OrderSymbol()==Symbol()) 
        {
         if(orderMagicNumber==0 || OrderMagicNumber()==orderMagicNumber) 
           {
            if(OrderCloseTime()>=timeCandle) 
              {
               return(true);
              }
           }
        }
     }

   return(false);
  }
//+------------------------------------------------------------------+

double sqGetAngle(double value1,double value2,int period,double coef) 
  {
   double diff=value1-value2;

   double fAngleRad=MathArctan(diff/(coef*period));
   double PI=3.141592654;

   double fAngleDegrees=(fAngleRad*180)/PI;

   return((fAngleDegrees));
  }
//+------------------------------------------------------------------+

string sqGetOrderSymbol(int orderMagicNumber) 
  {
   datetime timeCandle=TimeCurrent()-60; //iTime(NULL, PERIOD_M1, 1);

   for(int i=OrdersHistoryTotal(); i>=0; i--) 
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true && OrderSymbol()==Symbol()) 
        {
         if(orderMagicNumber==0 || OrderMagicNumber()==orderMagicNumber) 
           {
            if(OrderCloseTime()>=timeCandle) 
              {
               return(OrderSymbol());
              }
           }
        }
     }

   return("");
  }
//+------------------------------------------------------------------+

void sqTextFillOpens() 
  {
   ObjectSetText("lineopl","Open P/L: "+DoubleToStr(sqGetOpenPLInMoney(0),2),8,"Tahoma",LabelColor);
   ObjectSetText("linea","Account Balance: "+DoubleToStr(AccountBalance(),2),8,"Tahoma",LabelColor);
  }
//+------------------------------------------------------------------+

void sqTextFillTotals() 
  {
   ObjectSetText("lineto","Total profits/losses so far: "+sqGetTotalProfits(0,100)+"/"+sqGetTotalLosses(0,100),8,"Tahoma",LabelColor);
   ObjectSetText("linetp","Total P/L so far: "+DoubleToStr(sqGetTotalClosedPLInMoney(0,1000),2),8,"Tahoma",LabelColor);
  }
//+------------------------------------------------------------------+

double sqHighestInRange(string symbol,int timeframe,string timeFrom,string timeTo) 
  {
   int indexTo=-1;
   int indexFrom=-1;

// find index of bar for timeTo
   for(int i=1; i<=2000; i++) 
     {
      if(TimeToStr(Time[i],TIME_MINUTES)>=timeTo && TimeToStr(Time[i+1],TIME_MINUTES)<timeTo) 
        {
         //Log("Found timeTo: ", TimeToStr(Time[i]));
         indexTo=i;
         break;
        }
     }

   if(indexTo==-1) 
     {
      Log("Not found timeTo");
      return(-1);
     }

// find index of bar for timeFrom
   for(i=indexTo+1; i<=2000; i++) 
     {
      if(TimeToStr(Time[i],TIME_MINUTES)>=timeFrom && TimeToStr(Time[i+1],TIME_MINUTES)<timeFrom) 
        {
         //Log("Found timeFrom: ", TimeToStr(Time[i]));
         indexFrom=i;
         break;
        }
     }

   if(indexFrom==-1) 
     {
      Log("Not found time From");
      return(-1);
     }

   double value=-10000.0;

   for(i=indexTo; i<=indexFrom; i++) 
     {
      if(symbol=="NULL") 
        {
         value = MathMax(value,iHigh(NULL,timeframe,i));
           } else {
         value=MathMax(value,iHigh(symbol,timeframe,i));
        }
     }

   return(value);
  }
//+------------------------------------------------------------------+

double sqLowestInRange(string symbol,int timeframe,string timeFrom,string timeTo) 
  {
   int indexTo=-1;
   int indexFrom=-1;

// find index of bar for timeTo
   for(int i=1; i<=2000; i++) 
     {
      if(TimeToStr(Time[i],TIME_MINUTES)>=timeTo && TimeToStr(Time[i+1],TIME_MINUTES)<timeTo) 
        {
         //Log("Found timeTo: ", TimeToStr(Time[i]));
         indexTo=i;
         break;
        }
     }

   if(indexTo==-1) 
     {
      Log("Not found timeTo");
      return(-1);
     }

// find index of bar for timeFrom
   for(i=indexTo+1; i<=2000; i++) 
     {
      if(TimeToStr(Time[i],TIME_MINUTES)>=timeFrom && TimeToStr(Time[i+1],TIME_MINUTES)<timeFrom) 
        {
         //Log("Found timeFrom: ", TimeToStr(Time[i]));
         indexFrom=i;
         break;
        }
     }

   if(indexFrom==-1) 
     {
      Log("Not found time From");
      return(-1);
     }

   double value=100000.0;

   for(i=indexTo; i<=indexFrom; i++) 
     {
      if(symbol=="NULL") 
        {
         value = MathMin(value,iLow(NULL,timeframe,i));
           } else {
         value=MathMin(value,iLow(symbol,timeframe,i));
        }
     }

   return(value);
  }
//+------------------------------------------------------------------+

double sqGetOrdersAveragePrice(int orderMagicNumber) 
  {
   double sum = 0.0;
   double cnt = 0.0;
   for(int cc=OrdersTotal()-1; cc>=0; cc--) 
     {
      if(!OrderSelect(cc,SELECT_BY_POS)) continue;
      if(OrderMagicNumber()==orderMagicNumber && OrderSymbol()==Symbol()) 
        {
         if(OrderType()==OP_BUY && OrderCloseTime()==0) 
           {
            sum += OrderLots() * OrderOpenPrice ();
            cnt += OrderLots();
           }
         if(OrderType()==OP_SELL && OrderCloseTime()==0) 
           {
            sum += OrderLots() * OrderOpenPrice ();
            cnt += OrderLots();
           }
        }
     }

   if(NormalizeDouble (cnt, Digits) == 0) return (0);

   return(sum / cnt);
  }
//+------------------------------------------------------------------+

double sqGetIf(double condition,double val1,double val2) 
  {
   if(NormalizeDouble(condition, Digits) > 0) return (val1);
   return (val2);
  }
//+------------------------------------------------------------------+

double sqRound(double value,int digits) 
  {
   double pow=MathPow(10,digits);
   return(MathRound(value * pow) / pow);
  }
//+------------------------------------------------------------------+

double sqGetAsk(string symbol) 
  {
   if(symbol=="NULL") 
     {
      return(Ask);
        } else {
      return(MarketInfo(symbol,MODE_ASK));
     }
  }
//+------------------------------------------------------------------+

double sqGetBid(string symbol) 
  {
   if(symbol=="NULL") 
     {
      return(Bid);
        } else {
      return(MarketInfo(symbol,MODE_BID));
     }
  }
//+------------------------------------------------------------------+

string sqGetOrderTypeAsString(int type) 
  {
   switch(type) 
     {
      case OP_BUY: return("Buy");
      case OP_SELL: return("Sell");
      case OP_BUYLIMIT: return("Buy Limit");
      case OP_BUYSTOP: return("Buy Stop");
      case OP_SELLLIMIT: return("Sell Limit");
      case OP_SELLSTOP: return("Sell Stop");
     }

   return("Unknown");
  }
//+------------------------------------------------------------------+

void Verbose(string s1,string s2="",string s3="",string s4="",string s5="",string s6="",string s7="",string s8="",string s9="",string s10="",string s11="",string s12="") 
  {
   if(VerboseMode==1) 
     {
      // log to standard log
      Print("---VERBOSE--- ",TimeToStr(TimeCurrent())," ",s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12);

        } else if(VerboseMode==2) {
      // log to special file
      int handle=FileOpen("EAW_VerboseLog.txt",FILE_READ|FILE_WRITE);
      if(handle>0) 
        {
         FileSeek(handle,0,SEEK_END);
         FileWrite(handle,TimeToStr(TimeCurrent())," VERBOSE: ",s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12);
         FileClose(handle);
        }
     }
  }
//+------------------------------------------------------------------+

void VerboseLog(string s1,string s2="",string s3="",string s4="",string s5="",string s6="",string s7="",string s8="",string s9="",string s10="",string s11="",string s12="") 
  {
   if(VerboseMode!=1) 
     {
      Log(s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12);
     }

   Verbose(s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12);
  }
//+------------------------------------------------------------------+

double sqCICheck(double value) 
  {
   if(value >= 2147483647) return(0);
   return(value);
  }
//+------------------------------------------------------------------+

void sqDrawUpArrow(int shift) 
  {
   string name=StringConcatenate("Arrow_",MathRand());

   ObjectCreate(name,OBJ_ARROW,0,Time[shift],Low[shift]-20*Point); //draw an up arrow
   ObjectSet(name,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSet(name,OBJPROP_ARROWCODE,SYMBOL_ARROWUP);
   ObjectSet(name,OBJPROP_COLOR,Green);
  }
//+------------------------------------------------------------------+

void sqDrawDownArrow(int shift) 
  {
   string name=StringConcatenate("Arrow_",MathRand());

   ObjectCreate(name,OBJ_ARROW,0,Time[shift],High[shift]+140*Point); //draw an down arrow
   ObjectSet(name,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSet(name,OBJPROP_ARROWCODE,SYMBOL_ARROWDOWN);
   ObjectSet(name,OBJPROP_COLOR,Red);
  }
//+------------------------------------------------------------------+

string sqDateCurrent(int shift) 
  {
   return(TimeToStr(Time[shift], TIME_DATE));
  }
//+------------------------------------------------------------------+

string sqGetDate(int day,int month,int year) 
  {
   string strMonth=month;
   if(month<10) strMonth="0"+strMonth;

   string strDay=day;
   if(day<10) strDay="0"+strDay;

   return(StringConcatenate(year, ".", strMonth, ".", strDay));
  }
//+------------------------------------------------------------------+
//| return error description                                         |
//+------------------------------------------------------------------+
string ErrorDescription(int error_code)
  {
   string error_string;
//----
   switch(error_code)
     {
      //---- codes returned from trade server
      case 0:
      case 1:   error_string="no error";                                                  break;
      case 2:   error_string="common error";                                              break;
      case 3:   error_string="invalid trade parameters";                                  break;
      case 4:   error_string="trade server is busy";                                      break;
      case 5:   error_string="old version of the client terminal";                        break;
      case 6:   error_string="no connection with trade server";                           break;
      case 7:   error_string="not enough rights";                                         break;
      case 8:   error_string="too frequent requests";                                     break;
      case 9:   error_string="malfunctional trade operation (never returned error)";      break;
      case 64:  error_string="account disabled";                                          break;
      case 65:  error_string="invalid account";                                           break;
      case 128: error_string="trade timeout";                                             break;
      case 129: error_string="invalid price";                                             break;
      case 130: error_string="invalid stops";                                             break;
      case 131: error_string="invalid trade volume";                                      break;
      case 132: error_string="market is closed";                                          break;
      case 133: error_string="trade is disabled";                                         break;
      case 134: error_string="not enough money";                                          break;
      case 135: error_string="price changed";                                             break;
      case 136: error_string="off quotes";                                                break;
      case 137: error_string="broker is busy (never returned error)";                     break;
      case 138: error_string="requote";                                                   break;
      case 139: error_string="order is locked";                                           break;
      case 140: error_string="long positions only allowed";                               break;
      case 141: error_string="too many requests";                                         break;
      case 145: error_string="modification denied because order too close to market";     break;
      case 146: error_string="trade context is busy";                                     break;
      case 147: error_string="expirations are denied by broker";                          break;
      case 148: error_string="amount of open and pending orders has reached the limit";   break;
      case 149: error_string="hedging is prohibited";                                     break;
      case 150: error_string="prohibited by FIFO rules";                                  break;
      //---- mql4 errors
      case 4000: error_string="no error (never generated code)";                          break;
      case 4001: error_string="wrong function pointer";                                   break;
      case 4002: error_string="array index is out of range";                              break;
      case 4003: error_string="no memory for function call stack";                        break;
      case 4004: error_string="recursive stack overflow";                                 break;
      case 4005: error_string="not enough stack for parameter";                           break;
      case 4006: error_string="no memory for parameter string";                           break;
      case 4007: error_string="no memory for temp string";                                break;
      case 4008: error_string="not initialized string";                                   break;
      case 4009: error_string="not initialized string in array";                          break;
      case 4010: error_string="no memory for array\' string";                             break;
      case 4011: error_string="too long string";                                          break;
      case 4012: error_string="remainder from zero divide";                               break;
      case 4013: error_string="zero divide";                                              break;
      case 4014: error_string="unknown command";                                          break;
      case 4015: error_string="wrong jump (never generated error)";                       break;
      case 4016: error_string="not initialized array";                                    break;
      case 4017: error_string="dll calls are not allowed";                                break;
      case 4018: error_string="cannot load library";                                      break;
      case 4019: error_string="cannot call function";                                     break;
      case 4020: error_string="expert function calls are not allowed";                    break;
      case 4021: error_string="not enough memory for temp string returned from function"; break;
      case 4022: error_string="system is busy (never generated error)";                   break;
      case 4050: error_string="invalid function parameters count";                        break;
      case 4051: error_string="invalid function parameter value";                         break;
      case 4052: error_string="string function internal error";                           break;
      case 4053: error_string="some array error";                                         break;
      case 4054: error_string="incorrect series array using";                             break;
      case 4055: error_string="custom indicator error";                                   break;
      case 4056: error_string="arrays are incompatible";                                  break;
      case 4057: error_string="global variables processing error";                        break;
      case 4058: error_string="global variable not found";                                break;
      case 4059: error_string="function is not allowed in testing mode";                  break;
      case 4060: error_string="function is not confirmed";                                break;
      case 4061: error_string="send mail error";                                          break;
      case 4062: error_string="string parameter expected";                                break;
      case 4063: error_string="integer parameter expected";                               break;
      case 4064: error_string="double parameter expected";                                break;
      case 4065: error_string="array as parameter expected";                              break;
      case 4066: error_string="requested history data in update state";                   break;
      case 4099: error_string="end of file";                                              break;
      case 4100: error_string="some file error";                                          break;
      case 4101: error_string="wrong file name";                                          break;
      case 4102: error_string="too many opened files";                                    break;
      case 4103: error_string="cannot open file";                                         break;
      case 4104: error_string="incompatible access to a file";                            break;
      case 4105: error_string="no order selected";                                        break;
      case 4106: error_string="unknown symbol";                                           break;
      case 4107: error_string="invalid price parameter for trade function";               break;
      case 4108: error_string="invalid ticket";                                           break;
      case 4109: error_string="trade is not allowed in the expert properties";            break;
      case 4110: error_string="longs are not allowed in the expert properties";           break;
      case 4111: error_string="shorts are not allowed in the expert properties";          break;
      case 4200: error_string="object is already exist";                                  break;
      case 4201: error_string="unknown object property";                                  break;
      case 4202: error_string="object is not exist";                                      break;
      case 4203: error_string="unknown object type";                                      break;
      case 4204: error_string="no object name";                                           break;
      case 4205: error_string="object coordinates error";                                 break;
      case 4206: error_string="no specified subwindow";                                   break;
      default:   error_string="unknown error";
     }
//----
   return(error_string);
  }
//+------------------------------------------------------------------+
//| convert red, green and blue values to color                      |
//+------------------------------------------------------------------+
int RGB(int red_value,int green_value,int blue_value)
  {
//---- check parameters
   if(red_value<0)     red_value=0;
   if(red_value>255)   red_value=255;
   if(green_value<0)   green_value=0;
   if(green_value>255) green_value=255;
   if(blue_value<0)    blue_value=0;
   if(blue_value>255)  blue_value=255;
//----
   green_value<<=8;
   blue_value<<=16;
   return(red_value+green_value+blue_value);
  }
//+------------------------------------------------------------------+
//| right comparison of 2 doubles                                    |
//+------------------------------------------------------------------+
bool CompareDoubles(double number1,double number2)
  {
   if(NormalizeDouble(number1-number2,8)==0) return(true);
   else return(false);
  }
//+------------------------------------------------------------------+
//| up to 16 digits after decimal point                              |
//+------------------------------------------------------------------+
string DoubleToStrMorePrecision(double number,int precision)
  {
   double rem,integer,integer2;
   double DecimalArray[17]=
     {
      1.0,10.0,100.0,1000.0,10000.0,100000.0,1000000.0,10000000.0,100000000.0,
      1000000000.0,10000000000.0,100000000000.0,10000000000000.0,100000000000000.0,
      1000000000000000.0,1000000000000000.0,10000000000000000.0 
     };
   string intstring,remstring,retstring;
   bool   isnegative=false;
   int    rem2;
//----
   if(precision<0)  precision=0;
   if(precision>16) precision=16;
//----
   double p=DecimalArray[precision];
   if(number<0.0) { isnegative=true; number=-number; }
   integer=MathFloor(number);
   rem=MathRound((number-integer)*p);
   remstring="";
   for(int i=0; i<precision; i++)
     {
      integer2=MathFloor(rem/10);
      rem2=NormalizeDouble(rem-integer2*10,0);
      remstring=rem2+remstring;
      rem=integer2;
     }
//----
   intstring=DoubleToStr(integer,0);
   if(isnegative) retstring="-"+intstring;
   else           retstring=intstring;
   if(precision>0) retstring=retstring+"."+remstring;
   return(retstring);
  }
//+------------------------------------------------------------------+
//| convert integer to string contained input's hexadecimal notation |
//+------------------------------------------------------------------+
string IntegerToHexString(int integer_number)
  {
   string hex_string="00000000";
   int    value,shift=28;
//   Print("Parameter for IntegerHexToString is ",integer_number);
//----
   for(int i=0; i<8; i++)
     {
      value=(integer_number>>shift)&0x0F;
      if(value<10) hex_string=StringSetChar(hex_string, i, value+'0');
      else         hex_string=StringSetChar(hex_string, i, (value-10)+'A');
      shift-=4;
     }
//----
   return(hex_string);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+ Custom functions
//+
//+ Here you can define your own custom functions that can be used
//+ in EA Wizard.
//+ The functions can perform some action (for example draw on chart
//+ or manipulate with orders) or they can return value that
//+ can be used in comparison.
//+
//+ Note! All the functions below must be in valid MQL code!
//+ Contents of this file will be appended to your EA code.
//+
//+------------------------------------------------------------------+

double exampleFunction(double value) 
  {
   return(2 * value);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetTotalOpenPLInPips() 
  {
   double pl=0;

   for(int cc=OrdersTotal()-1; cc>=0; cc--) 
     {
      if(!OrderSelect(cc,SELECT_BY_POS)) continue;
      if(OrderType()!=OP_BUY && OrderType()!=OP_SELL) continue;

      if(OrderType()==OP_BUY) 
        {
         pl+=Bid-OrderOpenPrice();
           } else {
         pl+=OrderOpenPrice()-Ask;
        }
     }

   return(pl*gPointPow);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetMultiOrdersAveragePrice(int magic1,int magic2) 
  {
   double sum = 0.0;
   double cnt = 0.0;
   for(int cc=OrdersTotal()-1; cc>=0; cc--) 
     {
      if(!OrderSelect(cc,SELECT_BY_POS)) continue;
      if((OrderMagicNumber()==magic1 || OrderMagicNumber()==magic2) && OrderSymbol()==Symbol()) 
        {
         if(OrderType()==OP_BUY && OrderCloseTime()==0) 
           {
            sum += OrderLots() * OrderOpenPrice ();
            cnt += OrderLots();
           }
         if(OrderType()==OP_SELL && OrderCloseTime()==0) 
           {
            sum += OrderLots() * OrderOpenPrice ();
            cnt += OrderLots();
           }
        }
     }

   if(NormalizeDouble (cnt, Digits) == 0) return (0);

   return(sum / cnt);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsFALongSignal() 
  {
   if(iMA(NULL,240,40,0,MODE_EMA,0,0)>iMA(NULL,240,80,0,MODE_EMA,0,0)
      && iCustom(NULL,240,"WPR",21,0,1)<-80
      && iCustom(NULL,240,"WPR",21,0,0)>-80
      ) 
     {
      return(1); // conditions are valid
        } else {
      return(0); // conditions are invalid
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isFAShortSignal() 
  {
   if(iMA(NULL,240,40,0,MODE_EMA,0,0)<iMA(NULL,240,80,0,MODE_EMA,0,0)
      && iCustom(NULL,240,"WPR",21,0,1)>-20
      && iCustom(NULL,240,"WPR",21,0,0)<-20
      ) 
     {
      return(1); // conditions are valid
        } else {
      return(0); // conditions are invalid
     }
  }
//+------------------------------------------------------------------+
