//+------------------------------------------------------------------+
//|                                             Candle Direction.mq4 |
//|                                   Copyright 2014, Luis Andrianto |
//|                            https://login.mql5.com/en/users/lou15 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, Luis Andrianto"
#property link      "https://login.mql5.com/en/users/lou15"

#property indicator_chart_window
#property indicator_buffers 1

extern color LabelColor=DodgerBlue;
extern int Corner=0;
extern color UpColor=LimeGreen;
extern color DownColor=Red;
extern color NetralColor=White;

int TF[]={1,5,15,30,60,240,1440,10080,43200};
string Label[]={"M1","M5","M15","M30","H1","H4","D1","W1","MN"};
double ExtBuff[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexBuffer(0,ExtBuff,INDICATOR_DATA);
   
   for(int i=0;i<=8;i++)
   {
      ObjectCreate(Label[i],OBJ_LABEL,0,0,0);
      ObjectCreate(Label[i]+" ARROW",OBJ_LABEL,0,0,0);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   for(int i=0;i<=8;i++)
   {
      ObjectDelete(Label[i]);
      ObjectDelete(Label[i]+" ARROW");
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+

double OCandle(int tf){double OC=iOpen(Symbol(),tf,0);return(OC);}
double CCandle(int tf){double CC=iClose(Symbol(),tf,0);return(CC);}

void ObSetLabel(string name,string text,int x,int y)
   {
      ObjectSetText(name,text,10,"Impact",LabelColor);
      ObjectSet(name,OBJPROP_CORNER,Corner);
      ObjectSet(name,OBJPROP_XDISTANCE,x);
      ObjectSet(name,OBJPROP_YDISTANCE,y);
      ObjectSet(name,OBJPROP_BACK,0);
   }
void ObSetArrow(string name,int code,int x,int y,color clr)
   {
      ObjectSetText(name,CharToStr(code),14,"Wingdings",clr);      
      ObjectSet(name,OBJPROP_CORNER,Corner);
      ObjectSet(name,OBJPROP_XDISTANCE,x);
      ObjectSet(name,OBJPROP_YDISTANCE,y);
      ObjectSet(name,OBJPROP_BACK,0);
   }

int start()
  {
   
//----
   
   int X_Start=0;
   int Y_Start=20;
   color clr;
   for(int i=0;i<=8;i++)
      {
         X_Start=X_Start+30;        
         
         ObSetLabel(Label[i],Label[i],X_Start,Y_Start);
         
         if(CCandle(TF[i])>OCandle(TF[i])){clr=UpColor;ExtBuff[i]=1;}
         else if(CCandle(TF[i])<OCandle(TF[i])){clr=DownColor;ExtBuff[i]=2;}
         else {clr=NetralColor;ExtBuff[i]=0;}
         
         ObSetArrow(Label[i]+" ARROW",110,X_Start,Y_Start+20,clr);
       }
//----
   return(0);
  }
//+------------------------------------------------------------------+