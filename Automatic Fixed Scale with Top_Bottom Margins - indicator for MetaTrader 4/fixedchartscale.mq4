//+------------------------------------------------------------------+
//|                                                   ChartScale.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.06"
#property strict
#property indicator_chart_window
//--- input parameters
input double      HeadMargin=20.0;
input double      TailMargin=20.0;
//input double      PipScale=0;
double pip1=1/pow(10,Digits-1);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum onoff
  {
   ON, // On
   OFF // Off
  };
input onoff ascr=ON; // "Smart" Auto-Scroll
input onoff atrR=OFF;  // ATR Range
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   IndicatorShortName(NULL);
   ChartSetInteger(0,CHART_SCALEFIX,true);

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
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,         // Event ID
                  const long& lparam,   // Parameter of type long event
                  const double& dparam, // Parameter of type double event
                  const string& sparam  // Parameter of type string events
                  )
  {
   int pos,xpos;
   double priceHigh,priceLow,priceMax,priceMin,priceRange,headClose,midRange;

   bool cshift=ChartGetInteger(0,CHART_SHIFT,0);

   xpos=(int)(WindowBarsPerChart()*ChartShiftSizeGet()/100);
   if(cshift==true) pos=WindowFirstVisibleBar()+xpos-WindowBarsPerChart(); // Chart position for AutoScroll On/Off
   else pos=WindowFirstVisibleBar()-WindowBarsPerChart();                  // Check for chart shift

   if(ascr==ON)
     {
      if(pos>0) ChartSetInteger(0,CHART_AUTOSCROLL,false);                    // If chart scrolled backwards switch off Autoscroll
      else ChartSetInteger(0,CHART_AUTOSCROLL,true);                          // if chart at front switch Autoscroll on
     }
//---   
   int bars_count=WindowBarsPerChart();
   int bar=WindowFirstVisibleBar();

   priceHigh= High[bar];
   priceLow = Low[bar];

   for(int i=0; i<bars_count; i++,bar--) // Find High/Low price on visible chart
     {
      if(bar>=0)
        {
         if(High[bar]>priceHigh) priceHigh=High[bar];
         if(Low[bar]<priceLow) priceLow=Low[bar];
        }
     }

   if(pos<1) pos=1;

   if(atrR==ON) priceRange=iATR(NULL,PERIOD_D1,14,0);
   else priceRange=0;
//double Rmul=1/sqrt(Period()+5);
//Rmul=Rmul<1?1:Rmul;                                          // Visible price range
//priceRange*=Rmul;

   if(priceHigh-priceLow>priceRange) priceRange=priceHigh-priceLow;

   headClose=(Close[0]+iMA(NULL,0,3,0,MODE_SMMA,PRICE_MEDIAN,pos))/2;
   midRange=(priceHigh+priceLow)/2;

   if(headClose>=midRange)
     {
      priceMax=priceHigh+priceRange*(HeadMargin/100.0);                     // Calculate top margin
      priceMin=priceLow-priceRange*(TailMargin/100.0);                      // Calculate bottom margin
     }
   else
     {
      priceMax=priceHigh+priceRange*(TailMargin/100.0);                     // Calculate top margin
      priceMin=priceLow-priceRange*(HeadMargin/100.0);                      // Calculate bottom margin
     }

//priceMax=priceHigh+Rmul*50*pip1;
//priceMin=priceLow-Rmul*50*pip1;
   ChartSetDouble(0,CHART_FIXED_MAX,priceMax);                             // Set top margin
   ChartSetDouble(0,CHART_FIXED_MIN,priceMin);                             // Set bottom margin

   ChartRedraw();
  }
//+------------------------------------------------------------------+
//| The function receives shift size of the zero bar from the right  |
//| border of the chart in percentage values (from 10% up to 50%).   |
//+------------------------------------------------------------------+
double ChartShiftSizeGet(const long chart_ID=0)
  {
//--- prepare the variable to get the result
   double result=EMPTY_VALUE;
//--- reset the error value
   ResetLastError();
//--- receive the property value
   if(!ChartGetDouble(chart_ID,CHART_SHIFT_SIZE,0,result))
     {
      //--- display the error message in Experts journal
      Print(__FUNCTION__+", Error Code = ",GetLastError());
     }
//--- return the value of the chart property
   return(result);
  }
//+------------------------------------------------------------------+
