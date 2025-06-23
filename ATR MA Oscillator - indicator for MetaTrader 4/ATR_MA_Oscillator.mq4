
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 DodgerBlue
#property  indicator_width1  2
//---- input parameters
extern int AtrPeriod=112;
extern int SignalSMA=109;
extern int Type_MA_ATR=2;
extern int Type_MA=2;
//---- buffers
double AtrBuffer[];
double TempBuffer[];
double OsmaBuffer[];
double SignalBuffer[];

int init()
  {
   string short_name;
//---- 4 additional buffer used for counting.
   IndicatorBuffers(4);
//---- indicator line
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexDrawBegin(0,SignalSMA);
   IndicatorDigits(Digits+2);
   
   SetIndexBuffer(0,OsmaBuffer);
   SetIndexBuffer(1,AtrBuffer);
   SetIndexBuffer(2,TempBuffer);
   SetIndexBuffer(3,SignalBuffer);
   
//---- name for DataWindow and indicator subwindow label
   short_name="ATR MA Oscillator ("+AtrPeriod+","+SignalSMA+",Type MA ATR="+Type_MA_ATR+",Type MA Signal="+Type_MA+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
//----
   SetIndexDrawBegin(0,AtrPeriod);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Average True Range                                               |
//+------------------------------------------------------------------+
int start()
  {
   int i,counted_bars=IndicatorCounted();
//----
   if(Bars<=AtrPeriod) return(0);
//---- initial zero
   if(counted_bars<1)
      for(i=1;i<=AtrPeriod;i++) AtrBuffer[Bars-i]=0.0;
   i=Bars-counted_bars-1;
   
   while(i>=0)
     {
      double high=High[i];
      double low =Low[i];
      if(i==Bars-1) TempBuffer[i]=high-low;
      else
        {
         double prevclose=Close[i+1];
         TempBuffer[i]=MathMax(high,prevclose)-MathMin(low,prevclose);
        }
      i--;
     }

   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   for(i=0; i<limit; i++)
     
      AtrBuffer[i]=iMAOnArray(TempBuffer,Bars,AtrPeriod,0,Type_MA_ATR,i);
   for(i=0; i<limit; i++)   
      SignalBuffer[i]=iMAOnArray(AtrBuffer,Bars,SignalSMA,0,Type_MA,i);
   for(i=0; i<limit; i++) 
      { 
      OsmaBuffer[i]=AtrBuffer[i]-SignalBuffer[i];
      }
   return(0);
  }


