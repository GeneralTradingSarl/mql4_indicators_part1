//+------------------------------------------------------------------+
//|                                              DF-DonchianFibo.mq4 |
//|                                         Copyright 2014, DonForex |
//|                                              http://donforex.com |
//+------------------------------------------------------------------+
#property copyright   "Copyright 2014, DonForex"
#property link        "http://donforex.com"
#property description "DonForex - DonchianFibo indicator"
#property version     "1.01"
#property strict

//---- indicator settings
#property  indicator_chart_window
#property  indicator_buffers 7
#property  indicator_color1  clrOrchid
#property  indicator_color2  clrDarkOrange
#property  indicator_color3  clrChartreuse
#property  indicator_color4  clrSteelBlue
#property  indicator_color5  clrChartreuse
#property  indicator_color6  clrDarkOrange
#property  indicator_color7  clrOrchid
#property  indicator_width1  1
#property  indicator_width2  1
#property  indicator_width3  1
#property  indicator_width4  1
#property  indicator_width5  1
#property  indicator_width6  1
#property  indicator_width7  1


//---- indicator parameters
extern string Copyright                  = "http://donforex.com";
extern int    Donchian_Period            = 55;
extern bool   Ignore_Candle_Wicks        = false;
extern bool   Show_Prices                = true;
extern color  Val_1_Color                = clrOrchid;
extern color  Val_2_Color                = clrDarkOrange;
extern color  Val_3_Color                = clrChartreuse;
extern color  Val_4_Color                = clrSteelBlue;
extern color  Val_5_Color                = clrChartreuse;
extern color  Val_6_Color                = clrDarkOrange;
extern color  Val_7_Color                = clrOrchid;

//---- indicator buffers
double Val_1[];
double Val_2[];
double Val_3[];
double Val_4[];
double Val_5[];
double Val_6[];
double Val_7[];

double Diff;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {

//---- drawing settings
   IndicatorBuffers(7);
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID);
   SetIndexStyle(1,DRAW_LINE,STYLE_DOT);
   SetIndexStyle(2,DRAW_LINE,STYLE_DOT);
   SetIndexStyle(3,DRAW_LINE,STYLE_DOT);
   SetIndexStyle(4,DRAW_LINE,STYLE_DOT);
   SetIndexStyle(5,DRAW_LINE,STYLE_DOT);
   SetIndexStyle(6,DRAW_LINE,STYLE_SOLID);

//---- indicator buffers mapping
   SetIndexBuffer(0,Val_1);
   SetIndexBuffer(1,Val_2);
   SetIndexBuffer(2,Val_3);
   SetIndexBuffer(3,Val_4);
   SetIndexBuffer(4,Val_5);
   SetIndexBuffer(5,Val_6);
   SetIndexBuffer(6,Val_7);

//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("DonFibo");
   SetIndexLabel(0,"Val_1");
   SetIndexLabel(1,"Val_2");
   SetIndexLabel(2,"Val_3");
   SetIndexLabel(3,"Val_4");
   SetIndexLabel(4,"Val_5");
   SetIndexLabel(5,"Val_6");
   SetIndexLabel(6,"Val_7");

/* PLEASE, DON'T REMOVE IT!*/
   Comment(StringConcatenate("DF-DonchianFibo (",Donchian_Period,") >> http://donforex.com"));
/* PLEASE, DON'T REMOVE IT!*/

   if(Show_Prices)
     {
      ObjectCreate("DFDonFibo_1",OBJ_ARROW,0,Time[0],Close[0]);
      ObjectSet("DFDonFibo_1",OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
      ObjectSet("DFDonFibo_1",OBJPROP_COLOR,Val_1_Color);
      ObjectCreate("DFDonFibo_2",OBJ_ARROW,0,Time[0],Close[0]);
      ObjectSet("DFDonFibo_2",OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
      ObjectSet("DFDonFibo_2",OBJPROP_COLOR,Val_2_Color);
      ObjectCreate("DFDonFibo_3",OBJ_ARROW,0,Time[0],Close[0]);
      ObjectSet("DFDonFibo_3",OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
      ObjectSet("DFDonFibo_3",OBJPROP_COLOR,Val_3_Color);
      ObjectCreate("DFDonFibo_4",OBJ_ARROW,0,Time[0],Close[0]);
      ObjectSet("DFDonFibo_4",OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
      ObjectSet("DFDonFibo_4",OBJPROP_COLOR,Val_4_Color);
      ObjectCreate("DFDonFibo_5",OBJ_ARROW,0,Time[0],Close[0]);
      ObjectSet("DFDonFibo_5",OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
      ObjectSet("DFDonFibo_5",OBJPROP_COLOR,Val_5_Color);
      ObjectCreate("DFDonFibo_6",OBJ_ARROW,0,Time[0],Close[0]);
      ObjectSet("DFDonFibo_6",OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
      ObjectSet("DFDonFibo_6",OBJPROP_COLOR,Val_6_Color);
      ObjectCreate("DFDonFibo_7",OBJ_ARROW,0,Time[0],Close[0]);
      ObjectSet("DFDonFibo_7",OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
      ObjectSet("DFDonFibo_7",OBJPROP_COLOR,Val_7_Color);
     }

//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   int obj_total=ObjectsTotal();
   for(int i=obj_total; i>=0; i--)
     {
      string Obj_Name=ObjectName(i);
      if(StringFind(Obj_Name,"DFDonFibo_",0)>-1) ObjectDelete(Obj_Name);
     }

   Comment("");

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- the last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;

//---- calculate values

   if(!Ignore_Candle_Wicks)
     {
      for(int i=0; i<limit; i++)
        {
         Val_7[i]=iHigh(Symbol(),Period(),iHighest(Symbol(),Period(),MODE_HIGH,Donchian_Period,i));
         Val_1[i]=iLow(Symbol(),Period(),iLowest(Symbol(),Period(),MODE_LOW,Donchian_Period,i));

         Diff=Val_7[i]-Val_1[i];
         Val_2[i]=Val_1[i]+Diff*0.236;
         Val_3[i]=Val_1[i]+Diff*0.382;
         Val_4[i]=Val_1[i]+Diff*0.5;
         Val_5[i]=Val_1[i]+Diff*0.618;
         Val_6[i]=Val_1[i]+Diff*0.764;
        }
     }

   if(Ignore_Candle_Wicks)
     {
      for(int i=0; i<limit; i++)
        {
         int HighestBodyIndex=0;
         double HighestValue=0;
         for(int w=0;w<Donchian_Period;w++)
           {
            if(i+w<Bars)
              {
               if(MathMax(Open[w+i],Close[w+i])>HighestValue)
                 {
                  HighestValue=MathMax(Open[w+i],Close[w+i]);
                  HighestBodyIndex=w+i;
                 }
              }
           }
         Val_7[i]=MathMax(Open[HighestBodyIndex],Close[HighestBodyIndex]);

         int LowestBodyIndex=0;
         double LowestValue=9999999;
         for(int w=0;w<Donchian_Period;w++)
           {
            if(i+w<Bars)
              {
               if(MathMin(Open[w+i],Close[w+i])<LowestValue)
                 {
                  LowestValue=MathMin(Open[w+i],Close[w+i]);
                  LowestBodyIndex=w+i;
                 }
              }
           }
         Val_1[i]=MathMin(Open[LowestBodyIndex],Close[LowestBodyIndex]);

         Diff=Val_7[i]-Val_1[i];
         Val_2[i]=Val_1[i]+Diff*0.236;
         Val_3[i]=Val_1[i]+Diff*0.382;
         Val_4[i]=Val_1[i]+Diff*0.5;
         Val_5[i]=Val_1[i]+Diff*0.618;
         Val_6[i]=Val_1[i]+Diff*0.764;
        }
     }

   if(Show_Prices)
     {
     ObjectMove(0,"DFDonFibo_1",0,Time[0],Val_1[0]);
     ObjectMove(0,"DFDonFibo_2",0,Time[0],Val_2[0]);
     ObjectMove(0,"DFDonFibo_3",0,Time[0],Val_3[0]);
     ObjectMove(0,"DFDonFibo_4",0,Time[0],Val_4[0]);
     ObjectMove(0,"DFDonFibo_5",0,Time[0],Val_5[0]);
     ObjectMove(0,"DFDonFibo_6",0,Time[0],Val_6[0]);
     ObjectMove(0,"DFDonFibo_7",0,Time[0],Val_7[0]);      
     }

//---- done
   return(0);
  }
//+------------------------------------------------------------------+
