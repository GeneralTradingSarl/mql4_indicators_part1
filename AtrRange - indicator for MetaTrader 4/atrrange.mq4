//+------------------------------------------------------------------+
//|                                                     AtrRange.mq4 |
//|                                                           raxxla |
//|                                         http://www.cmetrading.ru |
//+------------------------------------------------------------------+
#property copyright "raxxla"
#property link      "http://www.cmetrading.ru"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_plots   3
//--- plot HiRange
#property indicator_label1  "HiRange"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot LoRange
#property indicator_label2  "LoRange"
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1

#property indicator_label3  "MultiRange"
#property indicator_type3   DRAW_ARROW
#property indicator_color3  clrYellow
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- input parameters
input int      MaxRange=25;
//--- indicator buffers
double         HiRangeBuffer[];
double         LoRangeBuffer[];
double         MRangeBuffer[];
//---
int      Atr_Start=3;
int      Atr_Step=2;
int      MA = 14;
int      pt = 1;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(Digits==5 || Digits==3)
      pt=10;
//--- indicator buffers mapping
   SetIndexBuffer(0,HiRangeBuffer);
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,159);
   SetIndexBuffer(1,LoRangeBuffer);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,159);
   SetIndexBuffer(2,MRangeBuffer);
   SetIndexStyle(2,DRAW_ARROW);
   SetIndexArrow(2,162);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
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
   int i,limit;
//---
   if(rates_total<=4)
      return(0);
//--- last counted bar will be recounted
   limit=rates_total-prev_calculated-3;
//---
   if(prev_calculated>0)
      limit++;
//---
   if(limit<3)
      limit=3;
//---
   for(i=1; i<limit; i++)
     {
      if(AtrRange(i,MaxRange*pt))
        {
         HiRangeBuffer[i] = High[i]+Point*3;
         LoRangeBuffer[i] = Low[i]-Point*3;
        }
      else
        {
         HiRangeBuffer[i] = 0.0;
         LoRangeBuffer[i] = 0.0;
        }
      //---
      if(AtrBreakIn(i))
         MRangeBuffer[i]=(High[i]+Low[i])/2;
      else
         MRangeBuffer[i]=0.0;
     }
//--- done
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool AtrBreakIn(int i)
  {
   double vlt1 = (High[i]-Low[i])/Point+Point;
   double vlt2 = (High[i+1]-Low[i+1])/Point+Point;
//---
   if((vlt1/vlt2)>1.5)
      return false;
//---
   double max = MathMax(GetAtr(2, i), MathMax(GetAtr(3, i), MathMax(GetAtr(4, i), GetAtr(5, i))));
   double min = MathMin(GetAtr(2, i), MathMin(GetAtr(3, i), MathMin(GetAtr(4, i), GetAtr(5, i))));
   double atrMa3=GetAtrMa(3,i);
//---
   if(max>atrMa3)
      return false;
//---
   if((max-min)/Point>(25*pt))
      return false;
//---
   double atr1=GetAtr(1,i);
//---
   if(atr1<min || atr1>atrMa3)
      return false;
//---
   if(atr1<GetAtr(1,i+1))
      return false;
//---
   if(atr1>=GetAtr(5,i))
      return false;
//---
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetAtr(int num,int offset)
  {
   num--;
   int atrPerod=Atr_Start+Atr_Step*num;
//---
   return iATR(NULL, 0, atrPerod, offset);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetAtrMa(int num,int offset)
  {
   num--;
//---
   int atrPerod=Atr_Start+Atr_Step*num;
   double summ=0;
//---
   for(int n=0;n<MA;n++)
     {
      summ+=iATR(NULL,0,atrPerod,offset+n);
     }
//---
   return (summ/MA);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool AtrRange(int i,int maxRange)
  {
   double vlt1 = (High[i]-Low[i])/Point+Point;
   double vlt2 = (High[i+1]-Low[i+1])/Point+Point;
   double vlt3 = (High[i+2]-Low[i+2])/Point+Point;
//---
   if(vlt1>maxRange)
      return false;
//---
   if((vlt3/vlt2)>1.8)
      return false;
//---
   if(vlt1>vlt2 || vlt2>vlt3 || vlt1>vlt3)
      return false;
//---
   if((High[i]-High[i+1])>Point)
      return false;
//---
   if((High[i+1]-High[i+2])>Point)
      return false;
//---
   if((Low[i+1]-Low[i])>Point)
      return false;
//---
   if((Low[i+2]-Low[i+1])>Point)
      return false;
//---
   return true;
  }
//+------------------------------------------------------------------+
