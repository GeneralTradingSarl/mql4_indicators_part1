//+-----------------------------------------------------------+
//|       CCI of Moving Average with Dynamic Signal Lines.mq4 |
//+-----------------------------------------------------------+
#property description "MT4 Code by  Max Michael 2022"
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_label1  "CCI"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrSilver
#property indicator_width1  2
#property indicator_label2  "up level"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrLimeGreen
#property indicator_style2  STYLE_DOT
#property indicator_width2  1
#property indicator_label3  "down level"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrOrange
#property indicator_style3  STYLE_DOT
#property indicator_label4  "prices"
#property indicator_type4   DRAW_NONE
#property indicator_color4  clrBlack
#property strict

extern int                    CCIPeriod = 32;          // CCI period
extern int                     MaPeriod = 14;          // 1=normal CCI
input  ENUM_MA_METHOD          MaMethod = MODE_EMA;    // Average method
input  ENUM_APPLIED_PRICE         Price = PRICE_CLOSE; // Price Mode
input  double              SignalPeriod = 9;           // Dsl signal period
input  int                      MaxBars = 1000;

double alpha;

double cci[], levelUp[], levelDn[], prices[]; 

int init()
{
   SetIndexBuffer(0,cci);     SetIndexEmptyValue(0,0);
   SetIndexBuffer(1,levelUp); SetIndexEmptyValue(1,0);
   SetIndexBuffer(2,levelDn); SetIndexEmptyValue(2,0);
   SetIndexBuffer(3,prices);  SetIndexLabel(3,"");
   IndicatorShortName("CCI of MA ("+(string)CCIPeriod+","+(string)MaPeriod+","+(string)SignalPeriod+")");
   MaPeriod = MaPeriod>0 ? MaPeriod : 1;
   alpha = 2.0/(1.0+MathMax(SignalPeriod,1.0));
   IndicatorDigits(2);
   return(0);
}

int start()
{
   int counted_bars=IndicatorCounted();
   if (counted_bars<0) return(-1);
   if (counted_bars>0) counted_bars--;
   int limit = Bars-counted_bars-1;
   if (limit>MaxBars) limit=MaxBars;
   int i,k;
   
   for( i=limit,k; i>=0; i--)
   {
      prices[i] = iMA(NULL,0, MaPeriod ,0,MaMethod,Price,i);
      // Calculate CCI - Commodity Channel Index
      if (i < MaxBars-CCIPeriod) // begin when enough prices
      {
         double avg=0; for(k=0; k<CCIPeriod && (i+k)<MaxBars; k++) avg +=         prices[i+k];      avg /= (CCIPeriod);
         double dev=0; for(k=0; k<CCIPeriod && (i+k)<MaxBars; k++) dev += MathAbs(prices[i+k]-avg); dev /= (CCIPeriod);
         cci[i] = (dev!=0) ? (prices[i]-avg)/(0.015*dev) : 0;
      }
   }
   // Signal Period EMA lines
   for( i=limit; i>=0; i--) 
   {
      levelUp[i] = (cci[i] > 0) ? (cci[i]-levelUp[i+1]) * alpha + levelUp[i+1] * (1-alpha) : levelUp[i+1];
      levelDn[i] = (cci[i] < 0) ? (cci[i]-levelDn[i+1]) * alpha + levelDn[i+1] * (1-alpha) : levelDn[i+1];
   }
   return(0);
}
