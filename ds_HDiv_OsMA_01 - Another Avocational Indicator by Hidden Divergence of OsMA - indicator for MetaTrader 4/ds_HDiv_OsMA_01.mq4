//+------------------------------------------------------------------
//    															  ds_HDiv_OsMA.mq4
//												   			  dolsergon@yandex.ru
//														         icq(qip)-366382375
//+------------------------------------------------------------------+
//|                                                         OsMA.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2004, MetaQuotes Software Corp."
#property  link      "http://www.metaquotes.net/"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 3
#property  indicator_color1  Silver
#property  indicator_width1  2
#property  indicator_color2  Blue
#property  indicator_width2  1
#property  indicator_color3  Orange
#property  indicator_width3  1
//---- indicator parameters
extern int FastEMA=12;
extern int SlowEMA=26;
extern int SignalSMA=9;

extern int FractRightBars=1;   // кол-во бар справа (фрактал)
extern int FractLeftBars = 4;      // кол-во бар слева (фрактал)
extern int MaxFanSize = 3;         // макс. кол-во линий в "веере"



//---- indicator buffers
double     OsmaBuffer[];
double     MacdBuffer[];
double     SignalBuffer[];
double      FrUpBuffer[];
double      FrDnBuffer[];

string IndName;
//=======================================================================================================================================================================
int init()
  {
//---- 2 additional buffers are used for counting.
   IndicatorBuffers(5);
//---- drawing settings
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexDrawBegin(0,SignalSMA);
   IndicatorDigits(Digits+2);
//---- 3 indicator buffers mapping
   SetIndexBuffer(0,OsmaBuffer);

   SetIndexBuffer(1,FrDnBuffer);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,119);
   SetIndexEmptyValue(1,0.0);

   SetIndexBuffer(2,FrUpBuffer);
   SetIndexStyle(2,DRAW_ARROW);
   SetIndexArrow(2,119);
   SetIndexEmptyValue(2,0.0);

   SetIndexBuffer(3,MacdBuffer);
   SetIndexBuffer(4,SignalBuffer);
//---- name for DataWindow and indicator subwindow label
   IndName="ds_HDiv_OsMA("+FastEMA+","+SlowEMA+","+SignalSMA+")";
   IndicatorShortName(IndName);
//---- initialization done
   return(0);
  }
//=======================================================================================================================================================================
void deinit() 
  {

   ObjectsDeleteAll();
  }
//=======================================================================================================================================================================
//| Moving Average of Oscillator                                     |
int start()
  {
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+FractLeftBars;

//---- macd counted in the 1-st additional buffer
   for(int i=0; i<limit; i++)
      MacdBuffer[i]=iMA(NULL,0,FastEMA,0,MODE_EMA,PRICE_CLOSE,i)-iMA(NULL,0,SlowEMA,0,MODE_EMA,PRICE_CLOSE,i);
//---- signal line counted in the 2-nd additional buffer
   for(i=0; i<limit; i++)
      SignalBuffer[i]=iMAOnArray(MacdBuffer,0,SignalSMA,0,MODE_SMA,i);
//---- main loop
   for(i=0; i<limit; i++)
      OsmaBuffer[i]=MacdBuffer[i]-SignalBuffer[i];
//---- done

// FRACTALS -------------------------------------------------------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------

   int l_bars,r_bars;
   int p;
   double v,v2;

   for(i=1+FractRightBars; i<limit; i++) 
     {

      l_bars = 0;
      r_bars = 0;
      v=OsmaBuffer[i];
      for(p=1; p<=FractLeftBars; p++) 
        {
         if(OsmaBuffer[i+p]>v) 
           {
            l_bars++;
            v=OsmaBuffer[i+p];
           }
         else    break;
        }
      v=OsmaBuffer[i];
      for(p=1; p<=FractRightBars; p++) 
        {
         if(OsmaBuffer[i-p]>=v) 
           {
            r_bars++;
            v=OsmaBuffer[i-p];
           }
         else    break;
        }
      if((l_bars==FractLeftBars) && (r_bars==FractRightBars)) 
        {
         FrDnBuffer[i]=OsmaBuffer[i];
        }

      l_bars = 0;
      r_bars = 0;
      v=OsmaBuffer[i];
      for(p=1; p<=FractLeftBars; p++) 
        {
         if(OsmaBuffer[i+p]<v) 
           {
            l_bars++;
            v=OsmaBuffer[i+p];
           }
         else    break;
        }
      v=OsmaBuffer[i];
      for(p=1; p<=FractRightBars; p++) 
        {
         if(OsmaBuffer[i-p]<=v) 
           {
            r_bars++;
            v=OsmaBuffer[i-p];
           }
         else    break;
        }
      if((l_bars==FractLeftBars) && (r_bars==FractRightBars)) 
        {
         FrUpBuffer[i]=OsmaBuffer[i];
        }

     }

// DIVERGENCE -----------------------------------------------------------------------------------------------------------------------------------------------------------

   int PointsOffset=9;

   for(p=1+FractRightBars; p<limit; p++) 
     {

      if(FrUpBuffer[p]!=0) 
        {
         int count=0;

         for(i=FractLeftBars+p; i<Bars; i++) 
           {
            if(FrUpBuffer[i]!=0) 
              {

               if((FrUpBuffer[i]<FrUpBuffer[p]) && (High[i]>High[p])) 
                 {
                  DrawIndicatorTrendLine(Time[i],Time[p],OsmaBuffer[i],OsmaBuffer[p],Red,2);
                  DrawPriceTrendLine(Time[i],Time[p],High[i],High[p],Red,2);
                  DrawPriceArrow(Time[p-2],Open[p-2]+PointsOffset*Point,Red,167);
                  count++;
                  if(count>=MaxFanSize) break;
                 }
               else    break;

              }
           }
        }

      if(FrDnBuffer[p]!=0) 
        {
         count=0;

         for(i=FractLeftBars+p; i<Bars; i++) 
           {
            if(FrDnBuffer[i]!=0) 
              {

               if((FrDnBuffer[i]>FrDnBuffer[p]) && (Low[i]<Low[p])) 
                 {
                  DrawIndicatorTrendLine(Time[i],Time[p],OsmaBuffer[i],OsmaBuffer[p],Green,2);
                  DrawPriceTrendLine(Time[i],Time[p],Low[i],Low[p],Green,2);
                  DrawPriceArrow(Time[p-2],Open[p-2]+PointsOffset*Point,Blue,167);
                  count++;
                  if(count>=MaxFanSize) break;
                 }
               else    break;

              }
           }
        }

     }


   return(0);
  }
//=======================================================================================================================================================================
void DrawPriceTrendLine(datetime x1,datetime x2,double y1,
                        double y2,color lineColor,double style)
  {
   string label="DivergLine# "+DoubleToStr(x1+x2,0);
   ObjectDelete(label);
   ObjectCreate(label,OBJ_TREND,0,x1,y1,x2,y2,0,0);
   ObjectSet(label,OBJPROP_RAY,0);
   ObjectSet(label,OBJPROP_COLOR,lineColor);
   ObjectSet(label,OBJPROP_STYLE,style);
  }
//=======================================================================================================================================================================
void DrawIndicatorTrendLine(datetime x1,datetime x2,double y1,
                            double y2,color lineColor,double style)
  {
   int indicatorWindow=WindowFind(IndName);
   if(indicatorWindow<0)
      return;
   string label="DivergLine$# "+DoubleToStr(x1+x2,0);
   ObjectDelete(label);
   ObjectCreate(label,OBJ_TREND,indicatorWindow,x1,y1,x2,y2,0,0);
   ObjectSet(label,OBJPROP_RAY,0);
   ObjectSet(label,OBJPROP_COLOR,lineColor);
   ObjectSet(label,OBJPROP_STYLE,style);
  }
//=======================================================================================================================================================================
void DrawPriceArrow(datetime x1,double y1,color Color,double style)
  {
   string label="DivergArrow# "+DoubleToStr(x1,0);
   ObjectDelete(label);
   ObjectCreate(label,OBJ_ARROW,0,x1,y1);
   ObjectSet(label,OBJPROP_ARROWCODE,style);
   ObjectSet(label,OBJPROP_COLOR,Color);
  }
//+------------------------------------------------------------------+
