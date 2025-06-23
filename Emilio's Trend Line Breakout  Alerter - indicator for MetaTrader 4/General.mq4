#property copyright "Emilio Stefano Reale FxTrading"
#property library

#include <stderror.mqh>
#include <WinUser32.mqh>

/*
#import "fg_lib.dll"
   void BeepSell();
   void BeepBuy();
   void BeepClose();
   void BeepTrailing();
#import
*/

#define MKTG_INVAR   -1
#define MKTG_RESET   0
#define MKTG_UP      1 
#define MKTG_DWN     2 
#define MKTG_SIDE    3 
#define MKTG_NOTSIDE 4 

#define STOCK_INV    -1
#define STOCK_DOWN   10
#define STOCK_UP     20

#define SND_SELL     "sell.wav"
#define SND_BUY      "buy.wav"

#define OP_NONE      -1000

#define LINE_STYLE   STYLE_SOLID
#define LINE_COLOR   Red

#define           LOGFNAME             "test.txt"

#define LOTS_NORMAL     0
#define LOTS_TOO_BIG    1
#define LOTS_TOO_SMALL  2


bool printErr()
{
   int err=GetLastError();
   if (err > 0) Print("error(",err,"): ", ErrorDescription(err));
   return(err > 0);
}

void MyPrint(string str)
{
   Print(str);
}

string ErrDesc()
{
   int err=GetLastError();
   if (err > 0) return (ErrorDescription(err));
   return ("");
}

// messaggio di libreria che identifica il suono da riprodurre
// in caso di vendita o di acquisto 
void SoundMessage(bool SellOrBuy)
{
   if (SellOrBuy) MessageBeep(500); else MessageBeep(1000);
}

void MBox(string str)
{
   MessageBox(str, "-INFO DEBUG-");
}

void drawLabel(string id, string text, int fsize, color fcolor, int x,int y,string font="Arial",int window = 0)
{
  ObjectDelete(id);
  ObjectCreate(id, OBJ_LABEL, window, 0, 0);
  ObjectSetText(id,text, fsize, font, fcolor);
  ObjectSet(id, OBJPROP_CORNER, 0);
  ObjectSet(id, OBJPROP_XDISTANCE, x);
  ObjectSet(id, OBJPROP_YDISTANCE, y);   
}

void NdxLabel(string id, string text, int fsize, color fcolor, int x, double y, string font="Arial",int window = 0)
{
  ObjectDelete(id);
  ObjectCreate(id, OBJ_LABEL, 0, iTime(NULL, 0, x), y);
  ObjectSetText(id,text, fsize, font, Black);
}

void BLLabel(string text)
{  LabelText( 10, 10, text, 2); }

int LabelText(int xOffset, int yOffset, string text, int iCorner) 
{  
   string Name = "" + CalcMagic();
   ObjectDelete(Name);
   ObjectCreate   (Name,OBJ_LABEL         , 0, 0, 0 );
   ObjectSet      (Name,OBJPROP_CORNER    , iCorner);
   ObjectSet      (Name,OBJPROP_XDISTANCE , xOffset );
   ObjectSet      (Name,OBJPROP_YDISTANCE , yOffset );
   ObjectSet      (Name,OBJPROP_BACK      , True );
   ObjectSetText  (Name, text  , 8, "Courier New", Black );
}

int CalcMagic()
{       
   string CurrPair; int CurrPeriod;
   CurrPair = Symbol(); CurrPeriod = Period();

   if      (CurrPair=="EURUSD" || CurrPair=="EURUSDm") {return(1000+CurrPeriod);}
   else if (CurrPair=="GBPUSD" || CurrPair=="GBPUSDm") {return(2000+CurrPeriod);}
   else if (CurrPair=="USDCHF" || CurrPair=="USDCHFm") {return(3000+CurrPeriod);}
   else if (CurrPair=="USDJPY" || CurrPair=="USDJPYm") {return(4000+CurrPeriod);}
   else if (CurrPair=="EURJPY" || CurrPair=="EURJPYm") {return(5000+CurrPeriod);}
   else if (CurrPair=="EURCHF" || CurrPair=="EURCHFm") {return(6000+CurrPeriod);}
   else if (CurrPair=="EURGBP" || CurrPair=="EURGBPm") {return(7000+CurrPeriod);}
   else if (CurrPair=="USDCAD" || CurrPair=="USDCADm") {return(8000+CurrPeriod);}
   else if (CurrPair=="AUDUSD" || CurrPair=="AUDUSDm") {return(9000+CurrPeriod);}
   else if (CurrPair=="GBPCHF" || CurrPair=="GBPCHFm") {return(10000+CurrPeriod);}
   else if (CurrPair=="GBPJPY" || CurrPair=="GBPJPYm") {return(11000+CurrPeriod);}
   else if (CurrPair=="CHFJPY" || CurrPair=="CHFJPYm") {return(12000+CurrPeriod);}
   else if (CurrPair=="NZDUSD" || CurrPair=="NZDUSDm") {return(13000+CurrPeriod);}
   else if (CurrPair=="EURCAD" || CurrPair=="EURCADm") {return(14000+CurrPeriod);}
   else if (CurrPair=="AUDJPY" || CurrPair=="AUDJPYm") {return(15000+CurrPeriod);}
   else if (CurrPair=="EURAUD" || CurrPair=="EURAUDm") {return(16000+CurrPeriod);}
   else if (CurrPair=="AUDCAD" || CurrPair=="AUDCADm") {return(17000+CurrPeriod);}
   else if (CurrPair=="AUDNZD" || CurrPair=="AUDNZDm") {return(18000+CurrPeriod);}
   else if (CurrPair=="NZDJPY" || CurrPair=="NZDJPYm") {return(19000+CurrPeriod);}
   else if (CurrPair=="CADJPY" || CurrPair=="CADJPYm") {return(20000+CurrPeriod);}
   else if (CurrPair=="XAUUSD" || CurrPair=="XAUUSDm") {return(21000+CurrPeriod);}
   else if (CurrPair=="XAGUSD" || CurrPair=="XAGUSDm") {return(22000+CurrPeriod);}
   else if (CurrPair=="GBPAUD" || CurrPair=="GBPAUDm") {return(23000+CurrPeriod);}
   else if (CurrPair=="GBPCAD" || CurrPair=="GBPCADm") {return(24000+CurrPeriod);}
   else if (CurrPair=="AUFCHF" || CurrPair=="AUFCHFm") {return(25000+CurrPeriod);}
   else if (CurrPair=="CADCHF" || CurrPair=="CADCHFm") {return(26000+CurrPeriod);}
   else if (CurrPair=="NZDCHF" || CurrPair=="NZDCHFm") {return(27000+CurrPeriod);}
}

int SetBit(int value, int bit)
{ return (value | bit); }

bool CheckBit(int value, int bit)
{ return ((value & bit) == bit); }

double ComputePip(int ratio = 1)
{
   return (ratio * Point);
}

double PipCommission(double commission)
{
   return ((Ask - Bid) / commission);
}

double commissions()
{
   return (Ask - Bid);
}

datetime dayTime(int h, int m)
{
   return (StrToTime("" + Year() + "." + Month() + "." + Day() + " " + h +":" + m));
}

datetime yearTime(int y, int mo, int d, int h, int m)
{
   return (StrToTime("" + y + "." + mo + "." + d + " " + h +":" + m));
}

string MagicString()
{ return("_"+CalcMagic()); }


bool isDownTrend(double m1, double m2)
{  if ( m1 < 0.1 || m2 < 0.1)  return (false); else return (m1 > m2); }

bool isUpTrend(double m1, double m2)
{  if (m1<0.1 || m2<0.1) return (false); else return ( m1 < m2); }

bool isLateral(double m1, double m2)
{
  double v = MathAbs( m1 - m2);
  
  return (v <= 20);
}


int BollingerRange(double v1, double v2, double _pipratio = 1)
{
   if ((v2 == 0) || (v1 == 0)) return(0); 
   else
      return (MathFloor(MathAbs(v1 - v2) / ComputePip(_pipratio)));
   return (0);
}

void FileComment(string strComment)
{
		int hFile = FileOpen(Day() + "." + Month() + "." +  Year() + " " + Hour() + ":" + Minute() +  ":" + Seconds() +
		   "__test_" + ExpertName() + ".txt", FILE_BIN | FILE_READ | FILE_WRITE, '\t');	

		FileSeek(hFile, 0, SEEK_END);
		FileWriteString(hFile, strComment, StringLen(strComment));
		FileClose(hFile);
}

string ExpertName()
{
   return (Symbol());
}

void WriteLOG(string descr, string value)
{
   int fileHandle;
   fileHandle = FileOpen(LOGFNAME, FILE_CSV | FILE_WRITE);
   FileWrite(fileHandle, TimeToStr(TimeCurrent()), descr, value); 
   FileClose(fileHandle);
}

void DeleteLine(string name) 
{ 
   int    obj_total = ObjectsTotal();
   string _name;
   for(int i = 0; i < obj_total; i++)
   {
      _name = ObjectName(i);
      if(ObjectType(name) == OBJ_TREND)
      {
         ObjectDelete(name); 
      }
   }
}

void CreateLine(string name, int shift1, double val1, int shift2, double val2, int window)
{ 
   CreateLineEx(name, shift1, val1, shift2, val2, window, true, LINE_STYLE, LINE_COLOR);
}

void CreateSimpleLine(string name, int shift1, double val1, int shift2, double val2, int window)
{ 
   CreateLineEx(name, shift1, val1, shift2, val2, window, false, LINE_STYLE, LINE_COLOR);
}

void CreateTLRay(string name, int shift1, double val1, int shift2, double val2, int window)
{ 
   CreateLineEx(name, shift1, val1, shift2, val2, window, true, LINE_STYLE, LINE_COLOR);
}

void CreateLineEx(
   string name, int shift1, double val1, int shift2, double val2, int window, bool ray, double style, double mycolor
   )
{ 
   DeleteLine(name); 
   ObjectCreate(name, OBJ_TREND, window, cTime(shift1), val1, cTime(shift2), val2); 
   ObjectSet(name, OBJPROP_STYLE, style); 
   ObjectSet(name, OBJPROP_COLOR, mycolor); 
   ObjectSet(name, OBJPROP_RAY, ray);
}
double LineValue(string name, int shift) { return (ObjectGetValueByShift(name, shift)); }

double LineValueP(string name, int shift, int prec) 
{ return (norD(LineValue(name, shift), prec)); }

int digits()
{
   return (MarketInfo(Symbol(), Digits));
}

double LineValueDgtPip(string name, int shift)
{
   return (LineValueP(name, shift, digits()-1));
}

string ServerTime()
{  string strHourPad, strMinutePad;
   if (TimeHour(iTime(NULL,PERIOD_M1,0))>=0 && TimeHour(iTime(NULL,PERIOD_M1,0))<=9) strHourPad = "0";
   else strHourPad = "";
   if (TimeMinute(iTime(NULL,PERIOD_M1,0))>=0 && TimeMinute(iTime(NULL,PERIOD_M1,0))<=9) strMinutePad = "0";
   else strMinutePad = "";
   return(StringConcatenate("",strHourPad,TimeHour(iTime(NULL,PERIOD_M1,0)),":",strMinutePad,TimeMinute(iTime(NULL,PERIOD_M1,0)),")"));
}

double   cHigh(int shift)                  { return (cHighEx(0, shift)); }
double cHighEx(int frame, int shift)       { return (iHigh(NULL, frame, shift)); }
double   cLow(int shift)                   { return (cLowEx(0, shift)); }
double cLowEx(int frame, int shift)        { return (iLow(NULL, frame, shift)); }
double   cClose(int shift)                 { return (cCloseEx(0, shift)); }
double cCloseEx(int frame, int shift)      { return (iClose(NULL, frame, shift)); }
double   cOpen(int shift)                  { return (cOpenEx(0, shift)); }
double cOpenEx(int frame, int shift)       { return (iOpen(NULL, frame, shift)); }
double   cVolume(int shift)                { return (cVolumeEx(0, shift)); }
double cVolumeEx(int frame, int shift)     { return (iVolume(NULL, frame, shift)); }
datetime cTime(int shift)                  { return (cTimeEx(0, shift)); }
datetime cTimeEx(int frame, int shift)     { return (iTime(NULL, frame, shift)); }

int cBShift(datetime bartime)              { return (cBShiftEx(0, bartime)); }
int cBShiftEx(int frame, datetime bartime) { return (iBarShift(NULL, frame, bartime, true)); }

double RSI(int RSI_PERIOD, int shift)
{ return(iRSI(NULL,0, RSI_PERIOD, PRICE_CLOSE, shift)); }

double cRSI(int period, int shift)
{
   return (RSI(period, shift));  
}
/*
void RSIArray(double &a[], int p)
{
   int s = ArrayResize(a, p);
   for (int i = 0; i < p; i++) { a[i] = RSI(i); }
}
*/

void incDArray(double &a[], double v)
{
   int s = ArrayResize(a, ArraySize(a) + 1);
   s--;
   a[s] = v;
}

void incIArray(int &a[], int v)
{
   int s = ArrayResize(a, ArraySize(a) + 1);
   s--;
   a[s] = v;
}


void HighArray(double &a[], int p)
{
   int s = ArrayResize(a,p);
   for (int i = 0; i < p; i++) { a[i] = cHigh(i); }
}

void LowArray(double &a[], int p)
{
   int s = ArrayResize(a,p);
   for (int i = 0; i < p; i++) { a[i] = cLow(i); }
}

double ADX_PLUSDI(int period, int price, int shift)
{ return (iADX(NULL,0,period,price,MODE_PLUSDI,shift)); }

double ADX_MINUSDI(int period, int price, int shift)
{ return (iADX(NULL,0,period,price,MODE_MINUSDI,shift)); }

double ADX_MAIN(int period, int price, int shift)
{ return (iADX(NULL,0,period,price,MODE_SIGNAL,shift)); }

double cADX_MAIN(int period, int shift)
{ return (ADX_MAIN(period, PRICE_CLOSE, shift)); }

double cADX_PDI(int period, int shift)
{ return (ADX_PLUSDI(period, PRICE_CLOSE, shift)); }

double cADX_MDI(int period, int shift)
{ return (ADX_MINUSDI(period, PRICE_CLOSE, shift)); }

// calcola l'inclinazione di una retta tramite il proprio coeff. angolare M
double TLM(double x1, double y1, double x2, double y2)
{ double dy = y2-y1, dx = x2-x1; return(DivByZero(dy,dx)); }

double LWMA(int period, int applied_price, int shift)
{ return (iMA(Symbol(),0, period, 0, MODE_LWMA, applied_price, shift));  }

double EMA(int period, int shift)
{ return (EMAClose(period, shift)); }

double SMA(int period, int shift)
{ return (SMAClose(period, shift)); }

double EMAClose(int period, int shift)
{ return (iMA (Symbol(), 0, period,  0, MODE_EMA, PRICE_CLOSE, shift)); }

double SMMA (int period, int applied_price, int shift)
{ return (iMA(Symbol(), 0, period, 0, MODE_SMMA, applied_price, shift)); }

double EMAOpen(int period, int shift)
{ return (iMA (Symbol(), 0, period,  0, MODE_EMA, PRICE_OPEN, shift));  }

double EMAMedian(int period, int shift)
{  return (iMA (Symbol(), 0, period,  0, MODE_EMA, PRICE_MEDIAN, shift));  }

double SMAClose(int period, int shift)
{ return (iMA(Symbol(), 0, period, 0, MODE_SMA, PRICE_CLOSE, shift)); }

double SMAMedian(int period, int shift)
{ return (iMA(Symbol(), 0, period, 0, MODE_SMA, PRICE_MEDIAN, shift));}

double SMAOpen(int period, int shift)
{ return (iMA(Symbol(), 0, period, 0, MODE_SMA, PRICE_OPEN, shift)); }

double norD(double value, int precision)
{ return(NormalizeDouble(value, precision)); }

bool Up(int p1, int p2, int shift) // periodi delle medie
{ return (EMAClose(p1,0) < EMAClose(p2,shift)); }

bool Down(int p1, int p2, int shift)
{ return (EMAClose(p1,0) > EMAClose(p2,shift)); }

bool UpCross(int p1, int p2, int shift)
{ return ((Up(p1,p2,shift) && !Up(p1,p2,shift+1))); }

bool DownCross(int p1, int p2, int shift)
{ return ((Down(p1, p2, shift) && !Down(p1,p2,shift))); }

double cStochK(int K, int D, int slowing, int shift)
{ return (iStochastic(NULL, 0, K, D, slowing, MODE_EMA, 0, MODE_MAIN, shift)); }

double cStochD(int K, int D, int slowing, int shift)
{ return(iStochastic(NULL, 0,  K, D, slowing, MODE_EMA, 0, MODE_SIGNAL, shift)); }

double cBollUpper(int period, int deviation, int bandShift, int shift)
{ return (iBands(NULL, 0, period, deviation, bandShift, PRICE_CLOSE, MODE_UPPER, shift)); }

double cBollLower(int period, int deviation, int bandShift, int shift)
{ return (iBands(NULL, 0, period, deviation, bandShift, PRICE_CLOSE, MODE_LOWER, shift)); }

double cSar(int shift)
{ return (iSAR(NULL, 0, 0.02, 0.2, shift)); }

double cEnvelopesUpper(int period, double deviation)
{ return (cEnvelopesEx(period, MODE_EMA, 0, PRICE_CLOSE, deviation, MODE_UPPER, 0)); }

double cEnvelopesLower(int period, double deviation)
{ return (cEnvelopesEx(period, MODE_EMA, 0, PRICE_CLOSE, deviation, MODE_LOWER, 0)); }

double cEnvelopesEx(int period, int method,int ma_shift, int applied_price, double deviation, int mode, int shift)
{ return (iEnvelopes(NULL, 0, period, method, ma_shift, applied_price, deviation, mode, shift)); }

double cIchimokuTS(int ts, int ks, int ssb, int shift)
{ return (cIchimokuEx(ts, ks, ssb, MODE_TENKANSEN, shift)); }

double cIchimokuKS(int ts, int ks, int ssb, int shift)
{ return (cIchimokuEx(ts, ks, ssb, MODE_KIJUNSEN, shift));}

double cIchimokuSSA(int ts, int ks, int ssb, int shift)
{ return (cIchimokuEx(ts, ks, ssb, MODE_SENKOUSPANA, shift)); }

double cIchimokuSSB(int ts, int ks, int ssb, int shift)
{ return (cIchimokuEx(ts, ks, ssb, MODE_SENKOUSPANB, shift)); }

double cIchimokuCS(int ts, int ks, int ssb, int shift)
{ return (cIchimokuEx(ts, ks, ssb, MODE_CHINKOUSPAN, shift)); }

double cIchimokuEx(int ts, int ks, int ssb, int mode, int shift)
{ return(iIchimoku(NULL, 0, ts, ks, ssb, mode, shift)); }

double cAC(int shift)
{ return (cACEx(0, shift)); }

double cACEx(int timeframe, int shift)
{ return (iAC(NULL, timeframe, shift)); }

double cOBV(int shift)
{ return (cOBVEx(0, shift)); }

double cOBVEx(int timeframe, int shift)
{ return (iOBV(NULL, timeframe, PRICE_CLOSE, 0)); }

double cMFI(int shift)
{ return (cMFIEx(0,14,shift)); }

double cMFIEx( int timeframe, int period, int shift)
{ iMFI(NULL, timeframe, period, shift); }

double cMACDm(int fastema, int slowema, int signalperiod, int shift)
{ return (iMACD(NULL, 0, fastema, slowema, signalperiod, PRICE_CLOSE, MODE_MAIN, shift)); }

double cMACDs(int fastema, int slowema, int signalperiod, int shift)
{ return (iMACD(NULL, 0, fastema, slowema, signalperiod, PRICE_CLOSE, MODE_SIGNAL, shift));}

double cRVIm(int shift)
{ return (iRVI(NULL, 0, 10, MODE_MAIN, 0)); }

double cRVIs(int shift)
{ return (iRVI(NULL, 0, 10, MODE_SIGNAL, 0)); }

double cOSMA(int shift)
{ return (iOsMA(NULL, 0, 12, 26, 29, PRICE_CLOSE, shift));}

double cBullsEx(int period, int shift)
{  return (iBullsPower(NULL, 0, period, PRICE_CLOSE, shift));}

bool osmaUp(int shift)     // OsMA rialzista
{ return (cOSMA(shift) > cOSMA(shift + 1)); }

bool osmaDw(int shift)     // OsMA ribassista
{ return (cOSMA(shift) < cOSMA(shift + 1)); }

double cMomentum(int shift)
{ return (iMomentum(NULL, 0, 3, PRICE_CLOSE, shift));}

bool momentumUp(int shift)
{ return (cMomentum(shift) > cMomentum(shift + 1));}

bool momentumDw(int shift)
{  return (cMomentum(shift) < cMomentum(shift + 1));}

bool isGreenAC(int shift)
{  return (cAC(shift) > cAC(shift+1));}

bool isRedAC(int shift)
{  return (cAC(shift) < cAC(shift + 1)); }

bool _MyBuy(int disaster_sl, int disaster_tp, double lots, int magicnumber, int slippage, color clr)
{
   double a = Ask, b = Bid, po = Point;
   bool r = false;
   
   double sl = 0, tp = 0;
   if (disaster_sl > 0) sl = a - (disaster_sl * po);
   if (disaster_tp > 0) tp = a + (disaster_tp * po);

   if (OrderSend(Symbol(), OP_BUY, lots, a, slippage, 
      sl, tp, "", 
      magicnumber, 0, clr) > 0)
   { r = true; }
   return (r);
}

bool _MySell(int disaster_sl, int disaster_tp, double lots, int magicnumber, int slippage, color clr)
{
   double a = Ask, b = Bid, po = Point;
   bool r = false;
   double sl = 0, tp = 0;
   if (disaster_sl > 0) sl = b + (disaster_sl * po);
   if (disaster_tp > 0) tp = b - (disaster_tp * po);
   if (OrderSend(Symbol(), OP_SELL, lots, b, slippage, 
      sl,tp, "",    
      magicnumber, 0, clr) > 0)
   { r = true; }
   
   return (r);
}


double _pip(double commissions)
{
   return ((Ask - Bid ) / commissions  );
}

void PlaySymbolAudio()
{
   PlaySound(Symbol() + ".wav");
}

void Play(string file)
{
   PlaySound(file);  
}

void PlaySymbolAudioAlert()
{
   PlaySound("Alert_" + Symbol() + ".wav");
}

void DeleteObjects()
{
   ObjectsDeleteAll();
}

int magicfile(string filename, string separator)
{
   int handle = 0;
   double ret = -1;
   string mystring = "";
   string s1, s2;
   
   handle=FileOpen(filename, FILE_CSV|FILE_READ, separator);
   if (handle > 0)
   {
      while (!FileIsEnding(handle))
      {
         mystring = FileReadString(handle);
         int pos = StringFind(mystring, separator);
         if (pos > -1)
         {
            s1 = StringSubstr(mystring, 0, pos-1);
            if (s1 == Symbol())
            {
               s2 = StringSubstr(mystring, pos + 1);
               break;
            }
         }
      }
      FileClose(handle);
   }
   if (s2 != "") return (StrToDouble(s2)); else return (-1);
}

double commissionsfile(string filename, string symbol, string separator)
{
   int handle = 0;
   double ret = -1;
   string mystring = "";
   string s1, s2;
   
   handle=FileOpen(filename, FILE_CSV|FILE_READ, separator);
   if (handle > 0)
   {
      while (!FileIsEnding(handle))
      {
         mystring = FileReadString(handle);
         int pos = StringFind(mystring, separator);
         if (pos > -1)
         {
            s1 = StringSubstr(mystring, 0, pos-1);
            if (s1 == symbol)
            {
               s2 = StringSubstr(mystring, pos + 1);
               break;
            }
         }
      }
      FileClose(handle);
   }
   if (s2 != "") return (StrToDouble(s2)); else return (-1);
}


void SetGbIfNotExist(string name, double value)
{
   if (!GlobalVariableCheck(name)) { GlobalVariableSet(name, value); }
}

double GetGb(string name, double defaultValue)
{
   SetGbIfNotExist(name, defaultValue);
   return (GlobalVariableGet(name));
}

void SetGb (string name , double value)
{
   GlobalVariableSet(name, value);
}




int OpenOrder(int type, double pointmul, int StopLoss, int Slippage, string ExpertComment, int MagicNumber, int NumberOfTries, double Lots, int triessleep)
{
   double po = Point * pointmul;
   int ticket=0, err=0, c = 0;
   if(type==OP_BUY) {
      for(c = 0 ; c < NumberOfTries ; c++) {
         ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,Ask-StopLoss*po,0 ,ExpertComment,MagicNumber,0,Green);
         err=GetLastError();
         if(err==0) {  break; }
         else
         {
            if(err==4 || err==137 ||err==146 || err==136) //Busy errors
            { Sleep(triessleep); continue; }
            else //normal error
            { Print("Error opening BUY order : ", ErrorDescription(err)); break; }  
         }
      }   
   }
   if(type==OP_SELL)
   {   
      for(c = 0 ; c < NumberOfTries ; c++)
      {
         ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,Bid+StopLoss*po,0,ExpertComment,MagicNumber,0,Red);
         err=GetLastError();
         if(err==0) {  break; }
         else {
            if(err==4 || err==137 ||err==146 || err==136) //Busy errors
            { Sleep(triessleep); continue; }
            else //normal error
            { Print("Error opening SELL order : ", ErrorDescription(err)); break; }  
         }
      }   
   } 
   return(ticket);
}

double Trend3Period(int period, int ema, int shift)
{
   double ret = iMA(Symbol(), period, ema, 0 , MODE_EMA , PRICE_CLOSE, 0);   
   return (ret);
}

int Trend3Daily(int EMAS, int EMAM, int EMAL, int shift, int s_spread)
{
   double emas = Trend3Period(PERIOD_D1, EMAS, shift);
   double emam = Trend3Period(PERIOD_D1, EMAM, shift);
   double emal = Trend3Period(PERIOD_D1, EMAL, shift);
   double emass = Trend3Period(PERIOD_D1, EMAS, shift + s_spread);
   double emams = Trend3Period(PERIOD_D1, EMAM, shift + s_spread);
   double emals = Trend3Period(PERIOD_D1, EMAL, shift + s_spread);
   
   
   int ret = OP_NONE;
   if (
      (emas > emam && emam > emal) /*
      &&
      (emas > emass && emam > emams && emal > emals) */
      ) {
      ret = OP_BUY;
   }
   else if (
      (emal > emam && emam > emas) /*
      &&
      (emals > emams && emams > emass)  */
      ) {
      ret = OP_SELL;
   }
   Comment("emas: ", emas, " emam: ", emam, " emal: ", emal, " emass: ", emass, " emams: ", emams, " emals: ", emals, "\nOP:", ret);
   return (ret);  
}

/* Order functions lib */
bool GetOrdByTicket(int ticket) {
   return (OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES));
}

int GetOrdType(int ticket)
{
   int ret = -1;
   if (GetOrdByTicket(ticket)) {
      ret = OrderType();
   }
   return (ret);

}

double GetOrdPrice(int ticket)
{
   double ret = -1;
   if (GetOrdByTicket(ticket)) {
      ret = OrderOpenPrice();
   }
   return (ret);
}

void OrdCloseAllEx(int magic, bool chkMagic, int Slip, int Wait)
{
   int total = OrdersTotal();
   for(int i=total-1;i>-1;i--)
   {
      OrderSelect(i, SELECT_BY_POS);
      int type   = OrderType();
      bool result = false;
      if ((chkMagic && OrderMagicNumber() == magic) || (OrderSymbol() == Symbol() ))
      {
         switch(type)
         {
            case OP_BUY  : result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), Slip, Green); break;
            case OP_SELL : result = OrderClose( OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), Slip, Red ); break;
         }
         if(result == false)
         {
            Alert("Order " , OrderTicket() , " failed to close. Error:" , GetLastError() );
            Sleep(Wait);
            RefreshRates();
            i--;
         }
      }  
   }
}

void OrdCloseAll(int magic, bool chkMagic, int Slip)
{
   OrdCloseAllEx(magic, chkMagic, Slip, 2000);
}

double CalcPIPVal(double PIP, double value)
{
   return (value * PIP);
}

int ONum(int mn, bool chkMn)
{
   int count =0 ;
   for ( int i = 0; i < OrdersTotal(); i++)
      OrderSelect(i, SELECT_BY_POS);
      if (((OrderMagicNumber() == mn) && chkMn) || (OrderSymbol() == Symbol())) count++;
   return (count);
}


/* stack functions */
static int order_stack[];

void push(int &array[], int value)
{
   int size = ArraySize(array);
   ArrayResize(array, size+1);
   array[size] = value;
}

int pop(int &array[])
{
   int size = ArraySize(array);
   int ret = array[size-1];
   ArrayResize(array, size - 1   );
   return (ret);
}

void Push(int value)
{
   push(order_stack, value);   
}

// ritorna il ticket dell'ultimo valore nello stack
int Pop()
{
   int ret = -1;
   if (ArraySize(order_stack) > 0)
      ret = pop(order_stack);
   return (ret);
}

void init_order_stack()
{
   ArrayResize(order_stack, 0);
}

int OrderStackCount()
{
   return (ArraySize(order_stack));
}

int GetLastOrderTicket()
{
   int ret = -1;
   if (ArraySize(order_stack) > 0)
   {
      ret = Pop();
      Push(ret);
   }
   return (ret);
}
/*************************/

// se ritorna un numero < 0 allora è una perdita altrimenti un guadagno
int PointProfit(int order_ticket)
{
   double b = Bid, a = Ask, profit = 0;
   if (OrderSelect(order_ticket, SELECT_BY_TICKET, MODE_TRADES))
   {
      if (OrderType() == OP_BUY)
         profit = b - a;
      else 
        profit = a - b;
   }
   return(0);
}

int CountOrders(int magic)
{
   int ot = OrdersTotal();  
   int ret = 0;
   for (int i = ot; i > 0; i--)
   {
      
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      int omn = OrderMagicNumber();
      string os = OrderSymbol();
      if (magic > 0)
      {
         if (omn == magic && os == Symbol())
         {
            ret++;
         }
      }
      else
      {
         if (os == Symbol())  ret++;
      }
   }
   return (ret);
}

int _IsTradeAllowed( int MaxWaiting_sec = 30 )
{
    if ( !IsTradeAllowed() )
    {
        int StartWaitingTime = GetTickCount();

        while ( true )
        {
            if ( IsStopped() ) { return(-1); }
            if ( GetTickCount() - StartWaitingTime > MaxWaiting_sec * 1000 ) { Print( "???????? ????? ???????? (" + MaxWaiting_sec + " ???.)!" ); return(-2); }
            if ( IsTradeAllowed() )
            {
                return(0);
            }
            Sleep(100);
        }
    }
    else
    {
        return(1);
    }
}

void AlertError()
{
   int error = GetLastError();
   Alert(ErrorDescription(error));
}

string ErrorDescription(int error_code)
  {
   string error_string;
   switch(error_code)
     {
      case 0:
      case 1:   error_string="no error";                                                  break;
      case 2:   error_string="common error";                                              break;
      case 3:   error_string="invalid trade parameters";                                  break;
      case 4:   error_string="trade server is busy";                                      break;
      case 5:   error_string="old version of the client terminal";                        break;
      case 6:   error_string="no connection with trade server";                           break;
      case 7:   error_string="not enough rights";                                         break;
      case 8:   error_string="too frequent requests";                                     break;
      case 9:   error_string="malfunctional trade operation";                             break;
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
      case 137: error_string="broker is busy";                                            break;
      case 138: error_string="requote";                                                   break;
      case 139: error_string="order is locked";                                           break;
      case 140: error_string="long positions only allowed";                               break;
      case 141: error_string="too many requests";                                         break;
      case 145: error_string="modification denied because order too close to market";     break;
      case 146: error_string="trade context is busy";                                     break;
      //---- mql4 errors
      case 4000: error_string="no error";                                                 break;
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
      case 4109: error_string="trade is not allowed";                                     break;
      case 4110: error_string="longs are not allowed";                                    break;
      case 4111: error_string="shorts are not allowed";                                   break;
      case 4200: error_string="object is already exist";                                  break;
      case 4201: error_string="unknown object property";                                  break;
      case 4202: error_string="object is not exist";                                      break;
      case 4203: error_string="unknown object type";                                      break;
      case 4204: error_string="no object name";                                           break;
      case 4205: error_string="object coordinates error";                                 break;
      case 4206: error_string="no specified subwindow";                                   break;
      default:   error_string="unknown error";
     }
   return(error_string);
  }

int RGB(int red_value,int green_value,int blue_value)
  {
//---- check parameters
   if(red_value<0)     red_value=0;
   if(red_value>255)   red_value=255;
   if(green_value<0)   green_value=0;
   if(green_value>255) green_value=255;
   if(blue_value<0)    blue_value=0;
   if(blue_value>255)  blue_value=255;

   green_value<<=8;
   blue_value<<=16;
   return(red_value+green_value+blue_value);
  }

bool CompareDoubles(double number1,double number2)
  {
   if(NormalizeDouble(number1-number2,8)==0) return(true);
   else return(false);
  }

string DoubleToStrMorePrecision(double number,int precision)
  {
   double rem,integer,integer2;
   double DecimalArray[17]={ 1.0, 10.0, 100.0, 1000.0, 10000.0, 100000.0, 1000000.0,  10000000.0, 100000000.0,
                             1000000000.0, 10000000000.0, 100000000000.0, 10000000000000.0, 100000000000000.0,
                             1000000000000000.0, 1000000000000000.0, 10000000000000000.0 };
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
   int    value, shift=28;
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
  
double spread()
{
   return (MarketInfo(Symbol(), MODE_SPREAD) * Point);
}

void myPivotEx(string symbol, int period, int shift, double &s1, double &ap, double &s2, double &s3, double &r1, double &r2, double &r3)
{
   double h = iHigh(symbol, period, shift);
   double l = iLow(symbol, period, shift);
   double c = iClose(symbol, period, shift);
   
   double AP = (h + l + c) / 3;     // avg pivot
   s1 = 2 * AP - h;
   r1 = 2 * AP - l;
   s2 = AP - r1 - s1;
   r2 = (AP - s1) + r1;
   s3 = s2 - h - l;
   r3 = r2 + h -l;
   ap = AP;
}

void DrawHLine(string name, double value, int shift, color clr, int style)
{
      // if (ObjectFind(name) != -1) ObjectDelete(name);
      ObjectCreate(name , OBJ_HLINE, cTime(shift), value, 0, 0, 0, 0); 
      ObjectSet(name, OBJPROP_COLOR, clr);
      ObjectSet(name, OBJPROP_STYLE, STYLE_SOLID);
}

void DailyPivot(string symbol, double &ap, double &s1, double &s2, double &s3, double &r1, double &r2, double &r3, bool draw)
{
   myPivotEx(Symbol(), PERIOD_D1, 1, ap, s1, s2, s3, r1, r2, r3);
   if (draw) 
   {
      string name = Symbol() + "-";
      DrawHLine(name + "r1", r1, 0, Green, STYLE_SOLID);
      DrawHLine(name + "r2", r2, 0, Green, STYLE_SOLID);
      DrawHLine(name + "r3", r3, 0, Green, STYLE_SOLID);
      DrawHLine(name + "s1", s1, 0, Red, STYLE_SOLID);
      DrawHLine(name + "s2", s2, 0, Red, STYLE_SOLID);
      DrawHLine(name + "s3", s3, 0, Red, STYLE_SOLID);
   }
}

int calcHigherPeriod( int period = 0) {
   int p = period;
   if ( p == 0) p = Period();
   switch (p) {
      case PERIOD_M1: 
         return (PERIOD_M5);
      case PERIOD_M5: 
         return (PERIOD_M15);
      case PERIOD_M15:
         return (PERIOD_M30);
      case PERIOD_M30:
         return (PERIOD_H1);
      case PERIOD_H1:
         return (PERIOD_H4);
      case PERIOD_H4:
         return (PERIOD_D1);
      case PERIOD_D1:
         return (PERIOD_W1);
      case PERIOD_W1:
         return (PERIOD_MN1);
      default:
         return (0);
   }
   return (0);     
}

// math functions 
double DivByZero(int a, int b) {
   if (a == 0 || b == 0) {
      return (0);
   }
   return (a / b);
}

int IntPart(double v) {
   int r = v;
   return (r);
}

// date & time functions
// le date sono espresse come secondi che passano dall 1/1/1900
void TimeSpan(datetime d1, datetime d2, int &d, int &h, int &m, int &s) {
   s = d1 - d2;
   
   d = DivByZero(s , 24*60*60);
   h = DivByZero(s , 60*60); 
   m = DivByZero(s , 60); 
   
   
}

 
//--------------------------------------------------------------------
double GetNeccessaryLotsWithRisk(int riskPercent, double sl, double price, int& error)
{
   error = LOTS_NORMAL;
   
   double ticks = MathAbs(sl - price) / MarketInfo(Symbol(), MODE_TICKSIZE),  
      riskAmount = AccountBalance() * riskPercent / 100.0,                    
      lots = riskAmount / (ticks * MarketInfo(Symbol(), MODE_TICKVALUE));     
   
   double maxLot = MarketInfo(Symbol(), MODE_MAXLOT),
      minLot = MarketInfo(Symbol(), MODE_MINLOT),
      lotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
      
   
   if (lots > maxLot)
   {
      error = LOTS_TOO_BIG;
      lots = 0;
   }
   if (lots < minLot)
   {
      error = LOTS_TOO_SMALL;
      lots = 0;
   }
   
   
   int digits;
   if (lotStep >= 1) digits = 0;             // 1
   else  if (lotStep * 10 >= 1) digits = 1;  // 0.1
         else digits = 2;                    // 0.01
   lots = NormalizeDouble(lots, digits);
 
   return (lots);
}