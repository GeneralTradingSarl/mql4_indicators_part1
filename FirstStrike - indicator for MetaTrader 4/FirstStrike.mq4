//+------------------------------------------------------------------+
//|                                                  FirstStrike.mq4 |
//|                                                             Itso |
//|                                                      itso@dir.bg |
//+------------------------------------------------------------------+
#property copyright "Itso"
#property link      "itso@dir.bg"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Blue
//---- buffers
double BuffMin[];
double BuffMax[];

int Periods[] = {
   PERIOD_M1,
   PERIOD_M5,
   PERIOD_M15,
   PERIOD_M30,
   PERIOD_H1,
   PERIOD_H4,
   PERIOD_D1,
   PERIOD_W1,
   PERIOD_MN1
};

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
  if (Period()==PERIOD_M1)
  {
   Print("This indicator doesn\'t work on M1 timeframe!");
   return(0);
  }
//---- indicators
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,217);
   SetIndexBuffer(0,BuffMin);
   SetIndexEmptyValue(0,0.0);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,218);
   SetIndexBuffer(1,BuffMax);
   SetIndexEmptyValue(1,0.0);
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   if (Period()==PERIOD_M1) return(0);
   
   int    counted_bars=IndicatorCounted();
//----
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   double Value;
   for (int i=0; i<limit; i++)
   {
      switch(GetFirstStrike(Period(),i,Value))
      {
         case -1: 
            {
               BuffMin[i]=Value;
               break;
            }
         case  1: 
            {
               BuffMax[i]=Value;
               break;
            }
         case  0:
            {
               BuffMin[i]=Value;
               BuffMax[i]=Value;
            }
      }
   }
   return(0);
  }
//+------------------------------------------------------------------+

int GetFirstStrike(int ParentPeriod, int ParentBar, double& Value)
{
   int CurrPeriod;
   datetime StartTime, EndTime;
   int ChildFirstBar, ChildLastBar;
   int idxMin, idxMax;
   double ValMin, ValMax;
   
   for(int i=0;i<ArrayRange(Periods,0);i++)   
   {
      if(Periods[i]==ParentPeriod)
      {
         CurrPeriod=Periods[i-1];
         break;
      }
   }
   if (ParentBar==0)
   {
      StartTime=TimeCurrent();
      ChildFirstBar=0;
   }
   else
   {
      StartTime=iTime(Symbol(),ParentPeriod,ParentBar-1);
      ChildFirstBar=iBarShift(Symbol(),CurrPeriod,StartTime);
      ChildFirstBar++;
   }
   EndTime=iTime(Symbol(),ParentPeriod,ParentBar);
   ChildLastBar=iBarShift(Symbol(),CurrPeriod,EndTime);
   
   ValMin=2*Bid;
   ValMax=0;
   for(i=ChildLastBar;i>=ChildFirstBar;i--)
   {
      double CurrLow=iLow(Symbol(),CurrPeriod,i);
      double CurrHigh=iHigh(Symbol(),CurrPeriod,i);
      if(CurrLow<ValMin)
      {
         ValMin=CurrLow;
         idxMin=i;
      }
      if(CurrHigh>ValMax)
      {
         ValMax=CurrHigh;
         idxMax=i;
      }
   }
   
   if (idxMin>idxMax)
   {
      Value=ValMin;
      return(-1);
   }
   else if(idxMin<idxMax)
   {
      Value=ValMax;
      return(1);
   }
   else
   {
      if(CurrPeriod==PERIOD_M1)
      {
         Value=ValMax;
         return(0);
      }
      else
      {
         return(GetFirstStrike(CurrPeriod,idxMax,Value));
      }
   }
}