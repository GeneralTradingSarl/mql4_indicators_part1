//+------------------------------------------------------------------+
//|                                            Cauchy derivative.mq4 |
//|                                               Yuriy Tokman (YTG) |
//|                                               http://ytg.com.ua/ |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman (YTG)"
#property link      "http://ytg.com.ua/"
#property version   "1.00"
#property strict
#property indicator_separate_window

#property indicator_buffers 1
#property indicator_color1 clrDarkViolet
#property indicator_width1 2

input int period=13;
//---- buffers
double ExtMapBuffer1[];
string name="";
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   name="Cauchy derivative("+DoubleToStr(period,0)+")";
   IndicatorShortName(name);

   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexLabel(0,name);
   SetIndexDrawBegin(0,period);

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
//---
   int limit=rates_total-prev_calculated;
   if(prev_calculated==0)limit--;
   else  limit++;
   if(limit==rates_total-1)limit=rates_total-period-1;

   for(int i=0; i<limit && !IsStopped(); i++)

      ExtMapBuffer1[i]=(MA(i)-MG(i)) -(MA(i+1)-MG(i+1));

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
double PC(int _i=0)
  {
   double pc=0;
   pc=((High[_i]+Open[_i]+Close[_i]+Low[_i])/4)/Point;
   return(pc);
  }
//----
double MA(int _i=0)
  {
   double ar= 0;
   for(int i=_i; i<_i+period; i++)
     {
      ar+=PC(i);
     }
   return(ar/period);
  }
//----
double MG(int _i=0)
  {
   double ge= 1;
   for(int i=_i; i<_i+period; i++)
     {
      ge*=PC(i);
     }
   return(MathPow(ge,1.0/period));
  }
//+------------------------------------------------------------------+
