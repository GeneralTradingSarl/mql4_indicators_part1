//+------------------------------------------------------------------+
//|                                              AlertCloseOrder.mq4 |
//|                               Copyright © 2010, Vladimir Hlystov |
//|                                         http://cmillion.narod.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, Vladimir Hlystov"
#property link      "http://cmillion.narod.ru"
#property indicator_chart_window
int Orders;
//+------------------------------------------------------------------+
int start()
  {
   if (Orders>OrdersTotal()) AlertOrder();
   Orders=OrdersTotal();
   return(0);
  }
//+------------------------------------------------------------------+
void AlertOrder()
{
   string txt;
   double OCP;
   int i=OrdersHistoryTotal()-1;
   if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true)
   {                                     
      OCP=OrderClosePrice();
      if (OCP==OrderStopLoss()  ) txt="SL";
      if (OCP==OrderTakeProfit()) txt="TP";
      Alert("Order N ",OrderTicket()," close in ",txt," ",
      DoubleToStr(OCP,Digits)," profit ",DoubleToStr(OrderProfit(),2));
}  }
//+------------------------------------------------------------------+

