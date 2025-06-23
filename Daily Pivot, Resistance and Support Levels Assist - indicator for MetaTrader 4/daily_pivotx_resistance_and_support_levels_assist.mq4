//+------------------------------------------------------------------+
//|            Daily Pivot, Resistance and Support Levels Assist.mq4 |
//|                                                           Thicha |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Thicha"
#property link      "https://www.forexavengers.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
input ENUM_BASE_CORNER BASE_CORNER = CORNER_LEFT_UPPER;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   ObjectDelete("PIVOT_LINE");
   ObjectDelete("RE1");
   ObjectDelete("RE2");
   ObjectDelete("SU1");
   ObjectDelete("SU2");
   ObjectDelete("PPL");
   ObjectDelete("Res1");
   ObjectDelete("Res2");
   ObjectDelete("Su1");
   ObjectDelete("Su3");
//---
   return(INIT_SUCCEEDED);
  }
  void deinit()
   {
   ObjectDelete("PIVOT_LINE");
   ObjectDelete("RE1");
   ObjectDelete("RE2");
   ObjectDelete("RE3");
   ObjectDelete("SU1");
   ObjectDelete("SU2");
   ObjectDelete("SU3");
   ObjectDelete("PPL");
   ObjectDelete("Res1");
   ObjectDelete("Res2");
   ObjectDelete("Su1");
   ObjectDelete("Su2");
   ObjectDelete("Su3"); 
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
  double YESTERDAY_CLOSE=EMPTY_VALUE;
  double YESTERDAY_LOW=EMPTY_VALUE;
  double YESTERDAY_HIGH=EMPTY_VALUE;
 int counted_Bars =IndicatorCounted();
   for(int i=0;i<counted_Bars-1;i++)
   {
  YESTERDAY_CLOSE=iClose(NULL,PERIOD_D1,1);
  YESTERDAY_HIGH=iHigh(NULL,PERIOD_D1,1);
  YESTERDAY_LOW=iLow(NULL,PERIOD_D1,1);
   }
  double PP=(YESTERDAY_CLOSE+YESTERDAY_HIGH+YESTERDAY_LOW)/3;
  double S1=PP*2-YESTERDAY_HIGH;
  double R1=PP*2-YESTERDAY_LOW;
  double S2=PP-YESTERDAY_HIGH+YESTERDAY_LOW;
  double R2=PP+YESTERDAY_HIGH-YESTERDAY_LOW;
  double S3=YESTERDAY_LOW-2*(YESTERDAY_HIGH-PP);
  double R3=YESTERDAY_HIGH+(PP-YESTERDAY_LOW)*2;
   
  double PIVOT=NormalizeDouble((YESTERDAY_CLOSE+YESTERDAY_HIGH+YESTERDAY_LOW)/3,Digits);
  double RES1=NormalizeDouble(PP+PP-YESTERDAY_LOW,Digits);
  double RES2=NormalizeDouble(PP+YESTERDAY_HIGH-YESTERDAY_LOW,Digits);
  double SUP1=NormalizeDouble((2*PP)-YESTERDAY_HIGH,Digits);
  double SUP2=NormalizeDouble(PP-YESTERDAY_HIGH+YESTERDAY_LOW,Digits);
  double SUP3=NormalizeDouble(S3,Digits);
  double RES3=NormalizeDouble(R3,Digits);
   
   ObjectCreate("PIVOT_LINE",OBJ_LABEL,0,0,0);
   ObjectSet("PIVOT_LINE",OBJPROP_COLOR,Red);
   ObjectSet("PIVOT_LINE",OBJPROP_FONTSIZE,14);
   ObjectSet("PIVOT_LINE",OBJPROP_CORNER,BASE_CORNER);
   ObjectSet("PIVOT_LINE",OBJPROP_XDISTANCE,0);
   ObjectSet("PIVOT_LINE",OBJPROP_YDISTANCE,15);
   ObjectSetText("PIVOT_LINE","PIVOT= "+DoubleToStr(PIVOT,Digits),14,"Times New Roman",Red);  
   
   ObjectCreate("RE1",OBJ_LABEL,0,0,0);
   ObjectSet("RE1",OBJPROP_COLOR,Green);
   ObjectSet("RE1",OBJPROP_FONTSIZE,14);
   ObjectSet("RE1",OBJPROP_CORNER,BASE_CORNER);
   ObjectSet("RE1",OBJPROP_XDISTANCE,0);
   ObjectSet("RE1",OBJPROP_YDISTANCE,30);
   ObjectSetText("RE1","RESISTANCE1= "+DoubleToStr(RES1,Digits));
   ObjectSetText("RE1","RESISTANCE1= "+DoubleToStr(RES1,Digits),14,"Times New Roman",Green);  
      
   ObjectCreate("RE2",OBJ_LABEL,0,0,0);
   ObjectSet("RE2",OBJPROP_COLOR,Yellow);
   ObjectSet("RE2",OBJPROP_FONTSIZE,14);
   ObjectSet("RE2",OBJPROP_CORNER,BASE_CORNER);
   ObjectSet("RE2",OBJPROP_XDISTANCE,0);
   ObjectSet("RE2",OBJPROP_YDISTANCE,45);
   ObjectSetText("RE2","RESISTANCE2= "+DoubleToStr(RES2,Digits));
   ObjectSetText("RE2","RESISTANCE2= "+DoubleToStr(RES2,Digits),14,"Times New Roman",Yellow);  
   
   ObjectCreate("RE3",OBJ_LABEL,0,0,0);
   ObjectSet("RE3",OBJPROP_COLOR,Yellow);
   ObjectSet("RE3",OBJPROP_FONTSIZE,14);
   ObjectSet("RE3",OBJPROP_CORNER,BASE_CORNER);
   ObjectSet("RE3",OBJPROP_XDISTANCE,0);
   ObjectSet("RE3",OBJPROP_YDISTANCE,60);
   ObjectSetText("RE3","RESISTANCE3= "+DoubleToStr(RES3,Digits));
   ObjectSetText("RE3","RESISTANCE3= "+DoubleToStr(RES3,Digits),14,"Times New Roman",Aqua);  
     
   ObjectCreate("SU1",OBJ_LABEL,0,0,0);
   ObjectSet("SU1",OBJPROP_COLOR,Orange);
   ObjectSet("SU1",OBJPROP_FONTSIZE,14);
   ObjectSet("SU1",OBJPROP_CORNER,BASE_CORNER);
   ObjectSet("SU1",OBJPROP_XDISTANCE,0);
   ObjectSet("SU1",OBJPROP_YDISTANCE,75);
   ObjectSetText("SU1","SUPPORT1= "+DoubleToStr(SUP1,Digits));
   ObjectSetText("SU1","SUPPORT1= "+DoubleToStr(SUP1,Digits),14,"Times New Roman",Orange);   
         
   ObjectCreate("SU2",OBJ_LABEL,0,0,0);
   ObjectSet("SU2",OBJPROP_COLOR,Blue);
   ObjectSet("SU2",OBJPROP_FONTSIZE,14);
   ObjectSet("SU2",OBJPROP_CORNER,BASE_CORNER);
   ObjectSet("SU2",OBJPROP_XDISTANCE,0);
   ObjectSet("SU2",OBJPROP_YDISTANCE,90);
   ObjectSetText("SU2","SUPPORT2= "+DoubleToStr(SUP2,Digits));
   ObjectSetText("SU2","SUPPORT2= "+DoubleToStr(SUP2,Digits),14,"Times New Roman",Pink);  
   
   ObjectCreate("SU3",OBJ_LABEL,0,0,0);
   ObjectSet("SU3",OBJPROP_COLOR,Blue);
   ObjectSet("SU3",OBJPROP_FONTSIZE,14);
   ObjectSet("SU3",OBJPROP_CORNER,BASE_CORNER);
   ObjectSet("SU3",OBJPROP_XDISTANCE,0);
   ObjectSet("SU3",OBJPROP_YDISTANCE,105);
   ObjectSetText("SU3","SUPPORT3= "+DoubleToStr(SUP3,Digits));
   ObjectSetText("SU3","SUPPORT3= "+DoubleToStr(SUP3,Digits),14,"Times New Roman",Blue);  
   //--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
