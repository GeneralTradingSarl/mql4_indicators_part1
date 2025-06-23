//+------------------------------------------------------------------+
//|                                                  Delta Force.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2004, MetaQuotes Software Corp."
#property  link      "http://www.metaquotes.net/"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 2
#property  indicator_color1  LimeGreen
#property  indicator_color2  Red
//---- indicator buffers
double ind_buffer1[];
double ind_buffer2[];
double ind_buffer3[];
//----
double CB = 0, valueh1 = 0, valuel = 0, valueh = 0, value = 0, price = 0, hi = 1, lo = 1;
double resh = 0, resl = 0, deltah = 0, deltal = 0;
int CurrentBar=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- 1 additional buffer used for counting.
   IndicatorBuffers(3); 
//---- drawing settings
   SetIndexStyle(0, DRAW_HISTOGRAM, STYLE_SOLID, 2);
   SetIndexStyle(1, DRAW_HISTOGRAM, STYLE_SOLID, 2);
   IndicatorDigits(MarketInfo(Symbol(), MODE_DIGITS) + 1);
   SetIndexDrawBegin(0, 34);
   SetIndexDrawBegin(1, 34);
//---- 3 indicator buffers mapping
   if(!SetIndexBuffer(0, ind_buffer1) &&
      !SetIndexBuffer(1, ind_buffer2) &&
      !SetIndexBuffer(2, ind_buffer3))
      Print("cannot set indicator buffers!");
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("DeltaForce");
   SetIndexLabel(0, "DF1");
   SetIndexLabel(1, "DF2");       
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Delta Force                                                      |
//+------------------------------------------------------------------+
int start()
  {
   for(CB = 0 ; CB <= Bars ; CB++)
     {
       CurrentBar = Bars - CB;
       if(Close[CurrentBar] > Close[CurrentBar+1]) 
         {
           resl = 0;
           if(resh == 0)  
               deltah = 0;
           deltah = deltah + (Close[CurrentBar] - Close[CurrentBar+1]);
           // valueh =  High[CurrentBar];
           resh=  1;
         }
       if(resh == 0) 
           deltah = 0;
       ind_buffer1[CurrentBar] = deltah;
       if(Close[CurrentBar] < Close[CurrentBar+1] )
         {
           resh = 0;
           if(resl == 0) 
               deltal = 0;
           deltal = deltal + (Close[CurrentBar+1] - Close[CurrentBar]);
           //valuel = Low[CurrentBar];
           resl= 1;
         }
       if(resl == 0 ) 
           deltal=0;
       ind_buffer2[CurrentBar] = deltal;
     }
//---- done
   return(0);
  }
//+------------------------------------------------------------------+  