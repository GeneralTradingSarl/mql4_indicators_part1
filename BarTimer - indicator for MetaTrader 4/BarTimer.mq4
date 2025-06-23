//+------------------------------------------------------------------+
//|                                                     BarTimer.mq4 |
//|                               Copyright © 2008, Art Royal s.r.o. |
//|                                           Author: Vasyl Gumenyak |  
//|                                           http://www.jiport.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, Art Royal s.r.o."
#property link      "http://www.jiport.com/"

#property indicator_chart_window
#property indicator_buffers 0

extern string FontName="Arial";
extern int FontSize=14;
extern color FontColor=White;
extern int Corner=0;// values [0-3] - опорный угол
extern int XDistance=250;// x расстояние от опорного угла
extern int YDistance=0;// y расстояние от опорного угла

int lenbase;
string s_base=":...:...:...:...:";// строка для формирования индикатора с ползунком

int init()
  {
   lenbase=StringLen(s_base);
   return(0);
  }

int deinit()
  {
   if (ObjectFind("BarTimer") != -1) ObjectDelete("BarTimer");
   return(0);
  }

//+------------------------------------------------------------------+
//| ползунок отмечает текущиее положение по времени                  |
//|   относительно начала и конца текущего бара,                     |
//| дополнительно дается доля времени                                |
//|   прошедшего от начала бара в процентах                          |
//+------------------------------------------------------------------+
int start()
  {
   int i=0,sec=0;
   double pc=0.0;
   string time="",s_end="",s_beg="";
   if (ObjectFind("BarTimer") == -1) {// если объект не найден - создаем и задаем параметры
     ObjectCreate("BarTimer" , OBJ_LABEL,0,0,0);
     ObjectSet("BarTimer", OBJPROP_XDISTANCE, XDistance);
     ObjectSet("BarTimer", OBJPROP_YDISTANCE, YDistance);
     ObjectSet("BarTimer", OBJPROP_CORNER, Corner);
   }
   sec=TimeCurrent()-Time[0];// время в секундах от начала бара
   i=(lenbase-1)*sec/(Period()*60);// позиция ползунка
   pc=100.0*sec/(Period()*60);// время от начала бара в процентах
   if(i>lenbase-1) i=lenbase-1;// возможно излишний контроль границы
   if(i>0) s_beg=StringSubstr(s_base,0,i);
   if(i<lenbase-1) s_end=StringSubstr(s_base,i+1,lenbase-i-1);
   time=StringConcatenate(s_beg,"|",s_end,"  ",DoubleToStr(pc,0),"%");
   ObjectSetText("BarTimer", time, FontSize, FontName, FontColor);

   return(0);
  }
//+------------------------------------------------------------------+