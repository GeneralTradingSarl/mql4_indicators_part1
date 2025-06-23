//+------------------------------------------------------------------+
//|                                              AlligatorSignal.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 5
#property indicator_plots   5
//--- plot Alligator_jaw
#property indicator_label1  "AlligatorJaw"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot AlligatorTeeth
#property indicator_label2  "AlligatorTeeth"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot AlligatorLips
#property indicator_label3  "AlligatorLips"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrGreen
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- plot ArrowBuy
#property indicator_label4  "ArrowBuy"
#property indicator_type4   DRAW_ARROW
#property indicator_color4  clrRed
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1
//--- plot ArrowSell
#property indicator_label5  "ArrowSell"
#property indicator_type5   DRAW_ARROW
#property indicator_color5  clrBlue
#property indicator_style5  STYLE_SOLID
#property indicator_width5  1
//--- input parameters
input int      InpJawPeriod=8;// Jaws Period
input int      InpJawShift=0;// Jaws Shift
input int      InpTeethPeriod=5;// Teeth Period
input int      InpTeethShift=0;// Teeth Shift
input int      InpLipsPeriod=3;// Lips Period
input int      InpLipsShift=0;// Lips Shift
input int      InpMaPeriod=3;//averaging period 
input ENUM_MA_METHOD      InpMaMethod=MODE_EMA;// method of averaging of the Alligator lines 
input ENUM_APPLIED_PRICE      InpAppliedPrice=PRICE_WEIGHTED;// type of price used for calculation of Alligator 
input double      InpForceFilte=0.35;
//--- indicator buffers
double         AlligatorJawBuffer[];
double         AlligatorTeethBuffer[];
double         AlligatorLipsBuffer[];
double         ArrowBuyBuffer[];
double         ArrowSellBuffer[];
string         AlligatorSignalBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,AlligatorJawBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,AlligatorTeethBuffer,INDICATOR_DATA);
   SetIndexBuffer(2,AlligatorLipsBuffer,INDICATOR_DATA);
   SetIndexBuffer(3,ArrowBuyBuffer,INDICATOR_DATA);
   SetIndexBuffer(4,ArrowSellBuffer,INDICATOR_DATA);
//--- Define the symbol code for drawing in PLOT_ARROW 
   SetIndexArrow(3,241);
   SetIndexArrow(4,242);
//--- name for DataWindow and indicator subwindow label
   string short_name="AlligatorSignal("+IntegerToString(InpJawPeriod)+","+IntegerToString(InpTeethPeriod)+","+IntegerToString(InpLipsPeriod)+")";
   IndicatorShortName(short_name);

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,// size of input time series 
                const int prev_calculated,// bars handled in previous call 
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//--- Get the number of bars available for the current symbol and chart period 
/*
   int bars=Bars(Symbol(),0);
   Print("Bars = ",bars,", rates_total = ",rates_total,",  prev_calculated = ",prev_calculated);
   Print("time[0] = ",time[0]," time[rates_total-1] = ",time[rates_total-1]);
   */
   int limit=rates_total-1;
   ArrayResize(AlligatorSignalBuffer,rates_total,10);
//ArrayFill(AlligatorSignalBuffer,0,rates_total,"N/A");
   for(int i=0;  i<limit;i++)
     {
      AlligatorJawBuffer[i]=NormalizeDouble(iAlligator(NULL,NULL,
                                            InpJawPeriod,InpJawShift,InpTeethPeriod,InpTeethShift,InpLipsPeriod,InpLipsShift,
                                            InpMaMethod,InpAppliedPrice,MODE_GATORJAW,i
                                            ),Digits);
      AlligatorTeethBuffer[i]=NormalizeDouble(iAlligator(NULL,NULL,
                                              InpJawPeriod,InpJawShift,InpTeethPeriod,InpTeethShift,InpLipsPeriod,InpLipsShift,
                                              InpMaMethod,InpAppliedPrice,MODE_GATORTEETH,i
                                              ),Digits);
      AlligatorLipsBuffer[i]=NormalizeDouble(iAlligator(NULL,NULL,
                                             InpJawPeriod,InpJawShift,InpTeethPeriod,InpTeethShift,InpLipsPeriod,InpLipsShift,
                                             InpMaMethod,InpAppliedPrice,MODE_GATORLIPS,i
                                             ),Digits);
     }
   for(int i=0;  i<limit;i++)
     {
      double Force=NormalizeDouble(iForce(NULL,NULL,InpMaPeriod,InpMaMethod,InpAppliedPrice,i),Digits);

      string AlligatorSignal="N/A";

      if(AlligatorJawBuffer[i]>AlligatorTeethBuffer[i] && AlligatorLipsBuffer[i+1]<=AlligatorTeethBuffer[i+1])
        {
         AlligatorSignal="UpCross";
        }

      if(AlligatorJawBuffer[i]<AlligatorTeethBuffer[i] && AlligatorLipsBuffer[i+1]>=AlligatorTeethBuffer[i+1])
        {
         AlligatorSignal="DownCross";
        }

      if(AlligatorLipsBuffer[i]>AlligatorTeethBuffer[i] && AlligatorTeethBuffer[i]>AlligatorJawBuffer[i])
        {
         AlligatorSignal="Rise";
        }

      if(AlligatorLipsBuffer[i]<AlligatorTeethBuffer[i] && AlligatorTeethBuffer[i]<AlligatorJawBuffer[i])
        {
         AlligatorSignal="Fall";
        }

      if(Force>InpForceFilte && AlligatorSignal=="Rise")
        {
         AlligatorSignal="Buy";
        }
      if(Force<InpForceFilte && AlligatorSignal=="Fall")
        {
         AlligatorSignal="Sell";
        }
      AlligatorSignalBuffer[i]=AlligatorSignal;
      if(AlligatorSignalBuffer[i]=="Buy")
        {
         ArrowBuyBuffer[i]=low[i]-0.00050;
        }
      if(AlligatorSignalBuffer[i]=="Sell")
        {
         ArrowSellBuffer[i]=high[i]+0.00050;
        }
     }
//--- return value of prev_calculated for next call 
   return(rates_total);
  }
//+------------------------------------------------------------------+
