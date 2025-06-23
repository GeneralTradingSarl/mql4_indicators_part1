//+------------------------------------------------------------------+
//|                                                      Awesome.mq4 |
//|                   Copyright 2005-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright   "2005-2014, MetaQuotes Software Corp."
#property link        "http://www.mql4.com"
#property description "Awesome Oscillator, 4 colors, customizable"
#property strict

//--- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 5
#property  indicator_color1  Black
#property  indicator_color2  LimeGreen
#property  indicator_color3  Green
#property  indicator_color4  Red
#property  indicator_color5  Maroon

input int _periodfast=5; //Period fast
input int _periodslow=34; //Period slow
input ENUM_LINE_STYLE _linestyle=STYLE_SOLID; //Line style
input int _lineweight=2; //Line weight
input ENUM_MA_METHOD     _mamethod     = MODE_SMA;        // MA method
input ENUM_APPLIED_PRICE _appliedprice = PRICE_MEDIAN;    // Applied price
input color _clrup1=clrLimeGreen; // Color up strong
input color _clrup2=clrGreen;  // Color up weak
input color _clrdn1=clrRed;  //Color down strong
input color _clrdn2=clrMaroon;  //Color down weak


//--- buffers
double     ExtAOBuffer[];
double     ExtUpBuffer1[]; //light green, 1 strong
double     ExtUpBuffer2[]; // dark green, 2 weak
double     ExtDnBuffer1[]; //light red, 1 strong
double     ExtDnBuffer2[]; // dark red, 2 weak
//---
//--- bars minimum for calculation
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit(void)
  {
//--- drawing settings
   SetIndexStyle(0,DRAW_NONE);
   SetIndexStyle(1,DRAW_HISTOGRAM,_linestyle,_lineweight,_clrup1);
   SetIndexStyle(2,DRAW_HISTOGRAM,_linestyle,_lineweight,_clrup2);
   SetIndexStyle(3,DRAW_HISTOGRAM,_linestyle,_lineweight,_clrdn1);
   SetIndexStyle(4,DRAW_HISTOGRAM,_linestyle,_lineweight,_clrdn2);

   IndicatorDigits(Digits+1);
//--- start drawing from left to right, only after _periodslow bars
   SetIndexDrawBegin(0, _periodslow); 
   SetIndexDrawBegin(1, _periodslow); 
   SetIndexDrawBegin(2, _periodslow); 
   SetIndexDrawBegin(3, _periodslow); 
   SetIndexDrawBegin(4, _periodslow);
    
//--- 3 indicator buffers mapping
   SetIndexBuffer(0,ExtAOBuffer);
   SetIndexBuffer(1,ExtUpBuffer1);
   SetIndexBuffer(2,ExtUpBuffer2);
   SetIndexBuffer(3,ExtDnBuffer1);
   SetIndexBuffer(4,ExtDnBuffer2);

//--- name for DataWindow and indicator subwindow label
   IndicatorShortName("AO");
   SetIndexLabel(1,NULL);
   SetIndexLabel(2,NULL);
   SetIndexLabel(3,NULL);
   SetIndexLabel(4,NULL);
   
  }
//+------------------------------------------------------------------+
//| Awesome Oscillator                                               |
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
   int    i,limit=rates_total-prev_calculated;
   double prev=0.0,current;
//--- check for rates total
   if(rates_total<=_periodslow) //_datalimit)
      return(0);
//--- last counted bar will be recounted
   if(prev_calculated>0)
     {
      limit++;
      prev=ExtAOBuffer[limit];
     }
//--- macd
   for(i=0; i<limit; i++)
      ExtAOBuffer[i]=iMA(NULL,0,_periodfast,0,_mamethod,_appliedprice,i)-
                     iMA(NULL,0,_periodslow,0,_mamethod,_appliedprice,i);
//--- dispatch values between 2 buffers
   bool up=true;
   for(i=limit-1; i>=0; i--)
     {
      current=ExtAOBuffer[i];
      ExtUpBuffer1[i]=0;
      ExtUpBuffer2[i]=0;
      ExtDnBuffer1[i]=0;
      ExtDnBuffer2[i]=0;
      if(prev < current)                             //up
         if(current>=0) ExtUpBuffer1[i]=current;        //light green
         else           ExtDnBuffer2[i]=current;        //dark red
      else                                           //down
         if(current>=0) ExtUpBuffer2[i]=current;        //dark green
         else           ExtDnBuffer1[i]=current;        //light red 
      prev=current;
     }
//--- done
   return(rates_total);
  }
//+------------------------------------------------------------------+
