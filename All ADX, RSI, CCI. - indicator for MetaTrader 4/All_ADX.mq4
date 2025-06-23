//+------------------------------------------------------------------+
//|                                                      All ADX.mq4 |
//|                                                           mladen |
//+------------------------------------------------------------------+
#property copyright   "mladen"
#property link        ""
#define indicatorName "All ADX"
//----
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 Gold
#property indicator_color2 Green
#property indicator_color3 Red
//---- input parameters
extern int    ADXPeriod           =14;
extern bool   showHigherTimeframes=true;
extern int    barsPerTimeFrame    =35;
extern bool   shiftRight          =False;
extern color  txtColor            =Silver;
extern color  separatorColor      =DimGray;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
//----
string shortName;
string labelsShort[] ={"M1","M5","M15","M30","H1","H4","D1"};
string labelsLong[]  ={"M15","M30","H1","H4","D1","W1","MN1"};
string labels[];
int    periodsShort[]={PERIOD_M1,PERIOD_M5,PERIOD_M15,PERIOD_M30,PERIOD_H1,PERIOD_H4,PERIOD_D1};
int    periodsLong[] ={PERIOD_M15,PERIOD_M30,PERIOD_H1,PERIOD_H4,PERIOD_D1,PERIOD_W1,PERIOD_MN1};
int    periods[];
int    Shift;
double minValue;
double maxValue;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   barsPerTimeFrame=MathMax(barsPerTimeFrame,30);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,ExtMapBuffer3);
   //----
   if (shiftRight) Shift=1;
   else            Shift=0;
   SetIndexShift(0,Shift*(barsPerTimeFrame+1));
   SetIndexShift(1,Shift*(barsPerTimeFrame+1));
   SetIndexShift(2,Shift*(barsPerTimeFrame+1));
   //----
   SetIndexLabel(0,"ADX");
   SetIndexLabel(1,"+DI");
   SetIndexLabel(2,"-DI");
   shortName=indicatorName+" ("+ADXPeriod+")";
   IndicatorShortName(shortName);
     if (showHigherTimeframes) 
     {
      ArrayCopy(labels,labelsLong);
      ArrayCopy(periods,periodsLong);
     }
     else  
     {
      ArrayCopy(labels,labelsShort);
      ArrayCopy(periods,periodsShort);
     }
   //----
   for(int i=1;i<7;i++)
      if (Period()==periods[i])
        {
         string tmpLbl=labels[i];
         int    tmpPer=periods[i];
         //----
         for(int k=i ;k>0; k--)
           {
            labels[k] =labels[k-1];
            periods[k]=periods[k-1];
           }
         labels[0] =tmpLbl;
         periods[0]=tmpPer;
        }
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   for(int l=0;l<7;l++)
     {
      ObjectDelete(indicatorName+l);
      ObjectDelete(indicatorName+l+1);
     }
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   string on;
   int    wn=WindowFind(shortName);
   int    k=0;
   //----
   minValue= 999999;
   maxValue=-999999;
   for(int p=0; p<7;p++)
     {
      for(int i=0; i<barsPerTimeFrame;i++,k++)
        {
         ExtMapBuffer1[k] =iADX(NULL,periods[p],ADXPeriod,PRICE_CLOSE,0,i);
         ExtMapBuffer2[k] =iADX(NULL,periods[p],ADXPeriod,PRICE_CLOSE,1,i);
         ExtMapBuffer3[k] =iADX(NULL,periods[p],ADXPeriod,PRICE_CLOSE,2,i);
         checkMinMax(k);
        }
      ExtMapBuffer1[k] =EMPTY_VALUE;
      ExtMapBuffer2[k] =EMPTY_VALUE;
      ExtMapBuffer3[k] =EMPTY_VALUE;
      k+=1;
      //----
      on=indicatorName+p;
      if(ObjectFind(on)==-1)
         ObjectCreate(on,OBJ_TREND,wn,0,0);
      ObjectSet(on,OBJPROP_TIME1,myTime(k-Shift*(barsPerTimeFrame+1)-1));
      ObjectSet(on,OBJPROP_TIME2,myTime(k-Shift*(barsPerTimeFrame+1)-1));
      ObjectSet(on,OBJPROP_COLOR ,separatorColor);
      ObjectSet(on,OBJPROP_WIDTH ,2);
      on=indicatorName+p+1;
      if(ObjectFind(on)==-1)
         ObjectCreate(on,OBJ_TEXT,wn,0,0);
      ObjectSet(on,OBJPROP_TIME1,myTime(k-Shift*(barsPerTimeFrame+1)-6));
      ObjectSetText(on,labels[p],9,"Arial",txtColor);
     }
   for(p=0; p<7;p++)
     {
      on=indicatorName+p;
      ObjectSet(on,OBJPROP_PRICE1,minValue*1.05);
      ObjectSet(on,OBJPROP_PRICE2,maxValue);
      on=indicatorName+p+1;
      ObjectSet(on,OBJPROP_PRICE1,(minValue+maxValue)/2);
     }
   //----
   for(p=0; p<7;p++)
     {
      on=indicatorName+p;
      ObjectSet(on,OBJPROP_PRICE1,maxValue);
      ObjectSet(on,OBJPROP_PRICE2,minValue);
      on=indicatorName+p+1;
      ObjectSet(on,OBJPROP_PRICE1,maxValue);
     }
   //----
   SetIndexDrawBegin(0,Bars-k);
   SetIndexDrawBegin(1,Bars-k);
   SetIndexDrawBegin(2,Bars-k);
   return(0);
  }
//+------------------------------------------------------------------+
//+ Custom functions and procedures                                  +
//+------------------------------------------------------------------+
void checkMinMax(int shift)
  {
   double tmpMin;
   double tmpMax;
//----
   tmpMin=MathMin(ExtMapBuffer1[shift],ExtMapBuffer2[shift]);
   tmpMin=MathMin(ExtMapBuffer3[shift],tmpMin);
   tmpMax=MathMax(ExtMapBuffer1[shift],ExtMapBuffer2[shift]);
   tmpMax=MathMax(ExtMapBuffer3[shift],tmpMax);
   minValue=MathMin(tmpMin,minValue);
   maxValue=MathMax(tmpMax,maxValue);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int myTime(int a)
  {
   if(a<0)
      return(Time[0]+Period()*60*MathAbs(a));
   else  return(Time[a]);
  }
//+------------------------------------------------------------------+