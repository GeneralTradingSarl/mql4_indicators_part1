//+------------------------------------------------------------------+
//|                                                        DXWeekSnR |
//|                                           Copyright 2012, dXerof |
//+------------------------------------------------------------------+
#property  copyright "dXerof"
#property link "http://free-bonus-deposit.blogspot.com/"
#property indicator_chart_window

extern int TF=10080;
extern color Lcolor= Red;
extern int CountSnR=4;
extern int CountBar=1000;
extern int start=0;
int CountLine=5;
bool UseBP=False;
double BPSize=30;
bool SnR=True;

double fiborat=1.00061803;

string Name;
double poen;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   if(Digits==2 || Digits==4) poen=Point; else poen=10*Point;
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete("Open");
   ObjectDelete("Close");
   ObjectDelete("High");
   ObjectDelete("Low");

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   double Hi=iHigh(Symbol(),TF,1);
   double Lo=iLow(Symbol(),TF,1);
   double Cl=iClose(Symbol(),TF,1);
   double Op=iOpen(Symbol(),TF,1);

//Above hi
   if(Close[0]>Hi || Close[0]<Lo)
     {
      for(int i=1; i<CountBar; i++)
        {
         if(Close[0]>iLow(Symbol(),TF,i) && Close[0]<iHigh(Symbol(),TF,i))
           {
            double iHi=iHigh(Symbol(),TF,i);
            double iLo=iLow(Symbol(),TF,i);
            double iCl=iClose(Symbol(),TF,i);
            double iOp=iOpen(Symbol(),TF,i);
            datetime date=iTime(Symbol(),TF,i);

            Op=iOp;
            Cl=iCl;
            Hi=iHi;
            Lo=iLo;

            break;
           }
        }
     }
//Below Low
   if(Close[0]<Lo)
     {
      for(i=1; i<CountBar; i++)
        {
         if(Close[0]<iHigh(Symbol(),TF,i) && Close[0]>iLow(Symbol(),TF,i))
           {
            iHi=iHigh(Symbol(),TF,i);
            iLo=iLow(Symbol(),TF,i);
            iCl=iClose(Symbol(),TF,i);
            iOp=iOpen(Symbol(),TF,i);
            date=iTime(Symbol(),TF,i);

            Op=iOp;
            Cl=iCl;
            Hi=iHi;
            Lo=iLo;

            break;
           }
        }
     }
   ObjectDelete("Open");
   ObjectDelete("Close");
   ObjectDelete("High");
   ObjectDelete("Low");

   if(Cl>Op) Lcolor=YellowGreen; else Lcolor=Red;

   draw("Open",date,Op,Lcolor,1);
   draw("Close",date,Cl,Lcolor,1);
   draw("High",date,Hi,Lcolor,1);
   draw("Low",date,Lo,Lcolor,1);
   date=iTime(Symbol(),TF,i);

   dpkfx();

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void draw(string Line,int TimeStart,double Price,color line_clr,int line_width)
  {
   ObjectCreate(Line,OBJ_TREND,0,TimeStart,Price,CurTime(),Price);
   ObjectSet(Line,OBJPROP_COLOR,line_clr);
   ObjectSet(Line,OBJPROP_STYLE,STYLE_DOT);
   ObjectSet(Line,OBJPROP_WIDTH,line_width);
   ObjectSet(Line,OBJPROP_BACK,True);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void dpkfx()
  {
   int ipos=3;
   int xpos=30;

   double vol=(iHigh(Symbol(),1440,0)-iLow(Symbol(),1440,0))/Point;

   int st=1;
   stats("line","------------------",9,"Arial",White,ipos,xpos-1,45);
   stats("dpkforex","dXerof Oye",12,"Impact",Lime,ipos,xpos,30);
   stats("line2","------------------",9,"Arial",White,ipos,xpos-1,21);
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
