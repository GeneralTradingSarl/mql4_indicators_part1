//------------------------------------------------------------------
#property copyright "mladen"
#property link      "mladenfx@gmail.com"
#property link      "www.forex-station.com"
//------------------------------------------------------------------
#property indicator_separate_window
#property indicator_buffers 7
#property indicator_color1  clrDimGray
#property indicator_color2  clrDimGray
#property indicator_color3  clrDarkGray
#property indicator_color4  clrLimeGreen
#property indicator_color5  clrLimeGreen
#property indicator_color6  clrOrangeRed
#property indicator_color7  clrOrangeRed
#property indicator_style1  STYLE_DOT
#property indicator_style2  STYLE_DOT
#property indicator_width3  2
#property indicator_width4  3
#property indicator_width5  3
#property indicator_width6  3
#property indicator_width7  3
#property strict

//
//
//
//
//

enum enMaTypes
{
   ma_sma,    // Simple moving average
   ma_ema,    // Exponential moving average
   ma_smma,   // Smoothed MA
   ma_lwma    // Linear weighted MA
};
enum enColorOn
{
   chg_onZero,  // Change color on zero cross
   chg_onOuter, // Change color on levels cross
   chg_onSlope  // Change color on slope change
};
input  int             DmiPeriod         = 32;             // DMI period
input  enMaTypes       DmiMaMethod       = ma_smma;        // DMI smoothing method
input  int             Smooth            = 0;              // Smothing period (<=1 for no smoothing)
input  enMaTypes       SmoothType        = ma_ema;         // Smothing method
extern int             SignalPeriod      = 9;              // Signal period
input  enColorOn       ColorOn           = chg_onOuter;    // Change color on :

double stoch[],stochua[],stochub[],stochda[],stochdb[],levelu[],leveld[],state[];

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
   IndicatorBuffers(8);
      SetIndexBuffer( 0, levelu);
      SetIndexBuffer( 1, leveld);
      SetIndexBuffer( 2, stoch); 
      SetIndexBuffer( 3, stochua); 
      SetIndexBuffer( 4, stochub); 
      SetIndexBuffer( 5, stochda); 
      SetIndexBuffer( 6, stochdb); 
      SetIndexBuffer( 7, state); 
   IndicatorShortName("DMI oscillator ("+(string)DmiPeriod+","+(string)Smooth+")");
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

   double alpha = 2.0/(1.0+SignalPeriod);
   if (state[limit]== 1) CleanPoint(limit,stochua,stochub);
   if (state[limit]==-1) CleanPoint(limit,stochda,stochdb);
   for(int i=limit; i>=0; i--)
   {
      double dhh = (i<rates_total-1) ? high[i]-high[i+1] : 0;
      double dll = (i<rates_total-1) ? low[i+1]-low[i]   : 0;
      double tr  = (i<rates_total-1) ? MathMax(high[i],close[i+1])-MathMin(low[i],close[i+1]) : high[i]-low[i];
      double atr = iCustomMa(DmiMaMethod,tr,DmiPeriod,i,rates_total,0);

         double plusDM    = (dhh>dll && dhh>0) ? dhh : 0;
         double minusDM   = (dll>dhh && dll>0) ? dll : 0;
         double plusDI    = 100*iCustomMa(DmiMaMethod,plusDM ,DmiPeriod,i,rates_total,1)/atr;
         double minusDI   = 100*iCustomMa(DmiMaMethod,minusDM,DmiPeriod,i,rates_total,2)/atr;
                stoch[i]  = iCustomMa(SmoothType,plusDI-minusDI,Smooth,i,rates_total,3);
                levelu[i] = (i<Bars-1) ? (stoch[i]>0) ? levelu[i+1]+alpha*(stoch[i]-levelu[i+1]) : levelu[i+1] : 0;
                leveld[i] = (i<Bars-1) ? (stoch[i]<0) ? leveld[i+1]+alpha*(stoch[i]-leveld[i+1]) : leveld[i+1] : 0;
                switch(ColorOn)
                {
                  case chg_onOuter : state[i] = (stoch[i]>levelu[i]) ? 1 : (stoch[i]<leveld[i]) ? -1 : 0; break;
                  case chg_onZero  : state[i] = (stoch[i]>0)         ? 1 : (stoch[i]<0)         ? -1 : 0; break;
                  default :          state[i] = (i<rates_total-1) ? (stoch[i]>stoch[i+1]) ? 1 : (stoch[i]<stoch[i+1]) ? -1 : state[i+1] : 0;
                }
                stochda[i] = EMPTY_VALUE;
                stochdb[i] = EMPTY_VALUE;
                stochua[i] = EMPTY_VALUE;
                stochub[i] = EMPTY_VALUE;
         if (state[i] ==  1) PlotPoint(i,stochua,stochub,stoch);
         if (state[i] == -1) PlotPoint(i,stochda,stochdb,stoch);
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

#define _maInstances 4
#define _maWorkBufferx1 1*_maInstances
#define _maWorkBufferx2 2*_maInstances

double iCustomMa(int mode, double price, double length, int r, int bars, int instanceNo=0)
{
   r = bars-r-1;
   switch (mode)
   {
      case ma_sma   : return(iSma(price,(int)length,r,bars,instanceNo));
      case ma_ema   : return(iEma(price,length,r,bars,instanceNo));
      case ma_smma  : return(iSmma(price,(int)length,r,bars,instanceNo));
      case ma_lwma  : return(iLwma(price,(int)length,r,bars,instanceNo));
      default       : return(price);
   }
}

//
//
//
//
//

double workSma[][_maWorkBufferx2];
double iSma(double price, int period, int r, int _bars, int instanceNo=0)
{
   if (ArrayRange(workSma,0)!= _bars) ArrayResize(workSma,_bars); instanceNo *= 2; int k;

   workSma[r][instanceNo+0] = price;
   workSma[r][instanceNo+1] = price; for(k=1; k<period && (r-k)>=0; k++) workSma[r][instanceNo+1] += workSma[r-k][instanceNo+0];  
   workSma[r][instanceNo+1] /= 1.0*k;
   return(workSma[r][instanceNo+1]);
}

//
//
//
//
//

double workEma[][_maWorkBufferx1];
double iEma(double price, double period, int r, int _bars, int instanceNo=0)
{
   if (ArrayRange(workEma,0)!= _bars) ArrayResize(workEma,_bars);

   workEma[r][instanceNo] = price;
   if (r>0 && period>1)
          workEma[r][instanceNo] = workEma[r-1][instanceNo]+(2.0/(1.0+period))*(price-workEma[r-1][instanceNo]);
   return(workEma[r][instanceNo]);
}

//
//
//
//
//

double workSmma[][_maWorkBufferx1];
double iSmma(double price, double period, int r, int _bars, int instanceNo=0)
{
   if (ArrayRange(workSmma,0)!= _bars) ArrayResize(workSmma,_bars);

   workSmma[r][instanceNo] = price;
   if (r>1 && period>1)
          workSmma[r][instanceNo] = workSmma[r-1][instanceNo]+(price-workSmma[r-1][instanceNo])/period;
   return(workSmma[r][instanceNo]);
}

//
//
//
//
//

double workLwma[][_maWorkBufferx1];
double iLwma(double price, double period, int r, int _bars, int instanceNo=0)
{
   if (ArrayRange(workLwma,0)!= _bars) ArrayResize(workLwma,_bars);
   
   workLwma[r][instanceNo] = price; if (period<=1) return(price);
      double sumw = period;
      double sum  = period*price;

      for(int k=1; k<period && (r-k)>=0; k++)
      {
         double weight = period-k;
                sumw  += weight;
                sum   += weight*workLwma[r-k][instanceNo];  
      }             
      return(sum/sumw);
}


//-------------------------------------------------------------------
//                                                                  
//-------------------------------------------------------------------
//
//
//
//
//

void CleanPoint(int i,double& first[],double& second[])
{
   if (i>=Bars-3) return;
   if ((second[i]  != EMPTY_VALUE) && (second[i+1] != EMPTY_VALUE))
        second[i+1] = EMPTY_VALUE;
   else
      if ((first[i] != EMPTY_VALUE) && (first[i+1] != EMPTY_VALUE) && (first[i+2] == EMPTY_VALUE))
          first[i+1] = EMPTY_VALUE;
}

void PlotPoint(int i,double& first[],double& second[],double& from[])
{
   if (i>=Bars-2) return;
   if (first[i+1] == EMPTY_VALUE)
      if (first[i+2] == EMPTY_VALUE) 
            { first[i]  = from[i];  first[i+1]  = from[i+1]; second[i] = EMPTY_VALUE; }
      else  { second[i] =  from[i]; second[i+1] = from[i+1]; first[i]  = EMPTY_VALUE; }
   else     { first[i]  = from[i];                           second[i] = EMPTY_VALUE; }
}