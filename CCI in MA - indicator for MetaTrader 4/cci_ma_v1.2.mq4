//===================================================================================================================================================//
#property copyright   "Copyright 2016-2017, Nikolaos Pantzos"
#property link        "https://www.mql5.com/en/users/pannik"
#property version     "1.2"
#property description "CCI on MA"
#property strict
//===================================================================================================================================================//
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 clrDeepSkyBlue
#property indicator_color2 clrRed
#property indicator_color3 clrYellow
#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2
//===================================================================================================================================================//
input string             MA_Parameters   = "||========== MA Parameters ==========||";
input int                MA_Periods      = 14;
input ENUM_MA_METHOD     MA_Method       = MODE_SMA;
input string             CCI_Parameters  = "||========== CCI Parameters ==========||";
input int                CCI_Periods     = 14;
input ENUM_APPLIED_PRICE CCI_ApliedPrice = PRICE_CLOSE;
input double             CCI_LevelsUP    = 100;
input double             CCI_LevelsDN    = -100;
input string             Show_Parameters = "||========== Show Indicator Parameters ==========||";
extern bool              ReverseSignals  = false;
input int                BarsCount       = 10000;
//===================================================================================================================================================//
double TrendUp[];
double TrendDown[];
double TrendLine[];
double IndicatorLevel[];
double MALevel[];
//===================================================================================================================================================//
int OnInit(void)
  {
//-----------------------------------------------------------------------------------
   IndicatorShortName(WindowExpertName()+"("+DoubleToStr(CCI_Periods,0)+")");
   IndicatorDigits(Digits);
   IndicatorBuffers(5);
//---
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,TrendUp);
   SetIndexLabel(0,"CCI Trend Up");
//---
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,TrendDown);
   SetIndexLabel(1,"CCI Trend Down");
//---
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,TrendLine);
   SetIndexLabel(2,"CCI No Trend");
//---
   SetIndexBuffer(3,IndicatorLevel);
   SetIndexBuffer(4,MALevel);
//-----------------------------------------------------------------------------------
   return(INIT_SUCCEEDED);
//-----------------------------------------------------------------------------------
  }
//===================================================================================================================================================//
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
//-----------------------------------------------------------------------------------
   int i=0;
   int Limit=0;
   int CountedBars=BarsCount;
   if(CountedBars<0) return(-1);
   if(CountedBars>Bars-1) CountedBars=Bars-1;
   if(CountedBars<0) return(-1);
   if(CountedBars>0) CountedBars--;
   Limit=CountedBars;
//-----------------------------------------------------------------------------------
   for(i=Limit; i>=0; i--)
     {
      IndicatorLevel[i]=iCCI(NULL,0,CCI_Periods,CCI_ApliedPrice,i);
      MALevel[i]=iMA(NULL,0,MA_Periods,0,MA_Method,0,i);
      TrendLine[i]=NormalizeDouble(MALevel[i],Digits);
      TrendUp[i]=EMPTY_VALUE;
      TrendDown[i]=EMPTY_VALUE;
      //-----------------------------------------------------------------------------------
      //Normal signals
      if(ReverseSignals==false)
        {
         if(IndicatorLevel[i]>=CCI_LevelsUP)
           {
            TrendLine[i]=EMPTY_VALUE;
            TrendUp[i]=NormalizeDouble(MALevel[i],Digits);
           }
         //-----------------------------------------------------------------------------------
         if(IndicatorLevel[i]<=CCI_LevelsDN)
           {
            TrendLine[i]=EMPTY_VALUE;
            TrendDown[i]=NormalizeDouble(MALevel[i],Digits);
           }
         //-----------------------------------------------------------------------------------
         if((IndicatorLevel[i]>=CCI_LevelsUP) && (IndicatorLevel[i+1]<=CCI_LevelsUP))
           {
            TrendUp[i+1]=NormalizeDouble(MALevel[i+1],Digits);
           }
         //-----------------------------------------------------------------------------------
         if((IndicatorLevel[i]<=CCI_LevelsDN) && (IndicatorLevel[i+1]>=CCI_LevelsDN))
           {
            TrendDown[i+1]=NormalizeDouble(MALevel[i+1],Digits);
           }
        }
      //-----------------------------------------------------------------------------------
      //Reverse signals
      if(ReverseSignals==true)
        {
         if(IndicatorLevel[i]>=CCI_LevelsUP)
           {
            TrendLine[i]=EMPTY_VALUE;
            TrendDown[i]=NormalizeDouble(MALevel[i],Digits);
           }
         //-----------------------------------------------------------------------------------
         if(IndicatorLevel[i]<=CCI_LevelsDN)
           {
            TrendLine[i]=EMPTY_VALUE;
            TrendUp[i]=NormalizeDouble(MALevel[i],Digits);
           }
         //-----------------------------------------------------------------------------------
         if((IndicatorLevel[i]>=CCI_LevelsUP) && (IndicatorLevel[i+1]<=CCI_LevelsUP))
           {
            TrendDown[i+1]=NormalizeDouble(MALevel[i+1],Digits);
           }
         //-----------------------------------------------------------------------------------
         if((IndicatorLevel[i]<=CCI_LevelsDN) && (IndicatorLevel[i+1]>=CCI_LevelsDN))
           {
            TrendUp[i+1]=NormalizeDouble(MALevel[i+1],Digits);
           }
        }
      //-----------------------------------------------------------------------------------
      //Zero signals
      if((IndicatorLevel[i+1]>=CCI_LevelsUP) && (IndicatorLevel[i]<=CCI_LevelsUP))
        {
         TrendLine[i+1]=NormalizeDouble(MALevel[i+1],Digits);
        }
      //-----------------------------------------------------------------------------------
      if((IndicatorLevel[i+1]<=CCI_LevelsDN) && (IndicatorLevel[i]>=CCI_LevelsDN))
        {
         TrendLine[i+1]=NormalizeDouble(MALevel[i+1],Digits);
        }
      //-----------------------------------------------------------------------------------
     }
//-----------------------------------------------------------------------------------
   return(rates_total);
//-----------------------------------------------------------------------------------
  }
//===================================================================================================================================================//
