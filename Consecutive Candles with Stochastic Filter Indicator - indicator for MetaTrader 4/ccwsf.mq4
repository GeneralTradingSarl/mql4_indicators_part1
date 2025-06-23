//+------------------------------------------------------------------+
//|             Consecutive Candles with Stochastic Filter Indicator |
//|                                         Copyright 2017, tidyneat |
//|                                          http://www.tidyneat.com |
//+------------------------------------------------------------------+
/*The indicator should be able to identify consecutive high candles 
and consecutive low candles. The first candle must have a X pip long 
adjustable body for the first condition to be met, the candle must 
also be below or equal to the 20 stochastic level for consecutive high 
candles and above or equal to the 80 stochastic level for consecutive 
low candles. If the above conditions are met, then the indicator can 
look at candle 2. Candle 2 must also have a X pip long adjustable body 
for the condition to be met, however it is not dependent on the 
stochastic levels. Furthermore, Candle two should alert X number of 
seconds before the candle closes. Look at the attached image for an 
example. */

/* Change log
2-4-19 Added 50% line to indicator box
- Ignored changing the indicator lines indivisually since mql does not have a built in language convention to create this change would require too much additional research and effor.
Fixed and error with the DodgerBlue lines not showing, the problem was due to using DodgerBlue instead of clrDodgerBlue in the code to indicate a color, should be fixed now. 
*/
#property copyright "John Davis"
#property link      "https://www.mql5.com/en/users/johnthe"
#property version "3.00"
#property strict

#property description ""
#property description "Indicator commissioned by ndivho20."
#property description "It Identifies consecutive high and low candles."
#property description "The first candle must have a X pip long body."
#property description "The candle must appear when the stochastic is."
#property description "below or equal to 80 or 20. Then it looks at"
#property description "candle 2 which must also have an X pip long body"
#property description "An alert is set just after candle close "
//----
#property indicator_separate_window
#property indicator_buffers 8
#property indicator_minimum   0
#property indicator_maximum 100
#property indicator_color1 clrCornflowerBlue
#property indicator_style1 STYLE_DOT
#property indicator_color2 clrBlueViolet
#property indicator_color3 clrDodgerBlue
#property indicator_color4 clrRed
#property indicator_width3 2
#property indicator_width4 2
#property indicator_level1 80
#property indicator_level2 20
#property indicator_level3 50

//---- Enumerations
enum arrowType {No_Arrows,Trend_Trading,Range_Trading};
enum concan {two,three};
enum candleType {none,Bull,Bear};
//---- input parameters
extern arrowType arrow=Trend_Trading; // What type of trade arrows?
extern string Consecutive_Candles_Settings="========================================"; // Settings for Consecutive Candles Indicator
extern double minimumPipSizeCandle1=30; //Minimum pip size for candle one in points.
extern double minimumPipSizeCandle2 =30; //Minimum pip size for second candle in points.
extern double minimumPipSizeCandle3 =30; //Minimum pip size for third candle in points.
extern bool pushNotifications=false; //Turn on push notifications?
extern bool onScreenNotifications=true; //Turn on popup notifications?
extern bool emailNotifications=false; //Turn on email notifications?
extern concan candlesBeforeAlert=three;// Candles before alert.
input bool Verbose=true; // Turn details on or off in Expert Tab
extern string Stochastic_Settings="=====================================";
extern int       KPeriod=5;
extern int       Slowing   =3;
extern int       DPeriod   =3;
extern string note4="0=sma, 1=ema, 2=smma, 3=lwma";
extern int       MAMethod=0;
extern string note5="0=high/low, 1=close/close";
extern int       PriceField=1;
extern string note6="overbought level";
extern int       overBought=80;
extern string note7="oversold level";
extern int       overSold=20;
extern color indicatorLevelLineColor= clrMagenta;
extern int  indicatorLevelLineWidth = 1;
extern ENUM_LINE_STYLE  indicatorLevelLineStyle=STYLE_DASHDOT;

input color Buy_Color=clrGreen;
input color Sell_Color=clrRed;
int Cross_From_Below_Level = overSold;
int Cross_From_Above_Level = overBought;

//---- buffers
double KFull[];
double DFull[];
double Upper[];
double Lower[];
double Buy_Point[];
double Sell_Point[];
double UpArrow[];
double DownArrow[];
double pips;
candleType typeOfCandle=NULL;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {

// Determine what a pip point is.
   pips=Point; //.00001 or .0001. .001 .01.
   if(Digits==4 || Digits==2)
      pips=pips/10;
// Attach arrays to buffers
   SetIndexBuffer(0,DFull);
   SetIndexBuffer(1,KFull);
   SetIndexBuffer(2,Upper);
   SetIndexBuffer(3,Lower);
   SetIndexBuffer(4,Buy_Point);
   SetIndexBuffer(5,Sell_Point);
   SetIndexBuffer(6,UpArrow);
   SetIndexBuffer(7,DownArrow);

// Set Indicator draw type, size, and color
   SetIndexStyle(4,DRAW_ARROW,EMPTY,3,Buy_Color);
   SetIndexStyle(5,DRAW_ARROW,EMPTY,3,Sell_Color);
   SetIndexStyle(6,DRAW_ARROW,EMPTY,4,Buy_Color);
   SetIndexStyle(7,DRAW_ARROW,EMPTY,4,Sell_Color);

// Set which type of arrow from wingdings
   SetIndexArrow(4,159);
   SetIndexArrow(5,159);
   SetIndexArrow(6,221);
   SetIndexArrow(7,222);

// Label for arrows
   SetIndexLabel(6,"Up Arrow");
   SetIndexLabel(7,"Down Arrow");

// Set Levels in indicator window
   SetLevelStyle(indicatorLevelLineStyle,
                 indicatorLevelLineWidth,
                 indicatorLevelLineColor);
   SetLevelValue(0,overBought);
   SetLevelValue(1,overSold);
//----
   DPeriod=MathMax(DPeriod,1);
   if(DPeriod==1)
     {
      SetIndexStyle(0,DRAW_NONE);
      SetIndexLabel(0,NULL);
     }
   else
     {
      SetIndexStyle(0,DRAW_LINE);
      SetIndexLabel(0,"Slow");
     }
   string shortName="Stochastic X ("+(string)KPeriod+","+
                    (string)Slowing+","+(string)DPeriod+","+maDescription(MAMethod)+
                    ","+priceDescription(PriceField);
   if(overBought < overSold) overBought=overSold;
   if(overBought < 100)      shortName =shortName+","+(string)overBought;
   if(overSold   >   0)      shortName =shortName+","+(string)overSold;
   IndicatorShortName(shortName+")");
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
// Set checking once per bar logic
   static datetime candletime=0;
   if(candletime!=Time[0])
     {
      int    limit;
      int    i;
      //----   
      int counted_bars=IndicatorCounted();
      if(counted_bars < 0)  return(-1);
      if(counted_bars>0) counted_bars--;
      limit=Bars-counted_bars;
      if(counted_bars==0) limit-=1+MathMax(2,MathMax(KPeriod,DPeriod));
      for(i=limit; i>=0; i--)
        {
         KFull[i]=iStochastic(NULL,0,KPeriod,DPeriod,Slowing,MAMethod,PriceField,MODE_MAIN,i);
         DFull[i]=iStochastic(NULL,0,KPeriod,DPeriod,Slowing,MAMethod,PriceField,MODE_SIGNAL,i);
         if(KFull[i]>overBought) { Upper[i]=KFull[i]; Upper[i+1]=KFull[i+1]; }
         else
           {
            Upper[i]=EMPTY_VALUE;
            if(Upper[i+2]==EMPTY_VALUE)
               Upper[i+1]=EMPTY_VALUE;
           }
         if(KFull[i]<overSold) { Lower[i]=KFull[i]; Lower[i+1]=KFull[i+1]; }
         else
           {
            Lower[i]=EMPTY_VALUE;
            if(Lower[i+2]==EMPTY_VALUE)
               Lower[i+1]=EMPTY_VALUE;
           }

         //--- Stochastic Crossing Up Below 10 Signal

         if(KFull[i]<Cross_From_Below_Level && KFull[i]>DFull[i])

           {
            Buy_Point[i]=KFull[i];

           }
         //--- Stochastic Crossing Down Above 80 Signal 

         if(KFull[i]>Cross_From_Above_Level && KFull[i]<DFull[i])
           {
            Sell_Point[i]=KFull[i];
           }

         // Set values for alert message
         double stoch= NormalizeDouble(KFull[i+1],4);
         double price=NormalizeDouble(iOpen(NULL,PERIOD_CURRENT,0),Digits);
         string msg=Symbol()+" has consecutive "+EnumToString(typeOfCandle)+" candles at "+(string)price+" current stochastic of "+(string)stoch+".";

         if(CheckForConsecutiveCandles(i))
           {
            if(i==0)// if i is current send an alert
              {
               sendAlert(msg);
               if(Verbose)UpdateExpertsTab(i); // if verbose is on print out alert details
              }
            if(arrow!=No_Arrows)// if no arrows skip drawing arrows
              {
               if(typeOfCandle==Bull && arrow==Range_Trading)
                 {
                  //DownArrow[i+1]=iHigh(NULL,PERIOD_CURRENT,i+1)+Point*arrow_Spacing;
                  DownArrow[i+1]=60;
                 }
               else if(typeOfCandle==Bull && arrow==Trend_Trading)
                 {
                  //UpArrow[i+1]=iLow(NULL,PERIOD_CURRENT,i+1)-Point*arrow_Spacing;
                  UpArrow[i+1]=40;
                 }
               else if(typeOfCandle==Bear && arrow==Range_Trading)
                 {
                  //UpArrow[i+1]=iLow(NULL,PERIOD_CURRENT,i+1)-Point*arrow_Spacing;
                  UpArrow[i+1]=40;
                 }
               else if(typeOfCandle==Bear && arrow==Trend_Trading)
                 {
                  //DownArrow[i+1]=iHigh(NULL,PERIOD_CURRENT,i+1)+Point*arrow_Spacing;
                  DownArrow[i+1]=60;
                 }
              }

           }
        }
      candletime=Time[0];
     }

//----
   Comment(WindowExpertName()+" "+EnumToString(arrow)+" mode");
//Print(WindowExpertName()+" "+EnumToString(arrow)+" mode");
   return(0);
  }
//+------------------------------------------------------------------+
//| Check if candle one conditions are met                           |
//| Int,Int -> Boolean
//+------------------------------------------------------------------+
bool CandleCheck(double minPipSize,double stoch,int shift,int candleNumber)
  {
   double candleSize=iClose(NULL,PERIOD_CURRENT,shift)-iOpen(NULL,PERIOD_CURRENT,shift);
// On candle one check stoch level
   if(candleNumber==1)// We check the stochastic on first candles only
     {
      if(stoch<=overSold && candleSize>=minPipSize)//overSold=20
        {
         typeOfCandle=Bull;
         return true;
        }
      else if(stoch>=overBought && candleSize<=-minPipSize)//overBought=80
        {
         typeOfCandle=Bear;
         return true;
        }
     }
   else
// Check if candle beyond 1 are meet pip requirements.
   if(candleSize>minPipSize && typeOfCandle==Bull)
     {
      return true;
     }
   else if(candleSize<=-minPipSize && typeOfCandle==Bear)
     {
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//| Send Details to Experts Tab function                             |
//+------------------------------------------------------------------+
void UpdateExpertsTab(int i)
  {
   double candleSize1=NormalizeDouble((iClose(NULL,PERIOD_CURRENT,i+1)-iOpen(NULL,PERIOD_CURRENT,i+1))/pips,2);
   double candleSize2=NormalizeDouble((iClose(NULL,PERIOD_CURRENT,i+2)-iOpen(NULL,PERIOD_CURRENT,i+2))/pips,2);
   double candleSize3=NormalizeDouble((iClose(NULL,PERIOD_CURRENT,i+3)-iOpen(NULL,PERIOD_CURRENT,i+3))/pips,2);
   double stochastic1=NormalizeDouble(KFull[i+1],2);
   double stochastic2=NormalizeDouble(KFull[i+2],2);
   double stochastic3=NormalizeDouble(KFull[i+3],2);

   if(candlesBeforeAlert==two)
     {
      if(Verbose) Print(TimeToString(Time[i]),"  2 Candle 2 size is ",candleSize1," stochastic is ",stochastic1);
      if(Verbose) Print(TimeToString(Time[i]),"  1  Candle 1 size is ",candleSize2," stochastic is ",stochastic2);
      if(Verbose)Print("***************************************************************");

     }
   else if(candlesBeforeAlert==three)
     {
      if(Verbose) Print(TimeToString(Time[i]),"  3 Candle 3 size is ",candleSize1," stochastic is ",stochastic1);
      if(Verbose)Print(TimeToString(Time[i]),"  2 Candle 2 size is ",candleSize2," stochastic is ",stochastic2);
      if(Verbose) Print(TimeToString(Time[i]),"  1 Candle 1 size is ",candleSize3," stochastic is ",stochastic3);
      if(Verbose)Print("***************************************************************");

     }
  }
//+------------------------------------------------------------------+
//| Checking for consecutive candles                                 |
//| Int -> bool                                                      |
//+------------------------------------------------------------------+
bool CheckForConsecutiveCandles(int i)
  {
// Checking of Candles
   bool CandleOneCheck=false;
   bool CandleTwoCheck=false;
   bool CandleThreeCheck=false;
   if(candlesBeforeAlert==two)
     {
      CandleOneCheck=CandleCheck(minimumPipSizeCandle1*pips,KFull[i+3],i+2,1);
      CandleTwoCheck=CandleCheck(minimumPipSizeCandle2*pips,KFull[i+1],i+1,2);
      if(CandleOneCheck && CandleTwoCheck)
        {
         return true;
        }
     }
   else if(candlesBeforeAlert==three)
     {
      CandleOneCheck=CandleCheck(minimumPipSizeCandle1*pips,KFull[i+3],i+3,1);
      CandleTwoCheck=CandleCheck(minimumPipSizeCandle2*pips,KFull[i+2],i+2,2);
      CandleThreeCheck=CandleCheck(minimumPipSizeCandle3*pips,KFull[i+1],i+1,3);
      if(CandleOneCheck && CandleTwoCheck && CandleThreeCheck)
        {
         return true;
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
//| Alerts                                                           |
//+------------------------------------------------------------------+
void sendAlert(string message)
  {
   if(onScreenNotifications)
      Alert(message);

   if(pushNotifications)
      SendNotification(message);

   if(emailNotifications)
      SendMail("Alert from Consecutive Candle Indicator",message+" /n/n Thank you from John Davis/n https://www.mql5.com/en/users/johnthe");
  }
//+------------------------------------------------------------------+
string priceDescription(int mode)
  {
   string answer;
   switch(mode)
     {
      case 0:  answer="Low/High";break;
      case 1:  answer="Close/Close";break;
      default: answer="Invalid price field requested";
      Alert(answer);
     }
   return(answer);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string maDescription(int mode)
  {
   string answer;
   switch(mode)
     {
      case MODE_SMA:  answer="SMA";break;
      case MODE_EMA:  answer="EMA";break;
      case MODE_SMMA: answer="SMMA";break;
      case MODE_LWMA: answer="LWMA";break;
      default:        answer="Invalid MA mode requested";
      Alert(answer);
     }
   return(answer);
  }
//+------------------------------------------------------------------+
