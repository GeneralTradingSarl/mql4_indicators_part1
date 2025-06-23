//+------------------------------------------------------------------+
//|                                                   ServerTime.mq4 |
//|                                      Copyright © 2005, komposter |
//|                                      mailto:komposterius@mail.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, komposter"
#property link      "mailto:komposterius@mail.ru"

#property indicator_chart_window

extern color TextColor = Black;
//----

int init()
  {
		  ObjectCreate( "ServerTime", OBJ_LABEL, 0,0,0,0,0,0,0);
		  ObjectSet( "ServerTime", OBJPROP_CORNER, 0);
		  ObjectSet( "ServerTime", OBJPROP_XDISTANCE, 0);
		  ObjectSet( "ServerTime", OBJPROP_YDISTANCE, 12);
		  ObjectSetText(  "ServerTime", "", 12, "Arial", TextColor);
    return(0);
  }
//----
int deinit() 
  { 
    ObjectDelete("ServerTime"); 
    return(0); 
  }
//----
int start() 
  { 
    ObjectSetText("ServerTime", TimeToStr( CurTime(), TIME_SECONDS ), 12, "Arial", TextColor ); 
    return(0); 
  }
//+------------------------------------------------------------------+


