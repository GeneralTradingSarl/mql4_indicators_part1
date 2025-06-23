//+------------------------------------------------------------------+
//|                                          All_In_One_Grab 1.0 mq4 |
//|                                   Copyright © 2014, Michael Beck |
//|                                          http://fuckthisshit.lol |
//+------------------------------------------------------------------+
#property indicator_chart_window
//+------------------------------------------------------------------+
//| VARIAVBLEN                                                       |
//+------------------------------------------------------------------+
//|----------- Variablen -------------------------+
extern string Algemein   = "Variablen Block";
extern int    obCorner   = 1;
extern int    LabelPosX  = 4;
extern int    LabelPosY  = 40;
extern int    FontSize   = 10;
extern string FontName   = "Microsoft Sans Serif";
//|----------- Variablen Spread ------------------+
extern string Spread     = "Variablen Block";
extern bool   Spread_ON  = true;
extern color  FontColor  = Yellow;
//|----------- Variablen ATR ---------------------+
extern string ATR        = "Variablen Block";
extern bool   ATR_ON     = true;
extern int    ATRPeriod  = 14;
extern color  FontColor2 = Orange;
//|----------- Variablen Info ------------------+
extern string MarketNFO     = "Variablen Block";
extern bool   MarketInfo_ON = false;
extern color  FontColor3  = White;
extern int    extSpa1     =  450;
//|----------- Variablen vLines ------------------+
extern string vLines     = "Vertical Lines";
extern bool  vLines_ON    = true;
extern color vLineD1Color = DimGray;
extern color vLineW1Color = Yellow;
extern color vLineMNColor = Red;
//|----------- Variablen hLines ------------------+
extern string SpreadRead     = "Horizontal Lines";
extern bool hLines_ON     = true;
extern color hLineColor   = LightSlateGray;
//|----------- Variablen Pivot ----------------+
extern string Pivots     = "Variablen Block";
extern bool AllPivots_OFF  = false;
extern bool PivD0_ON       = true;
extern bool PivD0Ray_ON    = true;
//extern bool PivD1_ON       = true;
//extern bool PivD1Ray_ON    = false;
//extern bool PivW1_ON       = true;
//extern bool PivW1Ray_ON    = false;
//|----------- Variablen OHLC ----------------+
extern string OHLC     = "Only D1+W1 Close";
extern bool PriorClose_ON  = true;
extern bool PriorCloseW_ON = true;
extern bool PriorCloRay_ON = true;
extern color CloseColor = Red;
//|----------- Variablen PlusMinus----------------+
extern string Mix     = "Plus Minus + Range MAs";
extern bool PluMi_ON      = true;
extern bool Range_ON      = true;
extern color rangeColor   = Aqua;
extern bool MovAv_ON = true;
//++++++++++++++++++++++++++++++++++++++++++++++
//|----------- Variablen intern ------------------+
double Yen; 
int LabelPosY2,LabelPosY3,LabelPosY4,LabelPosY5,LabelPosY6,LabelPosY7,LabelPosY8,LabelPosY9,LabelPosY10;
int abstand = FontSize + 5;
double PivotD, R1D, R2D, R3D, S1D, S2D, S3D; // Today
double PivotY, R1Y, R2Y, R3Y, S1Y, S2Y, S3Y; // Yesterday
double PivotW, R1W, R2W, R3W, S1W, S2W, S3W; // Week
//------- HIGH ---------------------------------+  
double High0   = iHigh(NULL,PERIOD_D1,0);
double High1   = iHigh(NULL,PERIOD_D1,1);
double High2   = iHigh(NULL,PERIOD_D1,2);
double High3   = iHigh(NULL,PERIOD_D1,3);
double High4   = iHigh(NULL,PERIOD_D1,4);
double High5   = iHigh(NULL,PERIOD_D1,5);
//------- LOW ----------------------------------+  
double Low0   = iLow(NULL,PERIOD_D1,0);
double Low1   = iLow(NULL,PERIOD_D1,1);
double Low2   = iLow(NULL,PERIOD_D1,2);
double Low3   = iLow(NULL,PERIOD_D1,3);
double Low4   = iLow(NULL,PERIOD_D1,4);
double Low5   = iLow(NULL,PERIOD_D1,5);  
//------- OPEN ---------------------------------+  
double Open0  = iOpen(NULL,PERIOD_D1,0);
double Close1 = iClose(NULL,PERIOD_D1,1);
double Close2 = iClose(NULL,PERIOD_D1,2);
double Close3 = iClose(NULL,PERIOD_D1,3);
double Close4 = iClose(NULL,PERIOD_D1,4);
double Close5 = iClose(NULL,PERIOD_D1,5);
//------- HLO Week-------------------------------+   
double HighW0 = iHigh(NULL,PERIOD_W1,0);
double LowW0  = iLow (NULL,PERIOD_W1,0);
double OpenW0 = iOpen(NULL,PERIOD_W1,0); 
double CloseW0 = iOpen(NULL,PERIOD_W1,0); 
//------- HLO Month-------------------------------+   
double HighMN = iHigh(NULL,PERIOD_MN1,0);
double LowWMN = iLow (NULL,PERIOD_MN1,0);
double OpenMN = iOpen(NULL,PERIOD_MN1,0);  
//-------------------------------------Time Stuff
double TimeCu = TimeCurrent();
double TimeD0  = iTime(NULL,PERIOD_D1,0);
double TimeD1  = iTime(NULL,PERIOD_D1,1);
double TimeD2  = iTime(NULL,PERIOD_D1,2);
double TimeD3  = iTime(NULL,PERIOD_D1,3);
double TimeD4  = iTime(NULL,PERIOD_D1,4);
double TimeD5  = iTime(NULL,PERIOD_D1,5);
double TimeD6  = iTime(NULL,PERIOD_D1,6);
double TimeD7  = iTime(NULL,PERIOD_D1,7);
double TimeD8  = iTime(NULL,PERIOD_D1,8);
double TimeD9  = iTime(NULL,PERIOD_D1,9);
double TimeD10 = iTime(NULL,PERIOD_D1,10);
//--------------------------------------------   
double TimeW0  = iTime(NULL,PERIOD_W1,0);
double TimeW1  = iTime(NULL,PERIOD_W1,1); 
double TimeW2  = iTime(NULL,PERIOD_W1,2); 
double TimeW3  = iTime(NULL,PERIOD_W1,3); 
//--------------------------------------------     
double TimeMN0 = iTime(NULL,PERIOD_MN1,0);
double TimeMN1 = iTime(NULL,PERIOD_MN1,1);
//+------------------------------------------------------------------+
//| Custom indicator start function                                  |
//+------------------------------------------------------------------+
int init(){
//---- 
   LabelPosY2 = LabelPosY + abstand;
   LabelPosY3 = LabelPosY2 + abstand;
   
   LabelPosY7 = LabelPosY3 + abstand;
   LabelPosY8 = LabelPosY7 + abstand;
   LabelPosY9 = LabelPosY8 + abstand;
   LabelPosY10 = LabelPosY9 + abstand;
   
   LabelPosY4 = LabelPosY3 + abstand + extSpa1;
   LabelPosY5 = LabelPosY4 + abstand;
   LabelPosY6 = LabelPosY5 + abstand;

   if(Digits==3){Yen=1;}
    else {Yen=100;}
    
   PivotD = (High1 + Low1 + Close1) / 3;
   R1D    = (PivotD * 2) - Low1;
   R2D    = PivotD + ( High1 - Low1);
   R3D    = (PivotD - Low1)*2 + High1;
   S1D    = (2 * PivotD) - High1;
   S2D    = PivotD - ( High1 - Low1);
   S3D    = Low1 - ( High1- PivotD)*2; 
//----
   return(0);}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit(){
   ObjectDelete("ATRD1440");  //SPRD
   ObjectDelete("ATRD1455");  //ATRD1
   ObjectDelete("ATRD1470");  //ATRW1
   ObjectDelete("ATRD1485"); //PMD0
   ObjectDelete("ATRD14100"); //PMW0
   ObjectDelete("ATRD14115"); //PMMN
   ObjectDelete("ATRD14130"); //Range
//--- Info   
   ObjectDelete("ATRD14535");
   ObjectDelete("ATRD14550");
   ObjectDelete("ATRD14565");
//--- vLines Day     
   ObjectDelete("vLineD0");
   ObjectDelete("vLineD1");
   ObjectDelete("vLineD2");
   ObjectDelete("vLineD3");
   ObjectDelete("vLineD4");
   ObjectDelete("vLineD5");
   ObjectDelete("vLineD6");
   ObjectDelete("vLineD7");
   ObjectDelete("vLineD8");
   ObjectDelete("vLineD9");
   ObjectDelete("vLineD10");
//--- Week --- Month
   ObjectDelete("vLineW0");
   ObjectDelete("vLineW1");
   ObjectDelete("vLineW2");
   ObjectDelete("vLineW3");
   ObjectDelete("vLineMN0");
   ObjectDelete("vLineMN1");
//------------------ hLines
   ObjectDelete("hLineM");
   ObjectDelete("hLineM1");
   ObjectDelete("hLineM2");
   ObjectDelete("hLineM3");
   ObjectDelete("hLineMm1");
   ObjectDelete("hLineMm2");
   ObjectDelete("hLineMm3");
//----- hLinesYen   
   ObjectDelete("hLineMY");
   ObjectDelete("hLineMY1");
   ObjectDelete("hLineMY2");
   ObjectDelete("hLineMY3");
   ObjectDelete("hLineMYm1");
   ObjectDelete("hLineMYm2");
   ObjectDelete("hLineMYm3");  
//---------------- Pivots  
//----------------- OHLC
   ObjectDelete("CloseD1"); 
   ObjectDelete("CloseW1"); 
//----------------- PivD
   ObjectDelete("PivD0"); 
   ObjectDelete("PivD0S1"); 
   ObjectDelete("PivD0S2"); 
   ObjectDelete("PivD0S3");
   ObjectDelete("PivD0R1"); 
   ObjectDelete("PivD0R2");
   ObjectDelete("PivD0R3");
//----------------- MAs
   ObjectDelete("MA50D0"); 
   ObjectDelete("MA50D1"); 
   ObjectDelete("MA50D2"); 
   ObjectDelete("MA200D0");
   ObjectDelete("MA200D1"); 
   ObjectDelete("MA200D2");         
//----
   return(0);}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//----
//------------- FUNCTION SPACE ------------------------------
  vLinesCreate();
  hLinesCreate();
  OHLCCreate();
  PivotCreate();
  MAsCreate();
//------------- FUNCTION SPACE ENDE -----------------------------
//-------------------------------------------------------------
if(Spread_ON == true)
  {
    double spread = MarketInfo(Symbol(), MODE_SPREAD);
    pxy("SPRD: "+DoubleToStr(spread/10,1),FontColor,LabelPosX,LabelPosY,FontSize);
      
  }
  else Print("Spread OFF");  
//-------------------------------------------------+
if(ATR_ON == true)
  {
    double ATRd1 = iATR(NULL,PERIOD_D1,ATRPeriod,1)*100*Yen;
    double ATRw1 = iATR(NULL,PERIOD_W1,ATRPeriod,1)*100*Yen;
    pxy("ATRD1: "+DoubleToStr(ATRd1,1),FontColor2,LabelPosX,LabelPosY2,FontSize);
    pxy("ATRW1: "+DoubleToStr(ATRw1,1),FontColor2,LabelPosX,LabelPosY3,FontSize);
  }
  else Print("ATR OFF");  
//------------------------------------------------+
if(MarketInfo_ON == true)
  {
    double TickV = MarketInfo(Symbol(),MODE_TICKVALUE); 
    double LSw = MarketInfo(Symbol(),MODE_SWAPLONG); 
    double SSw = MarketInfo(Symbol(),MODE_SWAPSHORT);   
    pxy("TickValue: "+DoubleToStr(TickV/10,2),FontColor3,LabelPosX,LabelPosY4,FontSize);
    pxy("LongSW: "+DoubleToStr(LSw/10,2),FontColor3,LabelPosX,LabelPosY5,FontSize);
    pxy("ShortSW: "+DoubleToStr(SSw/10,2),FontColor3,LabelPosX,LabelPosY6,FontSize);
  }
  else Print("Market Info OFF");  
//-+-+-+-+-++-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+-+-+-+-+-++-+-+-+-+-+     
if(PluMi_ON == true)
  {
    double PlMiDay = Bid - Open0;
    double PlMiWee = Bid - OpenW0;
    double PlMiMN  = Bid - OpenMN;
//--------- DAILY --------------------------       
    if(Bid > Open0)
      {
       pxy("+-D0: "+DoubleToStr(PlMiDay*100*Yen,1),Lime,LabelPosX,LabelPosY8,FontSize);
      }   
    else{pxy("+-D0: "+DoubleToStr(PlMiDay*100*Yen,1),Red,LabelPosX,LabelPosY8,FontSize);} 
//--------- WEEKLEY --------------------------        
    if(Bid > OpenW0)
      {
       pxy("+-W0: "+DoubleToStr(PlMiWee*100*Yen,1),Lime,LabelPosX,LabelPosY9,FontSize);
      }   
    else{pxy("+-W0: "+DoubleToStr(PlMiWee*100*Yen,1),Red,LabelPosX,LabelPosY9,FontSize);} 
//--------- MONTHLY --------------------------       
    if(Bid > OpenMN)
      {
       pxy("+-MN0: "+DoubleToStr(PlMiMN*100*Yen,1),Lime,LabelPosX,LabelPosY10,FontSize);
      }   
    else{pxy("+-MN0: "+DoubleToStr(PlMiMN*100*Yen,1),Red,LabelPosX,LabelPosY10,FontSize);}  
  }
else Print("Plus Minus OFF");   

//------------- Daily Range -----------------------------
if(Range_ON == true)
  {
   double range = High0 - Low0;
  if(Digits == 5)
    {pxy("RangeD: "+DoubleToStr(range*10000,1),rangeColor,LabelPosX,LabelPosY7,FontSize);} 
  if(Digits ==3)
    {pxy("RangeD: "+DoubleToStr(range*100,1),rangeColor,LabelPosX,LabelPosY7,FontSize);} 
  }
  else Print("Daily Range OFF");  
//------------------------------------------------------------------
//------------+   
   return(0);
  }
//------------- int start ENDE -------------------+
//|--------------------- Label Function---------------------+
string pxy(string mytext,color clr,int posx,int posy,int size)
  { 
   string n="ATRD1"+posx+posy;  
   ObjectCreate(n,OBJ_LABEL,0,0,0);
   ObjectSet(n,OBJPROP_CORNER,obCorner);
   ObjectSet(n,OBJPROP_XDISTANCE,posx);
   ObjectSet(n,OBJPROP_YDISTANCE,posy);
   ObjectSet(n,OBJPROP_COLOR,clr);
   ObjectSetText(n,mytext,size);
   return(n);}
//++++++++++++++++ START VOIDS +++++++++++++++++++  
//---------------- ANFANG MAs ----------------+++
//++++++++++++++++++++++++++++++++++++++++++++++++

void MAsCreate()               
  { 
   double MA50D0  = iMA(NULL,PERIOD_D1,50 ,0,MODE_SMA,PRICE_CLOSE,0);
   double MA50D1 = iMA(NULL,PERIOD_D1,50 ,0,MODE_SMA,PRICE_CLOSE,1);
   double MA50D2 = iMA(NULL,PERIOD_D1,50 ,0,MODE_SMA,PRICE_CLOSE,2);
   double MA50D3 = iMA(NULL,PERIOD_D1,50 ,0,MODE_SMA,PRICE_CLOSE,3);
   double MA50D4 = iMA(NULL,PERIOD_D1,50 ,0,MODE_SMA,PRICE_CLOSE,4);
   double MA50D5 = iMA(NULL,PERIOD_D1,50 ,0,MODE_SMA,PRICE_CLOSE,5);
   
   double MA200D0  = iMA(NULL,PERIOD_D1,200,0,MODE_SMA,PRICE_CLOSE,0);
   double MA200D1 = iMA(NULL,PERIOD_D1,200,0,MODE_SMA,PRICE_CLOSE,1);
   double MA200D2 = iMA(NULL,PERIOD_D1,200,0,MODE_SMA,PRICE_CLOSE,2);
   double MA200D3 = iMA(NULL,PERIOD_D1,200,0,MODE_SMA,PRICE_CLOSE,3);
   double MA200D4 = iMA(NULL,PERIOD_D1,200,0,MODE_SMA,PRICE_CLOSE,4);
   double MA200D5 = iMA(NULL,PERIOD_D1,200,0,MODE_SMA,PRICE_CLOSE,5);
  
  
  
   if(MovAv_ON == true && Period() <= PERIOD_H4)                 
      {
       ObjectCreate(NULL,"MA50D0",OBJ_TREND,0,0,0);
       ObjectSet("MA50D0",OBJPROP_WIDTH,2);
       ObjectSet("MA50D0",OBJPROP_COLOR,Aqua);
       ObjectSet("MA50D0",OBJPROP_STYLE,6);
       ObjectSet("MA50D0",OBJPROP_TIME1,TimeD0);
       ObjectSet("MA50D0",OBJPROP_TIME2,TimeCu);
       ObjectSet("MA50D0",OBJPROP_PRICE1,MA50D0);
       ObjectSet("MA50D0",OBJPROP_PRICE2,MA50D0);
       ObjectSet("MA50D0",OBJPROP_RAY_RIGHT,false);
       ObjectSet("MA50D0",OBJPROP_BACK,true);
        
       ObjectCreate(NULL,"MA50D1",OBJ_TREND,0,0,0);
       ObjectSet("MA50D1",OBJPROP_WIDTH,2);
       ObjectSet("MA50D1",OBJPROP_COLOR,Aqua);
       ObjectSet("MA50D1",OBJPROP_STYLE,6);
       ObjectSet("MA50D1",OBJPROP_TIME1,TimeD1);
       ObjectSet("MA50D1",OBJPROP_TIME2,TimeD0);
       ObjectSet("MA50D1",OBJPROP_PRICE1,MA50D1);
       ObjectSet("MA50D1",OBJPROP_PRICE2,MA50D1);
       ObjectSet("MA50D1",OBJPROP_RAY_RIGHT,false);
       ObjectSet("MA50D1",OBJPROP_BACK,true);
       
       ObjectCreate(NULL,"MA50D2",OBJ_TREND,0,0,0);
       ObjectSet("MA50D2",OBJPROP_WIDTH,2);
       ObjectSet("MA50D2",OBJPROP_COLOR,Aqua);
       ObjectSet("MA50D2",OBJPROP_STYLE,6);
       ObjectSet("MA50D2",OBJPROP_TIME1,TimeD2);
       ObjectSet("MA50D2",OBJPROP_TIME2,TimeD1);
       ObjectSet("MA50D2",OBJPROP_PRICE1,MA50D2);
       ObjectSet("MA50D2",OBJPROP_PRICE2,MA50D2);
       ObjectSet("MA50D2",OBJPROP_RAY_RIGHT,false);
       ObjectSet("MA50D2",OBJPROP_BACK,true);
       
       ObjectCreate(NULL,"MA200D0",OBJ_TREND,0,0,0);
       ObjectSet("MA200D0",OBJPROP_WIDTH,2);
       ObjectSet("MA200D0",OBJPROP_COLOR,Blue);
       ObjectSet("MA200D0",OBJPROP_STYLE,6);
       ObjectSet("MA200D0",OBJPROP_TIME1,TimeD0);
       ObjectSet("MA200D0",OBJPROP_TIME2,TimeCu);
       ObjectSet("MA200D0",OBJPROP_PRICE1,MA200D0);
       ObjectSet("MA200D0",OBJPROP_PRICE2,MA200D0);
       ObjectSet("MA200D0",OBJPROP_RAY_RIGHT,false);
       ObjectSet("MA200D0",OBJPROP_BACK,true);
       
       ObjectCreate(NULL,"MA200D1",OBJ_TREND,0,0,0);
       ObjectSet("MA200D1",OBJPROP_WIDTH,2);
       ObjectSet("MA200D1",OBJPROP_COLOR,Blue);
       ObjectSet("MA200D1",OBJPROP_STYLE,6);
       ObjectSet("MA200D1",OBJPROP_TIME1,TimeD0);
       ObjectSet("MA200D1",OBJPROP_TIME2,TimeD1);
       ObjectSet("MA200D1",OBJPROP_PRICE1,MA200D1);
       ObjectSet("MA200D1",OBJPROP_PRICE2,MA200D1);
       ObjectSet("MA200D1",OBJPROP_RAY_RIGHT,false);
       ObjectSet("MA200D1",OBJPROP_BACK,true);
       
       ObjectCreate(NULL,"MA200D2",OBJ_TREND,0,0,0);
       ObjectSet("MA200D2",OBJPROP_WIDTH,2);
       ObjectSet("MA200D2",OBJPROP_COLOR,Blue);
       ObjectSet("MA200D2",OBJPROP_STYLE,6);
       ObjectSet("MA200D2",OBJPROP_TIME1,TimeD1);
       ObjectSet("MA200D2",OBJPROP_TIME2,TimeD2);
       ObjectSet("MA200D2",OBJPROP_PRICE1,MA200D2);
       ObjectSet("MA200D2",OBJPROP_PRICE2,MA200D2);
       ObjectSet("MA200D2",OBJPROP_RAY_RIGHT,false);
       ObjectSet("MA200D2",OBJPROP_BACK,true);
      }
   else Print("MAs OFF");     
  return;}
//++++++++++++++++++ENDE MAs ++++++++++++++++++++++++++ 
  
//++++++++++++++++++++++++++++++++++++++++++++++++++++++   
//---------------- ANFANG OHLC ----------------+++
//++++++++++++++++++++++++++++++++++++++++++++++++
void OHLCCreate()               
  { 
   if(PriorClose_ON == true && Period() <= PERIOD_H4)                 
      {
       ObjectCreate(NULL,"CloseD1",OBJ_TREND,0,0,0);
       ObjectSet("CloseD1",OBJPROP_WIDTH,1);
       ObjectSet("CloseD1",OBJPROP_COLOR,CloseColor);
       ObjectSet("CloseD1",OBJPROP_STYLE,3);
       ObjectSet("CloseD1",OBJPROP_TIME1,TimeD0);
       ObjectSet("CloseD1",OBJPROP_TIME2,TimeCu);
       ObjectSet("CloseD1",OBJPROP_PRICE1,Close1);
       ObjectSet("CloseD1",OBJPROP_PRICE2,Close1);
       ObjectSet("CloseD1",OBJPROP_RAY_RIGHT,PriorCloRay_ON);
       ObjectSet("CloseD1",OBJPROP_BACK,true);
      }
   if(PriorCloseW_ON == true && Period() <= PERIOD_H4)                 
      {    
       ObjectCreate(NULL,"CloseW1",OBJ_TREND,0,0,0);
       ObjectSet("CloseW1",OBJPROP_WIDTH,1);
       ObjectSet("CloseW1",OBJPROP_COLOR,CloseColor);
       ObjectSet("CloseW1",OBJPROP_STYLE,4);
       ObjectSet("CloseW1",OBJPROP_TIME1,TimeW0);
       ObjectSet("CloseW1",OBJPROP_TIME2,TimeCu);
       ObjectSet("CloseW1",OBJPROP_PRICE1,CloseW0);
       ObjectSet("CloseW1",OBJPROP_PRICE2,CloseW0);
       ObjectSet("CloseW1",OBJPROP_RAY_RIGHT,PriorCloRay_ON);
       ObjectSet("CloseW1",OBJPROP_BACK,true);
      }
   else Print("OHLC OFF");     
  return;}
//++++++++++++++++++ENDE OHLC ++++++++++++++++++++++++++    
//++++++++++++++++++++++++++++++++++++++++++++++++++++++   
//---------------- ANFANG Pivots -----------------------
void PivotCreate()               
  { 
   if(AllPivots_OFF == false && Period() <= PERIOD_D1)                 
      {
     if(PivD0_ON == true && Period() <= PERIOD_H4)
       {     
        ObjectCreate(NULL,"PivD0",OBJ_TREND,0,0,0);
        ObjectSet("PivD0",OBJPROP_WIDTH,2);
        ObjectSet("PivD0",OBJPROP_COLOR,Magenta);
        ObjectSet("PivD0",OBJPROP_STYLE,4);
        ObjectSet("PivD0",OBJPROP_TIME1,TimeD0);
        ObjectSet("PivD0",OBJPROP_TIME2,TimeCu);
        ObjectSet("PivD0",OBJPROP_PRICE1,PivotD);
        ObjectSet("PivD0",OBJPROP_PRICE2,PivotD);
        ObjectSet("PivD0",OBJPROP_RAY_RIGHT,PivD0Ray_ON);
        ObjectSet("PivD0",OBJPROP_BACK,true);
        
        ObjectCreate(NULL,"PivD0S1",OBJ_TREND,0,0,0);
        ObjectSet("PivD0S1",OBJPROP_WIDTH,1);
        ObjectSet("PivD0S1",OBJPROP_COLOR,Yellow);
        ObjectSet("PivD0S1",OBJPROP_STYLE,6);
        ObjectSet("PivD0S1",OBJPROP_TIME1,TimeD0);
        ObjectSet("PivD0S1",OBJPROP_TIME2,TimeCu);
        ObjectSet("PivD0S1",OBJPROP_PRICE1,S1D);
        ObjectSet("PivD0S1",OBJPROP_PRICE2,S1D);
        ObjectSet("PivD0S1",OBJPROP_RAY_RIGHT,PivD0Ray_ON);
        ObjectSet("PivD0S1",OBJPROP_BACK,true);
        
        ObjectCreate(NULL,"PivD0S2",OBJ_TREND,0,0,0);
        ObjectSet("PivD0S2",OBJPROP_WIDTH,1);
        ObjectSet("PivD0S2",OBJPROP_COLOR,Yellow);
        ObjectSet("PivD0S2",OBJPROP_STYLE,6);
        ObjectSet("PivD0S2",OBJPROP_TIME1,TimeD0);
        ObjectSet("PivD0S2",OBJPROP_TIME2,TimeCu);
        ObjectSet("PivD0S2",OBJPROP_PRICE1,S2D);
        ObjectSet("PivD0S2",OBJPROP_PRICE2,S2D);
        ObjectSet("PivD0S2",OBJPROP_RAY_RIGHT,PivD0Ray_ON);
        ObjectSet("PivD0S2",OBJPROP_BACK,true);
        
        ObjectCreate(NULL,"PivD0S3",OBJ_TREND,0,0,0);
        ObjectSet("PivD0S3",OBJPROP_WIDTH,1);
        ObjectSet("PivD0S3",OBJPROP_COLOR,Yellow);
        ObjectSet("PivD0S3",OBJPROP_STYLE,6);
        ObjectSet("PivD0S3",OBJPROP_TIME1,TimeD0);
        ObjectSet("PivD0S3",OBJPROP_TIME2,TimeCu);
        ObjectSet("PivD0S3",OBJPROP_PRICE1,S3D);
        ObjectSet("PivD0S3",OBJPROP_PRICE2,S3D);
        ObjectSet("PivD0S3",OBJPROP_RAY_RIGHT,PivD0Ray_ON);
        ObjectSet("PivD0S3",OBJPROP_BACK,true);
        
        ObjectCreate(NULL,"PivD0R1",OBJ_TREND,0,0,0);
        ObjectSet("PivD0R1",OBJPROP_WIDTH,1);
        ObjectSet("PivD0R1",OBJPROP_COLOR,White);
        ObjectSet("PivD0R1",OBJPROP_STYLE,6);
        ObjectSet("PivD0R1",OBJPROP_TIME1,TimeD0);
        ObjectSet("PivD0R1",OBJPROP_TIME2,TimeCu);
        ObjectSet("PivD0R1",OBJPROP_PRICE1,R1D);
        ObjectSet("PivD0R1",OBJPROP_PRICE2,R1D);
        ObjectSet("PivD0R1",OBJPROP_RAY_RIGHT,PivD0Ray_ON);
        ObjectSet("PivD0R1",OBJPROP_BACK,true);
        
        ObjectCreate(NULL,"PivD0R2",OBJ_TREND,0,0,0);
        ObjectSet("PivD0R2",OBJPROP_WIDTH,1);
        ObjectSet("PivD0R2",OBJPROP_COLOR,White);
        ObjectSet("PivD0R2",OBJPROP_STYLE,6);
        ObjectSet("PivD0R2",OBJPROP_TIME1,TimeD0);
        ObjectSet("PivD0R2",OBJPROP_TIME2,TimeCu);
        ObjectSet("PivD0R2",OBJPROP_PRICE1,R2D);
        ObjectSet("PivD0R2",OBJPROP_PRICE2,R2D);
        ObjectSet("PivD0R2",OBJPROP_RAY_RIGHT,PivD0Ray_ON);
        ObjectSet("PivD0R2",OBJPROP_BACK,true);
        
        ObjectCreate(NULL,"PivD0R3",OBJ_TREND,0,0,0);
        ObjectSet("PivD0R3",OBJPROP_WIDTH,1);
        ObjectSet("PivD0R3",OBJPROP_COLOR,White);
        ObjectSet("PivD0R3",OBJPROP_STYLE,6);
        ObjectSet("PivD0R3",OBJPROP_TIME1,TimeD0);
        ObjectSet("PivD0R3",OBJPROP_TIME2,TimeCu);
        ObjectSet("PivD0R3",OBJPROP_PRICE1,R3D);
        ObjectSet("PivD0R3",OBJPROP_PRICE2,R3D);
        ObjectSet("PivD0R3",OBJPROP_RAY_RIGHT,PivD0Ray_ON);
        ObjectSet("PivD0R3",OBJPROP_BACK,true);
       
       }
      }
   else Print("Pivots OFF");     
  return;}
//++++++++++++++++++ENDE Pivots ++++++++++++++++++++++++++     
//---------------- ANFANG hLines -------------------------  
void hLinesCreate()               
  { 
   if(hLines_ON == true && Period() <= PERIOD_D1)                 
      {
     if(Digits() == 5)
       {double mittig = NormalizeDouble(Bid,2);
        double mittigO1 = mittig + 0.01;
        double mittigO2 = mittig + 0.02;
        double mittigO3 = mittig + 0.03;
        double mittigU1 = mittig - 0.01;
        double mittigU2 = mittig - 0.02;
        double mittigU3 = mittig - 0.03;
        
        ObjectCreate(NULL,"hLineM",OBJ_HLINE,0,0,mittig);
        ObjectSet("hLineM",OBJPROP_WIDTH,1);
        ObjectSet("hLineM",OBJPROP_COLOR,hLineColor);
        ObjectSet("hLineM",OBJPROP_STYLE,2);
        ObjectSet("hLineM",OBJPROP_BACK,true);
        
        ObjectCreate(NULL,"hLineM1",OBJ_HLINE,0,0,mittigO1);
        ObjectSet("hLineM1",OBJPROP_WIDTH,1);
        ObjectSet("hLineM1",OBJPROP_COLOR,hLineColor);
        ObjectSet("hLineM1",OBJPROP_STYLE,2);
        ObjectSet("hLineM1",OBJPROP_BACK,true);
        
        ObjectCreate(NULL,"hLineM2",OBJ_HLINE,0,0,mittigO2);
        ObjectSet("hLineM2",OBJPROP_WIDTH,1);
        ObjectSet("hLineM2",OBJPROP_COLOR,hLineColor);
        ObjectSet("hLineM2",OBJPROP_STYLE,2);
        ObjectSet("hLineM2",OBJPROP_BACK,true);
        
        ObjectCreate(NULL,"hLineM3",OBJ_HLINE,0,0,mittigO3);
        ObjectSet("hLineM3",OBJPROP_WIDTH,1);
        ObjectSet("hLineM3",OBJPROP_COLOR,hLineColor);
        ObjectSet("hLineM3",OBJPROP_STYLE,2);
        ObjectSet("hLineM3",OBJPROP_BACK,true);
        
        ObjectCreate(NULL,"hLineMm1",OBJ_HLINE,0,0,mittigU1);
        ObjectSet("hLineMm1",OBJPROP_WIDTH,1);
        ObjectSet("hLineMm1",OBJPROP_COLOR,hLineColor);
        ObjectSet("hLineMm1",OBJPROP_STYLE,2);
        ObjectSet("hLineMm1",OBJPROP_BACK,true);
        
        ObjectCreate(NULL,"hLineMm2",OBJ_HLINE,0,0,mittigU2);
        ObjectSet("hLineMm2",OBJPROP_WIDTH,1);
        ObjectSet("hLineMm2",OBJPROP_COLOR,hLineColor);
        ObjectSet("hLineMm2",OBJPROP_STYLE,2);
        ObjectSet("hLineMm2",OBJPROP_BACK,true);
        
        ObjectCreate(NULL,"hLineMm3",OBJ_HLINE,0,0,mittigU3);
        ObjectSet("hLineMm3",OBJPROP_WIDTH,1);
        ObjectSet("hLineMm3",OBJPROP_COLOR,hLineColor);
        ObjectSet("hLineMm3",OBJPROP_STYLE,2);
        ObjectSet("hLineMm3",OBJPROP_BACK,true);
       }
//------------------- YEN -------------------------     
     if(Digits() == 3)
       {double mittigYen = NormalizeDouble(Bid,0);   
        double mittigYenO1 = mittigYen + 1;
        double mittigYenO2 = mittigYen + 2;
        double mittigYenO3 = mittigYen + 3;
        double mittigYenU1 = mittigYen - 1;
        double mittigYenU2 = mittigYen - 2;
        double mittigYenU3 = mittigYen - 3;
        
        ObjectCreate(NULL,"hLineMY",OBJ_HLINE,0,0,mittigYen);
        ObjectSet("hLineMY",OBJPROP_WIDTH,1);
        ObjectSet("hLineMY",OBJPROP_COLOR,hLineColor);
        ObjectSet("hLineMY",OBJPROP_STYLE,2);
        ObjectSet("hLineMY",OBJPROP_BACK,true);
        
        ObjectCreate(NULL,"hLineMY1",OBJ_HLINE,0,0,mittigYenO1);
        ObjectSet("hLineMY1",OBJPROP_WIDTH,1);
        ObjectSet("hLineMY1",OBJPROP_COLOR,hLineColor);
        ObjectSet("hLineMY1",OBJPROP_STYLE,2);
        ObjectSet("hLineMY1",OBJPROP_BACK,true);
        
        ObjectCreate(NULL,"hLineMY2",OBJ_HLINE,0,0,mittigYenO2);
        ObjectSet("hLineMY2",OBJPROP_WIDTH,1);
        ObjectSet("hLineMY2",OBJPROP_COLOR,hLineColor);
        ObjectSet("hLineMY2",OBJPROP_STYLE,2);
        ObjectSet("hLineMY2",OBJPROP_BACK,true);
        
        ObjectCreate(NULL,"hLineMY3",OBJ_HLINE,0,0,mittigYenO3);
        ObjectSet("hLineMY3",OBJPROP_COLOR,hLineColor);
        ObjectSet("hLineMY3",OBJPROP_STYLE,2);
        ObjectSet("hLineMY3",OBJPROP_BACK,true);
        
        ObjectCreate(NULL,"hLineMYm1",OBJ_HLINE,0,0,mittigYenU1);
        ObjectSet("hLineMYm1",OBJPROP_WIDTH,1);
        ObjectSet("hLineMYm1",OBJPROP_COLOR,hLineColor);
        ObjectSet("hLineMYm1",OBJPROP_STYLE,2);
        ObjectSet("hLineMYm1",OBJPROP_BACK,true);
        
        ObjectCreate(NULL,"hLineMYm2",OBJ_HLINE,0,0,mittigYenU2);
        ObjectSet("hLineMYm2",OBJPROP_WIDTH,1);
        ObjectSet("hLineMYm2",OBJPROP_COLOR,hLineColor);
        ObjectSet("hLineMYm2",OBJPROP_STYLE,2);
        ObjectSet("hLineMYm2",OBJPROP_BACK,true);
        
        ObjectCreate(NULL,"hLineMYm3",OBJ_HLINE,0,0,mittigYenU3);
        ObjectSet("hLineMYm3",OBJPROP_WIDTH,1);
        ObjectSet("hLineMYm3",OBJPROP_COLOR,hLineColor);
        ObjectSet("hLineMYm3",OBJPROP_STYLE,2);
        ObjectSet("hLineMYm3",OBJPROP_BACK,true);
       }
      }
   else Print("hLines OFF");     
  return;}
//++++++++++++++++++ENDE hLines ++++++++++++++++++++++++++  
//---------------- ANFANG vLines -------------------------
void vLinesCreate()               
  {   
//------------------ FUNCTION --------------------------                                                  
   if(vLines_ON == true)                 
      {
//------------------- DAY -------------------------  
     if(Period() <= 60)
       {
       ObjectCreate(NULL,"vLineD0",OBJ_VLINE,0,TimeD0,0);
       ObjectSet("vLineD0",OBJPROP_WIDTH,1);
       ObjectSet("vLineD0",OBJPROP_COLOR,vLineD1Color);
       ObjectSet("vLineD0",OBJPROP_STYLE,2);
       ObjectSet("vLineD0",OBJPROP_BACK,true);
       
       ObjectCreate(NULL,"vLineD1",OBJ_VLINE,0,TimeD1,0);
       ObjectSet("vLineD1",OBJPROP_WIDTH,1);
       ObjectSet("vLineD1",OBJPROP_COLOR,vLineD1Color);
       ObjectSet("vLineD1",OBJPROP_STYLE,2);
       ObjectSet("vLineD1",OBJPROP_BACK,true);
       
       ObjectCreate(NULL,"vLineD2",OBJ_VLINE,0,TimeD2,0);
       ObjectSet("vLineD2",OBJPROP_WIDTH,1);
       ObjectSet("vLineD2",OBJPROP_COLOR,vLineD1Color);
       ObjectSet("vLineD2",OBJPROP_STYLE,2);
       ObjectSet("vLineD2",OBJPROP_BACK,true);
       
       ObjectCreate(NULL,"vLineD3",OBJ_VLINE,0,TimeD3,0);
       ObjectSet("vLineD3",OBJPROP_WIDTH,1);
       ObjectSet("vLineD3",OBJPROP_COLOR,vLineD1Color);
       ObjectSet("vLineD3",OBJPROP_STYLE,2);
       ObjectSet("vLineD3",OBJPROP_BACK,true);
       
       ObjectCreate(NULL,"vLineD4",OBJ_VLINE,0,TimeD4,0);
       ObjectSet("vLineD4",OBJPROP_WIDTH,1);
       ObjectSet("vLineD4",OBJPROP_COLOR,vLineD1Color);
       ObjectSet("vLineD4",OBJPROP_STYLE,2);
       ObjectSet("vLineD4",OBJPROP_BACK,true);
       
       ObjectCreate(NULL,"vLineD5",OBJ_VLINE,0,TimeD5,0);
       ObjectSet("vLineD5",OBJPROP_WIDTH,1);
       ObjectSet("vLineD5",OBJPROP_COLOR,vLineD1Color);
       ObjectSet("vLineD5",OBJPROP_STYLE,2);
       ObjectSet("vLineD5",OBJPROP_BACK,true);
       
       ObjectCreate(NULL,"vLineD6",OBJ_VLINE,0,TimeD6,0);
       ObjectSet("vLineD6",OBJPROP_WIDTH,1);
       ObjectSet("vLineD6",OBJPROP_COLOR,vLineD1Color);
       ObjectSet("vLineD6",OBJPROP_STYLE,2);
       ObjectSet("vLineD6",OBJPROP_BACK,true);
       
       ObjectCreate(NULL,"vLineD7",OBJ_VLINE,0,TimeD7,0);
       ObjectSet("vLineD7",OBJPROP_WIDTH,1);
       ObjectSet("vLineD7",OBJPROP_COLOR,vLineD1Color);
       ObjectSet("vLineD7",OBJPROP_STYLE,2);
       ObjectSet("vLineD7",OBJPROP_BACK,true);
       
       ObjectCreate(NULL,"vLineD8",OBJ_VLINE,0,TimeD8,0);
       ObjectSet("vLineD8",OBJPROP_WIDTH,1);
       ObjectSet("vLineD8",OBJPROP_COLOR,vLineD1Color);
       ObjectSet("vLineD8",OBJPROP_STYLE,2);
       ObjectSet("vLineD8",OBJPROP_BACK,true);
       
       ObjectCreate(NULL,"vLineD9",OBJ_VLINE,0,TimeD9,0);
       ObjectSet("vLineD9",OBJPROP_WIDTH,1);
       ObjectSet("vLineD9",OBJPROP_COLOR,vLineD1Color);
       ObjectSet("vLineD9",OBJPROP_STYLE,2);
       ObjectSet("vLineD9",OBJPROP_BACK,true);
       
       ObjectCreate(NULL,"vLineD10",OBJ_VLINE,0,TimeD10,0);
       ObjectSet("vLineD10",OBJPROP_WIDTH,1);
       ObjectSet("vLineD10",OBJPROP_COLOR,vLineD1Color);
       ObjectSet("vLineD10",OBJPROP_STYLE,2);
       ObjectSet("vLineD10",OBJPROP_BACK,true);
       }
//------------------- WEEK -------------------------     
     if(Period() <= 240)
       {   
       ObjectCreate(NULL,"vLineW0",OBJ_VLINE,0,TimeW0,0);
       ObjectSet("vLineW0",OBJPROP_WIDTH,1);
       ObjectSet("vLineW0",OBJPROP_COLOR,vLineW1Color);
       ObjectSet("vLineW0",OBJPROP_STYLE,2);
       ObjectSet("vLineW0",OBJPROP_BACK,true);
       
       ObjectCreate(NULL,"vLineW1",OBJ_VLINE,0,TimeW1,0);
       ObjectSet("vLineW1",OBJPROP_WIDTH,1);
       ObjectSet("vLineW1",OBJPROP_COLOR,vLineW1Color);
       ObjectSet("vLineW1",OBJPROP_STYLE,2);
       ObjectSet("vLineW1",OBJPROP_BACK,true);
       
       ObjectCreate(NULL,"vLineW2",OBJ_VLINE,0,TimeW2,0);
       ObjectSet("vLineW2",OBJPROP_WIDTH,1);
       ObjectSet("vLineW2",OBJPROP_COLOR,vLineW1Color);
       ObjectSet("vLineW2",OBJPROP_STYLE,2);
       ObjectSet("vLineW2",OBJPROP_BACK,true);
       
       ObjectCreate(NULL,"vLineW3",OBJ_VLINE,0,TimeW3,0);
       ObjectSet("vLineW3",OBJPROP_WIDTH,1);
       ObjectSet("vLineW3",OBJPROP_COLOR,vLineW1Color);
       ObjectSet("vLineW3",OBJPROP_STYLE,2);
       ObjectSet("vLineW3",OBJPROP_BACK,true);       
//------------------- MONTH -------------------------        
       ObjectCreate(NULL,"vLineMN0",OBJ_VLINE,0,TimeMN0,0);
       ObjectSet("vLineMN0",OBJPROP_WIDTH,1);
       ObjectSet("vLineMN0",OBJPROP_COLOR,vLineMNColor);
       ObjectSet("vLineMN0",OBJPROP_STYLE,2);
       ObjectSet("vLineMN0",OBJPROP_BACK,true); 
       
       ObjectCreate(NULL,"vLineMN1",OBJ_VLINE,0,TimeMN1,0);
       ObjectSet("vLineMN1",OBJPROP_WIDTH,1);
       ObjectSet("vLineMN1",OBJPROP_COLOR,vLineMNColor);
       ObjectSet("vLineMN1",OBJPROP_STYLE,2);
       ObjectSet("vLineMN1",OBJPROP_BACK,true);     
       }
      }
   else Print("vLines OFF");     
   return;}                      
//+++++++++++++++++ vLines ENDE ++++++++++++++++++++++++++  
   
/*
string pas(double styl,double with,color clr,double time1)
  {
   string n="vLines"+time1;
   ObjectCreate(n,OBJ_VLINE,0,0,0);
   ObjectSet(n,OBJPROP_WIDTH,with);
   ObjectSet(n,OBJPROP_COLOR,clr);
   ObjectSet(n,OBJPROP_STYLE,styl);
   ObjectSet(n,OBJPROP_TIME1,time1);
   ObjectSet(n,OBJPROP_BACK,true);
   return(n);
  }
  
//---------------- ANFANG Pivots ----------------
void PivotCreate()               
  { 
   if(AllPivots_OFF == false && Period() <= PERIOD_D1)                 
      {
     if(PivD0_ON == true && Period() <= PERIOD_H4)
       {
        ObjectCreate(NULL,"vLineD0",OBJ_VLINE,0,TimeD0,0);
        ObjectSet("vLineD0",OBJPROP_WIDTH,1);
        ObjectSet("vLineD0",OBJPROP_COLOR,vLineD1Color);
        ObjectSet("vLineD0",OBJPROP_STYLE,2);
        ObjectSet("vLineD0",OBJPROP_BACK,true);
       
       }
      }
   else Print("Pivots OFF");     
  return;}
//++++++++++++++++++ENDE Pivots ++++++++++++++++++++++++++     
*/