//+------------------------------------------------------------------+
//|                                              ATR exponential.mq4 |
//|                                    Copyright © 2011 Matus German |
//|                                        http://www.MTexperts.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, Matus German"
#property link      "http://www.MTexperts.net/"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 DodgerBlue
//---- input parameters
extern int AtrPeriod=14;
                      
//---- buffers
double AtrBuffer[];
double TempBuffer[];

int counted_bars=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- 1 additional buffer used for counting.
   IndicatorBuffers(2);
//---- indicator line
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,AtrBuffer);
   SetIndexBuffer(1,TempBuffer);
//---- name for DataWindow and indicator subwindow label
   short_name="ATR exponential("+AtrPeriod+")";
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
//----

   double pr=2.0/(AtrPeriod+1);
       i=Bars-2;
   if(counted_bars>2) i=Bars-counted_bars-1;
//---- main calculation loop
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
      //if(pos==Bars-2) ExtMapBuffer[pos+1]=Close[pos+1];
      AtrBuffer[i]=TempBuffer[i]*pr+AtrBuffer[i+1]*(1-pr);
 	   i--;
     }
   return(0);
}