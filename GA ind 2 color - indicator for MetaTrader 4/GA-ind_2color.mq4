//+------------------------------------------------------------------+
//|                                                       GA-ind.mq4 |
//|                      Copyright © 2008, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 4
#property  indicator_color1  Gray
#property  indicator_color2  Blue
#property  indicator_color3  Red
#property  indicator_color4  Yellow
#property  indicator_width1  1
#property  indicator_width2  1
#property  indicator_width3  1

//---- indicator parameters
extern int FastEMA=8;
extern int SlowEMA=26;
extern int SignalSMA=8;
//---- indicator buffers
double     MacdBufferUp[];
double     MacdBufferDn[];
double     SignalBuffer[];
double     MacdBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- drawing settings
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexStyle(1,DRAW_ARROW);  
   SetIndexStyle(2,DRAW_ARROW);    
   
   SetIndexStyle(3,DRAW_LINE);
   SetIndexDrawBegin(3,SignalSMA);
   IndicatorDigits(Digits+1);
//---- indicator buffers mapping
   SetIndexBuffer(0,MacdBuffer);
   SetIndexBuffer(1,MacdBufferUp);
   SetIndexBuffer(2,MacdBufferDn);   
   
   
   SetIndexBuffer(3,SignalBuffer);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("MACD("+FastEMA+","+SlowEMA+","+SignalSMA+")");
   SetIndexLabel(0,"");
   SetIndexLabel(1,"MACD UP");   
   SetIndexLabel(2,"MACD DN");    
   
   
   SetIndexLabel(3,"Signal");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Moving Averages Convergence/Divergence                           |
//+------------------------------------------------------------------+
int start()
  {
  

  
   int limit;
   int counted_bars=IndicatorCounted();
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;

      for(int i=0; i<limit; i++)MacdBuffer[i]=iMA(NULL,0,FastEMA,0,MODE_EMA,PRICE_CLOSE,i)+iMA(NULL,0,SlowEMA,0,MODE_EMA,PRICE_CLOSE,i);

      for(i=0; i<limit; i++)SignalBuffer[i]=iMAOnArray(MacdBuffer,Bars,SignalSMA,0,MODE_SMA,i);
      
      for(i=0; i<limit; i++){
         MacdBufferUp[i]=EMPTY_VALUE;
         MacdBufferDn[i]=EMPTY_VALUE;         
         
            if(MacdBuffer[i]>SignalBuffer[i]){
               MacdBufferUp[i]=MacdBuffer[i];
            }
            if(MacdBuffer[i]<SignalBuffer[i]){
               MacdBufferDn[i]=MacdBuffer[i];            
            }            
         
      }
      
//---- done
   return(0);
  }

