//+------------------------------------------------------------------+
//|                                                      Balance.mq4 |
//|                               Copyright © 2009, Хлыстов Владимир |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, Vladimir Hlystov"
#property link      "cmillion@narod.ru"
 
#property indicator_chart_window
extern int srift = 30;
extern color colorPLUS = Green;
extern color colorMINUS = Crimson;
 
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   ObjectCreate ("Balance1", OBJ_LABEL, 0, 0, 0);// Создание объ.
   ObjectSet    ("Balance1", OBJPROP_XDISTANCE, 10);      
   ObjectSet    ("Balance1", OBJPROP_CORNER, 0); //угол_вывода_ордеров
 
   ObjectCreate ("Balance2", OBJ_LABEL, 0, 0, 0);// Создание объ.
   ObjectSet    ("Balance2", OBJPROP_XDISTANCE, 10);      
   ObjectSet    ("Balance2", OBJPROP_CORNER, 0); //угол_вывода_ордеров
 
   ObjectCreate ("Balance3", OBJ_LABEL, 0, 0, 0);// Создание объ.
   ObjectSet    ("Balance3", OBJPROP_XDISTANCE, 10);      
   ObjectSet    ("Balance3", OBJPROP_CORNER, 0); //угол_вывода_ордеров
 
   ObjectCreate ("Balance4", OBJ_LABEL, 0, 0, 0);// Создание объ.
   ObjectSet    ("Balance4", OBJPROP_XDISTANCE, 10);      
   ObjectSet    ("Balance4", OBJPROP_CORNER, 0); //угол_вывода_ордеров
 
   ObjectCreate ("Balance5", OBJ_LABEL, 0, 0, 0);// Создание объ.
   ObjectSet    ("Balance5", OBJPROP_XDISTANCE, 10);      
   ObjectSet    ("Balance5", OBJPROP_CORNER, 0); //угол_вывода_ордеров
 
   ObjectCreate ("Balance all", OBJ_LABEL, 0, 0, 0);// Создание объ.
   ObjectSet    ("Balance all", OBJPROP_XDISTANCE, 10);      
   ObjectSet    ("Balance all", OBJPROP_YDISTANCE, 10);
   ObjectSet    ("Balance all", OBJPROP_CORNER, 3); //угол_вывода_ордеров
 
   ObjectCreate ("TIME", OBJ_LABEL, 0, 0, 0);// Создание объ.
   ObjectSet    ("TIME", OBJPROP_XDISTANCE, 10);      
   ObjectSet    ("TIME", OBJPROP_YDISTANCE, 0);
   ObjectSet    ("TIME", OBJPROP_CORNER, 1); //угол_вывода_ордеров
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete ("Balance1");
   ObjectDelete ("Balance2");
   ObjectDelete ("Balance3");
   ObjectDelete ("Balance4");
   ObjectDelete ("Balance5");
   ObjectDelete ("Balance all");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   color  color_t;
   string Balance;
   double Balance_USDСHF,
          Balance_USDJPY,
          Balance_EURUSD,
          Balance_GBPUSD,
          Balance_USDCAD;
   string tip_EURUSD,
          tip_GBPUSD,
          tip_USDCAD,
          tip_USDСHF,
          tip_USDJPY;
   int    n;
   for (int i=0; i<OrdersTotal(); i++)// По всем ордерам терминала
   {
      if((OrderSelect(i, SELECT_BY_POS)==true)) //Если есть следующ и наша вал.пара
      { 
         if (OrderType()<2)  //Buy или Sell
         {
            if (OrderSymbol()=="EURUSD") {Balance_EURUSD = Balance_EURUSD + OrderProfit(); tip_EURUSD = tip_EURUSD + "     "+DoubleToStr(OrderLots(),2); if (OrderType()==0) tip_EURUSD = tip_EURUSD + "  Buy  "; else tip_EURUSD = tip_EURUSD + "  Sell ";}
            if (OrderSymbol()=="GBPUSD") {Balance_GBPUSD = Balance_GBPUSD + OrderProfit(); tip_GBPUSD = tip_GBPUSD + "     "+DoubleToStr(OrderLots(),2); if (OrderType()==0) tip_GBPUSD = tip_GBPUSD + "  Buy  "; else tip_GBPUSD = tip_GBPUSD + "  Sell ";}
            if (OrderSymbol()=="USDCAD") {Balance_USDCAD = Balance_USDCAD + OrderProfit(); tip_USDCAD = tip_USDCAD + "     "+DoubleToStr(OrderLots(),2); if (OrderType()==0) tip_USDCAD = tip_USDCAD + "  Buy  "; else tip_USDCAD = tip_USDCAD + "  Sell ";}
            if (OrderSymbol()=="USDCHF") {Balance_USDСHF = Balance_USDСHF + OrderProfit(); tip_USDСHF = tip_USDСHF + "     "+DoubleToStr(OrderLots(),2); if (OrderType()==0) tip_USDСHF = tip_USDСHF + "  Buy  "; else tip_USDСHF = tip_USDСHF + "  Sell ";}
            if (OrderSymbol()=="USDJPY") {Balance_USDJPY = Balance_USDJPY + OrderProfit(); tip_USDJPY = tip_USDJPY + "     "+DoubleToStr(OrderLots(),2); if (OrderType()==0) tip_USDJPY = tip_USDJPY + "  Buy  "; else tip_USDJPY = tip_USDJPY + "  Sell ";}
         }
      }
   }
   n = 0;
   if (StringLen(tip_EURUSD)>1) {
      if (Balance_EURUSD>=0) color_t = colorPLUS; else color_t = colorMINUS;
      ObjectSetText("Balance1","EURUSD  "+DoubleToStr(Balance_EURUSD,2)+" "+tip_EURUSD,srift,"Arial",color_t);
      ObjectSet    ("Balance1", OBJPROP_YDISTANCE, n*(srift+srift/5));
      n = n + 1;}
   else ObjectSetText("Balance1"," ",0,"Arial",0);
   if (StringLen(tip_USDСHF)>1) {
      if (Balance_USDСHF>=0) color_t = colorPLUS; else color_t = colorMINUS;
      ObjectSetText("Balance2","USDCHF  "+DoubleToStr(Balance_USDСHF,2)+" "+tip_USDСHF,srift,"Arial",color_t);
      ObjectSet    ("Balance2", OBJPROP_YDISTANCE, n*(srift+srift/5));
      n = n + 1;}
   else ObjectSetText("Balance2"," ",0,"Arial",0);
   if (StringLen(tip_USDJPY)>1){
      if (Balance_USDJPY>=0) color_t = colorPLUS; else color_t = colorMINUS;
      ObjectSetText("Balance3","USDJPY   "+DoubleToStr(Balance_USDJPY,2)+" "+tip_USDJPY,srift,"Arial",color_t);
      ObjectSet    ("Balance3", OBJPROP_YDISTANCE, n*(srift+srift/5));
      n = n + 1;}
   else ObjectSetText("Balance3"," ",0,"Arial",0);
   if (StringLen(tip_GBPUSD)>1){
      if (Balance_GBPUSD>=0) color_t = colorPLUS; else color_t = colorMINUS;
      ObjectSetText("Balance4","GBPUSD  "+DoubleToStr(Balance_GBPUSD,2)+" "+tip_GBPUSD,srift,"Arial",color_t);
      ObjectSet    ("Balance4", OBJPROP_YDISTANCE, n*(srift+srift/5));
      n = n + 1;}
   else ObjectSetText("Balance4"," ",0,"Arial",0);
   if (StringLen(tip_USDCAD)>1){
      if (Balance_USDCAD>=0) color_t = colorPLUS; else color_t = colorMINUS;
      ObjectSetText("Balance5","USDCAD  "+DoubleToStr(Balance_USDCAD,2)+" "+tip_USDCAD,srift,"Arial",color_t);
      ObjectSet    ("Balance5", OBJPROP_YDISTANCE, n*(srift+srift/5));
      n = n + 1;}   
   else ObjectSetText("Balance5"," ",0,"Arial",0);
   if (Balance_USDCAD+Balance_GBPUSD+Balance_USDJPY+Balance_USDСHF+Balance_EURUSD>=0) color_t = colorPLUS; else color_t = colorMINUS;
   ObjectSetText("Balance all","Balance  "+DoubleToStr(Balance_USDCAD+Balance_GBPUSD+Balance_USDJPY+Balance_USDСHF+Balance_EURUSD,2)+"    free "+DoubleToStr(AccountFreeMargin(),2),srift*2,"Arial",color_t);   
   ObjectSetText("TIME",TimeW(CurTime()),srift*2,"Arial",color_t);   
return(0);
}
//+------------------------------------------------------------------+
string TimeW(int taim)
{
   string sTime;
   int HH=TimeHour(taim);   // Hour                  
   int MM=TimeMinute(taim); // Minute   
 
   if (HH<10) sTime = sTime+"0"+DoubleToStr(HH,0);
   else sTime = sTime+DoubleToStr(HH,0);
   if (MM<10) sTime = sTime+":0"+DoubleToStr(MM,0);
   else sTime = sTime+":"+DoubleToStr(MM,0);
   return(sTime);
}
//+------------------------------------------------------------------+