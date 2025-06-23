// +------------------------------------------------------------------+
// | FileName: Camarilla_AlertwFibs.mq4                               |
// | Author: Copyright © 2005, Fermin Da Costa Gomez                  |
// | Version : 01 (Inital code)                                       |
// |                                                                  |
// | Modified by MrPip to add H5, L5, Fibonacci and alerts            |
// |                                                                  |
// +------------------------------------------------------------------+
#property copyright "Copyright © 2005, Fermin Da Costa Gomez"
#property link      "http://forex.viahetweb.nl"
//----
#property indicator_chart_window
#property indicator_buffers 7
#property indicator_color1 Yellow
#property indicator_color2 LawnGreen
#property indicator_color3 LawnGreen
#property indicator_color4 LawnGreen
#property indicator_color5 OrangeRed
#property indicator_color6 OrangeRed
#property indicator_color7 OrangeRed
#property indicator_width1 1
#property indicator_width2 3
#property indicator_width3 1
#property indicator_width4 1
#property indicator_width5 3
#property indicator_width6 1
#property indicator_width7 1
#property indicator_style1 1 // STYLE_DASH
//---- input parameters
extern bool Alerts=true;
extern int GMT_Offset=0;
extern int PipDistance = 20;
extern color FontColor = White;
extern int fontsize=8;
extern bool Fibs=true;
extern color FibColor=Sienna;
extern bool Pivot=true;
extern color PivotColor=Yellow;
extern int PivotWidth=1;
//---- buffers
double PBuffer[];
double H5Buffer[];
double H4Buffer[];
double H3Buffer[];
double L3Buffer[];
double L4Buffer[];
double L5Buffer[];
string sL3="L3",  sL4="L4", sL5="L5";
string sH3="H3", sH4="H4", sH5="H5";
double P,H3,H4,H5;
double L3,L4,L5;
double LastHigh,LastLow,x;
bool firstL3=true,firstL4=true;
double DifBelowL3,DifAboveL3,DifBelowL4,DifAboveL4,PipsLimit;
bool firstH3=true,firstH4=true;
double DifBelowH3,DifAboveH3,DifBelowH4,DifAboveH4;
double D1=0.091667;
double D2=0.183333;
double D3=0.2750;
double D4=0.55;
// Fib variables
double yesterday_high=0;
double yesterday_low=0;
double yesterday_close=0;
double r3=0;
double r2=0;
double r1=0;
double p=0;
double s1=0;
double s2=0;
double s3=0;
double R;
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- TODO: add your code here
//   ObjectDelete("Pivot");
   DeleteCamLabels();
   if(Fibs) DeleteFibLabels();
   if(Pivot) DeletePivotLabels();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- indicator line
   SetIndexStyle(0,DRAW_LINE,STYLE_DASH,PivotWidth);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(0,PBuffer);
   SetIndexBuffer(1,H3Buffer);
   SetIndexBuffer(2,H4Buffer);
   SetIndexBuffer(3,H5Buffer);
   SetIndexStyle(4,DRAW_LINE);
   SetIndexStyle(5,DRAW_LINE);
   SetIndexStyle(6,DRAW_LINE);
   SetIndexBuffer(4,L3Buffer);
   SetIndexBuffer(5,L4Buffer);
   SetIndexBuffer(6,L5Buffer);
//---- name for DataWindow and indicator subwindow label
   short_name="Camarilla levels";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
//----
   SetIndexDrawBegin(0,1);
//----
   r2=0;r1=0;p=0;s1=0;s2=0;s3=0;r3=0;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int DeleteCamLabels()
  {
   ObjectDelete("L3");
   ObjectDelete("L4");
   ObjectDelete("L5");
   ObjectDelete("H3");
   ObjectDelete("H4");
   ObjectDelete("H5");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CreateCamLabels()
  {
   ObjectCreate("L3",OBJ_TEXT,0,0,0);
   ObjectSetText("L3","L3 Long "+DoubleToStr(L3,4),fontsize,"Arial",FontColor);
   ObjectCreate("L4",OBJ_TEXT,0,0,0);
   ObjectSetText("L4","L4 Short BreakOut "+DoubleToStr(L4,4),fontsize,"Arial",FontColor);
   ObjectCreate("L5",OBJ_TEXT,0,0,0);
   ObjectSetText("L5","L5 SB Target "+DoubleToStr(L5,4),fontsize,"Arial",FontColor);
   ObjectCreate("H3",OBJ_TEXT,0,0,0);
   ObjectSetText("H3","H3 Short "+DoubleToStr(H3,4),fontsize,"Arial",FontColor);
   ObjectCreate("H4",OBJ_TEXT,0,0,0);
   ObjectSetText("H4","H4 Long BreakOut "+DoubleToStr(H4,4),fontsize,"Arial",FontColor);
   ObjectCreate("H5",OBJ_TEXT,0,0,0);
   ObjectSetText("H5","H5 LB Target "+DoubleToStr(H5,4),fontsize,"Arial",FontColor);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int DeletePivotLabels()
  {
   ObjectDelete("P Label");
//   ObjectDelete("P Line");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CreatePivotLabels()
  {
   ObjectCreate("P label",OBJ_TEXT,0,0,0);
   ObjectSetText("P label","Pivot  "+DoubleToStr(P,4),fontsize,"Arial",FontColor);
// ObjectCreate("P line", OBJ_HLINE, 0, 0, 0);
// ObjectSet("P line", OBJPROP_STYLE, STYLE_DASHDOTDOT);
// ObjectSet("P line", OBJPROP_COLOR, PivotColor);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int DeleteFibLabels()
  {
   ObjectDelete("S1 Label");
   ObjectDelete("S1 Line");
   ObjectDelete("S2 Label");
   ObjectDelete("S2 Line");
   ObjectDelete("S3 Label");
   ObjectDelete("S3 Line");
   ObjectDelete("R1 Label");
   ObjectDelete("R1 Line");
   ObjectDelete("R2 Label");
   ObjectDelete("R2 Line");
   ObjectDelete("R3 Label");
   ObjectDelete("R3 Line");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CreateFibLabels()
  {
   ObjectCreate("R1 label",OBJ_TEXT,0,0,0);
   ObjectSetText("R1 label","Fib R1",fontsize,"Arial",FontColor);
   ObjectCreate("R2 label",OBJ_TEXT,0,0,0);
   ObjectSetText("R2 label","Fib R2",fontsize,"Arial",FontColor);
   ObjectCreate("R3 label",OBJ_TEXT,0,0,0);
   ObjectSetText("R3 label","Fib R3",fontsize,"Arial",FontColor);
   ObjectCreate("S1 label",OBJ_TEXT,0,0,0);
   ObjectSetText("S1 label","Fib S1",fontsize,"Arial",FontColor);
   ObjectCreate("S2 label",OBJ_TEXT,0,0,0);
   ObjectSetText("S2 label","Fib S2",fontsize,"Arial",FontColor);
   ObjectCreate("S3 label",OBJ_TEXT,0,0,0);
   ObjectSetText("S3 label","Fib S3",fontsize,"Arial",FontColor);
//---- Set lines on chart window
   ObjectCreate("S1 line",OBJ_HLINE,0,0,0);
   ObjectSet("S1 line",OBJPROP_STYLE,STYLE_DASHDOTDOT);
   ObjectSet("S1 line",OBJPROP_COLOR,FibColor);
   ObjectCreate("S2 line",OBJ_HLINE,0,0,0);
   ObjectSet("S2 line",OBJPROP_STYLE,STYLE_DASHDOTDOT);
   ObjectSet("S2 line",OBJPROP_COLOR,FibColor);
   ObjectCreate("S3 line",OBJ_HLINE,0,0,0);
   ObjectSet("S3 line",OBJPROP_STYLE,STYLE_DASHDOTDOT);
   ObjectSet("S3 line",OBJPROP_COLOR,FibColor);
   ObjectCreate("R1 line",OBJ_HLINE,0,0,0);
   ObjectSet("R1 line",OBJPROP_STYLE,STYLE_DASHDOTDOT);
   ObjectSet("R1 line",OBJPROP_COLOR,FibColor);
   ObjectCreate("R2 line",OBJ_HLINE,0,0,0);
   ObjectSet("R2 line",OBJPROP_STYLE,STYLE_DASHDOTDOT);
   ObjectSet("R2 line",OBJPROP_COLOR,FibColor);
   ObjectCreate("R3 line",OBJ_HLINE,0,0,0);
   ObjectSet("R3 line",OBJPROP_STYLE,STYLE_DASHDOTDOT);
   ObjectSet("R3 line",OBJPROP_COLOR,FibColor);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CalculateFibs()
  {
// Calculate Fib
   if(Fibs || Pivot)
     {
      yesterday_high=iHigh(NULL,PERIOD_D1,1);
      yesterday_low=iLow(NULL,PERIOD_D1,1);
      yesterday_close=iClose(NULL,PERIOD_D1,1);
      R=yesterday_high-yesterday_low;//range
      p=(yesterday_high+yesterday_low+yesterday_close)/3;// Standard Pivot
      r1 = p + (R * 0.38);
      r2 = p + (R * 0.62);
      r3 = p + (R * 0.99);
      s1 = p - (R * 0.38);
      s2 = p - (R * 0.62);
      s3 = p - (R * 0.99);
      //----
      if(Fibs)
        {
         ObjectMove("R1 label",0,Time[20],r1);
         ObjectMove("R2 label",0,Time[20],r2);
         ObjectMove("R3 label",0,Time[20],r3);
         ObjectMove("S1 label",0,Time[20],s1);
         ObjectMove("S2 label",0,Time[20],s2);
         ObjectMove("S3 label",0,Time[20],s3);
         //---- Set lines on chart window
         ObjectMove("S1 line",0,Time[40],s1);
         ObjectMove("S2 line",0,Time[40],s2);
         ObjectMove("S3 line",0,Time[40],s3);
         ObjectMove("R1 line",0,Time[40],r1);
         ObjectMove("R2 line",0,Time[40],r2);
         ObjectMove("R3 line",0,Time[40],r3);
        }
      //      if (Pivot) ObjectMove("P label", 0, Time[20], p);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int DoAlerts()
  {
   DifAboveH3 = Close[0] - H3;
   DifBelowH3 = H3 - Close[0];
   DifAboveH4 = Close[0] - H4;
   DifBelowH4 = H4 - Close[0];
   DifAboveL3 = Close[0] - L3;
   DifBelowL3 = L3 - Close[0];
   DifAboveL4 = Close[0] - L4;
   DifBelowL4 = L4 - Close[0];
   PipsLimit=PipDistance*Point;
//----  
   if(DifAboveH3>PipsLimit && DifBelowH3>PipsLimit) firstH3=true;
   if(DifAboveH3<=PipsLimit && DifAboveH3>0)
     {
      if(firstH3)
        {
         Alert("Above Cam H3 Line by ",DifAboveH3," for ",Symbol(),"-",Period());
         PlaySound("alert.wav");
         firstH3=false;
        }
     }
   if(DifBelowH3<=PipsLimit && DifBelowH3>0)
     {
      if(firstH3)
        {
         Alert("Below Cam H3 Line by ",DifBelowH3," for ",Symbol(),"-",Period());
         PlaySound("alert.wav");
         firstH3=false;
        }
     }
   if(DifAboveH4>PipsLimit && DifBelowH4>PipsLimit) firstH4=true;
   if(DifAboveH4<=PipsLimit && DifAboveH4>0)
     {
      if(firstH4)
        {
         Alert("Above Cam H4 Line by ",DifAboveH4," for ",Symbol(),"-",Period());
         PlaySound("timeout.wav");
         firstH4=false;
        }
     }
   if(DifBelowH4<=PipsLimit && DifBelowH4>0)
     {
      if(firstH4)
        {
         Alert("Below Cam H4 Line by ",DifBelowH4," for ",Symbol(),"-",Period());
         PlaySound("timeout.wav");
         firstH4=false;
        }
     }
   if(DifAboveL3>PipsLimit && DifBelowL3>PipsLimit) firstL3=true;
   if(DifAboveL3<=PipsLimit && DifAboveL3>0)
     {
      if(firstL3)
        {
         Alert("Above Cam L3 Line by ",DifAboveL3," for ",Symbol(),"-",Period());
         PlaySound("alert.wav");
         firstL3=false;
        }
     }
   if(DifBelowL3<=PipsLimit && DifBelowL3>0)
     {
      if(firstL3)
        {
         Alert("Below Cam L3 Line by ",DifBelowL3," for ",Symbol(),"-",Period());
         PlaySound("alert.wav");
         firstL3=false;
        }
     }
   if(DifAboveL4>PipsLimit && DifBelowL4>PipsLimit) firstL4=true;
   if(DifAboveL4<=PipsLimit && DifAboveL4>0)
     {
      if(firstL4)
        {
         Alert("Above Cam L4 Line by ",DifAboveL4," for ",Symbol(),"-",Period());
         PlaySound("timeout.wav");
         firstL4=false;
        }
     }
   if(DifBelowL4<=PipsLimit && DifBelowL4>0)
     {
      if(firstL4)
        {
         Alert("Below Cam L4 Line by ",DifBelowL4," for ",Symbol(),"-",Period());
         PlaySound("timeout.wav");
         firstL4=false;
        }
     }
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   double offset_seconds=GMT_Offset*3600;
   int limit,i;
   datetime LastMoveTime;
//---- indicator calculation
   if(counted_bars==0)
     {
      x=Period();
      if(x>240) return(-1);
      CreateCamLabels();
      if(Fibs) CreateFibLabels();

     }

   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+1;

   for(i=limit; i>=0;i--)
     {
      if(High[i+1]>LastHigh) LastHigh=High[i+1];
      if(Low[i+1]<LastLow) LastLow=Low[i+1];
      if(TimeDay(Time[i]-offset_seconds)!=TimeDay(Time[i+1]-offset_seconds))
        {
         L3 = Close[i+1] - (LastHigh - LastLow)*D3;
         L4 = Close[i+1] - (LastHigh-LastLow)*D4;
         P=NormalizeDouble((LastHigh+LastLow+Close[i+1])/3,4);
         H3 = (LastHigh - LastLow)*D3 +Close[i+1];
         H4 = (LastHigh-LastLow)*D4 + Close[i+1];
         if(LastLow!=0)
           {
            H5 = (LastHigh/LastLow) * Close[i+1];
            L5 = Close[i+1] - (LastHigh/LastLow)*Close[i+1] + Close[i+1];
           }
         LastLow=Low[i];
         LastHigh=High[i];
         P=NormalizeDouble(P,4);
         L3=NormalizeDouble(L3,4);
         L4=NormalizeDouble(L4,4);
         L5=NormalizeDouble(L5,4);
         H3=NormalizeDouble(H3,4);
         H4=NormalizeDouble(H4,4);
         H5=NormalizeDouble(H5,4);
         //----         
         DeleteCamLabels();
         CreateCamLabels();
         //----
         ObjectMove("L3",0,Time[i],L3);
         ObjectMove("L4",0,Time[i],L4);
         ObjectMove("H3",0,Time[i],H3);
         ObjectMove("H4",0,Time[i],H4);
         if(LastLow!=0)
           {
            ObjectMove("H5",0,Time[i],H5);
            ObjectMove("L5",0,Time[i],L5);
           }
        }
      if(Pivot)
        {
         DeletePivotLabels();
         CreatePivotLabels();
         ObjectMove("P label",0,Time[20],P);
         PBuffer[i]=P;
        }
      H3Buffer[i]=H3;
      H4Buffer[i]=H4;
      H5Buffer[i]=H5;
      L3Buffer[i]=L3;
      L4Buffer[i]=L4;
      L5Buffer[i]=L5;
      LastMoveTime=Time[i];
      if(Fibs || Pivot) CalculateFibs();
     }
// Move Labels for cam lines

   if(CurTime()>LastMoveTime+60)
     {
      ObjectMove("L3",0,CurTime(),L3);
      ObjectMove("L4",0,CurTime(),L4);
      ObjectMove("L5",0,CurTime(),L5);
      ObjectMove("H3",0,CurTime(),H3);
      ObjectMove("H4",0,CurTime(),H4);
      ObjectMove("H5",0,CurTime(),H5);
      LastMoveTime=CurTime();
     }
// Now check for Alert
   if(Alerts) DoAlerts();
//----
   return(0);
  }
//+------------------------------------------------------------------+
