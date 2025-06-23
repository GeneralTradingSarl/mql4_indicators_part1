//+------------------------------------------------------------------+
//|                                                      chaos 2.mq4 |
//|                                                          Samurai |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Samurai"
#property link      ""

#property indicator_chart_window
#property indicator_buffers 2
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectDelete("up");
   ObjectDelete("down");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {

   

//----
if (iAC(0,0,0)>iAC(0,0,1) && iAC(0,0,2) > iAC(0,0,1))
{
   ObjectCreate("up", OBJ_ARROW,0,Time[1],High[1] + 0.0002);
   ObjectSet("up",OBJPROP_COLOR,Green);
   ObjectSet("up",OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
}
if (iAC(0,0,0)<iAC(0,0,1) && iAC(0,0,2) < iAC(0,0,1))
{
   ObjectCreate("down", OBJ_ARROW,0,Time[1],Low[1] - 0.0002);
   ObjectSet("down",OBJPROP_ARROWCODE,SYMBOL_LEFTPRICE);
   ObjectSet("down",OBJPROP_COLOR,Red);
}

//----
   return(0);
  }
//+------------------------------------------------------------------+