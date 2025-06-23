//+------------------------------------------------------------------+
//|                                                      A_stops.mq4 |
//|                                         Copyright © 2010, Elmare |
//|                                        http://elmare.webnode.ru  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, 2010, Elmare"
#property link      "http://elmare.webnode.ru"

#property indicator_chart_window


int tmp;
extern int stops=300;
extern int stops2=100;
extern color cl=DarkSlateGray;
extern color cl2=DarkSlateGray;
extern int style=4;
extern int style2=2;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {

 


  
  
  
ObjectCreate("aL1",OBJ_HLINE,0,0,0);

ObjectCreate("aL2",OBJ_HLINE,0,0,0);

ObjectCreate("aL21",OBJ_HLINE,0,0,0);

ObjectCreate("aL22",OBJ_HLINE,0,0,0);


//-------------------------------


   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
ObjectDelete("aL1"); 
ObjectDelete("aL2");
ObjectDelete("aL21"); 
ObjectDelete("aL22");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   
 if (ObjectFind("aL1")==-1) ObjectCreate("aL1",OBJ_HLINE,0,0,0);
 if (ObjectFind("aL2")==-1) ObjectCreate("aL2",OBJ_HLINE,0,0,0);
 if (ObjectFind("aL21")==-1) ObjectCreate("aL21",OBJ_HLINE,0,0,0);
 if (ObjectFind("aL22")==-1) ObjectCreate("aL22",OBJ_HLINE,0,0,0);
//----

 
   
//----------------------------   
ObjectSet("aL1",OBJPROP_TIME1,Time[0]); 
ObjectSet("aL1",OBJPROP_PRICE1,Close[0]+stops*Point); 
ObjectSet("aL1",OBJPROP_COLOR,cl);
ObjectSet("aL1",OBJPROP_STYLE,style);

ObjectSet("aL2",OBJPROP_TIME1,Time[0]); 
ObjectSet("aL2",OBJPROP_PRICE1,Close[0]-stops*Point); 
ObjectSet("aL2",OBJPROP_COLOR,cl);
ObjectSet("aL2",OBJPROP_STYLE,style); 

ObjectSet("aL21",OBJPROP_TIME1,Time[0]); 
ObjectSet("aL21",OBJPROP_PRICE1,Close[0]+stops2*Point); 
ObjectSet("aL21",OBJPROP_COLOR,cl2);
ObjectSet("aL21",OBJPROP_STYLE,style2);

ObjectSet("aL22",OBJPROP_TIME1,Time[0]); 
ObjectSet("aL22",OBJPROP_PRICE1,Close[0]-stops2*Point); 
ObjectSet("aL22",OBJPROP_COLOR,cl2);
ObjectSet("aL22",OBJPROP_STYLE,style2);

   return(0);
  }
//+------------------------------------------------------------------+