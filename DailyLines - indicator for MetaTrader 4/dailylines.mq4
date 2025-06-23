//+------------------------------------------------------------------+
//|                                                   DailyLines.mq4 |
//|                                        Copyright © 2014, deVries |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2014, deVries"
#property link      ""
#property version   "1.00"
#property strict
#property indicator_chart_window

input int  MaxBarsToLookBackForSeparators=0;
input string LookToAllBars="Input 0";
//--- Colors each day 
input color Sunday = Red;
input color Monday = Blue;
input color Tuesday= Blue;
input color Wednesday= Blue;
input color Thursday = Blue;
input color Friday=Blue;
input color Saturday=Blue;
//--- input parameters for style the day line
input ENUM_LINE_STYLE InpStyle=STYLE_DASHDOTDOT; // Line style
input int             InpWidth=1;                // Line width
//--- input distance text from top of the chart 
input double          textplace=30;
input string          InpFont="Arial";         // Font
input int             InpFontSize=8;          // Font size
input ENUM_ANCHOR_POINT InpAnchor=ANCHOR_BOTTOM; // Anchor type

double textprice,newtextprice,
max_price,min_price;
string thisday="";
string daycheck1="",daycheck2="";
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//Set Timer
   EventSetMillisecondTimer(250);
//--- find the highest and lowest values of the chart then calculate textposition
   max_price=ChartGetDouble(0,CHART_PRICE_MAX);
   min_price=ChartGetDouble(0,CHART_PRICE_MIN);
   int heightinpixels=ChartHeightInPixelsGet(0,0);
   textprice=max_price-((max_price-min_price)*(textplace/heightinpixels));
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   int i2;
   int obj_total=ObjectsTotal(0,-1,-1);
   for(i2=obj_total; i2>=0; i2--)
     {
      string name=ObjectName(0,i2,-1,-1);
      if(StringSubstr(name,0,14)=="NewTradingDay ") {TrendDelete(0,name);}
      if(StringSubstr(name,0,8)=="DayText ") {TextDelete(0,name);}
     }
//--- destroy timer
   EventKillTimer();
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
   int    i1;                        // Bar Index
   string today=TimeToString(time[0],TIME_DATE);

// starting index for number of Separators
   if(MaxBarsToLookBackForSeparators<=0 || MaxBarsToLookBackForSeparators>rates_total-2)
      i1=rates_total-2; // starting index for calculation of all bars
   else i1= MaxBarsToLookBackForSeparators;


   if((daycheck1 == "NewTradingDay "+today)&&(daycheck2 == "DayText "+today))return(rates_total);

//--- find the highest and lowest values of the chart
   max_price=ChartGetDouble(0,CHART_PRICE_MAX);
   min_price=ChartGetDouble(0,CHART_PRICE_MIN);
//calculation place of the text  
   int heightinpixels=ChartHeightInPixelsGet(0,0);
   textprice=max_price-((max_price-min_price)*(textplace/heightinpixels));

   while(i1>=0)
     {
      datetime now=time[i1];

      thisday=TimeToString(now,TIME_DATE);
      color   clr = CLR_NONE;
      string  text="";

      int weekday=TimeDayOfWeekMQL4(now);
      text = DaytoStr(weekday);
      clr  = DaytoClr(weekday);

      if(ObjectFind(0,"NewTradingDay "+thisday)<0)
        {
         TrendCreate(0,"NewTradingDay "+thisday,0,now,Point(),now,textprice,clr,InpStyle,
                     InpWidth,true,false,true,false,true,0);
        }

      if(ObjectFind(0,"DayText "+thisday)<0)
        {
         TextCreate(0,"DayText "+thisday,0,now,textprice,text,InpFont,InpFontSize,
                    clr,90,InpAnchor,false,false,true,0);
        }
      i1--;
     }
   ChartRedraw(0);
   if(ObjectFind(0,"NewTradingDay "+today)==0)daycheck1="NewTradingDay "+today;
   if(ObjectFind(0,"DayText "+today)==0)daycheck2="DayText "+today;

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Checks at timechange if objects has to move                      | 
//+------------------------------------------------------------------+
void OnTimer()
  {
//--- find the highest and lowest values of the chart
   max_price=ChartGetDouble(0,CHART_PRICE_MAX);
   min_price=ChartGetDouble(0,CHART_PRICE_MIN);

   int heightinpixels=ChartHeightInPixelsGet(0,0);
   textprice=max_price-((max_price-min_price)*(textplace/heightinpixels));

   if((textprice>newtextprice+Point()) || (textprice<newtextprice-Point()))
     {
      ChangeTextPrice(textprice);
     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|  Set the right DayText to each Day                               |
//+------------------------------------------------------------------+   
string DaytoStr(int weekday) 
  {
   switch(weekday) 
     {
      case 0     : return(" Sun");  break;
      case 1     : return(" Mon");  break;
      case 2     : return(" Tue"); break;
      case 3     : return(" Wed"); break;
      case 4     : return(" Thu");  break;
      case 5     : return(" Fri");  break;
      case 6     : return(" Sat");  break;
     }
   return("");
  }
//+------------------------------------------------------------------+
//|  Setting the Colors of the Lines                                 |
//+------------------------------------------------------------------+   
color DaytoClr(int weekday) 
  {
   switch(weekday) 
     {
      case 0     : return(Sunday);  break;
      case 1     : return(Monday);  break;
      case 2     : return(Tuesday);  break;
      case 3     : return(Wednesday);  break;
      case 4     : return(Thursday);  break;
      case 5     : return(Friday);  break;
      case 6     : return(Saturday);  break;
     }
   return(CLR_NONE);
  }
//+------------------------------------------------------------------+
//| The function receives the chart height value in pixels.          |
//+------------------------------------------------------------------+
int ChartHeightInPixelsGet(const long chart_ID=0,const int sub_window=0)
  {
//--- prepare the variable to get the property value
   long result=-1;
//--- reset the error value
   ResetLastError();
//--- receive the property value
   if(!ChartGetInteger(chart_ID,CHART_HEIGHT_IN_PIXELS,sub_window,result))
     {
      //--- display the error message in Experts journal
      Print(__FUNCTION__+", Error Code = ",GetLastError());
     }
//--- return the value of the chart property
   return((int)result);
  }
//+------------------------------------------------------------------+
//| The function Returns the zero-based day of week                  |
//| (0 means Sunday,1,2,3,4,5,6) for the specified date.             |
//+------------------------------------------------------------------+  
int TimeDayOfWeekMQL4(datetime date)
  {
   MqlDateTime tm;
   TimeToStruct(date,tm);
   return(tm.day_of_week);
  }
//+------------------------------------------------------------------+
//| Create a trend line by the given coordinates                     |
//+------------------------------------------------------------------+
bool TrendCreate(const long            chart_ID=0,        // chart's ID
                 const string          name="TrendLine",  // line name
                 const int             sub_window=0,      // subwindow index
                 datetime              time1=0,           // first point time
                 double                price1=0,          // first point price
                 datetime              time2=0,           // second point time
                 double                price2=0,          // second point price
                 const color           clr=clrRed,        // line color
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // line style
                 const int             width=1,           // line width
                 const bool            back=false,        // in the background
                 const bool            selection=true,    // highlight to move
                 const bool            ray_left=false,    // line's continuation to the left
                 const bool            ray_right=false,   // line's continuation to the right
                 const bool            hidden=true,       // hidden in the object list
                 const long            z_order=0)         // priority for mouse click
  {
//--- set anchor points' coordinates if they are not set
   ChangeTrendEmptyPoints(time1,price1,time2,price2);
//--- reset the error value
   ResetLastError();
//--- create a trend line by the given coordinates
   if(!ObjectCreate(chart_ID,name,OBJ_TREND,sub_window,time1,price1,time2,price2))
     {
      Print(__FUNCTION__,
            ": failed to create a trend line! Error code = ",GetLastError());
      return(false);
     }
//--- set line color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set line display style
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set line width
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the line by mouse
//--- when creating a graphical object using ObjectCreate function, the object cannot be
//--- highlighted and moved by default. Inside this method, selection parameter
//--- is true by default making it possible to highlight and move the object
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- enable (true) or disable (false) the mode of continuation of the line's display to the left
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_LEFT,ray_left);
//--- enable (true) or disable (false) the mode of continuation of the line's display to the right
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_RIGHT,ray_right);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Check the values of trend line's anchor points and set default   |
//| values for empty ones                                            |
//+------------------------------------------------------------------+
void ChangeTrendEmptyPoints(datetime &time1,double &price1,
                            datetime &time2,double &price2)
  {
//--- if the first point's time is not set, it will be on the current bar
   if(!time1)
      time1=TimeCurrent();
//--- if the first point's price is not set, it will have Bid value
   if(!price1)
      price1=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- if the second point's time is not set, it is located 9 bars left from the second one
   if(!time2)
     {
      //--- array for receiving the open time of the last 10 bars
      datetime temp[10];
      CopyTime(Symbol(),Period(),time1,10,temp);
      //--- set the second point 9 bars left from the first one
      time2=temp[0];
     }
//--- if the second point's price is not set, it is equal to the first point's one
   if(!price2)
      price2=price1;
  }
//+------------------------------------------------------------------+
//| The function deletes the trend line from the chart.              |
//+------------------------------------------------------------------+
bool TrendDelete(const long   chart_ID=0,       // chart's ID
                 const string name="TrendLine") // line name
  {
//--- reset the error value
   ResetLastError();
//--- delete a trend line
   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": failed to delete a trend line! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Creating Text object                                             |
//+------------------------------------------------------------------+
bool TextCreate(const long              chart_ID=0,               // chart's ID
                const string            name="Text",              // object name
                const int               sub_window=0,             // subwindow index
                datetime                time=0,                   // anchor point time
                double                  price=0,                  // anchor point price
                const string            text="Text",              // the text itself
                const string            font="Arial",             // font
                const int               font_size=10,             // font size
                const color             clr=clrRed,               // color
                const double            angle=0.0,                // text slope
                const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // anchor type
                const bool              back=false,               // in the background
                const bool              selection=false,          // highlight to move
                const bool              hidden=true,              // hidden in the object list
                const long              z_order=0)                // priority for mouse click
  {
//--- set anchor point coordinates if they are not set
   ChangeTextEmptyPoint(time,price);
//--- reset the error value
   ResetLastError();
//--- create Text object
   if(!ObjectCreate(chart_ID,name,OBJ_TEXT,sub_window,time,price))
     {
      Print(__FUNCTION__,
            ": failed to create \"Text\" object! Error code = ",GetLastError());
      return(false);
     }
//--- set the text
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- set text font
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- set font size
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- set the slope angle of the text
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
//--- set anchor type
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
//--- set color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the object by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Check anchor point values and set default values                 |
//| for empty ones                                                   |
//+------------------------------------------------------------------+
void ChangeTextEmptyPoint(datetime &time,double &price)
  {
//--- if the point's time is not set, it will be on the current bar
   if(!time)
      time=TimeCurrent();
//--- if the point's price is not set, it will have Bid value
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
  }
//+------------------------------------------------------------------+
//| Delete Text object                                               |
//+------------------------------------------------------------------+
bool TextDelete(const long   chart_ID=0,  // chart's ID
                const string name="Text") // object name
  {
//--- reset the error value
   ResetLastError();
//--- delete the object
   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": failed to delete \"Text\" object! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Move trend line and text to textprice                            |
//+------------------------------------------------------------------+
void ChangeTextPrice(double price)
  {
//--- indicator buffers mapping
   int obj_total=ObjectsTotal(0,0,-1);

   for(int i3=obj_total; i3>=0; i3--)
     {
      string name=ObjectName(0,i3,0,-1);
      if(StringSubstr(name,0,14)=="NewTradingDay ")
        {
         long t1=ObjectGetInteger(0,name,OBJPROP_TIME,1);
         ObjectMove(0,name,1,t1,price);
        }
      if(StringSubstr(name,0,8)=="DayText ") //{TextDelete(0,name);}
        {
         long t1=ObjectGetInteger(0,name,OBJPROP_TIME,0);
         ObjectMove(0,name,0,t1,price);
        }
     }
   newtextprice=textprice;
   ChartRedraw();
  }       
//+------------------------------------------------------------------+
