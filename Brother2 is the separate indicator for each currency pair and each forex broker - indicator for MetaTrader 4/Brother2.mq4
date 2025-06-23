//
// "Dissent is the highest form of patriotism" / "Bunt jest najwy¿sz¹ form¹ patriotyzmu" - Thomas Jefferson 
// "BROTHER 2 - indicator"
//
#property copyright "SantaClaus"
#property link      "SantaClaus"
//
#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 31
// other settings
extern int       timezone=1; // for POLAND is GMT+1 . Setup the timezone now!
extern double    risk=8; // risk in % for Money Management no more than risk% by each position
extern string    low_news, medium_news, high_news; // You can edit this values everyday... put here times of news publication for example 8:00, 7:00, 21:00
//
int init()
  {
IndicatorShortName("-*-");
return(0);}

int deinit()
  {ObjectsDeleteAll();return(0);}

int start()
  {
//
int counted_bars=IndicatorCounted();
int windowIndex=WindowFind("-*-");
string cantrade_info, connection_info;
datetime czas_lokalny = TimeLocal();
double 
margin=MarketInfo(Symbol(),MODE_MARGINREQUIRED), Etrade,
microlot=MarketInfo(Symbol(),MODE_MINLOT);

Etrade=MarketInfo(Symbol(),MODE_TRADEALLOWED);
if (Etrade!=0) {cantrade_info="[ YES ]";} else {cantrade_info="[ NO ]";}

if (!IsConnected())   {connection_info=("No connection with BROKER\'s server!");} else {connection_info=("Broker\'s server connection is OK!");}

string InfoGMT    = "[ Current GMT time:   " + TimeToStr(TimeLocal() + (( 0 - timezone) * 3600), TIME_DATE | TIME_SECONDS)+" ]";

string globalinf  = "[ 24h World Market Times ]    GMT: Open --- Close";
string London2    = "Europe (London UK).....................: 08:00 --- 17:00";
string Frankfurt2 = "Europe (Frankfurt Germany).........: 07:00 --- 16:00";
string NewYork2   = "America (New York USA)............: 13:00 --- 22:00";
string Chicago2   = "America (Chicago USA)...............: 14:00 --- 23:00";
string Tokyo2     = "Asia (Tokyo Japan).....................: 00:00 --- 09:00";
string HongKong2  = "Asia (Hong Kong China)...............: 01:00 --- 10:00";
string Sydney2    = "Pacific (Sydney Australlia)............: 22:00 --- 07:00";
string Wellington2= "Pacific (Wellington New Zealand)....: 22:00 --- 06:00";

int m1,s1,h1,m2,s2,h2,m3,s3,h3,m4,s4,h4,m5,s5,h5,m6,s6,h6,m7,s7,h7,im1,im2,im3,im4,im5,im6,im7;

m1=(iTime(NULL,1,0)+60)-TimeCurrent();s1=m1%60;im1=(m1-s1)/60; h1=im1/60; //PERIOD_M1	1	1 minute.
m2=(iTime(NULL,5,0)+5*60)-TimeCurrent();s2=m2%60;im2=(m2-s2)/60;h2=im2/60; //PERIOD_M5	5	5 minutes.
m3=(iTime(NULL,15,0)+15*60)-TimeCurrent();s3=m3%60;im3=(m3-s3)/60;h3=im3/60; //PERIOD_M15	15	15 minutes.
m4=(iTime(NULL,30,0)+30*60)-TimeCurrent();s4=m4%60;im4=(m4-s4)/60;h4=im4/60; //PERIOD_M30	30	30 minutes.
m5=(iTime(NULL,60,0)+60*60)- TimeCurrent();s5=m5%60;im5=(m5-s5)/60;h5=im5/60; //PERIOD_H1	60	1 hour.
m6=(iTime(NULL,240,0)+240*60)-TimeCurrent();s6=m6%60;im6=((m6-s6)/60)%60;h6=((m6-s6)/60)/60; //PERIOD_H4	240	4 hour.
m7=(iTime(NULL,1440,0)+1440*60)-TimeCurrent();s7=m7%60;im7=((m7-s7)/60)%60;h7=((m7-s7)/60)/60; //PERIOD_D1	1440	Daily.

string  str_swieca_m1 =  ("open [M1]: "+TimeToStr(iTime(Symbol(),PERIOD_M1,0), TIME_DATE | TIME_SECONDS)+" | time to end: "+h1+":"+im1+":"+s1);
string  str_swieca_m5 =  ("open [M5]: "+TimeToStr(iTime(Symbol(),PERIOD_M5,0), TIME_DATE | TIME_SECONDS)+" | time to end: "+h2+":"+im2+":"+s2);
string  str_swieca_m15 = ("open [M15]: "+TimeToStr(iTime(Symbol(),PERIOD_M15,0), TIME_DATE | TIME_SECONDS)+" | time to end: "+h3+":"+im3+":"+s3);
string  str_swieca_m30 = ("open [M30]: "+TimeToStr(iTime(Symbol(),PERIOD_M30,0), TIME_DATE | TIME_SECONDS)+" | time to end: "+h4+":"+im4+":"+s4);
string  str_swieca_h1 =  ("open [H1]: "+TimeToStr(iTime(Symbol(),PERIOD_H1,0), TIME_DATE | TIME_SECONDS)+" | time to end: "+h5+":"+im5+":"+s5);
string  str_swieca_h4 =  ("open [H4]: "+TimeToStr(iTime(Symbol(),PERIOD_H4,0), TIME_DATE | TIME_SECONDS)+" | time to end: "+h6+":"+im6+":"+s6);
string  str_swieca_d =   ("open [D]: "+TimeToStr(iTime(Symbol(),PERIOD_D1,0), TIME_DATE | TIME_SECONDS)+" | time to end: "+h7+":"+im7+":"+s7);
string  str_swieca_w =   ("open [W]: "+TimeToStr(iTime(Symbol(),PERIOD_W1,0), TIME_DATE | TIME_SECONDS)+" | end bar: "+TimeToStr(iTime(Symbol(),PERIOD_W1,0)+10080*60, TIME_DATE | TIME_SECONDS));
string  str_swieca_mn =  ("open [MN]: "+TimeToStr(iTime(Symbol(),PERIOD_MN1,0), TIME_DATE | TIME_SECONDS)+" | end bar: "+TimeToStr(iTime(Symbol(),PERIOD_MN1,0)+43200*60, TIME_DATE | TIME_SECONDS));

//ObjectCreate("line2",OBJ_HLINE,windowIndex,0,28.5);ObjectSet("line2",OBJPROP_COLOR,RoyalBlue);ObjectSet("line2",OBJPROP_WIDTH,1);
// Symbol, Spread, Bid/Low, Ask/High, Freezlevel - Start
ObjectCreate("time_cur", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("time_cur","BROKER\'s time: "+TimeToStr(TimeCurrent(), TIME_DATE | TIME_SECONDS), 8, "Tahoma", Pink);
ObjectSet("time_cur", OBJPROP_CORNER, 0);ObjectSet("time_cur", OBJPROP_XDISTANCE, 28);ObjectSet("time_cur", OBJPROP_YDISTANCE, 5);
ObjectCreate("currency", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("currency","["+Symbol()+"]", 9, "Tahoma", Red);
ObjectSet("currency", OBJPROP_CORNER, 0);ObjectSet("currency", OBJPROP_XDISTANCE, 195);ObjectSet("currency", OBJPROP_YDISTANCE, 5);
ObjectCreate("cspread", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("cspread","spread: "+DoubleToStr(MarketInfo(Symbol(),MODE_SPREAD),0), 8, "Tahoma", RoyalBlue);
ObjectSet("cspread", OBJPROP_CORNER, 0);ObjectSet("cspread", OBJPROP_XDISTANCE, 255);ObjectSet("cspread", OBJPROP_YDISTANCE, 5);
ObjectCreate("max-ask", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("max-ask","Ask/High: "+DoubleToStr(MarketInfo(Symbol(),MODE_ASK),Digits)+"/"+DoubleToStr(MarketInfo(Symbol(),MODE_HIGH),Digits), 8, "Tahoma", SkyBlue);
ObjectSet("max-ask", OBJPROP_CORNER, 0);ObjectSet("max-ask", OBJPROP_XDISTANCE, 318);ObjectSet("max-ask", OBJPROP_YDISTANCE, 5);
ObjectCreate("low-bid", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("low-bid","Bid/Low: "+DoubleToStr(MarketInfo(Symbol(),MODE_BID),Digits)+"/"+DoubleToStr(MarketInfo(Symbol(),MODE_LOW),Digits), 8, "Tahoma", Tomato);
ObjectSet("low-bid", OBJPROP_CORNER, 0);ObjectSet("low-bid", OBJPROP_XDISTANCE, 444);ObjectSet("low-bid", OBJPROP_YDISTANCE, 5);
ObjectCreate("pipsdev", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("pipsdev","Current order freeze level in pips: "+DoubleToStr(MarketInfo(Symbol(), MODE_FREEZELEVEL),0)+" close/modify/cancel", 8, "Tahoma", Silver);
ObjectSet("pipsdev", OBJPROP_CORNER, 0);ObjectSet("pipsdev", OBJPROP_XDISTANCE, 570);ObjectSet("pipsdev", OBJPROP_YDISTANCE, 5);
ObjectCreate("tickvalue_", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("tickvalue_","1 Pip/Tick value for 1 MinLot: "+DoubleToStr(MarketInfo(Symbol(),MODE_TICKVALUE)*microlot,2)+" "+AccountCurrency(), 8, "Tahoma", DeepPink);
ObjectSet("tickvalue_", OBJPROP_CORNER, 0);ObjectSet("tickvalue_", OBJPROP_XDISTANCE, 870);ObjectSet("tickvalue_", OBJPROP_YDISTANCE, 5);


// Symbol, Spread, Bid/Low, Ask/High, Freezlevel - Stop
// teraz jest godzina NA ŒWIECIE - START
ObjectCreate("globalinf", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("globalinf",globalinf, 7, "Tahoma", Lime);
ObjectSet("globalinf", OBJPROP_CORNER, 0);ObjectSet("globalinf", OBJPROP_XDISTANCE, 318);ObjectSet("globalinf", OBJPROP_YDISTANCE, 21);
ObjectCreate("london", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("london",London2, 7, "Tahoma", DimGray);
ObjectSet("london", OBJPROP_CORNER, 0);ObjectSet("london", OBJPROP_XDISTANCE, 318);ObjectSet("london", OBJPROP_YDISTANCE, 30);
ObjectCreate("frankfurt", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("frankfurt",Frankfurt2, 7, "Tahoma", DimGray);
ObjectSet("frankfurt", OBJPROP_CORNER, 0);ObjectSet("frankfurt", OBJPROP_XDISTANCE, 318);ObjectSet("frankfurt", OBJPROP_YDISTANCE, 39);
ObjectCreate("newyork", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("newyork",NewYork2, 7, "Tahoma", DimGray);
ObjectSet("newyork", OBJPROP_CORNER, 0);ObjectSet("newyork", OBJPROP_XDISTANCE, 318);ObjectSet("newyork", OBJPROP_YDISTANCE, 48);
ObjectCreate("chicago", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("chicago",Chicago2, 7, "Tahoma", DimGray);
ObjectSet("chicago", OBJPROP_CORNER, 0);ObjectSet("chicago", OBJPROP_XDISTANCE, 318);ObjectSet("chicago", OBJPROP_YDISTANCE, 57);
ObjectCreate("tokyo", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("tokyo",Tokyo2, 7, "Tahoma", DimGray);
ObjectSet("tokyo", OBJPROP_CORNER, 0);ObjectSet("tokyo", OBJPROP_XDISTANCE, 318);ObjectSet("tokyo", OBJPROP_YDISTANCE, 66);
ObjectCreate("hongkong", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("hongkong",HongKong2, 7, "Tahoma", DimGray);
ObjectSet("hongkong", OBJPROP_CORNER, 0);ObjectSet("hongkong", OBJPROP_XDISTANCE, 318);ObjectSet("hongkong", OBJPROP_YDISTANCE, 75);
ObjectCreate("sydney", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("sydney",Sydney2, 7, "Tahoma", DimGray);
ObjectSet("sydney", OBJPROP_CORNER, 0);ObjectSet("sydney", OBJPROP_XDISTANCE, 318);ObjectSet("sydney", OBJPROP_YDISTANCE, 84);
ObjectCreate("Wellington", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("Wellington",Wellington2, 7, "Tahoma", DimGray);
ObjectSet("Wellington", OBJPROP_CORNER, 0);ObjectSet("Wellington", OBJPROP_XDISTANCE, 318);ObjectSet("Wellington", OBJPROP_YDISTANCE, 93);

ObjectCreate("InfoGMT", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("InfoGMT",InfoGMT, 9, "Tahoma", Lime);
ObjectSet("InfoGMT", OBJPROP_CORNER, 0);ObjectSet("InfoGMT", OBJPROP_XDISTANCE, 570);ObjectSet("InfoGMT", OBJPROP_YDISTANCE, 90);
ObjectCreate("2InfoGMT", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("2InfoGMT","_______________________________    ->", 9, "Tahoma", Lime);
ObjectSet("2InfoGMT", OBJPROP_CORNER, 0);ObjectSet("2InfoGMT", OBJPROP_XDISTANCE, 318);ObjectSet("2InfoGMT", OBJPROP_YDISTANCE, 90);

ObjectCreate("ConnectionInfo", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("ConnectionInfo",connection_info, 8, "Tahoma", DimGray);
ObjectSet("ConnectionInfo", OBJPROP_CORNER, 0);ObjectSet("ConnectionInfo", OBJPROP_XDISTANCE, 880);ObjectSet("ConnectionInfo", OBJPROP_YDISTANCE, 75);
ObjectCreate("TradeAllowed", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("TradeAllowed",".: Is trade allowed? "+cantrade_info+" :.", 9, "Tahoma", Crimson);
ObjectSet("TradeAllowed", OBJPROP_CORNER, 0);ObjectSet("TradeAllowed", OBJPROP_XDISTANCE, 880);ObjectSet("TradeAllowed", OBJPROP_YDISTANCE, 90);
ObjectCreate("swaplong", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("swaplong","Swap  Long: "+DoubleToStr(MarketInfo(Symbol(),MODE_SWAPLONG),2)+" "+AccountCurrency(), 7, "Tahoma", RoyalBlue);
ObjectSet("swaplong", OBJPROP_CORNER, 0);ObjectSet("swaplong", OBJPROP_XDISTANCE, 570);ObjectSet("swaplong", OBJPROP_YDISTANCE, 30);
ObjectCreate("swapshort", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("swapshort","Swap Short: "+DoubleToStr(MarketInfo(Symbol(),MODE_SWAPSHORT),2)+" "+AccountCurrency(), 7, "Tahoma", Red);
ObjectSet("swapshort", OBJPROP_CORNER, 0);ObjectSet("swapshort", OBJPROP_XDISTANCE, 570);ObjectSet("swapshort", OBJPROP_YDISTANCE, 39);
//
ObjectCreate("mouse", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("mouse","8", 17, "Wingdings", LimeGreen);
ObjectSet("mouse", OBJPROP_CORNER, 0);ObjectSet("mouse", OBJPROP_XDISTANCE, 540);ObjectSet("mouse", OBJPROP_YDISTANCE, 60);
ObjectCreate("lownews", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("lownews","[ low important ]: "+low_news, 7, "Tahoma", DimGray);
ObjectSet("lownews", OBJPROP_CORNER, 0);ObjectSet("lownews", OBJPROP_XDISTANCE, 570);ObjectSet("lownews", OBJPROP_YDISTANCE, 57);
ObjectCreate("mediumnews", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("mediumnews","[ medium important ]: "+medium_news, 7, "Tahoma", DimGray);
ObjectSet("mediumnews", OBJPROP_CORNER, 0);ObjectSet("mediumnews", OBJPROP_XDISTANCE, 570);ObjectSet("mediumnews", OBJPROP_YDISTANCE, 66);
ObjectCreate("highnews", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("highnews","[ high important ]: "+high_news, 7, "Tahoma", DimGray);
ObjectSet("highnews", OBJPROP_CORNER, 0);ObjectSet("highnews", OBJPROP_XDISTANCE, 570);ObjectSet("highnews", OBJPROP_YDISTANCE, 75);

//
ObjectCreate("margin_big", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("margin_big","Margin required for 1 Lot: "+DoubleToStr(margin,2)+" "+AccountCurrency(), 8, "Tahoma", Gold);
ObjectSet("margin_big", OBJPROP_CORNER, 0);ObjectSet("margin_big", OBJPROP_XDISTANCE, 690);ObjectSet("margin_big", OBJPROP_YDISTANCE, 30);
ObjectCreate("margin_min", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("margin_min","Margin required for "+DoubleToStr(microlot,2)+" Lot: "+DoubleToStr(margin*microlot,2)+" "+AccountCurrency(), 8, "Tahoma", Gold);
ObjectSet("margin_min", OBJPROP_CORNER, 0);ObjectSet("margin_min", OBJPROP_XDISTANCE, 690);ObjectSet("margin_min", OBJPROP_YDISTANCE, 39);
ObjectCreate("margin_onrisk", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("margin_onrisk"," -->  [ * Open no more than: "+DoubleToStr(LotsOptimized(),2)+" Lot/s ]", 8, "Tahoma", Gold);
ObjectSet("margin_onrisk", OBJPROP_CORNER, 0);ObjectSet("margin_onrisk", OBJPROP_XDISTANCE, 875);ObjectSet("margin_onrisk", OBJPROP_YDISTANCE, 35);
ObjectCreate("lot_step", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("lot_step"," -->  [ lot step: "+DoubleToStr(MarketInfo(Symbol(),MODE_LOTSTEP),2)+" Lot/s ]", 8, "Tahoma", Gold);
ObjectSet("lot_step", OBJPROP_CORNER, 0);ObjectSet("lot_step", OBJPROP_XDISTANCE, 875);ObjectSet("lot_step", OBJPROP_YDISTANCE, 45);
ObjectCreate("minlot", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("minlot"," -->  [ Min Lot: "+DoubleToStr(MarketInfo(Symbol(),MODE_MINLOT),2)+" Lot/s ]", 8, "Tahoma", Gold);
ObjectSet("minlot", OBJPROP_CORNER, 0);ObjectSet("minlot", OBJPROP_XDISTANCE, 875);ObjectSet("minlot", OBJPROP_YDISTANCE, 25);
ObjectCreate("risk_info", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("risk_info","* Current capital risk: "+DoubleToStr(risk,2)+" %", 8, "Tahoma", Gold);
ObjectSet("risk_info", OBJPROP_CORNER, 0);ObjectSet("risk_info", OBJPROP_XDISTANCE, 875);ObjectSet("risk_info", OBJPROP_YDISTANCE, 56);
// teraz jest godzina NA ŒWIECIE - STOP
//
// ile czasu zosta³o do koñca œwiecy w sekundach - start
ObjectCreate("bar_m1", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("bar_m1",str_swieca_m1, 7, "Tahoma", LimeGreen);
ObjectSet("bar_m1", OBJPROP_CORNER, 0);ObjectSet("bar_m1", OBJPROP_XDISTANCE, 5);ObjectSet("bar_m1", OBJPROP_YDISTANCE, 21);
ObjectCreate("bar_m5", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("bar_m5",str_swieca_m5, 7, "Tahoma", LimeGreen);
ObjectSet("bar_m5", OBJPROP_CORNER, 0);ObjectSet("bar_m5", OBJPROP_XDISTANCE, 5);ObjectSet("bar_m5", OBJPROP_YDISTANCE, 30);
ObjectCreate("bar_m15", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("bar_m15",str_swieca_m15, 7, "Tahoma", LimeGreen);
ObjectSet("bar_m15", OBJPROP_CORNER, 0);ObjectSet("bar_m15", OBJPROP_XDISTANCE, 5);ObjectSet("bar_m15", OBJPROP_YDISTANCE, 39);
ObjectCreate("bar_m30", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("bar_m30",str_swieca_m30, 7, "Tahoma", MediumSeaGreen);
ObjectSet("bar_m30", OBJPROP_CORNER, 0);ObjectSet("bar_m30", OBJPROP_XDISTANCE, 5);ObjectSet("bar_m30", OBJPROP_YDISTANCE, 48);
ObjectCreate("bar_h1", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("bar_h1",str_swieca_h1, 7, "Tahoma", MediumSeaGreen);
ObjectSet("bar_h1", OBJPROP_CORNER, 0);ObjectSet("bar_h1", OBJPROP_XDISTANCE, 5);ObjectSet("bar_h1", OBJPROP_YDISTANCE, 57);
ObjectCreate("bar_h4", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("bar_h4",str_swieca_h4, 7, "Tahoma", MediumSeaGreen);
ObjectSet("bar_h4", OBJPROP_CORNER, 0);ObjectSet("bar_h4", OBJPROP_XDISTANCE, 5);ObjectSet("bar_h4", OBJPROP_YDISTANCE, 66);
ObjectCreate("bar_d", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("bar_d",str_swieca_d, 7, "Tahoma", DarkSeaGreen);
ObjectSet("bar_d", OBJPROP_CORNER, 0);ObjectSet("bar_d", OBJPROP_XDISTANCE, 5);ObjectSet("bar_d", OBJPROP_YDISTANCE, 75);
ObjectCreate("bar_w", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("bar_w",str_swieca_w, 7, "Tahoma", DarkSeaGreen);
ObjectSet("bar_w", OBJPROP_CORNER, 0);ObjectSet("bar_w", OBJPROP_XDISTANCE, 5);ObjectSet("bar_w", OBJPROP_YDISTANCE, 84);
ObjectCreate("bar_mn", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("bar_mn",str_swieca_mn, 7, "Tahoma", DarkSeaGreen);
ObjectSet("bar_mn", OBJPROP_CORNER, 0);ObjectSet("bar_mn", OBJPROP_XDISTANCE, 5);ObjectSet("bar_mn", OBJPROP_YDISTANCE, 93);
// ile czasu zosta³o do koñca œwiecy w sekundach - stop
// choinka 2009/2010
ObjectCreate("choinka1", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("choinka1",CharToStr(182), 9, "Wingdings", LimeGreen);
ObjectSet("choinka1", OBJPROP_CORNER, 0);ObjectSet("choinka1", OBJPROP_XDISTANCE, 1086);ObjectSet("choinka1", OBJPROP_YDISTANCE, 70);
ObjectCreate("choinka2", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("choinka2","-*-|-*-", 9, "Tahoma", LimeGreen);
ObjectSet("choinka2", OBJPROP_CORNER, 0);ObjectSet("choinka2", OBJPROP_XDISTANCE, 1075);ObjectSet("choinka2", OBJPROP_YDISTANCE, 83);
ObjectCreate("choinka3", OBJ_LABEL, windowIndex, 0, 0);ObjectSetText("choinka3",".*-*-|-*-*.", 9, "Tahoma", LimeGreen);
ObjectSet("choinka3", OBJPROP_CORNER, 0);ObjectSet("choinka3", OBJPROP_XDISTANCE, 1064);ObjectSet("choinka3", OBJPROP_YDISTANCE, 96);
//
 WindowRedraw(); 
return(0);
  }
//+------------------------------------------------------------------+

double LotsOptimized()
{
   int msc_po_przecinku, mianownik;
   double Lot1,
   Min_Lot = MarketInfo(Symbol(), MODE_MINLOT), 
   margin=MarketInfo(Symbol(),MODE_MARGINREQUIRED), 
   microlot=MarketInfo(Symbol(),MODE_MINLOT);
   if (Min_Lot==0.01)
   {Lot1 = NormalizeDouble( (AccountEquity() * (risk/100))/(margin)  ,2);}
   else
   {Lot1 = NormalizeDouble( (AccountEquity() * (risk/100))/(margin)  ,1);}
   return(Lot1);
}


