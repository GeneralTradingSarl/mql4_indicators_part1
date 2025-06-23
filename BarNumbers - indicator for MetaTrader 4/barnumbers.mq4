//+------------------------------------------------------------------+
//|                                                   BarNumbers.mq4 |
//|                                                      Samuel Beer |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Samuel Beer"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

int FirstBar;
int LastBar;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   FirstBar = Bars-1-(int)ChartGetInteger(0, CHART_FIRST_VISIBLE_BAR);
   LastBar = FirstBar+(int)ChartGetInteger(0, CHART_WIDTH_IN_BARS);
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
   {
   ObjectsDeleteAll(0, "bn_");
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
//---
   
   if (prev_calculated == rates_total) // inside bar tick
      {
      ObjectSetDouble(0, StringFormat("bn_ser_%d", Bars-1), OBJPROP_PRICE, High[0]);
      ObjectSetDouble(0, StringFormat("bn_abs_%d", Bars-1), OBJPROP_PRICE, Low[0]);
      }
   else // new bar
      {
      int limit = rates_total - prev_calculated;
      int first_bar = Bars-1-FirstBar;
      int last_bar = Bars-1-LastBar;
      for (int i = first_bar; i >= last_bar && i >= 0; --i)
         {
         // change text of series numbers
         if (i >= limit)
            ObjectSetString(0, StringFormat("bn_ser_%d", Bars-1-i), OBJPROP_TEXT, StringFormat("%d", i));
         // recreate abs numbers only from where we left of
         else if (i < limit)
            NumbersCreate(i);
         }
      
      }
//--- return value of prev_calculated for next call
   return rates_total;
  }

void OnChartEvent(const int id,         // Event ID 
                  const long& lparam,   // Parameter of type long event 
                  const double& dparam, // Parameter of type double event 
                  const string& sparam  // Parameter of type string events 
  )
   {
   // when the chart changes, update the display of objects
   if (id != CHARTEVENT_CHART_CHANGE) return ;
   
   int first_bar = (int)ChartGetInteger(0, CHART_FIRST_VISIBLE_BAR);
   int last_bar = first_bar-(int)ChartGetInteger(0, CHART_WIDTH_IN_BARS);
   int prev_first = Bars-1-FirstBar;
   int prev_last = Bars-1-LastBar;
   
   // if the viewport shifted to a complete new position -> redraw all
   if (first_bar < prev_last || last_bar > prev_first)
      {
      ObjectsDeleteAll(0, "bn_");
      for (int i=first_bar; i >= last_bar && i >= 0; --i)
         NumbersCreate(i);
      }
   else
      {
      int end = MathMin(last_bar, prev_last);
      for (int i=MathMax(first_bar, prev_first); i >= end && i >= 0; --i)
         {
         if (i > first_bar)
            NumbersDelete(i);
         else if (i > prev_first)
            NumbersCreate(i);
         /*else
            {
            Print ("would jump to ", MathMax(last_bar, prev_last));
            i = MathMax(last_bar, prev_last);
            continue;
            
            }*/
         
         if (i < last_bar)
            NumbersDelete(i);
         else if (i < prev_last)
            NumbersCreate(i);
         }
      }
   
   FirstBar = Bars-1-first_bar;
   LastBar = Bars-1-last_bar;
   }




//+------------------------------------------------------------------+

bool NumberCreate(const long            chart_ID=0,               // chart's ID 
                const string            name="Text",              // object name 
                const int               sub_window=0,             // subwindow index 
                datetime                time=0,                   // anchor point time 
                double                  price=0,                  // anchor point price 
                const string            text="Text",              // the text itself 
                const string            font="Arial",             // font 
                const int               font_size=10,             // font size 
                const color             clr=clrRed,               // color 
                const double            angle=0.0,                // text slope 
                const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER) // anchor type 
   {
   ObjectCreate(chart_ID,name,OBJ_TEXT,sub_window,time,price);
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font); 
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size); 
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle); 
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor); 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   
   return(true); 
   }

void NumbersCreate(int i) // i in series coordinates
   {
   NumberCreate(0, StringFormat("bn_ser_%d", Bars-1-i), 0, Time[i], High[i], StringFormat("%d", i), "Arial", 10, clrSteelBlue, 90, ANCHOR_LEFT);
   NumberCreate(0, StringFormat("bn_abs_%d", Bars-1-i), 0, Time[i], Low[i], StringFormat("%d", Bars-1-i), "Arial", 10, clrGray, 90, ANCHOR_RIGHT);
   }

void NumbersDelete(int i)
   {
   ObjectDelete(0, StringFormat("bn_ser_%d", Bars-1-i));
   ObjectDelete(0, StringFormat("bn_abs_%d", Bars-1-i));
   }