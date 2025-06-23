//+------------------------------------------------------------------+
//|                                                        Ball.mq4  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "created by Art "
#property link      "shaddow@yandex.ru"

#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 Gray
#property indicator_color2 Lime
#property indicator_color3 Red


#property indicator_level1  100
#property indicator_level2 -100
#property indicator_level3  0

#property indicator_minimum -185
#property indicator_maximum  185



//---- indicator parameters
extern int    BandsPeriod=20;
extern double BandsDeviations=2.0;
extern int    ModeMA=0;    
//MODE_SMA 0 Простое скользящее среднее 
//MODE_EMA 1 Экспоненциальное скользящее среднее 
//MODE_SMMA 2 Сглаженное скользящее среднее 
//MODE_LWMA 3 Линейно-взвешенное скользящее среднее 
extern int    ModePrice=0; 
//PRICE_CLOSE 0 Цена закрытия 
//PRICE_OPEN 1 Цена открытия 
//PRICE_HIGH 2 Максимальная цена 
//PRICE_LOW 3 Минимальная цена 
//PRICE_MEDIAN 4 Средняя цена, (high+low)/2 
//PRICE_TYPICAL 5 Типичная цена, (high+low+close)/3 
//PRICE_WEIGHTED 6 Взвешенная цена закрытия, (high+low+close+close)/4 

double ExtMapBufferUpper [];
double ExtMapBufferMiddle[];
double ExtMapBufferLower [];
int    BandsShift=0;

int    IndicatorLowZnach, IndicatorUpZnach, IndicatorHeightZnach; 
double LowerBB, UpperBB, MiddleBB, PriceChannelHigh, PriceChannelLo, PriceChannel ;   // полосы Боллинджера



int init()
  {
   
   SetIndexStyle(0,0,0,1);
   SetIndexBuffer(0,ExtMapBufferMiddle);
   SetIndexLabel(0,"Средняя");

   SetIndexStyle(1,0,0,1);
   SetIndexBuffer(1,ExtMapBufferUpper);
   SetIndexLabel(1,"Верхняя");
   
   SetIndexStyle(2,0,0,1);
   SetIndexBuffer(2,ExtMapBufferLower);
   SetIndexLabel(2,"Нижняя");

  
//----
   SetIndexDrawBegin(0,BandsPeriod+BandsShift);
   SetIndexDrawBegin(1,BandsPeriod+BandsShift);
   SetIndexDrawBegin(2,BandsPeriod+BandsShift);
   
   IndicatorShortName("Ball");
   
  
  string StrMA,StrModePrice;
  
//MODE_SMA 0 Простое скользящее среднее 
//MODE_EMA 1 Экспоненциальное скользящее среднее 
//MODE_SMMA 2 Сглаженное скользящее среднее 
//MODE_LWMA 3 Линейно-взвешенное скользящее среднее
 
//PRICE_CLOSE 0 Цена закрытия 
//PRICE_OPEN 1 Цена открытия 
//PRICE_HIGH 2 Максимальная цена 
//PRICE_LOW 3 Минимальная цена 
//PRICE_MEDIAN 4 Средняя цена, (high+low)/2 
//PRICE_TYPICAL 5 Типичная цена, (high+low+close)/3 
//PRICE_WEIGHTED 6 Взвешенная цена закрытия, (high+low+close+close)/4 
  
  
  StrMA="";
  StrModePrice="";
  
  if (ModeMA==0) StrMA ="Простое скользящее среднее";
  if (ModeMA==1) StrMA ="Экспоненциальное скользящее среднее"; 
  if (ModeMA==2) StrMA ="Сглаженное скользящее среднее";
  if (ModeMA==3) StrMA ="Линейно-взвешенное скользящее среднее";
  if ((ModeMA>3) || (ModeMA<0)) 
  {
  StrMA ="Простое скользящее среднее";
  ModeMA=0;
  }
  
  if (ModePrice==0) StrModePrice ="Цена закрытия";
  if (ModePrice==1) StrModePrice ="Цена открытия"; 
  if (ModePrice==2) StrModePrice ="Максимальная цена";
  if (ModePrice==3) StrModePrice ="Минимальная цена";
  if (ModePrice==4) StrModePrice ="Средняя цена";
  if (ModePrice==5) StrModePrice ="Типичная цена";
  if (ModePrice==6) StrModePrice ="Взвешенная цена закрытия";
  if ((ModePrice>6) || (ModePrice<0)) 
  {
  StrModePrice ="Цена закрытия";
  ModePrice=0;
  }  
  
  Comment("Метод вычисления MA ",StrMA,"\n","Используемая цена для расчёта ",StrModePrice);
  
    
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Bollinger Bands                                                  |
//+------------------------------------------------------------------+
int start()
  {
   
   int    i,k,counted_bars=IndicatorCounted();
   double deviation;
   double sum,oldval,newres;
   double tempValMid;
//----
   if(Bars<=BandsPeriod) return(0);
//----
   int limit=Bars-counted_bars;
   if(counted_bars>0) limit++;
   for(i=0; i<limit; i++)
   tempValMid=iMA(NULL,0,BandsPeriod,BandsShift,ModeMA,ModePrice,i);
//----
   i=Bars-BandsPeriod;
   if(counted_bars>BandsPeriod-1) i=Bars-counted_bars-1;
   while(i>=0)
     {
      sum=0.0;
      k=i+BandsPeriod-1;
      tempValMid=iMA(NULL,0,BandsPeriod,BandsShift,ModeMA,ModePrice,i);
      oldval=tempValMid;

      while(k>=i)
        {
         newres=Close[k]-oldval;
         sum+=newres*newres;
         k--;
        }
      deviation=BandsDeviations*MathSqrt(sum/BandsPeriod);
      
      ExtMapBufferMiddle[i]=tempValMid;
      UpperBB= oldval+deviation;
      MiddleBB=ExtMapBufferMiddle[i];
      LowerBB= oldval-deviation;
      
      
      
      double myPriceH=High[i];
      double myPriceL=Low[i];
        
      IndicatorLowZnach=int(-1*(NormalizeDouble(((MiddleBB-myPriceL)*100)/((MiddleBB-LowerBB)),0)));
      IndicatorUpZnach=  (int)NormalizeDouble(((myPriceH-MiddleBB)*100)/((UpperBB-MiddleBB)),0);
      
      
      
      ExtMapBufferUpper[i] =IndicatorUpZnach;
      ExtMapBufferMiddle[i]=(IndicatorUpZnach+IndicatorLowZnach)/2;
      ExtMapBufferLower[i] =IndicatorLowZnach;
      
      i--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+