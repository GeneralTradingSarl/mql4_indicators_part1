//+------------------------------------------------------------------+
//|                                            PriceDegrees.mq4 |
//|                 Copyright 2014,  Roy Philips Jacobs ~ 29/06/2014 |
//|                                           http://www.gol2you.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014,  Roy Philips Jacobs ~ 29/06/2014"
#property link      "http://www.gol2you.com ~ Forex Videos"
#property description "Forex Indicator Price Degrees with Trend Alerts."
#property description "This indicator will write value degrees of the lastest position of price at the current Timeframes."
#property description "according to the Daily price movment, and when position and condition of trend status was changed,"
#property description "the indicator will give an alerts."
//--
#property indicator_chart_window
//---
extern string PriceDegrees="Copyright © 2014 3RJ ~ Roy Philips-Jacobs";
extern bool  MsgAlerts   = true;
extern bool  SoundAlerts = true;
extern bool  eMailAlerts = false;
extern string  SoundAlertFile="alert.wav";
//--
int corner=1;
int dist_x=190;
int dist_xt=150;
int dist_y=80;
int sep=30;
int posalert,prevalert;
//--
color stgBull=clrBlue;
color stsBull=clrAqua;
color stsBear=clrYellow;
color stgBear=clrRed;
color txtrbl=clrWhite;
color txtblk=clrBlack;
//--
void EventSetTimer();
//--
string CRight;
string symbol;
string dtext;
string Albase,AlSubj,AlMsg;
//---
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit(void)
  {
//--- indicator buffers mapping
   symbol=_Symbol;
   CRight="Copyright © 2014 3RJ ~ Roy Philips-Jacobs";
//---
//---- indicators
   //---
   IndicatorShortName("PriceDegrees ("+symbol+")");
   //--
   IndicatorDigits(Digits);
   //--   
//---
   return;
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//----
   EventKillTimer();
   GlobalVariablesDeleteAll();
//---
   ObjectDelete("RoundedDegrees");
   ObjectDelete("TextDegrees");
   ObjectDelete("ArrUpDegrees");
   ObjectDelete("ArrDnDegrees"); 
//----
   return;
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
//------
   if(PriceDegrees!=CRight) return(0);
   if(rates_total<sep) return(0);
//---
//--- Set Last error value to Zero
   ResetLastError();
   ChartSetInteger(0,CHART_AUTOSCROLL,0,true);
   WindowRedraw();
   ChartRedraw(0);
   Sleep(500);
   RefreshRates();
   double WmaxPr=NormalizeDouble(WindowPriceMax(),Digits);
   double WminPr=NormalizeDouble(WindowPriceMin(),Digits);
   int limit=WindowFirstVisibleBar();
   int j;
   int dtxt=0;   
   //---
   color rndclr;
   color arrclr;
   color txtclr;
   //---
   bool dgrsUp,dgrsDn;
   //--
//----
   //--
   for(j=limit; j>=0; j--)
     {
       //---
       double dayopp=iOpen(symbol,1440,j);
       double h4cls1=iClose(symbol,240,j+1);
       double m15cl1=iClose(symbol,15,j+1);
       double cc0=close[j];
       //--
       double dop_degrees=270+((dayopp-WminPr)/(WmaxPr-WminPr))*180;
       //--   
       double prvh41_degrees=270+((h4cls1-WminPr)/(WmaxPr-WminPr))*180;   
       //--   
       double prv151_degrees=270+((m15cl1-WminPr)/(WmaxPr-WminPr))*180;
       //--
       double cur_degrees=270+((cc0-WminPr)/(WmaxPr-WminPr))*180;
       //--
       double div1_degrees=prvh41_degrees - dop_degrees;
       double div151_degrees=prv151_degrees - prvh41_degrees;
       double div150_degrees=cur_degrees - prvh41_degrees;
       double div0_degrees=cur_degrees - dop_degrees;
       //--
       if(cur_degrees>360.0) {cur_degrees=cur_degrees-360.0;}
       if(cur_degrees==360.0) {cur_degrees=0.0;}
       //- To give a value of 90.0 degrees to the indicator, when the price moves up very quickly and make a New Windows Price Max.
       if(cur_degrees==90.0) {cur_degrees=90.0;}
       //- To give a value of 270.0 degrees to the indicator, when the price moves down very quickly and make a New Windows Price Min.
       if(cur_degrees==270.0) {cur_degrees=270.0;}
       //--
       if((div0_degrees>div1_degrees)&&(div150_degrees>div151_degrees))
          {dgrsUp=true; dgrsDn=false;}
       if((div0_degrees<div1_degrees)&&(div150_degrees<div151_degrees))
          {dgrsDn=true; dgrsUp=false;}
       //--
       //--- last edited 2014.06.29 11:25PM
       if((cur_degrees>=270.0 && cur_degrees<315.0)&&(dgrsDn==true)) {rndclr=stgBear; arrclr=stgBear; txtclr=txtrbl; posalert=11;}
       if((cur_degrees>=270.0 && cur_degrees<315.0)&&(dgrsUp==true)) {rndclr=stgBear; arrclr=stsBear; txtclr=txtrbl; posalert=12;}
       if((cur_degrees>=315.0 && cur_degrees<360.0)&&(dgrsDn==true)) {rndclr=stsBear; arrclr=stgBear; txtclr=txtblk; posalert=21;}
       if((cur_degrees>=315.0 && cur_degrees<360.0)&&(dgrsUp==true)) {rndclr=stsBear; arrclr=stsBull; txtclr=txtblk; posalert=23;}
       if((cur_degrees>=0.0 && cur_degrees<45.0)&&(dgrsUp==true)) {rndclr=stsBull; arrclr=stgBull; txtclr=txtblk; posalert=34;}
       if((cur_degrees>=0.0 && cur_degrees<45.0)&&(dgrsDn==true)) {rndclr=stsBull; arrclr=stsBear; txtclr=txtblk; posalert=32;}
       if((cur_degrees>=45.0 && cur_degrees<=90.0)&&(dgrsUp==true)) {rndclr=stgBull; arrclr=stgBull; txtclr=txtrbl; posalert=44;}
       if((cur_degrees>=45.0 && cur_degrees<=90.0)&&(dgrsDn==true)) {rndclr=stgBull; arrclr=stsBull; txtclr=txtrbl; posalert=43;}
       //---
       dtext=StringTrimRight(StringConcatenate(DoubleToStr(cur_degrees,1),"",CharToStr(176)));
       if(StringLen(dtext)>5) {dtxt=24;}
       else if(StringLen(dtext)==5) {dtxt=20;}
       else {dtxt=17;}
       //----
       if(j==0)
         {
           //---
           ObjectDelete("RoundedDegrees");
           ObjectDelete("TextDegrees");
           ObjectDelete("ArrUpDegrees");
           ObjectDelete("ArrDnDegrees");
           //--
           if(ObjectFind(0,"RoundedDegrees")<0)
             {             
               //--
               ObjectCreate(0,"RoundedDegrees",OBJ_LABEL,0,0,0);
               ObjectSetString(0,"RoundedDegrees",OBJPROP_TEXT,CharToStr(108));
               ObjectSetString(0,"RoundedDegrees",OBJPROP_FONT,"Wingdings");
               ObjectSetInteger(0,"RoundedDegrees",OBJPROP_COLOR,rndclr);
               ObjectSetInteger(0,"RoundedDegrees",OBJPROP_FONTSIZE,67);
               ObjectSetInteger(0,"RoundedDegrees",OBJPROP_CORNER,corner);
               ObjectSetInteger(0,"RoundedDegrees",OBJPROP_XDISTANCE,dist_x);
               ObjectSetInteger(0,"RoundedDegrees",OBJPROP_YDISTANCE,dist_y);              
               //--
             }
           else
             {
               //--
               ObjectSetString(0,"RoundedDegrees",OBJPROP_TEXT,CharToStr(108));
               ObjectSetString(0,"RoundedDegrees",OBJPROP_FONT,"Wingdings");
               ObjectSetInteger(0,"RoundedDegrees",OBJPROP_COLOR,rndclr);
               ObjectSetInteger(0,"RoundedDegrees",OBJPROP_FONTSIZE,67);
               ObjectSetInteger(0,"RoundedDegrees",OBJPROP_CORNER,corner);
               ObjectSetInteger(0,"RoundedDegrees",OBJPROP_XDISTANCE,dist_x);
               ObjectSetInteger(0,"RoundedDegrees",OBJPROP_YDISTANCE,dist_y);               
               //--               
             }
           //--
           if(ObjectFind(0,"TextDegrees")<0)
             {             
               //--               
               ObjectCreate(0,"TextDegrees",OBJ_LABEL,0,0,0);
               ObjectSetString(0,"TextDegrees",OBJPROP_TEXT,dtext);
               ObjectSetString(0,"TextDegrees",OBJPROP_FONT,"Bodoni MT Black");
               ObjectSetInteger(0,"TextDegrees",OBJPROP_COLOR,txtclr);
               ObjectSetInteger(0,"TextDegrees",OBJPROP_FONTSIZE,8);
               ObjectSetInteger(0,"TextDegrees",OBJPROP_CORNER,corner);
               ObjectSetInteger(0,"TextDegrees",OBJPROP_XDISTANCE,dist_xt+dtxt);
               ObjectSetInteger(0,"TextDegrees",OBJPROP_YDISTANCE,dist_y+41.5);
               //--
             }
           else
             {
               //--
               ObjectSetString(0,"TextDegrees",OBJPROP_TEXT,dtext);
               ObjectSetString(0,"TextDegrees",OBJPROP_FONT,"Bodoni MT Black");
               ObjectSetInteger(0,"TextDegrees",OBJPROP_COLOR,txtclr);
               ObjectSetInteger(0,"TextDegrees",OBJPROP_FONTSIZE,8);
               ObjectSetInteger(0,"TextDegrees",OBJPROP_CORNER,corner);
               ObjectSetInteger(0,"TextDegrees",OBJPROP_XDISTANCE,dist_xt+dtxt);
               ObjectSetInteger(0,"TextDegrees",OBJPROP_YDISTANCE,dist_y+41.5);
               //--
             }         
           //---
           //---
           if(dgrsUp)
             {
               //--
               if(ObjectFind(0,"ArrUpDegrees")<0)
                 {             
                   //--
                   ObjectCreate(0,"ArrUpDegrees",OBJ_LABEL,0,0,0);
                   ObjectSetString(0,"ArrUpDegrees",OBJPROP_TEXT,CharToStr(217));
                   ObjectSetString(0,"ArrUpDegrees",OBJPROP_FONT,"Wingdings");
                   ObjectSetInteger(0,"ArrUpDegrees",OBJPROP_COLOR,arrclr);
                   ObjectSetInteger(0,"ArrUpDegrees",OBJPROP_FONTSIZE,23);
                   ObjectSetInteger(0,"ArrUpDegrees",OBJPROP_CORNER,corner);
                   ObjectSetInteger(0,"ArrUpDegrees",OBJPROP_XDISTANCE,dist_xt+20);
                   ObjectSetInteger(0,"ArrUpDegrees",OBJPROP_YDISTANCE,dist_y-2);
                   //--
                 }
               else
                 {
                   //--
                   ObjectSetString(0,"ArrUpDegrees",OBJPROP_TEXT,CharToStr(217));
                   ObjectSetString(0,"ArrUpDegrees",OBJPROP_FONT,"Wingdings");
                   ObjectSetInteger(0,"ArrUpDegrees",OBJPROP_COLOR,arrclr);
                   ObjectSetInteger(0,"ArrUpDegrees",OBJPROP_FONTSIZE,23);
                   ObjectSetInteger(0,"ArrUpDegrees",OBJPROP_CORNER,corner);
                   ObjectSetInteger(0,"ArrUpDegrees",OBJPROP_XDISTANCE,dist_xt+20);
                   ObjectSetInteger(0,"ArrUpDegrees",OBJPROP_YDISTANCE,dist_y-2);
                   //--                 
                 }         
              //--
              //--
             }
           //---
           //---
           if(dgrsDn)
             {
               //--
               if(ObjectFind(0,"ArrDnDegrees")<0)
                 {             
                   //--
                   ObjectCreate(0,"ArrDnDegrees",OBJ_LABEL,0,0,0);
                   ObjectSetString(0,"ArrDnDegrees",OBJPROP_TEXT,CharToStr(218));
                   ObjectSetString(0,"ArrDnDegrees",OBJPROP_FONT,"Wingdings");
                   ObjectSetInteger(0,"ArrDnDegrees",OBJPROP_COLOR,arrclr);
                   ObjectSetInteger(0,"ArrDnDegrees",OBJPROP_FONTSIZE,23);
                   ObjectSetInteger(0,"ArrDnDegrees",OBJPROP_CORNER,corner);
                   ObjectSetInteger(0,"ArrDnDegrees",OBJPROP_XDISTANCE,dist_xt+20);
                   ObjectSetInteger(0,"ArrDnDegrees",OBJPROP_YDISTANCE,dist_y+63);
                   //--
                 }
               else
                 {
                   //--
                   ObjectSetString(0,"ArrDnDegrees",OBJPROP_TEXT,CharToStr(218));
                   ObjectSetString(0,"ArrDnDegrees",OBJPROP_FONT,"Wingdings");
                   ObjectSetInteger(0,"ArrDnDegrees",OBJPROP_COLOR,arrclr);
                   ObjectSetInteger(0,"ArrDnDegrees",OBJPROP_FONTSIZE,23);
                   ObjectSetInteger(0,"ArrDnDegrees",OBJPROP_CORNER,corner);
                   ObjectSetInteger(0,"ArrDnDegrees",OBJPROP_XDISTANCE,dist_xt+20);
                   ObjectSetInteger(0,"ArrDnDegrees",OBJPROP_YDISTANCE,dist_y+63);
                   //--
                 }                           
              //--
              //--
             }
           //--
           ChartRedraw(0);
           WindowRedraw();
           Sleep(500);
           RefreshRates();
           //--
           PosAlerts(posalert);
          //---
         }
      //---- End if(j)
     }
    //--- End for(j)
//--- done
   return(rates_total);
  }
//----- End OnCalculate()

//+--+
void DoAlerts(string msgText,string eMailSub)
  {
     if (MsgAlerts) Alert(msgText);
     if (SoundAlerts) PlaySound(SoundAlertFile);
     if (eMailAlerts) SendMail(eMailSub,msgText);
  }
//+--+

//+--+
string StrTF(int period)
  {
   switch(period)
     {
        case PERIOD_M1: return("M1");
        case PERIOD_M5: return("M5");
        case PERIOD_M15: return("M15");
        case PERIOD_M30: return("M30");
        case PERIOD_H1: return("H1");
        case PERIOD_H4: return("H4");
        case PERIOD_D1: return("D1");
        case PERIOD_W1: return("W1");
        case PERIOD_MN1: return("MN");
     }
   return(_Period);
  }  
//+--+

//+--+
void PosAlerts(int curalerts) //- last edited 2014.06.29 05:38AM
   {
    //---
    if((curalerts!=prevalert)&&(curalerts==43))
       {     
         Albase=StringConcatenate(symbol,", TF: ",StrTF(_Period),", PriceDegrees: ","Position ",dtext);
         AlSubj=StringConcatenate(Albase," Trend Began to Fall, Bulish Weakened");
         AlMsg=StringConcatenate(AlSubj," @ ",TimeToStr(TimeLocal(),TIME_SECONDS));
         DoAlerts(AlMsg,AlSubj);
         prevalert=curalerts;
       }
    //---
    if((curalerts!=prevalert)&&(curalerts==32))
       {     
         Albase=StringConcatenate(symbol,", TF: ",StrTF(_Period),", PriceDegrees: ","Position ",dtext);
         AlSubj=StringConcatenate(Albase," Trend was Down, Bulish Reversal");
         AlMsg=StringConcatenate(AlSubj," @ ",TimeToStr(TimeLocal(),TIME_SECONDS));
         DoAlerts(AlMsg,AlSubj);
         prevalert=curalerts;
       }
    //---
    if((curalerts!=prevalert)&&(curalerts==21))
       {     
         Albase=StringConcatenate(symbol,", TF: ",StrTF(_Period),", PriceDegrees: ","Position ",dtext);
         AlSubj=StringConcatenate(Albase," Trend was Down, Bearish Strengthened");
         AlMsg=StringConcatenate(AlSubj," @ ",TimeToStr(TimeLocal(),TIME_SECONDS));
         DoAlerts(AlMsg,AlSubj);
         prevalert=curalerts;
       }              
    //---
    if((curalerts!=prevalert)&&(curalerts==11))
       {     
         Albase=StringConcatenate(symbol,", TF: ",StrTF(_Period),", PriceDegrees: ","Position ",dtext);
         AlSubj=StringConcatenate(Albase," Trend was Down, Strong Bearish");
         AlMsg=StringConcatenate(AlSubj," @ ",TimeToStr(TimeLocal(),TIME_SECONDS));
         DoAlerts(AlMsg,AlSubj);
         prevalert=curalerts;
       }
    //---//
    if((curalerts!=prevalert)&&(curalerts==12))
       {
         Albase=StringConcatenate(symbol,", TF: ",StrTF(_Period),", PriceDegrees: ","Position ",dtext);
         AlSubj=StringConcatenate(Albase," Trend Began to Rise, Bearish Weakened");
         AlMsg=StringConcatenate(AlSubj," @ ",TimeToStr(TimeLocal(),TIME_SECONDS));
         DoAlerts(AlMsg,AlSubj);
         prevalert=curalerts;
       }
    //---
    if((curalerts!=prevalert)&&(curalerts==23))
       {
         Albase=StringConcatenate(symbol,", TF: ",StrTF(_Period),", PriceDegrees: ","Position ",dtext);
         AlSubj=StringConcatenate(Albase," Trend was Up, Bearish Reversal");
         AlMsg=StringConcatenate(AlSubj," @ ",TimeToStr(TimeLocal(),TIME_SECONDS));
         DoAlerts(AlMsg,AlSubj);
         prevalert=curalerts;
       }
    //---
    if((curalerts!=prevalert)&&(curalerts==34))
       {
         Albase=StringConcatenate(symbol,", TF: ",StrTF(_Period),", PriceDegrees: ","Position ",dtext);
         AlSubj=StringConcatenate(Albase," Trend was Up, Bulish Strengthened");
         AlMsg=StringConcatenate(AlSubj," @ ",TimeToStr(TimeLocal(),TIME_SECONDS));
         DoAlerts(AlMsg,AlSubj);
         prevalert=curalerts;
       }
    //---
    if((curalerts!=prevalert)&&(curalerts==44))
       {
         Albase=StringConcatenate(symbol,", TF: ",StrTF(_Period),", PriceDegrees: ","Position ",dtext);
         AlSubj=StringConcatenate(Albase," Trend was Up, Strong Bulish");
         AlMsg=StringConcatenate(AlSubj," @ ",TimeToStr(TimeLocal(),TIME_SECONDS));
         DoAlerts(AlMsg,AlSubj);
         prevalert=curalerts;
       }
    //---
    return;
   //----
   } //-end PosAlerts()
//+------------------------------------------------------------------+