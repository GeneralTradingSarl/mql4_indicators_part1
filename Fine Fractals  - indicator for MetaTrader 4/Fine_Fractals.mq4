//+------------------------------------------------------------------+
//|                                                Fine Fractals.mq4 |
//|                                     Copyright © 2009 Денис Орлов |
//|                                    http://denis-or-love.narod.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009 Денис Орлов"
#property link      "http://denis-or-love.narod.ru"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Green
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];

extern bool Fine=True;
extern bool FlatShift=True;
extern bool NewFAlert=False;

//+------------------------------------------------------------------+
//| iCustom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_ARROW);
   SetIndexArrow(0,164);
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexEmptyValue(0, 0.0);
   SetIndexStyle(1, DRAW_ARROW);
   SetIndexArrow(1, 164);
   SetIndexBuffer(1, ExtMapBuffer2);
   SetIndexEmptyValue(1, 0.0);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("Fine Fractals");
   SetIndexLabel(0, "iFractalsUp");
   SetIndexLabel(1, "iFractalsDn");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+1;
  //---- основной цикл
     for(int i = 2; i < limit; i++)
       { 
         double
       HP1=High[i+1],HP2=High[i],HP3=High[i-1],HPi=High[i-2],
       LP1=Low[i+1],LP2=Low[i],LP3=Low[i-1], LPi=Low[i-2],
       
         res=iFractals(NULL, 0, MODE_UPPER, i);
         if(res==0 && Fine)//повышенная чувствительность
            {
               if(HP1<HP2&&HP2>HP3 && (LP2>=LP3 || HP2>HPi)) res=HP2;
            }
         if(FlatShift && res!=0)// сдвигает фрактал флета
            while(iHigh(NULL,0,i)==iHigh(NULL,0,i+1)) i++;
         ExtMapBuffer1[i] = res;
         if(res!=0 && i==2 && NewFAlert) Alert("Новый верхний фрактал "+DoubleToStr(res,Digits));
         
         res= iFractals(NULL, 0, MODE_LOWER, i);
         if(res==0 && Fine)
            {
               if(LP1>LP2&&LP2<LP3&& (HP2<=HP3 || LP2<LPi))  res=LP2;
            }
         if(FlatShift && res!=0)
            while(iLow(NULL,0,i)==iLow(NULL,0,i+1)) i++;
         ExtMapBuffer2[i] =res;
         if(res!=0 && i==2 && NewFAlert) Alert("Новый нижний фрактал "+DoubleToStr(res,Digits));
       }
//----
   return(0);
  }
//+------------------------------------------------------------------+