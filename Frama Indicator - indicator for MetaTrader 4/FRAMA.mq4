//+------------------------------------------------------------------+
//|                                                        FRAMA.mq4 |
//|                                                             Rosh |
//|                    http://www.alpari-idc.ru/ru/experts/articles/ |
//+------------------------------------------------------------------+
#property copyright "Rosh"
#property link      "http://www.alpari-idc.ru/ru/experts/articles/"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 DarkBlue
//---- input parameters
extern int       PeriodFRAMA=10;
extern int       PriceType=0;
//PRICE_CLOSE 0 Цена закрытия 
//PRICE_OPEN 1 Цена открытия 
//PRICE_HIGH 2 Максимальная цена 
//PRICE_LOW 3 Минимальная цена 
//PRICE_MEDIAN 4 Средняя цена, (high+low)/2 
//PRICE_TYPICAL 5 Типичная цена, (high+low+close)/3 
//PRICE_WEIGHTED 6 Взвешенная цена закрытия, (high+low+close+close)/4 

//---- buffers
double ExtMapBuffer1[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexEmptyValue(0,0.0);
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
//| возвращает цену                                                  |
//+------------------------------------------------------------------+
double Price(int shift)
  {
//----
   double res;
//----
   switch (PriceType)
      {
      case PRICE_OPEN: res=Open[shift]; break;
      case PRICE_HIGH: res=High[shift]; break;
      case PRICE_LOW: res=Low[shift]; break;
      case PRICE_MEDIAN: res=(High[shift]+Low[shift])/2.0; break;
      case PRICE_TYPICAL: res=(High[shift]+Low[shift]+Close[shift])/3.0; break;
      case PRICE_WEIGHTED: res=(High[shift]+Low[shift]+2*Close[shift])/4.0; break;
      default: res=Close[shift];break;
      }
   return(res);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   double Hi1,Lo1,Hi2,Lo2,Hi3,Lo3;   
   double N1,N2,N3,D;
   double ALFA;
   int limit;
   int    counted_bars=IndicatorCounted();
   if (counted_bars==0) limit=Bars-2*PeriodFRAMA;
   if (counted_bars>0) limit=Bars-counted_bars;
   limit--;
      
//----
   for (int i=limit;i>=0;i--)
      {
      Hi1=High[iHighest(Symbol(),0,MODE_HIGH,PeriodFRAMA,i)];
      Lo1=Low[iLowest(Symbol(),0,MODE_LOW,PeriodFRAMA,i)];
      Hi2=High[iHighest(Symbol(),0,MODE_HIGH,PeriodFRAMA,i+PeriodFRAMA)];
      Lo2=Low[iLowest(Symbol(),0,MODE_LOW,PeriodFRAMA,i+PeriodFRAMA)];
      Hi3=High[iHighest(Symbol(),0,MODE_HIGH,2*PeriodFRAMA,i)];
      Lo3=Low[iLowest(Symbol(),0,MODE_LOW,2*PeriodFRAMA,i)];
      N1=(Hi1-Lo1)/PeriodFRAMA;
      N2=(Hi2-Lo2)/PeriodFRAMA;
      N3=(Hi3-Lo3)/(2.0*PeriodFRAMA);
      D=(MathLog(N1+N2)-MathLog(N3))/MathLog(2.0);
      ALFA=MathExp(-4.6*(D-1.0));
      ExtMapBuffer1[i]=ALFA*Price(i)+(1-ALFA)*ExtMapBuffer1[i+1];
      }
//----
   return(0);
  }
//+------------------------------------------------------------------+