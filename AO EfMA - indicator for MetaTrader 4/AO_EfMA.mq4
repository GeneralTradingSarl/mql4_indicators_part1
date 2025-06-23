//+------------------------------------------------------------------+
//|                                                      AO EfMA.mq4 |
//|            Copyright © 2011 http://www.mql4.com/ru/users/rustein |
//+------------------------------------------------------------------+

//---- Indicator settings
#property  indicator_separate_window
#property  indicator_buffers 3
#property  indicator_color1  Green
#property  indicator_width1  1
#property  indicator_color2  Red
#property  indicator_width2  1
#property  indicator_color3  Gold
#property  indicator_width3  1
//----
//+------------------------------------------------------------------+
extern int  FastPeriod = 13;
//+------------------------------------------------------------------+
extern int  SlowPeriod = 21;
//+------------------------------------------------------------------+
extern int  MAMethod   = 3; // 0=SMA,1=EMA,2=SSMA,3=LWMA
//+------------------------------------------------------------------+
extern int  MAPrice    = 6; // 0=Close,1=Open,2=High,3=Low,4=Median,5=Typical,6=Weighted
//+------------------------------------------------------------------+
extern bool Alerts     = true;
//+------------------------------------------------------------------+
extern int  AlertBar   = 1; 
//+------------------------------------------------------------------+
//-------------------------------------------------------------------+
 
//+------------------------------------------------------------------+
//|            DO NOT MODIFY ANYTHING BELOW THIS LINE!!!             |
//+------------------------------------------------------------------+
 
//-------------------------------------------------------------------+
//-------------------------------------------------------------------+
//-----
datetime LastAlertTime = -999999;
//---- Buffers
double Bull[];
double Bear[];
double Trend[];
double FastMA[];
double FastEfMA[];
double SlowMA[];
double SlowEfMA[];
//----
int    MAMode;
string strMAType;
int    PriceMA;
string strMAPrice;
//----
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
//-----
  switch(MAMethod)
  {
    case 1:  strMAType="EMA";  MAMode=MODE_EMA;  break;
    case 2:  strMAType="SMMA"; MAMode=MODE_SMMA; break;
    case 3:  strMAType="LWMA"; MAMode=MODE_LWMA; break;
    default: strMAType="SMA";  MAMode=MODE_SMA;  break;
  }
//-----
  switch(MAPrice)
  {
    case 1:  strMAPrice="Open";     PriceMA=PRICE_OPEN;     break;
    case 2:  strMAPrice="High";     PriceMA=PRICE_HIGH;     break;
    case 3:  strMAPrice="Low";      PriceMA=PRICE_LOW;      break;
    case 4:  strMAPrice="Median";   PriceMA=PRICE_LOW;      break;
    case 5:  strMAPrice="Typical";  PriceMA=PRICE_TYPICAL;  break;
    case 6:  strMAPrice="Weighted"; PriceMA=PRICE_WEIGHTED; break;
    default: strMAPrice="Close";    PriceMA=PRICE_CLOSE;    break;
  }
//-----
//----- Drawing settings
  IndicatorBuffers(7);
  SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,1);
  SetIndexBuffer(0,Bull);
  SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID,1);
  SetIndexBuffer(1,Bear);
  SetIndexStyle(2,DRAW_NONE,STYLE_SOLID,1);
  SetIndexBuffer(2,Trend);
//------
  SetIndexBuffer(3,FastEfMA);
  SetIndexBuffer(4,FastMA);
  SetIndexBuffer(5,SlowEfMA);
  SetIndexBuffer(6,SlowMA);
  SetIndexDrawBegin(0,FastPeriod);
  SetIndexDrawBegin(1,FastPeriod);
  IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS)+2);
//----- Name for DataWindow and indicator subwindow label
  IndicatorShortName("AO EfMA ("+FastPeriod+"-"+SlowPeriod+","+strMAType+","+strMAPrice+")");
  SetIndexLabel(0,NULL);
  SetIndexLabel(1,NULL);
//-----
  return(0);
}
//+------------------------------------------------------------------+
int start()
{
  int i,limit;
  int counted_bars=IndicatorCounted();
  if (counted_bars>0) counted_bars--; 
  limit=Bars-counted_bars;
  if(counted_bars==0) limit--;
//-----
  for(i=limit; i>=0; i--)
  {FastMA[i]=iMA(NULL,0,FastPeriod,0,MAMethod,MAPrice,i);}
//-----
  for(i=limit; i>=0; i--)
  {FastEfMA[i]=iMAOnArray(FastMA,Bars,FastPeriod,0,MAMethod,i);}
//-----
  for(i=limit; i>=0; i--)
  {SlowMA[i]=iMA(NULL,0,SlowPeriod,0,MAMethod,MAPrice,i);}
//-----
  for(i=limit; i>=0; i--)
  {SlowEfMA[i]=iMAOnArray(SlowMA,Bars,SlowPeriod,0,MAMethod,i);}
//-----
  for(i=0; i<limit; i++)
  Trend[i]=FastEfMA[i]-SlowEfMA[i];
//-----
  for(i=limit-1; i>=0; i--)
  {
    double TrendNow=Trend[i];
    double TrendPre=Trend[i+1];
    if(TrendNow > TrendPre)
    {
      Bull[i]=TrendNow;
      Bear[i]=EMPTY_VALUE;
    }   
    if(TrendNow < TrendPre)
    {
      Bear[i]=TrendNow;
      Bull[i]=EMPTY_VALUE;
    }
  }
//+------------------------------------------------------------------+      
  if(Alerts)
  {
    if(AlertBar >= 0 && Time[0] > LastAlertTime)
    {
      if(Trend[i+AlertBar] > 0 && Trend[i+AlertBar+1] < 0)
      {
        Alert("AO EfMA: Bull Zero Cross! ",Symbol()," TF: ",Period());
      }
      if(Trend[i+AlertBar] < 0 && Trend[i+AlertBar+1] > 0)
      { 
        Alert("AO EfMA: Bear Zero Cross! ",Symbol()," TF: ",Period());
      }
//-----
      if(Trend[i+AlertBar] > Trend[i+AlertBar+1] && Trend[i+AlertBar+1] < Trend[i+AlertBar+2])
      {
        Alert("AO EfMA: BULL! ",Symbol()," TF: ",Period());
      }
      if(Trend[i+AlertBar] < Trend[i+AlertBar+1] && Trend[i+AlertBar+1] > Trend[i+AlertBar+2])
      { 
        Alert("AO EfMA: BEAR! ",Symbol()," TF: ",Period());
      }
//-----
    }
//-----
    LastAlertTime = Time[0];
  }
//----- Done
  return(0);
}
//+------------------------------------------------------------------+
//|    Copyright © 2011 http://www.mql4.com/ru/users/rustein         |
//+------------------------------------------------------------------+