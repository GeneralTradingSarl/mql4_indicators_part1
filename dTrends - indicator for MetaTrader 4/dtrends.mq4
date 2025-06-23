//+------------------------------------------------------------------+
//|                                                      dTrends.mq4 |
//|                           Copyright 2019, Roberto Jacobs (3rjfx) |
//|                              https://www.mql5.com/en/users/3rjfx |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Roberto Jacobs (3rjfx) ~ By 3rjfx ~ Created: 2019/07/30"
#property link      "https://www.mql5.com/en/users/3rjfx"
#property version   "1.00"
/* Update_01: 2019/07/31 ~ Added distance in input property from zero in pips.*/
#property strict
#property indicator_chart_window
//--
//--- indicator settings
#property indicator_buffers 4
#property indicator_type1   DRAW_NONE
#property indicator_type2   DRAW_NONE
#property indicator_type3   DRAW_ARROW
#property indicator_type4   DRAW_ARROW
#property indicator_width3  1
#property indicator_width4  1
#property indicator_color3  clrAqua
#property indicator_color4  clrOrangeRed
#property indicator_style3  STYLE_SOLID 
#property indicator_style4  STYLE_SOLID 
#property indicator_label2  "dTrends"
#property indicator_label3  "Rise"
#property indicator_label4  "Down"
//---
enum YN
 {
   No,
   Yes
 };
//--
//---- input parameters
input ENUM_APPLIED_PRICE      Trend_price = PRICE_CLOSE;  // Select Applied Price
input int                      ema_period = 13;           // EMA Period
input double                         dist = 2.3;          // Distance from Zero in pips 
input YN                           alerts = Yes;          // Display Alerts / Messages (Yes) or (No)
input YN                       EmailAlert = No;           // Email Alert (Yes) or (No)
input YN                       sendnotify = No;           // Send Notification (Yes) or (No)
input YN                      displayinfo = Yes;          // Display Trade Info
//--
//---- buffers
double value1[];
double value2[];
double Rise[];
double Down[];
double Bears[];
double Bulls[];
double Temp[];
//--
int cur,prv;
int cmnt,pmnt;
string posisi,
       sigpos,
       iname,
       msgText;
//--
double pip;
double devi;
//--
#define minBars 99
//---------//
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   //--
   SetIndexBuffer(0,value1);
   SetIndexBuffer(1,value2);
   SetIndexBuffer(2,Rise);
   SetIndexBuffer(3,Down);
   //--
//---- drawing settings
   SetIndexStyle(2,DRAW_ARROW,STYLE_SOLID);
   SetIndexArrow(2,172);
   SetIndexStyle(3,DRAW_ARROW,STYLE_SOLID);
   SetIndexArrow(3,172);
   //--
   iname="dTrends";
   IndicatorSetString(INDICATOR_SHORTNAME,iname);
   IndicatorSetInteger(INDICATOR_DIGITS,Digits());
   //--
   if(Digits()==3||Digits()==5) 
     pip=Point()*10;
   else if(Digits()==2||Digits()==4) pip=Point();
   if((StringSubstr(Symbol(),0,1)=="X")||(StringSubstr(Symbol(),0,1)=="#")) pip=Point()*10;
   devi=NormalizeDouble(dist*pip,Digits());
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
   ObjectsDeleteAll(ChartID(),0,-1);
//----
   return;
  }
//-----//
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
//--- check for bars count
   if(rates_total<minBars)
      return(0); // not enough bars for calculation
   //-- 
   int limit;
   //--
//--- first calculation or number of bars was changed
   limit=rates_total-prev_calculated;
   if(prev_calculated>0) limit++;
   if(prev_calculated<minBars)
      limit=2;
   else limit=prev_calculated-1;
   //--
   ArrayResize(value1,limit);
   ArrayResize(value2,limit);
   ArrayResize(Rise,limit);
   ArrayResize(Down,limit);
   ArrayResize(Bears,limit);
   ArrayResize(Bulls,limit);
   ArrayResize(Temp,limit); 
   //--
   ArraySetAsSeries(value1,true);
   ArraySetAsSeries(value2,true);
   ArraySetAsSeries(Rise,true);
   ArraySetAsSeries(Down,true);
   ArraySetAsSeries(open,true);
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);
   ArraySetAsSeries(close,true);
   ArraySetAsSeries(time,true);
   ArraySetAsSeries(Bears,true);
   ArraySetAsSeries(Bulls,true);
   ArraySetAsSeries(Temp,true);
   //--
//--- the main loop of calculations
   for(int i=limit-1; i>=0; i--)
     {
      Temp[i]=iMA(Symbol(),0,ema_period,0,MODE_EMA,Trend_price,i);
      Bears[i]=low[i]-Temp[i];
      Bulls[i]=high[i]-Temp[i];
     }
   //---
   for(int i=limit-2; i>=0; i--)
     {
       value1[i] = - (Bears[i] + Bulls[i]); 
       if((value1[i+1]>=0) && (value1[i]<-devi)) {Rise[i]=low[i]; Down[i]=EMPTY_VALUE; cur=1;}
       else
       if((value1[i+1]<=0) && (value1[i]>devi)) {Down[i]=high[i]; Rise[i]=EMPTY_VALUE; cur=-1;}
       else {Rise[i]=EMPTY_VALUE; Down[i]=EMPTY_VALUE;}
       if(value1[i]<0) value2[i]=1.0; 
       else
       if(value1[i]>0) value2[i]=-1.0;
     }
   //---
   if(alerts==Yes||EmailAlert==Yes||sendnotify==Yes) Do_Alerts(cur);
   if(displayinfo==Yes) ChartComm();
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

void Do_Alerts(int fcur)
  {
//---
    cmnt=Minute();
    if(cmnt!=pmnt)
      {
        //--
        if(fcur==1)
          {
            msgText=iname+" Start to Up";
            posisi="Bullish"; 
            sigpos="Open BUY Order";
          }
        else
        if(fcur==-1)
          {
            msgText=iname+" Start to Down";
            posisi="Bearish"; 
            sigpos="Open SELL Order";
          }
        else
          {
            msgText=iname+" Trend Not Found!";
            posisi="Not Found!"; 
            sigpos="Wait for Confirmation!";
          }
        //--
        if(fcur!=prv)
          {
            Print(iname,"--- "+Symbol()+" "+TF2Str(Period())+": "+msgText+
                  "\n--- at: ",TimeToString(iTime(Symbol(),0,0),TIME_DATE|TIME_MINUTES)+" - "+sigpos);
            //--
            if(alerts==Yes)
              Alert(iname,"--- "+Symbol()+" "+TF2Str(Period())+": "+msgText+
                    "--- at: ",TimeToString(iTime(Symbol(),0,0),TIME_DATE|TIME_MINUTES)+" - "+sigpos);
            //--
            if(EmailAlert==Yes) 
              SendMail(iname,"--- "+Symbol()+" "+TF2Str(Period())+": "+msgText+
                               "\n--- at: "+TimeToString(iTime(Symbol(),0,0),TIME_DATE|TIME_MINUTES)+" - "+sigpos);
            //--
            if(sendnotify==Yes) 
              SendNotification(iname+"--- "+Symbol()+" "+TF2Str(Period())+": "+msgText+
                               "\n--- at: "+TimeToString(iTime(Symbol(),0,0),TIME_DATE|TIME_MINUTES)+" - "+sigpos);                
            //--
            prv=fcur;
          }
        //--
        pmnt=cmnt;
      }
    //--
    return;
    //--
//---
  } //-end Do_Alerts()
//---------//

string TF2Str(int period)
  {
   switch(period)
     {
       //--
       case PERIOD_M1:   return("M1");
       case PERIOD_M5:  return("M5");
       case PERIOD_M15: return("M15");
       case PERIOD_M30: return("M30");
       case PERIOD_H1:  return("H1");
       case PERIOD_H4:  return("H4");
       case PERIOD_D1:  return("D1");
       case PERIOD_W1:  return("W1");
       case PERIOD_MN1: return("MN");
       //--
     }
   return(string(period));
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
      "\n      :: Broker             :  ",TerminalCompany(), 
      "\n      :: Acc. Name       :  ",AccountName(), 
      "\n      :: Acc, Number    :  ",(string)AccountNumber(),
      "\n      :: Acc,TradeMode :  ",AccountMode(),
      "\n      :: Acc. Leverage   :  1 : ",(string)AccountLeverage(), 
      "\n      :: Acc. Balance     :  ",DoubleToString(AccountBalance(),2),
      "\n      :: Acc. Equity       :  ",DoubleToString(AccountEquity(),2), 
      "\n      --------------------------------------------",
      "\n      :: Indicator Name  :  ",iname,
      "\n      :: Currency Pair    :  ",Symbol(),
      "\n      :: Current Spread  :  ",IntegerToString(SymbolInfoInteger(Symbol(),SYMBOL_SPREAD),0),
      "\n      :: Indicator Signal :  ",posisi,
      "\n      :: Suggested        :  ",sigpos);
   //---
   ChartRedraw();
   return;
//----
  } //-end ChartComm()  
//---------//
//+------------------------------------------------------------------+