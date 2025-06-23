#include <stdlib.mqh>
#include <httpget.mqh>


extern string webserver="localhost";
extern string phpsend="gettrade.php";
extern string phpquery="querytrade.php";
extern int delay=1; //how many seconds to wait between two uploads to webserver (too low value can cause slowdown)


int i=0;
double SL;
double TP;
double Lotsize;
double openprice;
double closeprice;
string opendate;
string closedate;
int orderticket;
string ordertype;
string pair;
string tradestatus;
double profit;
string ticketnumber;
string accno;
int rows;
int NextSave;
int tradequery[100];

#property indicator_chart_window    

int init()
{
 NextSave=0;
 accno=AccountNumber();
 rows=0;
}

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
  
 while(TimeCurrent()>NextSave)
 {

  rows=0; 
   
  for (i=0;i<OrdersTotal();i++)

   {

    if(OrderSelect(i,SELECT_BY_POS)==true) 
    
    {
     
     openprice = OrderOpenPrice(); 
     orderticket = OrderTicket();
     pair = OrderSymbol();
     opendate = TimeToStr(OrderOpenTime());
     ordertype = OrderType();
     profit = OrderProfit();
     SL = OrderStopLoss();
     TP = OrderTakeProfit();
     Lotsize = OrderLots(); 
     string response1;
     if (ordertype == "1" || ordertype == "0")
     
     {
      tradestatus="open";
     }

     if (ordertype == "2" || ordertype == "3" || ordertype == "4" || ordertype == "5")
     
     {
      tradestatus="pending";
     }   
     
     HttpGET("http://"+webserver+"//"+phpsend+"?openprice="+openprice+"&closeprice="+closeprice+"&opendate="+opendate+"&closedate="+closedate+"&orderticket="+orderticket+"&ordertype="+ordertype+"&pair="+pair+"&profit="+profit+"&SL="+SL+"&TP="+TP+"&Lot="+Lotsize+"&status="+tradestatus+"&accno="+accno, response1);
     
     }
         
   }  

     string response2;
     
     HttpGET("http://"+webserver+"//"+phpquery, response2);
     
     string substr=StringSubstr(response2,0,1);
     
     rows = StrToInteger(substr);
     
     int j=1;
     string order=OrderTicket();
     int length=StringLen(order);
     
     for (i=0;i<rows;i++)
     
     {
     tradequery[i]=StrToInteger(StringSubstr(response2,j,8));
     j=j+length;   
     }
  
   for(i=0;i<rows;i++)
    {
    
         
     if (OrderSelect(tradequery[i],SELECT_BY_TICKET,MODE_HISTORY)==true)    
     {
     
     if(OrderCloseTime()!=0)
      {
         string response3;  
         tradestatus="closed";
         openprice = OrderOpenPrice(); 
         orderticket = OrderTicket();
         pair = OrderSymbol();
         opendate = TimeToStr(OrderOpenTime());
         ordertype = OrderType();
         profit = OrderProfit();
         SL = OrderStopLoss();
         TP = OrderTakeProfit();
         Lotsize = OrderLots();      
         closeprice = OrderClosePrice();
         closedate = TimeToStr(OrderCloseTime());

         HttpGET("http://"+webserver+"//"+phpsend+"?openprice="+openprice+"&closeprice="+closeprice+"&opendate="+opendate+"&closedate="+closedate+"&orderticket="+orderticket+"&ordertype="+ordertype+"&pair="+pair+"&profit="+profit+"&SL="+SL+"&TP="+TP+"&Lot="+Lotsize+"&status="+tradestatus+"&accno="+accno, response3);
      }     
    }
   }      
      
  NextSave=TimeCurrent()+delay;
 }
 
   

//----
   return(0);
  }
//+------------------------------------------------------------------+

