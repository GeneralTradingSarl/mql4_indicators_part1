//+------------------------------------------------------------------+
//|                                                       cek OP.mq4 |
//|                               Copyright 2014, 101177ui@gmail.com |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, 101177ui@gmail.com"
#property link      "http://www.mql4.com"
#property indicator_chart_window

input bool Comment=true;//see comment

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   Comment("");
   return(INIT_SUCCEEDED);
  }
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   Comment("");
   ObjectsDeleteAll();
   return(0);
  }
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {double AM=AccountInfoDouble(ACCOUNT_MARGIN);
   if(AM==0)AM=Point;
   double ML=AccountInfoDouble(ACCOUNT_EQUITY)/AM*100;
   if(AM==0)ML=0;
   if(Comment)
      Comment("\n","ACCOUNT_BALANCE        =  ",AccountInfoDouble(ACCOUNT_BALANCE),
              "\n","ACCOUNT_PROFIT           =  ",AccountInfoDouble(ACCOUNT_PROFIT),
              "\n","ACCOUNT_EQUITY           =  ",AccountInfoDouble(ACCOUNT_EQUITY),
              "\n","ACCOUNT_MARGIN          =  ",AccountInfoDouble(ACCOUNT_MARGIN),
              "\n","ACCOUNT_FREEMARGIN  =  ",AccountInfoDouble(ACCOUNT_FREEMARGIN),
              "\n","MARGIN LEVEL                  =  ",ML," %"
              );
              
   string symbol=Symbol();
   int cntcb;
//+------------------------------------------------------------------+
//| gambar price aktual                                              |
//+------------------------------------------------------------------+
   
   for(cntcb=OrdersTotal(); cntcb>=0; cntcb--)
     {
      if(OrderSelect(cntcb,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()==symbol)
           {
            string AN="BUY"+OrderOpenPrice()+TimeToStr(OrderOpenTime());
            if(OrderType()==0)
               if(ObjectGet(AN,OBJPROP_PRICE1)==0)
                  gbr(AN,OrderOpenTime(),OrderOpenPrice(),3,Blue);
            AN="TPBUY"+OrderOpenPrice()+OrderTakeProfit()+TimeToStr(OrderOpenTime());
            if(OrderType()==0)
               if(ObjectGet(AN,OBJPROP_PRICE1)==0)
                  gbr(AN,Time[0],+OrderTakeProfit(),3,White);
            AN="SELL"+OrderOpenPrice()+TimeToStr(OrderOpenTime());
            if(OrderType()==1)
               if(ObjectGet(AN,OBJPROP_PRICE1)==0)
                  gbr(AN,OrderOpenTime(),OrderOpenPrice(),3,Red);
            AN="TPSELL"+OrderOpenPrice()+OrderTakeProfit()+TimeToStr(OrderOpenTime());
            if(OrderType()==1)
               if(ObjectGet(AN,OBJPROP_PRICE1)==0)
                  gbr(AN,Time[0],+OrderTakeProfit(),3,Green);
           }
     }
//+------------------------------------------------------------------+
//| baca sejarah                                                     |
//+------------------------------------------------------------------+
   for(cntcb=0; cntcb<=OrdersHistoryTotal(); cntcb++)
     {
      if(OrderSelect(cntcb,SELECT_BY_POS,MODE_HISTORY))
         if(OrderSymbol()==symbol)
           {
            AN="BUY"+OrderOpenPrice()+TimeToStr(OrderOpenTime());
            ObjectDelete(AN);
            if(OrderType()==0)
               if(ObjectGet(AN,OBJPROP_PRICE1)==0)
                  gbr(AN,OrderOpenTime(),OrderOpenPrice(),1,Blue);
            AN="CloseBUY"+OrderClosePrice()+TimeToStr(OrderOpenTime());
            ObjectDelete(AN);
            if(OrderType()==0)
               if(ObjectGet(AN,OBJPROP_PRICE1)==0)
                  gbr(AN,OrderCloseTime(),OrderClosePrice(),11,White);
            AN="LCloseBUY"+OrderClosePrice()+TimeToStr(OrderOpenTime());
            ObjectDelete(AN);
            if(OrderType()==0)
               if(ObjectGet(AN,OBJPROP_PRICE1)==0)
                  tren(AN,OrderOpenTime(),OrderOpenPrice(),OrderCloseTime(),OrderClosePrice(),5,Blue);
            AN="SELL"+OrderOpenPrice()+TimeToStr(OrderOpenTime());
            ObjectDelete(AN);
            if(OrderType()==1)
               if(ObjectGet(AN,OBJPROP_PRICE1)==0)
                  gbr(AN,OrderOpenTime(),OrderOpenPrice(),1,Red);
            AN="CloseSELL"+OrderClosePrice()+TimeToStr(OrderOpenTime());
            ObjectDelete(AN);
            if(OrderType()==1)
               if(ObjectGet(AN,OBJPROP_PRICE1)==0)
                  gbr(AN,OrderCloseTime(),OrderClosePrice(),11,Aqua);

            AN="LCloseSELL"+OrderClosePrice()+TimeToStr(OrderOpenTime());
            ObjectDelete(AN);
            if(OrderType()==1)
               if(ObjectGet(AN,OBJPROP_PRICE1)==0)
                  tren(AN,OrderOpenTime(),OrderOpenPrice(),OrderCloseTime(),OrderClosePrice(),5,Red);
           }
     }
   return(0);
  }
//+------------------------------------------------------------------+
//| kode panah                                                       |
//+------------------------------------------------------------------+
void gbr(string nama,datetime tempat,double harga1,int kode,color warna)
  {
   if(kode==1)
     {
      ObjectCreate(nama,OBJ_ARROW,0,tempat,harga1);
      ObjectSet(nama,OBJPROP_ARROWCODE,1);
      ObjectSet(nama,OBJPROP_COLOR,warna);
     }
   if(kode==11)
     {
      ObjectCreate(nama,OBJ_ARROW,0,tempat,harga1);
      ObjectSet(nama,OBJPROP_ARROWCODE,3);
      ObjectSet(nama,OBJPROP_COLOR,warna);
     }
   if(kode==2)
     {
      ObjectCreate(nama,OBJ_ARROW,0,tempat,harga1);
      ObjectSet(nama,OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
      ObjectSet(nama,OBJPROP_COLOR,warna);
      ObjectSet(nama,OBJPROP_PRICE1,harga1);
      ObjectSet(nama,OBJPROP_TIME1,tempat);
     }
   if(kode==3)
     {
      ObjectCreate(nama,OBJ_ARROW,0,tempat,harga1);
      ObjectSet(nama,OBJPROP_ARROWCODE,SYMBOL_LEFTPRICE);
      ObjectSet(nama,OBJPROP_COLOR,warna);
      ObjectSet(nama,OBJPROP_PRICE1,harga1);
      ObjectSet(nama,OBJPROP_TIME1,tempat);
     }
   if(kode==4)
     {
      ObjectCreate(nama,OBJ_HLINE,0,0,harga1);
      ObjectSet(nama,OBJPROP_COLOR,warna);
      ObjectSet(nama,OBJPROP_WIDTH,1);
      ObjectSet(nama,OBJPROP_RAY,False);
     }
   return;
  }//*/
//+------------------------------------------------------------------+
//| Gambar trenline                                                  |
//+------------------------------------------------------------------+
void tren(string nama,datetime tempat1,double harga1,datetime tempat2,double harga2,int kode,color warna)
  {
   if(kode==5)
     {
      ObjectCreate(nama,OBJ_TREND,0,tempat1,harga1,tempat2,harga2);
      ObjectSet(nama,6,warna);
      ObjectSet(nama,7,STYLE_DOT);
      ObjectSet(nama,10,0);
      ObjectSetText(nama,nama);
     }
   return;
  }
