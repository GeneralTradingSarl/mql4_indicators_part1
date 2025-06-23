//+------------------------------------------------------------------+
//|                                                   Candle SnR.mq4 |
//|                   Copyright 2005-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright   "2005-2014, MetaQuotes Software Corp."
#property link "http://free-bonus-deposit.blogspot.com"
#property description "Candle SnR"
#property indicator_chart_window

extern color   MainColor=MediumTurquoise;
extern int Days=20;

int BarShift=1;
double ratio;
int TimeFrame;

string Name;
color iLcolor;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   DelLine();
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
//double Range=HighPrice - LowPrice;
   datetime TimeStart;
   datetime TimeEnd;
   double DayOpen;

   if(Volume[0]<3) DelLine();

   if(Period()>=1440) TimeFrame=43200;
   if(Period()==240) TimeFrame=10080;
   if(Period()<=60) TimeFrame=1440;

   for(int x=1; x<Days+1; x++)
     {
      TimeStart=iTime(Symbol(),TimeFrame,x-1);
      TimeEnd=iTime(Symbol(),TimeFrame,x-2);

      double Hi=iHigh(Symbol(),TimeFrame,x);
      double Lo=iLow(Symbol(),TimeFrame,x);
      double Cl=iClose(Symbol(),TimeFrame,x);
      double Op=iOpen(Symbol(),TimeFrame,x);

      if(x==1) TimeEnd=TimeStart+60*100*60;

      DayOpen=iOpen(Symbol(),TimeFrame,x-1);

      if(x==1) int ray=1; else ray=0;

      iLcolor=MainColor;

      draw(" Open "+x,TimeStart,Op,TimeEnd,iLcolor,2,ray);
      draw(" Low "+x,TimeStart,Lo,TimeEnd,iLcolor,1,ray);
      draw(" High "+x,TimeStart,Hi,TimeEnd,iLcolor,1,ray);
      draw(" Close "+x,TimeStart,Cl,TimeEnd,iLcolor,1,ray);
     }
   dpkfx();
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void draw(string Line,datetime TimeStart,double Price,datetime TimeEnd,color line_clr,int line_width,int ray)
  {
   ObjectCreate(Line,OBJ_TREND,0,TimeStart,Price,TimeEnd,Price);
   ObjectSet(Line,OBJPROP_COLOR,line_clr);
   ObjectSet(Line,OBJPROP_STYLE,STYLE_DOT);
   ObjectSet(Line,OBJPROP_WIDTH,line_width);
   ObjectSet(Line,OBJPROP_BACK,True);
   ObjectSet(Line,OBJPROP_RAY,ray);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void dpkfx()
  {
   int ipos=2;
   int xpos=30;

   double vol=(iHigh(Symbol(),1440,0)-iLow(Symbol(),1440,0))/Point;

   int st=1;
   stats("line","----------------------------",9,"Arial",White,ipos,xpos-1,42);
   stats("dpkforex","TodayRange  :  "+DoubleToStr(vol,0),10,"Impact",Yellow,ipos,xpos,30);
   stats("line2","----------------------------",9,"Arial",White,ipos,xpos-1,21);
   stats("line3","http://free-bonus-deposit.blogspot.com",9,"Arial",White,ipos,xpos-1,10);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void stats(string tname,string word,int fsize,string ftype,color tcolor,int posxy,int posx,int posy)
  {
   ObjectCreate(tname,OBJ_LABEL,0,0,0);
   ObjectSetText(tname,word,fsize,ftype,tcolor);
   ObjectSet(tname,OBJPROP_CORNER,posxy);
   ObjectSet(tname,OBJPROP_XDISTANCE,posx);
   ObjectSet(tname,OBJPROP_YDISTANCE,posy);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DelLine()
  {
   for(int x=1; x<Days+1; x++)
     {
      ObjectDelete("OPEN"+x);

      ObjectDelete(" Open "+x);
      ObjectDelete(" Low "+x);
      ObjectDelete(" High "+x);
      ObjectDelete(" Close "+x);
     }
  }
//+------------------------------------------------------------------+
