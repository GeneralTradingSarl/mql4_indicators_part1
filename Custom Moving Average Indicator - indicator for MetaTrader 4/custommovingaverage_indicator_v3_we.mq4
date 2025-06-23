//+------------------------------------------------------------------+
//|                                       Custom Moving Averages.mq4 |
//|                   Copyright 2011-2016,HPC Sphere Pvt. Ltd. India |
//|                                        https://www.hpcsphere.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2011-2016, HPC Sphere Pvt. Ltd. India"
#property version   "2.00"
#property description "Custom Moving Averages"
#property link "https://www.hpcsphere.com"
#property icon "\\Images\\hpcs_logo.ico"
#property  strict

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red
//--- indicator parameters
extern int            InpMAPeriod=14;        // Period
input int            InpMAShift=0;          // Shift
input ENUM_MA_METHOD InpMAMethod=MODE_SMA;  // Method
input ENUM_APPLIED_PRICE Applied_Price = PRICE_CLOSE;   // Applied Price
//--- indicator buffer
double ExtLineBuffer[];

void func_AlertInvalidPeriod()
{
    if (Bars > 0) {
    if (InpMAPeriod >= Bars) {
    //
        Alert("Custom Moving Averages' Period(" + IntegerToString(InpMAPeriod) + ") is not less than the total number of bars (" 
                + IntegerToString(Bars) + ") on the chart"); 
        InpMAPeriod = 14;
        Alert("Using default \"Period\" value of " + IntegerToString(InpMAPeriod) + " to plot the Custom Moving Averages");
    }}
}
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(void)
  {
   string short_name;
   func_AlertInvalidPeriod();
   int    draw_begin=InpMAPeriod-1;
//--- indicator short name
   switch(InpMAMethod)
     {
      case MODE_SMA  : short_name="SMA(";                break;
      case MODE_EMA  : short_name="EMA(";  draw_begin=0; break;
      case MODE_SMMA : short_name="SMMA(";               break;
      case MODE_LWMA : short_name="LWMA(";               break;
      default :        return(INIT_FAILED);
     }
   IndicatorShortName(short_name+string(InpMAPeriod)+")");
   IndicatorDigits(Digits);
//--- check for input
   if(InpMAPeriod<2)
      return(INIT_FAILED);
//--- drawing settings
   SetIndexStyle(0,DRAW_LINE);
   SetIndexShift(0,InpMAShift);
   SetIndexDrawBegin(0,draw_begin);
//--- indicator buffers mapping
   SetIndexBuffer(0,ExtLineBuffer);
//--- initialization done
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|  Moving Average                                                  |
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
    func_AlertInvalidPeriod();
//--- check for bars count
   if(rates_total<InpMAPeriod-1 || InpMAPeriod<2)
      return(0);
//--- counting from 0 to rates_total
   ArraySetAsSeries(ExtLineBuffer,false);
//--- first calculation or number of bars was changed
   if(prev_calculated==0)
      ArrayInitialize(ExtLineBuffer,0);
//--- calculation
    double arr[];
    double median[];
    double weighted[];
    double typical[];
    ArrayResize(arr,Bars);
    ArrayResize(median,Bars);
    ArrayResize(typical,Bars);
    ArrayResize(weighted,Bars);

  //   ArraySetAsSeries(weighted,false);
    if(Applied_Price == PRICE_CLOSE)
    {       
        ArraySetAsSeries(close,false);
        ArrayCopy(arr,close,0,0,WHOLE_ARRAY);        
    }
    else if(Applied_Price == PRICE_OPEN)
    {       
        ArraySetAsSeries(open,false);
        ArrayCopy(arr,open,0,0,WHOLE_ARRAY);
    }
    else if(Applied_Price == PRICE_HIGH)
    {
        ArraySetAsSeries(high,false);
        ArrayCopy(arr,high,0,0,WHOLE_ARRAY);
    }
    else if(Applied_Price == PRICE_LOW)
    {
        ArraySetAsSeries(low,false);
        ArrayCopy(arr,low,0,0,WHOLE_ARRAY);
    }
    else if(Applied_Price == PRICE_MEDIAN)
    {
        for(int k = 0; k < Bars; k++)
        {
            median[k] =(High[k]+Low[k])/2;
        }
        ArrayCopy(arr,median,0,0,WHOLE_ARRAY);
        ArraySetAsSeries(arr,true);  

    }
    else if(Applied_Price == PRICE_TYPICAL)
    {
        for(int k = 0; k < Bars; k++)
        {
            typical[k] =(High[k]+Low[k]+Close[k])/3;           
        }
        
        ArrayCopy(arr,typical,0,0,WHOLE_ARRAY);
        ArraySetAsSeries(arr,true);  
 
    }
    else if(Applied_Price == PRICE_WEIGHTED)
    {
       
        for(int k = 0; k < Bars ; k++)
        {
            weighted[k] = NormalizeDouble((High[k]+Low[k]+Close[k]+Close[k])/4,Digits);                   
        }
        
        ArrayCopy(arr,weighted,0,0,WHOLE_ARRAY); 
        ArraySetAsSeries(arr,true);  

    }

    switch(InpMAMethod)
     {
      case MODE_EMA:  CalculateEMA(rates_total,prev_calculated,arr);        break;
      case MODE_LWMA: CalculateLWMA(rates_total,prev_calculated,arr);       break;
      case MODE_SMMA: CalculateSmoothedMA(rates_total,prev_calculated,arr); break;
      case MODE_SMA:  CalculateSimpleMA(rates_total,prev_calculated,arr);   break;
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|   simple moving average                                          |
//+------------------------------------------------------------------+
void CalculateSimpleMA(int rates_total,int prev_calculated,const double &price[])
  {
   int i,limit;
//--- first calculation or number of bars was changed
   if(prev_calculated==0)
   
     {
      limit=InpMAPeriod;
      //--- calculate first visible value
      double firstValue=0;
      for(i=0; i<limit; i++)
         firstValue+=price[i];
      firstValue/=InpMAPeriod;
      ExtLineBuffer[limit-1]=firstValue;
     }
   else
      limit=prev_calculated-1;
//--- main loop
   for(i=limit; i<rates_total && !IsStopped(); i++)
      ExtLineBuffer[i]=ExtLineBuffer[i-1]+(price[i]-price[i-InpMAPeriod])/InpMAPeriod;
//---
  }
//+------------------------------------------------------------------+
//|  exponential moving average                                      |
//+------------------------------------------------------------------+
void CalculateEMA(int rates_total,int prev_calculated,const double &price[])
  {
   int    i,limit;
   double SmoothFactor=2.0/(1.0+InpMAPeriod);
//--- first calculation or number of bars was changed
   if(prev_calculated==0)
     {
      limit=InpMAPeriod;
      ExtLineBuffer[0]=price[0];
      for(i=1; i<limit; i++)
         ExtLineBuffer[i]=price[i]*SmoothFactor+ExtLineBuffer[i-1]*(1.0-SmoothFactor);
     }
   else
      limit=prev_calculated-1;
//--- main loop
   for(i=limit; i<rates_total && !IsStopped(); i++)
      ExtLineBuffer[i]=price[i]*SmoothFactor+ExtLineBuffer[i-1]*(1.0-SmoothFactor);
//---
  }
//+------------------------------------------------------------------+
//|  linear weighted moving average                                  |
//+------------------------------------------------------------------+
void CalculateLWMA(int rates_total,int prev_calculated,const double &price[])
  {
   int        i,limit;
   static int weightsum;
   double     sum;
//--- first calculation or number of bars was changed
   if(prev_calculated==0)
     {
      weightsum=0;
      limit=InpMAPeriod;
      //--- calculate first visible value
      double firstValue=0;
      for(i=0;i<limit;i++)
        {
         int k=i+1;
         weightsum+=k;
         firstValue+=k*price[i];
        }
      firstValue/=(double)weightsum;
      ExtLineBuffer[limit-1]=firstValue;
     }
   else
      limit=prev_calculated-1;
//--- main loop
   for(i=limit; i<rates_total && !IsStopped(); i++)
     {
      sum=0;
      for(int j=0;j<InpMAPeriod;j++)
         sum+=(InpMAPeriod-j)*price[i-j];
      ExtLineBuffer[i]=sum/weightsum;
     }
//---
  }
//+------------------------------------------------------------------+
//|  smoothed moving average                                         |
//+------------------------------------------------------------------+
void CalculateSmoothedMA(int rates_total,int prev_calculated,const double &price[])
  {
   int i,limit;
//--- first calculation or number of bars was changed
   if(prev_calculated==0)
     {
      limit=InpMAPeriod;
      double firstValue=0;
      for(i=0; i<limit; i++)
         firstValue+=price[i];
      firstValue/=InpMAPeriod;
      ExtLineBuffer[limit-1]=firstValue;
     }
   else
      limit=prev_calculated-1;
//--- main loop
   for(i=limit; i<rates_total && !IsStopped(); i++)
      ExtLineBuffer[i]=(ExtLineBuffer[i-1]*(InpMAPeriod-1)+price[i])/InpMAPeriod;
//---
  }
//+------------------------------------------------------------------+
