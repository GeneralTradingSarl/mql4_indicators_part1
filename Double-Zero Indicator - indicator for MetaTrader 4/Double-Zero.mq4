//+------------------------------------------------------------------+
//|                                            Double-Zero-Visualizer|
//+------------------------------------------------------------------+

#property  copyright "ps"
#property  link      ""
//---- indicator settings
#property  indicator_chart_window
#property  indicator_buffers 1
#property  indicator_color1  Lime
#property  indicator_width1  1

//---- indicator parameters
extern int relDigitPos=2;  // position of the relevant digit. 
                      // example1: a setting of "2"  in a market at the level of 1,2312  (taxed by 4 digits) makes the indicator visualize 1,2300
                      // example2: a setting of "3"  in a market at the level of 1,23125 (taxed by 5 digits) makes the indicator visualize 1,23100
                      // example3: a setting of "1"  in a market at the level of 1,23125 (taxed by 5 digits) makes the indicator visualize 1,20000
                      // example4: a setting of "-1" in a market at the level of 123,15  (taxed by 2 digits) makes the indicator visualize 120,00

//---- indicator 
double buf[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- drawing settings
   SetIndexStyle(0,DRAW_LINE);
   
//---- indicator buffers mapping
   SetIndexBuffer(0,buf);
   
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("Double-Zero-Visualizer");
   SetIndexLabel(0,"Nearest Double-Zero");
   
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| now do the dance.                           |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int counted_bars=IndicatorCounted();
   
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;

//---- calculate values
   for(int i=0; i<limit; i++) {
      buf[i]=getNearestDoubleZero(iClose(Symbol(),PERIOD_M1,i*Period()),relDigitPos);
   }
   
   return(0);
  }

double getNearestDoubleZero(double price, int pos) {
   double factor=MathPow(10, pos);
   return(MathRound(price*factor)/factor);
}