//+------------------------------------------------------------------+ 
//|                                                  _BZ_Skyline.mq4 | 
//|                                                    Skyline, 2008 | 
//|                                      http://www.forexpertutti.it | 
//+------------------------------------------------------------------+ 
#property copyright "Skyline,2008"
#property link      "www.forexpertutti.it"
//----
#property indicator_chart_window
#property  indicator_buffers 7
#property  indicator_color1  White
#property  indicator_color2  RoyalBlue
#property  indicator_color3  Red
#property  indicator_color4  LimeGreen
#property  indicator_color5  LimeGreen
#property  indicator_color6  SlateBlue
#property  indicator_color7  SlateBlue
//----
#property  indicator_style1 2
#property  indicator_style2 2
#property  indicator_style3 2
#property  indicator_style4 2
#property  indicator_style5 2
#property  indicator_style6 2
#property  indicator_style7 2
//----
extern double myEntryTrigger  =4;
extern double myProfitTarget  =10;
extern double myStopLoss      =7;
extern int    Shift           =0;
extern color  myHourColor  =DarkGray;
extern int    myStyle      =STYLE_DOT;
extern bool   ShowLables   =false ;
//----
double OpenLine[];
double BuyLine1[];
double BuyLine2[];
double SellLine1[];
double SellLine2[];
double TargetLine1[];
double TargetLine2[];
double StopLossLine1[];
double StopLossLine2[];
//+------------------------------------------------------------------+ 
//| Custom indicator initialization function                         | 
//+------------------------------------------------------------------+ 
int init()
  {
//---- indicators 
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,OpenLine);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,BuyLine1);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,SellLine1);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,TargetLine1);
   SetIndexStyle(4,DRAW_LINE);
   SetIndexBuffer(4,TargetLine2);
   SetIndexStyle(5,DRAW_LINE);
   SetIndexBuffer(5,StopLossLine1);
   SetIndexStyle(6,DRAW_LINE);
   SetIndexBuffer(6,StopLossLine2);
//----
   SetIndexShift(0,Shift);
   SetIndexShift(1,Shift);
   SetIndexShift(2,Shift);
   SetIndexShift(3,Shift);
   SetIndexShift(4,Shift);
   SetIndexShift(5,Shift);
   SetIndexShift(6,Shift);
//---- 
   return(0);
  }
//+------------------------------------------------------------------+ 
//| Custom indicator deinitialization function                       | 
//+------------------------------------------------------------------+ 
int deinit()
  {
//----
   for( int i=ObjectsTotal() - 1; i>=0; i--)
     {
      string name=ObjectName( i );
      if(StringFind( name, "HourStart")>= 0)
         ObjectDelete( name );
      if(StringFind( name, "Hour")>= 0)
         ObjectDelete( name );
      if(StringFind( name,"OpenText")>= 0)
         ObjectDelete( name );
      if(StringFind( name, "SellEntry")>= 0)
         ObjectDelete( name );
      if(StringFind( name, "BuyEntry" )>= 0)
         ObjectDelete( name );
      if(StringFind( name, "ProfitTarget1")>= 0)
         ObjectDelete( name );
      if(StringFind( name, "ProfitTarget2")>= 0)
         ObjectDelete( name );
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+ 
//| Custom indicator iteration function                              | 
//+------------------------------------------------------------------+ 
int start()
  {
   int    counted_bars=IndicatorCounted();
   int limit;
//---- 
   if(TimeHour(Time[0])!= TimeHour(Time[1]))
     {
      double level= (High[1] + Low[1] + Close[1])/3;
      SetTimeLine("HourStart", "Hour", 0, White, level+10*Point); // draw the vertical bars that marks the time span 
     }
//---- last counted bar will be recounted 
   if(counted_bars>0) counted_bars--;
//----
   limit=Bars-counted_bars;
   for(int i=0; i<limit; i++)
     {
      int BarShift  =iBarShift(NULL,PERIOD_H1,Time[i],true);
      double OpenH1 =iOpen(NULL,PERIOD_H1,BarShift);
      OpenLine[i]   =OpenH1;
      BuyLine1[i]   =OpenH1+myEntryTrigger*Point;
      SellLine1[i]  =OpenH1-myEntryTrigger*Point;
      TargetLine1[i]=OpenH1+myProfitTarget*Point;
      TargetLine2[i]=OpenH1-myProfitTarget*Point;
      StopLossLine1[i]=iClose(NULL,0,i)+ myStopLoss*Point;
      StopLossLine2[i]=iClose(NULL,0,i)- myStopLoss*Point;
     }
//---- 
   if (ShowLables)  DisplayText();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DisplayText()
  {
   double OpenH1=iOpen(NULL,PERIOD_H1,0);
   ObjectDelete("OpenText");
   ObjectDelete("SellEntry");
   ObjectDelete("BuyEntry");
   ObjectDelete("ProfitTarget1");
   ObjectDelete("ProfitTarget2");
   // Text for Open Price 
   ObjectCreate("OpenText",OBJ_TEXT,0,Time[0],OpenH1);
   ObjectSetText("OpenText","Open price",8,"Verdana",White);
   // Text for Sell Entry 
   ObjectCreate("SellEntry",OBJ_TEXT,0,Time[0],OpenH1-myEntryTrigger*Point);
   ObjectSetText("SellEntry","Sell entry",8,"Verdana",Red);
   // Text for Buy Entry 
   ObjectCreate("BuyEntry",OBJ_TEXT,0,Time[0],OpenH1+myEntryTrigger*Point);
   ObjectSetText("BuyEntry","Buy entry",8,"Verdana",Blue);
   // Text for ProfitTarget1 
   ObjectCreate("ProfitTarget1",OBJ_TEXT,0,Time[0],OpenH1+myProfitTarget*Point);
   ObjectSetText("ProfitTarget1","Profit Target (BUY)",8,"Verdana",Green);
   // Text for ProfitTarget2 
   ObjectCreate("ProfitTarget2",OBJ_TEXT,0,Time[0],OpenH1-myProfitTarget*Point);
   ObjectSetText("ProfitTarget2","Profit Target (SELL)",8,"Verdana",Green);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetTimeLine(string objname, string text, int idx, color col1, double vleveltext)
  {
   string name= "[PIVOT] " + objname;
   int x= Time[idx];
   ObjectDelete(" Label");
//----
   if (ObjectFind(name)!=0)
      ObjectCreate(name, OBJ_TREND, 0, x, 0, x, 100);
     else 
     {
      ObjectMove(name, 0, x, 0);
      ObjectMove(name, 1, x, 100);
     }
   ObjectSet(name, OBJPROP_STYLE, myStyle);
   ObjectSet(name, OBJPROP_COLOR, myHourColor);
//----
   if (ObjectFind(name + " Label")!=0)
      ObjectCreate(name + " Label", OBJ_TEXT, 0, x, vleveltext);
   else
      ObjectMove(name + " Label", 0, x, vleveltext);
//----
   ObjectSetText(name + " Label", text, 8, "Arial", col1);
  }
//+------------------------------------------------------------------+