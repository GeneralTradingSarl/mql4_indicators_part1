//+------------------------------------------------------------------+
//|                                          CandleTimeStationary.mq4|
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+

#property indicator_chart_window
//---- input parameters

extern color  Clock_Color = DimGray;
extern string Corner_Placement = "1 is top right 3 is bottom right";
extern int    Corner = 3;


string objname="Spread&Bar";
double s1[];

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init(){

  ObjectCreate(objname, OBJ_LABEL,0, 0, 0);
  ObjectSet(objname, OBJPROP_CORNER, Corner);
  ObjectSet(objname, OBJPROP_XDISTANCE, 10);
  ObjectSet(objname, OBJPROP_YDISTANCE, 2);     
   
   //----
   return(0);
}
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit(){

  ObjectDelete(objname);

  //----
  return(0);
} 


//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
{

   //Time to bar expiry
  int m,s;

  m=Time[0]+Period()*60-CurTime();
  s=m%60;
  m=(m-s)/60;
  int spread=MarketInfo(Symbol(), MODE_SPREAD);

  string _sp="",_m="",_s="";
  if (spread<10) _sp="..";
  else if (spread<100) _sp=".";
  if (m<10) _m="0";
  if (s<10) _s="0";
  
  ObjectSetText(objname,"Spread: " +DoubleToStr(spread,0)+_sp+" Next Bar in "+_m+DoubleToStr(m,0)+":"+_s+DoubleToStr(s,0), 10, "Courier", Clock_Color);
  return(0);
}
//+---------------------------------------------------------