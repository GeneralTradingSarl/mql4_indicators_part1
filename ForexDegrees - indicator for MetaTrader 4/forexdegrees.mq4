//+------------------------------------------------------------------+
//|                                                 ForexDegrees.mq4 |
//|             Copyright 2016,  Roberto Philips Jacobs ~ 22/03/2016 |
//|                              https://www.mql5.com/en/users/3rjfx |
//+------------------------------------------------------------------+
#property copyright "https://www.mql5.com/en/users/3rjfx. ~ By 3rjfx ~ Created: 2016/03/22"
#property link      "http://www.mql5.com"
#property link      "https://www.mql5.com/en/users/3rjfx"
#property version   "1.00"
#property description "Forex Indicator ForexDegrees with Trend Alerts."
#property description "This indicator will write value degrees of the lastest position of Price/MA/WPR/RSI/Stochastic at the current Timeframes."
#property description "And when position and condition of trend status was changed, the indicator will give an alerts."
//--
#property indicator_chart_window
#property indicator_buffers 2
//---
extern string           ForexDegrees  = "Copyright © 2016 3RJ ~ Roberto Philips-Jacobs";
extern bool            MsgAlerts      = true;
extern bool            SoundAlerts    = true;
extern bool            eMailAlerts    = false;
extern string         SoundAlertFile  = "alert.wav";
//--
extern bool           UsePriceDegrees = true;
extern ENUM_APPLIED_PRICE    AppPrice = PRICE_TYPICAL; // Applied Price
extern bool              UseMADegrees = false;
extern int                   MAPeriod = 2;
extern ENUM_MA_METHOD        MAMethod = MODE_EMA;
extern ENUM_APPLIED_PRICE  MAAppPrice = PRICE_TYPICAL; // Applied Price
extern bool             UseWPRDegrees = false;
extern int                  WPRPeriod = 14;
extern bool             UseRSIDegrees = false;
extern int                  RSIPeriod = 14;
extern ENUM_APPLIED_PRICE RSIAppPrice = PRICE_TYPICAL;
extern bool      UseStochasticDegrees = false;
extern int                StocKperiod = 5;  // K Period 
extern int                StocDperiod = 3;  // D Period 
extern int                StocSlowing = 3;  // Slowing
//--
//--- buffers
double DegreesUp[];
double DegreesDn[];
//-
double cprice[];
//--
int corner=1;
int dist_x=170;
int dist_xt=130;
int dist_y=80;
int sep=100;
int use=0;
int posalert,prevalert;
int tfi=PERIOD_CURRENT;
int window;
int cmin;
int pmin=-1;
//--
color stgBull=clrBlue;
color stsBull=clrAqua;
color stsBear=clrYellow;
color stgBear=clrRed;
color txtrbl=clrWhite;
color txtblk=clrBlack;
//--
bool res;
string inname;
string CRight;
string dtext;
string Albase,AlSubj,AlMsg;
//---
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(void)
  {
//--- indicator buffers mapping
   CRight="Copyright © 2016 3RJ ~ Roberto Philips-Jacobs";
//---
   IndicatorShortName("ForexDegrees ("+_Symbol+")");
   IndicatorDigits(2);
//--- indicator buffers mapping
   IndicatorBuffers(2);
   //---
   SetIndexBuffer(0,DegreesUp);
   SetIndexBuffer(1,DegreesDn);
//--- indicator lines
   SetIndexStyle(0,DRAW_NONE);
   SetIndexStyle(1,DRAW_NONE);
//--- indicator labels
   SetIndexLabel(0,"DegreesUp");
   SetIndexLabel(1,"DegreesDn");
   //---
   if(!UseDegrees(use)) 
     {UsePriceDegrees=true; inname="Price "; UseMADegrees=false; UseWPRDegrees=false; UseRSIDegrees=false; UseStochasticDegrees=false;}
   //---
   //--
//--- initialization done
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//----
   //--
   ObjectsDeleteAll();
   GlobalVariablesDeleteAll();
//----
   return;
  }
//----

bool UseDegrees(int pd)
   {
//----
     if(UsePriceDegrees) {pd++; inname="Price ";}
     if(UseMADegrees) {pd++; inname="MA ";}
     if(UseWPRDegrees) {pd++; inname="WPR ";}
     if(UseRSIDegrees) {pd++; inname="RSI ";}
     if(UseStochasticDegrees) {pd++; inname="Stochastic ";}
     //--
     if(pd>1) {return(false);}
     //--
     return(true);
//----
   } //-end UseDegrees()
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
//------
   if(ForexDegrees!=CRight) return(0);
   if(rates_total<sep) return(0);
   int limit=rates_total-prev_calculated;
   if(prev_calculated>0) limit=103;
//------
//--- Set Last error value to Zero
   ResetLastError();
   WindowRedraw();
   ChartRedraw(0);
   Sleep(500);
   RefreshRates();
   //--
   int j;
   int dtxt=0;
   //---
   color rndclr;
   color arrclr;
   color txtclr;
   //---
   bool dgrsUp,dgrsDn;
   //--
   double clsdg[];
   double emadg[];
   double sma04[];
   double wprdg[];
   double rsidg[];
   double stodg[];
   double WmaxPr=0.0;
   double WminPr=0.0;
   //--
   ArrayResize(clsdg,limit);
   ArrayResize(emadg,limit);
   ArrayResize(sma04,limit);
   ArrayResize(wprdg,limit);
   ArrayResize(rsidg,limit);
   ArrayResize(stodg,limit);
   //--
   ArraySetAsSeries(clsdg,true);
   ArraySetAsSeries(emadg,true);
   ArraySetAsSeries(sma04,true);
   ArraySetAsSeries(wprdg,true);
   ArraySetAsSeries(rsidg,true);
   ArraySetAsSeries(stodg,true);
   ArraySetAsSeries(open,true);
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);
   ArraySetAsSeries(close,true);
   //--
   //-- prepare the Highest and Lowest Price
   int Hi=iHighest(_Symbol,tfi,MODE_HIGH,sep,0);
   int Lo=iLowest(_Symbol,tfi,MODE_LOW,sep,0);
   if(Hi!=-1) WmaxPr=high[Hi];
   if(Lo!=-1) WminPr=low[Lo];
   //--
   if(UsePriceDegrees)
     {
       switch(AppPrice)
         {
           case 0:
                   clsdg[0]=Close[0];
                   clsdg[1]=Close[1];
                   clsdg[2]=Close[2];
                   break;
           case 1:
                   clsdg[0]=Open[0];
                   clsdg[1]=Open[1];
                   clsdg[2]=Open[2];
                   break;
           case 2:  
                   clsdg[0]=High[0];
                   clsdg[1]=High[1];
                   clsdg[2]=High[2];
                   break;
           case 3:
                   clsdg[0]=Low[0];
                   clsdg[1]=Low[1];
                   clsdg[2]=Low[2];
                   break;
           case 4:
                   clsdg[0]=(High[0]+Low[0])/2;
                   clsdg[1]=(High[1]+Low[1])/2;
                   clsdg[2]=(High[2]+Low[2])/2;

                   break;
           case 5:
                   clsdg[0]=(High[0]+Low[0]+Close[0])/3;
                   clsdg[1]=(High[1]+Low[1]+Close[1])/3;
                   clsdg[2]=(High[2]+Low[2]+Close[2])/3;
                   break;
           case 6:
                   clsdg[0]=(High[0]+Low[0]+Close[0]+Close[0])/4;
                   clsdg[1]=(High[1]+Low[1]+Close[1]+Close[1])/4;
                   clsdg[2]=(High[2]+Low[2]+Close[2]+Close[2])/4;
                   break;
         }
     }
   //--
   if(UseMADegrees)
     {
       for(int i=limit-1; i>=0; i--)
         emadg[i]=iMA(_Symbol,tfi,MAPeriod,0,MAMethod,MAAppPrice,i);
     }
   //--
   if(UseWPRDegrees)
     {
       for(int w=limit-1; w>=0; w--)
         wprdg[w]=100-MathAbs(iWPR(_Symbol,tfi,WPRPeriod,w));
     }
   //--
   if(UseRSIDegrees)
     {
       for(int r=limit-1; r>=0; r--)
         rsidg[r]=iRSI(_Symbol,tfi,RSIPeriod,RSIAppPrice,r);
     }
   //--
   if(UseStochasticDegrees)
     {
       for(int s=limit-1; s>=0; s--)
         stodg[s]=iStochastic(_Symbol,tfi,StocKperiod,StocDperiod,StocSlowing,0,0,0,s);
     }
   //--
//----
   //--
   for(j=limit-3; j>=0; j--)
     {
       //---
       sma04[j]=iMAOnArray(emadg,0,4,0,0,j);
       //--
       if(UsePriceDegrees)
         {
           double cur_degrees=NormalizeDouble(270+(((clsdg[j]-WminPr)/(WmaxPr-WminPr))*180),2);
           double prev1_degrees=NormalizeDouble(270+(((clsdg[j+1]-WminPr)/(WmaxPr-WminPr))*180),2);
           double prev2_degrees=NormalizeDouble(270+(((clsdg[j+2]-WminPr)/(WmaxPr-WminPr))*180),2);
           //--
           double div1_degrees=prev1_degrees - prev2_degrees;
           double div0_degrees=cur_degrees - prev2_degrees;
           //--
         }
       //--
       if(UseMADegrees)
         {
           cur_degrees=NormalizeDouble((270+(((emadg[j]-WminPr)/(WmaxPr-WminPr))*180))+(emadg[0]-sma04[0]),2);
           prev1_degrees=NormalizeDouble((270+(((emadg[j+1]-WminPr)/(WmaxPr-WminPr))*180))+(emadg[1]-sma04[1]),2);
           prev2_degrees=NormalizeDouble((270+(((emadg[j+2]-WminPr)/(WmaxPr-WminPr))*180))+(emadg[2]-sma04[2]),2);
           //--
           div1_degrees=prev1_degrees - prev2_degrees;
           div0_degrees=cur_degrees - prev2_degrees;
           //--
         }
       //--
       if(UseWPRDegrees)
         {
           cur_degrees=NormalizeDouble(270+((wprdg[j]/100)*180),2);
           prev1_degrees=NormalizeDouble(270+((wprdg[j+1]/100)*180),2);
           prev2_degrees=NormalizeDouble(270+((wprdg[j+2]/100)*180),2);
           //--
           div1_degrees=prev1_degrees - prev2_degrees;
           div0_degrees=cur_degrees - prev2_degrees;
           //--
         }
       //--
       if(UseRSIDegrees)
         {
           cur_degrees=NormalizeDouble(270+((rsidg[j]/100)*180),2);
           prev1_degrees=NormalizeDouble(270+((rsidg[j+1]/100)*180),2);
           prev2_degrees=NormalizeDouble(270+((rsidg[j+2]/100)*180),2);
           //--
           div1_degrees=prev1_degrees - prev2_degrees;
           div0_degrees=cur_degrees - prev2_degrees;
           //--
         }
       //--
       if(UseStochasticDegrees)
         {
           cur_degrees=NormalizeDouble(270+((stodg[j]/100)*180),2);
           prev1_degrees=NormalizeDouble(270+((stodg[j+1]/100)*180),2);
           prev2_degrees=NormalizeDouble(270+((stodg[j+2]/100)*180),2);
           //--
           div1_degrees=prev1_degrees - prev2_degrees;
           div0_degrees=cur_degrees - prev2_degrees;
           //--
         }
       //--
       if(cur_degrees>360.0) {cur_degrees=NormalizeDouble(cur_degrees-360.0,2);}
       if(cur_degrees==360.0) {cur_degrees=NormalizeDouble(0.0,2);}
       //- To give a value of 90.0 degrees to the indicator, when the price moves up very quickly and make a New Windows Price Max.
       if(cur_degrees==90.0) {cur_degrees=NormalizeDouble(90.0,2);}
       //- To give a value of 270.0 degrees to the indicator, when the price moves down very quickly and make a New Windows Price Min.
       if(cur_degrees==270.0) {cur_degrees=NormalizeDouble(270.0,2);}
       //--
       if(div0_degrees>div1_degrees) {dgrsUp=true; dgrsDn=false; DegreesUp[j]=cur_degrees; DegreesDn[j]=0.0;}
       if(div0_degrees<div1_degrees) {dgrsDn=true; dgrsUp=false; DegreesDn[j]=cur_degrees; DegreesUp[j]=0.0;}
       //---
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
   string periodcur;
   switch(period)
     {
       //--
       case PERIOD_M1: periodcur="M1"; break;
       case PERIOD_M5: periodcur="M5"; break;
       case PERIOD_M15: periodcur="M15"; break;
       case PERIOD_M30: periodcur="M30"; break;
       case PERIOD_H1: periodcur="H1"; break;
       case PERIOD_H4: periodcur="H4"; break;
       case PERIOD_D1: periodcur="D1"; break;
       case PERIOD_W1: periodcur="W1"; break;
       case PERIOD_MN1: periodcur="MN"; break;
       //--
     }
   //--
   return(periodcur);
  }  
//---------//

//+--+//
void PosAlerts(int curalerts) //-
   {
    //---
    cmin=(int)Minute();
    if(cmin!=pmin)
      {
        if((curalerts!=prevalert)&&(curalerts==43))
          {
            Albase="*"+WindowExpertName()+": "+_Symbol+", TF: "+StrTF(_Period)+", "+inname+"Position "+dtext;
            AlSubj=Albase+", Trend Began to Fall, Bulish Weakened";
            AlMsg=AlSubj+" @ "+TimeToString(TimeCurrent(),TIME_DATE|TIME_MINUTES);
            pmin=cmin;
            DoAlerts(AlMsg,AlSubj);
            prevalert=curalerts;
          }
        //---
        if((curalerts!=prevalert)&&(curalerts==32))
          {     
            Albase="*"+WindowExpertName()+": "+_Symbol+", TF: "+StrTF(_Period)+", "+inname+"Position "+dtext;
            AlSubj=Albase+", Trend was Down, Bulish Reversal";
            AlMsg=AlSubj+" @ "+TimeToString(TimeCurrent(),TIME_DATE|TIME_MINUTES);
            pmin=cmin;
            DoAlerts(AlMsg,AlSubj);
            prevalert=curalerts;
          }
        //---
        if((curalerts!=prevalert)&&(curalerts==21))
          {     
            Albase="*"+WindowExpertName()+": "+_Symbol+", TF: "+StrTF(_Period)+", "+inname+"Position "+dtext;
            AlSubj=Albase+", Trend was Down, Bearish Strengthened";
            AlMsg=AlSubj+" @ "+TimeToString(TimeCurrent(),TIME_DATE|TIME_MINUTES);
            pmin=cmin;
            DoAlerts(AlMsg,AlSubj);
            prevalert=curalerts;
          }              
        //---
        if((curalerts!=prevalert)&&(curalerts==11))
          {     
            Albase="*"+WindowExpertName()+": "+_Symbol+", TF: "+StrTF(_Period)+", "+inname+"Position "+dtext;
            AlSubj=Albase+", Trend was Down, Strong Bearish";
            AlMsg=AlSubj+" @ "+TimeToString(TimeCurrent(),TIME_DATE|TIME_MINUTES);
            pmin=cmin;
            DoAlerts(AlMsg,AlSubj);
            prevalert=curalerts;
          }
        //---
        if((curalerts!=prevalert)&&(curalerts==12))
          {
            Albase="*"+WindowExpertName()+": "+_Symbol+", TF: "+StrTF(_Period)+", "+inname+"Position "+dtext;
            AlSubj=Albase+", Trend Began to Rise, Bearish Weakened";
            AlMsg=AlSubj+" @ "+TimeToString(TimeCurrent(),TIME_DATE|TIME_MINUTES);
            pmin=cmin;
            DoAlerts(AlMsg,AlSubj);
            prevalert=curalerts;
          }
        //---
        if((curalerts!=prevalert)&&(curalerts==23))
          {
            Albase="*"+WindowExpertName()+": "+_Symbol+", TF: "+StrTF(_Period)+", "+inname+"Position "+dtext;
            AlSubj=Albase+", Trend was Up, Bearish Reversal";
            AlMsg=AlSubj+" @ "+TimeToString(TimeCurrent(),TIME_DATE|TIME_MINUTES);
            pmin=cmin;
            DoAlerts(AlMsg,AlSubj);
            prevalert=curalerts;
          }
        //---
        if((curalerts!=prevalert)&&(curalerts==34))
          {
            Albase="*"+WindowExpertName()+": "+_Symbol+", TF: "+StrTF(_Period)+", "+inname+"Position "+dtext;
            AlSubj=Albase+", Trend was Up, Bulish Strengthened";
            AlMsg=AlSubj+" @ "+TimeToString(TimeCurrent(),TIME_DATE|TIME_MINUTES);
            pmin=cmin;
            DoAlerts(AlMsg,AlSubj);
            prevalert=curalerts;
          }
        //---
        if((curalerts!=prevalert)&&(curalerts==44))
          {
            Albase="*"+WindowExpertName()+": "+_Symbol+", TF: "+StrTF(_Period)+", "+inname+"Position "+dtext;
            AlSubj=Albase+" Trend was Up, Strong Bulish";
            AlMsg=AlSubj+" @ "+TimeToString(TimeCurrent(),TIME_DATE|TIME_MINUTES);
            pmin=cmin;
            DoAlerts(AlMsg,AlSubj);
            prevalert=curalerts;
          }
      }   
    //---
    return;
   //----
   } //-end PosAlerts()
//+------------------------------------------------------------------+