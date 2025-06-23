//+------------------------------------------------------------------+
//|                                                      hotKeys.mq4 |
//|                                    Copyright 2015, Mohit Marwaha |
//|                                             marwaha1@gmail.com   |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Mohit Marwaha"
#property link      "marwaha1@gmail.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property description "marwaha1@gmail.com"
#property description "The indicator will change the timeframe of the chart with key press"
#property description "M - Monthly, W - Weekly, D - Daily, 4 - 4Hr, 1 - 1Hr, 3 - 30Mins, f - 15Mins, 5 - 5Mins"
#define KEY_MONTHLY 57
#define KEY_WEEKLY 56
#define KEY_DAILY 55
#define KEY_4HOUR 54
#define KEY_1HOUR 53
#define KEY_5MIN 50
#define KEY_30MIN 52
#define KEY_15MIN 51
#define KEY_1MIN 49
#define KEY_CHARTFIX 48
#define KEY_P 80

extern bool showInfo=true;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {

   if(showInfo==true)
     {
      ObjectCreate("Obj1",OBJ_LABEL,0,0,0);
      ObjectSetText("Obj1",Symbol()+"-"+IntegerToString(Period())+" Min",12,"Calibri",DodgerBlue);
      ObjectSet("Obj1",OBJPROP_CORNER,0);
      ObjectSet("Obj1",OBJPROP_XDISTANCE,15);
      ObjectSet("Obj1",OBJPROP_YDISTANCE,10);

      ObjectCreate("Obj2",OBJ_LABEL,0,0,0);
      ObjectSetText("Obj2","Ask:"+DoubleToStr(Ask),8,"Verdana",Red);
      ObjectSet("Obj2",OBJPROP_CORNER,0);
      ObjectSet("Obj2",OBJPROP_XDISTANCE,15);
      ObjectSet("Obj2",OBJPROP_YDISTANCE,30);

      ObjectCreate("Obj3",OBJ_LABEL,0,0,0);
      ObjectSetText("Obj3","Bid:"+DoubleToStr(Bid),8,"Verdana",Green);
      ObjectSet("Obj3",OBJPROP_CORNER,0);
      ObjectSet("Obj3",OBJPROP_XDISTANCE,15);
      ObjectSet("Obj3",OBJPROP_YDISTANCE,40);

      ObjectCreate("Obj4",OBJ_LABEL,0,0,0);
      ObjectSetText("Obj4","Spread:"+DoubleToStr(NormalizeDouble((Ask-Bid),5)),8,"Verdana",Gray);
      ObjectSet("Obj4",OBJPROP_CORNER,0);
      ObjectSet("Obj4",OBJPROP_XDISTANCE,15);
      ObjectSet("Obj4",OBJPROP_YDISTANCE,50);
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   if(id==CHARTEVENT_KEYDOWN)
     {
      switch(int(lparam))
        {
         case KEY_MONTHLY:ChartSetSymbolPeriod(0,NULL,43200);
         break;
         case KEY_WEEKLY:ChartSetSymbolPeriod(0,NULL,10080);
         break;
         case KEY_DAILY:ChartSetSymbolPeriod(0,NULL,1440);
         break;
         case KEY_4HOUR:ChartSetSymbolPeriod(0,NULL,240);
         break;
         case KEY_1HOUR:ChartSetSymbolPeriod(0,NULL,60);
         break;
         case KEY_5MIN:ChartSetSymbolPeriod(0,NULL,5);
         break;
         case KEY_30MIN:ChartSetSymbolPeriod(0,NULL,30);
         break;
         case KEY_15MIN:ChartSetSymbolPeriod(0,NULL,15);
         break;
         case KEY_1MIN:ChartSetSymbolPeriod(0,NULL,1);
         break;
         case KEY_CHARTFIX:
           {
            bool isFixed=ChartGetInteger(0,CHART_SCALEFIX,true);
            if(!isFixed)
              {
               ChartSetInteger(0,CHART_SCALEFIX,true);
              }
            else  
              {
               ChartSetInteger(0,CHART_SCALEFIX,false);
              }
           }
         break;
         case KEY_P:
           {
            bool isFixed=ChartGetInteger(0,CHART_SHOW_PRICE_SCALE,true);
            if(!isFixed)
              {
               ChartSetInteger(0,CHART_SHOW_PRICE_SCALE,true);
              }
            else  
              {
               ChartSetInteger(0,CHART_SHOW_PRICE_SCALE,false);
              }
           }
         break;
        }
      ChartRedraw();
     }
  }
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectsDeleteAll();
   return(0);
  }
//+------------------------------------------------------------------+
