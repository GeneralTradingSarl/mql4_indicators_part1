//+------------------------------------------------------------------+
//|                                                               a_info.mq4 |
//|                                         Copyright © 2010, Elmare |
//|                                         http://elmare.webnode.ru  |
//+------------------------------------------------------------------+
#property copyright "Elmare © 2010"
#property link      "http://elmare.webnode.ru/"

#property indicator_chart_window

extern int ATR_Period=5;
extern double comission=0;
extern int shift=10;
extern bool symbol = true;
extern bool frame = true;
double pprice;
string sprice;
double hl;
string shl;
double pto;
string spto;
int k;
int d;
int fsize=11;
int pfsize=24;
color fcolor=Orange;
double da;
string sda;
string font="Microsoft Sans Serif";
string instr;
int per;
string sper;
string ssprd;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {

instr=Symbol();
instr=StringSubstr(instr,0,6);

per=Period();
if (per<60){sper="M"+per;}
else if(per>=60&&per<60*24) {sper="H"+per/60+" ";}
else {sper="D"+per/(60*24);}

ObjectCreate("L",OBJ_LABEL,0,0,0);
ObjectSet("L",OBJPROP_CORNER,1);
ObjectSet("L",OBJPROP_XDISTANCE,3);
ObjectSet("L",OBJPROP_YDISTANCE,0+shift);


//======================================
if (symbol)
{
ObjectCreate("Instr",OBJ_LABEL,0,0,0);
ObjectSet("Instr",OBJPROP_CORNER,1);
ObjectSet("Instr",OBJPROP_XDISTANCE,62);
ObjectSet("Instr",OBJPROP_YDISTANCE,120+shift);
ObjectSetText("Instr",instr,12,font,DarkSlateGray);
}
if (frame)
{
ObjectCreate("Peri",OBJ_LABEL,0,0,0);
ObjectSet("Peri",OBJPROP_CORNER,1);
ObjectSet("Peri",OBJPROP_XDISTANCE,4);
ObjectSet("Peri",OBJPROP_YDISTANCE,120+shift);
ObjectSetText("Peri",sper,12,font,DarkSlateGray);
}

ObjectCreate("L1",OBJ_LABEL,0,0,0);
ObjectSet("L1",OBJPROP_CORNER,1);
ObjectSet("L1",OBJPROP_XDISTANCE,36);
ObjectSet("L1",OBJPROP_YDISTANCE,40+shift);
ObjectSetText("L1","High to Low  :",fsize,font,fcolor);



ObjectCreate("L11",OBJ_LABEL,0,0,0);
ObjectSet("L11",OBJPROP_CORNER,1);
ObjectSet("L11",OBJPROP_XDISTANCE,5);
ObjectSet("L11",OBJPROP_YDISTANCE,40+shift);

//======================================

ObjectCreate("L2",OBJ_LABEL,0,0,0);
ObjectSet("L2",OBJPROP_CORNER,1);
ObjectSet("L2",OBJPROP_XDISTANCE,36);
ObjectSet("L2",OBJPROP_YDISTANCE,60+shift);
ObjectSetText("L2","Pips to Open:",fsize,font,fcolor);



ObjectCreate("L22",OBJ_LABEL,0,0,0);
ObjectSet("L22",OBJPROP_CORNER,1);
ObjectSet("L22",OBJPROP_XDISTANCE,5);
ObjectSet("L22",OBJPROP_YDISTANCE,60+shift);

//======================================

ObjectCreate("L3",OBJ_LABEL,0,0,0);
ObjectSet("L3",OBJPROP_CORNER,1);
ObjectSet("L3",OBJPROP_XDISTANCE,36);
ObjectSet("L3",OBJPROP_YDISTANCE,80+shift);
//ObjectSetText("L3","Day Average:",fsize,font,fcolor);



ObjectCreate("L33",OBJ_LABEL,0,0,0);
ObjectSet("L33",OBJPROP_CORNER,1);
ObjectSet("L33",OBJPROP_XDISTANCE,5);
ObjectSet("L33",OBJPROP_YDISTANCE,80+shift);

//=======================================

ObjectCreate("L4",OBJ_LABEL,0,0,0);
ObjectSet("L4",OBJPROP_CORNER,1);
ObjectSet("L4",OBJPROP_XDISTANCE,36);
ObjectSet("L4",OBJPROP_YDISTANCE,100+shift);
ObjectSetText("L4","Spread         :",fsize,font,fcolor);



ObjectCreate("L44",OBJ_LABEL,0,0,0);
ObjectSet("L44",OBJPROP_CORNER,1);
ObjectSet("L44",OBJPROP_XDISTANCE,5);
ObjectSet("L44",OBJPROP_YDISTANCE,100+shift);








if(Digits==5){k=10000;d=5;} 
else if(Digits==4){k=10000;d=4;}
else if(Digits==3){k=100;d=3;}
else if(Digits==2){k=10;d=2;}
else {k=100;d=2;}

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
ObjectDelete("L");
ObjectDelete("L1");
ObjectDelete("L11");
ObjectDelete("L2");
ObjectDelete("L22");
ObjectDelete("L3");
ObjectDelete("L33");
ObjectDelete("L4");
ObjectDelete("L44");
ObjectDelete("Instr");
ObjectDelete("Peri");

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
  
sprice=DoubleToStr(Bid,d-1); 
hl=iHigh(0,PERIOD_D1,0)-iLow(0,PERIOD_D1,0); 
hl*=k;
shl=DoubleToStr(hl,0);
pto=(Bid-iOpen(0,PERIOD_D1,0))*k;
spto=DoubleToStr(pto,0);
da=iATR(0,PERIOD_D1,ATR_Period,1);
da*=k;
sda=DoubleToStr(da,0);
//ssprd=DoubleToStr(deduct(Ask,Bid)*k+comission,1);
ssprd=DoubleToStr((Ask-Bid)*k+comission,1);
 
//===================================  
if (pprice>Bid)
   {
      ObjectSetText("L",sprice,pfsize,"Digifacewide",Red);
      pprice=Bid;
   }
if (pprice<Bid)
   {
      ObjectSetText("L",sprice,pfsize,"Digifacewide",Lime);
      pprice=Bid;
   }
//======================================

ObjectSetText("L11",shl,fsize,font,LightGray);

//=====================================================

if (pto<=0){ObjectSetText("L22",spto,fsize,font,Red);}
if (pto>0){ObjectSetText("L22",spto,fsize,font,Lime);}

//======================================

ObjectSetText("L33",sda,fsize,font,LightGray);
ObjectSetText("L3",ATR_Period+" Days Avrg :",fsize,font,fcolor);
ObjectSetText("L44",ssprd,fsize,font,LightGray);

   return(0);
  }
//+------------------------------------------------------------------+