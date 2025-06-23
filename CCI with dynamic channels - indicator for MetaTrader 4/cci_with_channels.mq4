#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 5
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrDeepSkyBlue
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrYellow
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrDeepSkyBlue
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrYellow
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrRed
#property indicator_width5  2

input int                inpCCIPeriod        = 14;          // CCI period
input ENUM_APPLIED_PRICE inpCCIPrice         = PRICE_CLOSE; // CCI price

input int                inpSmoothing        = 14;          // Smoothing period for CCI
input double             inpOverbought       = 150;         // Overbought level %
input double             inpOversold         = -150;        // Oversold level %
input double             inpUpperNeutral     = 90;          // Upper neutral level %
input double             inpLowerNeutral     = -90;         // Lower neutral level %

double bupu[],bupd[],bdnu[],bdnd[],cci[];
//+------------------------------------------------------------------+
int OnInit() {
   SetIndexBuffer(0,bupu,INDICATOR_DATA);
   SetIndexBuffer(1,bupd,INDICATOR_DATA);
   SetIndexBuffer(2,bdnu,INDICATOR_DATA);
   SetIndexBuffer(3,bdnd,INDICATOR_DATA);
   SetIndexBuffer(4,cci,INDICATOR_DATA);
   return(INIT_SUCCEEDED);
}
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
                const int &spread[]) {
   
   int limit = prev_calculated>0 ? rates_total - prev_calculated + 1 : rates_total - 1;
   
   for(int i=limit;i>=0;i--) {
      cci[i] = iCCI(NULL,PERIOD_CURRENT,inpCCIPeriod,inpCCIPrice,i);
      double _cci = (cci[i]!=EMPTY_VALUE) ? cci[i] : 0;
      /* 
      bupu[i]     = iEma(_rsi-inpOverbought  ,inpSmoothing,index,0);
      bdnu[i]     = iEma(_rsi-inpOversold    ,inpSmoothing,index,1);
      bupd[i]     = iEma(_rsi-inpUpperNeutral,inpSmoothing,index,2);
      bdnd[i]     = iEma(_rsi-inpLowerNeutral,inpSmoothing,index,3);
      */
      double pr=2.0/(inpSmoothing+1.0);
      //bupu[i]     = (_rsi-inpOverbought) * pr + bupu[i+1]*(1-pr);
      if(i<rates_total-1) {
         bupu[i]     = (_cci-inpOverbought) * pr + bupu[i+1]*(1-pr);
         bdnu[i]     = (_cci-inpOversold) * pr + bdnu[i+1]*(1-pr);
         bupd[i]     = (_cci-inpUpperNeutral) * pr + bupd[i+1]*(1-pr);
         bdnd[i]     = (_cci-inpLowerNeutral) * pr + bdnd[i+1]*(1-pr);
      }else{
         bupu[i]     = (_cci-inpOverbought);
         bdnu[i]     = (_cci-inpOversold);
         bupd[i]     = (_cci-inpUpperNeutral);
         bdnd[i]     = (_cci-inpLowerNeutral);
      }
   }
   return(rates_total);
}
//+------------------------------------------------------------------+
#define _emaInstances 4
#define _emaRingSize 6
double workEma[_emaRingSize][_emaInstances];
//
//---
//


double iEma(double price, double period,int i, int _inst=0)
{
   int _indCurrent = (i  )%_emaRingSize;
   int _indPrevious = (i-1)%_emaRingSize;

   if(i>0 && period>1)
      workEma[_indCurrent][_inst] = workEma[_indPrevious][_inst] + (2.0/(1.0+period)) * (price-workEma[_indPrevious][_inst]);
   else   workEma[_indCurrent][_inst]=price;
   return(workEma[_indCurrent][_inst]);
}