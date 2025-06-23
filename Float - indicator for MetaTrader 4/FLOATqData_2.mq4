//+--------------------------------------------------------------------------------+
//|                Float.mq4                                                       |
//|                Copyright © 2005  Barry Stander  Barry_Stander_4@yahoo.com      |
//|                http://www.4Africa.net/4meta/                                   |
//|                Float                                                           |
//+--------------------------------------------------------------------------------+
#property copyright "Float converted from MT3 to MT4"
#property link      "http://www.4Africa.net/4meta/"
#property link      "Data window added by cja"
//----
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 MidnightBlue
#property indicator_color2 Red
//----
extern int float1=50,use_fibos=0,Backtesting=0,from1=0;
string short_name;
//----
double f,c1,high_bar,Low_bar;
int bars_high,bars_low;
double cumulativeV,FLOATV,cumulativeV2,swing;
double newcv,CV,CV2;
double fib23,fib38,fib50,fib62,fib76;
double dinap0,dinap1,dinap2,dinap3,dinap4,dinap5;
double CVL,CVL1,CVL2,CVL3,CVL4;
double Buffer1[];
double Buffer2[];
//----
int shift,swing_time;
int cvstart,cvend,bar;
//+------------------------------------------------------------------+
//| delete_objects                                                   |
//+------------------------------------------------------------------+
void delete_objects()
  {
   string  buff_str="";
   for(int i=ObjectsTotal()-1;i>=0;i--)
     {
      buff_str=ObjectName(i);
      if(StringFind(buff_str,"float_",0)==0) ObjectDelete(buff_str);
     }
   Comment("");
  }
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(2);
   delete_objects();
//----
   short_name=("Float01 DATA");
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
//----
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,3);
   SetIndexBuffer(0,Buffer1);
//SetIndexDrawBegin(0,Buffer1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,Buffer2);
//SetIndexDrawBegin(1,Buffer2);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   delete_objects();
   return(0);
  }
//+------------------------------------------------------------------+
//| create_line                                                      |
//+------------------------------------------------------------------+
void create_line(int from,double p1,int to,double p2,color c,int style,int w=1)
  {
//   int size=Bars;
   int size=ArraySize(Buffer1);
   if(from>=size) return;
   if(to>=size) return;
   static int acc=0;
   string name="float_line_"+acc;acc++;
   datetime t0=Time[from];
   if(from<0) t0=Time[0]-from*Period()*60;
   datetime t1=Time[to];
   if(to<0) t1=Time[0]-to*Period()*60;
//----
   ObjectCreate(name,OBJ_TREND,0,t0,p1,t1,p2);
   ObjectSet(name,OBJPROP_STYLE,style);
   ObjectSet(name,OBJPROP_COLOR,c);
   ObjectSet(name,OBJPROP_RAY,0);
   ObjectSet(name,OBJPROP_WIDTH,w);
  }
//+------------------------------------------------------------------+
//| place_text                                                       |
//+------------------------------------------------------------------+
void place_text(string text,int from,double p,color c)
  {
   int size=ArraySize(Buffer1);
   if(from>=size) return;
   static int acc=0;
   string name="float_text_"+acc;acc++;
   ObjectCreate(name,OBJ_TEXT,0,Time[from],p);
   ObjectSetText(name,text,8,"Arial",c);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   static int last=0;
   if(last==Bars) return(0);

   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+from1;
//----
   delete_objects();
   cumulativeV=0;
   cumulativeV2=0;
   FLOATV=0;
//----
   bars_high=Highest(NULL,0,MODE_HIGH,float1,from1+1);
   bars_low =Lowest(NULL,0,MODE_LOW,float1,from1+1);
   high_bar=High[bars_high];
   Low_bar=Low[bars_low];
   swing=high_bar-Low_bar;
   swing_time=MathAbs(bars_low-bars_high);
   if(bars_high<bars_low)
     {
      cvstart=bars_low;
      cvend=bars_high;
     }
   else
     {
      cvstart=bars_high;
      cvend=bars_low;
     }

   for(shift=cvstart;shift>=cvend;shift--) FLOATV=FLOATV+Volume[shift];
//find cumulative volume since last turnover
   for(shift=cvstart;shift>=from1;shift--)
     {
      cumulativeV=cumulativeV+Volume[shift];
      if(cumulativeV>=FLOATV)cumulativeV=0;
      //----
      Buffer1[shift]=cumulativeV*0.001; //Blue
      Buffer2[shift]=FLOATV*0.001;      //Red
     }
// Float DATA window code
   double FirstValue=high_bar;//High bar Price
   double SecondValue=Low_bar;//Low bar Price
   double ThirdValue=bars_high*0.0001;//# of bars ago
   double ForthValue=bars_low*0.0001;//# of bars ago
   double FifthValue=FLOATV*0.0001;                       //Float volume 
   double SixthValue=swing_time; // Float Time was
   double SeventhValue=FLOATV*0.0001-cumulativeV*0.0001; //Float Vol left
   double EigthValue=float1; //float period
//----
   ObjectCreate("Flt",OBJ_LABEL,WindowFind("Float01 DATA"),0,0);
   ObjectSetText("Flt",DoubleToStr(FirstValue,Digits),18,"Arial",PaleTurquoise);
   ObjectSet("Flt",OBJPROP_CORNER,0);
   ObjectSet("Flt",OBJPROP_XDISTANCE,120);
   ObjectSet("Flt",OBJPROP_YDISTANCE,10);
   ObjectCreate("Flt2",OBJ_LABEL,WindowFind("Float01 DATA"),0,0);
   ObjectSetText("Flt2",DoubleToStr(SecondValue,Digits),18,"Arial",PaleTurquoise);
   ObjectSet("Flt2",OBJPROP_CORNER,0);
   ObjectSet("Flt2",OBJPROP_XDISTANCE,120);
   ObjectSet("Flt2",OBJPROP_YDISTANCE,35);
   ObjectCreate("Flt3",OBJ_LABEL,WindowFind("Float01 DATA"),0,0);
   ObjectSetText("Flt3","HIGH Bar   =",14,"tahoma",Yellow);
   ObjectSet("Flt3",OBJPROP_CORNER,0);
   ObjectSet("Flt3",OBJPROP_XDISTANCE,5);
   ObjectSet("Flt3",OBJPROP_YDISTANCE,12);
   ObjectCreate("Flt4",OBJ_LABEL,WindowFind("Float01 DATA"),0,0);
   ObjectSetText("Flt4","LOW Bar    =",14,"tahoma",Yellow);
   ObjectSet("Flt4",OBJPROP_CORNER,0);
   ObjectSet("Flt4",OBJPROP_XDISTANCE,5);
   ObjectSet("Flt4",OBJPROP_YDISTANCE,35);
   ObjectCreate("Flt5",OBJ_LABEL,WindowFind("Float01 DATA"),0,0);
   ObjectSetText("Flt5",DoubleToStr(ThirdValue,Digits),14,"Arial",Red);
   ObjectSet("Flt5",OBJPROP_CORNER,0);
   ObjectSet("Flt5",OBJPROP_XDISTANCE,220);
   ObjectSet("Flt5",OBJPROP_YDISTANCE,15);
   ObjectCreate("Flt6",OBJ_LABEL,WindowFind("Float01 DATA"),0,0);
   ObjectSetText("Flt6",DoubleToStr(ForthValue,Digits),14,"Arial",Red);
   ObjectSet("Flt6",OBJPROP_CORNER,0);
   ObjectSet("Flt6",OBJPROP_XDISTANCE,220);
   ObjectSet("Flt6",OBJPROP_YDISTANCE,35);
   ObjectCreate("Flt7",OBJ_LABEL,WindowFind("Float01 DATA"),0,0);
   ObjectSetText("Flt7","+",14,"Arial",CadetBlue);
   ObjectSet("Flt7",OBJPROP_CORNER,0);
   ObjectSet("Flt7",OBJPROP_XDISTANCE,200);
   ObjectSet("Flt7",OBJPROP_YDISTANCE,13);
   ObjectCreate("Flt8",OBJ_LABEL,WindowFind("Float01 DATA"),0,0);
   ObjectSetText("Flt8","+",14,"Arial",CadetBlue);
   ObjectSet("Flt8",OBJPROP_CORNER,0);
   ObjectSet("Flt8",OBJPROP_XDISTANCE,200);
   ObjectSet("Flt8",OBJPROP_YDISTANCE,33);
   ObjectCreate("Flt9",OBJ_LABEL,WindowFind("Float01 DATA"),0,0);
   ObjectSetText("Flt9",DoubleToStr(FifthValue,Digits),14,"Arial",Coral);
   ObjectSet("Flt9",OBJPROP_CORNER,0);
   ObjectSet("Flt9",OBJPROP_XDISTANCE,410);
   ObjectSet("Flt9",OBJPROP_YDISTANCE,40);
   ObjectCreate("Flt10",OBJ_LABEL,WindowFind("Float01 DATA"),0,0);
   ObjectSetText("Flt10","Float Volume   =",9,"tahoma",Turquoise);
   ObjectSet("Flt10",OBJPROP_CORNER,0);
   ObjectSet("Flt10",OBJPROP_XDISTANCE,300);
   ObjectSet("Flt10",OBJPROP_YDISTANCE,45);
   ObjectCreate("Flt11",OBJ_LABEL,WindowFind("Float01 DATA"),0,0);
   ObjectSetText("Flt11",DoubleToStr(SixthValue,Digits-4),14,"Arial",MediumPurple);
   ObjectSet("Flt11",OBJPROP_CORNER,0);
   ObjectSet("Flt11",OBJPROP_XDISTANCE,410);
   ObjectSet("Flt11",OBJPROP_YDISTANCE,10);
   ObjectCreate("Flt12",OBJ_LABEL,WindowFind("Float01 DATA"),0,0);
   ObjectSetText("Flt12","Bars",9,"tahoma",CadetBlue);
   ObjectSet("Flt12",OBJPROP_CORNER,0);
   ObjectSet("Flt12",OBJPROP_XDISTANCE,445);
   ObjectSet("Flt12",OBJPROP_YDISTANCE,15);
   ObjectCreate("Flt13",OBJ_LABEL,WindowFind("Float01 DATA"),0,0);
   ObjectSetText("Flt13","Float Time       =",9,"tahoma",Turquoise);
   ObjectSet("Flt13",OBJPROP_CORNER,0);
   ObjectSet("Flt13",OBJPROP_XDISTANCE,300);
   ObjectSet("Flt13",OBJPROP_YDISTANCE,15);
   ObjectCreate("Flt14",OBJ_LABEL,WindowFind("Float01 DATA"),0,0);
   ObjectSetText("Flt14",DoubleToStr(SeventhValue,Digits),14,"Arial",Coral);
   ObjectSet("Flt14",OBJPROP_CORNER,0);
   ObjectSet("Flt14",OBJPROP_XDISTANCE,410);
   ObjectSet("Flt14",OBJPROP_YDISTANCE,25);
   ObjectCreate("Flt15",OBJ_LABEL,WindowFind("Float01 DATA"),0,0);
   ObjectSetText("Flt15","Float Vol left    =",9,"tahoma",Turquoise);
   ObjectSet("Flt15",OBJPROP_CORNER,0);
   ObjectSet("Flt15",OBJPROP_XDISTANCE,300);
   ObjectSet("Flt15",OBJPROP_YDISTANCE,30);
   ObjectCreate("Flt16",OBJ_LABEL,WindowFind("Float01 DATA"),0,0);
   ObjectSetText("Flt16","Float Period",9,"tahoma",Turquoise);
   ObjectSet("Flt16",OBJPROP_CORNER,0);
   ObjectSet("Flt16",OBJPROP_XDISTANCE,790);
   ObjectSet("Flt16",OBJPROP_YDISTANCE,10);
   ObjectCreate("Flt17",OBJ_LABEL,WindowFind("Float01 DATA"),0,0);
   ObjectSetText("Flt17",DoubleToStr(EigthValue,Digits-4),14,"Arial",Coral);
   ObjectSet("Flt17",OBJPROP_CORNER,0);
   ObjectSet("Flt17",OBJPROP_XDISTANCE,866);
   ObjectSet("Flt17",OBJPROP_YDISTANCE,8);
//End Float DATA window code
   create_line(cvstart,high_bar,from1+1,high_bar,Blue,STYLE_SOLID);
//  place_text("100.0",from+1,high_bar,Green); //100 fib level           
   create_line(cvstart,Low_bar,from1+1,Low_bar,Blue,STYLE_SOLID);
//  place_text("00.0",from+1,Low_bar,Green);  //0.00 fib level         
//  fib23=((high_bar-Low_bar)*0.236)+Low_bar;
//  fib38=((high_bar-Low_bar)*0.382)+Low_bar;
//  fib50=((high_bar-Low_bar)/2)+Low_bar;
//  fib62=((high_bar-Low_bar)*0.618)+Low_bar;
//  fib76=((high_bar-Low_bar)*0.764)+Low_bar;
//  dinap0=(Low_bar+fib23)/2;
//  dinap1=(fib23+fib38)/2;
//  dinap2=(fib38+fib50)/2;
//  dinap3=(fib50+fib62)/2;
//  dinap4=(fib62+fib76)/2;
//  dinap5=(high_bar+fib76)/2;
   create_line(cvstart,fib23,from1+1,fib23,Green,STYLE_DASHDOTDOT);
   place_text("23.6",from1+1,fib23,Green);
   create_line(cvstart,fib38,from1+1,fib38,Green,STYLE_DASHDOTDOT);
   place_text("38.2",from1+1,fib38,Green);
   create_line(cvstart,fib50,from1+1,fib50,Red,STYLE_DASHDOTDOT,1);
   place_text("50.0",from1+1,fib50,Red);
   create_line(cvstart,fib62,from1+1,fib62,Green,STYLE_DASHDOTDOT);
   place_text("61.8",from1+1,fib62,Green);
   create_line(cvstart,fib76,from1+1,fib76,Green,STYLE_DASHDOTDOT);
   place_text("76.4",from1+1,fib76,Green);
//----
   create_line(cvstart,dinap0,from1+1,dinap0,MidnightBlue,STYLE_DOT);
   create_line(cvstart,dinap1,from1+1,dinap1,MidnightBlue,STYLE_DOT);
   create_line(cvstart,dinap2,from1+1,dinap2,MidnightBlue,STYLE_DOT);
   create_line(cvstart,dinap3,from1+1,dinap3,MidnightBlue,STYLE_DOT);
   create_line(cvstart,dinap4,from1+1,dinap4,MidnightBlue,STYLE_DOT);
   create_line(cvstart,dinap5,from1+1,dinap5,MidnightBlue,STYLE_DOT);
   create_line(cvstart,high_bar,cvstart,Low_bar*Point,Blue,STYLE_SOLID);
   create_line(cvend,high_bar,cvend,Low_bar*Point,Red,STYLE_SOLID);
//vert float predictions. These are only time based.
//see blue histogram for real float values.
//if you change "trendline" to "Vline" it will draw through oscillators too.might be fun
   for(int i=1;i<10;i++)
     {
      int x=cvend-(swing_time*i);
      create_line(x+5,high_bar,x+5,Low_bar,DarkSlateGray,STYLE_DOT);
     }
//  Comment(
//  "\n","high was   ",bars_high,"  bars ago",
//  "\n","Low was    ",bars_low," bars ago","\n",
//  "\n","Float time was  =   ",swing_time," bars",
//  "\n","Float Vol. left =   ",FLOATV-cumulativeV,
//  "\n","Float Volume    =   ",FLOATV,
//  );
//----
   return(0);
  }
//+------------------------------------------------------------------+
