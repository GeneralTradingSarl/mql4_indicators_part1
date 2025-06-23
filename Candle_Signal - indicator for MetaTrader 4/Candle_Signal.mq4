//+------------------------------------------------------------------+
//|                                                Candle_Signal.mq4 |
//|                      Copyright © 2006, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, MetaQuotes Software Corp."
#property link      " cja "
//----
#property indicator_chart_window
//----
extern int PIP_Difference=15;
extern int PERIOD=240;//0 = all timeframes
extern string IIIIIIIIIIIIIIIIIIIIIIIII="<<<< Alert TEXT on Screen >>>>>>>>>>>>>>>>>";
extern bool Show_AlertTEXT=true;
extern string IIIIIIIIIIIIIIIIIIIIIIIIII="<<<< POP/UP Alert >>>>>>>>>>>>>>>>>>>>>>>>";
extern bool AlertON=true;
extern int Shift_UP_DN=0;
extern int Shift_Left_Right=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectsDeleteAll(0,OBJ_LABEL);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
   double PIPS,PPIPS,TARGET_UP,TARGET_DN;
   //double OPEN = iOpen(NULL,30,0);
   // double CLOSE = iClose(NULL,30,0);
   double CUROPEN=iOpen(NULL,PERIOD,0);
   double PREVCLOSE=iClose(NULL,PERIOD,1);
   PIPS= (PREVCLOSE-Bid);
   PPIPS= (PREVCLOSE+Ask);
   TARGET_UP=((PREVCLOSE+PIP_Difference*Point));
   TARGET_DN=((PREVCLOSE-PIP_Difference*Point));
   string PRC1="";
   //PRICE = iMA(Symbol(),0,1,0,MODE_EMA,PRICE_CLOSE,0);
   if(Show_AlertTEXT==true)
     {
      string CandleSignal="",CandleSignal2="",CandleSignal3=""; color col=clrNONE,col2=clrNONE,col3=clrNONE;
//----
      CandleSignal="Currently Signals Pending ................................."; col= C'250,250,0';
        if((Ask)>=(PREVCLOSE+PIP_Difference*Point)){CandleSignal="ALERT : PRICE Above Previous CLOSE By [ "+(DoubleToStr(PIP_Difference,Digits-4))+" ] "+"";
         col=C'0,225,0';
        }
        if((Bid)<=(PREVCLOSE-PIP_Difference*Point)){CandleSignal="ALERT : PRICE Below Previous CLOSE By [ "+(DoubleToStr(PIP_Difference,Digits-4))+" ] "+"";
         col=C'250,0,0';
        }
        if((Ask)>=(PREVCLOSE)){CandleSignal2="Upper Entry Target [ "+(DoubleToStr(TARGET_UP,Digits))+" ] "+"";
         col2=C'180,225,0';
        }
        if((Bid)<=(PREVCLOSE)){CandleSignal2="Lower Entry Target [ "+(DoubleToStr(TARGET_DN,Digits))+" ] "+"";
         col2=C'250,100,0';
        }
      // Determin whether Open above/Below Previous Close                                          
        if((CUROPEN)>=(PREVCLOSE)){CandleSignal3="OPEN > PREV / CLOSE"+"";
         col3=C'0,225,0';
        }
        if((CUROPEN)<(PREVCLOSE)){CandleSignal3="OPEN < PREV / CLOSE"+"";
         col3=C'250,0,0';
        }
      ObjectCreate("CandleSignal", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("CandleSignal", CandleSignal, 12,"Arial Bold", col);
      ObjectSet("CandleSignal", OBJPROP_CORNER, 0);
      ObjectSet("CandleSignal", OBJPROP_XDISTANCE, 250+Shift_Left_Right);
      ObjectSet("CandleSignal", OBJPROP_YDISTANCE, 20+Shift_UP_DN);
//----
      ObjectCreate("CandleSignal2", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("CandleSignal2", CandleSignal2, 12,"Arial Bold", col2);
      ObjectSet("CandleSignal2", OBJPROP_CORNER, 0);
      ObjectSet("CandleSignal2", OBJPROP_XDISTANCE, 250+Shift_Left_Right);
      ObjectSet("CandleSignal2", OBJPROP_YDISTANCE, 52+Shift_UP_DN);
//----
      ObjectCreate("CandleSignal3", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("CandleSignal3", CandleSignal3, 7,"Arial Bold", col3);
      ObjectSet("CandleSignal3", OBJPROP_CORNER, 0);
      ObjectSet("CandleSignal3", OBJPROP_XDISTANCE, 362+Shift_Left_Right);
      ObjectSet("CandleSignal3", OBJPROP_YDISTANCE, 8+Shift_UP_DN);
//----
      ObjectCreate("Signal1", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("Signal1","Signal Auto Display", 9, "Arial", Silver);
      ObjectSet("Signal1", OBJPROP_CORNER, 0);
      ObjectSet("Signal1", OBJPROP_XDISTANCE, 250+Shift_Left_Right);
      ObjectSet("Signal1", OBJPROP_YDISTANCE, 5+Shift_UP_DN);
//----
      ObjectCreate("Signal2", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("Signal2","Target  TF = [ "+(string)PERIOD+" ]", 9, "Arial", Silver);
      ObjectSet("Signal2", OBJPROP_CORNER, 0);
      ObjectSet("Signal2", OBJPROP_XDISTANCE, 250+Shift_Left_Right);
      ObjectSet("Signal2", OBJPROP_YDISTANCE, 37+Shift_UP_DN);
//----      
      double Price1=iMA(Symbol(),0,1,0,MODE_EMA,PRICE_CLOSE,0);
      PRC1=DoubleToStr(Price1,Digits);
//----
      ObjectCreate("Signalprice", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("Signalprice",""+PRC1+"", 30, "Arial",  col);
      ObjectSet("Signalprice", OBJPROP_CORNER, 0);
      ObjectSet("Signalprice", OBJPROP_XDISTANCE,250+Shift_Left_Right);
      ObjectSet("Signalprice", OBJPROP_YDISTANCE, 70+Shift_UP_DN);
     }
   if (AlertON==true)
     {
        if((Ask)>=(PREVCLOSE+PIP_Difference*Point)){   if (BarChanged())
           {
           Alert(Symbol()," M",Period()," ALERT : PRICE Above CLOSE By [ "+(DoubleToStr(PIP_Difference,Digits-4))+" ] "+"");
           }
           }
        if((Bid)<=(PREVCLOSE-PIP_Difference*Point)){   if (BarChanged())
           {
           Alert(Symbol()," M",Period()," ALERT : PRICE Below CLOSE By [ "+(DoubleToStr(PIP_Difference,Digits-4))+" ] "+"");
           }
           }
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
bool BarChanged()
  {
   static datetime dt=0;
   if (dt!=Time[0])
     {
      dt=Time[0];
      return(true);
     }
   return(false);
  }
//---- done

//+------------------------------------------------------------------+