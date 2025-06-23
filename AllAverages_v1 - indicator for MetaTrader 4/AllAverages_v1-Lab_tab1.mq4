//+------------------------------------------------------------------+
//|                                               AllAverages_v1.mq4 |
//|                             Copyright © 2007-08, TrendLaboratory |
//|            http://finance.groups.yahoo.com/group/TrendLaboratory |
//|                                   E-mail: igorad2003@yahoo.co.uk |
//|            "Labels added by "OTCFX".                             |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007-08, TrendLaboratory"
#property link      "http://finance.groups.yahoo.com/group/TrendLaboratory"
//----
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1  Orange
#property indicator_width1  2
//---- indicator parameters
extern int Price=0;
extern int MA_Period=5;
extern int MA_Shift=0;
extern int MA_Method=1;
extern int Label_Size=8;
extern color LabelCol=Orange;
//---- indicator buffers
double MA[];
double aPrice[];
//----
int    draw_begin;
string short_name;
string xLAb1;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- drawing settings
   SetIndexStyle(0,DRAW_LINE);
   SetIndexShift(0,MA_Shift);
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS));
   draw_begin=MA_Period;
//---- indicator short name
   switch(MA_Method)
     {
      case 1 : short_name="EMA";  break;
      case 2 : short_name="Wilder"; break;
      case 3 : short_name="LWMA"; break;
      case 4 : short_name="SineWMA"; break;
      case 5 : short_name="TriMA"; break;
      case 6 : short_name="LSMA"; break;
      case 7 : short_name="SMMA"; break;
      case 8 : short_name="MMA"; break;
      case 9 : short_name="HMA"; break;
      case 10: short_name="ZeroLagEMA"; break;
      default: MA_Method=0; short_name="SMA";
     }
   IndicatorShortName(short_name+MA_Period+")");
   SetIndexDrawBegin(0,draw_begin);
   SetIndexLabel(0,short_name+MA_Period+")");
//---- indicator buffers mapping
   IndicatorBuffers(2);
   SetIndexBuffer(0,MA);
   SetIndexBuffer(1,aPrice);
//---- initialization done
   xLAb1=short_name+MA_Period+")";
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete(xLAb1);
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int limit, i, shift;
   int JK0=0;   
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   limit = Bars - counted_bars;
   if(counted_bars==0) limit--;
      
   for(shift=limit; shift>=0; shift--)   aPrice[shift]=iMA(NULL,0,1,0,0,Price,shift);
   JK0=MA_Period;
   for(shift=limit; shift>=0; shift--)
     {
      if(shift==limit - MA_Period)
        {
         switch(MA_Method)
           {
            case 1 : MA[shift]=SMA(aPrice,MA_Period,shift); break;
            case 2 : MA[shift]=SMA(aPrice,MA_Period,shift); break;
            case 7 : MA[shift]=SMA(aPrice,MA_Period,shift); break;
            case 10: MA[shift]=SMA(aPrice,1,shift); break;
           }
        }
      else
         if(shift < limit - MA_Period)
           {
            switch(MA_Method)
              {
               case 1 : MA[shift]=EMA(aPrice,MA,MA_Period,shift); break;
               case 2 : MA[shift]=Wilder(aPrice,MA,MA_Period,shift); break;
               case 3 : MA[shift]=LWMA(aPrice,MA_Period,shift); break;
               case 4 : MA[shift]=SineWMA(aPrice,MA_Period,shift); break;
               case 5 : MA[shift]=TriMA(aPrice,MA_Period,shift); break;
               case 6 : MA[shift]=LSMA(aPrice,MA_Period,shift); break;
               case 7 : MA[shift]=SMMA(aPrice,MA,MA_Period,shift); break;
               case 8 : MA[shift]=MMA(aPrice,MA_Period,shift); break;
               case 9 : MA[shift]=HMA(aPrice,MA_Period,shift); break;
               case 10: MA[shift]=ZeroLagEMA(aPrice,MA,MA_Period,shift); break;
               default: MA[shift]=SMA(aPrice,MA_Period,shift); break;
              }
           }
     }
//---- done
   if (ObjectFind(xLAb1)!=0)
      ObjectCreate(xLAb1,OBJ_TEXT,0,0,0);
   ObjectMove(xLAb1,0,Time[0], MA[0]+0.00007);
   ObjectSetText(xLAb1,"                        <-<"+JK0+","+short_name+","+DoubleToStr( MA[0],Digits), Label_Size, "Verdana", LabelCol);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SMA(double array[],int per,int bar)
  {
   double Sum=0;
   for(int i=0;i < per;i++) Sum+=array[i+bar];
//----
   return(Sum/per);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double EMA(double array1[],double array2[],int per,int bar)
  {
   return(array2[bar+1] + 2.0/(1+per)*(array1[bar] - array2[bar+1]));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Wilder(double array1[],double array2[],int per,int bar)
  {
   return(array2[bar+1] + 1.0/per*(array1[bar] - array2[bar+1]));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LWMA(double array[],int per,int bar)
  {
   double Sum=0;
   double Weight=0;
//----
   for(int i=0;i < per;i++)
     {
      Weight+= (per - i);
      Sum+=array[bar+i]*(per - i);
     }
   if(Weight>0) double lwma=Sum/Weight;
   else lwma=0;
   return(lwma);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SineWMA(double array[],int per,int bar)
  {
   double pi=3.1415926535;
   double Sum=0;
   double Weight=0;
   double del=0.5*pi/per;
//----   
   for(int i=0;i < per;i++)
     {
      Weight+= MathSin(0.5*pi - del*i);
      Sum+=array[bar+i]*MathSin(0.5*pi - del*i);
     }
   if(Weight>0) double swma=Sum/Weight;
   else swma=0;
   return(swma);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TriMA(double array[],int per,int bar)
  {
   double sma[];
   int len=MathCeil((per+1)*0.5);
   ArrayResize(sma,len);
   for(int i=0;i < len;i++) sma[i]=SMA(array,len,bar+i);
   double trima=SMA(sma,len,0);
//----
   return(trima);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LSMA(double array[],int per,int bar)
  {
   double Sum=0;
   for(int i=per; i>=1; i--) Sum+=(i-(per+1)/3.0)*array[per-i+bar];
   double lsma=Sum*6/(per*(per+1));
//----
   return(lsma);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SMMA(double array1[],double array2[],int per,int bar)
  {
   double Sum=0;
   for(int i=0;i < per;i++) Sum+=array1[i+bar+1];
   double smma=(Sum - array2[bar+1] + array1[bar])/per;
//----
   return(smma);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MMA(double array[],int per,int bar)
  {
   double Slope=0;
   for(int i=1;i<=per;i++)
     {
      double Factor=1 + (2 * (i - 1));
      Slope+=(array[bar + i - 1] * ((per - Factor)/2));
     }
   double sma=SMA(array,per,bar);
   double mma=sma + (6 * Slope)/((per + 1) * per);
//----   
   return(mma);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double HMA(double array[],int per,int bar)
  {
   double tmp[];
   int len= MathSqrt(per);
   ArrayResize(tmp,len);
   for(int i=0; i < len;i++) tmp[i]=2*LWMA(array,per/2,bar+i) - LWMA(array,per,bar+i);
   double hma=LWMA(tmp,len,0);
//----
   return(hma);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ZeroLagEMA(double array1[],double array2[],int per,int bar)
  {
   double alfa=2.0/(1+per);
   int lag=0.5*(per - 1);
   return(alfa*(2*array1[bar] - array1[bar+lag]) + (1-alfa)*array2[bar+1]);
  }
//+------------------------------------------------------------------+