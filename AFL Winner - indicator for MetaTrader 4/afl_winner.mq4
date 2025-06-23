//+------------------------------------------------------------------+
//|                                                   AFL_Winner.mq4 |
//|                                                        avoitenko |
//|                        https://login.mql5.com/en/users/avoitenko |
//+------------------------------------------------------------------+
#property copyright  ""
#property link       "https://login.mql5.com/en/users/avoitenko"

#property indicator_separate_window
#property indicator_buffers 3
//---
#property indicator_color1 Lime
#property indicator_width1 3
#property indicator_style1 STYLE_SOLID
//---
#property indicator_color2 Red
#property indicator_width2 3
#property indicator_style2 STYLE_SOLID
//---
#property indicator_color3 Black
#property indicator_width3 3
#property indicator_style3 STYLE_SOLID

//--- extern
extern int PERIOD    =  10;
extern int AVERAGE   =  5;

//--- buffers
double BullHBuffer[];
double BearHBuffer[];
double ZeroBuffer[];
double pa[];
double pa5[];
double rsv[];
double pak[];
double pad[];

//--- global vars
int i, k;
int offset;
double scost5;
double svolume5;
double max,min;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//--- check input parameters
   if(PERIOD  < 2) PERIOD  = 2;
   if(AVERAGE < 2) AVERAGE = 2;
   offset = PERIOD + AVERAGE*AVERAGE;
   
   IndicatorBuffers(8);
   
//--- buffers
   SetIndexBuffer(0, BullHBuffer);
   SetIndexBuffer(1, BearHBuffer);
   SetIndexBuffer(2, ZeroBuffer);
   SetIndexBuffer(3, pa);
   SetIndexBuffer(4, pa5);
   SetIndexBuffer(5, rsv);
   SetIndexBuffer(6, pak);
   SetIndexBuffer(7, pad);
//---
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexStyle(2,DRAW_HISTOGRAM);
//---
   SetIndexLabel(0,"Bull High");
   SetIndexLabel(1,"Bear High");
   SetIndexLabel(2,"Low");
//---
   SetIndexEmptyValue(0,0);
   SetIndexEmptyValue(1,0);
   SetIndexEmptyValue(2,0);
//---
   IndicatorDigits(2);
   IndicatorShortName("Winner (" + PERIOD + ", " + AVERAGE + ") ");
   return(0);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars = IndicatorCounted();
   int limit;

   if(counted_bars<0)return(0);
   if(counted_bars==0)
   {
      limit= Bars-offset;
      ArrayInitialize(BullHBuffer,0);
      ArrayInitialize(BearHBuffer,0);
      ArrayInitialize(ZeroBuffer,0);
   }
   else limit = Bars-counted_bars-1;
   
//--- main cycle
   for(i=limit; i>=0; i--)
   {
      pa[i] = (2*Close[i]+High[i]+Low[i])/4;

      scost5=0;
      for(k=0; k < AVERAGE; k++)
         scost5 += Volume[i+k]*pa[i+k];

      svolume5=0;
      for(k=0; k < AVERAGE; k++) 
         svolume5 += Volume[i+k];

      if(svolume5==0)continue;   
      pa5[i] = scost5/svolume5;

      min = LLV(pa5,i,PERIOD);
      max = HHV(pa5,i,PERIOD);

      rsv[i] = ((pa5[i] - min)/MathMax(max-min,Point))*100;
   }

//--- wma   
   for(i=limit; i>=0; i--)   
      pak[i] = iMAOnArray(rsv,0,AVERAGE,0,MODE_LWMA,i);
   
   for(i=limit; i>=0; i--)
      pad[i] = iMAOnArray(pak,0,AVERAGE,0,MODE_LWMA,i);

//--- histo
   for(i=limit; i>=0; i--)
   {
      if(pak[i]>pad[i])
      {
         BullHBuffer[i]=pak[i]; 
         ZeroBuffer[i]=pad[i]; 
         BearHBuffer[i]=0;
      }
      else
      {
         BearHBuffer[i]=pad[i];
         ZeroBuffer[i]=pak[i];
         BullHBuffer[i]=0; 
      }
   }
//---
   return(0);
  }
//+------------------------------------------------------------------+
//|   LLV                                                            |
//+------------------------------------------------------------------+
double LLV(double &buffer[],int index, int period)
{
   int total = ArraySize(buffer);
   double min = buffer[index];
   for(int i = index+1; i<MathMin(index+period,total); i++)
      if(buffer[i] < min) min = buffer[i];
   return(min);
}
//+------------------------------------------------------------------+
//|   HHV                                                            |
//+------------------------------------------------------------------+
double HHV(double &buffer[],int index, int period)
{
   int total = ArraySize(buffer);
   double max = buffer[index];
   for(int i=index+1; i<MathMin(index+period,total); i++)
      if(buffer[i] > max) max = buffer[i];
   return(max);
}
//+------------------------------------------------------------------+

