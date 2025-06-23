//+------------------------------------------------------------------+
//|                                     Timeframe_zoom_per_chart.mq4 |
//|                                                  Girard Matthieu |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Girard Matthieu"
#property link      "https://www.mql5.com"
#property version   "1.00"
#import "user32.dll"
int      PostMessageA(int hWnd,int Msg,int wParam,int lParam);
int      GetWindow(int hWnd,int uCmd);
int      GetParent(int hWnd);
#import
#property strict
#property indicator_chart_window
//---
int intParent;
int intChild;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   Print("start oninit");
//--- Lot button + 
   ButtonCreate(0,"TZPC_ZommInButton",0,0,15,25,15,2,"Z+","Arial",10,clrWhite,clrBlack,clrWhite,false,false,false,false,0);
//ObjectSetString(0,"ZommInButton",OBJPROP_TOOLTIP,"Use can use 'P' key instead");
//--- Lot button - 
   ButtonCreate(0,"TZPC_ZommOutButton",0,24,15,25,15,2,"Z-","Arial",10,clrWhite,clrBlack,clrWhite,false,false,false,false,0);
//ObjectSetString(0,"LotSizeButtonMinus",OBJPROP_TOOLTIP,"Use can use 'M' key instead");
//--- M1 button
   if(Period()==PERIOD_M1)
     {
      ButtonCreate(0,"TZPC_M1Button",0,48,15,25,15,2,"M1","Arial",8,clrBlack,clrWhite,clrBlack,false,false,false,false,0);
        }else{
      ButtonCreate(0,"TZPC_M1Button",0,48,15,25,15,2,"M1","Arial",8,clrWhite,clrBlack,clrWhite,false,false,false,false,0);
     }
   ObjectSetString(0,"TZPC_M1Button",OBJPROP_TOOLTIP,"Choose 1 Minute period");
//--- M5 button
   if(Period()==PERIOD_M5)
     {
      ButtonCreate(0,"TZPC_M5Button",0,72,15,25,15,2,"M5","Arial",8,clrBlack,clrWhite,clrBlack,false,false,false,false,0);
        }else{
      ButtonCreate(0,"TZPC_M5Button",0,72,15,25,15,2,"M5","Arial",8,clrWhite,clrBlack,clrWhite,false,false,false,false,0);
     }
   ObjectSetString(0,"TZPC_M5Button",OBJPROP_TOOLTIP,"Choose 5 Minutes period");
//--- M15 button
   if(Period()==PERIOD_M15)
     {
      ButtonCreate(0,"TZPC_M15Button",0,96,15,25,15,2,"M15","Arial",8,clrBlack,clrWhite,clrBlack,false,false,false,false,0);
        }else{
      ButtonCreate(0,"TZPC_M15Button",0,96,15,25,15,2,"M15","Arial",8,clrWhite,clrBlack,clrWhite,false,false,false,false,0);
     }
   ObjectSetString(0,"TZPC_M15Button",OBJPROP_TOOLTIP,"Choose 15 Minutes period");
//--- M30 button
   if(Period()==PERIOD_M30)
     {
      ButtonCreate(0,"TZPC_M30Button",0,120,15,25,15,2,"M30","Arial",8,clrBlack,clrWhite,clrBlack,false,false,false,false,0);
        }else{
      ButtonCreate(0,"TZPC_M30Button",0,120,15,25,15,2,"M30","Arial",8,clrWhite,clrBlack,clrWhite,false,false,false,false,0);
     }
   ObjectSetString(0,"TZPC_M30Button",OBJPROP_TOOLTIP,"Choose 30 Minutes period");
//--- H1 button
   if(Period()==PERIOD_H1)
     {
      ButtonCreate(0,"TZPC_H1Button",0,144,15,25,15,2,"H1","Arial",8,clrBlack,clrWhite,clrBlack,false,false,false,false,0);
        }else{
      ButtonCreate(0,"TZPC_H1Button",0,144,15,25,15,2,"H1","Arial",8,clrWhite,clrBlack,clrWhite,false,false,false,false,0);
     }
   ObjectSetString(0,"TZPC_H1Button",OBJPROP_TOOLTIP,"Choose 1 Hour period");
//--- H4 button
   if(Period()==PERIOD_H4)
     {
      ButtonCreate(0,"TZPC_H4Button",0,168,15,25,15,2,"H4","Arial",8,clrBlack,clrWhite,clrBlack,false,false,false,false,0);
        }else{
      ButtonCreate(0,"TZPC_H4Button",0,168,15,25,15,2,"H4","Arial",8,clrWhite,clrBlack,clrWhite,false,false,false,false,0);
     }
   ObjectSetString(0,"TZPC_H4Button",OBJPROP_TOOLTIP,"Choose 4 Hours period");
//--- D1 button
   if(Period()==PERIOD_D1)
     {
      ButtonCreate(0,"TZPC_D1Button",0,192,15,25,15,2,"D1","Arial",8,clrBlack,clrWhite,clrBlack,false,false,false,false,0);
        }else{
      ButtonCreate(0,"TZPC_D1Button",0,192,15,25,15,2,"D1","Arial",8,clrWhite,clrBlack,clrWhite,false,false,false,false,0);
     }
   ObjectSetString(0,"TZPC_D1Button",OBJPROP_TOOLTIP,"Choose 1 Day period");
//--- W1 button
   if(Period()==PERIOD_W1)
     {
      ButtonCreate(0,"TZPC_W1Button",0,214,15,25,15,2,"W1","Arial",8,clrBlack,clrWhite,clrBlack,false,false,false,false,0);
        }else{
      ButtonCreate(0,"TZPC_W1Button",0,214,15,25,15,2,"W1","Arial",8,clrWhite,clrBlack,clrWhite,false,false,false,false,0);
     }
   ObjectSetString(0,"TZPC_W1Button",OBJPROP_TOOLTIP,"Choose 1 Week period");
//--- MN button
   if(Period()==PERIOD_MN1)
     {
      ButtonCreate(0,"TZPC_MNButton",0,238,15,25,15,2,"MN","Arial",8,clrBlack,clrWhite,clrBlack,false,false,false,false,0);
        }else{
      ButtonCreate(0,"TZPC_MNButton",0,238,15,25,15,2,"MN","Arial",8,clrWhite,clrBlack,clrWhite,false,false,false,false,0);
     }
   ObjectSetString(0,"TZPC_MNButton",OBJPROP_TOOLTIP,"Choose 1 Month period");
//---
   intParent= GetParent(WindowHandle(Symbol(),Period()));
   intChild = GetWindow(intParent,0);
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
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      if((StringFind(sparam,"TZPC_")>-1))
        {
         if(!(StringFind(sparam,"TZPC_Zomm")>-1))
           {
            ObjectSetInteger(0,"TZPC_M1Button",OBJPROP_COLOR,clrWhite);
            ObjectSetInteger(0,"TZPC_M1Button",OBJPROP_BGCOLOR,clrBlack);
            ObjectSetInteger(0,"TZPC_M1Button",OBJPROP_BORDER_COLOR,clrWhite);
            ObjectSetInteger(0,"TZPC_M5Button",OBJPROP_COLOR,clrWhite);
            ObjectSetInteger(0,"TZPC_M5Button",OBJPROP_BGCOLOR,clrBlack);
            ObjectSetInteger(0,"TZPC_M5Button",OBJPROP_BORDER_COLOR,clrWhite);
            ObjectSetInteger(0,"TZPC_M15Button",OBJPROP_COLOR,clrWhite);
            ObjectSetInteger(0,"TZPC_M15Button",OBJPROP_BGCOLOR,clrBlack);
            ObjectSetInteger(0,"TZPC_M15Button",OBJPROP_BORDER_COLOR,clrWhite);
            ObjectSetInteger(0,"TZPC_M30Button",OBJPROP_COLOR,clrWhite);
            ObjectSetInteger(0,"TZPC_M30Button",OBJPROP_BGCOLOR,clrBlack);
            ObjectSetInteger(0,"TZPC_M30Button",OBJPROP_BORDER_COLOR,clrWhite);
            ObjectSetInteger(0,"TZPC_H1Button",OBJPROP_COLOR,clrWhite);
            ObjectSetInteger(0,"TZPC_H1Button",OBJPROP_BGCOLOR,clrBlack);
            ObjectSetInteger(0,"TZPC_H1Button",OBJPROP_BORDER_COLOR,clrWhite);
            ObjectSetInteger(0,"TZPC_H4Button",OBJPROP_COLOR,clrWhite);
            ObjectSetInteger(0,"TZPC_H4Button",OBJPROP_BGCOLOR,clrBlack);
            ObjectSetInteger(0,"TZPC_H4Button",OBJPROP_BORDER_COLOR,clrWhite);
            ObjectSetInteger(0,"TZPC_D1Button",OBJPROP_COLOR,clrWhite);
            ObjectSetInteger(0,"TZPC_D1Button",OBJPROP_BGCOLOR,clrBlack);
            ObjectSetInteger(0,"TZPC_D1Button",OBJPROP_BORDER_COLOR,clrWhite);
            ObjectSetInteger(0,"TZPC_W1Button",OBJPROP_COLOR,clrWhite);
            ObjectSetInteger(0,"TZPC_W1Button",OBJPROP_BGCOLOR,clrBlack);
            ObjectSetInteger(0,"TZPC_W1Button",OBJPROP_BORDER_COLOR,clrWhite);
            ObjectSetInteger(0,"TZPC_MNButton",OBJPROP_COLOR,clrWhite);
            ObjectSetInteger(0,"TZPC_MNButton",OBJPROP_BGCOLOR,clrBlack);
            ObjectSetInteger(0,"TZPC_MNButton",OBJPROP_BORDER_COLOR,clrWhite);
           }
        }
      if(sparam=="TZPC_ZommInButton")
        {
         PostMessageA(intParent,0x0111,33025,0);
        }
      if(sparam=="TZPC_ZommOutButton")
        {
         PostMessageA(intParent,0x0111,33026,0);
        }
      if(sparam=="TZPC_M1Button")
        {
         PostMessageA(intParent,0x0111,33137,0);
         ObjectSetInteger(0,"TZPC_M1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"TZPC_M1Button",OBJPROP_BGCOLOR,clrWhite);
         ///ObjectSetInteger(0,"TZPC_M1Button",OBJPROP_BORDER_COLOR,clrBlack);
        }
      if(sparam=="TZPC_M5Button")
        {
         PostMessageA(intParent,0x0111,33138,0);
         ObjectSetInteger(0,"TZPC_M5Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"TZPC_M5Button",OBJPROP_BGCOLOR,clrWhite);
         // ObjectSetInteger(0,"TZPC_M5Button",OBJPROP_BORDER_COLOR,clrBlack);
        }
      if(sparam=="TZPC_M15Button")
        {
         PostMessageA(intParent,0x0111,33139,0);
         ObjectSetInteger(0,"TZPC_M15Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"TZPC_M15Button",OBJPROP_BGCOLOR,clrWhite);
         //ObjectSetInteger(0,"TZPC_M15Button",OBJPROP_BORDER_COLOR,clrBlack);
        }
      if(sparam=="TZPC_M30Button")
        {
         PostMessageA(intParent,0x0111,33140,0);
         ObjectSetInteger(0,"TZPC_M30Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"TZPC_M30Button",OBJPROP_BGCOLOR,clrWhite);
         //ObjectSetInteger(0,"TZPC_M30Button",OBJPROP_BORDER_COLOR,clrBlack);
        }
      if(sparam=="TZPC_H1Button")
        {
         PostMessageA(intParent,0x0111,35400,0);
         ObjectSetInteger(0,"TZPC_H1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"TZPC_H1Button",OBJPROP_BGCOLOR,clrWhite);
         //ObjectSetInteger(0,"TZPC_H1Button",OBJPROP_BORDER_COLOR,clrBlack);
        }
      if(sparam=="TZPC_H4Button")
        {
         PostMessageA(intParent,0x0111,33136,0);
         ObjectSetInteger(0,"TZPC_H4Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"TZPC_H4Button",OBJPROP_BGCOLOR,clrWhite);
         //ObjectSetInteger(0,"TZPC_H4Button",OBJPROP_BORDER_COLOR,clrBlack);
        }
      if(sparam=="TZPC_D1Button")
        {
         PostMessageA(intParent,0x0111,33134,0);
         ObjectSetInteger(0,"TZPC_D1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"TZPC_D1Button",OBJPROP_BGCOLOR,clrWhite);
         //ObjectSetInteger(0,"TZPC_D1Button",OBJPROP_BORDER_COLOR,clrBlack);
        }
      if(sparam=="TZPC_W1Button")
        {
         PostMessageA(intParent,0x0111,33141,0);
         ObjectSetInteger(0,"TZPC_W1Button",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"TZPC_W1Button",OBJPROP_BGCOLOR,clrWhite);
         //ObjectSetInteger(0,"TZPC_W1Button",OBJPROP_BORDER_COLOR,clrBlack);
        }
      if(sparam=="TZPC_MNButton")
        {
         PostMessageA(intParent,0x0111,33334,0);
         ObjectSetInteger(0,"TZPC_MNButton",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"TZPC_MNButton",OBJPROP_BGCOLOR,clrWhite);
         //ObjectSetInteger(0,"TZPC_MNButton",OBJPROP_BORDER_COLOR,clrBlack);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ButtonCreate(const long              chart_ID=0,               // chart's ID
                  const string            name="Button",            // button name
                  const int               sub_window=0,             // subwindow index
                  const int               xx=0,                      // X coordinate
                  const int               yy=0,                      // Y coordinate
                  const int               width=50,                 // button width
                  const int               height=18,                // button height
                  const ENUM_BASE_CORNER  cornerr=CORNER_LEFT_UPPER,// chart corner for anchoring
                  const string            text="Button",            // text
                  const string            font="Arial",             // font
                  const int               font_size=10,             // font size
                  const color             clr=clrBlack,             // text color
                  const color             back_clr=C'236,233,216',  // background color
                  const color             border_clr=clrNONE,       // border color
                  const bool              state=false,              // pressed/released
                  const bool              back=false,               // in the background
                  const bool              selection=false,          // highlight to move
                  const bool              hidden=true,              // hidden in the object list
                  const long              z_order=0)                // priority for mouse click
  {
//--- reset the error value
   ResetLastError();
//--- create the button
   if(ObjectFind(chart_ID,name)<0)
     {
      if(!ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0))
        {
         Print(__FUNCTION__,
               ": failed to create the button! Error code = ",GetLastError());
         return(false);
        }
      //--- set button coordinates
      ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,xx);
      ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,yy);
      //--- set button size
      ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
      ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
      //--- set the chart's corner, relative to which point coordinates are defined
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,cornerr);
      //--- set the text
      ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
      //--- set text font
      ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
      //--- set font size
      ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
      //--- set text color
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      //--- set background color
      ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
      //--- set border color
      ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
      //--- display in the foreground (false) or background (true)
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      //--- set button state
      ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state);
      //--- enable (true) or disable (false) the mode of moving the button by mouse
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      //--- hide (true) or display (false) graphical object name in the object list
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      //--- set the priority for receiving the event of a mouse click in the chart
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      //--- successful execution
     }
   return(true);
  }
//+------------------------------------------------------------------+
