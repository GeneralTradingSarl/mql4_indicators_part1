//+------------------------------------------------------------------+
//|                                                 at_Itp(t)Env.mq4 |
//|        at_Itp(t):    Copyright © 2005, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//|        Envelope:              Copyright © 2005, Nikolay Kositsin |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
//----
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Lime
#property indicator_color2 Blue
#property indicator_color3 Red
//----
extern int hours=4;
extern int s=10;
extern int cb=1000;
extern double Envelope_Shift=0.20;
extern int Shift=0;
double ci[];
double UperBuffer [];
double DownBuffer [];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
if(Period()>PERIOD_H4)
  {
   Alert("Timeframe must be H4 or less");
   return(INIT_FAILED);
  }

//---- drawing settings
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);
//---- IndexShift    
   SetIndexShift(0,Shift);
   SetIndexShift(1,Shift);
   SetIndexShift(2,Shift);
//----   
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS));
//----   
   SetIndexLabel (0, "Envelope+");
   SetIndexLabel (1, "at_Itp(t)");
   SetIndexLabel (2, "Envelope-");
//---- indicator buffers   
   IndicatorBuffers(3);
//---- indicator buffers mapping
   SetIndexBuffer (0, UperBuffer);
   SetIndexBuffer (1, ci);
   SetIndexBuffer (2, DownBuffer);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   //   int    counted_bars=IndicatorCounted();
   int i,x,m,pt,aa,bb,cc;
//----------------------------
   pt=hours*60/Period();
//-----------------------
   for(m=0; m<=s; m++)
     {
      i=0;
      while(i<=cb)
        {
         if (m==0) { ci[cb+pt]=Close[cb+pt]; ci[i]=Close[i]; ci[cb+2*pt]=Close[cb+2*pt];}
         if (m!=0 & m!=s) { ci[i+pt]=0.5*(ci[i]+ci[i+2*pt]); ci[0]=0.5*(ci[0]+ci[pt]);  ci[cb+2*pt]=0.5*(ci[cb+2*pt]+ci[cb+pt]); }
           if (m==s) { aa=i; bb=i+pt; cc=i+2*pt;
            for(x=i; x<=i+pt-1; x++)  {ci[x]=ci[aa]*((x-bb)*(x-cc))/((aa-bb)*(aa-cc))+ci[bb]*((x-aa)*(x-cc))/((bb-aa)*(bb-cc))+ci[cc]*((x-aa)*(x-bb))/((cc-aa)*(cc-bb));}
           }

         i=i+pt;
        }
     }
   //+------------------------------------------------------------------+
   //|                                                                  |
   //| Input indicator buffer: ci.                                      |
   //| Output indicator buffers: UperBuffer, DownBuffer.                |
   //+------------------------------------------------------------------+                                                                                                     |
   int ExtCountedBars=IndicatorCounted();
   int r;   r=Bars-ExtCountedBars-1;
   while(r>=0)
     {
      UperBuffer[r]=  ci[r]*(1+Envelope_Shift/100);
      DownBuffer[r]=  ci[r]/(1+Envelope_Shift/100);
      r--;
     }
   return(0);
  }
//+------------------------------------------------------------------+