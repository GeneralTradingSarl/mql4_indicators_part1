//+------------------------------------------------------------------+
//|                                             DF-ProfitMonitor.mq4 |
//|                                         Copyright 2014, DonForex |
//|                                              http://donforex.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, DonForex"
#property link      "http://donforex.com"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Teal
#property indicator_width1 2
#property indicator_level1 0

extern string     Copyright_DonForex          = "http://donforex.com";
extern bool       SelectByMagicNumber         = False;
extern int        MagicNumber                 = 0;
extern color      FontColor                   = SteelBlue;
extern int        Corner                      = 0;


//--- buffers
double ExtMapBuffer1[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   
   IndicatorShortName("DF-ProfitMonitor || http://donforex.com");
   
   ObjectCreate("DF_PM_Name",OBJ_LABEL,0,0,0,0,0);
   ObjectSet("DF_PM_Name",OBJPROP_CORNER,Corner);
   ObjectSet("DF_PM_Name",OBJPROP_XDISTANCE,10);
   ObjectSet("DF_PM_Name",OBJPROP_YDISTANCE,15);
   ObjectSetText("DF_PM_Name","       DF-ProfitMonitor       ",8,"Courier New",FontColor);
   
   ObjectCreate("DF_PM_Line0",OBJ_LABEL,0,0,0,0,0);
   ObjectSet("DF_PM_Line0",OBJPROP_CORNER,Corner);
   ObjectSet("DF_PM_Line0",OBJPROP_XDISTANCE,10);
   ObjectSet("DF_PM_Line0",OBJPROP_YDISTANCE,15);
   ObjectSetText("DF_PM_Line0","__________________________",10,"Courier New",FontColor);
   
   ObjectCreate("DF_PM_Balance",OBJ_LABEL,0,0,0,0,0);
   ObjectSet("DF_PM_Balance",OBJPROP_CORNER,Corner);
   ObjectSet("DF_PM_Balance",OBJPROP_XDISTANCE,10);
   ObjectSet("DF_PM_Balance",OBJPROP_YDISTANCE,29);
   ObjectSetText("DF_PM_Balance","Balance:",12,"Courier New",FontColor);
   
   ObjectCreate("DF_PM_Equity",OBJ_LABEL,0,0,0,0,0);
   ObjectSet("DF_PM_Equity",OBJPROP_CORNER,Corner);
   ObjectSet("DF_PM_Equity",OBJPROP_XDISTANCE,10);
   ObjectSet("DF_PM_Equity",OBJPROP_YDISTANCE,43);
   ObjectSetText("DF_PM_Equity","Equity:",12,"Courier New",FontColor);
   
   ObjectCreate("DF_PM_Margin",OBJ_LABEL,0,0,0,0,0);
   ObjectSet("DF_PM_Margin",OBJPROP_CORNER,Corner);
   ObjectSet("DF_PM_Margin",OBJPROP_XDISTANCE,10);
   ObjectSet("DF_PM_Margin",OBJPROP_YDISTANCE,57);
   ObjectSetText("DF_PM_Margin","Margin:",20,"Courier New",FontColor);
   
   ObjectCreate("DF_PM_FreeMargin",OBJ_LABEL,0,0,0,0,0);
   ObjectSet("DF_PM_FreeMargin",OBJPROP_CORNER,Corner);
   ObjectSet("DF_PM_FreeMargin",OBJPROP_XDISTANCE,10);
   ObjectSet("DF_PM_FreeMargin",OBJPROP_YDISTANCE,71);
   ObjectSetText("DF_PM_FreeMargin","Free margin:",12,"Courier New",FontColor);
   
   ObjectCreate("DF_PM_Profit",OBJ_LABEL,0,0,0,0,0);
   ObjectSet("DF_PM_Profit",OBJPROP_CORNER,Corner);
   ObjectSet("DF_PM_Profit",OBJPROP_XDISTANCE,10);
   ObjectSet("DF_PM_Profit",OBJPROP_YDISTANCE,85);
   ObjectSetText("DF_PM_Profit","Acc. profit:",12,"Courier New",FontColor);
   
   ObjectCreate("DF_PM_Line1",OBJ_LABEL,0,0,0,0,0);
   ObjectSet("DF_PM_Line1",OBJPROP_CORNER,Corner);
   ObjectSet("DF_PM_Line1",OBJPROP_XDISTANCE,10);
   ObjectSet("DF_PM_Line1",OBJPROP_YDISTANCE,90);
   ObjectSetText("DF_PM_Line1","__________________________",10,"Courier New",FontColor);
   
   ObjectCreate("DF_PM_Copyright",OBJ_LABEL,0,0,0,0,0);
   ObjectSet("DF_PM_Copyright",OBJPROP_CORNER,Corner);
   ObjectSet("DF_PM_Copyright",OBJPROP_XDISTANCE,10);
   ObjectSet("DF_PM_Copyright",OBJPROP_YDISTANCE,104);
   ObjectSetText("DF_PM_Copyright","       www.donforex.com       ",8,"Courier New",FontColor);
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
   ObjectDelete("DF_PM_Name");
   ObjectDelete("DF_PM_Line0");
   ObjectDelete("DF_PM_Balance");
   ObjectDelete("DF_PM_Equity");
   ObjectDelete("DF_PM_Margin");
   ObjectDelete("DF_PM_FreeMargin");
   ObjectDelete("DF_PM_Profit");
   ObjectDelete("DF_PM_Line1");
   ObjectDelete("DF_PM_Copyright");

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   
//----      
   if(SelectByMagicNumber) ExtMapBuffer1[0]=MagicProfit(MagicNumber);
   else ExtMapBuffer1[0]=AccountProfit();
   
   ObjectSetText("DF_PM_Balance",StringConcatenate("Balance:     ",DoubleToStr(AccountBalance(),2)),12,"Courier New",FontColor);
   ObjectSetText("DF_PM_Equity",StringConcatenate("Equity:      ",DoubleToStr(AccountEquity(),2)),12,"Courier New",FontColor);
   ObjectSetText("DF_PM_Margin",StringConcatenate("Margin:      ",DoubleToStr(AccountMargin(),2)),12,"Courier New",FontColor);
   ObjectSetText("DF_PM_FreeMargin",StringConcatenate("Free margin: ",DoubleToStr(AccountFreeMargin(),2)),12,"Courier New",FontColor);
   ObjectSetText("DF_PM_Profit",StringConcatenate("Acc. profit: ",DoubleToStr(AccountProfit(),2)),12,"Courier New",FontColor);
   
      
//----
   return(0);
  }
//+------------------------------------------------------------------+

double MagicProfit(int Magic)
   {
   double profit=0;
   int total=OrdersTotal()-1;
   for (int cnt=total;cnt>=0;cnt--) 
      {
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if (OrderMagicNumber()==Magic) 
         {
         profit+=OrderProfit();
         }
      }
   return(profit);
   }