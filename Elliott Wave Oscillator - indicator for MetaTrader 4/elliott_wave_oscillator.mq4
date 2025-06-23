//+------------------------------------------------------------------+
//|                                      Elliott Wave Oscillator.mq4 |
//|                               Copyright 2016-2021, Hossein Nouri |
//|                           https://www.mql5.com/en/users/hsnnouri |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016-2021, Hossein Nouri"
#property description "Fully Coded By Hossein Nouri"
#property description "Email : hsn.nouri@gmail.com"
#property description "Skype : hsn.nouri"
#property description "Telegram : @hypernova1990"
#property description "Website : http://www.metatraderprogrammer.ir"
#property description "MQL5 Profile : https://www.mql5.com/en/users/hsnnouri"
#property description " "
#property description "Feel free to contact me for MQL4/MQL5/Pine coding."
#property link      "https://www.mql5.com/en/users/hsnnouri"
#property version   "1.20"
#property strict
#property indicator_separate_window
#property indicator_buffers 6
#property indicator_plots   6

//--- v1.20
// Alerts added



//--- plot UpperGrowing
#property indicator_label2  "Upper Growing"
#property indicator_type2   DRAW_HISTOGRAM
#property indicator_color2  clrLime
#property indicator_style2  STYLE_SOLID
#property indicator_width2  2
//--- plot UpperFalling
#property indicator_label3  "Upper Falling"
#property indicator_type3   DRAW_HISTOGRAM
#property indicator_color3  clrGreen
#property indicator_style3  STYLE_SOLID
#property indicator_width3  2
//--- plot LowerGrowing
#property indicator_label4  "Lower Growing"
#property indicator_type4   DRAW_HISTOGRAM
#property indicator_color4  clrMaroon
#property indicator_style4  STYLE_SOLID
#property indicator_width4  2
//--- plot LowerFalling
#property indicator_label5  "Lower Falling"
#property indicator_type5   DRAW_HISTOGRAM
#property indicator_color5  clrRed
#property indicator_style5  STYLE_SOLID
#property indicator_width5  2
//--- moving average
#property indicator_label6  "MA"
#property indicator_type6   DRAW_LINE
#property indicator_color6  clrDodgerBlue
#property indicator_style6  STYLE_DOT
#property indicator_width6  1



#property  indicator_level1     0.0
#property  indicator_levelcolor clrSilver
#property  indicator_levelstyle STYLE_DOT

//--- input parameters
input string               DescEWO                    = "========== EWO ==========";                  // Description
input int                  InpFastMA                  = 5;                                            // Fast Period
input int                  InpSlowMA                  = 35;                                           // Slow Period
input ENUM_APPLIED_PRICE   InpPriceSource             = PRICE_MEDIAN;                                 // Apply to
input ENUM_MA_METHOD       InpSmoothingMethod         = MODE_SMA;                                     // Method
input string               DescMA                     = "=========== MA ===========";                 // Description
input bool                 InpShowMA                  = true;                                         // Show MA
input int                  InpMaPeriod                = 5;                                            // Period
input ENUM_MA_METHOD       InpMaMethod                = MODE_SMA;                                     // Method
input string               DescAlertEvents            = "======= Alert Events =======";               // Description
input bool                 InpAlertOnZeroLineCross    = false;                                        // Zero Line Cross
input bool                 InpAlertOnFallingGrowing   = false;                                        // Falling/Growing
input bool                 InpAlertOnMACross          = false;                                        // MA Cross
input string               DescAlertSettings          = "======= Alert Settings =======";             // Description
input bool                 InpAlertShowPopup          = true;                                         // Show Pop-up
input bool                 InpAlertSendEmail          = false;                                        // Send Email
input bool                 InpAlertSendNotification   = false;                                        // Send Notification
input bool                 InpAlertPlaySound          = false;                                        // Play Sound
input string               InpAlertSoundFile          = "alert.wav";                                  // Sound File

//--- indicator buffers
double         UpperGrowingBuffer[];
double         UpperFallingBuffer[];
double         LowerGrowingBuffer[];
double         LowerFallingBuffer[];
double         MABuffer[];
double         EWO[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   string ShortName;
   int Begin = MathMax(InpFastMA,InpSlowMA);
   ShortName="EWO("+(string)InpFastMA+","+(string)InpSlowMA+")";
//--- indicator buffers mapping
   IndicatorBuffers(6);

   SetIndexStyle(0,DRAW_NONE,STYLE_SOLID,1,clrNONE);
   SetIndexBuffer(0,EWO);
   SetIndexBuffer(1,UpperGrowingBuffer);
   SetIndexBuffer(2,UpperFallingBuffer);
   SetIndexBuffer(3,LowerGrowingBuffer);
   SetIndexBuffer(4,LowerFallingBuffer);
   SetIndexBuffer(5,MABuffer);
   SetIndexDrawBegin(1,Begin);
   SetIndexDrawBegin(2,Begin);
   SetIndexDrawBegin(3,Begin);
   SetIndexDrawBegin(4,Begin);
   SetIndexDrawBegin(5,Begin+InpMaPeriod);
   IndicatorDigits(6);
   IndicatorShortName(ShortName);


//---
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
//---
   if(rates_total < MathMax(InpSlowMA,InpFastMA)+InpMaPeriod)    return(0);
   int limit;
   if(prev_calculated==0)
      limit=rates_total-MathMax(InpFastMA,InpSlowMA);
   else limit=rates_total-prev_calculated+1;


   for(int i=0; i<limit; i++)
   {
      calculateValue(i);
   }
   if(InpShowMA==true)
   {
      for(int i=0; i<limit; i++)
      {
         MABuffer[i]= iMAOnArray(EWO,0,InpMaPeriod,0, InpMaMethod,i);
      }
   }
   if(IsNewBar())
   {
      if(InpAlertOnZeroLineCross)
      {
         if(EWO[2]<=0 && EWO[1]>0)
         {
            TriggerAlert("EWO crossed above zero line.");
         }
         else if(EWO[2]>=0 && EWO[1]<0)
         {
            TriggerAlert("EWO crossed below zero line.");
         }
      }

      if(InpAlertOnFallingGrowing)
      {
         if(EWO[1] > EWO[2] && (EWO[2] < EWO[3] || (EWO[2] == EWO[3] && EWO[3]<EWO[4])))
         {
            TriggerAlert("EWO started growing.");
         }
         else if(EWO[1] < EWO[2] && (EWO[2] > EWO[3] || (EWO[2] == EWO[3] && EWO[3]>EWO[4])))
         {
            TriggerAlert("EWO started falling.");
         }
      }
      if(InpAlertOnMACross)
      {
         if(EWO[2]<=MABuffer[2] && EWO[1]>MABuffer[1])
         {
            TriggerAlert("EWO crossed above MA line.");
         }
         else if(EWO[2]>=MABuffer[2] && EWO[1]<MABuffer[1])
         {
            TriggerAlert("EWO crossed below MA line.");
         }
      }
   }
//--- return value of prev_calculated for next call
   return(rates_total);
}
//+------------------------------------------------------------------+
void calculateValue(int index)
{
   double value=FastMA(index)-SlowMA(index);
   double valuePrev=FastMA(index+1)-SlowMA(index+1);
   EWO[index]=value;
   if(value>0)
   {
      LowerGrowingBuffer[index]=EMPTY_VALUE;
      LowerFallingBuffer[index]=EMPTY_VALUE;
      if(value>=valuePrev)
      {
         UpperGrowingBuffer[index]=value;
         UpperFallingBuffer[index]=EMPTY_VALUE;
         return;
      }
      if(value<=valuePrev)
      {
         UpperFallingBuffer[index]=value;
         UpperGrowingBuffer[index]=EMPTY_VALUE;
         return;
      }
   }
   if(value<0)
   {
      UpperGrowingBuffer[index]=EMPTY_VALUE;
      UpperFallingBuffer[index]=EMPTY_VALUE;
      if(value>=valuePrev)
      {
         LowerGrowingBuffer[index]=value;
         LowerFallingBuffer[index]=EMPTY_VALUE;
         return;
      }
      if(value<=valuePrev)
      {
         LowerFallingBuffer[index]=value;
         LowerGrowingBuffer[index]=EMPTY_VALUE;
         return;
      }
   }

}
//+------------------------------------------------------------------+
double FastMA(int _index)
{
   return iMA(Symbol(), PERIOD_CURRENT,InpFastMA,0,InpSmoothingMethod,InpPriceSource,_index);
}
//+------------------------------------------------------------------+
double SlowMA(int _index)
{
   return iMA(Symbol(), PERIOD_CURRENT,InpSlowMA,0,InpSmoothingMethod,InpPriceSource,_index);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsNewBar()
{
   RefreshRates();
   static int CountedBars=Bars;
   static double PrevClose=Close[1];
   static datetime PrevTime=Time[1];
   if(Bars!=CountedBars || Close[1]!=PrevClose || PrevTime!=Time[1])
   {
      CountedBars = Bars;
      PrevClose=Close[1];
      PrevTime=Time[1];
      return true;
   }
   return false;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string GetTFName()
{
   if(_Period==1)  return "M1";
   if(_Period==5)  return "M5";
   if(_Period==15)  return "M15";
   if(_Period==30)  return "M30";
   if(_Period==60)  return "H1";
   if(_Period==240)  return "H4";
   if(_Period==1440)  return "D1";
   if(_Period==10080)  return "W1";
   if(_Period==43200)  return "MN1";
   return "";
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TriggerAlert(string _OP)
{
   string message = StringConcatenate(_Symbol,"(",GetTFName(),") ",_OP);
   if(InpAlertShowPopup) Alert(message);
   if(InpAlertSendEmail)
   {
      if(!SendMail("Elliott Wave Oscillator",message))
      {
         Print("Send email failed with error #",GetLastError());
      }
   }
   if(InpAlertPlaySound)   PlaySound(InpAlertSoundFile);
   if(InpAlertSendNotification)
   {
      if(!SendNotification(message))
      {
         Print("Send notification failed with error #",GetLastError());
      }
   }
}
//+------------------------------------------------------------------+
