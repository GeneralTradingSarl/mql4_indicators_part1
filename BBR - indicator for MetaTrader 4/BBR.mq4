//+------------------------------------------------------------------+
//|                                                          BBR.mq4 |
//|          Bollinger Bands Breakout Reversal with RSI confirmation |
//+------------------------------------------------------------------+
#property copyright "Copyright @ 2011, downspin"
#property link      "mg@downspin.de"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Green
#property indicator_color2 Red
#property indicator_color3 DarkSlateGray

extern int corner=0,
x_dist=3,
y_dist=10;

double up[],
down[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(2);
   SetIndexStyle(0,DRAW_ARROW); SetIndexArrow(0,233); SetIndexBuffer(0,up);
   SetIndexStyle(1,DRAW_ARROW); SetIndexArrow(1,234); SetIndexBuffer(1,down);
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete("rsi");
   ObjectDelete("bb");
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   double rsi0,rsi1,rsi2,bbu0,bbu1,bbl0,bbl1;
   color rsicol=indicator_color3,
   bbcol=indicator_color3;

   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+1;

   for(int i=limit;i>=0;i--)
     {
      rsi0=iRSI(Symbol(),0,7,5,i);
      rsi1=iRSI(Symbol(),0,7,5,i+1);
      rsi2=iRSI(Symbol(),0,7,5,i+2);
      bbu0=iBands(Symbol(),0,20,2,1,0,1,i);
      bbu1=iBands(Symbol(),0,20,2,1,0,1,i+1);
      bbl0=iBands(Symbol(),0,20,2,1,0,2,i);
      bbl1=iBands(Symbol(),0,20,2,1,0,2,i+1);
      if((Low[i+1]<bbl1 || Low[i]<bbl0) && (rsi1<20 || rsi2<20) && rsi0>rsi1)
        {
         up[i]=Low[i]-5*Point;
        }
      if((High[i+1]>bbu1 || High[i]>bbu0) && (rsi1>80 || rsi2>80) && rsi0<rsi1)
        {
         down[i]=High[i]+5*Point;
        }
      if(i==0)
        {
         if(rsi0<20 || rsi1<20 || rsi2<20 || rsi0>80 || rsi1>80 || rsi2>80) rsicol=Orange;
         if((rsi1<20||rsi2<20)&&rsi0>rsi1) rsicol=Green;
         if((rsi1>80||rsi2>80)&&rsi0<rsi1) rsicol=Red;
         if(High[i]>bbu0 || High[i+1]>bbu1) bbcol=Red;
         if(Low[i]<bbl0 || Low[i+1]<bbl1) bbcol=Green;
         ObjectCreate("rsi",OBJ_LABEL,0,0,0);
         ObjectSetText("rsi","RSI",8,"Arial Bold",rsicol);
         ObjectSet("rsi",OBJPROP_CORNER,0);
         ObjectSet("rsi",OBJPROP_XDISTANCE,x_dist);
         ObjectSet("rsi",OBJPROP_YDISTANCE,y_dist);
         ObjectCreate("bb",OBJ_LABEL,0,0,0);
         ObjectSetText("bb","BB",8,"Arial Bold",bbcol);
         ObjectSet("bb",OBJPROP_CORNER,0);
         ObjectSet("bb",OBJPROP_XDISTANCE,x_dist+23);
         ObjectSet("bb",OBJPROP_YDISTANCE,y_dist);
        }
     }
   return(0);
  }
//+------------------------------------------------------------------+
