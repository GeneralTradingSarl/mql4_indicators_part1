//+------------------------------------------------------------------+
//|                                                      FMDemod.mq4 |
//|                                         Copyright 2021, R Poster |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright   "R Poster 2021"
#property link        "http://www.mql4.com"
#property description "FM Demodulator-from J. Ehlers S&C 5/2021"
#property strict

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 DodgerBlue
//--- input parameter
input int FMPeriod     =  30;  // FM DeMod Period
input double OCNorm    =  38.; // Cls-Opn normalization 
//--- buffers
double ExtFMBuffer[];
double a1,b1,c1,c2,c3;
double MULT;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(void)
  {
   string short_name;
   double angl;
//--- indicator line
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtFMBuffer);
//--- name for DataWindow and indicator subwindow label
   short_name="FMDemod("+" Period "+IntegerToString(FMPeriod)+ " ,Norm "+DoubleToString(OCNorm,0)+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
   //
   MULT=1.0;
   if(Digits()==5 || Digits()==3) MULT=10.0;
   //
   a1 = MathExp(-1.414*3.14159/FMPeriod);
   angl = 1.414*180./FMPeriod; // degrees
   angl = angl*(3.14158/180.); // radians
   b1 = 2.*a1*MathCos(angl);
   c2 = b1;
   c3 = -a1*a1;
   c1 = 1.-c2-c3;
   //
//--- check input parameter
   if(FMPeriod<=0)
     {
      Print("Wrong input parameter FM Period=",FMPeriod);
      return(INIT_FAILED);
     }
//---
   SetIndexDrawBegin(0,FMPeriod);
//--- initialization done
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| FM Demodulator                                                   |
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
   int i,limit;
   int StartBar = 4;
   double ss,oc_1,oc_2,oc;
//--- check for bars count and input parameter
   if(rates_total<=StartBar || FMPeriod<=0)
      return(0);
//--- counting from 0 to rates_total
   ArraySetAsSeries(ExtFMBuffer,false);
   ArraySetAsSeries(close,false);
   ArraySetAsSeries(open,false);
//--- initial buffers
   if(prev_calculated<=0)
     {
      for(i=0; i<StartBar; i++)
       {
        oc = (close[i]-open[i]);
        ExtFMBuffer[i]=c1*GetClsOpn(oc);
       }
      limit=StartBar;
     }
   else
      limit=prev_calculated-1;
//-------- the main loop of calculations ----------------------
   for(i=limit; i<rates_total; i++)
    {
      oc = (close[i]-open[i]);
      oc_1 = GetClsOpn(oc);
      oc = (close[i-1]-open[i-1]);  
      oc_2 = GetClsOpn(oc);
      ss = c1*(oc_1+oc_2)/2.+c2*ExtFMBuffer[i-1]+c3*ExtFMBuffer[i-2]; 
      ExtFMBuffer[i]=ss;
    }
   return(rates_total);
  }
//+------------------------------------------------------------------+
double GetClsOpn(double oc)
 {
  double occ;
  occ=oc/(OCNorm*Point*MULT);
  if(occ>1.0)   occ=1.0;
  if (occ<-1.0) occ=-1.0;
  
  return occ;
 }
 //---------------------------------
