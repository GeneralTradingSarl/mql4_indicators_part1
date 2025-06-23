//+------------------------------------------------------------------+
//|                                                                  |
//|                                      Copyright © 2005,giulio     |
//|                                                                  |
//+------------------------------------------------------------------+


#property copyright "Copyright © 2005, Giulio "

#property indicator_chart_window
#property indicator_buffers 6
#property indicator_color1 White
#property indicator_color2 Red
#property indicator_color3 White
#property indicator_color4 Red
#property indicator_color5 White
#property indicator_color6 Red
#property indicator_style5 STYLE_DOT
#property indicator_style6 STYLE_DOT


double CrossUp[];
double CrossDown[];
extern int FasterEMA = 89; //Faster EMA Channel
extern int SlowerEMA = 144; //Slower EMA Channel
extern int  EXIT_Period=89; //Exit Period Channel
double highexit[];
double lowexit[];
extern int  Stop_loss=89; //Stop Loss Channel
double highstop[];
double lowstop[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_ARROW,0,2);
   SetIndexArrow(0,159);
   SetIndexBuffer(0,CrossUp);
   SetIndexStyle(1,DRAW_ARROW,0,2);
   SetIndexArrow(1,159);
   SetIndexBuffer(1,CrossDown);
   SetIndexStyle(2,DRAW_LINE,0,2);
   SetIndexStyle(3,DRAW_LINE,0,2);
   SetIndexBuffer(2,highexit);
   SetIndexBuffer(3,lowexit);
   SetIndexStyle(4,DRAW_LINE,2,0);
   SetIndexStyle(5,DRAW_LINE,2,0);
   SetIndexBuffer(4,highstop);
   SetIndexBuffer(5,lowstop);
   SetIndexStyle(6,DRAW_LINE,2,0);
   SetIndexLabel(0,"ENTRY LONG");
   SetIndexLabel(1,"ENTRY SHORT");
   SetIndexLabel(2,"LONG EXIT LINE");
   SetIndexLabel(3,"SHORT EXIT LINE");
   SetIndexLabel(4,"LONG STOPLOSS");
   SetIndexLabel(5,"SHORT STOP");

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
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start() 
  {
   int limit,i;
   double fasterEMA,slowerEMA,fasterEMAhigh,fasterEMAlow,slowerEMAlow,slowerEMAhigh,close,open;

   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;

   limit=Bars-counted_bars;

   for(i=0; i<=limit; i++)
     {

      fasterEMA = iMA(NULL, 0, FasterEMA, 0, MODE_EMA, PRICE_CLOSE, i+0);
      slowerEMA = iMA(NULL, 0, SlowerEMA, 0, MODE_EMA, PRICE_CLOSE, i+0);
      fasterEMAhigh= iMA(NULL,0,FasterEMA,0,MODE_EMA,PRICE_HIGH,i+0);
      fasterEMAlow = iMA(NULL, 0, FasterEMA, 0, MODE_EMA, PRICE_LOW, i+0);
      slowerEMAlow = iMA(NULL, 0, SlowerEMA, 0, MODE_EMA, PRICE_LOW, i+0);
      slowerEMAhigh= iMA(NULL,0,SlowerEMA,0,MODE_EMA,PRICE_HIGH,i+0);
      close= iClose(NULL,0,i+0);
      open = iOpen(NULL,0,i+0);
      highexit[i]= iHigh(Symbol(),Period(),iHighest(Symbol(),Period(),MODE_HIGH,EXIT_Period,i+1));
      lowexit[i] = iLow(Symbol(),Period(),iLowest(Symbol(),Period(),MODE_LOW,EXIT_Period,i+1));
      highstop[i]= iMA(NULL,0,Stop_loss,0,MODE_EMA,PRICE_LOW,i+0);
      lowstop[i] = iMA(NULL,0,Stop_loss,0,MODE_EMA,PRICE_HIGH,i+0);


      if(
         (((slowerEMA<fasterEMA) && (open<fasterEMAhigh) && (close>fasterEMAhigh)) || (open<slowerEMAhigh && close>slowerEMAhigh))
         )
        {         CrossUp[i+0]=High[i+0];      }
      else if(
         (((slowerEMA>fasterEMA) && (open>fasterEMAlow) && (close<fasterEMAlow)) || (open>slowerEMAlow && close<slowerEMAlow))
         )
           {          CrossDown[i+0]=Low[i+0];      }

     }
   return(0);
  }
//+------------------------------------------------------------------+
