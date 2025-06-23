//------------------------------------------------------------------
#property copyright "mladen"
#property link      "mladenfx@gmail.com"
#property link      "www.forex-station.com"
//------------------------------------------------------------------
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1  clrLimeGreen
#property indicator_color2  clrOrangeRed
#property indicator_width1  2
#property indicator_width2  2
#property strict

//
//
//
//
//

enum enPrices
{
   pr_close,      // Close
   pr_open,       // Open
   pr_high,       // High
   pr_low,        // Low
   pr_median,     // Median
   pr_typical,    // Typical
   pr_weighted,   // Weighted
   pr_average,    // Average (high+low+open+close)/4
   pr_medianb,    // Average median body (open+close)/2
   pr_tbiased,    // Trend biased price
   pr_tbiased2,   // Trend biased (extreme) price
   pr_haclose,    // Heiken ashi close
   pr_haopen ,    // Heiken ashi open
   pr_hahigh,     // Heiken ashi high
   pr_halow,      // Heiken ashi low
   pr_hamedian,   // Heiken ashi median
   pr_hatypical,  // Heiken ashi typical
   pr_haweighted, // Heiken ashi weighted
   pr_haaverage,  // Heiken ashi average
   pr_hamedianb,  // Heiken ashi median body
   pr_hatbiased,  // Heiken ashi trend biased price
   pr_hatbiased2  // Heiken ashi trend biased (extreme) price
};
enum enColorOn
{
   chg_onZero,   // Change color on zero cross
   chg_onOuter,  // Change color on levels cross
   chg_onOuter2, // Change color on opposite levels cross
   chg_onSlope   // Change color on slope change
};
input  int             DspPeriod    = 14;          // DSP period
input  enPrices        Price        = pr_median;   // DSP price
extern int             SignalPeriod = 9;           // Signal period
input  enColorOn       ColorOn      = chg_onOuter; // Change color on :

double val[],histu[],histd[],levelu[],leveld[],state[];

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

int OnInit()
{
   IndicatorBuffers(6);
      SetIndexBuffer( 0, histu); SetIndexStyle(0,DRAW_HISTOGRAM);
      SetIndexBuffer( 1, histd); SetIndexStyle(1,DRAW_HISTOGRAM);
      SetIndexBuffer( 2, val); 
      SetIndexBuffer( 3, levelu);
      SetIndexBuffer( 4, leveld);
      SetIndexBuffer( 5, state); 
   IndicatorShortName("DSP bars ("+(string)DspPeriod+")");
   return(0);
}
void OnDeinit(const int reason) { }
//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double   &open[],
                const double   &high[],
                const double   &low[],
                const double   &close[],
                const long     &tick_volume[],
                const long     &volume[],
                const int      &spread[])
{
   int counted_bars = prev_calculated;
      if(counted_bars < 0) return(-1);
      if(counted_bars > 0) counted_bars--;
         int limit=MathMin(rates_total-counted_bars,rates_total-1);
         
   //
   //
   //
   //
   //

   double alphas = 2.0/(1.0+SignalPeriod);
   double alpham = 2.0/(1.0+DspPeriod);
   for(int i=limit; i>=0 && !_StopFlag; i--)
   {
      double price = getPrice(Price,open,close,high,low,i,rates_total);
         val[i]    = iEma(price,alpham,i,rates_total,0)-iEma(price,alpham/2.0,i,rates_total,1);
         levelu[i] = (i<Bars-1) ? (val[i]>0) ? levelu[i+1]+alphas*(val[i]-levelu[i+1]) : levelu[i+1] : 0;
         leveld[i] = (i<Bars-1) ? (val[i]<0) ? leveld[i+1]+alphas*(val[i]-leveld[i+1]) : leveld[i+1] : 0;
                switch(ColorOn)
                {
                  case chg_onOuter  : state[i] = (val[i]>levelu[i]) ? 1 : (val[i]<leveld[i]) ? -1 : 0;                                 break;
                  case chg_onOuter2 : state[i] = (val[i]>levelu[i]) ? 1 : (val[i]<leveld[i]) ? -1 : (i<rates_total-1) ? state[i+1]: 0; break;
                  case chg_onZero   : state[i] = (val[i]>0)         ? 1 : (val[i]<0)         ? -1 : 0;                                 break;
                  default :           state[i] = (i<rates_total-1) ? (val[i]>val[i+1]) ? 1 : (val[i]<val[i+1]) ? -1 : state[i+1] : 0;
                }
         histu[i] = EMPTY_VALUE; histd[i] = EMPTY_VALUE;                
         if (state[i] ==  1) { histu[i] = high[i]; histd[i] = low[i]; }
         if (state[i] == -1) { histd[i] = high[i]; histu[i] = low[i]; }
   }
   return(rates_total);
}

//------------------------------------------------------------------
//                                                                  
//------------------------------------------------------------------
//
//
//
//
//

double workEma[][2];
double iEma(double price, double alpha, int r, int _bars, int instanceNo=0)
{
   if (ArrayRange(workEma,0)!= _bars) ArrayResize(workEma,_bars); r=_bars-r-1;

   workEma[r][instanceNo] = price;
   if (r>0 && alpha!=-1)
          workEma[r][instanceNo] = workEma[r-1][instanceNo]+alpha*(price-workEma[r-1][instanceNo]);
   return(workEma[r][instanceNo]);
}

//------------------------------------------------------------------
//
//------------------------------------------------------------------
//
//
//
//
//
//

#define _priceInstances     1
#define _priceInstancesSize 4
double workHa[][_priceInstances*_priceInstancesSize];
double getPrice(int tprice, const double& open[], const double& close[], const double& high[], const double& low[], int i, int bars, int instanceNo=0)
{
  if (tprice>=pr_haclose)
   {
      if (ArrayRange(workHa,0)!= bars) ArrayResize(workHa,bars); instanceNo*=_priceInstancesSize;
         int r = bars-i-1;
         
         //
         //
         //
         //
         //
         
         double haOpen;
         if (r>0)
                haOpen  = (workHa[r-1][instanceNo+2] + workHa[r-1][instanceNo+3])/2.0;
         else   haOpen  = (open[i]+close[i])/2;
         double haClose = (open[i] + high[i] + low[i] + close[i]) / 4.0;
         double haHigh  = MathMax(high[i], MathMax(haOpen,haClose));
         double haLow   = MathMin(low[i] , MathMin(haOpen,haClose));

         if(haOpen  <haClose) { workHa[r][instanceNo+0] = haLow;  workHa[r][instanceNo+1] = haHigh; } 
         else                 { workHa[r][instanceNo+0] = haHigh; workHa[r][instanceNo+1] = haLow;  } 
                                workHa[r][instanceNo+2] = haOpen;
                                workHa[r][instanceNo+3] = haClose;
         //
         //
         //
         //
         //
         
         switch (tprice)
         {
            case pr_haclose:     return(haClose);
            case pr_haopen:      return(haOpen);
            case pr_hahigh:      return(haHigh);
            case pr_halow:       return(haLow);
            case pr_hamedian:    return((haHigh+haLow)/2.0);
            case pr_hamedianb:   return((haOpen+haClose)/2.0);
            case pr_hatypical:   return((haHigh+haLow+haClose)/3.0);
            case pr_haweighted:  return((haHigh+haLow+haClose+haClose)/4.0);
            case pr_haaverage:   return((haHigh+haLow+haClose+haOpen)/4.0);
            case pr_hatbiased:
               if (haClose>haOpen)
                     return((haHigh+haClose)/2.0);
               else  return((haLow+haClose)/2.0);        
            case pr_hatbiased2:
               if (haClose>haOpen)  return(haHigh);
               if (haClose<haOpen)  return(haLow);
                                    return(haClose);        
         }
   }
   
   //
   //
   //
   //
   //
   
   switch (tprice)
   {
      case pr_close:     return(close[i]);
      case pr_open:      return(open[i]);
      case pr_high:      return(high[i]);
      case pr_low:       return(low[i]);
      case pr_median:    return((high[i]+low[i])/2.0);
      case pr_medianb:   return((open[i]+close[i])/2.0);
      case pr_typical:   return((high[i]+low[i]+close[i])/3.0);
      case pr_weighted:  return((high[i]+low[i]+close[i]+close[i])/4.0);
      case pr_average:   return((high[i]+low[i]+close[i]+open[i])/4.0);
      case pr_tbiased:   
               if (close[i]>open[i])
                     return((high[i]+close[i])/2.0);
               else  return((low[i]+close[i])/2.0);        
      case pr_tbiased2:   
               if (close[i]>open[i]) return(high[i]);
               if (close[i]<open[i]) return(low[i]);
                                     return(close[i]);        
   }
   return(0);
}   