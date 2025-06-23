//+------------------------------------------------------------------+
//|                                                          CMA.mq4 |
//|                                       Copyright 2020, PuguForex. |
//|                             https://www.mql5.com/users/puguforex |
//|                                         NRP color code by Mladen |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, PuguForex."
#property link      "https://www.mql5.com/users/puguforex"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 4

#property indicator_color1 clrSilver
#property indicator_width1 1
#property indicator_style1 STYLE_DOT
#property indicator_type1  DRAW_LINE
#property indicator_label1 "Moving average"

#property indicator_color2 clrLimeGreen
#property indicator_width2 3
#property indicator_style2 STYLE_SOLID
#property indicator_type2  DRAW_LINE
#property indicator_label2 "CMA"

#property indicator_color3 clrRed
#property indicator_width3 3
#property indicator_style3 STYLE_SOLID
#property indicator_type3  DRAW_LINE
#property indicator_label3 "Slope down"

#property indicator_color4 clrRed
#property indicator_width4 3
#property indicator_style4 STYLE_SOLID
#property indicator_type4  DRAW_LINE
#property indicator_label4 "Slope up"

input int inpPeriod = 14;                        //Period
input ENUM_APPLIED_PRICE inpPrice = PRICE_CLOSE; //Price
input ENUM_MA_METHOD inpMethod = MODE_SMA;       //Method

double ma[],cma[],up[],dn[],trend[];    
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   IndicatorBuffers(5);
//--- indicator buffers mapping
      SetIndexBuffer(0,ma,INDICATOR_DATA);
      SetIndexBuffer(1,cma,INDICATOR_DATA);
      SetIndexBuffer(2,up,INDICATOR_DATA);
      SetIndexBuffer(3,dn,INDICATOR_DATA);
      SetIndexBuffer(4,trend,INDICATOR_CALCULATIONS);
//---
   IndicatorSetString(INDICATOR_SHORTNAME,"CMA("+(string)inpPeriod+")");
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
   if (rates_total<inpPeriod) return(0);
   if (IsStopped()) return(0);
   int start = (prev_calculated==0) ? rates_total-inpPeriod-1 : rates_total-prev_calculated;
//---
   if (trend[start]==-1) iCleanPoint(start,rates_total,up,dn);
   for (int i=start; i>=0 && !IsStopped(); i--)
   {
       ma[i] = iMA(Symbol(),Period(),inpPeriod,0,inpMethod,inpPrice,i);
       
       double deviation = iStdDev(Symbol(),Period(),inpPeriod,0,inpMethod,inpPrice,i)/_Point;
       double error     = (cma[i+1]-ma[i])/_Point;
       
       double variance  = MathPow(deviation,2);
       double sqrerror  = MathPow(error,2);
       double gain      = (variance==0||sqrerror==0) ? 1 : sqrt(sqrerror/(variance+sqrerror));
       
   //---   
       static double tolerance = MathPow(10,-5);
       double err   = 1;
       double kPrev = 1;
       double k     = 1;
       
   //Calculate gain factor
       while (err > tolerance)
         {
          k     = gain * kPrev * (2 - kPrev);
          err   = kPrev - k;
          kPrev = k;
         }
       
       cma[i]    = cma[i+1]+k*(ma[i]-cma[i+1]);
       trend[i]  = cma[i]>cma[i+1] ? 1 : cma[i]<cma[i+1] ? -1 : trend[i+1];
       up[i]     = EMPTY_VALUE;
       dn[i]     = EMPTY_VALUE;
       if (trend[i]==-1) iPlotPoint(i,rates_total,up,dn,cma);   
   }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//
//
//
//

void iCleanPoint(int i, int bars, double& first[], double& second[])
{
   if (i>=bars-3) return;
   if ((second[i]  != EMPTY_VALUE) && (second[i+1] != EMPTY_VALUE))
        second[i+1] = EMPTY_VALUE;
   else
      if ((first[i] != EMPTY_VALUE) && (first[i+1] != EMPTY_VALUE) && (first[i+2] == EMPTY_VALUE))
          first[i+1] = EMPTY_VALUE;
}
void iPlotPoint(int i, int bars, double& first[], double& second[], double& from[])
{
   if (i>=bars-2) return;
   if (first[i+1] == EMPTY_VALUE)
      if (first[i+2] == EMPTY_VALUE)
            { first[i]  = from[i];  first[i+1]  = from[i+1]; second[i] = EMPTY_VALUE; }
      else  { second[i] =  from[i]; second[i+1] = from[i+1]; first[i]  = EMPTY_VALUE; }
   else     { first[i]  = from[i];                           second[i] = EMPTY_VALUE; }
}