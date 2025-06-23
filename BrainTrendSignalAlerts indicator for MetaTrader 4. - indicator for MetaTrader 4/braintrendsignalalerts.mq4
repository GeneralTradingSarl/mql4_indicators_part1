//+------------------------------------------------------------------+
//|                                       BrainTrendSignalAlerts.mq4 |
//|                                Copyright 2019, www.forex-tsd.com |
//|                              https://www.mql5.com/en/users/3rjfx |
//+------------------------------------------------------------------+
#property copyright   "BrainTrading Inc."
#property link        "https://www.forex-tsd.com"
#property link        "https://www.mql5.com/en/users/3rjfx"
#property description "BrainTrendSignalAlerts indicator for MetaTrader 4."
#property description "Software is the modifying indicator base on BrainTrend2SigALERTS by BrainTrading Inc."
#property description "Modifying and update by 3rjfx ~ 2019.01.15. ~ update_1 : 2019.01.15."
#property strict
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 clrBlue
#property indicator_color2 clrRed
//---
enum YN
 {
   No,
   Yes
 };
//--
//---- input parameters ---//
input int     NumBars = 360;    // Bars Calculation
input YN       alerts = Yes;    // Display Alerts / Messages (Yes) or (No)
input YN   EmailAlert = No;     // Email Alert (Yes) or (No)
input YN  displayinfo = Yes;    // Display Trade Info
//--
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
//---
double 
   pricepos,
   sprd;
static int fbar;
int cbars;
int xa,xb;
int cur,prv;
int cmnt,pmnt;
string 
   posisi,
   sigpos,
   msgText;
string frtext;
string iname;
datetime 
   fbartime,
   pbartime,
   cbartime;     
//-------//
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexArrow(0,233);
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexDrawBegin(0,0);
   SetIndexEmptyValue(0,0.0);
   //--
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexArrow(1,234);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexDrawBegin(1,0);
   SetIndexEmptyValue(1,0.0);
   //-- name for DataWindow
   SetIndexLabel(0,"Price Up");
   SetIndexLabel(1,"Price Down");
   //--
   iname=WindowExpertName();
   IndicatorShortName(iname);
   IndicatorDigits(_Digits);
   //--
   cbars=NumBars;
   if(NumBars<=360) cbars=360;
   sprd=MarketInfo(_Symbol,MODE_SPREAD)*_Point;
//---
   return(INIT_SUCCEEDED);
  }
//---------//
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//----
    Comment("");
    ObjectsDeleteAll();
    GlobalVariablesDeleteAll();
    //--
//----
   return;
  }
//---------//
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
   ResetLastError();
   RefreshRates();
   cur=0;
   int counted_bars=rates_total;
   if(prev_calculated==0)
      counted_bars=cbars;
   if(prev_calculated>0) counted_bars++;
   int satb = fmin(counted_bars,cbars);
   //--
   ArrayResize(ExtMapBuffer1,satb);
   ArrayResize(ExtMapBuffer2,satb);
   ArraySetAsSeries(ExtMapBuffer1,true);
   ArraySetAsSeries(ExtMapBuffer2,true);
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);
   ArraySetAsSeries(close,true);
   ArraySetAsSeries(time,true);
	//--
	int       artp=7;
	int       Shift=0;	
	int       glava=0;	
	int       J=0;	
	int       p=0;
	int       Curr=0;
	//--
	double    dartp=7.0;
	double    cecf=0.7;
	bool      river=True;
	double    Emaxtra=0;
	double    widcha=0;
	double    TR=0;
	double    Values[100];
	double    ATR=0;
	double    Weight=0;
	double    r1=0;
	double    Range1=0;
	double    s=2;
	double    val1=0;
	double    val2=0;
   //---
   if(close[satb - 2] > close[satb - 1]) river = true; else river = false;
   Emaxtra = close[satb - 2];
   Shift=satb-3;
   while(Shift>=0)
     {
      TR = sprd + high[Shift] - low[Shift];
      if(fabs(sprd + high[Shift] - close[Shift+1]) > TR ) TR = fabs(sprd + high[Shift] - close[Shift+1]);
      if(fabs(low[Shift] - close[Shift+1]) > TR)  TR = fabs(low[Shift] - close[Shift+1]);
      if(Shift == satb-3) 
        {
          for(J=0; Shift<=artp-1; J++) Values[J] = TR; 
        } 
      //--
 		Values[glava] = TR;
      ATR = 0;
      Weight = artp;
      Curr = glava;
      for(J=0; J<=artp-1; J++) 
        {
          ATR += Values[Curr] * Weight;
          Weight -= 1.0;
          Curr--;
          if (Curr == -1) Curr = artp - 1;
        }
      ATR = 2.0 * ATR / (dartp * (dartp + 1.0));
      glava++;
      if (glava == artp) glava = 0;
      widcha = cecf * ATR;
      if(river && low[Shift] < Emaxtra - widcha) 
        {
          river = False;
          Emaxtra = sprd + high[Shift];
        }
      if(!river && sprd + high[Shift] > Emaxtra + widcha) 
        {
          river = True;
          Emaxtra = low[Shift];
        }
      if(river && low[Shift] > Emaxtra) 
        {
          Emaxtra = low[Shift];
        }
      if(!river && sprd + high[Shift] < Emaxtra ) 
        {
          Emaxtra = sprd + high[Shift];
        }
      //--
      Range1 = iATR(_Symbol,0,10,Shift);
      val1 = 0;
      val2 = 0;
      if(river) 
        {
          if(p != 1) r1 = low[Shift] - Range1 * s / 3.0 - sprd;
          if(p == 1) r1 = -1.0;
          if(r1 > 0) 
            {
              val1 = r1;
              val2 = 0;
            } 
          else 
            {
              val1 = 0;
              val2 = 0;
            }
          ExtMapBuffer1[Shift]=val1;
          p = 1;
        } 
      else 
        {
          if(p != 2) r1 = sprd + high[Shift] + Range1 * s / 3.0;
          if(p == 2) r1 = -1.0;
          if(r1 > 0) 
            {
              val1 = 0;
              val2 = r1;
            } 
          else 
            {
              val1 = 0;
              val2 = 0;
            }
          ExtMapBuffer2[Shift]=val2;
          p = 2;
        }
      Shift--;
     }
   //---
   for(int x=satb-3; x>=0; x--)
     {
       if(ExtMapBuffer1[x]>0.0) {xa=x; pbartime=time[x]; posisi="Bullish"; sigpos="Open BUY Order !"; frtext="Above "; pricepos=ExtMapBuffer1[x];}
       if(ExtMapBuffer2[x]>0.0) {xb=x; pbartime=time[x]; posisi="Bearish"; sigpos="Open SELL Order !"; frtext="Below "; pricepos=ExtMapBuffer2[x];}
     }
   //--
   if(xa<xb && xa==0)
     {
       cbartime=time[xa];
       fbar=iBarShift(_Symbol,0,cbartime,false);
       pricepos=ExtMapBuffer1[xa];
       cur=1;
     }
   if(xb<xa && xb==0)
     {
       cbartime=time[xb];
       fbar=iBarShift(_Symbol,0,cbartime,false);
       pricepos=ExtMapBuffer2[xb];
       cur=-1;
     }
   //--
   if((alerts==Yes||EmailAlert==Yes)&&(cur!=0)) Do_Alerts(cur,fbar);
   if(displayinfo==Yes) ChartComm();
   //---
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//---------//

string AccountMode() // function: to known account trade mode
   {
//----
//--- Demo, Contest or Real account 
   ENUM_ACCOUNT_TRADE_MODE account_type=(ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE);
 //---
   string trade_mode;
   //--
   switch(account_type) 
     { 
      case  ACCOUNT_TRADE_MODE_DEMO: 
         trade_mode="Demo"; 
         break; 
      case  ACCOUNT_TRADE_MODE_CONTEST: 
         trade_mode="Contest"; 
         break; 
      default: 
         trade_mode="Real"; 
         break; 
     }
   //--
   return(trade_mode);
//----
   } //-end AccountMode()
//---------//

void ChartComm() // function: write comments on the chart
  {
//----
   //--
   Comment("\n     :: Server Date Time : ",(string)Year(),".",(string)Month(),".",(string)Day(), "   ",TimeToString(TimeCurrent(),TIME_SECONDS), 
      "\n     ------------------------------------------------------------", 
      "\n      :: Broker             :  ", TerminalCompany(), 
      "\n      :: Acc. Name       :  ", AccountName(), 
      "\n      :: Acc, Number    :  ", (string)AccountNumber(),
      "\n      :: Acc,TradeMode :  ", AccountMode(),
      "\n      :: Acc. Leverage   :  1 : ", (string)AccountLeverage(), 
      "\n      :: Acc. Balance     :  ", DoubleToString(AccountBalance(),2),
      "\n      :: Acc. Equity       :  ", DoubleToString(AccountEquity(),2), 
      "\n     --------------------------------------------", 
      "\n      :: Indicator Name  :  ",iname,
      "\n      :: Currency Pair    :  ",_Symbol,
      "\n      :: Current Spread  :  ",IntegerToString(SymbolInfoInteger(_Symbol,SYMBOL_SPREAD),0),
      "\n      :: Signal Start       : at bar ",string(iBarShift(_Symbol,0,pbartime,false)),
      "\n      :: Price Start        :  "+frtext+DoubleToString(pricepos,_Digits), 
      "\n      :: Indicator Signal :  ",posisi,
      "\n      :: Suggested        :  ",sigpos);
   //---
   ChartRedraw();
   return;
//----
  } //-end ChartComm()  
//---------//

void Do_Alerts(int fcur,int fb)
  {
    //--
    cmnt=Minute();
    if(cmnt!=pmnt)
      {
        //--
        if(fcur==1)
          {
            msgText="Arrow up Found"+" at bars: "+string(fb);
            posisi="Bullish"; 
            sigpos="Open BUY Order !";
            fbartime=iTime(_Symbol,0,fb);
          }
        if(fcur==-1)
          {
            msgText="Arrow down Found"+" at bars: "+string(fb);
            posisi="Bearish"; 
            sigpos="Open SELL Order !";
            fbartime=iTime(_Symbol,0,fb);
          }
        //--
        if(fcur!=prv) // || fbartime>pbartime)
          {
            Print(iname,"--- "+_Symbol+" "+TF2Str(_Period)+": "+msgText+
                  "\n--- at: ",TimeToString(iTime(_Symbol,0,0),TIME_DATE|TIME_MINUTES)+" - "+sigpos);
            //--
            if(alerts==Yes)
              Alert(iname,"--- "+_Symbol+" "+TF2Str(_Period)+": "+msgText+
                    "--- at: ",TimeToString(iTime(_Symbol,0,0),TIME_DATE|TIME_MINUTES)+" - "+sigpos);
            //--
            if(EmailAlert==Yes) 
              SendMail(iname,"--- "+_Symbol+" "+TF2Str(_Period)+": "+msgText+
                               "\n--- at: "+TimeToString(iTime(_Symbol,0,0),TIME_DATE|TIME_MINUTES)+" - "+sigpos);
            //--
            prv=fcur;
            pbartime=fbartime;
          }
        //--
        pmnt=cmnt;
      }
    //--
    return;
    //---
  }
//---------//

string TF2Str(int period)
  {
   switch(period)
     {
       //--
       case PERIOD_M1: return("M1");
       case PERIOD_M5: return("M5");
       case PERIOD_M15: return("M15");
       case PERIOD_M30: return("M30");
       case PERIOD_H1: return("H1");
       case PERIOD_H4: return("H4");
       case PERIOD_D1: return("D1");
       case PERIOD_W1: return("W1");
       case PERIOD_MN1: return("MN");
       //--
     }
   return(string(period));
  }  
//---------//
//+------------------------------------------------------------------+