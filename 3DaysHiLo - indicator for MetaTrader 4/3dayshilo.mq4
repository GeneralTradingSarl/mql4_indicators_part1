//+------------------------------------------------------------------+
//|                                                                  
//|                       3DaysHiLo.mq4              
//|                                         
//|                       http://free-bonus-deposit.blogspot.com/              
//|                                                                  
//+------------------------------------------------------------------+
#property indicator_chart_window
#property link "http://free-bonus-deposit.blogspot.com/"

input color   Day1Color=clrWhite;
input color   Day2Color=clrGray;
input color   Day3Color=clrGold;
input int     LineWidth=2;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   return(0);
  }
//-------------------------------------------------------- 
int deinit()
  {
   ObjectDelete("Day1Hi");
   ObjectDelete("Day1Lo");
   ObjectDelete("Day2Hi");
   ObjectDelete("Day2Lo");
   ObjectDelete("Day3Hi");
   ObjectDelete("Day3Lo");

   return(0);
  }
//--------------------------------------------------------- 
int start()
  {
   double D1Hi=iHigh(Symbol(),1440,1);
   double D1Lo=iLow(Symbol(),1440,1);
   datetime D1Time=iTime(Symbol(),1440,1);

   double D2Hi=iHigh(Symbol(),1440,2);
   double D2Lo=iLow(Symbol(),1440,2);
   datetime D2Time=iTime(Symbol(),1440,2);

   double D3Hi=iHigh(Symbol(),1440,3);
   double D3Lo=iLow(Symbol(),1440,3);
   datetime D3Time=iTime(Symbol(),1440,3);

   datetime TimeEnd=iTime(Symbol(),1440,0)+1440*60;

   draw("Day1Hi",D1Time,D1Hi,TimeEnd,Day1Color,LineWidth,0);
   draw("Day1Lo",D1Time,D1Lo,TimeEnd,Day1Color,LineWidth,0);

   draw("Day2Hi",D2Time,D2Hi,TimeEnd,Day2Color,LineWidth,0);
   draw("Day2Lo",D2Time,D2Lo,TimeEnd,Day2Color,LineWidth,0);

   draw("Day3Hi",D3Time,D3Hi,TimeEnd,Day3Color,LineWidth,0);
   draw("Day3Lo",D3Time,D3Lo,TimeEnd,Day3Color,LineWidth,0);

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
   int ipos=3;
   int xpos=10;

   double vol=(iHigh(Symbol(),1440,0)-iLow(Symbol(),1440,0))/Point;

   int st=1;

   stats("dpkforex","TodayRange  :  "+DoubleToStr(vol,0),12,"Impact",Yellow,ipos,xpos,22);
   stats("line2","http://free-bonus-deposit.blogspot.com",8,"Arial",White,ipos,xpos-1,10);
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
