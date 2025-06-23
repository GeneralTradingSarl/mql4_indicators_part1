//+------------------------------------------------------------------+
//|                                      Currency Strength Meter.mq4 |
//|                              Copyright 2018, Besarion Turmanauli |
//|                             https://www.mql5.com/en/users/dos.ge |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Besarion Turmanauli"
#property link      "https://www.mql5.com/en/users/dos.ge"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 100
#property indicator_buffers 4
#property indicator_plots   4
//--- plot Label1
//#property indicator_label1  "Label1"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot Label2
//#property indicator_label2  "Label2"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrViolet
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot Label3
//#property indicator_label3  "Label3"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrGreen
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- plot Label4
//#property indicator_label4  "Label4"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrBlue
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1
//--- indicator buffers
double         Label1Buffer[];
double         Label2Buffer[];
double         Label3Buffer[];
double         Label4Buffer[];

#define ISN "Currency Strength Meter"
int initial_limit=0;

extern string instrOne = "EURUSD"; //Instrument 1
extern string instrTwo = "AUDUSD"; //Instrument 2
extern string instrThree= "NZDUSD"; //Instrument 3
extern string instrFour = "USDJPY"; //Instrument 4
extern color colorOne=clrRed; //Instrument 1 Color
extern color colorTwo=clrViolet; //Instrument 2 Color
extern color colorThree=clrGreen; //Instrument 3 Color
extern color colorFour= clrBlue; //Instrument 4 Color
extern int indicatorPeriod = 14; //Indicator Period
extern ENUM_APPLIED_PRICE appliedPrice=PRICE_CLOSE; //Indicator Applied Price 
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {

   if(!LabelCreate(0,instrOne,1,5,20,CORNER_LEFT_LOWER,instrOne,"Arial",10,colorOne))
     {
      return (0);
     }

   if(!LabelCreate(0,instrTwo,1,75,20,CORNER_LEFT_LOWER,instrTwo,"Arial",10,colorTwo))
     {
      return (0);
     }

   if(!LabelCreate(0,instrThree,1,145,20,CORNER_LEFT_LOWER,instrThree,"Arial",10,colorThree))
     {
      return (0);
     }

   if(!LabelCreate(0,instrFour,1,215,20,CORNER_LEFT_LOWER,instrFour,"Arial",10,colorFour))
     {
      return (0);
     }

   SetLevelValue(0,80.0);
   SetLevelValue(1,50.0);
   SetLevelValue(2,20.0);
//--- indicator buffers mapping
   SetIndexBuffer(0,Label1Buffer);
   SetIndexLabel(0,instrOne);
   SetIndexStyle(0,0,0,1,colorOne);
   SetIndexBuffer(1,Label2Buffer);
   SetIndexLabel(1,instrTwo);
   SetIndexStyle(1,0,0,1,colorTwo);
   SetIndexBuffer(2,Label3Buffer);
   SetIndexLabel(2,instrThree);
   SetIndexStyle(2,0,0,1,colorThree);
   SetIndexBuffer(3,Label4Buffer);
   SetIndexLabel(3,instrFour);
   SetIndexStyle(3,0,0,1,colorFour);

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i,// Bar index
   Counted_bars;                // Number of counted bars

   Counted_bars=IndicatorCounted(); // Number of counted bars
   i=Bars-Counted_bars-1;           // Index of the first uncounted
   if(initial_limit==0){initial_limit=i;}

   while(i>0)
     {//start iteration

      //getting initial values
      double open=Open[i];
      double high=High[i];
      double low=Low[i];
      double close=Close[i];

      Label1Buffer[i]=iRSI(instrOne,Period(),indicatorPeriod,PRICE_CLOSE,i);
      Label2Buffer[i]=iRSI(instrTwo,Period(),indicatorPeriod,PRICE_CLOSE,i);
      Label3Buffer[i]=iRSI(instrThree,Period(),indicatorPeriod,PRICE_CLOSE,i);
      Label4Buffer[i]=iRSI(instrFour,Period(),indicatorPeriod,PRICE_CLOSE,i);

      i--;
     }//end iteration

   return (0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   LabelDelete(0,instrOne);
   LabelDelete(0,instrTwo);
   LabelDelete(0,instrThree);
   LabelDelete(0,instrFour);
   return(0);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Create a text label                                              |
//+------------------------------------------------------------------+
bool LabelCreate(const long              chart_ID=0,               // chart's ID
                 const string            name="Label",             // label name
                 const int               sub_window=0,             // subwindow index
                 const int               x=0,                      // X coordinate
                 const int               y=0,                      // Y coordinate
                 const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                 const string            text="Label",             // text
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
//--- reset the error value
   ResetLastError();
//--- create a text label
   if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create text label! Error code = ",GetLastError());
      return(false);
     }
//--- set label coordinates
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
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
//--- enable (true) or disable (false) the mode of moving the label by mouse
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
//| Delete a text label                                              |
//+------------------------------------------------------------------+
bool LabelDelete(const long   chart_ID=0,   // chart's ID
                 const string name="Label") // label name
  {
//--- reset the error value
   ResetLastError();
//--- delete the label
   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": failed to delete a text label! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
