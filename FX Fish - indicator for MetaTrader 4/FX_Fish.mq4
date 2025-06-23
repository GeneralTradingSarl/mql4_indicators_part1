//+------------------------------------------------------------------+
//|                                                                  |
//|                 Copyright © 2000-2007, MetaQuotes Software Corp. |
//|                                         http://www.metaquotes.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, Kiko Segui"
#property link      "webtecnic@terra.es"
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Lime
#property indicator_color2 Red
#property  indicator_level1  0
#property  indicator_level2  0.30
#property  indicator_level3 -0.30
//----
double buffer1[];
double buffer2[];
//----
extern int period=10;
extern int price=0;
extern bool Mode_Fast= False;
extern bool Signals= False;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,2,Lime);
   SetIndexBuffer(0,buffer1);
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID,2,Red);
   SetIndexBuffer(1,buffer2);
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   int i;
   double tmp;
//----
   for(i=0;i<Bars;i++)
     {
      ObjectDelete("SELL SIGNAL: "+DoubleToStr(i,0));
      ObjectDelete("BUY SIGNAL: "+DoubleToStr(i,0));
      ObjectDelete("EXIT: "+DoubleToStr(i,0));
     }
   return(0);
  }
double Value=0,Value1=0,Value2=0,Fish=0,Fish1=0,Fish2=0;
//----
int buy=0,sell=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int i;
   int barras;
   double _price;
   double tmp;
   double MinL=0;
   double MaxH=0;
   double Threshold=1.2;
//----
   barras=Bars;
   if (Mode_Fast)
      barras=100;
   i=0;
   while(i<barras)
     {
      MaxH=High[Highest(NULL,0,MODE_HIGH,period,i)];
      MinL=Low[Lowest(NULL,0,MODE_LOW,period,i)];
//----
      switch(price)
        {
         case 1: _price=Open[i]; break;
         case 2: _price=Close[i]; break;
         case 3: _price=High[i]; break;
         case 4: _price=Low[i]; break;
         case 5: _price=(High[i]+Low[i]+Close[i])/3; break;
         case 6: _price=(Open[i]+High[i]+Low[i]+Close[i])/4; break;
         case 7: _price=(Open[i]+Close[i])/2; break;
         default: _price=(High[i]+Low[i])/2; break;
        }
      Value=0.33*2*((_price-MinL)/(MaxH-MinL)-0.5) + 0.67*Value1;
      Value=MathMin(MathMax(Value,-0.999),0.999);
      Fish=0.5*MathLog((1+Value)/(1-Value))+0.5*Fish1;
//----
      buffer1[i]= 0;
      buffer2[i]= 0;
//----
      if((Fish<0) && (Fish1>0))
        {
         if (Signals)
           {
            ObjectCreate("EXIT: "+DoubleToStr(i,0),OBJ_TEXT,0,Time[i],_price);
            ObjectSetText("EXIT: "+DoubleToStr(i,0),"EXIT AT "+DoubleToStr(_price,4),7,"Arial",White);
           }
         buy=0;
        }
      if ((Fish>0) && (Fish1<0))
        {
         if (Signals)
           {
            ObjectCreate("EXIT: "+DoubleToStr(i,0),OBJ_TEXT,0,Time[i],_price);
            ObjectSetText("EXIT: "+DoubleToStr(i,0),"EXIT AT "+DoubleToStr(_price,4),7,"Arial",White);
           }
         sell=0;
        }
      if (Fish>=0)
        {
         buffer1[i]=Fish;
        }
      else
        {
         buffer2[i]=Fish;
        }
      tmp=i;
      if ((Fish<-Threshold) &&
          (Fish>Fish1) &&
          (Fish1<=Fish2))
        {
         if (Signals)
           {
            ObjectCreate("SELL SIGNAL: "+DoubleToStr(i,0),OBJ_TEXT,0,Time[i],_price);
            ObjectSetText("SELL SIGNAL: "+DoubleToStr(i,0),"SELL AT "+DoubleToStr(_price,4),7,"Arial",Red);
           }
         sell=1;
        }
      if ((Fish>Threshold) &&
           (Fish<Fish1) &&
           (Fish1>=Fish2))
        {
         if (Signals)
           {
            ObjectCreate("BUY SIGNAL: "+DoubleToStr(i,0),OBJ_TEXT,0,Time[i],_price);
            ObjectSetText("BUY SIGNAL: "+DoubleToStr(i,0),"BUY AT "+DoubleToStr(_price,4),7,"Arial",Lime);
           }
         buy=1;
        }
      Value1=Value;
      Fish2=Fish1;
      Fish1=Fish;
      i++;
     }
   return(0);
  }
//+------------------------------------------------------------------+