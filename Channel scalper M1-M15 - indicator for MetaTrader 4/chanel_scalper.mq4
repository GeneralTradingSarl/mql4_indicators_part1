//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Orange
#property indicator_color2 Orange
#property indicator_color3 Yellow
#property indicator_color4 Yellow
#property indicator_width2 1
#property indicator_width4 1
#property indicator_width1 2
#property indicator_width3 4

int    period       = 11;
int    appliedPrice = PRICE_CLOSE;
double multiplier   = 2.0;

double TrendU[];
double TrendUA[];
double TrendD[];
double TrendDA[];
double Direction[];
double Up[];
double Dn[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(7);
   SetIndexBuffer(0,TrendU);
   SetIndexBuffer(1,TrendUA); SetIndexStyle(1,DRAW_NONE);
   SetIndexBuffer(2,TrendD);
   SetIndexBuffer(3,TrendDA); SetIndexStyle(3,DRAW_NONE);
   SetIndexBuffer(4,Direction);
   SetIndexBuffer(5,Up);
   SetIndexBuffer(6,Dn);

   SetIndexLabel(0,"");
   SetIndexLabel(1,"");
   SetIndexLabel(2,"");
   SetIndexLabel(3,"");
   IndicatorShortName("");
   period=MathMax(1,period);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i;

   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+1;

   for(i=limit; i>=0; i--)
     {
      double atr    = iATR(NULL,0,period,i);
      double cprice = iMA(NULL,0,1,0,MODE_SMA,appliedPrice,i);
      double mprice = (High[i]+Low[i])/2;
      Up[i]  = mprice+multiplier*atr;
      Dn[i]  = mprice-multiplier*atr;

      Direction[i]=Direction[i+1];
      if(cprice > Up[i+1]) Direction[i] =  1;
      if(cprice < Dn[i+1]) Direction[i] = -1;

      TrendU[i]  = EMPTY_VALUE;
      TrendUA[i] = EMPTY_VALUE;
      TrendD[i]  = EMPTY_VALUE;
      TrendDA[i] = EMPTY_VALUE;

      if(Direction[i]>0) { Dn[i]=MathMax(Dn[i],Dn[i+1]); TrendU[i]=Dn[i]; if(Direction[i]!=Direction[i+1]) TrendUA[i]=TrendU[i];}
      else                  { Up[i]=MathMin(Up[i],Up[i+1]); TrendD[i]=Up[i]; if(Direction[i]!=Direction[i+1]) TrendDA[i]=TrendD[i];}
     }
   return(0);
  }
//+------------------------------------------------------------------+
