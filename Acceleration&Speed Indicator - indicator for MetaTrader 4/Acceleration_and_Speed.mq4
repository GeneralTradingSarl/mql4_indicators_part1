//+------------------------------------------------------------------+
//|                                       Acceleration_and_Speed.mq4 |
//|                      Copyright © 2005, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, Kharko"

//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 4
#property  indicator_color1  Red
#property  indicator_color2  Green
#property  indicator_color3  Yellow
#property  indicator_color4  Aqua

//---- indicator parameters
extern int    Bar          = 24;       // Период
extern int    Cena         = 0;        // Цена: 1 - открытия; 2 - закрытия; 3 - максимум; 4 - минимум;
                                       //       5 - (H + L)/2; 6 - (H+L+C)/3; 7 - (H+L+C+O)/4;
                                       //       0 - (H+L+C+O)/4
extern bool   Sp_vis        = true;    // показать/спрятать график скорости
extern bool   Ac_vis        = true;    // показать/спрятать график ускорения
extern bool   SpOf_vis      = true;    // показать/спрятать график скорости со сдвигом внутрь истории
extern bool   AcOf_vis      = true;    // показать/спрятать график ускорения со сдвигом внутрь истории

//---- indicator buffers
double     ExtBuffer0[];
double     ExtBuffer1[];
double     ExtBuffer2[];
double     ExtBuffer3[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- drawing settings
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexStyle(3,DRAW_LINE);
//---- 4 indicator buffers mapping
   SetIndexBuffer(0,ExtBuffer0);
   SetIndexBuffer(1,ExtBuffer1);
   SetIndexBuffer(2,ExtBuffer2);
   SetIndexBuffer(3,ExtBuffer3);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("A&S");
   SetIndexLabel(0,"Speed");
   SetIndexLabel(1,"Acceleration");
   SetIndexLabel(2,"Speed+Offset");
   SetIndexLabel(3,"Acceleration+Offset");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Accelerator/Decelerator Oscillator                               |
//+------------------------------------------------------------------+
int start()
  {
   int    limit,Error;
//---- last counted bar will be recounted
   int counted_bars=IndicatorCounted();
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars-Bar;
   if(limit<1)limit=1;
//---- 
   if(ExtBuffer0[0]!=0)ExtBuffer0[0]=0;
   if(ExtBuffer1[0]!=0)ExtBuffer1[0]=0;
   if(ExtBuffer2[Bar]!=0)ExtBuffer2[Bar]=0;
   if(ExtBuffer3[Bar]!=0)ExtBuffer3[Bar]=0;
   for(int i=0; i<limit; i++)
   {
      ExtBuffer0[i]=(value(i)-value(i+Bar))/Point;
      ExtBuffer2[i+Bar]=ExtBuffer0[i];
   }

   for(i=0; i<limit; i++)
   {
      ExtBuffer1[i]=ExtBuffer0[i]-ExtBuffer0[i+Bar];
      ExtBuffer3[i+Bar]=ExtBuffer1[i];
   }
   if(Sp_vis==false)ArrayInitialize(ExtBuffer0,0.0);
   if(SpOf_vis==false)ArrayInitialize(ExtBuffer2,0.0);
   if(Ac_vis==false)ArrayInitialize(ExtBuffer1,0.0);
   if(AcOf_vis==false)ArrayInitialize(ExtBuffer3,0.0);
   
   Error=GetLastError();
   if(Error!=0 && Error!=1) {Print("Error START : ",Error);RefreshRates();}
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double value(int i)
{
  switch(Cena)
  {
      case 1:
         return(Open[i]);
      case 2:
         return(Close[i]);
      case 3:
         return(High[i]);
      case 4:
         return(Low[i]);
      case 5:
         return((High[i]+Low[i])/2);
      case 6:
         return((High[i]+Low[i]+Close[i])/3);
      case 7:
         return((High[i]+Low[i]+Close[i]+Open[i])/4);
      default:
         return((High[i]+Low[i]+Close[i]+Open[i])/4);
  }

}

