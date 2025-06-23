//+------------------------------------------------------------------+
//| CoeffofLine_true.mq4                                             |
//| Ramdass - Conversion only                                        |
//+------------------------------------------------------------------+
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 DarkKhaki
//----
extern int CountBars=300;
//---- buffers
double cfl[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- indicator line
   IndicatorBuffers(1);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,cfl);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| CoeffofLine_true                                                              |
//+------------------------------------------------------------------+
int start()
  {
   if (CountBars>=Bars) CountBars=Bars;
   SetIndexDrawBegin(0,Bars-CountBars+5+1);
   int i,shift,cnt,ndot1,ndot=5,counted_bars=IndicatorCounted();
   double TYVar,ZYVar,TIndicatorVar,ZIndicatorVar,M,N,AY,AIndicator;
//----
   if(Bars<=ndot) return(0);
//----
   shift=CountBars-ndot-1;
   while(shift>=0)
     {
      TYVar=0;
      ZYVar=0;
      N=0;
      M=0;
      TIndicatorVar=0;
      ZIndicatorVar=0;
      ndot1=ndot;
//----
      for(cnt=ndot; cnt>=1; cnt--) // n=5 -  по пяти точкам
        {
         ZYVar=ZYVar+(High[shift+cnt-1]+Low[shift+cnt-1])/2*(6-cnt);
         TYVar=TYVar+(High[shift+cnt-1]+Low[shift+cnt-1])/2;
         N=N+cnt*cnt; //равно 55
         M=M+cnt; //равно 15
         ZIndicatorVar=ZIndicatorVar+iMA(NULL,0,5,3,MODE_SMMA,PRICE_MEDIAN,shift+cnt-1)*(6-cnt);
         TIndicatorVar=TIndicatorVar+iMA(NULL,0,5,3,MODE_SMMA,PRICE_MEDIAN,shift+cnt-1);
        }
      AY=(TYVar+(N-2*ZYVar)*ndot/M)/M;
      AIndicator=(TIndicatorVar+(N-2*ZIndicatorVar)*ndot/M)/M;
      if (Symbol()=="EURUSD" || Symbol()=="GBPUSD" || Symbol()=="USDCAD" || Symbol()=="USDCHF"
       || Symbol()=="EURGBP" || Symbol()=="EURCHF" || Symbol()=="AUDUSD"
       || Symbol()=="GBPCHF")
      {cfl[shift]=(-1000)*MathLog(AY/AIndicator);}
      else {cfl[shift]=(1000)*MathLog(AY/AIndicator);}
      shift--;
     }
   return(0);
  }
//+------------------------------------------------------------------+